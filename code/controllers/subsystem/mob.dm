var/datum/subsystem/mob/SSmob


/datum/subsystem/mob
	name          = "Misc Mobs"
	wait          = 2 SECONDS
	flags         = SS_NO_INIT | SS_KEEP_TIMING | SS_DISABLE_FOR_TESTING
	priority      = SS_PRIORITY_MOB
	display_order = SS_DISPLAY_MOB

	var/list/currentrun = list()


/datum/subsystem/mob/New()
	NEW_SS_GLOBAL(SSmob)


/datum/subsystem/mob/stat_entry()
	..("P:[living_misc_mobs.len]")


/datum/subsystem/mob/fire(resumed = FALSE)
	if (!resumed)
		currentrun = living_misc_mobs.Copy()

	while (currentrun.len)
		var/mob/living/M = currentrun[currentrun.len]
		currentrun.len--

		if (!M || M.disposed)
			continue

		M.Life()

		if (MC_TICK_CHECK)
			return
