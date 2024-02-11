//lv553 AREAS--------------------------------------//

/area/lv553
	icon = 'icons/turf/area_strata.dmi'
	icon_state = "base_ico"
	can_build_special = TRUE
	powernet_name = "ground"
	minimap_color = MINIMAP_AREA_COLONY

//parent types

/area/lv553/indoors
	name = "Isaac's Lament - Indoors"
	icon_state = "shed_x_ag" //because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV553_INDOORS


/area/lv553/outdoors
	name = "Isaac's Lament - Outdoors"
	icon_state = "strata" //because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_NONE
	soundscape_playlist = SCAPE_PL_LV553_OUTDOORS

/area/lv553/oob
	name = "lv553 - Out Of Bounds"
	icon_state = "ag_e"
	ceiling = CEILING_MAX
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL

/area/lv553/oob/w_y_vault
	name = "lv553 - Weyland Secure Vault"
	icon_state = "shed_x_ag"

//LZ1

/area/lv553/landing_zone_1
	name = "Isaac's Lament - Landing Zone One"
	icon_state = "landingzone_1"
	is_resin_allowed =  FALSE
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ

//LZ2

/area/lv553/landing_zone_2
	name = "Isaac's Lament - Landing Zone Two"
	icon_state = "landingzone_2"
	is_resin_allowed =  FALSE
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ

//Outdoors

//Indoors

/area/lv553/indoors/bungalow_manager
	name = "Isaac's Lament - Weyland Yutani Colonial Manager's Bungalow"
	icon_state = "shed_1_ag" //because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV553_INDOORS

/area/lv553/indoors/aerospace_control
	name = "Isaac's Lament - Landing Zones' Aerospace Control"
	icon_state = "outpost_gen_1" //because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV553_INDOORS
	requires_power = FALSE

/area/lv553/indoors/lz_sec_checkpoint
	name = "Isaac's Lament - Landing Zones' Security Checkpoint"
	icon_state = "outpost_sec_4" //because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV553_INDOORS

/area/lv553/indoors/welcome_centre/offices
	name = "Isaac's Lament - WeyYu Welcome Centre Offices"
	icon_state = "offices" //because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV553_INDOORS

/area/lv553/indoors/welcome_centre/lobby
	name = "Isaac's Lament - WeyYu Welcome Centre Lobby"
	icon_state = "dorms_lobby" //because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV553_INDOORS

/area/lv553/indoors/welcome_centre/canteen
	name = "Isaac's Lament - WeyYu Welcome Centre Canteen"
	icon_state = "dorms_canteen" //because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV553_INDOORS

/area/lv553/indoors/hospital/lobby
	name = "Isaac's Lament - Jeppson's Memorial Hospital Hallway"
	icon_state = "outpost_med_hall" //because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV553_INDOORS

/area/lv553/indoors/hospital/reception
	name = "Isaac's Lament - Jeppson's Memorial Hospital Reception"
	icon_state = "outpost_med_recp" //because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV553_INDOORS

/area/lv553/indoors/hospital/outpatients_and_icu
	name = "Isaac's Lament - Jeppson's Memorial Hospital Intensive Care Unit and Outpatients"
	icon_state = "outpost_med_recovery" //because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV553_INDOORS

/area/lv553/indoors/hospital/storage_laundyroom_and_breakroom
	name = "Isaac's Lament - Jeppson's Memorial Hospital Storage, Laundryoom and Breakroom"
	icon_state = "outpost_med_stock" //because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV553_INDOORS

/area/lv553/indoors/hospital/operating_rooms
	name = "Isaac's Lament - Jeppson's Memorial Hospital Operating Rooms"
	icon_state = "outpost_med_or" //because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV553_INDOORS

/area/lv553/indoors/hospital/garage
	name = "Isaac's Lament - Jeppson's Memorial Hospital Paramedics Garage"
	icon_state = "garage" //because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV553_INDOORS

/area/lv553/indoors/hospital/research/floor
	name = "Isaac's Lament - Jeppson's Memorial Hospital Research Floor"
	icon_state = "outpost_med_chem" //because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV553_INDOORS

/area/lv553/indoors/hospital/research/toilets
	name = "Isaac's Lament - Jeppson's Memorial Hospital Research Toilets"
	icon_state = "outpost_med_chem" //because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV553_INDOORS

/area/lv553/indoors/hospital/research/offices
	name = "Isaac's Lament - Jeppson's Memorial Hospital Research Managers Offices"
	icon_state = "outpost_med_chem" //because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV553_INDOORS

/area/lv553/indoors/hospital/research/reception
	name = "Isaac's Lament - Jeppson's Memorial Hospital Research Reception"
	icon_state = "outpost_med_chem" //because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV553_INDOORS

/area/lv553/indoors/gated_community/residence_bunkhouse
	name = "Isaac's Lament - Jeppson's Memorial Hospital Staff Residence Bunkhouse"
	icon_state = "outpost_med_closet" //because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV553_INDOORS

/area/lv553/indoors/gated_community/head_of_corporate_engineering
	name = "Isaac's Lament - Weyland Yutani Gated Community - Head of Engineering House"
	icon_state = "outpost_med_closet" //because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV553_INDOORS

/area/lv553/indoors/gated_community/head_of_corporate_security
	name = "Isaac's Lament - Weyland Yutani Gated Community - Head of Security House"
	icon_state = "outpost_med_closet" //because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV553_INDOORS

/area/lv553/indoors/gated_community/director_of_corporate_research
	name = "Isaac's Lament - Weyland Yutani Gated Community - Director of Research House"
	icon_state = "outpost_med_closet" //because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV553_INDOORS

/area/lv553/indoors/gated_community/director_of_coporate_relations
	name = "Isaac's Lament - Weyland Yutani Gated Community - Director of Corporate Relations House"
	icon_state = "outpost_med_closet" //because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV553_INDOORS

