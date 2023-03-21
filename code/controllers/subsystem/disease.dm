var/list/active_diseases = list()


SUBSYSTEM_DEF(disease)
	name  = "Disease"
	wait  = 2 SECONDS
	flags = SS_NO_INIT | SS_KEEP_TIMING
	priority = SS_PRIORITY_DISEASE

	var/list/currentrun = list()

/datum/controller/subsystem/disease/stat_entry(msg)
	msg = "P:[active_diseases.len]"
	return ..()


/datum/controller/subsystem/disease/fire(resumed = FALSE)
	if (!resumed)
		currentrun = active_diseases.Copy()

	while (currentrun.len)
		var/datum/disease/current_disease = currentrun[currentrun.len]
		currentrun.len--

		if (!current_disease || QDELETED(current_disease))
			continue

		current_disease.process()

		if (MC_TICK_CHECK)
			return
