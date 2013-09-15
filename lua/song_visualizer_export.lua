local song = renoise.song()
local transport = song.transport
local bpm = transport.bpm
local lpb = transport.lpb
local spl = (60 / bpm) / lpb
local sequence = song.sequencer.pattern_sequence
local num_tracks = #song.tracks
local num_patterns = #sequence
local line_count = 0
local instruments_to_detect = { 0, 1, 2 }
local output = {}

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
            
              print('Line', line_count, '| Sec', seconds, '| Track', t, '| Instr', instrument, '| Note', note, '| Vol', volume)
            
            end -- end detected instrument check
          
          end -- end note off check
          
        end -- end empty column check
        
      end -- end note column loop
        
    end -- end track loop
    
    line_count = line_count + 1
    
  end -- end pattern line loop
  
end -- end pattern sequence loop
