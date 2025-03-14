//lv759 AREAS--------------------------------------//

/area/tyrargo
//	name = "Tyrargo Rift"
	icon_state = "lv-626"
	can_build_special = TRUE
	powernet_name = "ground"
	minimap_color = MINIMAP_AREA_COLONY_RESANDCOM

//parent types

/area/tyrargo/indoors
	name = "Hybrisa - Indoors"
	icon_state = "cliff_blocked"//because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_METAL
//area	soundscape_playlist = SCAPE_PL_LV759_INDOORS
	ambience_exterior = AMBIENCE_TYRARGO_CITY

/area/tyrargo/outdoors
	name = "Hybrisa - Outdoors"
	icon_state = "cliff_blocked"//because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_NONE
//	soundscape_playlist = SCAPE_PL_LV759_OUTDOORS
	ambience_exterior = AMBIENCE_TYRARGO_CITY
//	soundscape_interval = 25

/area/tyrargo/underground
	name = "Out Of Bounds"
	icon_state = "oob"
	ceiling = CEILING_MAX
	flags_area = AREA_NOTUNNEL

/area/tyrargo/oob
	name = "Out Of Bounds"
	icon_state = "oob"
	ceiling = CEILING_MAX
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL
	minimap_color = MINIMAP_AREA_OOB
	requires_power = FALSE
