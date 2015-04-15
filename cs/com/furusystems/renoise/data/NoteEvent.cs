namespace com.furusystems.renoise.data
{
	/**
	 * ...
	 * @author Andreas Rønning
	 */
	public struct NoteEvent 
	{
		public Instrument instrument;
		public Track track;
		public int note;
		public float normalizedNote;
		public int volume;
		public float time;
		public bool hasTriggered;
	}

}