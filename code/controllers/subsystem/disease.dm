SUBSYSTEM_DEF(disease)
	name  = "Disease"
	wait  = 2 SECONDS
	flags = SS_NO_INIT | SS_KEEP_TIMING
	priority = SS_PRIORITY_DISEASE

	var/list/datum/disease/all_diseases = list()
	var/list/datum/disease/currentrun = list()

/datum/controller/subsystem/disease/stat_entry(msg)
	msg = "P:[length(all_diseases)]"
	return ..()

/datum/controller/subsystem/disease/fire(resumed = FALSE)
	if (!resumed)
		currentrun = all_diseases.Copy()

	while (length(currentrun))
		var/datum/disease/D = currentrun[length(currentrun)]
		currentrun.len--

		if (!D || QDELETED(D))
			continue

		D.process()

		if (MC_TICK_CHECK)
			return
