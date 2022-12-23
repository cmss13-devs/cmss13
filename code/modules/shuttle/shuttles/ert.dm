/*
	ERT Shuttles
*/

#define ERT_SHUTTLE_DEFAULT_CALLTIME 300
#define ERT_SHUTTLE_DEFAULT_RECHARGE 900

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
	. = ..()
	for(var/place in shuttle_areas)
		for(var/obj/structure/machinery/door/airlock/air in place)
			doors += list(air)

/obj/docking_port/mobile/emergency_response/enterTransit()
	control_doors("force-lock")
	..()

/obj/docking_port/mobile/emergency_response/proc/control_doors(var/action)
	for(var/i in doors)
		switch(action)
			if("open")
				INVOKE_ASYNC(i, /obj/structure/machinery/door/airlock.proc/open)
			if("close")
				INVOKE_ASYNC(i, /obj/structure/machinery/door/airlock.proc/close)
			if("force-lock")
				INVOKE_ASYNC(src, .proc/lockdown_door, i)
			if("lock")
				INVOKE_ASYNC(i, /obj/structure/machinery/door/airlock.proc/lock)
			if("unlock")
				INVOKE_ASYNC(i, /obj/structure/machinery/door/airlock.proc/unlock)

/obj/docking_port/mobile/emergency_response/proc/lockdown_door(var/obj/structure/machinery/door/airlock/air)
	air.safe=0
	air.unlock()
	air.close()
	air.lock()
	air.safe=1

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
	id = "base-ert1"
	roundstart_template = /datum/map_template/shuttle/ert1

/obj/docking_port/stationary/emergency_response/idle_port2
	name = "Response Station Landing Pad 2"
	dir = NORTH
	id = "base-ert2"
	roundstart_template = /datum/map_template/shuttle/ert2

/obj/docking_port/stationary/emergency_response/idle_port3
	name = "Response Station Landing Pad 3"
	dir = NORTH
	id = "base-ert3"
	roundstart_template = /datum/map_template/shuttle/ert3

/datum/map_template/shuttle/ert1
	name = "ERT Shuttle 1"
	shuttle_id = "ert_shuttle_1"

/datum/map_template/shuttle/ert2
	name = "ERT Shuttle 2"
	shuttle_id = "ert_shuttle_2"

/datum/map_template/shuttle/ert3
	name = "ERT Shuttle 3"
	shuttle_id = "ert_shuttle_3"

