/datum/controller/shuttle_controller
	var/list/shuttles //maps shuttle tags to shuttle datums, so that they can be looked up.
	var/list/process_shuttles //simple list of shuttles, for processing

/datum/controller/shuttle_controller/process()
	//process ferry shuttles
	for (var/datum/shuttle/ferry/shuttle in process_shuttles)
		if (shuttle.process_state)
			shuttle.process()

/datum/controller/shuttle_controller/New()
	shuttles = list()
	process_shuttles = list()

	var/datum/shuttle/ferry/supply/shuttle

	// Supply shuttle
	shuttle = new/datum/shuttle/ferry/supply()
	shuttle.location = 1
	shuttle.warmup_time = 1
	shuttle.move_time = ELEVATOR_TRANSIT_DURATION
	for(var/area/A in GLOB.all_areas)
		if(A.type == /area/supply/dock/uscm)
			shuttle.area_offsite = A
			break

	for(var/area/A in GLOB.all_areas)
		if(A.type == /area/supply/station/uscm)
			shuttle.area_station = A
			break

	shuttles["Supply"] = shuttle
	process_shuttles += shuttle
	GLOB.supply_controller.shuttle = shuttle

	shuttle = new/datum/shuttle/ferry/supply/upp()
	shuttle.location = 1
	shuttle.warmup_time = 1
	shuttle.move_time = ELEVATOR_TRANSIT_DURATION
	for(var/area/A in GLOB.all_areas)
		if(A.type == /area/supply/dock/upp)
			shuttle.area_offsite = A
			break

	for(var/area/A in GLOB.all_areas)
		if(A.type == /area/supply/station/upp)
			shuttle.area_station = A
			break

	shuttles["Supply upp"] = shuttle
	process_shuttles += shuttle

	GLOB.supply_controller_upp.shuttle = shuttle

//This is called by gameticker after all the machines and radio frequencies have been properly initialized
/datum/controller/shuttle_controller/proc/setup_shuttle_docks()
	var/datum/shuttle/shuttle
	var/list/dock_controller_map = list() //so we only have to iterate once through each list

	for(var/shuttle_tag in shuttles)
		shuttle = shuttles[shuttle_tag]
		if(istype(shuttle, /datum/shuttle/ferry/marine))
			continue //Evac pods ignore this, as do other marine ferries.
		if(shuttle.docking_controller_tag)
			dock_controller_map[shuttle.docking_controller_tag] = shuttle

	//search for the controllers, if we have one.
	if(length(dock_controller_map))
		for(var/obj/structure/machinery/embedded_controller/radio/C in GLOB.machines) //only radio controllers are supported at the moment
			if (istype(C.program, /datum/computer/file/embedded_program/docking))
				if(dock_controller_map[C.id_tag])
					shuttle = dock_controller_map[C.id_tag]
					shuttle.docking_controller = C.program
					dock_controller_map -= C.id_tag


	//sanity check
	//NO SANITY
// if (length(dock_controller_map) || length(dock_controller_map_station) || length(dock_controller_map_offsite))
// var/dat = ""
// for (var/dock_tag in dock_controller_map + dock_controller_map_station + dock_controller_map_offsite)
// dat += "\"[dock_tag]\", "

	//makes all shuttles docked to something at round start go into the docked state
	for(var/shuttle_tag in shuttles)
		shuttle = shuttles[shuttle_tag]
		shuttle.dock()
