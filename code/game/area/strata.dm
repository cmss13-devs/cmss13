
// Areas for the Sorokyne Strata

/area/strata
	name = "Sorokyne Strata"
	icon = 'icons/turf/area_strata.dmi'
	icon_state = "strata"
	can_build_special = TRUE //T-Comms structure
	powernet_name = "ground"
	temperature = TROPICAL_TEMP
	minimap_color = MINIMAP_AREA_COLONY

/area/strata/interior/out_of_bounds
	name = "Out of Bounds"
	icon_state = "ag_i"
	soundscape_playlist = FALSE
	ambience_exterior = FALSE
	requires_power = FALSE
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL|AREA_UNWEEDABLE
	ceiling = CEILING_MAX

//////////////////////////////////////////

/area/strata/exterior
	name = "Exterior"
	icon_state = "ag_e"
	ceiling = CEILING_NONE
	ambience_exterior = AMBIENCE_JUNGLE_ALT

/area/strata/interior
	name = "Interior"
	icon_state = "ag_i"
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV759_INDOORS
	ambience_exterior = AMBIENCE_HYBRISA_INTERIOR
	temperature = T20C //Nice and room temp

////////////////////////////////////////

//-Landing Zones

/area/strata/exterior/landing_zones
	name = "Do not use."
	icon_state = "landingzone_2"
	minimap_color = MINIMAP_AREA_LZ

/area/strata/interior/landing_zones
	name = "Do not use."
	icon_state = "landingzone_1"
	minimap_color = MINIMAP_AREA_LZ

/area/strata/exterior/landing_zones/lz2
	name = "Landing Zone 2 Pad - Rocky Fields"
	unlimited_power = 1 //So the DS computer always works for the Queen
	is_landing_zone = TRUE
	linked_lz = DROPSHIP_LZ2

/area/strata/exterior/landing_zones/near_lz2
	name = "Landing Zone 2 - Rocky Fields"
	icon_state = "nearlz2"
	is_landing_zone = TRUE
	linked_lz = DROPSHIP_LZ2

/area/strata/interior/landing_zones/lz1
	name = "Landing Zone 1 Pad - Mining Aerodrome"
	unlimited_power = 1 //So the DS computer always works for the Queen
	is_landing_zone = TRUE
	linked_lz = DROPSHIP_LZ1

/area/strata/interior/landing_zones/near_lz1
	name = "Landing Zone 1 - Mining Aerodrome"
	icon_state = "nearlz1"
	is_landing_zone = TRUE
	linked_lz = DROPSHIP_LZ1

//-Caves (how are these caves?)

/area/strata/exterior/shed_five_caves
	name = "Terminal Five Topside Pathway"
	icon_state = "lzcaves"

/area/strata/exterior/lz_caves
	name = "External Mining Aerodrome Pathway"
	linked_lz = DROPSHIP_LZ1
	icon_state = "lzcaves"

//-Marsh

/area/strata/exterior/marsh
	name = "Do not use."
	icon_state = "marsh"

/area/strata/exterior/marsh/spring_marshes
	name = "Geothermal Springs Marshes"
	linked_lz = list(DROPSHIP_LZ1, DROPSHIP_LZ2)

/area/strata/exterior/marsh/water_marshes
	name = "Geothermal Water Marshes"
	linked_lz = DROPSHIP_LZ2

/area/strata/exterior/marsh/island_marshes
	name = "Geothermal Island Marshes"
	is_landing_zone = TRUE
	linked_lz = DROPSHIP_LZ2

/area/strata/exterior/marsh/relay_marshes
	name = "Geothermal Relay Marshes"
	is_landing_zone = TRUE
	linked_lz = DROPSHIP_LZ2

/area/strata/exterior/marsh/center
	name = "Geothermal Springs"
	icon_state = "marshcenter"
	linked_lz = list(DROPSHIP_LZ1, DROPSHIP_LZ2)

/area/strata/exterior/marsh/river
	name = "Geothermal River"
	icon_state = "marshriver"
	linked_lz = DROPSHIP_LZ1

/area/strata/exterior/marsh/crash
	name = "Geothermal Crashed Dropship"
	icon_state = "marshship"
	linked_lz = list(DROPSHIP_LZ1, DROPSHIP_LZ2)

/area/strata/exterior/marsh/water
	name = "Geothermal Water"
	icon_state = "marshwater"
	linked_lz = DROPSHIP_LZ2

//-Outside "interiors"

/area/strata/interior/vanyard
	name = "Flight Control Vehicle Yard"
	icon_state = "garage"

/area/strata/exterior/tcomms_mining_caves
	name = "Mining Pathway Relay"
	icon_state = "tcomms1"

