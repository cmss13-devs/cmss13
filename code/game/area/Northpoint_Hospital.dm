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
	name = "Northpoint Hospital - Logistics Area - SouthWest"
	icon_state = "shuttlered2"
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ
	linked_lz = DROPSHIP_LZ2

/area/northpoint/landing_zone_2/ceiling
	ceiling = CEILING_METAL
