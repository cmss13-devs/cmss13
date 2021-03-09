SUBSYSTEM_DEF(human)
	name          = "Human Life"
	wait          = 2 SECONDS
	flags         = SS_NO_INIT | SS_KEEP_TIMING
	priority      = SS_PRIORITY_HUMAN

	var/list/currentrun = list()

	var/list/processable_human_list = list()


/datum/controller/subsystem/human/stat_entry(msg)
	msg = "P:[processable_human_list.len]"
	return ..()

/datum/controller/subsystem/human/fire(resumed = FALSE)
	if (!resumed)
		currentrun = processable_human_list.Copy()

	while (currentrun.len)
		var/mob/living/carbon/human/M = currentrun[currentrun.len]
		currentrun.len--

		if (!M || QDELETED(M))
			continue

		M.Life(wait * 0.1)

		if (MC_TICK_CHECK)
			return
