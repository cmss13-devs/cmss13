
//Areas for the Sorokyne Strata (aka Carp Lake.dm)

/* AG in a path stands for ABOVE GROUND, while UG stands for underground.
After that, all areas are sorted by EXTERIOR or INTERIOR. With INTERIOR being any area that isn't nippy and cold. (All buildings & jungle caves)
EXTERIOR is FUCKING FREEZING, and refers to areas out in the open and or exposed to the elements.
*/

/area/strata
	name = "Sorokyne Strata"
	icon = 'icons/turf/area_strata.dmi'
	//ambience = list('figuresomethingout.ogg')
	icon_state = "strata"
	can_build_special = TRUE //T-Comms structure
	powernet_name = "ground"
	temperature = SOROKYNE_TEMPERATURE //If not in a building, it'll be cold. All interior areas are set to T20C
	minimap_color = MINIMAP_AREA_COLONY

/area/shuttle/drop1/strata //Not in Sulaco.DM because holy shit we need to sort things.
	name = "Dropship Alamo Landing Zone"
	icon_state = "shuttle"
	base_lighting_alpha = 255
	minimap_color = MINIMAP_AREA_LZ
	linked_lz = DROPSHIP_LZ1

/area/shuttle/drop2/strata
	name = "Dropship Normandy Landing Zone"
	icon_state = "shuttle2"
	base_lighting_alpha = 255
	minimap_color = MINIMAP_AREA_LZ
	linked_lz = DROPSHIP_LZ2


//Begin actual area definitions. There's probably a better way to do this.

//////////////////////////////////////////
//   ------===| Essentials |===------   //
//////////////////////////////////////////

//-Above Ground (ag)
/area/strata/ag
	name = "Above Ground Area"
	icon_state = "ag"

/area/strata/ag/exterior
	name = "Exterior Above Ground Area"
	icon_state = "ag_e"
	ceiling = CEILING_NONE
	//always_unpowered = 1 So exterior lights work, this will be commented out unless it causes unforseen issues.

/area/strata/ag/interior
	name = "Interior Above Ground Area"
	icon_state = "ag_i"
	requires_power = 1
	temperature = T20C //Nice and room temp
	ceiling = CEILING_METAL


//-Under Ground (ug)

/area/strata/ug
	name = "Under Ground Area"
	icon_state = "ug"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS

/area/strata/ug/interior
	name = "Interior Under Ground Area"
	icon_state = "ug_i"
	requires_power = 1
	temperature = T20C

/area/strata/ug/exterior
	name = "Exterior Under Ground Area"
	icon_state = "ug_i"
	requires_power = 1
	temperature = T20C
	ceiling = CEILING_NONE
	weather_enabled = TRUE


////////////////////////////////////////
//   ------===| Exterior |===------   //
////////////////////////////////////////


//-Landing Zones
/area/strata/ag/exterior/landing_zones
	name = "Do not use."
	icon_state = "landingzone_2"
	minimap_color = MINIMAP_AREA_LZ

/area/strata/ag/exterior/landing_zones/lz2
	name = "Landing Zone 2 Pad - Ice Fields"
	unlimited_power = 1 //So the DS computer always works for the Queen
	weather_enabled = FALSE
	is_landing_zone = TRUE
	linked_lz = DROPSHIP_LZ2

/area/strata/ag/exterior/landing_zones/near_lz2
	name = "Landing Zone 2 - Ice Fields"
	icon_state = "nearlz2"
	weather_enabled = TRUE
	is_landing_zone = TRUE
	linked_lz = DROPSHIP_LZ2

/area/strata/ag/interior/landing_zones
	name = "Do not use."
	icon_state = "landingzone_1"
	minimap_color = MINIMAP_AREA_LZ
	weather_enabled = FALSE
	ceiling = CEILING_NONE

/area/strata/ag/interior/landing_zones/lz1
	name = "Landing Zone 1 Pad - Mining Aerodrome"
	unlimited_power = 1 //So the DS computer always works for the Queen
	is_landing_zone = TRUE
	linked_lz = DROPSHIP_LZ1

