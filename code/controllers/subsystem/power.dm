var/datum/subsystem/power/SSpower

var/list/power_machines = list()

/datum/subsystem/power
	name          = "Power"
	init_order    = SS_INIT_POWER
	display_order = SS_DISPLAY_POWER
	priority      = SS_PRIORITY_POWER
	flags         = SS_DISABLE_FOR_TESTING
	wait          = 2 SECONDS

	var/list/currentrun_cables = list()
	var/list/currentrun_powerents = list()
	var/list/currentrun_power_machines = list()
	var/list/currentrun_areas = list()


/datum/subsystem/power/New()
	NEW_SS_GLOBAL(SSpower)


/datum/subsystem/power/stat_entry()
	..("PN:[powernets.len]|PM:[power_machines.len]|A:[active_areas.len]")


/datum/subsystem/power/Initialize(timeofday)
	makepowernets()
	..()


/datum/subsystem/power/fire(resumed = FALSE)
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
		if (!X || X.disposed)
			continue

		if (istype(X, /obj/structure/machinery))
			var/obj/structure/machinery/M = X
			if (M.process() == PROCESS_KILL)
				//M.inMachineList = FALSE
				power_machines.Remove(M)
				continue

		if (MC_TICK_CHECK)
			return

	while (currentrun_areas.len)
		var/area/A = currentrun_areas[currentrun_areas.len]
		currentrun_areas.len--

		if(A.master == A)
			if(A.powerupdate)
				A.powerupdate -= 1
				A.clear_usage()
				for(var/obj/structure/machinery/M in A.area_machines) // should take it to O(n^2) and hopefully less expensive.
					if(M)
						//check if the area has power for M's channel
						//this will keep stat updated in case the machine is moved from one area to another.
						if(!M.processable)
							A.area_machines -= M
						M.power_change(A)	//we've already made sure A is a master area, above.

						if(!(M.stat & NOPOWER) && M.use_power)
							M.auto_use_power()

			if(A.apc.len)
				if (MC_TICK_CHECK)
					return
				continue

		A.powerupdate = 0

		if (MC_TICK_CHECK)
			return
