//AREAS

/area/khami_barrens
	name = "Khami Barrens"
	icon = 'icons/turf/area_kutjevo.dmi'
	//ambience = list('figuresomethingout.ogg')
	icon_state = "khami_barrens"
	can_build_special = TRUE //T-Comms structure
	temperature = 308.7 //kelvin, 35c, 95f
	minimap_color = MINIMAP_AREA_ENGI

/area/shuttle/drop1/khami_barrens
	name = "Khami Barrens - Dropship Alamo Landing Zone"
	icon_state = "shuttle"
	icon = 'icons/turf/area_kutjevo.dmi'

/area/shuttle/drop2/khami_barrens
	name = "Khami Barrens - Dropship Normandy Landing Zone"
	icon_state = "shuttle2"
	icon = 'icons/turf/area_kutjevo.dmi'

/area/khami_barrens/exterior
	name = "Khami Barrens - Exterior"
	ceiling = CEILING_NONE
	icon_state = "ext"


/area/khami_barrens/interior
	name = "Khami Barrens - Interior"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	icon_state = "int"
	requires_power = 1

/area/khami_barrens/interior/oob
	name = "Khami Barrens -  Out Of Bounds"
	ceiling = CEILING_MAX
	icon_state = "oob"
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL

/area/khami_barrens/interior/oob/dev_room
	name = "Khami Barrens - Credits Room"
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL
	icon_state = "khami_barrens"

//exterior map areas

/area/khami_barrens/exterior/lz_pad
	name = "Khami Barrens - Passenger Landing Zone"
	icon_state = "lz_pad"
	weather_enabled = FALSE
	unlimited_power = 1//ds computer
	is_resin_allowed = FALSE
	is_landing_zone = TRUE

/area/khami_barrens/exterior/lz_dunes
	name = "Khami Barrens - Cargo Landing Zone"
	icon_state = "lz_dunes"
	is_resin_allowed = FALSE
	weather_enabled =  FALSE
	unlimited_power = 1//DS Computer
	is_landing_zone = TRUE

/area/khami_barrens/exterior/scrubland
	name = "Khami Barrens - Oasis Scrubland"
	icon_state = "scrubland"

/area/khami_barrens/exterior/lodge
	name = "Khami Barrens - Hunting Lodge Exterior"
	icon_state = "scrubland"

/area/khami_barrens/exterior/scrubland/village
	name = "Khami Barrens - North Village Scrubland"
	icon_state = "scrubland"

/area/khami_barrens/exterior/scrubland/village/west
	name = "Khami Barrens - West Village Scrubland"
	icon_state = "scrubland"

/area/khami_barrens/exterior/scrubland/checkpoint
	name = "Khami Barrens - Checkpoint Scrubland"
	icon_state = "scrubland"

/area/khami_barrens/exterior/scrubland/lodge
	name = "Khami Barrens - Hunting Lodge Scrubland"
	icon_state = "scrubland"

/area/khami_barrens/exterior/stonyfields
	name = "Khami Barrens - South Stony Barrens"
	icon_state = "stone_fields"

/area/khami_barrens/exterior/stonyfields/north
	name = "Khami Barrens - North Stony Barrens"
	icon_state = "stone_fields"

/area/khami_barrens/exterior/driedoasis/basin
	name = "Khami Barrens - Dried Oasis Basin"
	icon_state = "rf_river"

/area/khami_barrens/exterior/driedoasis/bridge
	name = "Khami Barrens - Dried Oasis Bridge"
	icon_state = "rf_bridge"

/area/khami_barrens/exterior/driedoasis/gates
	name = "Khami Barrens - Dried Oasis Flood Gates"
	icon_state = "rf_river"

/area/khami_barrens/exterior/ruins
	name = "Khami Barrens - Ruins Exterior"
	icon_state = "construction"

/area/khami_barrens/exterior/village
	name = "Khami Barrens - West Village Exterior"
	icon_state = "construction2"

