#define CRASH_LAND_PROBABILITY 50

/obj/docking_port/mobile/escape_shuttle
	name = "Escape Pod"
	id = ESCAPE_SHUTTLE
	area_type = /area/shuttle/escape_pod
	width = 4
	height = 5
	preferred_direction = SOUTH
	rechargeTime = SHUTTLE_RECHARGE
	ignitionTime = 8 SECONDS
	ignition_sound = 'sound/effects/escape_pod_warmup.ogg'

	var/datum/door_controller/single/door_handler = new()
	var/launched = FALSE
	var/crash_land = FALSE
	var/evac_set = FALSE

/obj/docking_port/mobile/escape_shuttle/Initialize(mapload)
	. = ..(mapload)
	for(var/place in shuttle_areas)
		for(var/obj/structure/machinery/door/air in place)
			door_handler.doors += list(air)
			air.breakable = FALSE
			air.indestructible = TRUE
			air.unacidable = TRUE

/obj/docking_port/mobile/escape_shuttle/proc/cancel_evac()
	door_handler.control_doors("force-unlock")
	evac_set = FALSE

	var/obj/structure/machinery/computer/shuttle/escape_pod_panel/panel = getControlConsole()
	if(panel.pod_state != STATE_READY && panel.pod_state != STATE_DELAYED)
		return
	panel.pod_state = STATE_IDLE
	for(var/area/interior_area in shuttle_areas)
		for(var/obj/structure/machinery/cryopod/evacuation/cryotube in interior_area)
			cryotube.dock_state = STATE_IDLE

/obj/docking_port/mobile/escape_shuttle/proc/prepare_evac()
	door_handler.control_doors("force-unlock")
	evac_set = TRUE
	for(var/area/interior_area in shuttle_areas)
		for(var/obj/structure/machinery/cryopod/evacuation/cryotube in interior_area)
			cryotube.dock_state = STATE_READY

/obj/docking_port/mobile/escape_shuttle/proc/evac_launch()
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
			cryos += list(cryotube)
	if (occupant_count > 3)
		playsound(src,'sound/effects/escape_pod_warmup.ogg', 50, 1)
		sleep(31)
		var/turf/sploded = return_center_turf()
		cell_explosion(sploded, 100, 20, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data("escape pod malfunction")) //Clears out walls
		sleep(25)
		mode = SHUTTLE_CRASHED
		for(var/obj/structure/machinery/cryopod/evacuation/cryotube in cryos)
			cryotube.go_out()
		door_handler.control_doors("force-unlock")
		return

	if(prob(CRASH_LAND_PROBABILITY))
		create_crash_point()
	else
		destination = null

	set_mode(SHUTTLE_IGNITING)
	on_ignition()
	setTimer(ignitionTime)
	launched = TRUE

/obj/docking_port/mobile/escape_shuttle/proc/create_crash_point()

	var/ground_z_level

	var/z_level_index = 1
	for(var/datum/space_level/level in SSmapping.z_list)
		if(ZTRAIT_GROUND in level.traits)
			ground_z_level = z_level_index
			break
		z_level_index++

	var/list/potential_areas = SSmapping.areas_in_z[SSmapping.areas_in_z[ground_z_level]]

	var/area/area_picked = potential_areas[rand(1, potential_areas.len)]

	var/list/potential_turfs = list()

	for(var/turf/turf_in_area in area_picked.contents)
		potential_turfs += turf_in_area

	if(!potential_turfs.len)
		destination = null
		return

	var/turf/turf_picked = potential_turfs[rand(1, potential_turfs.len)]

	var/obj/docking_port/stationary/escape_pod/crash_land/temp_escape_pod_port = new(turf_picked)
	temp_escape_pod_port.width = width
	temp_escape_pod_port.height = height
	temp_escape_pod_port.id = id

	destination = temp_escape_pod_port

	crash_land = TRUE

/obj/docking_port/mobile/escape_shuttle/enterTransit()
	. = ..()

	if(!crash_land)
		return

	for(var/x_offset = 0 to destination.width)
		for(var/y_offset = 0 to destination.height)
			var/turf/closed/wall/found_turf = locate(destination.x + x_offset, destination.y + y_offset, destination.z)
			if(istype(found_turf) && found_turf.hull)
				qdel(found_turf)

	cell_explosion(destination.return_center_turf(), 250, 25, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data("evac pod crash"))

/obj/docking_port/mobile/escape_shuttle/on_prearrival()
	. = ..()

	if(!crash_land)
		return

	movement_force = list("KNOCKDOWN" = 0, "THROW" = 5)

	for(var/mob/evac_mob in shuttle_areas[1])
		shake_camera(evac_mob, 20, 2)

	door_handler.control_doors("force-unlock")

/obj/docking_port/mobile/escape_shuttle/afterShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir, rotation)
	. = ..()
	playsound(src,'sound/effects/escape_pod_launch.ogg', 50, 1)

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

/obj/docking_port/stationary/escape_pod/crash_land
	name = "Crash Escape Pod Dock"

/obj/docking_port/stationary/escape_pod/crash_land/on_arrival(obj/docking_port/mobile/arriving_shuttle)
	. = ..()

	if(istype(arriving_shuttle, /obj/docking_port/mobile/escape_shuttle))
		var/obj/docking_port/mobile/escape_shuttle/escape_shuttle = arriving_shuttle
		escape_shuttle.door_handler.control_doors("force-unlock")

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


#undef CRASH_LAND_PROBABILITY
