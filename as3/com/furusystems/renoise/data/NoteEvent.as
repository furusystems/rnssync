package com.furusystems.renoise.data 
{
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public class NoteEvent 
	{
		public var instrument:Instrument;
		public var track:Track;
		public var note:int;
		public var volume:int;
		public var time:Number;
		public function NoteEvent() 
		{
			
		}
		public function toString():String 
		{
			return "[NoteEvent instrument=" + instrument + " track=" + track + " note=" + note + " volume=" + volume + 
						" time=" + time + "]";
		}
		
	}

}