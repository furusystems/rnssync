using System.Collections.Generic;
using com.furusystems.renoise.data;
namespace com.furusystems.renoise
{
	public class Song 
	{
		public string title;
		public int bpm;
		public int lpb;
		public List<Instrument> instruments;
		public List<Track> tracks;
		public List<NoteEvent> events;
		public Song() {
			events = new List<NoteEvent>();
			tracks = new List<Track>();
			instruments = new List<Instrument>();
		}
	
		public Track getTrack(int idx){
			return tracks[idx];
		}
		public Instrument getInstrument(int idx){
			return instruments[idx];
		}
		public override string ToString()
		{
			return "[Song=" + title + ", instruments="+instruments.Count + "]";
		}

	}
}