var/datum/subsystem/stamina/SSstamina

var/global/list/active_staminas = list()

/datum/subsystem/stamina
	name     = "Stamina"
	wait     = 2 SECONDS
	priority = SS_PRIORITY_STAMINA

	var/list/currentrun = list()

/datum/subsystem/stamina/New()
	NEW_SS_GLOBAL(SSstamina)

/datum/subsystem/stamina/fire(resumed = FALSE)
	if (!resumed)
		currentrun = active_staminas.Copy()

	while (currentrun.len)
		var/datum/stamina/S = currentrun[currentrun.len]
		currentrun.len--

		if (!S || S.disposed)
			continue

		S.process()

		if (MC_TICK_CHECK)
			return
