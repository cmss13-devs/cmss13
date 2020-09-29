SUBSYSTEM_DEF(nano)
	name     = "Nano UI"
	flags    = SS_NO_INIT
	wait     = 2 SECONDS
	priority = SS_PRIORITY_NANOUI
	runlevels = RUNLEVELS_DEFAULT|RUNLEVEL_LOBBY
	var/list/currentrun = list()

/datum/controller/subsystem/nano/stat_entry()
	..("P:[nanomanager.processing_uis.len]")

/datum/controller/subsystem/nano/fire(resumed = FALSE)
	if (!resumed)
		currentrun = nanomanager.processing_uis.Copy()

	while (currentrun.len)
		var/datum/nanoui/UI = currentrun[currentrun.len]
		currentrun.len--

		if (!UI || QDELETED(UI))
			continue

		UI.process()

		if (MC_TICK_CHECK)
			return
