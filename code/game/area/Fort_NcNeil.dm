//Fort McNeil Areas//

/area/fort_mcneil
//	name = "Fort McNeil"
	icon_state = "tutorial"
	can_build_special = TRUE
	powernet_name = "ground"
	minimap_color = MINIMAP_AREA_COLONY

//parent types

/area/fort_mcneil/indoors
	name = "Fort McNeil - Indoors"
	icon_state = "unknown"
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV522_INDOORS

/area/fort_mcneil/outdoors
	name = "Fort McNeil - Outdoors"
	icon_state = "unknown"
	ceiling = CEILING_NONE
	soundscape_playlist = SCAPE_PL_LV522_OUTDOORS

/area/fort_mcneil/oob
	name = "Out Of Bounds"
	icon_state = "unknown"
	ceiling = CEILING_MAX
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL|AREA_NOBURROW
	minimap_color = MINIMAP_AREA_OOB
	requires_power = FALSE
	ambience_exterior = AMBIENCE_TYRARGO_CITY

//Landing Zone

/area/fort_mcneil/landing_zone_1
	name = "Fort McNeil - Landing Zone"
	icon_state = "shuttlered2"
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ
	linked_lz = DROPSHIP_LZ1

/area/fort_mcneil/landing_zone_1/ceiling
	ceiling = CEILING_METAL

//Exterior Areas

// --

/area/fort_mcneil/outdoors/road
	name = "Outskirts Road"
	icon_state = "shuttle"
	minimap_color = MINIMAP_AREA_SHIP
	requires_power = FALSE

/area/fort_mcneil/outdoors/road/south
	name = "Outskirts Road - South"
	linked_lz = DROPSHIP_LZ1

/area/fort_mcneil/outdoors/road/central
	name = "Outskirts Road - Central"

/area/fort_mcneil/outdoors/road/north
	name = "Outskirts Road - North"

// --

/area/fort_mcneil/outdoors/scrublands
	name = "Scrublands"
	icon_state = "green"
	minimap_color = MINIMAP_SNOW
	requires_power = FALSE

/area/fort_mcneil/outdoors/scrublands/south
	name = "Scrublands - South"
	icon_state = "south"
	linked_lz = DROPSHIP_LZ1

/area/fort_mcneil/outdoors/scrublands/central
	icon_state = "central"
	name = "Scrublands - Central"

/area/fort_mcneil/outdoors/scrublands/north
	icon_state = "north"
	name = "Scrublands - North"

// --

/area/fort_mcneil/outdoors/colony_exterior
	name = "Fort McNeil Exterior"
	icon_state = "green"
	minimap_color = MINIMAP_ICE
	requires_power = FALSE

/area/fort_mcneil/outdoors/colony_exterior/south
	name = "Fort McNeil Exterior - South"
	icon_state = "south"

/area/fort_mcneil/outdoors/colony_exterior/south_east
	name = "Fort McNeil Exterior - South-East"
	icon_state = "southeast"

/area/fort_mcneil/outdoors/colony_exterior/south_west
	name = "Fort McNeil Exterior - South-West"
	icon_state = "southwest"

/area/fort_mcneil/outdoors/colony_exterior/central
	icon_state = "central"
	name = "Fort McNeil Exterior - Central"

/area/fort_mcneil/outdoors/colony_exterior/north
	icon_state = "north"
	name = "Fort McNeil Exterior - North"

/area/fort_mcneil/outdoors/colony_exterior/north_east
	icon_state = "northeast"
	name = "Fort McNeil Exterior - North-East"

/area/fort_mcneil/outdoors/colony_exterior/north_west
	icon_state = "northwest"
	name = "Fort McNeil Exterior - North-West"

/area/fort_mcneil/outdoors/colony_exterior/west
	icon_state = "west"
	name = "Fort McNeil Exterior - West"

/area/fort_mcneil/outdoors/colony_exterior/east
	icon_state = "east"
	name = "Fort McNeil Exterior - East"

// --

