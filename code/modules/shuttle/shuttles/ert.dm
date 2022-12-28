/*
	ERT Shuttles
*/

#define ERT_SHUTTLE_DEFAULT_CALLTIME 30 SECONDS
#define ERT_SHUTTLE_DEFAULT_RECHARGE 90 SECONDS

#define ADMIN_LANDING_PAD_1 "base-ert1"
#define ADMIN_LANDING_PAD_2 "base-ert2"
#define ADMIN_LANDING_PAD_3 "base-ert3"

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
	control_doors("force-lock-launch")
	..()

/obj/docking_port/mobile/emergency_response/proc/control_doors(var/action)
	for(var/door in doors)
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

/datum/map_template/shuttle/response_ert
	name = "ERT Shuttle 1"
	shuttle_id = "ert_response_shuttle"

/datum/map_template/shuttle/pmc_ert
	name = "ERT Shuttle 2"
	shuttle_id = "ert_pmc_shuttle"

/datum/map_template/shuttle/upp_ert
	name = "ERT Shuttle 3"
	shuttle_id = "ert_upp_shuttle"

