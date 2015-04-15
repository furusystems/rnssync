using System.Collections.Generic;
namespace com.furusystems.renoise.data
{
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public struct Instrument 
	{
		public int index;
		public string name;
		public List<NoteEvent> events;
		public Instrument(int index, string name) {
			this.index = index;
			this.name = name;
			events = new List<NoteEvent>();
		}
	}
}