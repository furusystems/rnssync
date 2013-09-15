package com.furusystems.renoise.data 
{
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public class Song 
	{
		public var title:String;
		public var bpm:int;
		public var lpb:int;
		public var instruments:Vector.<Instrument> = new Vector.<Instrument>();
		public var tracks:Vector.<Track> = new Vector.<Track>();
		public var events:Vector.<NoteEvent> = new Vector.<NoteEvent>();
		public function Song() 
		{
			
		}
		
		public function getTrack(idx:int):Track 
		{
			for each(var t:Track in tracks) {
				if (t.index == idx) return t;
			}
			return null;
		}
		public function getInstrument(idx:int):Instrument {
			for each(var i:Instrument in instruments) {
				if (i.index == idx) return i;
			}
			return null;
		}
		
		public function toString():String 
		{
			return "[Song title=" + title + " bpm=" + bpm + " lpb=" + lpb + " instruments=" + instruments + " tracks=" + tracks + 
						" events=" + events + "]";
		}
		
	}

}