/area/strata/exterior/tcomms_vehicle_yard
	name = "Vehicle Yard Relay"
	icon_state = "tcomms1"

//-Outpost

/area/strata/exterior/outpost_decks
	name = "Outpost - Decks"
	icon_state = "rdecks"
	minimap_color = MINIMAP_AREA_CAVES

//-Paths

/area/strata/exterior/flight_control_exterior
	name = "Flight Control Exterior"
	linked_lz = DROPSHIP_LZ1
	icon_state = "path"

/area/strata/exterior/mining_outpost_exterior
	name = "Mining Outpost - Exterior"
	linked_lz = DROPSHIP_LZ1
	icon_state = "path"

/area/strata/exterior/north_outpost
	name = "Outpost - North Access Channel"
	icon_state = "outpost_gen_2"
	icon_state = "path"

/area/strata/exterior/far_north_outpost
	name = "Far North Of The Outpost"
	icon_state = "cabin"
	unoviable_timer = FALSE
	icon_state = "path"

/area/strata/exterior/south_outpost
	name = "South Of The Outpost"
	icon_state = "path"

////////////////////////////////////////

//-Outpost

/area/strata/interior/outpost
	name = "Sorokyne Outpost"
	icon_state = "shed_x_ag"
	minimap_color = MINIMAP_AREA_CAVES

/area/strata/interior/outpost/foyer
	name = "Outpost - Main Foyer"
	icon_state = "outpost_gen_1"

/area/strata/interior/outpost/maint
	name = "Outpost - Canteen - Eastern Maintenance"
	icon_state = "outpost_maint"

/area/strata/interior/outpost/med
	name = "Outpost - Medical"
	icon_state = "outpost_med"
	minimap_color = MINIMAP_AREA_MEDBAY

/area/strata/interior/outpost/engi
	name = "Outpost - Engineering"
	icon_state = "outpost_engi_0"
	minimap_color = MINIMAP_AREA_ENGI

/area/strata/interior/outpost/engi/drome
	name = "Outpost - Aerodome"
	icon_state = "outpost_engi_4"

/area/strata/interior/outpost/engi/drome/shuttle
	name = "Dismantled VDVK Eagle Mk 4"
	icon_state = "outpost_engi_3"

/area/strata/interior/outpost/engi/drome/shuttle_MK3
	name = "VDVK Eagle Mk 3"
	icon_state = "outpost_engi_3"

/area/strata/interior/shuttle_sof
	name = "UPP-DS-3 'Voron'"
	icon_state = "outpost_engi_3"
	ambience_exterior = AMBIENCE_SHIP_ALT

/area/strata/interior/supply_shuttle_sof
	name = "UPP-DS-3 'Volk'"
	icon_state = "outpost_engi_3"
	ambience_exterior = AMBIENCE_SHIP_ALT

/area/strata/interior/outpost/security
	name = "Outpost - Security"
	icon_state = "outpost_sec_0"
	minimap_color = MINIMAP_AREA_SEC

/area/strata/interior/outpost/admin
	name = "Outpost - Administration"
	icon_state = "outpost_admin_0"
	minimap_color = MINIMAP_AREA_COMMAND
	ceiling = CEILING_GLASS

/area/strata/interior/outpost/canteen
	name = "Outpost - Canteen"
	icon_state = "outpost_canteen_0"
	ceiling = CEILING_GLASS

/area/strata/interior/outpost/canteen/bar
	name = "Outpost - Bar"
	icon_state = "outpost_canteen_2"

//-Mining Outpost

/area/strata/interior/mining_outpost
	name = "Mining Outpost - Central"
	icon_state = "dorms_0"
	minimap_color = MINIMAP_AREA_MINING
	linked_lz = DROPSHIP_LZ1

/area/strata/interior/mining_outpost/south_dormitories
	name = "Mining Outpost - South Dormitories"
	icon_state = "dorms_3"
	ceiling = CEILING_GLASS

/area/strata/interior/mining_outpost/maintenance
	name = "Mining Outpost - Dormitory Maintenance"
	icon_state = "outpost_maint"

/area/strata/interior/mining_outpost/hive
	name = "Mining Outpost - Dormitory Geothermal Storage"
	icon_state = "dorms_beno"

/area/strata/interior/mining_outpost/canteen
	name = "Mining Outpost - Dormitory Canteen"
	icon_state = "dorms_canteen"
	ceiling = CEILING_GLASS

/area/strata/interior/mining_outpost/flight_control
	name = "Mining Outpost - Flight Control"
	icon_state = "dorms_lobby"
	is_landing_zone = TRUE

