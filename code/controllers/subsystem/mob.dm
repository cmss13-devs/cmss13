SUBSYSTEM_DEF(mob)
	name          = "Misc Mobs"
	wait          = 2 SECONDS
	flags         = SS_NO_INIT | SS_KEEP_TIMING | SS_DISABLE_FOR_TESTING
	priority      = SS_PRIORITY_MOB

	var/list/currentrun = list()
	var/list/living_misc_mobs = list()

/datum/controller/subsystem/mob/stat_entry(msg)
	msg = "P:[living_misc_mobs.len]"
	return ..()


/datum/controller/subsystem/mob/fire(resumed = FALSE)
	if (!resumed)
		currentrun = living_misc_mobs.Copy()

	while (currentrun.len)
		var/mob/living/M = currentrun[currentrun.len]
		currentrun.len--

		if (!M || QDELETED(M))
			continue

		M.Life(wait * 0.1)

		if (MC_TICK_CHECK)
			return
