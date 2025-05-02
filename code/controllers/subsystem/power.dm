GLOBAL_LIST_EMPTY(power_machines)

SUBSYSTEM_DEF(power)
	name   = "Power"
	init_order = SS_INIT_POWER
	priority   = SS_PRIORITY_POWER
	wait   = 2 SECONDS

	var/list/currentrun_cables = list()
	var/list/currentrun_powerents = list()
	var/list/currentrun_power_machines = list()
	var/list/currentrun_areas = list()

/datum/controller/subsystem/power/stat_entry(msg)
	msg = "PN:[length(GLOB.powernets)]|PM:[length(GLOB.power_machines)]|A:[length(GLOB.active_areas)]"
	return ..()


/datum/controller/subsystem/power/Initialize(timeofday)
	makepowernets()
	return SS_INIT_SUCCESS


/datum/controller/subsystem/power/fire(resumed = FALSE)
	if (!resumed)
		currentrun_powerents   = GLOB.powernets.Copy()
		currentrun_areas = GLOB.active_areas.Copy()
		currentrun_power_machines = GLOB.power_machines.Copy()

	// First we reset the powernets.
	// This is done first because we want the power machinery to have acted last on the powernet between intervals.
	while(length(currentrun_powerents))
		var/datum/powernet/Powernet = currentrun_powerents[length(currentrun_powerents)]
		currentrun_powerents.len--
		if(Powernet)
			Powernet.process()
		if (MC_TICK_CHECK)
			return


	// Next we let the power machines operate, this way until the next tick it will be as if they have all done their work.
	while (length(currentrun_power_machines))
		var/datum/X = currentrun_power_machines[length(currentrun_power_machines)]
		currentrun_power_machines.len--
		if (!X || QDELETED(X))
			continue

		if (istype(X, /obj/structure/machinery))
			var/obj/structure/machinery/M = X
			if (M.process() == PROCESS_KILL)
				//M.inMachineList = FALSE
				GLOB.power_machines.Remove(M)
				continue

		if (MC_TICK_CHECK)
			return
