using com.furusystems.renoise.data;
using System.Collections.Generic;
namespace com.furusystems.renoise
{

	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public class Playback 
	{
		static public Song currentSong;
		static public float time;
		static List<NoteEvent> _noteEventBuffer;	
		static int _lastTriggeredEventIndex = -1;
		static public void start(Song s = null) {
			if (s == null) s = currentSong;
			currentSong = s;
			resetSong();
			time = 0;
			_noteEventBuffer = new List<NoteEvent>();
		}
	
		static public void resetSong(Song s = null) {
			_lastTriggeredEventIndex = 0;
			if (s == null) s = currentSong;
			if (s != null) {
				for (int i = 0; i < s.events.Count; i++)
				{
					NoteEvent e = s.events[i];
					e.hasTriggered = false;
				}
			}
		}
	
		static void getEvents(List<NoteEvent> events, float time) {
			_noteEventBuffer.Clear();
			for (var i = _lastTriggeredEventIndex; i<events.Count; i++) {
				NoteEvent evt = events[i];
				if (evt.hasTriggered) continue;
				if (evt.time <= time){
					evt.hasTriggered = true;
					_noteEventBuffer.Add(evt);
				}else {
					_lastTriggeredEventIndex = i;
					break;
				}
			}
		}
	
		static public List<NoteEvent> syncSong(float newTime) {
			getEvents(currentSong.events, newTime);
			return _noteEventBuffer;
		}
		static public List<NoteEvent> syncTrack(Track track, float newTime) {
			getEvents(track.events, newTime);
			return _noteEventBuffer;
		}
		static public List<NoteEvent> syncInstrument(Instrument instrument, float newTime) {
			getEvents(instrument.events, newTime);
			return _noteEventBuffer;
		}
	}
}