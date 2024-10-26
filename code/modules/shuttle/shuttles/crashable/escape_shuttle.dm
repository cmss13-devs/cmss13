/obj/docking_port/mobile/crashable/escape_shuttle
	name = "Escape Pod"
	id = ESCAPE_SHUTTLE
	area_type = /area/shuttle/escape_pod
	width = 4
	height = 5
	preferred_direction = SOUTH
	rechargeTime = SHUTTLE_RECHARGE
	ignitionTime = 8 SECONDS
	ignition_sound = 'sound/effects/escape_pod_warmup.ogg'
	/// The % chance of the escape pod crashing into the groundmap before lifeboats leaving
	var/early_crash_land_chance = 75
	/// The % chance of the escape pod crashing into the groundmap
	var/crash_land_chance = 0
	/// How many people can be in the escape pod before it crashes
	var/max_capacity = 3

	var/datum/door_controller/single/door_handler = new()
	var/launched = FALSE
	var/evac_set = FALSE

/obj/docking_port/mobile/crashable/escape_shuttle/Initialize(mapload)
	. = ..(mapload)
	for(var/place in shuttle_areas)
		for(var/obj/structure/machinery/door/airlock/evacuation/air in place)
			door_handler.doors += list(air)
			air.breakable = FALSE
			air.explo_proof = TRUE
			air.unacidable = TRUE
			air.linked_shuttle = src

/obj/docking_port/mobile/crashable/escape_shuttle/proc/cancel_evac()
	door_handler.control_doors("force-unlock")
	evac_set = FALSE

	var/obj/structure/machinery/computer/shuttle/escape_pod_panel/panel = getControlConsole()
	if(panel.pod_state != STATE_READY && panel.pod_state != STATE_DELAYED)
		return
	panel.pod_state = STATE_IDLE
	for(var/area/interior_area in shuttle_areas)
		for(var/obj/structure/machinery/cryopod/evacuation/cryotube in interior_area)
			cryotube.dock_state = STATE_IDLE

/obj/docking_port/mobile/crashable/escape_shuttle/proc/prepare_evac()
	door_handler.control_doors("force-unlock")
	evac_set = TRUE
	for(var/area/interior_area in shuttle_areas)
		for(var/obj/structure/machinery/cryopod/evacuation/cryotube in interior_area)
			cryotube.dock_state = STATE_READY
	for(var/obj/structure/machinery/door/air in door_handler.doors)
		air.breakable = TRUE
		air.explo_proof = FALSE
		air.unslashable = FALSE
		air.unacidable = FALSE

/obj/docking_port/mobile/crashable/escape_shuttle/evac_launch()
	. = ..()

	if(mode == SHUTTLE_CRASHED)
		return

	if(launched)
		return

	var/obj/structure/machinery/computer/shuttle/escape_pod_panel/panel = getControlConsole()
	if(panel.pod_state == STATE_DELAYED)
		return

	door_handler.control_doors("force-lock-launch")
	var/occupant_count = 0
	var/list/cryos = list()
	for(var/area/interior_area in shuttle_areas)
		for(var/mob/living/occupant in interior_area)
			occupant_count++
		for(var/obj/structure/machinery/cryopod/evacuation/cryotube in interior_area)
			if(cryotube.occupant)
				occupant_count++
			cryos += list(cryotube)
	if (occupant_count > max_capacity)
		playsound(src,'sound/effects/escape_pod_warmup.ogg', 50, 1)
		mode = SHUTTLE_CRASHED
		sleep(31)
		var/turf/sploded = return_center_turf()
		cell_explosion(sploded, 100, 20, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data("escape pod malfunction")) //Clears out walls
		sleep(25)
		for(var/obj/structure/machinery/cryopod/evacuation/cryotube in cryos)
			cryotube.go_out()
		door_handler.control_doors("force-unlock")
		return

	set_mode(SHUTTLE_IGNITING)
	on_ignition()
	setTimer(ignitionTime)
	launched = TRUE

	if(!crash_land) // so doors won't break in space
		for(var/obj/structure/machinery/door/air in door_handler.doors)
			for(var/obj/effect/xenomorph/acid/acid in air.loc)
				if(acid.acid_t == air)
					qdel(acid)
			air.breakable = FALSE
			air.explo_proof = TRUE
			air.unacidable = TRUE

/obj/docking_port/mobile/crashable/escape_shuttle/crash_check()
	. = ..()

	if(prob((SShijack.hijack_status >= HIJACK_OBJECTIVES_COMPLETE ? crash_land_chance : early_crash_land_chance)))
		return TRUE

/obj/docking_port/mobile/crashable/escape_shuttle/open_doors()
	. = ..()

	door_handler.control_doors("force-unlock")

/obj/docking_port/mobile/crashable/escape_shuttle/afterShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir, rotation)
	. = ..()
	playsound(src,'sound/effects/escape_pod_launch.ogg', 50, 1)

/obj/docking_port/mobile/crashable/escape_shuttle/e
	id = ESCAPE_SHUTTLE_EAST
	width = 4
	height = 5

/obj/docking_port/mobile/crashable/escape_shuttle/cl
	id = ESCAPE_SHUTTLE_EAST_CL
	width = 4
	height = 5
	early_crash_land_chance = 0
	crash_land_chance = 0

/obj/docking_port/mobile/crashable/escape_shuttle/w
	id = ESCAPE_SHUTTLE_WEST
	width = 4
	height = 5

/obj/docking_port/mobile/crashable/escape_shuttle/n
	id = ESCAPE_SHUTTLE_NORTH
	width = 5
	height = 4

/obj/docking_port/mobile/crashable/escape_shuttle/s
	id = ESCAPE_SHUTTLE_SOUTH
	width = 5
	height = 4

/obj/docking_port/stationary/escape_pod
	name = "Escape Pod Dock"

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
