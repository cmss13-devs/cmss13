//LV-1021: Operation Falcon's Fury Areas//

/area/lv1021
//	name = "LV-1021"
	icon_state = "tutorial"
	can_build_special = TRUE
	powernet_name = "ground"
	minimap_color = MINIMAP_AREA_COLONY
	temperature = TROPICAL_TEMP

//parent types

/area/lv1021/indoors
	name = "LV-1021 - Indoors"
	icon_state = "unknown"
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV759_INDOORS
	ambience_exterior = AMBIENCE_JUNGLE_ALT
	ceiling_muffle = FALSE
	base_muffle = -1000

/area/lv1021/outdoors
	name = "LV-1021 - Outdoors"
	icon_state = "unknown"
	ceiling = CEILING_NONE
	ambience_exterior = AMBIENCE_JUNGLE_ALT

/area/lv1021/oob
	name = "Out Of Bounds"
	icon_state = "unknown"
	ceiling = CEILING_MAX
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL|AREA_NOBURROW
	minimap_color = MINIMAP_AREA_OOB
	requires_power = FALSE

//Landing Zone

/area/lv1021/landing_zone_1
	name = "LV-1021 - North-West Landing Zone"
	icon_state = "shuttlered2"
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ
	linked_lz = DROPSHIP_LZ1

/area/lv1021/landing_zone_1/ceiling
	ceiling = CEILING_METAL

/area/lv1021/landing_zone_2
	name = "LV-1021 - Southern Landing Zone"
	icon_state = "shuttlered2"
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ
	linked_lz = DROPSHIP_LZ2

/area/lv1021/landing_zone_2/ceiling
	ceiling = CEILING_SANDSTONE_ALLOW_CAS

// Comms

/area/lv1021/outdoors/comms
	name = "LV-1021 - Communications"
	icon_state = "server"
	minimap_color = MINIMAP_AREA_CELL_MED

/area/lv1021/outdoors/comms/west_2
	name = "LV-1021 - West Jungle - External Communications"

/area/lv1021/outdoors/comms/south_2
	name = "LV-1021 - Central Jungle - External Communications"

/area/lv1021/outdoors/comms/north_1
	name = "LV-1021 - CLF Camp  - Tertiary Communications"

/area/lv1021/outdoors/comms/north_west_1
	name = "LV-1021 - CLF Camp  - Primary Communications"
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV759_INDOORS
	ambience_exterior = AMBIENCE_JUNGLE_ALT
	ceiling_muffle = FALSE
	base_muffle = -1000

//Exterior Areas

// --

/area/lv1021/outdoors/jungle
	name = "LV-1021 - Jungle"
	icon_state = "green"
	minimap_color = MINIMAP_AREA_JUNGLE
//	requires_power = FALSE

/area/lv1021/outdoors/jungle/jungleW_north
	icon_state = "north"
	name = "LV-1021 - West Jungle - North"
	linked_lz = DROPSHIP_LZ1

/area/lv1021/outdoors/jungle/jungleW_south
	icon_state = "south"
	name = "LV-1021 - West Jungle - South"

// --

/area/lv1021/outdoors/jungle/jungleC_clf_n
	icon_state = "north"
	name = "LV-1021 - CLF Camp - North"

/area/lv1021/outdoors/jungle/jungleC_clf_e
	icon_state = "east"
	name = "LV-1021 - CLF Camp - East"

/area/lv1021/outdoors/jungle/jungleC_mid
	icon_state = "central"
	name = "LV-1021 - Central Jungle - Central"

/area/lv1021/outdoors/jungle/jungleC_south
	icon_state = "south"
	name = "LV-1021 - Central Jungle - South"
	linked_lz = DROPSHIP_LZ2

/area/lv1021/outdoors/jungle/jungleC_south_west
	icon_state = "southwest"
	name = "LV-1021 - Central Jungle - South-West"
	linked_lz = DROPSHIP_LZ2

/area/lv1021/outdoors/jungle/jungleC_n_e
	icon_state = "northeast"
	name = "LV-1021 - Central Jungle - North-East"
	unoviable_timer = FALSE

/area/lv1021/outdoors/jungle/jungleC_e
	icon_state = "east"
	name = "LV-1021 - Central Jungle - East"
	unoviable_timer = FALSE

/area/lv1021/outdoors/jungle/jungleC_s_e
	icon_state = "southeast"
	name = "LV-1021 - Central Jungle - South-East"
	unoviable_timer = FALSE

// --

/area/lv1021/outdoors/river
	icon_state = "blue2"
	name = "LV-1021 - River"
	requires_power = FALSE

/area/lv1021/outdoors/river/central_north
	name = "LV-1021 - Central River - North"

/area/lv1021/outdoors/river/central_south
	name = "LV-1021 - Central River - South"

/area/lv1021/outdoors/river/central_lagoon
	name = "LV-1021 - Central River - Lagoon"
	flags_area = AREA_NOTUNNEL|AREA_NOBURROW

/area/lv1021/outdoors/river/east_river
	name = "LV-1021 - East River"

//Interior Areas

// --

/area/lv1021/indoors/clf_camp
	name = "LV-1021 - CLF Camp"
	icon_state = "centcom"

/area/lv1021/indoors/clf_camp/coordinator
	name = "LV-1021 - CLF Camp - Coordinators Cabin"
	minimap_color = MINIMAP_AREA_COMMAND

/area/lv1021/indoors/clf_camp/ancil_n
	name = "LV-1021 - CLF Camp - North Ancillery Cabins"
	minimap_color = MINIMAP_AREA_MEDBAY

/area/lv1021/indoors/clf_camp/education
	name = "LV-1021 - CLF Camp - Educational Cabin"
	minimap_color = MINIMAP_AREA_MINING

/area/lv1021/indoors/clf_camp/landing
	name = "LV-1021 - CLF Camp - Resupply and Landing Cabin"
	minimap_color = MINIMAP_AREA_ENGI

/area/lv1021/indoors/clf_camp/ancil_e
	name = "LV-1021 - CLF Camp - East Ancillery Cabins"
	minimap_color = MINIMAP_AREA_MEDBAY

/area/lv1021/indoors/clf_camp/ancil_s
	name = "LV-1021 - CLF Camp - South Ancillery Cabin"
	minimap_color = MINIMAP_AREA_MEDBAY

/area/lv1021/indoors/clf_camp/ancil_se
	name = "LV-1021 - CLF Camp - South-East Ancillery Cabin"
	minimap_color = MINIMAP_AREA_MEDBAY

// --

//Cave Areas

/area/lv1021/indoors/caves
	name = "Caves"
	icon_state = "cave"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	soundscape_playlist = SCAPE_PL_LV759_DEEPCAVES
	ceiling_muffle = FALSE
	minimap_color = MINIMAP_AREA_HYBRISACAVES
	unoviable_timer = FALSE

/area/lv1021/indoors/caves/landing_zone
	name = "LV-1021 - Cave - Landing Zone 2"
	unoviable_timer = TRUE

/area/lv1021/indoors/caves/landing_zone/weedkiller
	linked_lz = DROPSHIP_LZ2

/area/lv1021/indoors/caves/clf_tunnel
	name = "LV-1021 - CLF Tunnel"

/area/lv1021/indoors/caves/cave_north
	name = "LV-1021 - Eastern Cave - North"

/area/lv1021/indoors/caves/cave_south
	name = "LV-1021 - Eastern Cave - South"
