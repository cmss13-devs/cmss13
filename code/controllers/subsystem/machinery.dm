var/list/machines = list()
var/list/processing_machines = list()

var/list/datum/powernet/powernets = list() //Holds all powernet datums in use or pooled
var/list/datum/powernet/powernets_by_name = list() //Holds all powernet datums in use or pooled


SUBSYSTEM_DEF(machinery)
	name          = "Machinery"
	wait          = 3.5 SECONDS
	flags         = SS_NO_INIT | SS_KEEP_TIMING
	priority      = SS_PRIORITY_MACHINERY

	var/list/currentrunmachines = list()

/datum/controller/subsystem/machinery/stat_entry(var/msg)
	if (msg)
		return ..()

	..("M:[global.processing_machines.len]")

/datum/controller/subsystem/machinery/fire(resumed = FALSE)
	if (!resumed)
		currentrunmachines = processing_machines.Copy()

	while (currentrunmachines.len)
		var/obj/structure/machinery/M = currentrunmachines[currentrunmachines.len]
		currentrunmachines.len--

		if (!M || QDELETED(M))
			continue

		M.process()
		//if (M.process() == PROCESS_KILL)
			//M.inMachineList = FALSE
			//machines.Remove(M)
			//continue

		if (MC_TICK_CHECK)
			return


