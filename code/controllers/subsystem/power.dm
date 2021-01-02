var/list/power_machines = list()

SUBSYSTEM_DEF(power)
	name          = "Power"
	init_order    = SS_INIT_POWER
	priority      = SS_PRIORITY_POWER
	flags         = SS_DISABLE_FOR_TESTING
	wait          = 2 SECONDS

	var/list/currentrun_cables = list()
	var/list/currentrun_powerents = list()
	var/list/currentrun_power_machines = list()
	var/list/currentrun_areas = list()

/datum/controller/subsystem/power/stat_entry(msg)
	msg = "PN:[powernets.len]|PM:[power_machines.len]|A:[active_areas.len]"
	return ..()


/datum/controller/subsystem/power/Initialize(timeofday)
	makepowernets()
	return ..()


/datum/controller/subsystem/power/fire(resumed = FALSE)
	if (!resumed)
		currentrun_powerents      = global.powernets.Copy()
		currentrun_areas = active_areas.Copy()
		currentrun_power_machines = global.power_machines.Copy()

	// First we reset the powernets.
	// This is done first because we want the power machinery to have acted last on the powernet between intervals.
	while(currentrun_powerents.len)
		var/datum/powernet/Powernet = currentrun_powerents[currentrun_powerents.len]
		currentrun_powerents.len--
		if(Powernet)
			Powernet.process()
		if (MC_TICK_CHECK)
			return


	// Next we let the power machines operate, this way until the next tick it will be as if they have all done their work.
	while (currentrun_power_machines.len)
		var/datum/X = currentrun_power_machines[currentrun_power_machines.len]
		currentrun_power_machines.len--
		if (!X || QDELETED(X))
			continue

		if (istype(X, /obj/structure/machinery))
			var/obj/structure/machinery/M = X
			if (M.process() == PROCESS_KILL)
				//M.inMachineList = FALSE
				power_machines.Remove(M)
				continue

		if (MC_TICK_CHECK)
			return
