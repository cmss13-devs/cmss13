var/datum/subsystem/human/SShuman


/datum/subsystem/human
	name          = "Human Life"
	wait          = 2 SECONDS
	flags         = SS_NO_INIT | SS_KEEP_TIMING
	priority      = SS_PRIORITY_HUMAN
	display_order = SS_DISPLAY_HUMAN

	var/list/currentrun


/datum/subsystem/human/New()
	NEW_SS_GLOBAL(SShuman)


/datum/subsystem/human/stat_entry()
	..("P:[human_mob_list.len]")


/datum/subsystem/human/fire(resumed = FALSE)
	if (!resumed)
		currentrun = human_mob_list.Copy()

	while (currentrun.len)
		var/mob/living/carbon/human/M = currentrun[currentrun.len]
		currentrun.len--

		if (!M || M.disposed || M.gcDestroyed || M.timestopped)
			continue

		M.Life()

		if (MC_TICK_CHECK)
			return
