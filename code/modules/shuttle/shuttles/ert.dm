/*
	ERT Shuttles
*/

#define ERT_WIDTH 7
#define ERT_HEIGHT 13

// Base ERT Shuttle
/obj/docking_port/mobile/emergency_response
	name = "ERT Shuttle"
	ignitionTime = DROPSHIP_WARMUP_TIME
	area_type = /area/shuttle/ert
	width = 7
	height = 13
	var/list/doors = list()

/obj/docking_port/mobile/emergency_response/on_ignition()
	..()
	control_doors("close")
	control_doors("lock")

/obj/docking_port/mobile/emergency_response/proc/control_doors(var/action)
	for(var/i in doors)
		switch(action)
			if("open")
				INVOKE_ASYNC(i, /obj/structure/machinery/door/airlock.proc/open)
			if("close")
				INVOKE_ASYNC(i, /obj/structure/machinery/door/airlock.proc/close)
			if("lock")
				INVOKE_ASYNC(i, /obj/structure/machinery/door/airlock.proc/lock)
			if("unlock")
				INVOKE_ASYNC(i, /obj/structure/machinery/door/airlock.proc/unlock)

/obj/docking_port/mobile/emergency_response/on_prearrival()
	..()
	control_doors("unlock")

// ERT Shuttle 1
/obj/docking_port/mobile/emergency_response/ert1
	name = "ERT Shuttle 1"
	id = "ert1"
	preferred_direction = NORTH
	port_direction = NORTH

// ERT Shuttle 2
/obj/docking_port/mobile/emergency_response/ert2
	name = "ERT Shuttle 2"
	id = "ert2"
	preferred_direction = NORTH
	port_direction = NORTH

// ERT Shuttle 3
/obj/docking_port/mobile/emergency_response/ert3
	name = "ERT Shuttle 3"
	id = "ert3"
	preferred_direction = NORTH
	port_direction = NORTH

// Generic ERT Dock
/obj/docking_port/stationary/emergency_response
	name   = "ERT docking port"
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

/obj/docking_port/stationary/transit/emergency_response/ert1
	dir = NORTH
	id = "transit-ert-1"

/obj/docking_port/stationary/transit/emergency_response/ert2
	dir = NORTH
	id = "transit-ert-2"

// These are docking ports not on the almayer
/obj/docking_port/stationary/emergency_response/idle_port1
	name = "Base ERT1"
	dir = NORTH
	id = "base-ert1"
	roundstart_template = /datum/map_template/shuttle/ert1

/obj/docking_port/stationary/emergency_response/idle_port2
	name = "Base ERT2"
	dir = NORTH
	id = "base-ert2"
	roundstart_template = /datum/map_template/shuttle/ert2

/obj/docking_port/stationary/emergency_response/idle_port3
	name = "Base ERT3"
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

