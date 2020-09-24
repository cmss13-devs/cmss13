var/list/active_smoke_effects = list()


SUBSYSTEM_DEF(smoke_effects)
	name     = "Smoke Effects"
	wait     = 1 SECOND
	flags    = SS_NO_INIT | SS_KEEP_TIMING
	priority = SS_PRIORITY_OBJECTS

	var/list/currentrun = list()

/datum/subsystem/smoke_effects/stat_entry()
	..("P:[active_smoke_effects.len]")


/datum/subsystem/smoke_effects/fire(resumed = FALSE)
	if(!resumed)
		currentrun = active_smoke_effects.Copy()

	while(currentrun.len)
		var/obj/effect/particle_effect/smoke/E = currentrun[currentrun.len]
		currentrun.len--

		if(!E || E.disposed)
			continue

		E.process()

		if(MC_TICK_CHECK)
			return