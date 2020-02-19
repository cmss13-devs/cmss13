var/datum/subsystem/cellauto/SScellauto

var/list/cellauto_cells = list()

/datum/subsystem/cellauto
	name     = "Cellular Automata"
	wait     = SS_WAIT_CELLAUTO
	priority = SS_PRIORITY_CELLAUTO
	flags    = SS_NO_INIT | SS_NO_TICK_CHECK

	var/list/currentrun

/datum/subsystem/cellauto/New()
	NEW_SS_GLOBAL(SSevent)


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