/area/strata/ag/interior/landing_zones/near_lz1
	name = "Landing Zone 1 - Mining Aerodrome"
	icon_state = "nearlz1"
	is_landing_zone = TRUE
	linked_lz = DROPSHIP_LZ1


//-Caves
/area/strata/ag/exterior/caves
	name = "Do not use."
	icon_state = "lzcaves"

/area/strata/ag/exterior/caves/shed_five_caves
	name = "Terminal Five Topside Caves"

/area/strata/ag/exterior/caves/lz_caves
	name = "External Mining Aerodrome Caves"
	linked_lz = DROPSHIP_LZ1

/area/strata/ag/exterior/jungle/carplake_center
	name = "Deep Jungle - Carp Lake Center Island"
	icon_state = "ug_jung_1"
	weather_enabled = TRUE
	unoviable_timer = FALSE

//-Marsh

/area/strata/ag/exterior/marsh
	name = "Do not use."
	icon_state = "marsh"

/area/strata/ag/exterior/marsh/spring_marshes
	name = "Cryo-Thermal Springs Marshes"
	linked_lz = list(DROPSHIP_LZ1, DROPSHIP_LZ2)

/area/strata/ag/exterior/marsh/water_marshes
	name = "Cryo-Thermal Water Marshes"
	linked_lz = DROPSHIP_LZ2

/area/strata/ag/exterior/marsh/island_marshes
	name = "Cryo-Thermal Island Marshes"
	is_landing_zone = TRUE
	linked_lz = DROPSHIP_LZ2

/area/strata/ag/exterior/marsh/relay_marshes
	name = "Cryo-Thermal Relay Marshes"
	is_landing_zone = TRUE
	linked_lz = DROPSHIP_LZ2

/area/strata/ag/exterior/marsh/center
	name = "Cryo-Thermal Springs"
	icon_state = "marshcenter"
	linked_lz = list(DROPSHIP_LZ1, DROPSHIP_LZ2)

/area/strata/ag/exterior/marsh/river
	name = "Cryo-Thermal River"
	icon_state = "marshriver"
	linked_lz = DROPSHIP_LZ1

/area/strata/ag/exterior/marsh/crash
	name = "Cryo-Thermal Crashed Lifeboat"
	icon_state = "marshship"
	linked_lz = list(DROPSHIP_LZ1, DROPSHIP_LZ2)

/area/strata/ag/exterior/marsh/water
	name = "Cryo-Thermal Water"
	icon_state = "marshwater"
	temperature = TCMB //space cold
	linked_lz = DROPSHIP_LZ2

//-Outside "interiors"

/area/strata/ag/exterior/vanyard
	name = "Flight Control Vehicle Yard"
	icon_state = "garage"

/area/strata/ag/exterior/tcomms
	name = "Do not use."
	icon_state = "tcomms1"

/area/strata/ag/exterior/tcomms/mining_caves
	name = "Mining Caves Relay"

//-Outpost

/area/strata/ag/exterior/outpost_decks
	name = "Outpost Decks"
	icon_state = "rdecks"
	minimap_color = MINIMAP_AREA_CAVES

//-Paths

/area/strata/ag/exterior/paths
	name = "Ice Path"
	icon_state = "path"

/area/strata/ag/exterior/paths/flight_control_exterior
	name = "Flight Control Exterior"
	linked_lz = DROPSHIP_LZ1

/area/strata/ag/exterior/paths/mining_outpost_exterior
	name = "Mining Outpost Exterior"
	linked_lz = DROPSHIP_LZ1

/area/strata/ag/exterior/paths/north_outpost
	name = "Outpost - North Access Channel"
	icon_state = "outpost_gen_2"

/area/strata/ag/exterior/paths/far_north_outpost
	name = "Far North Of The Outpost"
	icon_state = "cabin"
	unoviable_timer = FALSE

