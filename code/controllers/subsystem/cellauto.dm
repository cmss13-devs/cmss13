var/list/cellauto_cells = list()

SUBSYSTEM_DEF(cellauto)
	name     = "Cellular Automata"
	wait     = SS_WAIT_CELLAUTO
	priority = SS_PRIORITY_CELLAUTO
	flags    = SS_NO_INIT

	var/list/currentrun = list()

/datum/subsystem/cellauto/stat_entry()
	..("C: [cellauto_cells.len]")

/datum/subsystem/cellauto/fire(resumed = FALSE)
	if (!resumed)
		currentrun = cellauto_cells.Copy()

	while(currentrun.len)
		var/datum/automata_cell/C = currentrun[currentrun.len]
		currentrun.len--

		if (!C || C.disposed)
			continue

		C.update_state()

		if (MC_TICK_CHECK)
			return