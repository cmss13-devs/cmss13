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
	icon_state = "shed_x_ag"
	ceiling = CEILING_METAL //because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	soundscape_playlist = SCAPE_PL_LV553_INDOORS


/area/lv553/outdoors
	name = "Isaac's Lament - Outdoors"
	icon_state = "path"
	ceiling = CEILING_NONE //because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
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

/area/lv553/outdoors/landing_zones_disembark
	name = "Isaac's Lament - Landing Zones Disembarkation Road"

/area/lv553/outdoors/bungalow_manager_exterior
	name = "Isaac's Lament - WeyYu Colonial Manager's Bungalow Exterior"

/area/lv553/outdoors/welcome_center_exterior/west
	name = "Isaac's Lament - WeyYu Welcome Center - West Exterior"

/area/lv553/outdoors/welcome_center_exterior/east
	name = "Isaac's Lament - WeyYu Welcome Center - East Exterior"

/area/lv553/outdoors/gated_community_exterior
	name = "Isaac's Lament - WeyYu Gated Community Exterior"

/area/lv553/outdoors/hospital/break_garden
	name = "Isaac's Lament - Jeppson's Memorial Hospital - Break Garden"

/area/lv553/outdoors/hospital/road_north_west
	name = "Isaac's Lament - Jeppson's Memorial Hospital - North West Road Entrance"

/area/lv553/outdoors/hospital/road_north_east
	name = "Isaac's Lament - Jeppson's Memorial Hospital - North East Road Entrance"

/area/lv553/outdoors/uscm_garrison_exterior/fenced
	name = "Isaac's Lament - USCM Garrison - Fenced Exterior"

/area/lv553/outdoors/uscm_garrison_exterior/entrance
	name = "Isaac's Lament - USCM Garrison - Entrance Exterior"

/area/lv553/outdoors/flooded_streets/west
	name = "Isaac's Lament - Flooded Streets - West"

/area/lv553/outdoors/flooded_streets/east
	name = "Isaac's Lament - Flooded Streets - East"

/area/lv553/outdoors/flooded_streets/waste_treatment
	name = "Isaac's Lament - Flooded Waste Treatment Facility Exterior"

/area/lv553/outdoors/colony_streets/west
	name = "Isaac's Lament - Colony Streets - West"

/area/lv553/outdoors/colony_streets/southwest
	name = "Isaac's Lament - Colony Streets - South-West"

/area/lv553/outdoors/colony_streets/south
	name = "Isaac's Lament - Colony Streets - South"

/area/lv553/outdoors/colony_streets/southeast
	name = "Isaac's Lament - Colony Streets - South-East"

/area/lv553/outdoors/colony_streets/east
	name = "Isaac's Lament - Colony Streets - East"

/area/lv553/outdoors/colony_streets/northeast
	name = "Isaac's Lament - Colony Streets - North-East"

//Indoors

/area/lv553/indoors/bungalow_manager
	name = "Isaac's Lament - WeyYu Colonial Manager's Bungalow"
	icon_state = "shed_1_ag"

/area/lv553/indoors/aerospace_control
	name = "Isaac's Lament - Landing Zones' Aerospace Control"
	icon_state = "outpost_gen_1"
	requires_power = FALSE

/area/lv553/indoors/lz_sec_checkpoint
	name = "Isaac's Lament - Landing Zones' Security Checkpoint"
	icon_state = "outpost_sec_4"

/area/lv553/indoors/welcome_center/offices
	name = "Isaac's Lament - WeyYu Welcome Center - Offices"
	icon_state = "offices"

/area/lv553/indoors/welcome_center/lobby
	name = "Isaac's Lament - WeyYu Welcome Center - Lobby"
	icon_state = "dorms_lobby"

/area/lv553/indoors/welcome_center/canteen
	name = "Isaac's Lament - WeyYu Welcome Center - Canteen"
	icon_state = "dorms_canteen"

/area/lv553/indoors/hospital/lobby
	name = "Isaac's Lament - Jeppson's Memorial Hospital -  Hallway"
	icon_state = "outpost_med_hall"

/area/lv553/indoors/hospital/reception
	name = "Isaac's Lament - Jeppson's Memorial Hospital - Reception"
	icon_state = "outpost_med_recp"

