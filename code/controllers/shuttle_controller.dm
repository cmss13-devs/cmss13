/datum/controller/shuttle_controller
	var/list/shuttles //maps shuttle tags to shuttle datums, so that they can be looked up.
	var/list/process_shuttles //simple list of shuttles, for processing
	var/list/locs_crash

/datum/controller/shuttle_controller/process()
	//process ferry shuttles
	for (var/datum/shuttle/ferry/shuttle in process_shuttles)

		// Hacky bullshit that should only apply for shuttle/marine's for now.
		if (shuttle.move_scheduled && shuttle.already_moving == 0)
			shuttle.already_moving = 1
			spawn(-1)
				move_shuttle_to(shuttle.target_turf, 0, shuttle.shuttle_turfs, 0, shuttle.target_rotation, shuttle)

		if (shuttle.process_state)
			shuttle.process()

/datum/controller/shuttle_controller/New()
	shuttles = list()
	process_shuttles = list()
	locs_crash = list()

	var/datum/shuttle/ferry/shuttle

	// Supply shuttle
	shuttle = new/datum/shuttle/ferry/supply()
	shuttle.location = 1
	shuttle.warmup_time = 1
	shuttle.move_time = ELEVATOR_TRANSIT_DURATION
	for(var/area/A in GLOB.all_areas)
		if(A.type == /area/supply/dock)
			shuttle.area_offsite = A
			break

	for(var/area/A in GLOB.all_areas)
		if(A.type == /area/supply/station)
			shuttle.area_station = A
			break

	shuttles["Supply"] = shuttle
	process_shuttles += shuttle

	GLOB.supply_controller.shuttle = shuttle

