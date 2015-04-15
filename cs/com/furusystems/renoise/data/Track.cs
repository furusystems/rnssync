using System.Collections.Generic;
namespace com.furusystems.renoise.data
{
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public struct Track 
	{
		public int index;
		public string name;
		public List<NoteEvent> events;
		public Track(int index, string name) {
			this.name = name;
			this.index = index;
			events = new List<NoteEvent>();
		}
	}
}