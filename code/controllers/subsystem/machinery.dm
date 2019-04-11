var/datum/subsystem/machinery/SSmachinery

var/list/machines = list()
var/list/processing_machines = list()

var/list/datum/powernet/powernets = list() //Holds all powernet datums in use or pooled
var/list/cable_list = list() //Index for all cables, so that powernets don't have to look through the entire world all the time


/datum/subsystem/machinery
	name          = "Machinery"
	wait          = SS_WAIT_MACHINERY
	flags         = SS_NO_INIT | SS_KEEP_TIMING
	priority      = SS_PRIORITY_MACHINERY
	display_order = SS_DISPLAY_MACHINERY

	var/list/currentrunmachines
	var/list/currentrunpowernets
	var/list/currentrunareas

/datum/subsystem/machinery/New()
	NEW_SS_GLOBAL(SSmachinery)


/datum/subsystem/machinery/stat_entry(var/msg)
	if (msg)
		return ..()

	..("M:[global.processing_machines.len] A:[active_areas.len] PN:[powernets.len]")

/datum/subsystem/machinery/fire(resumed = FALSE)
	if (!resumed)
		currentrunmachines = processing_machines.Copy()
		currentrunpowernets = powernets.Copy()
		currentrunareas = active_areas.Copy()

	while (currentrunmachines.len)
		var/obj/machinery/M = currentrunmachines[currentrunmachines.len]
		currentrunmachines.len--		

		if (!M || M.gcDestroyed || M.disposed || M.timestopped)
			continue

		if(!M.processable)
			processing_machines -= M

		M.process()
		//if (M.process() == PROCESS_KILL)
			//M.inMachineList = FALSE
			//machines.Remove(M)
			//continue

		if (MC_TICK_CHECK)
			return

	while (currentrunareas.len)
		var/area/A = currentrunareas[currentrunareas.len]
		currentrunareas.len--

		if(A.master == A)
			if(A.powerupdate)
				A.powerupdate -= 1
				A.clear_usage()
				for(var/obj/machinery/M in A.area_machines) // should take it to O(n^2) and hopefully less expensive.
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

	while(currentrunpowernets.len)
		var/datum/powernet/Powernet = currentrunpowernets[currentrunpowernets.len]
		currentrunpowernets.len--
		if(Powernet)
			Powernet.process()
		if (MC_TICK_CHECK)
			return

