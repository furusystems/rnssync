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
		trace("Parsing..");
		var lines = data.split("\n");
		for (i in 0...lines.length) 
		{
			parseLine(lines[i], out);
		}
		trace("Complete!");
		return out;
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
		trace("Created instrument: " + i);
		out.instruments[i.index] = i;
	}
	
	static function parseTrack(data:String, out:Song):Void {
		var t = new Track();
		var split = data.split("|");
		t.index = Std.parseInt(split[0]);
		t.name = split[1];
		trace("Created track: " + t);
		out.tracks[t.index] = t;
	}
	
	static function parseNote(data:String, out:Song):Void {
		//track number|instrument number|seconds|MIDI note value (google it)|volume value,...
		var n = new NoteEvent();
		var split = data.split("|");
		n.track = out.getTrack(Std.parseInt(split[0]));
		n.track.events.push(n);
		n.instrument = out.getInstrument(Std.parseInt(split[1]));
		n.instrument.events.push(n);
		n.time = Std.parseFloat(split[2]);
		n.note = Std.parseInt(split[3]);
		n.volume = Std.parseInt(split[4]);
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