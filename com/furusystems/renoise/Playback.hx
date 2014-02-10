package com.furusystems.renoise;
import com.furusystems.renoise.data.Instrument;
import com.furusystems.renoise.data.NoteEvent;
import com.furusystems.renoise.data.Song;
import com.furusystems.renoise.data.Track;
/**
 * ...
 * @author Andreas Rønning
 */
class Playback 
{
	static public var currentSong:Null<Song>;
	static public var time:Float;
	static var _noteEventBuffer:Null<List<NoteEvent>>;	
	static public function start(?s:Song):Void {
		if (s == null) s = currentSong;
		currentSong = s;
		resetSong();
		time = 0;
		_noteEventBuffer = new List<NoteEvent>();
	}
	
	static public function resetSong(?s:Song):Void {
		if (s == null) s = currentSong;
		if (s != null) {
			for (i in 0...s.events.length) {
				s.events[i].hasTriggered = false;
			}
		}
	}
	
	static inline function getEvents(events:Array<NoteEvent>, time:Float):Void {
		_noteEventBuffer.clear();
		for (i in 0...events.length) {
			var evt:NoteEvent = events[i];
			if (evt.hasTriggered) continue;
			if (evt.time <= time){
				evt.hasTriggered = true;
				_noteEventBuffer.add(evt);
			}
		}
	}
	
	static public function syncSong(newTime:Float):List<NoteEvent> {
		getEvents(currentSong.events, newTime);
		return _noteEventBuffer;
	}
	static public function syncTrack(track:Track, newTime:Float):List<NoteEvent> {
		getEvents(track.events, newTime);
		return _noteEventBuffer;
	}
	static public function syncInstrument(instrument:Instrument, newTime:Float):List<NoteEvent> {
		getEvents(instrument.events, newTime);
		return _noteEventBuffer;
	}
}