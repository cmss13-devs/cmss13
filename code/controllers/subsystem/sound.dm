SUBSYSTEM_DEF(sound)
	name   = "Sound"
	flags   = SS_POST_FIRE_TIMING | SS_NO_INIT
	wait   = 2
	priority   = SS_PRIORITY_SOUND
	runlevels   = RUNLEVELS_DEFAULT|RUNLEVEL_LOBBY

	var/list/template_queue = list() // Full Template Queue
	var/list/run_queue = list() // Queue subset being processed during this tick
	var/list/run_hearers = null // Hearers for currently being processed template

/datum/controller/subsystem/sound/fire(resumed = FALSE)
	if(!resumed) // Controller first firing for this tick
		run_queue = template_queue.Copy()
		template_queue = list()
		run_hearers = null // null explicitely indicates we need to do ranging!

	for(var/datum/sound_template/run_template in run_queue)
		if(!run_hearers) // Initialize for handling next template
			run_hearers = run_queue[run_template] // get base hearers
			if(run_template.range) // ranging
				if(!run_hearers)
					run_hearers = run_template.get_hearers() // I hate |=
				else
					run_hearers |= run_template.get_hearers()

			if(MC_TICK_CHECK)
				return
		while(length(run_hearers)) // Output sound to hearers
			var/client/C = run_hearers[length(run_hearers)]
			run_hearers.len--
			if(C && C.soundOutput)
				C.soundOutput.process_sound(run_template)
			if(MC_TICK_CHECK)
				return
		run_queue.Remove(run_template) // Everyone that had to get this sound got it. Bye, template
		run_hearers = null // Reset so we know next one is new

/datum/controller/subsystem/sound/proc/queue(datum/sound_template/template, list/client/hearers, list/datum/interior/extra_interiors)

	if(extra_interiors && SSmapping)
		if(!hearers)
			hearers = list()
		for(var/datum/interior/VI in extra_interiors)
			if(VI?.ready)
				var/list/turf/bounds = VI.get_bound_turfs()
				var/turf/bottom_left = bounds[1]
				var/turf/top_right   = bounds[2]
				var/list/atom/movable/all_registered_movables = SSmapgrids.get_movables_in_region(bottom_left.z, bottom_left.x, top_right.x, bottom_left.y, top_right.y )
				for(var/mob/mob in all_registered_movables)
					if(mob.client)
						hearers += mob.client

	// In 99.99% of cases, interiors or direct-sent sounds aren't involved so there'll be none.
	// By explicitely nulling it out, we can take results from mapgrids at face value, without needing to do
	// list merging with |= ... little gains, but it's all super hot procs
	if(!length(hearers))
		hearers = null

	template_queue[template] = hearers
