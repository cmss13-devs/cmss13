SUBSYSTEM_DEF(sound)
	name          = "Sound"
	flags 		  = SS_POST_FIRE_TIMING | SS_NO_INIT
	wait		  = 2
	priority      = SS_PRIORITY_SOUND
	runlevels 	  = RUNLEVELS_DEFAULT|RUNLEVEL_LOBBY

	var/list/template_queue = list()							// Full Template Queue
	var/list/run_queue = list()									// Queue subset being processed during this tick
	var/list/run_hearers = null									// Hearers for currently being processed template

/datum/controller/subsystem/sound/fire(resumed = FALSE)
	if(!resumed)												// Controller first firing for this tick
		run_queue = template_queue.Copy()
		template_queue = list()
		run_hearers = null										// null explicitely indicates we need to do ranging!

	for(var/datum/sound_template/run_template in run_queue)
		if(!run_hearers) 										// Initialize for handling next template
			run_hearers = run_queue[run_template] 				// get base hearers
			if(run_template.range) 								// ranging
				var/datum/shape/rectangle/zone = RECT(run_template.x, run_template.y, run_template.range * 2, run_template.range * 2)
				run_hearers |= SSquadtree.players_in_range(zone, run_template.z)
			if(MC_TICK_CHECK)
				return
		while(length(run_hearers)) 								// Output sound to hearers
			var/client/C = run_hearers[run_hearers.len]
			run_hearers.len--
			if(C && C.soundOutput)
				C.soundOutput.process_sound(run_template)
			if(MC_TICK_CHECK)
				return
		run_queue.Remove(run_template)							// Everyone that had to get this sound got it. Bye, template
		run_hearers = null										// Reset so we know next one is new

/datum/controller/subsystem/sound/proc/queue(datum/sound_template/template, var/list/client/hearers, list/datum/interior/extra_interiors)
	if(!hearers)
		hearers = list()
	if(extra_interiors && GLOB.interior_manager)
		for(var/datum/interior/VI in extra_interiors)
			if(VI?.ready && VI?.chunk_id)
				var/list/bounds = GLOB.interior_manager.get_chunk_coords(VI.chunk_id)
				if(bounds.len >= 2)
					hearers |= SSquadtree.players_in_range(RECT(bounds[1], bounds[2], GLOB.interior_manager.chunk_size, GLOB.interior_manager.chunk_size), GLOB.interior_manager.interior_z)
	template_queue[template] = hearers
