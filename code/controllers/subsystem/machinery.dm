GLOBAL_LIST_EMPTY(machines)
GLOBAL_LIST_EMPTY(processing_machines)

GLOBAL_LIST_EMPTY(powernets) //Holds all powernet datums in use or pooled
GLOBAL_LIST_EMPTY(powernets_by_name) //Holds all powernet datums in use or pooled


SUBSYSTEM_DEF(machinery)
	name   = "Machinery"
	wait   = 3.5 SECONDS
	flags  = SS_KEEP_TIMING
	init_order = SS_INIT_MACHINES
	priority   = SS_PRIORITY_MACHINERY

	var/list/currentrunmachines = list()

/datum/controller/subsystem/machinery/Initialize(start_timeofday)
	makepowernets()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/machinery/stat_entry(msg)
	msg = "M:[length(GLOB.processing_machines)]"
	return ..()

/datum/controller/subsystem/machinery/fire(resumed = FALSE)
	if (!resumed)
		currentrunmachines = GLOB.processing_machines.Copy()

	while (length(currentrunmachines))
		var/obj/structure/machinery/M = currentrunmachines[length(currentrunmachines)]
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


