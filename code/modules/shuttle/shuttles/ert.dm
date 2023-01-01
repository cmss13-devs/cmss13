/*
	ERT Shuttles
*/

#define ERT_SHUTTLE_DEFAULT_CALLTIME 30 SECONDS
#define ERT_SHUTTLE_DEFAULT_RECHARGE 90 SECONDS

#define ADMIN_LANDING_PAD_1 "base-ert1"
#define ADMIN_LANDING_PAD_2 "base-ert2"
#define ADMIN_LANDING_PAD_3 "base-ert3"
#define ADMIN_LANDING_PAD_4 "base-ert4"

// Base ERT Shuttle
/obj/docking_port/mobile/emergency_response
	name = "ERT Shuttle"
	ignitionTime = DROPSHIP_WARMUP_TIME
	area_type = /area/shuttle/ert
	width = 7
	height = 13
	callTime = ERT_SHUTTLE_DEFAULT_CALLTIME // 30s flight time
	rechargeTime = ERT_SHUTTLE_DEFAULT_RECHARGE // 90s cooldown to recharge
	var/list/doors = list()

/obj/docking_port/mobile/emergency_response/Initialize(mapload)
	. = ..(mapload)
	for(var/place in shuttle_areas)
		for(var/obj/structure/machinery/door/airlock/air in place)
			doors += list(air)
			air.breakable = FALSE
			air.indestructible = TRUE
			air.unacidable = TRUE

/obj/docking_port/mobile/emergency_response/enterTransit()
	control_doors("force-lock-launch", force = TRUE)
	..()

/obj/docking_port/mobile/emergency_response/proc/control_doors(var/action, var/force = FALSE)
	for(var/D in doors)
		var/obj/structure/machinery/door/door = D
		var/is_external = door.borders_space()
		if(!force && is_external)
			world.log << "door [door] [force] [is_external]"
			continue
		switch(action)
			if("open")
				INVOKE_ASYNC(door, TYPE_PROC_REF(/obj/structure/machinery/door/airlock, open))
			if("close")
				INVOKE_ASYNC(door, TYPE_PROC_REF(/obj/structure/machinery/door/airlock, close))
			if("force-lock")
				INVOKE_ASYNC(src, PROC_REF(lockdown_door), door)
			if("lock")
				INVOKE_ASYNC(door, TYPE_PROC_REF(/obj/structure/machinery/door/airlock, lock))
			if("unlock")
				INVOKE_ASYNC(door, TYPE_PROC_REF(/obj/structure/machinery/door/airlock, unlock))
			if("force-lock-launch")
				INVOKE_ASYNC(src, PROC_REF(lockdown_door_launch), door)

/obj/docking_port/mobile/emergency_response/proc/lockdown_door_launch(var/obj/structure/machinery/door/airlock/air)
	for(var/mob/blocking_mob in air.loc) // Bump all mobs outta the way for outside airlocks of shuttles
		if(isliving(blocking_mob))
			to_chat(blocking_mob, SPAN_HIGHDANGER("You get thrown back as the dropship doors slam shut!"))
			blocking_mob.apply_effect(4, WEAKEN)
			for(var/turf/target_turf in orange(1, air)) // Forcemove to a non shuttle turf
				if(!istype(target_turf, /turf/open/shuttle) && !istype(target_turf, /turf/closed/shuttle))
					blocking_mob.forceMove(target_turf)
					break
	lockdown_door(air)

/obj/docking_port/mobile/emergency_response/proc/lockdown_door(var/obj/structure/machinery/door/airlock/air)
	air.safe = 0
	air.unlock()
	air.close()
	air.lock()
	air.safe = 1

/obj/docking_port/mobile/emergency_response/setDir(newdir)
	. = ..()
	for(var/obj/structure/machinery/door/shuttle_door in doors)
		shuttle_door.handle_multidoor()

// ERT Shuttle 1
/obj/docking_port/mobile/emergency_response/ert1
	name = "Response Shuttle"
	id = MOBILE_SHUTTLE_ID_ERT1
	preferred_direction = SOUTH
	port_direction = NORTH

// ERT Shuttle 2
/obj/docking_port/mobile/emergency_response/ert2
	name = "PMC Shuttle"
	id = MOBILE_SHUTTLE_ID_ERT2
	preferred_direction = SOUTH
	port_direction = NORTH

// ERT Shuttle 3
/obj/docking_port/mobile/emergency_response/ert3
	name = "UPP Shuttle"
	id = MOBILE_SHUTTLE_ID_ERT3
	preferred_direction = SOUTH
	port_direction = NORTH

