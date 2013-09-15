rnssync
=======

This is a personal project and probably won't be supported very well, so explore at risk of your own patience. 
The purpose is to take a completed soundtrack for a game, written in Renoise, export its note data (instrument timing, instrument ID, pitch and volume) through a LUA script, load it into a game client and process it as a stream plays, letting the game respond to its soundtrack *in detail* quite simply rather than based on some latency-heavy DSP. 

My primary use case is the use of music as a clock and even as level scripting for a time-sensitive game, such as a shoot'em up. "Silent" notes could be used to signify specific events, triggering enemy spawns and the like. This should make for some nice audio drama. Another use could be for visualizer effects for concerts and the like.
