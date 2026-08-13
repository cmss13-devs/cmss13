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
	soundscape_playlist = SCAPE_PL_LV522_OUTDOORS

/area/northpoint/oob
	name = "Out Of Bounds"
	icon_state = "unknown"
	ceiling = CEILING_MAX
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL|AREA_NOBURROW
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


//Interior Areas

// --

//Exterior Areas

// --

/area/northpoint/outdoors/urban_cave
	name = "Urban Cave Areas"
	icon_state = "cave"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	ceiling_muffle = FALSE
	minimap_color = MINIMAP_AREA_CELL_HIGH
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

/area/northpoint/outdoors/urban_cave/lz2_west
	name = "Northpoint Hospital - Logistics LZ - Exterior Streets - West"

/area/northpoint/outdoors/urban_cave/lz1_south_west
	name = "Northpoint Hospital - Medical LZ - Exterior Streets - South-West"