/area/strata/interior/administration
	name = "Flight Control Offices"
	icon_state = "offices"
	minimap_color = MINIMAP_AREA_COMMAND
	linked_lz = DROPSHIP_LZ1

/area/strata/interior/wooden_hospital
	name = "Wooden Hospital - Hospital Proper"
	icon_state = "cabin3"
	minimap_color = MINIMAP_AREA_CAVES
	unoviable_timer = FALSE

/area/strata/interior/wooden_ruins
	name = "Old Wooden Building"
	icon_state = "cabin3"
	minimap_color = MINIMAP_AREA_CAVES
	unoviable_timer = FALSE

// Sec Checkpoints

/area/strata/interior/checkpoints
	name= "Do not use."
	icon_state = "security_station"
	minimap_color = MINIMAP_AREA_SEC

/area/strata/interior/checkpoints/north_armor
	name = "North Security Armored Checkpoint"

/area/strata/interior/checkpoints/north
	name = "Landing Zone North Security Checkpoint"

/area/strata/interior/checkpoints/west
	name = "Landing Zone West Security Checkpoint"

/area/strata/interior/checkpoints/south
	name = "Landing Zone South Security Checkpoint"
	is_landing_zone = TRUE

/area/strata/interior/checkpoints/outpost
	name = "Outpost - Deck Security Checkpoint"
	icon_state = "rdecks_sec"

// Engi Storage

/area/strata/interior/parts_storage
	name = "Engineering - Parts Storage"
	icon_state = "outpost_engi_1"

/area/strata/interior/generator_substation
	name = "Engineering - Generator Substation"
	icon_state = "outpost_engi_1"

/area/strata/exterior/parts_storage_exterior
	name = "Engineering - Parts Storage Exterior"
	icon_state = "outpost_engi_4"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	soundscape_playlist = SCAPE_PL_LV759_CAVES
	ceiling_muffle = FALSE

/area/strata/exterior/parts_storage_cave
	name = "Engineering - Parts Storage Exterior"
	icon_state = "outpost_engi_4"
	minimap_color = MINIMAP_AREA_ENGI_CAVE
	ceiling =  CEILING_UNDERGROUND_ALLOW_CAS
	soundscape_playlist = SCAPE_PL_LV759_CAVES
	ceiling_muffle = FALSE

// BBall, Caves & Secure Checkpoint

/area/strata/interior/bball //come on and SLAM.
	name = "Outpost - Basket Ball Court"
	icon_state = "outpost_gen_4"
	minimap_color = MINIMAP_AREA_CAVES

/area/strata/interior/bball_cave //come on BURST AND DIE.
	name = "Outpost - B-Ball Caves"
	icon_state = "hive_1"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	minimap_color = MINIMAP_AREA_CAVES_DEEP
	unoviable_timer = FALSE
	ambience_exterior = AMBIENCE_HYBRISA_CAVES
	soundscape_playlist = SCAPE_PL_LV759_CAVES
	ceiling_muffle = FALSE

/area/strata/interior/secure_checkpoint
	name = "Secure Checkpoint Passthrough"
	icon_state = "outpost_engi_0"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	minimap_color = MINIMAP_AREA_CAVES_DEEP
	unoviable_timer = FALSE
	soundscape_playlist = SCAPE_PL_LV759_CAVES
	ceiling_muffle = FALSE

//-Deep Jungle Dorms

/area/strata/interior/underground_dorms
	name = "Do not use."
	icon_state = "ug_jung_dorm"
	minimap_color = MINIMAP_AREA_CAVES_STRUCTURE
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS
	ceiling_muffle = FALSE

/area/strata/interior/underground_dorms/sec1
	name = "Deep Jungle - Security Dorm #1"
	unoviable_timer = FALSE

/area/strata/interior/underground_dorms/sec2
	name = "Deep Jungle - Security Dorm #2"
	unoviable_timer = FALSE

/area/strata/interior/underground_dorms/admin1
	name = "Deep Jungle - General Staff Dorm #1"

/area/strata/interior/underground_dorms/admin2
	name = "Deep Jungle - General Staff Dorm #2"
	unoviable_timer = FALSE

/area/strata/interior/underground_dorms/admin3
	name = "Deep Jungle - General Staff Dorm #3"
	unoviable_timer = FALSE

/area/strata/interior/underground_dorms/admin4
	name = "Deep Jungle - General Staff Dorm #4"
	unoviable_timer = FALSE

/area/strata/interior/underground_dorms/med1
	name = "Deep Jungle - Medical Dorm #1"
	requires_power = 1

