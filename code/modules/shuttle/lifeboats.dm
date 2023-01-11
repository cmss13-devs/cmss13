// === MOBILES

/// Generic Lifeboat definition
/obj/docking_port/mobile/lifeboat
	name = "lifeboat"
	area_type = /area/shuttle/lifeboat
	ignitionTime = 10 SECONDS
	width = 27
	height = 7
	var/available = TRUE // can be used for evac? false if queenlocked or if in transit already
	var/status = LIFEBOAT_INACTIVE // -1 queen locked, 0 locked til evac, 1 working
	var/list/doors = list()
	var/survivors = 0

/obj/docking_port/mobile/lifeboat/proc/check_for_survivors()
	for(var/mob/living/carbon/human/survived_human as anything in GLOB.alive_human_list) //check for lifeboats survivors
		var/area/area = get_area(survived_human)
		if(!survived_human)
			continue
		if(survived_human.stat != DEAD && (area in shuttle_areas))
			var/turf/turf = get_turf(survived_human)
			if(!turf || is_mainship_level(turf.z))
				continue
			survivors++
			to_chat(survived_human, "<br><br>[SPAN_CENTERBOLD("<big>You have successfully left the [MAIN_SHIP_NAME]. You may now ghost and observe the rest of the round.</big>")]<br>")

/// Port Aft Lifeboat (bottom-right, doors on its left side)
/obj/docking_port/mobile/lifeboat/port
	name = "port-aft lifeboat"
	id = MOBILE_SHUTTLE_LIFEBOAT_PORT
	preferred_direction = WEST
	port_direction = WEST

/// Starboard Aft Lifeboat (top-right, doors its right side)
/obj/docking_port/mobile/lifeboat/starboard
	name = "starboard-aft lifeboat"
	id = MOBILE_SHUTTLE_LIFEBOAT_STARBOARD
	preferred_direction = EAST
	port_direction = EAST

/obj/docking_port/mobile/lifeboat/proc/send_to_infinite_transit()
	available = FALSE
	destination = null
	set_mode(SHUTTLE_IGNITING)
	on_ignition()
	setTimer(ignitionTime)

// === STATIONARIES

/// Generic lifeboat dock
/obj/docking_port/stationary/lifeboat_dock
	name   = "Lifeboat docking port"
	width  = 27
	height = 7

/obj/docking_port/stationary/lifeboat_dock/on_dock_ignition(departing_shuttle)
	var/obj/docking_port/mobile/lifeboat/lifeboat = departing_shuttle
	if(istype(lifeboat))
		for(var/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/door in lifeboat.doors)
			INVOKE_ASYNC(door, TYPE_PROC_REF(/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat, close_and_lock))

	for(var/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/blastdoor/blastdoor as anything in GLOB.lifeboat_doors)
		if(blastdoor.linked_dock == id)
			addtimer(CALLBACK(blastdoor, TYPE_PROC_REF(/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat, close_and_lock)), 10)
			addtimer(CALLBACK(blastdoor, TYPE_PROC_REF(/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/blastdoor, bolt_explosion)), 75)

/obj/docking_port/stationary/lifeboat_dock/on_departure(obj/docking_port/mobile/departing_shuttle)
	. = ..()
	for(var/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/blastdoor/blastdoor as anything in GLOB.lifeboat_doors)
		if(blastdoor.linked_dock == id)
			blastdoor.vacate_premises()

/obj/docking_port/stationary/lifeboat_dock/proc/open_dock()
	var/obj/docking_port/mobile/lifeboat/docked_shuttle = get_docked()
	if(docked_shuttle)
		for(var/obj/structure/machinery/door/airlock/multi_tile/door in docked_shuttle.doors)
			INVOKE_ASYNC(door, TYPE_PROC_REF(/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat, unlock_and_open))

	for(var/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/blastdoor/blastdoor as anything in GLOB.lifeboat_doors)
		if(blastdoor.linked_dock == id)
			addtimer(CALLBACK(blastdoor, TYPE_PROC_REF(/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat, unlock_and_open)), 10)

/obj/docking_port/stationary/lifeboat_dock/proc/close_dock()
	var/obj/docking_port/mobile/lifeboat/docked_shuttle = get_docked()
	if(docked_shuttle)
		for(var/obj/structure/machinery/door/airlock/multi_tile/door in docked_shuttle.doors)
			INVOKE_ASYNC(door, TYPE_PROC_REF(/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat, close_and_lock))

	for(var/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat/blastdoor/blastdoor as anything in GLOB.lifeboat_doors)
		if(blastdoor.linked_dock == id)
			addtimer(CALLBACK(blastdoor, TYPE_PROC_REF(/obj/structure/machinery/door/airlock/multi_tile/almayer/dropshiprear/lifeboat, close_and_lock)), 10)


/// Port Aft Lifeboat default dock
/obj/docking_port/stationary/lifeboat_dock/port
	name = "Almayer Port Lifeboat Docking Port"
	dir = NORTH
	id = "almayer-lifeboat1"
	roundstart_template = /datum/map_template/shuttle/lifeboat_port

/// Port Aft Lifeboat default dock
/obj/docking_port/stationary/lifeboat_dock/starboard
	name = "Almayer Starboard Lifeboat Docking Port"
	dir = NORTH
	id = "almayer-lifeboat2"
	roundstart_template = /datum/map_template/shuttle/lifeboat_starboard

/obj/docking_port/stationary/lifeboat_dock/Initialize(mapload)
	. = ..()
	GLOB.lifeboat_almayer_docks += src

/obj/docking_port/stationary/lifeboat_dock/Destroy(force)
	if (force)
		GLOB.lifeboat_almayer_docks -= src
	return ..()


/// Admin lifeboat dock temporary dest because someone mapped them in for some reason (use transit instead)
/obj/docking_port/stationary/lifeboat_dock/admin
	dir = NORTH
	id = "admin-lifeboat" // change this

// === SHUTTLE TEMPLATES FOR SPAWNING THEM

/// Port-door lifeboat, bow east
/datum/map_template/shuttle/lifeboat_port
	name = "Port door lifeboat"
	shuttle_id = MOBILE_SHUTTLE_LIFEBOAT_PORT

/// Starboard-door lifeboat, bow east
/datum/map_template/shuttle/lifeboat_starboard
	name = "Starboard door lifeboat"
	shuttle_id = MOBILE_SHUTTLE_LIFEBOAT_STARBOARD


