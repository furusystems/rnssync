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
	public function new() 
	{
		events = new Array<NoteEvent>();
		tracks = new Array<Track>();
		instruments = new Array<Instrument>();
	}
	
	public function getTrack(idx:Int):Track 
	{
		for(t in tracks) {
			if (t.index == idx) return t;
		}
		return null;
	}
	public function getInstrument(idx:Int):Instrument {
		for(i in instruments) {
			if (i.index == idx) return i;
		}
		return null;
	}
	
	public function toString():String 
	{
		return "[Song title=" + title + " bpm=" + bpm + " lpb=" + lpb + " instruments=" + instruments + " tracks=" + tracks + " events=" + events + "]";
	}
	
}