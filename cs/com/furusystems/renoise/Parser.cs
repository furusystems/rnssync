using com.furusystems.renoise.data;
using System.Collections.Generic;

namespace com.furusystems.renoise{
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	class Parser 
	{
	
		const string INFO = "INFO";
		const string NOTE = "NOTE";
		const string TRACK = "TRACK";
		const string INSTR = "INSTR";
		const string TITLE = "title";
		const string BPM = "bpm";
		const string LPB = "lpb";
	
		static public Song parse(string data) {
			var s = new Song();
			var lines = data.Split('\n');
			foreach (string l in lines) 
			{
				parseLine(l, s);
			}
			foreach (Instrument i in s.instruments) {
				rangeInstrument(i);
			}
			return s;
		}
	
		static void rangeInstrument(Instrument instrument)
		{
			int l = 256;
			int h = -256;
			foreach (NoteEvent e in instrument.events) {
				if (e.note < l) {
					l = e.note;
				}
				if (e.note > h) {
					h = e.note;
				}
			}
			for (int i = 0; i < instrument.events.Count; i++)
			{
				var e = instrument.events[i];
				if (l == h || h - l == 0) e.normalizedNote = 1;
				else e.normalizedNote = (e.note - l) / (h - l);
			}
		}
	
		static void parseLine(string line, Song s) {
			if (line.IndexOf("//") > -1) return;
			var split = line.Split(':');
			switch(split[0]) {
				case INFO:
					parseInfo(split[1], s);
					break;
				case NOTE:
					parseNote(split[1], s);
					break;
				case TRACK:
					parseTrack(split[1], s);
					break;
				case INSTR:
					parseInstr(split[1], s);
					break;
			}
		}

		static void parseInstr(string data, Song s)
		{
			var split = data.Split('|');
			var i = new Instrument(int.Parse(split[0]), split[1]);
			s.instruments.Insert(i.index, i);
		}

		static void parseTrack(string data, Song s)
		{
			var split = data.Split('|');
			var t = new Track(int.Parse(split[0]), split[1]);
			s.tracks.Insert(t.index, t);
		}
	
		static void parseNote(string data, Song s) {
			var n = new NoteEvent();
			var split = data.Split('|');
			n.track = s.getTrack(int.Parse(split[0]));
			n.instrument = s.getInstrument(int.Parse(split[1]));
			n.time = float.Parse(split[2]);
			n.note = int.Parse(split[3]);
			n.volume = int.Parse(split[4]);
		
			n.track.events.Add(n);
			n.instrument.events.Add(n);
			s.events.Add(n);
		}
	
		static void parseInfo(string data, Song s) {
			var split = data.Split('|');
			switch(split[0].ToLower()) {
				case TITLE:
					s.title = split[1];
					break;
				case BPM:
					s.bpm = int.Parse(split[1]);
					break;
				case LPB:
					s.lpb = int.Parse(split[1]); 
					break;
			}
		}
	}
}