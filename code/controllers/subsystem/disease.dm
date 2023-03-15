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
		var/datum/disease/D = currentrun[currentrun.len]
		currentrun.len--

		if (!D || QDELETED(D))
			continue

		D.process()

		if (MC_TICK_CHECK)
			return
