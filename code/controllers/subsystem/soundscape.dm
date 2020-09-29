/*

	Placeholder for something more elaborate, such as soundscapes being specific spots in the
	maps 

*/
SUBSYSTEM_DEF(soundscape)
	name = "Soundscape"
	wait = 1 SECOND
	priority = SS_PRIORITY_SOUNDSCAPE
	var/list/currentrun = list()
	flags = SS_NO_INIT

/datum/controller/subsystem/soundscape/fire(resumed = FALSE)
	if(!resumed)
		currentrun = clients.Copy()
	
	while(currentrun.len)
		var/client/C = currentrun[currentrun.len]
		currentrun.len--
		
		if(!C || !C.soundOutput)
			continue

		C.soundOutput.update_soundscape()

		if(MC_TICK_CHECK)
			return
