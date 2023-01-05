var/global/list/active_staminas = list()

SUBSYSTEM_DEF(stamina)
	name     = "Stamina"
	wait     = 2 SECONDS
	priority = SS_PRIORITY_STAMINA
	flags = SS_NO_INIT
	var/list/currentrun = list()


/datum/controller/subsystem/stamina/fire(resumed = FALSE)
	if (!resumed)
		currentrun = active_staminas.Copy()

	while (currentrun.len)
		var/datum/stamina/S = currentrun[currentrun.len]
		currentrun.len--

		if (!S || QDELETED(S))
			continue

		S.process()

		if (MC_TICK_CHECK)
			return
