//lv759 AREAS--------------------------------------//

/area/tyrargo
//	name = "Tyrargo Rift"
	icon_state = "lv-626"
	can_build_special = TRUE
	powernet_name = "ground"
	minimap_color = MINIMAP_AREA_COLONY_RESANDCOM

//parent types

/area/tyrargo/indoors
	name = "Tyrargo - Indoors"
	icon_state = "unknown"
	ceiling = CEILING_METAL
//area	soundscape_playlist = SCAPE_PL_LV759_INDOORS
	ambience_exterior = AMBIENCE_TYRARGO_CITY

/area/tyrargo/outdoors
	name = "Tyrargo - Outdoors"
	icon_state = "unknown"
	ceiling = CEILING_NONE
//	soundscape_playlist = SCAPE_PL_LV759_OUTDOORS
	ambience_exterior = AMBIENCE_TYRARGO_CITY
//	soundscape_interval = 25

/area/tyrargo/underground
	name = "Tyrargo - Underground"
	icon_state = "unknown"
	ceiling = CEILING_MAX
	ambience_exterior = AMBIENCE_TYRARGO_SEWER_CITY
	soundscape_playlist = SCAPE_PL_TYRARGO_SEWER
	soundscape_interval = 13

/area/tyrargo/oob
	name = "Out Of Bounds"
	icon_state = "unknown"
	ceiling = CEILING_MAX
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL
	minimap_color = MINIMAP_AREA_OOB
	requires_power = FALSE
	ambience_exterior = AMBIENCE_TYRARGO_CITY

/area/tyrargo/oob/outdoors
	ceiling = CEILING_NO_PROTECTION

// Landing Zone One

/area/tyrargo/landing_zone_1
	name = "Firebase Charlie - Landing Zone One"
	icon_state = "yellow"
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ
	linked_lz = DROPSHIP_LZ1
	requires_power = FALSE
	ambience_exterior = AMBIENCE_TYRARGO_CITY

/area/tyrargo/landing_zone_1/ceiling
	ceiling = CEILING_METAL

/area/tyrargo/landing_zone_1/underground
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/tyrargo/landing_zone_1/west_trench
	name = "Firebase Charlie - Western Trench"
	icon_state = "ass_line"
	minimap_color = MINIMAP_AREA_GLASS

/area/tyrargo/landing_zone_1/north_trench
	name = "Firebase Charlie - Northern Trench"
	icon_state = "ass_line"
	minimap_color = MINIMAP_AREA_GLASS

/area/tyrargo/landing_zone_1/no_mans_land
	name = "Firebase Charlie - No Man's Land"
	icon_state = "security_sub"
	minimap_color = MINIMAP_LAVA

/area/tyrargo/landing_zone_1/comms
	name = "Firebase Charlie - Communications Control Bunker"
	requires_power = TRUE

// Landing Zone Two

/area/tyrargo/landing_zone_2
	name = "USASF Airbase Anderson - Landing Zone Two"
	icon_state = "yellow"
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ
	linked_lz = DROPSHIP_LZ2
	requires_power = FALSE
	ambience_exterior = AMBIENCE_TYRARGO_CITY

/area/tyrargo/landing_zone_2/ceiling
	ceiling = CEILING_METAL

/area/tyrargo/landing_zone_2/east_trench
	name = "USASF Airbase Anderson - North-East Trench"
	minimap_color = MINIMAP_AREA_CELL_MED

// Outskirts Road

/area/tyrargo/outdoors/outskirts_road
	name = "Outskirts Road"
	icon_state = "shuttle2"
	minimap_color = MINIMAP_AREA_CELL_LOW
	requires_power = FALSE

/area/tyrargo/outdoors/outskirts_road/west
	name = "Outskirts Road - West"

/area/tyrargo/outdoors/outskirts_road/central
	name = "Outskirts Road - Central"

/area/tyrargo/outdoors/outskirts_road/east
	name = "Outskirts Road - East"

// Western Outdoor Areas

/area/tyrargo/outdoors/outskirts
	name = "Outskirts"
	icon_state = "green"
	minimap_color = MINIMAP_AREA_JUNGLE
	requires_power = FALSE

/area/tyrargo/outdoors/outskirts/north_west_usasf
	name = "Outskirts  - Worth-West Anderson Airbase"

/area/tyrargo/outdoors/outskirts/north_east_usasf
	name = "Outskirts  - North-East Anderson Airbase"

/area/tyrargo/outdoors/outskirts/central
	name = "Outskirts  - Central"

/area/tyrargo/outdoors/outskirts/east
	name = "Outskirts  - East"

/area/tyrargo/outdoors/outskirts/fsb_north
	name = "Fire Support Base - North"
	icon_state = "security_sub"
	minimap_color = MINIMAP_AREA_DERELICT
	requires_power = TRUE

/area/tyrargo/outdoors/outskirts/fsb_south
	name = "Fire Support Base - South"
	icon_state = "security_sub"
	minimap_color = MINIMAP_AREA_DERELICT
	requires_power = TRUE

/area/tyrargo/outdoors/outskirts/east_trench
	name = "Fire Support Base - Eastern Trench"
	icon_state = "ass_line"
	minimap_color = MINIMAP_AREA_GLASS

/area/tyrargo/outdoors/outskirts/no_mans_land
	name = "Fire Support Base - No Man's Land"
	icon_state = "security_sub"
	minimap_color = MINIMAP_LAVA

// Surface Bunker

/area/tyrargo/indoors/bunker
	name = "Surface Bunker"
	icon_state = "security"
	minimap_color = MINIMAP_AREA_SEC
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS
	base_muffle = MUFFLE_LOW

/area/tyrargo/indoors/bunker/north
	name = "Surface Bunker - Alpha"

/area/tyrargo/indoors/bunker/north_south
	name = "Surface Bunker - Bravo"

/area/tyrargo/indoors/bunker/central
	name = "Surface Bunker - Charlie"

/area/tyrargo/indoors/bunker/central_south
	name = "Surface Bunker - Delta"

// Underground Bunker

/area/tyrargo/underground/bunker
	name = "Underground Bunker"
	icon_state = "security"
	minimap_color = MINIMAP_AREA_SEC

/area/tyrargo/underground/bunker/north
	name = "Bunker Network - Sector Tango-12"

/area/tyrargo/underground/bunker/south
	name = "Bunker Network - Sector Epsilon-29"

/area/tyrargo/underground/bunker/ammo_dump_entrance
	name = "USASF Airbase Anderson - Underground Ammo Dump"

/area/tyrargo/underground/bunker/ammo_dump_connection
	name = "USASF Airbase Anderson - Underground Cave Network"
	requires_power = FALSE