/area/khami_barrens/exterior/village/east
	name = "Khami Barrens - East Village Exterior"
	icon_state = "construction3"

//telecomms areas
/area/khami_barrens/exterior/telecomm
	name = "Khami Barrens - Communications Relay"
	icon_state = "ass_line"
	is_resin_allowed = FALSE
	ceiling_muffle = FALSE
	base_muffle = MUFFLE_LOW

/area/khami_barrens/exterior/telecomm/lz1_north
	name = "Khami Barrens - North LZ1 Communications Relay"

/area/khami_barrens/exterior/telecomm/lz1_south
	name = "Khami Barrens - South LZ1 Communications Relay"

/area/khami_barrens/exterior/telecomm/lz2_north
	name = "Khami Barrens - North LZ2 Communications Relay"

/area/khami_barrens/exterior/telecomm/lz2_south
	name = "Khami Barrens - South LZ2 Communications Relay"

//interior areas + caves

//Village Buildings
/area/khami_barrens/interior/village
	name = "Khami Barrens"
	ceiling = CEILING_METAL
	icon_state = "khami_barrens"

/area/khami_barrens/interior/village/company_offices
	name = "Khami Barrens - Village Company Offices West"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS
	icon_state = "foremans"

/area/khami_barrens/interior/village/company_offices/reception
	name = "Khami Barrens - Village Company Offices Reception"

/area/khami_barrens/interior/village/company_offices/east
	name = "Khami Barrens - Village Company Offices East"

/area/khami_barrens/interior/village/shop
	name = "Khami Barrens - Village Shop"
	ceiling = CEILING_METAL
	icon_state = "Colony_int"

/area/khami_barrens/interior/village/mall
	name = "Khami Barrens - Village Mall"
	icon_state = "Colony_int"

/area/khami_barrens/interior/village/restaurant
	name = "Khami Barrens - Village Restaurant"
	icon_state = "Colony_int"

/area/khami_barrens/interior/village/stage
	name = "Khami Barrens - Village Stage"
	icon_state = "Colony_int"

/area/khami_barrens/interior/village/botany
	name = "Khami Barrens - Village Botany Bay"
	icon_state = "botany0"
	minimap_color = MINIMAP_AREA_RESEARCH

/area/khami_barrens/interior/village/med
	name = "Khami Barrens - North Village Clinic"
	icon_state = "med0"
	minimap_color = MINIMAP_AREA_MEDBAY

/area/khami_barrens/interior/village/med/south
	name = "Khami Barrens - South Village Clinic"
	icon_state = "med2"

/area/khami_barrens/interior/village/med/reception_storage
	name = "Khami Barrens - Village Clinic Reception and Storage"
	icon_state = "med3"

/area/khami_barrens/interior/village/residence
	name = "Khami Barrens - North Village Residence"
	icon_state = "Colony_int"
	ceiling = CEILING_METAL
	is_resin_allowed = TRUE

/area/khami_barrens/interior/village/residence/west
	name = "Khami Barrens - West Village Residence"
	icon_state = "Colony_int"

/area/khami_barrens/interior/village/residence/east
	name = "Khami Barrens - East Village Residence"
	icon_state = "Colony_int"

/area/khami_barrens/interior/village/residence/company
	name = "Khami Barrens - West Village Company Residence"
	icon_state = "Colony_int"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	is_resin_allowed = TRUE

/area/khami_barrens/interior/village/residence/company/east
	name = "Khami Barrens - East Village Company Residence"
	icon_state = "Colony_int"

/area/khami_barrens/interior/village/engineering
	name = "Khami Barrens - North Village Engineering"
	icon_state = "Colony_int"
	ceiling = CEILING_METAL
	is_resin_allowed = TRUE
	minimap_color = MINIMAP_AREA_ENGI

/area/khami_barrens/interior/village/engineering/south
	name = "Khami Barrens - South Village Engineering"
	icon_state = "Colony_int"