/area/fort_mcneil/outdoors/comms
	name = "Colony Exterior Communications - Exterior"
	icon_state = "server"
	minimap_color = MINIMAP_AREA_ENGI_CAVE
	requires_power = FALSE

//Interior Areas

// --

/area/fort_mcneil/indoors/command
	name = "Fort McNeil - Command and Control"
	minimap_color = MINIMAP_AREA_COMMAND
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS
	icon_state = "centcom"

// --

/area/fort_mcneil/indoors/engi
	name = "Fort McNeil - Engineering"
	minimap_color = MINIMAP_AREA_ENGI
	icon_state = "engine"

// --

/area/fort_mcneil/indoors/hydro
	name = "Fort McNeil - Hydroponics"
	minimap_color = MINIMAP_AREA_JUNGLE
	icon_state = "engine"

// --

/area/fort_mcneil/indoors/hydro
	name = "Fort McNeil - Hydroponics"
	minimap_color = MINIMAP_AREA_JUNGLE
	icon_state = "hydro"

// --

/area/fort_mcneil/indoors/bar
	name = "Fort McNeil - Bar"
	minimap_color = MINIMAP_AREA_CONTESTED_ZONE
	icon_state = "bar"

// --

/area/fort_mcneil/indoors/dorm
	name = "Fort McNeil - Dormitory"
	minimap_color = MINIMAP_AREA_RESEARCH
	icon_state = "maint_dormitory"

// --

/area/fort_mcneil/indoors/connection_paths
	name = "Fort McNeil - Hub Connection Hallways"
	minimap_color = MINIMAP_AREA_ENGI_CAVE
	icon_state = "dk_yellow"

// --

/area/fort_mcneil/indoors/mining
	name = "Fort McNeil - Mining"
	minimap_color = MINIMAP_AREA_ENGI
	icon_state = "mining"

// --

/area/fort_mcneil/indoors/storage
	name = "Fort McNeil - Storage"
	minimap_color = MINIMAP_AREA_COLONY_SPACE_PORT
	icon_state = "maint_cargo"

// --

/area/fort_mcneil/indoors/comms_inside
	name = "Fort McNeil - Primary Communications"
	minimap_color = MINIMAP_AREA_COLONY_ENGINEERING
	icon_state = "engine"

/area/fort_mcneil/indoors/comms_outside
	name = "Fort McNeil - Tertiary Communications"
	minimap_color = MINIMAP_AREA_COLONY_ENGINEERING
	icon_state = "engine"

// --

/area/fort_mcneil/indoors/toilet
	name = "Fort McNeil - Lavatory"
	minimap_color = MINIMAP_AREA_COLONY_RESANDCOM
	icon_state = "bridge"

// --

/area/fort_mcneil/indoors/pod_1
	name = "Fort McNeil - Ancillery Pod #1"
	minimap_color = MINIMAP_AREA_HYBRISARESEARCH
	icon_state = "bridge"

/area/fort_mcneil/indoors/pod_2
	name = "Fort McNeil - Ancillery Pod #2"
	minimap_color = MINIMAP_AREA_HYBRISARESEARCH
	icon_state = "bridge"

/area/fort_mcneil/indoors/pod_3
	name = "Fort McNeil - Ancillery Pod #3"
	minimap_color = MINIMAP_AREA_HYBRISARESEARCH
	icon_state = "bridge"

// --

//Cave Areas

// --

/area/fort_mcneil/indoors/caves
	name = "Caves"
	icon_state = "cave"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	soundscape_playlist = SCAPE_PL_LV759_DEEPCAVES
	ceiling_muffle = FALSE
	minimap_color = MINIMAP_AREA_MINING
	unoviable_timer = FALSE
	always_unpowered = TRUE

/area/fort_mcneil/indoors/caves/north
	name = "Caves - North"

/area/fort_mcneil/indoors/caves/central
	name = "Caves - Central"

/area/fort_mcneil/indoors/caves/south
	name = "Caves - South"

// --