//---ELEVATOR---//
	// Elevator I
	shuttle = new /datum/shuttle/ferry/elevator()
	shuttle.location = 0
	shuttle.warmup_time = 10 SECONDS
	shuttle.recharge_time = ELEVATOR_RECHARGE

	for(var/area/A in GLOB.all_areas)
		if(A.type == /area/shuttle/elevator1/underground)
			shuttle.area_offsite = A
			break

	for(var/area/A in GLOB.all_areas)
		if(A.type == /area/shuttle/elevator1/ground)
			shuttle.area_station = A
			break

	for(var/area/A in GLOB.all_areas)
		if(A.type == /area/shuttle/elevator1/transit)
			shuttle.area_transition = A
			break

	shuttle.move_time = ELEVATOR_TRANSIT_DURATION
	shuttle.iselevator = 1
	shuttles["Elevator 1"] = shuttle
	process_shuttles += shuttle

	// Elevator II
	shuttle = new /datum/shuttle/ferry/elevator()
	shuttle.location = 0
	shuttle.warmup_time = 10 SECONDS
	shuttle.recharge_time = ELEVATOR_RECHARGE

	for(var/area/A in GLOB.all_areas)
		if(A.type == /area/shuttle/elevator2/underground)
			shuttle.area_offsite = A
			break

	for(var/area/A in GLOB.all_areas)
		if(A.type == /area/shuttle/elevator2/ground)
			shuttle.area_station = A
			break

	for(var/area/A in GLOB.all_areas)
		if(A.type == /area/shuttle/elevator2/transit)
			shuttle.area_transition = A
			break

	shuttle.transit_direction = NORTH
	shuttle.move_time = ELEVATOR_TRANSIT_DURATION
	shuttle.iselevator = 1
	shuttles["Elevator 2"] = shuttle
	process_shuttles += shuttle

	// Elevator III
	shuttle = new /datum/shuttle/ferry/elevator()
	shuttle.location = 0
	shuttle.warmup_time = 10 SECONDS
	shuttle.recharge_time = ELEVATOR_RECHARGE
	for(var/area/A in GLOB.all_areas)
		if(A.type == /area/shuttle/elevator3/underground)
			shuttle.area_offsite = A
			break

	for(var/area/A in GLOB.all_areas)
		if(A.type == /area/shuttle/elevator3/ground)
			shuttle.area_station = A
			break

	for(var/area/A in GLOB.all_areas)
		if(A.type == /area/shuttle/elevator3/transit)
			shuttle.area_transition = A
			break
	shuttle.transit_direction = NORTH
	shuttle.move_time = ELEVATOR_TRANSIT_DURATION
	shuttle.iselevator = 1
	shuttles["Elevator 3"] = shuttle
	process_shuttles += shuttle

	// Elevator IV
	shuttle = new /datum/shuttle/ferry/elevator()
	shuttle.location = 0
	shuttle.warmup_time = 10 SECONDS
	shuttle.recharge_time = ELEVATOR_RECHARGE
	for(var/area/A in GLOB.all_areas)
		if(A.type == /area/shuttle/elevator4/underground)
			shuttle.area_offsite = A
			break

	for(var/area/A in GLOB.all_areas)
		if(A.type == /area/shuttle/elevator4/ground)
			shuttle.area_station = A
			break

	for(var/area/A in GLOB.all_areas)
		if(A.type == /area/shuttle/elevator4/transit)
			shuttle.area_transition = A
			break
	shuttle.transit_direction = NORTH
	shuttle.move_time = ELEVATOR_TRANSIT_DURATION
	shuttle.iselevator = 1
	shuttles["Elevator 4"] = shuttle
	process_shuttles += shuttle

	// Trijent Transit I
	shuttle = new /datum/shuttle/ferry/elevator()
	shuttle.location = 0
	shuttle.warmup_time = 10 SECONDS
	shuttle.recharge_time = ELEVATOR_RECHARGE
	for(var/area/A in GLOB.all_areas)
		if(A.type == /area/shuttle/tri_trans1/omega)
			shuttle.area_offsite = A
			break

	for(var/area/A in GLOB.all_areas)
		if(A.type == /area/shuttle/tri_trans1/alpha)
			shuttle.area_station = A
			break

	for(var/area/A in GLOB.all_areas)
		if(A.type == /area/shuttle/tri_trans1/away)
			shuttle.area_transition = A
			break
	shuttle.transit_direction = NORTH
	shuttle.move_time = TRANSIT_POD_TRANSIT_DURATION
	shuttle.iselevator = 1
	shuttle.require_link = 1
	shuttles["Transit 1"] = shuttle
	process_shuttles += shuttle

	// Trijent Transit II
	shuttle = new /datum/shuttle/ferry/elevator()
	shuttle.location = 0
	shuttle.warmup_time = 10 SECONDS
	shuttle.recharge_time = ELEVATOR_RECHARGE
	for(var/area/A in GLOB.all_areas)
		if(A.type == /area/shuttle/tri_trans2/omega)
			shuttle.area_offsite = A
			break

	for(var/area/A in GLOB.all_areas)
		if(A.type == /area/shuttle/tri_trans2/alpha)
			shuttle.area_station = A
			break

	for(var/area/A in GLOB.all_areas)
		if(A.type == /area/shuttle/tri_trans2/away)
			shuttle.area_transition = A
			break
	shuttle.transit_direction = NORTH
	shuttle.move_time = TRANSIT_POD_TRANSIT_DURATION
	shuttle.iselevator = 1
	shuttle.require_link = 1
	shuttles["Transit 2"] = shuttle
	process_shuttles += shuttle

	for(var/obj/structure/machinery/computer/shuttle_control/S in GLOB.shuttle_controls)
		S.shuttle_datum = shuttles[S.shuttle_tag]


//This is called by gameticker after all the machines and radio frequencies have been properly initialized
/datum/controller/shuttle_controller/proc/setup_shuttle_docks()
	var/datum/shuttle/shuttle
	var/list/dock_controller_map = list() //so we only have to iterate once through each list

	for(var/shuttle_tag in shuttles)
		shuttle = shuttles[shuttle_tag]
		if(istype(shuttle, /datum/shuttle/ferry/marine)) continue //Evac pods ignore this, as do other marine ferries.
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