/area/strata/ag/exterior/paths/south_outpost
	name = "South Of The Outpost"
	ceiling = CEILING_NONE

////////////////////////////////////////
//   ------===| Interior |===------   //
////////////////////////////////////////

/area/strata/ug/interior/jungle
	name = "Do not use."
	ceiling = CEILING_DEEP_UNDERGROUND


//-Outpost

/area/strata/ag/interior/outpost
	name = "Sorokyne Outpost"
	icon_state = "shed_x_ag"
	minimap_color = MINIMAP_AREA_CAVES
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/strata/ag/interior/outpost/foyer
	name = "Outpost Main Foyer"
	icon_state = "outpost_gen_1"

/area/strata/ag/interior/outpost/maint
	name = "Outpost Canteen - Eastern Maintenance"
	icon_state = "outpost_maint"

/area/strata/ag/interior/outpost/med
	name = "Outpost Medical"
	icon_state = "outpost_med"
	minimap_color = MINIMAP_AREA_MEDBAY

/area/strata/ag/interior/outpost/engi
	name = "Outpost Engineering"
	icon_state = "outpost_engi_0"
	minimap_color = MINIMAP_AREA_ENGI

/area/strata/ag/interior/outpost/engi/drome
	name = "Outpost Aerodome"
	icon_state = "outpost_engi_4"

/area/strata/ag/interior/outpost/engi/drome/shuttle
	name = "Dismantled VDVK Eagle Mk 4"
	icon_state = "outpost_engi_3"

/area/strata/ag/interior/outpost/security
	name = "Outpost Security"
	icon_state = "outpost_sec_0"
	minimap_color = MINIMAP_AREA_SEC

/area/strata/ag/interior/outpost/admin
	name = "Outpost Administration"
	icon_state = "outpost_admin_0"
	minimap_color = MINIMAP_AREA_COMMAND
	ceiling = CEILING_GLASS

/area/strata/ag/interior/outpost/canteen
	name = "Outpost Canteen"
	icon_state = "outpost_canteen_0"
	ceiling = CEILING_GLASS

/area/strata/ag/interior/outpost/canteen/bar
	name = "Outpost Bar"
	icon_state = "outpost_canteen_2"

//-Mining Outpost

/area/strata/ag/interior/mining_outpost
	name = "Do not use."
	minimap_color = MINIMAP_AREA_MINING
	linked_lz = DROPSHIP_LZ1
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/strata/ag/interior/mining_outpost/central
	name = "Mining Outpost Central"
	icon_state = "dorms_0"
	ceiling = CEILING_GLASS

/area/strata/ag/interior/mining_outpost/south_dormitories
	name = "Mining Outpost South Dormitories"
	icon_state = "dorms_3"
	ceiling = CEILING_GLASS

/area/strata/ag/interior/mining_outpost/maintenance
	name = "Mining Outpost Dormitory Maintenance"
	icon_state = "outpost_maint"

/area/strata/ag/interior/mining_outpost/hive
	name = "Mining Outpost Dormitory Thermal Storage"
	icon_state = "dorms_beno"

/area/strata/ag/interior/mining_outpost/canteen
	name = "Mining Outpost Dormitory Canteen"
	icon_state = "dorms_canteen"
	ceiling = CEILING_GLASS

/area/strata/ag/interior/mining_outpost/flight_control
	name = "Mining Outpost Flight Control"
	icon_state = "dorms_lobby"
	is_landing_zone = TRUE

//-Outside interiors

/area/strata/ag/interior/outside
	name= "Do not use."
	icon_state = "outpost_gen_3"

/area/strata/ag/interior/outside/administration
	name = "Flight Control Offices"
	icon_state = "offices"
	minimap_color = MINIMAP_AREA_COMMAND
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS
	linked_lz = DROPSHIP_LZ1

/area/strata/ag/interior/outside/wooden_hospital
	name = "Wooden Hospital - Hospital Proper"
	icon_state = "cabin3"
	minimap_color = MINIMAP_AREA_CAVES
	unoviable_timer = FALSE

