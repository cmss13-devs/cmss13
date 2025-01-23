SUBSYSTEM_DEF(data_core)
	name = "Data Core"
	priority = SS_PRIORITY_DATA_CORE
	flags = SS_NO_INIT
	wait = 10 SECONDS

	var/list/datum/tgui_havers = list()
	var/list/datum/currentrun = list()

/datum/controller/subsystem/data_core/stat_entry(msg)
	msg = "P:[length(tgui_havers)]"
	return ..()

/datum/controller/subsystem/data_core/fire(resumed = FALSE)
	if (!resumed)
		if(GLOB.data_core.update_flags == NONE)
			return
		GLOB.data_core.update_flags = NONE
		currentrun = tgui_havers.Copy()

	while (length(currentrun))
		var/datum/tgui_haver = currentrun[length(currentrun)]
		currentrun.len--

		if (!tgui_haver || QDELETED(tgui_haver))
			continue

		tgui_haver.update_static_data_for_all_viewers()

		if (MC_TICK_CHECK)
			return
