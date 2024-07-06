SUBSYSTEM_DEF(xeno)
	name   = "Xeno Life"
	wait   = 2 SECONDS
	flags  = SS_NO_INIT | SS_KEEP_TIMING
	priority   = SS_PRIORITY_XENO

	var/list/currentrun = list()

/datum/controller/subsystem/xeno/stat_entry(msg)
	msg = "P:[length(GLOB.xeno_mob_list)]"
	return ..()


/datum/controller/subsystem/xeno/fire(resumed = FALSE)
	if (!resumed)
		currentrun = GLOB.xeno_mob_list.Copy()

	while (length(currentrun))
		var/mob/living/carbon/xenomorph/M = currentrun[length(currentrun)]
		currentrun.len--

		if (!M || QDELETED(M))
			continue

		M.Life(wait * 0.1)

		if (MC_TICK_CHECK)
			return
