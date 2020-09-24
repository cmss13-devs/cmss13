SUBSYSTEM_DEF(clues)
	name          = "Clues"
	wait          = 10 SECONDS
	flags         = SS_NO_INIT | SS_KEEP_TIMING
	priority      = SS_PRIORITY_DISEASE

	var/list/currentrun = list()
	var/list/prints_list = list()

/datum/subsystem/clues/stat_entry()
	..("P:[prints_list.len]")

/datum/subsystem/clues/fire(resumed = FALSE)
	if(!resumed && length(prints_list))
		currentrun = prints_list.Copy()

	while(currentrun.len)
		var/obj/effect/decal/prints/P = currentrun[currentrun.len]
		currentrun.len--

		if(!P || P.disposed)
			continue

		if(world.timeofday - P.created_time > 10 MINUTE)
			qdel(P)

		if(MC_TICK_CHECK)
			return
