/*

	Placeholder for something more elaborate, such as soundscapes being specific spots in the
	maps 

*/
/datum/subsystem/soundscape
	name = "Soundscape"
	wait = 1 SECOND
	priority = SS_PRIORITY_SOUNDSCAPE
	var/list/currentrun = list()

/datum/subsystem/soundscape/fire(resumed = FALSE)
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
