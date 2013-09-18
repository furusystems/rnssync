package com.furusystems.renoise.data;
/**
 * ...
 * @author Andreas Rønning
 */
class NoteEvent 
{
	public var instrument:Instrument;
	public var track:Track;
	public var note:Int;
	public var normalizedNote:Float;
	public var volume:Int;
	public var time:Float;
	public var hasTriggered:Bool;
	public function new() {
		
	}
	public function toString():String {
		return "[NoteEvent instrument=" + instrument + " track=" + track + " note=" + note + " volume=" + volume + " time=" + time + "]";
	}
	
}