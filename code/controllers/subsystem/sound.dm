SUBSYSTEM_DEF(sound)
	name          = "Sound"
	flags 		  = SS_FIRE_IN_LOBBY | SS_POST_FIRE_TIMING | SS_NO_INIT
	wait		  = 2
	priority      = SS_PRIORITY_SOUND

	var/list/template_queue = list()
	var/list/currentrun = list()

/datum/subsystem/sound/fire(resumed = FALSE)
	for(var/datum/sound_template/i in template_queue)
		if(!resumed) //We haven't started processing the hearers assigned to this sound yet
			currentrun = template_queue[i]
			if(i.range)
				currentrun |= SSquadtree.players_in_range(RECT(i.x, i.y, i.range * 2, i.range * 2), i.z)
			if(MC_TICK_CHECK) //An interruption
				return
		while(currentrun.len) //processing the hearers
			var/client/C = currentrun[currentrun.len]
			currentrun.len--
			if(C && C.soundOutput)
				C.soundOutput.process_sound(i)
			if(MC_TICK_CHECK)
				return
		template_queue.Remove(i) //Everyone that had to get this sound got it. Bye, template


/datum/subsystem/sound/proc/queue(datum/sound_template/template, list/hearers)
	if(!hearers)
		hearers = list()
	template_queue[template] = hearers
	