/area/strata/ag/interior/mountain
	name = "Outside mountain"
	icon_state = "ag_e"

/area/strata/ag/interior/outside/mountain
	name = "Outside mountain"
	icon_state = "ag_e"

/area/strata/ag/interior/outside/checkpoints
	name= "Do not use."
	icon_state = "security_station"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS
	minimap_color = MINIMAP_AREA_SEC

/area/strata/ag/interior/outside/checkpoints/north_armor
	name = "North Security Armored Checkpoint"

/area/strata/ag/interior/outside/checkpoints/north
	name = "Landing Zone North Security Checkpoint"

/area/strata/ag/interior/outside/checkpoints/west
	name = "Landing Zone West Security Checkpoint"

/area/strata/ag/interior/outside/checkpoints/south
	name = "Landing Zone South Security Checkpoint"
	is_landing_zone = TRUE

/area/strata/ag/interior/outside/checkpoints/outpost
	name = "Outpost Deck Security Checkpoint"
	icon_state = "rdecks_sec"

/area/strata/ag/interior/outside/engineering
	name = "Do not use."
	icon_state = "outpost_engi_3"
	minimap_color = MINIMAP_AREA_ENGI
	linked_lz = DROPSHIP_LZ2

/area/strata/ag/interior/outside/engineering/parts_storage
	name = "Engineering Parts Storage"
	icon_state = "outpost_engi_1"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/strata/ag/interior/outside/engineering/parts_storage_exterior
	name = "Engineering Parts Storage Exterior"
	weather_enabled = TRUE

/area/strata/ag/interior/outside/engineering/parts_storage_cave
	name = "Engineering Parts Storage Exterior"
	icon_state = "outpost_engi_4"
	minimap_color = MINIMAP_AREA_ENGI_CAVE
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS

/area/strata/ag/interior/outside/bball //come on and SLAM.
	name = "Outpost Basket Ball Court"
	icon_state = "outpost_gen_4"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS
	minimap_color = MINIMAP_AREA_CAVES

/area/strata/ag/interior/outside/bball/cave //come on BURST AND DIE.
	name = "Outpost - B-Ball Caves"
	icon_state = "hive_1"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	minimap_color = MINIMAP_AREA_CAVES_DEEP
	unoviable_timer = FALSE


//-Underground Dorms

/area/strata/ug/interior/outpost
	name = "Do not use."
	icon_state = "shed_x_ug"
	minimap_color = MINIMAP_AREA_CAVES

/area/strata/ug/interior/outpost/underground_dorms
	name = "Do not use."
	icon_state = "ug_jung_dorm"
	minimap_color = MINIMAP_AREA_CAVES_STRUCTURE

/area/strata/ug/interior/outpost/underground_dorms/sec1
	name = "Underground Security Dorm #1"
	unoviable_timer = FALSE

/area/strata/ug/interior/outpost/underground_dorms/sec2
	name = "Underground Security Dorm #2"
	unoviable_timer = FALSE

/area/strata/ug/interior/outpost/underground_dorms/admin1
	name = "Underground General Staff Dorm #1"

/area/strata/ug/interior/outpost/underground_dorms/admin2
	name = "Underground General Staff Dorm #2"
	unoviable_timer = FALSE

/area/strata/ug/interior/outpost/underground_dorms/admin3
	name = "Underground General Staff Dorm #3"
	unoviable_timer = FALSE

/area/strata/ug/interior/outpost/underground_dorms/admin4
	name = "Underground General Staff Dorm #4"
	unoviable_timer = FALSE

/area/strata/ug/interior/outpost/underground_dorms/med1
	name = "Underground Medical Dorm #1"
	requires_power = 1

/area/strata/ug/interior/outpost/underground_dorms/med2
	name = "Underground Medical Dorm #2"
	requires_power = TRUE

//-Underground platform

