renoise.tool():add_menu_entry {
  name = "Main Menu:File:DataExport",
  invoke = function() 
    showGUI();
    -- execute() 
  end
}

local selectedInstruments = "";

function stringSplit(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        local i=1
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                t[i] = str
                i = i + 1
        end
        return t
end

local function show_status(message)
  renoise.app():show_status(message)
  print(message)
end

function showGUI()
 -- Beside of texts, controls and backgrounds and so on, the viewbuilder also
  -- offers some helper views which will help you to 'align' and stack views.

  -- lets start by creating a view builder again:
  local vb = renoise.ViewBuilder()

  -- now we are going to use a "column" view. a column can do three things:
  -- 1. showing a background (if you don't want your views on the plain dialogs
  --    back)
  -- 2. "stack" other views (its child views) either vertically, or horizontally
  --    vertically = vb:column{}
  --    horizontally = vb:row{}
  -- 3. align child views via "margins" -> borders for nested views

  -- lets use all of this in a bit more complicated hello world view:

  local dialog_title = "NoteExport"
  local dialog_buttons = {"Ok", "Cancel"};

  -- get some consts to let the dialog look like Renoises default views...
  local DEFAULT_MARGIN = renoise.ViewBuilder.DEFAULT_CONTROL_MARGIN

  -- start with a 'column' to stack other views vertically:
  local dialog_content = vb:column {
    -- set a border of DEFAULT_MARGIN around our main content
    margin = DEFAULT_MARGIN,

    -- and create another column to align our text in a different background
    vb:column {
      -- background that is usually used for "groups"
      style = "group",
      -- add again some "borders" to make it more pretty
      margin = DEFAULT_MARGIN,

      -- now add the first text into the inner column
      vb:textfield {
        width = 320,
        text = "Instrument numbers here",
        notifier = function(text)
            show_status(("textfield value changed to '%s'"):format(text))
            config(text)
          end
      }
    }
  }

  local pushedButton = renoise.app():show_custom_prompt(
    dialog_title, dialog_content, dialog_buttons)
  
  if(pushedButton=="Ok") then
    execute(parse(selectedInstruments));
  end  
end

function parse(str)
  if(str=="")then return nil end;
  local t = stringSplit(str, " ")
  for key, value in pairs(t) do
    t[key] = tonumber(value)
  end
  return t
end

function config(input)
  print("Config: "..input);
  selectedInstruments = input;
end

-- function to check if a value exists in a table/array.
-- it's retarded that lua doesn't have this built in.
function in_table(item, table)
  for key, value in pairs(table) do
    if value == item then 
      return true
    end
  end
  return false
end

function allInstruments()
  local t = {};
  local idx = 0;
  for key, value in pairs(renoise.song().instruments) do
    t[idx] = key-1;
    idx = idx + 1;
  end
  return t
end

function execute(instruments_to_detect)
  if(instruments_to_detect == nil) then instruments_to_detect = allInstruments() end
  local dbg = "Tracking instruments: ";
  for key, value in pairs(instruments_to_detect) do
    dbg = dbg..value..","
  end
  print(dbg)
  local outputStr = "";
  local song = renoise.song()
  local transport = song.transport
  local bpm = transport.bpm
  local lpb = transport.lpb
  local spl = (60 / bpm) / lpb
  local sequence = song.sequencer.pattern_sequence
  local num_tracks = #song.tracks
  local num_patterns = #sequence
  local line_count = 0
  local output = {}
  
  -- pattern sequence loop
  for p = 1, num_patterns do
  
    local pattern = song:pattern(sequence[p])  
    local num_lines = pattern.number_of_lines
  
    -- pattern line loop
    for l = 1, num_lines do
    
      local seconds = line_count * spl
      -- track loop   
      for t = 1, num_tracks do
      
        local track = song:track(t)
        local num_columns = track.visible_note_columns
        local pattern_track = pattern:track(t)
        local line = pattern_track:line(l)
        if(t == num_tracks) then break end
        if(not renoise.song().sequencer:track_sequence_slot_is_muted(t, p)) then
			-- note column loop
			for c = 1, num_columns do
			  
			  local column = line:note_column(c)
			  
			  -- if we found a note...
			  if (not column.is_empty) then
			  
				-- if it's not a note off...
				if (column.note_value ~= renoise.PatternTrackLine.NOTE_OFF) then
				
				  local instrument = column.instrument_value
				  
				  if (in_table(instrument, instruments_to_detect)) then
								
					local note = column.note_value
					local volume = column.volume_value
				  
					outputStr = outputStr.."NOTE:"..(t-1).."|"..instrument.."|"..seconds.."|"..note.."|"..volume.."\n";
				  
				  end -- end detected instrument check
				
				end -- end note off check
				
			  end -- end empty column check
			  
			end -- end note column loop
        end -- end track sequence slot test
      end -- end track loop
      
      line_count = line_count + 1
      
    end -- end pattern line loop
    
  end -- end pattern sequence loop
  
  local final = "";
  
  final = final..("//Song info\n");
  final = final..printInfo();
  final = final..("//Track ID table\n")
  final = final..printTracks();
  
  final = final..("//Instrument ID table\n")
  final = final..printInstruments();
  
  final = final..("//Playback data: track number|instrument number|seconds|MIDI note value (google it)|volume value,...\n");
  final = final..outputStr;
  print(final);
end

function printInfo()
  local out = "INFO:Title|"..renoise.song().name.."\n";
  out = out.."INFO:BPM|"..renoise.song().transport.bpm.."\n";
  out = out.."INFO:LPB|"..renoise.song().transport.lpb.."\n";
  return out;
end

function printTracks()
  local out = "";
  for key, value in pairs(renoise.song().tracks) do
    out = out.. "TRACK:"..(key-1).."|"..value.name.."\n"
  end
  return out;
end

function printInstruments()
  local out = "";
  for key, value in pairs(renoise.song().instruments) do
    local n = value.name;
    if(n=="") then n = "Unnamed" end
    out = out.."INSTR:"..(key-1).."|"..n.."\n"
  end
  return out;
end

