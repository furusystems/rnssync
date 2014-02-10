package com.furusystems.renoise;
import com.furusystems.renoise.data.Instrument;
import com.furusystems.renoise.data.NoteEvent;
import com.furusystems.renoise.data.Song;
import com.furusystems.renoise.data.Track;
/**
 * ...
 * @author Andreas Rønning
 */
class Parser 
{
	
	static inline var INFO = "INFO";
	static inline var NOTE = "NOTE";
	static inline var TRACK = "TRACK";
	static inline var INSTR = "INSTR";
	static inline var TITLE = "title";
	static inline var BPM = "bpm";
	static inline var LPB = "lpb";
	
	static public function parse(data:String):Song {
		var out = new Song();
		var lines = data.split("\n");
		for (i in 0...lines.length) 
		{
			parseLine(lines[i], out);
		}
		for (i in out.instruments) {
			rangeInstrument(i);
		}
		#if debug
		for (instr in out.instruments) {
			trace(instr.name+", "+instr.events.length);
		}
		#end
		return out;
	}
	
	static function rangeInstrument(i:Instrument):Void
	{
		var l:Int = 256;
		var h:Int = -256;
		for (e in i.events) {
			if (e.note < l) {
				l = e.note;
			}
			if (e.note > h) {
				h = e.note;
			}
		}
		for (e in i.events) {
			if (l == h || h - l == 0) e.normalizedNote = 1;
			else e.normalizedNote = (e.note-l) / (h - l);
		}
	}
	
	static function parseLine(line:String, out:Song):Void {
		if (line.indexOf("//") > -1) return;
		var split = line.split(":");
		switch(split[0]) {
			case INFO:
				parseInfo(split[1], out);
			case NOTE:
				parseNote(split[1], out);
			case TRACK:
				parseTrack(split[1], out);
			case INSTR:
				parseInstr(split[1], out);
		}
	}
	
	static function parseInstr(data:String, out:Song):Void {
		var i = new Instrument();
		var split = data.split("|");
		i.index = Std.parseInt(split[0]);
		i.name = split[1];
		out.instruments[i.index] = i;
	}
	
	static function parseTrack(data:String, out:Song):Void {
		var t = new Track();
		var split = data.split("|");
		t.index = Std.parseInt(split[0]);
		t.name = split[1];
		out.tracks[t.index] = t;
	}
	
	static function parseNote(data:String, out:Song):Void {
		var n = new NoteEvent();
		var split = data.split("|");
		n.track = out.getTrack(Std.parseInt(split[0]));
		n.instrument = out.getInstrument(Std.parseInt(split[1]));
		n.time = Std.parseFloat(split[2]);
		n.note = Std.parseInt(split[3]);
		n.volume = Std.parseInt(split[4]);
		
		n.track.events.push(n);
		n.instrument.events.push(n);
		out.events.push(n);
	}
	
	static function parseInfo(data:String, out:Song):Void {
		var split = data.split("|");
		switch(split[0].toLowerCase()) {
			case TITLE:
				out.title = split[1];
			case BPM:
				out.bpm = Std.parseInt(split[1]);
			case LPB:
				out.lpb = Std.parseInt(split[1]); 
		}
	}
	
}