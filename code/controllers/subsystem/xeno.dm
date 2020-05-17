var/datum/subsystem/xeno/SSxeno


/datum/subsystem/xeno
	name          = "Xeno Life"
	wait          = 2 SECONDS
	flags         = SS_NO_INIT | SS_KEEP_TIMING
	priority      = SS_PRIORITY_XENO
	display_order = SS_DISPLAY_XENO

	var/list/currentrun = list()


/datum/subsystem/xeno/New()
	NEW_SS_GLOBAL(SSxeno)


/datum/subsystem/xeno/stat_entry()
	..("P:[xeno_mob_list.len]")


/datum/subsystem/xeno/fire(resumed = FALSE)
	if (!resumed)
		currentrun = xeno_mob_list.Copy()

	while (currentrun.len)
		var/mob/living/carbon/Xenomorph/M = currentrun[currentrun.len]
		currentrun.len--

		if (!M || M.disposed)
			continue

		M.Life()

		if (MC_TICK_CHECK)
			return