/area/lv553/indoors/hospital/outpatients_and_icu
	name = "Isaac's Lament - Jeppson's Memorial Hospital - Intensive Care Unit and Outpatients"
	icon_state = "outpost_med_recovery"

/area/lv553/indoors/hospital/storage_laundyroom_and_breakroom
	name = "Isaac's Lament - Jeppson's Memorial Hospital - Storage, Laundryoom and Breakroom"
	icon_state = "outpost_med_stock"

/area/lv553/indoors/hospital/operating_rooms
	name = "Isaac's Lament - Jeppson's Memorial Hospital - Operating Rooms"
	icon_state = "outpost_med_or"

/area/lv553/indoors/hospital/garage
	name = "Isaac's Lament - Jeppson's Memorial Hospital - Paramedics Garage"
	icon_state = "garage"

/area/lv553/indoors/hospital/research/floor
	name = "Isaac's Lament - Jeppson's Memorial Hospital - Research Floor"
	icon_state = "outpost_med_chem"

/area/lv553/indoors/hospital/research/toilets
	name = "Isaac's Lament - Jeppson's Memorial Hospital - Research Toilets"
	icon_state = "outpost_med_chem"

/area/lv553/indoors/hospital/research/offices
	name = "Isaac's Lament - Jeppson's Memorial Hospital - Research Managers Offices"
	icon_state = "outpost_med_chem"

/area/lv553/indoors/hospital/research/reception
	name = "Isaac's Lament - Jeppson's Memorial Hospital - Research Reception"
	icon_state = "outpost_med_chem"

/area/lv553/indoors/gated_community/residence_bunkhouse
	name = "Isaac's Lament - Jeppson's Memorial Hospital - Staff Residence Bunkhouse"
	icon_state = "shed_2_ag"

/area/lv553/indoors/gated_community/head_of_corporate_engineering
	name = "Isaac's Lament - Weyland Yutani Gated Community - Head of Engineering House"
	icon_state = "shed_3_ag"

/area/lv553/indoors/gated_community/head_of_corporate_security
	name = "Isaac's Lament - Weyland Yutani Gated Community - Head of Security House"
	icon_state = "shed_4_ag"

/area/lv553/indoors/gated_community/director_of_corporate_research
	name = "Isaac's Lament - Weyland Yutani Gated Community - Director of Research House"
	icon_state = "shed_5_ag"

/area/lv553/indoors/gated_community/director_of_coporate_relations
	name = "Isaac's Lament - Weyland Yutani Gated Community - Director of Corporate Relations House"
	icon_state = "shed_6_ag"

/area/lv553/indoors/uscm_garrison/recruitment_office
	name = "Isaac's Lament - USCM Garrison - Recruitment Office"
	icon_state = "shed_1_ug"

/area/lv553/indoors/uscm_garrison/garrison_bunks
	name = "Isaac's Lament - USCM Garrison - Garrison Bunks"
	icon_state = "shed_2_ug"

/area/lv553/indoors/uscm_garrison/armory
	name = "Isaac's Lament - USCM Garrison - Armory"
	icon_state = "shed_3_ug"

/area/lv553/indoors/uscm_garrison/io_office
	name = "Isaac's Lament - USCM Garrison - Third Fleet Intelligence Office"
	icon_state = "tcomms1"

/area/lv553/indoors/flooded/weymart
	name = "Isaac's Lament - Flooded Area - Weymart"
	icon_state = "shed_4_ug"

/area/lv553/indoors/flooded/waste_station
	name = "Isaac's Lament - Flooded Area - Waste Water Station"
	icon_state = "outpost_engi_4"

/area/lv553/indoors/flooded/waste_silos
	name = "Isaac's Lament - Flooded Area - Waste Water Silos"
	icon_state = "disposal"

/area/lv553/indoors/flooded/west_slums
	name = "Isaac's Lament - Flooded Area - West Slums"
	icon_state = "shed_7_ag"

/area/lv553/indoors/flooded/west_apartments
	name = "Isaac's Lament - Flooded Area - West Apartments"
	icon_state = "shed_5_ug"

/area/lv553/indoors/flooded/east_apartments
	name = "Isaac's Lament - Flooded Area - East Apartments"
	icon_state = "shed_6_ug"

/area/lv553/indoors/flooded/telecomms
	name = "Isaac's Lament - Flooded Area - Engineering Telecomms"
	icon_state = "tcomms2"
