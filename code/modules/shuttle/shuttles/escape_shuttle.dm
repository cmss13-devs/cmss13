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
	/// The % chance of the escape pod crashing into the groundmap
	var/early_crash_land_chance = 75
	var/crash_land_chance = 25

	var/datum/door_controller/single/door_handler = new()
	var/launched = FALSE
	var/crash_land = FALSE
	var/evac_set = FALSE

/obj/docking_port/mobile/escape_shuttle/Initialize(mapload)
	. = ..(mapload)
	for(var/place in shuttle_areas)
		for(var/obj/structure/machinery/door/airlock/evacuation/air in place)
			door_handler.doors += list(air)
			air.breakable = FALSE
			air.indestructible = TRUE
			air.unacidable = TRUE
			air.linked_shuttle = src

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
	for(var/obj/structure/machinery/door/air in door_handler.doors)
		air.breakable = TRUE
		air.indestructible = FALSE
		air.unslashable = FALSE
		air.unacidable = FALSE


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

	destination = null
	if(prob((EvacuationAuthority.evac_status >= EVACUATION_STATUS_IN_PROGRESS ? crash_land_chance : early_crash_land_chance)))
		create_crash_point()

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
			air.indestructible = TRUE
			air.unacidable = TRUE


/obj/docking_port/mobile/escape_shuttle/proc/create_crash_point()
	for(var/i = 1 to 10)
		var/list/all_ground_levels = SSmapping.levels_by_trait(ZTRAIT_GROUND)
		var/ground_z_level = all_ground_levels[1]

		var/list/area/potential_areas = SSmapping.areas_in_z["[ground_z_level]"]

		var/area/area_picked = pick(potential_areas)

		var/list/potential_turfs = list()

		for(var/turf/turf_in_area in area_picked)
			potential_turfs += turf_in_area

		if(!length(potential_turfs))
			continue

		var/turf/turf_picked = pick(potential_turfs)

		var/obj/docking_port/stationary/escape_pod/crash_land/temp_escape_pod_port = new(turf_picked)
		temp_escape_pod_port.width = width
		temp_escape_pod_port.height = height
		temp_escape_pod_port.id = id

		if(!check_crash_point(temp_escape_pod_port))
			qdel(temp_escape_pod_port)
			continue

		destination = temp_escape_pod_port
		break

	if(destination)
		crash_land = TRUE

/obj/docking_port/mobile/escape_shuttle/proc/check_crash_point(obj/docking_port/stationary/escape_pod/crash_land/checked_escape_pod_port)
	for(var/turf/found_turf as anything in checked_escape_pod_port.return_turfs())
		var/area/found_area = get_area(found_turf)
		if(found_area.flags_area & AREA_NOTUNNEL)
			return FALSE

		if(!found_area.can_build_special)
			return FALSE

		if(istype(found_turf, /turf/closed/wall))
			var/turf/closed/wall/found_closed_turf = found_turf
			if(found_closed_turf.hull)
				return FALSE

		if(istype(found_turf, /turf/closed/shuttle))
			return FALSE

	return TRUE

/obj/docking_port/mobile/escape_shuttle/enterTransit()
	. = ..()

	if(!crash_land)
		return

	for(var/area/shuttle_area in shuttle_areas)
		shuttle_area.flags_alarm_state |= ALARM_WARNING_FIRE
		shuttle_area.updateicon()
		for(var/mob/evac_mob in shuttle_area)
			if(evac_mob.client)
				playsound_client(evac_mob.client, 'sound/effects/bomb_fall.ogg', vol = 50)

	for(var/turf/found_turf as anything in destination.return_turfs())
		if(istype(found_turf, /turf/closed))
			found_turf.ChangeTurf(/turf/open/floor)

	cell_explosion(destination.return_center_turf(), 300, 25, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, create_cause_data("evac pod crash"))

/obj/docking_port/mobile/escape_shuttle/on_prearrival()
	. = ..()

	if(!crash_land)
		return

	movement_force = list("KNOCKDOWN" = 0, "THROW" = 5)

	for(var/area/shuttle_area in shuttle_areas)
		for(var/mob/evac_mob in shuttle_area)
			shake_camera(evac_mob, 20, 2)
			if(evac_mob.client)
				playsound_client(evac_mob.client, get_sfx("bigboom"), vol = 50)

	door_handler.control_doors("force-unlock")

/obj/docking_port/mobile/escape_shuttle/afterShuttleMove(turf/oldT, list/movement_force, shuttle_dir, shuttle_preferred_direction, move_dir, rotation)
	. = ..()
	playsound(src,'sound/effects/escape_pod_launch.ogg', 50, 1)

/obj/docking_port/mobile/escape_shuttle/proc/force_crash()
	create_crash_point()
	set_mode(SHUTTLE_IGNITING)
	on_ignition()
	setTimer(ignitionTime)

/obj/docking_port/mobile/escape_shuttle/e
	id = ESCAPE_SHUTTLE_EAST
	width = 4
	height = 5

/obj/docking_port/mobile/escape_shuttle/cl
	id = ESCAPE_SHUTTLE_EAST_CL
	width = 4
	height = 5
	early_crash_land_chance = 25
	crash_land_chance = 5

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

	for(var/area/shuttle_area in arriving_shuttle.shuttle_areas)
		shuttle_area.update_base_lighting()

		shuttle_area.flags_alarm_state &= ~ALARM_WARNING_FIRE
		shuttle_area.updateicon()

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
