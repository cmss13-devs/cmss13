SUBSYSTEM_DEF(human)
	name   = "Human Life"
	wait   = 2 SECONDS
	flags  = SS_NO_INIT | SS_KEEP_TIMING
	priority   = SS_PRIORITY_HUMAN

	var/list/mob/living/carbon/human/currentrun = list()
	var/list/mob/living/carbon/human/processable_human_list = list()

	/* DEBUG */
	var/mob/living/carbon/human/processing_human


/datum/controller/subsystem/human/stat_entry(msg)
	msg = "P:[processable_human_list.len] L:[processing_human]"
	return ..()

/datum/controller/subsystem/human/fire(resumed = FALSE)
	if (!resumed)
		currentrun = processable_human_list.Copy()

	while (currentrun.len)
		var/mob/living/carbon/human/M = currentrun[currentrun.len]
		currentrun.len--

		if (!M || QDELETED(M))
			continue

		var/before = world.time
		processing_human = M
		M.Life(wait * 0.1)
		if(before != world.time)
			log_debug("SShuman slept in processing. Offender: [M]")
		processing_human = null

		if (MC_TICK_CHECK)
			return
