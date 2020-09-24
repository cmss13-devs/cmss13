var/list/active_effects = list()

SUBSYSTEM_DEF(effects)
	name     = "Effects"
	wait     = 1 SECOND
	flags    = SS_NO_INIT | SS_KEEP_TIMING
	priority = SS_PRIORITY_DISEASE

	var/list/currentrun = list()

/datum/subsystem/effects/stat_entry()
	..("P:[active_effects.len]")


/datum/subsystem/effects/fire(resumed = FALSE)
	if(!resumed)
		currentrun = active_effects.Copy()

	while(currentrun.len)
		var/datum/effects/E = currentrun[currentrun.len]
		currentrun.len--

		if(!E || E.disposed)
			continue

		E.process()

		if(MC_TICK_CHECK)
			return