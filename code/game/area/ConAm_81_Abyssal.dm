//Abyssal Areas--------------------------------------//

/area/abyssal
	name = "Con-Am 81 'Abyssal'"
	icon = 'icons/turf/area_prison_v3_fiorina.dmi'
	icon_state = "fiorina"
	can_build_special = TRUE
	temperature = T20C
	powernet_name = "ground"
	ceiling = CEILING_GLASS
	minimap_color = MINIMAP_AREA_COLONY
	ceiling_muffle = FALSE

//parent types

/area/abyssal/interior
	name = "Abyssal - Interior"
	icon_state = "base_icon"
	soundscape_playlist = SCAPE_ABYSSAL_INTERIOR
	ambience_exterior = AMBIENCE_ALMAYER
	soundscape_interval = 45

/area/abyssal/exterior
	name = "Abyssal - Exterior"
	icon_state = "base_icon"
	ceiling = CEILING_NONE
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL|AREA_CONTAINMENT
	requires_power = FALSE
	ambience_exterior = SCAPE_ABYSSAL_EXTERIOR
	minimap_color = MINIMAP_AREA_GLASS
	temperature = TCMB
	pressure = 0
	always_unpowered = 1
	base_lighting_alpha = 255

/area/abyssal/oob
	name = "Out Of Bounds"
	icon_state = "oob"
	ceiling = CEILING_MAX
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL
	ambience_exterior = SCAPE_ABYSSAL_EXTERIOR
	minimap_color = MINIMAP_AREA_SPACE
	requires_power = FALSE
	temperature = TCMB
	pressure = 0
	always_unpowered = 1
	base_lighting_alpha = 255

//// Landing Zone \\\\

/area/abyssal/interior/landing_zone
	name = "Con-Am 81 'Abyssal' - Hanger - Landing Zone"
	icon_state = "lz1"
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ
	linked_lz = DROPSHIP_LZ1

//// Interior Station \\\\

// Survivor Bunker
/area/abyssal/interior/bunker
	name = "Abyssal - Emergency Radiation Bunker"
	icon_state = "police_line"
	flags_area = AREA_NOTUNNEL

//Corridor
/area/abyssal/interior/corridor_west
	name = "Abyssal - Port - Main Corridor"
	icon_state = "station0"

/area/abyssal/interior/corridor_central
	name = "Abyssal - Central - Main Corridor"
	icon_state = "station0"

/area/abyssal/interior/corridor_east
	name = "Abyssal - Starboard - Main Corridor"
	icon_state = "station0"

//Telecommunications
/area/abyssal/interior/telecomms_1
	name = "Abyssal - Secondary Telecommunications Hub"
	icon_state = "power0"

/area/abyssal/interior/telecomms_2
	name = "Abyssal - Primary Telecommunications Hub"
	icon_state = "power0"

//Maintenance
/area/abyssal/interior/maintenance
	name = "Abyssal - Maintenance"
	icon_state = "maints"

/area/abyssal/interior/maintenance/west
	name = "Abyssal - Port - Maintenance"

/area/abyssal/interior/maintenance/south
	name = "Abyssal - Aft - Maintenance"

/area/abyssal/interior/maintenance/north
	name = "Abyssal - Fore - Maintenance"

/area/abyssal/interior/maintenance/east
	name = "Abyssal - Starboard - Maintenance"

/area/abyssal/interior/maintenance/central
	name = "Abyssal - Central - Maintenance"

//Solar Control
/area/abyssal/interior/solar_control_south
	name = "Abyssal - Aft - Solar Interior Controlroom"
	icon_state = "disco"

//Solar Control
/area/abyssal/interior/solar_control_north
	name = "Abyssal - Fore - Solar Interior Controlroom"
	icon_state = "disco"

//Departments
/area/abyssal/interior/arrivals
	name = "Abyssal - Arrivals Wing"
	icon_state = "station1"

/area/abyssal/interior/cargo
	name = "Abyssal - Cargo Wing"
	icon_state = "station1"

/area/abyssal/interior/atmo
	name = "Abyssal - Atmospherics"
	icon_state = "station1"

/area/abyssal/interior/hydro
	name = "Abyssal - Hydroponics"
	icon_state = "botany"

/area/abyssal/interior/dormitory
	name = "Abyssal - Dormitory"
	icon_state = "station2"

/area/abyssal/interior/galley
	name = "Abyssal - Galley Kitchen"
	icon_state = "station2"

/area/abyssal/interior/security
	name = "Abyssal - Security Wing"
	icon_state = "security_hub"

/area/abyssal/interior/engineering
	name = "Abyssal - Engineering Wing"
	icon_state = "power0"

/area/abyssal/interior/medical
	name = "Abyssal - Medical Wing"
	icon_state = "station3"

/area/abyssal/interior/science
	name = "Abyssal - Science Wing"
	icon_state = "station4"

/area/abyssal/interior/command
	name = "Abyssal - Command Wing"
	icon_state = "fiorina"

//// Exterior Station \\\\

/area/abyssal/exterior/fore
	name = "Abyssal - Exterior Fore"
	icon_state = "maints"

/area/abyssal/exterior/aft
	name = "Abyssal - Exterior Aft"
	icon_state = "maints"