/area/strata/ug/interior/outpost/platform
	name = "Underground Platform"
	icon_state = "ug_jung_1"
	minimap_color = MINIMAP_AREA_MEDBAY_CAVE

//-Underground Jungle

/area/strata/ug/interior/jungle
	name = "Do not use."
	icon_state = "ug_jung_0"
	minimap_color = MINIMAP_AREA_JUNGLE

/area/strata/ug/interior/jungle/carplake
	name = "Do not use."
	icon_state = "ug_jung_1"
	unoviable_timer = FALSE

/area/strata/ug/interior/jungle/carplake/north
	name = "Deep Jungle - North of Carp Lake"
	icon_state = "ug_jung_6"

/area/strata/ug/interior/jungle/carplake/east
	name = "Deep Jungle - East of Carp Lake"
	icon_state = "ug_jung_5"

/area/strata/ug/interior/jungle/platform
	name = "Do not use."
	icon_state = "ug_jung_1"

/area/strata/ug/interior/jungle/platform/south
	name = "Deep Jungle - South of Underground Platform"
	icon_state = "ug_jung_4"
	unoviable_timer = FALSE

/area/strata/ug/interior/jungle/platform/east
	name = "Deep Jungle - East of Underground Platform"
	icon_state = "ug_jung_0"
	unoviable_timer = FALSE

/area/strata/ug/interior/jungle/structures
	name = "Do not use."
	icon_state = "ug_jung_mine_1"
	ceiling = CEILING_DEEP_UNDERGROUND_METAL

/area/strata/ug/interior/jungle/structures/research
	icon_state = "ug_jung_2"
	name = "Deep Jungle - Classified Research Station"
	minimap_color = MINIMAP_AREA_RESEARCH
	unoviable_timer = FALSE

/area/strata/ug/interior/jungle/structures/research/south
	icon_state = "ug_jung_3"
	name = "Deep Jungle - South of Classified Research Station"
	minimap_color = MINIMAP_AREA_JUNGLE

/area/strata/ug/interior/jungle/structures/research/hot_springs
	icon_state = "ug_jung_4"
	name = "Deep Jungle - Hot Springs"
	minimap_color = MINIMAP_AREA_JUNGLE

/area/strata/ug/interior/jungle/structures/research/old_tunnels
	icon_state = "ug_jung_mine_1"
	name = "Deep Jungle - Old Tunnels"
	minimap_color = MINIMAP_AREA_JUNGLE

/area/strata/ug/interior/jungle/structures/monitoring
	icon_state = "ug_jung_5"
	name = "Deep Jungle - Planetary Core Monitoring"
	minimap_color = MINIMAP_AREA_CAVES_STRUCTURE
	unoviable_timer = FALSE

/area/strata/ug/interior/jungle/structures/monitoring/west
	icon_state = "ug_jung_6"
	name = "Deep Jungle - West of Planetary Core Monitoring"
	minimap_color = MINIMAP_AREA_JUNGLE

/area/strata/ug/interior/jungle/structures/monitoring/south
	icon_state = "ug_jung_7"
	name = "Deep Jungle - South of Planetary Core Monitoring"
	minimap_color = MINIMAP_AREA_JUNGLE

/area/strata/ug/interior/jungle/structures/monitoring/east
	icon_state = "ug_jung_8"
	name = "Deep Jungle - East of Planetary Core Monitoring"
	minimap_color = MINIMAP_AREA_JUNGLE

/area/strata/ug/interior/jungle/structures/ruin
	icon_state = "ug_jung_mine_4"
	name = "Deep Jungle - Ancient Dorms"
	unoviable_timer = FALSE

/area/strata/ug/interior/jungle/tearlake
	name = "Deep Jungle - Weeping Pool"
	icon_state = "ug_jung_3"
	unoviable_timer = FALSE

//-Others

/area/strata/ag/interior/restricted
	name = "Super Secret Credits Room"
	icon_state = "marshwater"
	requires_power = FALSE
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL|AREA_UNWEEDABLE

