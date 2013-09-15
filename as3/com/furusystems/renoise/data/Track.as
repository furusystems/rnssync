package com.furusystems.renoise.data 
{
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public class Track 
	{
		public var index:int;
		public var name:String;
		public var events:Vector.<NoteEvent> = new Vector.<NoteEvent>();
		public function Track() 
		{
			
		}
		public function toString():String 
		{
			return "[Track index=" + index + " name=" + name + "]";
		}
		
	}

}