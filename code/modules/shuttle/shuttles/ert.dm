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
	width = ERT_WIDTH
	height = ERT_HEIGHT

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
	width  = ERT_WIDTH
	height = ERT_HEIGHT

/obj/docking_port/stationary/emergency_response/port1
	name = "Almayer ERT1"
	dir = NORTH
	id = "almayer-ert1"
	roundstart_template = /datum/map_template/shuttle/ert1

/obj/docking_port/stationary/emergency_response/port2
	name = "Almayer ERT2"
	dir = NORTH
	id = "almayer-ert2"

/obj/docking_port/stationary/emergency_response/port3
	name = "Almayer ERT3"
	dir = NORTH
	id = "almayer-ert3"

// These are docking ports not on the almayer
/obj/docking_port/stationary/emergency_response/idle_port1
	name = "Base ERT1"
	dir = NORTH
	id = "base-ert1"

/obj/docking_port/stationary/emergency_response/idle_port2
	name = "Base ERT2"
	dir = NORTH
	id = "base-ert2"

/obj/docking_port/stationary/emergency_response/idle_port3
	name = "Base ERT3"
	dir = NORTH
	id = "base-ert3"

/datum/map_template/shuttle/ert1
	name = "ERT Shuttle 1"
	shuttle_id = "ert-shuttle-1"

/datum/map_template/shuttle/ert2
	name = "ERT Shuttle 2"
	shuttle_id = "ert-shuttle-2"

/datum/map_template/shuttle/ert3
	name = "ERT Shuttle 3"
	shuttle_id = "ert-shuttle-3"
