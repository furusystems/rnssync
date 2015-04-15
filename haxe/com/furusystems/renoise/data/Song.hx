package com.furusystems.renoise.data;
/**
 * ...
 * @author Andreas Rønning
 */
class Song 
{
	public var title:String;
	public var bpm:Int;
	public var lpb:Int;
	public var instruments:Array<Instrument>;
	public var tracks:Array<Track>;
	public var events:Array<NoteEvent>;
	public function new() {
		events = new Array<NoteEvent>();
		tracks = new Array<Track>();
		instruments = new Array<Instrument>();
	}
	
	public inline function getTrack(idx:Int):Track {
		return tracks[idx];
	}
	public inline function getInstrument(idx:Int):Instrument {
		return instruments[idx];
	}
	
	public function toString():String {
		return "[Song title=" + title + " bpm=" + bpm + " lpb=" + lpb + " instruments=" + instruments + " tracks=" + tracks + " events=" + events + "]";
	}
	
}