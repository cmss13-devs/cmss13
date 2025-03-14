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
	icon_state = "oob"
	ceiling = CEILING_MAX

/area/tyrargo/oob
	name = "Out Of Bounds"
	icon_state = "oob"
	ceiling = CEILING_MAX
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL
	minimap_color = MINIMAP_AREA_OOB
	requires_power = FALSE
