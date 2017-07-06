rnssync
=======

This is a personal project and probably won't be supported very well, so explore at risk of your own patience. 
The purpose is to take a completed soundtrack for a game, written in Renoise, export its note data (instrument timing, instrument ID, pitch and volume) through a LUA script, load it into a game client and process it as a stream plays, letting the game respond to its soundtrack *in detail* quite simply rather than based on some latency-heavy DSP. 

My primary use case is the use of music as a clock and even as level scripting for a time-sensitive game, such as a shoot'em up. "Silent" notes could be used to signify specific events, triggering enemy spawns and the like. This should make for some nice audio drama. Another use could be for visualizer effects for concerts and the like.

A quick and dirty Flash demo exist [here](http://doomsday.no/dev/toys/sync).

Source is in Haxe and C#/Unity and behaves identically.

## Unity example

	using com.furusystems.renoise;
	using com.furusystems.renoise.data;

	public class SyncTest : MonoBehaviour {
		List<NoteEvent> NoteEvents;
		public TextAsset Data;
		public AudioSource Music;
		void Start()
		{
			NoteEvents = new List<NoteEvent>();
			var song = Parser.parse(Data.text);
	
			Music.Play(); //Start music and playback "together"
			Playback.start(song);
		}
		
		void Update () {
			NoteEvents = Playback.syncSong(Music.time); //Poll the playback for note events based on the music's time
			foreach (var e in NoteEvents)
			{
				if (e.instrument.index == 9) 
				{
					//In this case we know the renoise instrument indexed at 9 is a kickdrum for instance
				}
			}
		}
	}
