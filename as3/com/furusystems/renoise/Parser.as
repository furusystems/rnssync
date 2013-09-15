package com.furusystems.renoise 
{
	import com.furusystems.renoise.data.Instrument;
	import com.furusystems.renoise.data.NoteEvent;
	import com.furusystems.renoise.data.Song;
	import com.furusystems.renoise.data.Track;
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public class Parser 
	{
		public static function parse(data:String):Song {
			var out:Song = new Song();
			trace("Parsing..");
			var lines:Array = data.split("\n");
			for (var i:int = 0; i < lines.length; i++) 
			{
				parseLine(lines[i], out);
			}
			trace("Parsed!");
			
			return out;
		}
		
		static private function parseLine(line:String, out:Song):void 
		{
			if (line.indexOf("//") > -1) return;
			var split:Array = line.split(":");
			switch(split[0]) {
				case "INFO":
					parseInfo(split[1], out);
					break;
				case "NOTE":
					parseNote(split[1], out);
					break;
				case "TRACK":
					parseTrack(split[1], out);
					break;
				case "INSTR":
					parseInstr(split[1], out);
					break;
			}
		}
		
		static private function parseInstr(data:String, out:Song):void 
		{
			var i:Instrument = new Instrument();
			var split:Array = data.split("|");
			i.index = parseInt(split[0]);
			i.name = split[1];
			trace("Created instrument: " + i);
			out.instruments.push(i);
		}
		
		static private function parseTrack(data:String, out:Song):void 
		{
			var t:Track = new Track();
			var split:Array = data.split("|");
			t.index = parseInt(split[0]);
			t.name = split[1];
			trace("Created track: " + t);
			out.tracks.push(t);
		}
		
		static private function parseNote(data:String, out:Song):void 
		{
			//track number|instrument number|seconds|MIDI note value (google it)|volume value,...
			var n:NoteEvent = new NoteEvent();
			var split:Array = data.split("|");
			n.track = out.getTrack(parseInt(split[0]));
			n.track.events.push(n);
			n.instrument = out.getInstrument(parseInt(split[1]));
			n.instrument.events.push(n);
			n.time = parseFloat(split[2]);
			n.note = parseInt(split[3]);
			n.volume = parseInt(split[4]);
			out.events.push(n);
		}
		
		static private function parseInfo(data:String, out:Song):void 
		{
			var split:Array = data.split("|");
			switch(split[0].toLowerCase()) {
				case "title":
					out.title = split[1];
					break;
				case "bpm":
					out.bpm = parseInt(split[1]);
					break;
				case "lpb":
					out.lpb = parseInt(split[1]); 
					break;
			}
		}
		
	}

}