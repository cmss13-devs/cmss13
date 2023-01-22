/obj/docking_port/mobile/escape_shuttle
	name = "Escape Pod"
	id = ESCAPE_SHUTTLE
	area_type = /area/shuttle/escape_pod
	width = 4
	height = 5
	preferred_direction = SOUTH
	callTime = DROPSHIP_TRANSIT_DURATION
	rechargeTime = SHUTTLE_RECHARGE

	var/datum/door_controller/single/door_handler = new()
	var/launched = FALSE
	var/evac_set = FALSE

/obj/docking_port/mobile/escape_shuttle/Initialize(mapload)
	. = ..(mapload)
	for(var/place in shuttle_areas)
		for(var/obj/structure/machinery/door/air in place)
			door_handler.doors += list(air)
			air.breakable = FALSE
			air.indestructible = TRUE
			air.unacidable = TRUE

/obj/docking_port/mobile/escape_shuttle/proc/prepare_evac()
	door_handler.control_doors("force-unlock")
	evac_set = TRUE

/obj/docking_port/mobile/escape_shuttle/proc/evac_launch()
	if(mode == SHUTTLE_CRASHED)
		return

	var/obj/structure/machinery/computer/shuttle/escape_pod_panel/panel = getControlConsole()
	if(panel.pod_state == STATE_DELAYED)
		return

	door_handler.control_doors("force-lock-launch")
	destination = null
	var/occupant_count = 0
	var/list/cryos = list()
	for(var/area/interior_area in shuttle_areas)
		for(var/mob/occupant in interior_area)
			occupant_count++
		for(var/obj/structure/machinery/cryopod/evacuation/cryotube in interior_area)
			cryos += list(cryotube)
	if (occupant_count > 3)
		playsound(src,'sound/effects/escape_pod_warmup.ogg', 50, 1)
		sleep(31)
		var/turf/sploded = locate(src.x + 1, src.y + 2, src.z)
		cell_explosion(sploded, 100, 20, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data("escape pod malfunction")) //Clears out walls
		sleep(25)
		mode = SHUTTLE_CRASHED
		for(var/obj/structure/machinery/cryopod/evacuation/cryotube in cryos)
			cryotube.go_out()
		door_handler.control_doors("force-unlock")
		return

	set_mode(SHUTTLE_IGNITING)
	on_ignition()
	setTimer(ignitionTime)
	launched = TRUE

/obj/docking_port/mobile/escape_shuttle/e
	id = ESCAPE_SHUTTLE_EAST
	width = 4
	height = 5

/obj/docking_port/mobile/escape_shuttle/cl
	id = ESCAPE_SHUTTLE_EAST_CL
	width = 4
	height = 5

/obj/docking_port/mobile/escape_shuttle/w
	id = ESCAPE_SHUTTLE_WEST
	width = 4
	height = 5

/obj/docking_port/mobile/escape_shuttle/n
	id = ESCAPE_SHUTTLE_NORTH
	width = 5
	height = 4

/obj/docking_port/mobile/escape_shuttle/s
	id = ESCAPE_SHUTTLE_SOUTH
	width = 5
	height = 4

/obj/docking_port/stationary/escape_pod
	name = "Escape Pod Dock"
	dir = NORTH

/obj/docking_port/stationary/escape_pod/west
	id = ESCAPE_SHUTTLE_WEST_PREFIX
	roundstart_template = /datum/map_template/shuttle/escape_pod_w
	width = 4
	height = 5

/obj/docking_port/stationary/escape_pod/east
	id = ESCAPE_SHUTTLE_EAST_PREFIX
	roundstart_template = /datum/map_template/shuttle/escape_pod_e
	width = 4
	height = 5

/obj/docking_port/stationary/escape_pod/north
	id = ESCAPE_SHUTTLE_NORTH_PREFIX
	roundstart_template = /datum/map_template/shuttle/escape_pod_n
	width = 5
	height = 4

/obj/docking_port/stationary/escape_pod/south
	id = ESCAPE_SHUTTLE_SOUTH_PREFIX
	roundstart_template = /datum/map_template/shuttle/escape_pod_s
	width = 5
	height = 4

/obj/docking_port/stationary/escape_pod/cl
	id = ESCAPE_SHUTTLE_SOUTH_PREFIX
	roundstart_template = /datum/map_template/shuttle/escape_pod_e_cl
	width = 4
	height = 5

/datum/map_template/shuttle/escape_pod_w
	name = "Escape Pod W"
	shuttle_id = ESCAPE_SHUTTLE_WEST

/datum/map_template/shuttle/escape_pod_e
	name = "Escape Pod E"
	shuttle_id = ESCAPE_SHUTTLE_EAST

/datum/map_template/shuttle/escape_pod_n
	name = "Escape Pod N"
	shuttle_id = ESCAPE_SHUTTLE_NORTH

/datum/map_template/shuttle/escape_pod_s
	name = "Escape Pod S"
	shuttle_id = ESCAPE_SHUTTLE_SOUTH

/datum/map_template/shuttle/escape_pod_e_cl
	name = "Escape Pod E CL"
	shuttle_id = ESCAPE_SHUTTLE_EAST_CL
