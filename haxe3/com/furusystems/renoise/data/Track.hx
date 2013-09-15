package com.furusystems.renoise.data;
/**
 * ...
 * @author Andreas Rønning
 */
class Track 
{
	public var index:Int;
	public var name:String;
	public var events:Array<NoteEvent>;
	public function new() 
	{
		events = new Array<NoteEvent>();
	}
	public function toString():String 
	{
		return "[Track index=" + index + " name=" + name + "]";
	}
	
}