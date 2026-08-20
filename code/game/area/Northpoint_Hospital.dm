//Northpoint Hospital Areas//

/area/northpoint
//	name = "Northpoint Hospital"
	icon_state = "tutorial"
	can_build_special = TRUE
	powernet_name = "ground"
	minimap_color = MINIMAP_AREA_COLONY

//parent types

/area/northpoint/indoors
	name = "Northpoint Hospital - Indoors"
	icon_state = "unknown"
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV522_INDOORS

/area/northpoint/outdoors
	name = "Northpoint Hospital - Outdoors"
	icon_state = "unknown"
	ceiling = CEILING_NONE
	ceiling_muffle = FALSE
	soundscape_playlist = SCAPE_PL_LV522_OUTDOORS

/area/northpoint/oob
	name = "Out Of Bounds"
	icon_state = "unknown"
	ceiling = CEILING_MAX
	is_resin_allowed = FALSE
	flags_area = AREA_NOBURROW|AREA_UNWEEDABLE|AREA_NOTUNNEL
	minimap_color = MINIMAP_AREA_OOB
	requires_power = FALSE
	soundscape_playlist = SCAPE_PL_LV759_OUTDOORS
	ambience_exterior = AMBIENCE_CITY

//Landing Zone

/area/northpoint/landing_zone_1
	name = "Northpoint Hospital - Emergency Medical Landing Pad - NorthWest"
	icon_state = "shuttlered2"
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ
	linked_lz = DROPSHIP_LZ1

/area/northpoint/landing_zone_1/ceiling
	ceiling = CEILING_METAL

/area/northpoint/landing_zone_2
	name = "Northpoint Hospital - Logistics Landing Pad - SouthWest"
	icon_state = "shuttlered2"
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ
	linked_lz = DROPSHIP_LZ2

/area/northpoint/landing_zone_2/ceiling
	ceiling = CEILING_METAL

//Communications

/area/northpoint/indoors/comms
	name = "Comms Area"
	icon_state = "genetics"
	minimap_color = MINIMAP_AREA_COMMS

/area/northpoint/indoors/comms/com_alpha_1
	name = "Northpoint Hospital - Colony Primary Communications Hub"

/area/northpoint/indoors/comms/com_alpha_2
	name = "Northpoint Hospital - Emergency Backup Communications"
	ceiling = CEILING_NONE
	soundscape_playlist = SCAPE_PL_LV522_OUTDOORS

/area/northpoint/indoors/comms/com_bravo_1
	name = "Northpoint Hospital - Internal Communications Array"

/area/northpoint/indoors/comms/com_bravo_2
	name = "Northpoint Hospital - Military Field Communications Network"
	ceiling = CEILING_NONE
	soundscape_playlist = SCAPE_PL_LV522_OUTDOORS

//Interior Areas

// --

/area/northpoint/indoors/power
	name = "Northpoint Hospital - Power Generator Substation"
	icon_state = "engine"
	minimap_color = MINIMAP_AREA_COLONY_ENGINEERING

// --

/area/northpoint/indoors/emer_dep
	name = "Northpoint Hospital - Emergency Department"
	icon_state = "medbay"
	minimap_color = MINIMAP_AREA_MEDBAY

// --

/area/northpoint/indoors/main
	name = "Northpoint Hospital - Main Hospital"
	icon_state = "medbay2"
	minimap_color = MINIMAP_AREA_COLONY_HOSPITAL

// --

/area/northpoint/indoors/res
	name = "Northpoint Hospital - Medical Research Clinic"
	icon_state = "medbay3"
	minimap_color = MINIMAP_AREA_COLONY_RESANDCOM

// --

/area/northpoint/indoors/off
	name = "Northpoint Hospital - Office"
	icon_state = "captain"
	minimap_color = MINIMAP_AREA_COLONY_SPACE_PORT

// --

/area/northpoint/indoors/sec_prep
	name = "Northpoint Hospital - Security & Catering"
	icon_state = "security"
	minimap_color = MINIMAP_AREA_COLONY_MARSHALLS


//Exterior Areas

// --

/area/northpoint/outdoors/streets
	name = "Street Areas"
	icon_state = "iso1"
	ceiling = CEILING_NO_PROTECTION
	minimap_color = MINIMAP_AREA_CELL_VIP

/area/northpoint/outdoors/streets/lz1
	name = "Northpoint Hospital - LZ1 Streets"

/area/northpoint/outdoors/streets/lzstreets
	name = "Northpoint Hospital - LZ1 / LZ2 Connection Streets"

/area/northpoint/outdoors/streets/north_carpark
	name = "Northpoint Hospital - North Carpark/Entrance"

/area/northpoint/outdoors/streets/south_carpark
	name = "Northpoint Hospital - South Carpark/Entrance"

// --

/area/northpoint/outdoors/park
	name = "Northpoint Hospital - MacArthur Park"
	icon_state = "iso1"
	minimap_color = MINIMAP_AREA_CELL_LOW

// --

/area/northpoint/outdoors/hospital_exterior
	name = "Exterior Hospital Areas"
	icon_state = "valley"
	ceiling = CEILING_NO_PROTECTION
	minimap_color = MINIMAP_AREA_COLONY_STREETS

/area/northpoint/outdoors/hospital_exterior/west
	name = "Northpoint Hospital - West Hospital Grounds"

/area/northpoint/outdoors/hospital_exterior/north
	name = "Northpoint Hospital - North Hospital Grounds"

/area/northpoint/outdoors/hospital_exterior/south
	name = "Northpoint Hospital - South Hospital Grounds"

/area/northpoint/outdoors/hospital_exterior/east
	name = "Northpoint Hospital - East Hospital Grounds"

/area/northpoint/outdoors/hospital_exterior/central
	name = "Northpoint Hospital - Central Hospital Grounds"

// --

/area/northpoint/outdoors/urban_cave
	name = "Urban Cave Areas"
	icon_state = "cave"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	ceiling_muffle = FALSE
	minimap_color = MINIMAP_AREA_COLONY_STREETS
	unoviable_timer = FALSE

/area/northpoint/outdoors/urban_cave/south_east
	name = "Northpoint Hospital - Exterior Streets - Southeast"

/area/northpoint/outdoors/urban_cave/east
	name = "Northpoint Hospital - Exterior Streets - East"

/area/northpoint/outdoors/urban_cave/north_east
	name = "Northpoint Hospital - Exterior Streets - Northeast"

/area/northpoint/outdoors/urban_cave/south
	name = "Northpoint Hospital - Exterior Streets - South"

/area/northpoint/outdoors/urban_cave/lz2_south
	name = "Northpoint Hospital - Logistics LZ - Exterior Streets - South"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS

/area/northpoint/outdoors/urban_cave/lz2_south/weedkiller
	linked_lz = DROPSHIP_LZ2

/area/northpoint/outdoors/urban_cave/lz2_west
	name = "Northpoint Hospital - Logistics LZ - Exterior Streets - West"

/area/northpoint/outdoors/urban_cave/lz1_south_west
	name = "Northpoint Hospital - Medical LZ - Exterior Streets - South-West"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS

/area/northpoint/outdoors/urban_cave/lz1_south_west/weedkiller
	linked_lz = DROPSHIP_LZ1
