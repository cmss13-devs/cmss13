var/datum/subsystem/machinery/SSmachinery

var/list/machines = list()
var/list/processing_machines = list()

var/list/datum/powernet/powernets = list() //Holds all powernet datums in use or pooled
var/list/datum/powernet/powernets_by_name = list() //Holds all powernet datums in use or pooled


/datum/subsystem/machinery
	name          = "Machinery"
	wait          = SS_WAIT_MACHINERY
	flags         = SS_NO_INIT | SS_KEEP_TIMING
	priority      = SS_PRIORITY_MACHINERY
	display_order = SS_DISPLAY_MACHINERY

	var/list/currentrunmachines = list()

/datum/subsystem/machinery/New()
	NEW_SS_GLOBAL(SSmachinery)

/datum/subsystem/machinery/stat_entry(var/msg)
	if (msg)
		return ..()

	..("M:[global.processing_machines.len]")

/datum/subsystem/machinery/fire(resumed = FALSE)
	if (!resumed)
		currentrunmachines = processing_machines.Copy()

	while (currentrunmachines.len)
		var/obj/structure/machinery/M = currentrunmachines[currentrunmachines.len]
		currentrunmachines.len--

		if (!M || M.disposed)
			continue

		M.process()
		//if (M.process() == PROCESS_KILL)
			//M.inMachineList = FALSE
			//machines.Remove(M)
			//continue

		if (MC_TICK_CHECK)
			return


