// === MOBILES

/// Generic Lifeboat definition
/obj/docking_port/mobile/lifeboat
	name = "lifeboat"
	area_type = /area/shuttle/lifeboat
	ignitionTime = 10 SECONDS
	width = 27
	height = 7

/// Port Aft Lifeboat (bottom-right, doors on its left side)
/obj/docking_port/mobile/lifeboat/port
	name = "port-aft lifeboat"
	id = "lifeboat1"
	preferred_direction = WEST
	port_direction = WEST

/// Starboard Aft Lifeboat (top-right, doors its right side)
/obj/docking_port/mobile/lifeboat/starboard
	name = "starboard-aft lifeboat"
	id = "lifeboat2"
	preferred_direction = EAST
	port_direction = EAST


// === STATIONARIES

/// Generic lifeboat dock
/obj/docking_port/stationary/lifeboat_dock
	name   = "Lifeboat docking port"
	width  = 27
	height = 7

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


/// Admin lifeboat dock temporary dest because someone mapped them in for some reason (use transit instead)
/obj/docking_port/stationary/lifeboat_dock/admin
	dir = NORTH
	id = "admin-lifeboat" // change this

// === SHUTTLE TEMPLATES FOR SPAWNING THEM

/// Port-door lifeboat, bow east
/datum/map_template/shuttle/lifeboat_port
	name = "Port door lifeboat"
	shuttle_id = "lifeboat-port"

/// Starboard-door lifeboat, bow east
/datum/map_template/shuttle/lifeboat_starboard
	name = "Starboard door lifeboat"
	shuttle_id = "lifeboat-starboard"