/area/strata/interior/underground_dorms/med2
	name = "Deep Jungle - Medical Dorm #2"
	requires_power = TRUE

/area/strata/interior/underground_dorms/botany
	name = "Botanical Research Station"
	requires_power = TRUE

//-Platform

/area/strata/exterior/outpost_platform
	name = "Deep Jungle - Platform"
	icon_state = "ug_jung_1"
	minimap_color = MINIMAP_AREA_MEDBAY_CAVE

//-Jungle

/area/strata/exterior/carplake_center
	name = "Deep Jungle - Lake Center Island"
	icon_state = "ug_jung_1"
	unoviable_timer = FALSE

/area/strata/exterior/deep_jungle
	name = "Do not use."
	icon_state = "ug_jung_0"
	minimap_color = MINIMAP_AREA_JUNGLE
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	ceiling_muffle = FALSE

/area/strata/exterior/deep_jungle/carplake_north
	name = "Deep Jungle - North of Carp Lake"
	icon_state = "ug_jung_6"

/area/strata/exterior/deep_jungle/carplake_east
	name = "Deep Jungle - East of Carp Lake"
	icon_state = "ug_jung_5"

/area/strata/exterior/deep_jungle/platform
	name = "Deep Jungle - South of the Platform"
	icon_state = "ug_jung_4"
	unoviable_timer = FALSE

/area/strata/exterior/deep_jungle/platform_east
	name = "Deep Jungle - East of the Platform"
	icon_state = "ug_jung_0"
	unoviable_timer = FALSE
	ceiling = CEILING_NONE

/area/strata/exterior/deep_jungle/hot_springs
	icon_state = "ug_jung_4"
	name = "Deep Jungle - Hot Springs"
	minimap_color = MINIMAP_AREA_JUNGLE

/area/strata/exterior/deep_jungle/old_tunnels
	icon_state = "ug_jung_mine_1"
	name = "Deep Jungle - Old Path - West of Classified Research Station"
	minimap_color = MINIMAP_AREA_JUNGLE
	ceiling = CEILING_NONE

/area/strata/exterior/deep_jungle/north
	icon_state = "ug_jung_6"
	name = "Deep Jungle - South of Classified Research Station"
	minimap_color = MINIMAP_AREA_JUNGLE

/area/strata/exterior/deep_jungle/west
	icon_state = "ug_jung_6"
	name = "Deep Jungle - West of Planetary Core Monitoring"
	minimap_color = MINIMAP_AREA_JUNGLE

/area/strata/exterior/deep_jungle/south
	icon_state = "ug_jung_7"
	name = "Deep Jungle - South of Planetary Core Monitoring"
	minimap_color = MINIMAP_AREA_JUNGLE

/area/strata/exterior/deep_jungle/east
	icon_state = "ug_jung_8"
	name = "Deep Jungle - East of Planetary Core Monitoring"
	minimap_color = MINIMAP_AREA_JUNGLE

/area/strata/exterior/deep_jungle/planet_core_research_station_exterior
	icon_state = "ug_jung_8"
	name = "Deep Jungle - Planetary Core Monitoring Research Station"
	minimap_color = MINIMAP_AREA_JUNGLE

/area/strata/exterior/deep_jungle/ruin
	icon_state = "ug_jung_mine_4"
	name = "Deep Jungle - Ancient Dorms"
	unoviable_timer = FALSE
	weather_enabled = FALSE

/area/strata/exterior/deep_jungle/tearlake
	name = "Deep Jungle - Weeping Pool"
	icon_state = "ug_jung_3"
	unoviable_timer = FALSE

// Deep Jungle Structure

/area/strata/interior/planet_core_research_station
	icon_state = "ug_jung_5"
	name = "Deep Jungle - Planetary Core Monitoring Research Station"
	minimap_color = MINIMAP_AREA_CAVES_STRUCTURE
	unoviable_timer = FALSE
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS
	ceiling_muffle = FALSE

/area/strata/interior/research
	icon_state = "ug_jung_2"
	name = "Deep Jungle - Classified Research Station"
	minimap_color = MINIMAP_AREA_RESEARCH
	unoviable_timer = FALSE
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS
	ceiling_muffle = FALSE

//-Others

/area/strata/exterior/restricted
	name = "Super Secret Credits Room"
	icon_state = "marshwater"
	requires_power = FALSE
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL|AREA_UNWEEDABLE

// CLF Insert

/area/strata/interior/checkpoints/clf
	name = "Far North Armored Checkpoint"

/area/strata/interior/outpost/clf_dorms
	name = "Far North Dormitory"

/area/strata/interior/outpost/clf_office
	name = "Far North Office"