/area/khami_barrens/interior/village/engineering/power
	name = "Khami Barrens - Village Engineering Powerstation"
	icon_state = "power"

//Out buildings & Caves

/area/khami_barrens/interior/checkpoint
	name = "Khami Barrens - Checkpoint"
	ceiling = CEILING_METAL
	icon_state = "int"
	minimap_color = MINIMAP_AREA_SEC

/area/khami_barrens/interior/hunting_lodge
	name = "Khami Barrens - Hunting Lodge"
	ceiling = CEILING_METAL
	icon_state = "construction_int"

/area/khami_barrens/interior/marksman_residence
	name = "Khami Barrens - Marksman's Residence"
	ceiling = CEILING_METAL
	icon_state = "int"

/area/khami_barrens/interior/rancher_residence
	name = "Khami Barrens - Rancher's Residence"
	ceiling = CEILING_METAL
	icon_state = "int"

/area/khami_barrens/interior/landing_zone
	name = "Khami Barrens - Passenger Landing Zone Interior"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	icon_state = "int"
	minimap_color = MINIMAP_AREA_CAVES

/area/khami_barrens/interior/landing_zone_arrivals/north
	name = "Khami Barrens - Passenger Landing Zone Arrivals North"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	icon_state = "int"
	minimap_color = MINIMAP_AREA_CAVES

/area/khami_barrens/interior/landing_zone_arrivals/south
	name = "Khami Barrens - Passenger Landing Zone Arrivals South"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	icon_state = "int"
	minimap_color = MINIMAP_AREA_CAVES

/area/khami_barrens/interior/research_caves
	name = "Khami Barrens - Research Caves"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	icon_state = "colony_caves_0"
	minimap_color = MINIMAP_AREA_CAVES

/area/khami_barrens/interior/research_caves/checkpoint
	name = "Khami Barrens - Research Caves Checkpoint"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS
	icon_state = "colony_caves_2"
	minimap_color = MINIMAP_AREA_SEC_CAVE

/area/khami_barrens/interior/research_caves/research
	name = "Khami Barrens - Caves Research"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	icon_state = "med5"
	minimap_color = MINIMAP_AREA_RESEARCH_CAVE

/area/khami_barrens/interior/tunnels
	name = "Khami Barrens - Main Tunnel"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	icon_state = "colony_caves_3"
	minimap_color = MINIMAP_AREA_CAVES

/area/khami_barrens/interior/tunnels/auxillary
	name = "Khami Barrens - Auxillary Tunnels"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	icon_state = "colony_caves_2"

/area/khami_barrens/interior/resin_caves
	name = "Khami Barrens - North Resin Caves"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	icon_state = "colony_caves_0"
	minimap_color = MINIMAP_AREA_CAVES

/area/khami_barrens/interior/resin_caves/deep
	name = "Khami Barrens - South Resin Caves"
	ceiling = CEILING_DEEP_UNDERGROUND
	icon_state = "colony_caves_1"
	minimap_color = MINIMAP_AREA_CAVES

/area/khami_barrens/interior/ruin_caves
	name = "Khami Barrens - Interior Ruins"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	icon_state = "construction"
	minimap_color = MINIMAP_AREA_CAVES

/area/khami_barrens/interior/ruin_caves/north
	name = "Khami Barrens - North Ruin Caves"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	icon_state = "construction1"
	minimap_color = MINIMAP_AREA_CAVES

/area/khami_barrens/interior/ruin_caves/south
	name = "Khami Barrens - South Ruin Caves"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	icon_state = "construction2"
	minimap_color = MINIMAP_AREA_CAVES

//TURFS

/turf/closed/wall //var stuff
	var/force_blend  //var stuff

/turf/open/gm/grass/grass_dried
	icon_state = "grass_dried"

/turf/closed/wall/mineral/sandstone/runed/force_blend
	force_blend = 1

/turf/closed/wall/mineral/sandstone/runed/decor/force_blend
	force_blend = 1


