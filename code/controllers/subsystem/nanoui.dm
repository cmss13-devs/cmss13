SUBSYSTEM_DEF(nano)
	name  = "Nano UI"
	flags = SS_NO_INIT
	wait  = 2 SECONDS
	priority = SS_PRIORITY_NANOUI
	runlevels = RUNLEVELS_DEFAULT|RUNLEVEL_LOBBY
	var/list/currentrun = list()
	var/datum/nanomanager/nanomanager

/datum/controller/subsystem/nano/PreInit()
	nanomanager = new()

/datum/controller/subsystem/nano/stat_entry(msg)
	msg = "P:[length(nanomanager.processing_uis)]"
	return ..()

/datum/controller/subsystem/nano/fire(resumed = FALSE)
	if (!resumed)
		currentrun = nanomanager.processing_uis.Copy()

	while (length(currentrun))
		var/datum/nanoui/UI = currentrun[length(currentrun)]
		currentrun.len--

		if (!UI || QDELETED(UI))
			continue

		UI.process()

		if (MC_TICK_CHECK)
			return
