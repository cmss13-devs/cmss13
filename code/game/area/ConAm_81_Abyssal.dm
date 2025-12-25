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
	unoviable_timer = FALSE

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
	flags_area = AREA_NOTUNNEL|AREA_CONTAINMENT|AREA_UNWEEDABLE
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
	ceiling = CEILING_NONE
	is_resin_allowed =  FALSE
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ
	linked_lz = DROPSHIP_LZ1

//// Interior Station \\\\

// Survivor Bunker
/area/abyssal/interior/bunker
	name = "Abyssal - Emergency Radiation Bunker"
	icon_state = "police_line"
	flags_area = AREA_NOTUNNEL
	minimap_color = MINIMAP_AREA_JUNGLE

//Corridor
/area/abyssal/interior/corridor_west
	name = "Abyssal - Port - Main Corridor"
	icon_state = "station0"
	minimap_color = MINIMAP_DIRT

/area/abyssal/interior/corridor_central
	name = "Abyssal - Central - Main Corridor"
	icon_state = "station0"
	minimap_color = MINIMAP_DIRT

/area/abyssal/interior/corridor_east
	name = "Abyssal - Starboard - Main Corridor"
	icon_state = "station0"
	minimap_color = MINIMAP_DIRT

//Telecommunications
/area/abyssal/interior/telecomms_1
	name = "Abyssal - Secondary Telecommunications Hub"
	icon_state = "power0"
	minimap_color = MINIMAP_AREA_ENGI

/area/abyssal/interior/telecomms_2
	name = "Abyssal - Primary Telecommunications Hub"
	icon_state = "power0"
	minimap_color = MINIMAP_AREA_ENGI

//Maintenance
/area/abyssal/interior/maintenance
	name = "Abyssal - Maintenance"
	icon_state = "maints"
	minimap_color = MINIMAP_LAVA

/area/abyssal/interior/maintenance/west
	name = "Abyssal - Port - Maintenance"
	linked_lz = DROPSHIP_LZ1

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
	minimap_color = MINIMAP_AREA_GLASS

/area/abyssal/interior/solar_control_north
	name = "Abyssal - Fore - Solar Interior Controlroom"
	icon_state = "disco"
	minimap_color = MINIMAP_AREA_GLASS

//Departments
/area/abyssal/interior/arrivals
	name = "Abyssal - Arrivals Wing"
	icon_state = "station1"
	linked_lz = DROPSHIP_LZ1
	minimap_color = MINIMAP_AREA_CELL_MED

/area/abyssal/interior/cargo
	name = "Abyssal - Cargo Wing"
	icon_state = "station1"
	linked_lz = DROPSHIP_LZ1
	minimap_color = MINIMAP_AREA_SHIP

/area/abyssal/interior/atmo
	name = "Abyssal - Atmospherics"
	icon_state = "station1"
	minimap_color = MINIMAP_AREA_CELL_VIP

/area/abyssal/interior/hydro
	name = "Abyssal - Hydroponics"
	icon_state = "botany"
	minimap_color = MINIMAP_AREA_CELL_LOW

/area/abyssal/interior/dormitory
	name = "Abyssal - Dormitory"
	icon_state = "station2"
	minimap_color = MINIMAP_AREA_CELL_VIP

/area/abyssal/interior/galley
	name = "Abyssal - Galley Kitchen"
	icon_state = "station2"
	minimap_color = MINIMAP_AREA_CELL_VIP

/area/abyssal/interior/security
	name = "Abyssal - Security Wing"
	icon_state = "security_hub"
	minimap_color = MINIMAP_AREA_COLONY_MARSHALLS

/area/abyssal/interior/engineering
	name = "Abyssal - Engineering Wing"
	icon_state = "power0"
	minimap_color = MINIMAP_AREA_COLONY_ENGINEERING

/area/abyssal/interior/medical
	name = "Abyssal - Medical Wing"
	icon_state = "station3"
	minimap_color = MINIMAP_AREA_COLONY_HOSPITAL

/area/abyssal/interior/science
	name = "Abyssal - Science Wing"
	icon_state = "station4"
	minimap_color = MINIMAP_AREA_RESEARCH
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/abyssal/interior/command
	name = "Abyssal - Command Wing"
	icon_state = "fiorina"
	minimap_color = MINIMAP_AREA_COMMAND
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/abyssal/interior/liaison
	name = "Abyssal - Executive Coordinators Office"
	icon_state = "station4"
	minimap_color = MINIMAP_AREA_COMMAND
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

//// Exterior Station \\\\

/area/abyssal/exterior/fore
	name = "Abyssal - Exterior Fore"
	icon_state = "maints"

/area/abyssal/exterior/aft
	name = "Abyssal - Exterior Aft"
	icon_state = "maints"

//// Derelict Shuttle \\\\

/area/abyssal/interior/derelict_shuttle
	name = "Unidentified Space Craft (UFO-1)"
	icon_state = "tumor0-deep"
	ceiling = CEILING_REINFORCED_METAL
	flags_area = AREA_NOTUNNEL
	ambience_exterior = AMBIENCE_DERELICT
	soundscape_playlist = SCAPE_PL_LV759_DERELICTSHIP
	minimap_color = MINIMAP_AREA_HYBRISACAVES
	requires_power = FALSE

//// Gonzo \\\\

/area/abyssal/gonzo
	name = "Abyssal - Exterior Starboard"
	icon_state = "maints"
	ceiling = CEILING_MAX
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL
	minimap_color = MINIMAP_AREA_GLASS
	ambience_exterior = SCAPE_ABYSSAL_EXTERIOR
	requires_power = FALSE
	base_lighting_alpha = 255
	always_unpowered = 1
