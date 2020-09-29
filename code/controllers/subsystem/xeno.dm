SUBSYSTEM_DEF(xeno)
	name          = "Xeno Life"
	wait          = 2 SECONDS
	flags         = SS_NO_INIT | SS_KEEP_TIMING
	priority      = SS_PRIORITY_XENO

	var/list/currentrun = list()

/datum/controller/subsystem/xeno/stat_entry()
	..("P:[xeno_mob_list.len]")


/datum/controller/subsystem/xeno/fire(resumed = FALSE)
	if (!resumed)
		currentrun = xeno_mob_list.Copy()

	while (currentrun.len)
		var/mob/living/carbon/Xenomorph/M = currentrun[currentrun.len]
		currentrun.len--

		if (!M || QDELETED(M))
			continue

		M.Life()

		if (MC_TICK_CHECK)
			return
