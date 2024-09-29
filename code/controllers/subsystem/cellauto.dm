GLOBAL_LIST_EMPTY(cellauto_cells)

SUBSYSTEM_DEF(cellauto)
	name  = "Cellular Automata"
	wait  = 0.05 SECONDS
	priority = SS_PRIORITY_CELLAUTO
	flags = SS_NO_INIT

	var/list/currentrun = list()

/datum/controller/subsystem/cellauto/stat_entry(msg)
	msg = "C: [length(GLOB.cellauto_cells)]"
	return ..()

/datum/controller/subsystem/cellauto/fire(resumed = FALSE)
	if (!resumed)
		currentrun = GLOB.cellauto_cells.Copy()

	while(length(currentrun))
		var/datum/automata_cell/C = currentrun[length(currentrun)]
		currentrun.len--

		if (!C || QDELETED(C))
			continue

		C.update_state()

		if (MC_TICK_CHECK)
			return
