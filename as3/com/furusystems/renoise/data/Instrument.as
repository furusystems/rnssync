package com.furusystems.renoise.data 
{
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public class Instrument 
	{
		public var index:int;
		public var name:String;
		public var events:Vector.<NoteEvent> = new Vector.<NoteEvent>();
		public function Instrument() 
		{
			
		}
		public function toString():String 
		{
			return "[Instrument index=" + index + " name=" + name+"]";
		}
		
	}

}