SUBSYSTEM_DEF(clues)
	name   = "Clues"
	wait   = 30 SECONDS
	flags  = SS_NO_INIT | SS_KEEP_TIMING
	priority   = SS_PRIORITY_DISEASE

	var/list/currentrun = list()
	var/list/clues_list = list()

	var/list/cleaning_run = list()
	var/list/cleanup_targets = list()

/datum/controller/subsystem/clues/stat_entry(msg)
	msg = "C:[length(clues_list)]"
	return ..()

/datum/controller/subsystem/clues/fire(resumed = FALSE)
	if (!resumed && length(clues_list))
		currentrun = clues_list.Copy()

	// TODO: Make a config for maximum amount of clues
	// TODO: Make a config for cleaning target size
	// If the cleaning targets isn't empty, or we're overbudget on clues, we need to keep cleaning.
	if (length(clues_list) > 1000 || length(cleanup_targets))
		while(length(cleaning_run))
			var/datum/clue/target = cleaning_run[length(cleaning_run)]
			cleaning_run.len--

			if (!target || QDELETED(target))
				continue

			// If the cleaning target list is under maximum size, just add it
			if (length(cleaning_run) < 200)
				cleanup_targets += target

			// Otherwise, try to find a target that's younger than this clue and replace it
			var/index
			for (index = 1, index <= cleanup_targets.len, index++)
				var/datum/clue/replacee = cleanup_targets[index]
				if (replacee == null || replacee.created_time > target.created_time)
					cleanup_targets[index] = target

			// If no cleanup targets are younger than this clue, then it has survived this cleaning pass.
			if (MC_TICK_CHECK)
				return

		// Cleaning pass has completed. Time to mark all these clues for cleanup...
		for (var/datum/clue/clue in cleanup_targets)
			clue.cleanup = TRUE

	while (length(currentrun))
		var/datum/clue/clue = currentrun[length(currentrun)]
		currentrun.len--

		if (!clue || QDELETED(clue))
			continue

		if (clue.process() == PROCESS_KILL)
			qdel(clue)

		if (MC_TICK_CHECK)
			return

/*
/datum/controller/subsystem/clues/stat_entry(msg)
	msg = "P:[length(prints_list)]"
	return ..()

/datum/controller/subsystem/clues/fire(resumed = FALSE)
	if(!resumed && length(prints_list))
		currentrun = prints_list.Copy()

	while(length(currentrun))
		var/obj/effect/decal/prints/P = currentrun[length(currentrun)]
		currentrun.len--

		if(!P || QDELETED(P))
			continue

		if(world.timeofday - P.created_time > 10 MINUTES)
			qdel(P)

		if(MC_TICK_CHECK)
			return

/datum/controller/subsystem/clues/proc/create_print(turf/location, mob/living/carbon/human/criminal_mob, incident = "")
	if(!location || !istype(criminal_mob) || SSticker.mode.is_in_endgame)
		return

	new /obj/effect/decal/prints(location, criminal_mob, incident)
*/
