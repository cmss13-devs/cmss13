var/datum/subsystem/global_sound/SSglobal_sound

/datum/subsystem/global_sound
	name          = "Global Sound"
	wait          = 1 SECONDS
	priority      = SS_PRIORITY_GLOBAL_SOUND

	var/list/soundlen_map = list()
	var/list/currentrun

/datum/subsystem/global_sound/New()
	NEW_SS_GLOBAL(SSglobal_sound)
	
/datum/subsystem/global_sound/fire(resumed = FALSE)
	if(!resumed)
		currentrun = clients.Copy()

	for(var/sound/S in soundlen_map)
		if(--soundlen_map[S] <= 0)
			soundlen_map -= S
			qdel(S)
		
	while(currentrun.len)
		var/client/C = currentrun[currentrun.len]
		currentrun.len--

		C.soundOutput.process()

		if (MC_TICK_CHECK)
			return

/datum/subsystem/global_sound/proc/add_sound(sound/S, duration)
	soundlen_map[S] = duration / 10
	for(var/client/C in clients)
		if(!C || !C.soundOutput)
			continue
		C.soundOutput.update_globalsound_list()
