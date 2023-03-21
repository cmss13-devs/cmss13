var/global/list/active_staminas = list()

SUBSYSTEM_DEF(stamina)
	name  = "Stamina"
	wait  = 2 SECONDS
	priority = SS_PRIORITY_STAMINA
	flags = SS_NO_INIT
	var/list/currentrun = list()


/datum/controller/subsystem/stamina/fire(resumed = FALSE)
	if (!resumed)
		currentrun = active_staminas.Copy()

	while (currentrun.len)
		var/datum/stamina/player_stamina = currentrun[currentrun.len]
		currentrun.len--

		if (!player_stamina || QDELETED(player_stamina))
			continue

		player_stamina.process()

		if (MC_TICK_CHECK)
			return
