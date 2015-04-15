package com.furusystems.renoise;
import com.furusystems.renoise.data.*;
/**
 * ...
 * @author Andreas Rønning
 */
class Playback 
{
	static public var currentSong:Null<Song>;
	static public var time:Float;
	static var _noteEventBuffer:Null<List<NoteEvent>>;	
	static var _lastTriggeredEventIndex:Int = -1;
	static public function start(?s:Song):Void {
		if (s == null) s = currentSong;
		currentSong = s;
		resetSong();
		time = 0;
		_noteEventBuffer = new List<NoteEvent>();
	}
	
	static public function resetSong(?s:Song):Void {
		_lastTriggeredEventIndex = 0;
		if (s == null) s = currentSong;
		if (s != null) {
			for (i in 0...s.events.length) {
				s.events[i].hasTriggered = false;
			}
		}
	}
	
	static function getEvents(events:Array<NoteEvent>, time:Float):Void {
		_noteEventBuffer.clear();
		for (i in _lastTriggeredEventIndex...events.length) {
			var evt:NoteEvent = events[i];
			if (evt.hasTriggered) continue;
			if (evt.time <= time){
				evt.hasTriggered = true;
				_noteEventBuffer.add(evt);
			}else {
				_lastTriggeredEventIndex = i;
				break;
			}
		}
	}
	
	static public inline function syncSong(newTime:Float):List<NoteEvent> {
		getEvents(currentSong.events, newTime);
		return _noteEventBuffer;
	}
	static public inline function syncTrack(track:Track, newTime:Float):List<NoteEvent> {
		getEvents(track.events, newTime);
		return _noteEventBuffer;
	}
	static public inline function syncInstrument(instrument:Instrument, newTime:Float):List<NoteEvent> {
		getEvents(instrument.events, newTime);
		return _noteEventBuffer;
	}
}