// ERT Shuttle 3
/obj/docking_port/mobile/emergency_response/small
	name = "Rescue Shuttle"
	id = MOBILE_SHUTTLE_ID_ERT_SMALL
	preferred_direction = SOUTH
	port_direction = NORTH
	width = 6
	height = 9
	var/port_door
	var/starboard_door

/obj/docking_port/mobile/emergency_response/small/Initialize(mapload)
	. = ..()
	doors = list()
	for(var/place in shuttle_areas)
		for(var/obj/structure/machinery/door/airlock/multi_tile/air in place)
			doors += list(air)
			air.breakable = FALSE
			air.indestructible = TRUE
			air.unacidable = TRUE
			if(air.id == "starboard_door")
				starboard_door = air
			else if(air.id == "port_door")
				port_door = air
	if(!port_door)
		WARNING("No port door found for [src]")
	if(!starboard_door)
		WARNING("No starboard door found for [src]")

// Generic ERT Dock
/obj/docking_port/stationary/emergency_response
	width  = 7
	height = 13

/obj/docking_port/stationary/emergency_response/port1
	name = "Almayer starboard landing pad"
	dir = NORTH
	id = "almayer-ert1"


/obj/docking_port/stationary/emergency_response/port2
	name = "Almayer port landing pad"
	dir = NORTH
	id = "almayer-ert2"

/obj/docking_port/stationary/emergency_response/port3
	name = "Almayer stern landing pad"
	dir = NORTH
	id = "almayer-ert3"

/obj/docking_port/stationary/emergency_response/external
	var/airlock_id
	var/airlock_area
	var/external_airlocks = list()

/obj/docking_port/stationary/emergency_response/external/Initialize(mapload)
	. = ..()
	for(var/area/target_area in world)
		if(istype(target_area, airlock_area))
			world.log << "made it [target_area]"
			for(var/obj/structure/machinery/door/door in target_area)
				world.log << "door [door] [door.id] [airlock_id]"
				if(door.id == airlock_id)
					world.log << "MATCH"
					external_airlocks += list(door)
	if(!length(external_airlocks))
		WARNING("No external airlocks for [src]")

/obj/docking_port/stationary/emergency_response/external/on_arrival(obj/docking_port/mobile/arriving_shuttle)
	for(var/door in external_airlocks)
		INVOKE_ASYNC(door, TYPE_PROC_REF(/obj/structure/machinery/door, open))

/obj/docking_port/stationary/emergency_response/external/on_departure(obj/docking_port/mobile/departing_shuttle)
	for(var/door in external_airlocks)
		INVOKE_ASYNC(door, TYPE_PROC_REF(/obj/structure/machinery/door, close))

/obj/docking_port/stationary/emergency_response/external/port4
	name = "Almayer port external airlock"
	dir = EAST
	id = "almayer-ert4"
	width  = 6
	height = 9
	airlock_id = "s_engi_ext"
	airlock_area = /area/almayer/engineering/upper_engineering/notunnel

/obj/docking_port/stationary/emergency_response/external/port5
	name = "Almayer starboard external airlock"
	dir = EAST
	id = "almayer-ert5"
	width  = 6
	height = 9
	airlock_id = "n_engi_ext"
	airlock_area = /area/almayer/engineering/upper_engineering/notunnel

// These are docking ports not on the almayer
/obj/docking_port/stationary/emergency_response/idle_port1
	name = "Response Station Landing Pad 1"
	dir = NORTH
	id = ADMIN_LANDING_PAD_1
	roundstart_template = /datum/map_template/shuttle/response_ert

/obj/docking_port/stationary/emergency_response/idle_port2
	name = "Response Station Landing Pad 2"
	dir = NORTH
	id = ADMIN_LANDING_PAD_2
	roundstart_template = /datum/map_template/shuttle/pmc_ert

/obj/docking_port/stationary/emergency_response/idle_port3
	name = "Response Station Landing Pad 3"
	dir = NORTH
	id = ADMIN_LANDING_PAD_3
	roundstart_template = /datum/map_template/shuttle/upp_ert

/obj/docking_port/stationary/emergency_response/idle_port4
	name = "Response Station Landing Pad 4"
	dir = EAST
	id = ADMIN_LANDING_PAD_4
	width  = 6
	height = 9
	roundstart_template = /datum/map_template/shuttle/small_ert

/datum/map_template/shuttle/response_ert
	name = "ERT Shuttle 1"
	shuttle_id = "ert_response_shuttle"

/datum/map_template/shuttle/pmc_ert
	name = "ERT Shuttle 2"
	shuttle_id = "ert_pmc_shuttle"

/datum/map_template/shuttle/upp_ert
	name = "ERT Shuttle 3"
	shuttle_id = "ert_upp_shuttle"

/datum/map_template/shuttle/small_ert
	name = "ERT Shuttle 4"
	shuttle_id = "ert_small_shuttle_north"
