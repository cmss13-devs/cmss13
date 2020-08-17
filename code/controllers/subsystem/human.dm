var/datum/subsystem/human/SShuman


/datum/subsystem/human
	name          = "Human Life"
	wait          = 2 SECONDS
	flags         = SS_NO_INIT | SS_KEEP_TIMING
	priority      = SS_PRIORITY_HUMAN
	display_order = SS_DISPLAY_HUMAN

	var/list/currentrun = list()


/datum/subsystem/human/New()
	NEW_SS_GLOBAL(SShuman)

/datum/subsystem/human/stat_entry()
	..("P:[processable_human_list.len]")


/datum/subsystem/human/fire(resumed = FALSE)
	if (!resumed)
		currentrun = processable_human_list.Copy()

	while (currentrun.len)
		var/mob/living/carbon/human/M = currentrun[currentrun.len]
		currentrun.len--

		if (!M || M.disposed)
			continue

		M.Life()

		if (MC_TICK_CHECK)
			return
