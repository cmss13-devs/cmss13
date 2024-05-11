
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
	temperature = SOROKYNE_TEMPERATURE //If not in a building, it'll be cold. All interior areas are set to T20C
	minimap_color = MINIMAP_AREA_COLONY

/area/shuttle/drop1/strata //Not in Sulaco.DM because holy shit we need to sort things.
	name = "Dropship Alamo Landing Zone"
	icon_state = "shuttle"
	base_lighting_alpha = 255
	minimap_color = MINIMAP_AREA_LZ
	is_resin_allowed = FALSE

/area/shuttle/drop2/strata
	name = "Dropship Normandy Landing Zone"
	icon_state = "shuttle2"
	base_lighting_alpha = 255
	minimap_color = MINIMAP_AREA_LZ
	is_resin_allowed = FALSE

/area/strata/ag
	name = "Above Ground Area"
	icon_state = "ag"

/area/strata/ag/exterior
	name = "Exterior Above Ground Area"
	icon_state = "ag_e"
	//always_unpowered = 1 So exterior lights work, this will be commented out unless it causes unforseen issues.
	is_resin_allowed = FALSE

/area/strata/ag/exterior/paths
	is_resin_allowed = TRUE

/area/strata/ag/interior
	name = "Interior Above Ground Area"
	icon_state = "ag_i"
	requires_power = 1
	temperature = T20C //Nice and room temp
	ceiling = CEILING_METAL

/area/strata/ag/interior/mountain
	name = "Outside mountain"
	icon_state = "ag_e"

/area/strata/ag/interior/restricted
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL

/area/strata/ag/interior/restricted/devroom
	name = "Super Secret Credits Room"

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

//END PARENT ENTITIES

//Begin actual area definitions. There's probably a better way to do this.

/area/strata/ag/interior/research_decks/security //For all security stuff outside the outpost.
	name = "Outpost Deck Security Checkpoint"
	icon_state = "rdecks_sec"

////////Telecomms//////////////////

/area/strata/ag/exterior/tcomms
	name = "Do not use."
	icon_state = "tcomms1"

/area/strata/ag/exterior/tcomms/mining_caves
	name = "Mining Caves Relay"


//JUNGLE CAVES, ALL UNDERGROUND, ALL INTERIOR//

/area/strata/ug/interior/jungle
	name = "Deep I"

//Topside Structures //Clean these up into a sub tree

/area/strata/ag/interior/landingzone_checkpoint
	name = "Landing Zone Security Checkpoint"
	icon_state = "security_station"
	minimap_color = MINIMAP_AREA_SEC

/area/strata/ag/exterior/vanyard
	name = "Flight Control Vehicle Yard"
	icon_state = "garage"

/area/strata/ag/interior/administration
	name = "Flight Control Offices"
	icon_state = "offices"
	minimap_color = MINIMAP_AREA_COMMAND


//More topside areas, somehow these got duplicated?? Includes some parent defs.

//Also marshes



/area/strata/ug/interior/jungle/deep/minehead
	icon_state = "cabin2"
	name = "Deep Jungle - Minehead"

///OUTPOST INTERIOR///

/area/strata/ag/interior/outpost
	name = "Sorokyne Outpost"
	icon_state = "research_station"

/area/strata/ag/interior/outpost/gen
	name = "Outpost Interior"
	icon_state = "outpost_gen_0"

/area/strata/ag/interior/outpost/gen/foyer
	name = "Outpost Main Foyer"
	icon_state = "outpost_gen_1"

/area/strata/ag/interior/outpost/gen/bball //come on and SLAM.
	name = "Outpost Basket Ball Court"
	icon_state = "outpost_gen_4"

/area/strata/ag/interior/outpost/gen/bball/nest //come on and BURST AND DIE.
	name = "Outpost - B-Ball Caves"
	icon_state = "hive_1"


///ALL MAINTENANCE AREAS///


/area/strata/ag/interior/outpost/maint
	name = "Outpost Maintenance"
	icon_state = "outpost_maint"

/area/strata/ag/interior/outpost/maint/canteen_e_1
	name = "Outpost Canteen - Eastern Maintenance"

///OUTPOST MEDICAL///

/area/strata/ag/interior/outpost/med
	name = "Outpost Medical"
	icon_state = "outpost_med"
	minimap_color = MINIMAP_AREA_MEDBAY

///OUTPOST ENGINEERING///

/area/strata/ag/interior/engineering
	name = "Do not use."
	icon_state = "outpost_engi_3"

/area/strata/ag/interior/engineering/parts_storage
	name = "Engineering Parts Storage"
	icon_state = "outpost_engi_1"

/area/strata/ag/interior/engineering/parts_storage_exterior
	name = "Engineering Parts Storage Exterior"

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

///OUTPOST SECURITY

/area/strata/ag/interior/outpost/security
	name = "Outpost Security"
	icon_state = "outpost_sec_0"
	minimap_color = MINIMAP_AREA_SEC

///OUTPOST ADMINISTRATION

/area/strata/ag/interior/outpost/admin
	name = "Outpost Administration"
	icon_state = "outpost_admin_0"
	minimap_color = MINIMAP_AREA_COMMAND


///CANTEEN / GENERAL QUARTERS///

/area/strata/ag/interior/outpost/canteen
	name = "Outpost Canteen"
	icon_state = "outpost_canteen_0"

/area/strata/ag/interior/outpost/canteen/bar
	name = "Outpost Bar"
	icon_state = "outpost_canteen_2"

/area/strata/ag/interior/outpost/canteen/lower_cafeteria
	name = "Outpost Cafeteria"
	icon_state = "outpost_canteen_0"

/area/strata/ag/interior/outpost/canteen/personal_storage
	name = "Outpost Personal Storage"



///JUNGLE STRUCTURES - UNDERGROUND///




////END OUTPOST DEFINES////

///DEEP JUNGLE///

/area/strata/ug/exterior
	ceiling = CEILING_NONE

/area/strata/ug/exterior/jungle/deep/carplake_water
	name = "Deep Jungle - Carp Lake Waters"
	icon_state = "ug_jung_5"

/area/strata/ug/exterior/jungle/deep/carplake_center
	name = "Deep Jungle - Carp Lake Center Island"
	icon_state = "ug_jung_1"


/area/strata/ug/interior/jungle/deep/north_carp
	name = "Deep Jungle - North of Carp Lake"
	icon_state = "ug_jung_6"

/area/strata/ug/interior/jungle/deep/south_carp
	name = "Deep Jungle - South of Carp Lake"
	icon_state = "ug_jung_3"

/area/strata/ug/interior/jungle/deep/east_carp
	name = "Deep Jungle - East of Carp Lake"
	icon_state = "ug_jung_5"

/area/strata/ug/interior/jungle/deep/tearlake
	name = "Deep Jungle - Weeping Pool"
	icon_state = "ug_jung_3"

/area/strata/ug/interior/jungle/deep/tearlake_south
	name = "Deep Jungle - South of Weeping Pool"
	icon_state = "ug_jung_8"

/area/strata/ug/interior/jungle/deep/tearlake_north
	name = "Deep Jungle - North of Weeping Pool"
	icon_state = "ug_jung_3"

/area/strata/ug/interior/jungle/deep/tearlake_east
	name = "Deep Jungle - East of Weeping Pool"
	icon_state = "ug_jung_6"

/area/strata/ug/interior/jungle/deep/tearlake_west
	name = "Deep Jungle - West of Weeping Pool"
	icon_state = "ug_jung_5"

/area/strata/ug/interior/jungle/deep/south_dorms
	name = "Deep Jungle - South Dorms"
	icon_state = "ug_jung_4"

/area/strata/ug/interior/jungle/deep/east_dorms
	name = "Deep Jungle - East Dorms"
	icon_state = "ug_jung_0"

/area/strata/ug/interior/jungle/deep/structures
	name = "Deep Jungle - Unknown Structure"
	icon_state = "ug_jung_1"
	ceiling = CEILING_DEEP_UNDERGROUND_METAL

/area/strata/ug/interior/jungle/deep/structures/res
	icon_state = "ug_jung_2"
	name = "Deep Jungle - Classified Research Station"

/area/strata/ug/interior/jungle/deep/south_res
	icon_state = "ug_jung_3"
	name = "Deep Jungle - South of Classified Research Station"

/area/strata/ug/interior/jungle/deep/hotsprings
	icon_state = "ug_jung_4"
	name = "Deep Jungle - Hot Springs"

/area/strata/ug/interior/jungle/deep/structures/engi
	icon_state = "ug_jung_5"
	name = "Deep Jungle - Planetary Core Monitoring"

/area/strata/ug/interior/jungle/deep/south_engi
	icon_state = "ug_jung_7"
	name = "Deep Jungle - South of Core Monitoring"

/area/strata/ug/interior/jungle/deep/east_engi
	icon_state = "ug_jung_6"
	name = "Deep Jungle - East of Core Monitoring"

/area/strata/ug/interior/jungle/deep/west_engi
	icon_state = "ug_jung_8"
	name = "Deep Jungle - West of Core Monitoring"

/area/strata/ug/interior/jungle/deep/minehead
	icon_state = "ug_jung_mine_1"
	name = "Deep Jungle - Old Tunnels"

/area/strata/ug/interior/jungle/deep/minehead/north
	icon_state = "ug_jung_mine_2"
	name = "Deep Jungle - North Old Tunnels"

/area/strata/ug/interior/jungle/deep/minehead/south
	icon_state = "ug_jung_mine_3"
	name = "Deep Jungle - South Old Tunnels"

/area/strata/ug/interior/jungle/deep/minehead/east
	icon_state = "ug_jung_mine_4"
	name = "Deep Jungle - East Old Tunnels"

/area/strata/ug/interior/jungle/deep/minehead/west
	icon_state = "ug_jung_mine_5"
	name = "Deep Jungle - West Old Tunnels"

/area/strata/ug/interior/jungle/deep/minehead/ruins
	icon_state = "ug_jung_mine_4"
	name = "Deep Jungle - Ancient Dorms"


// ------===| Exterior |===------

//-Landing Zones
/area/strata/ag/exterior/landing_zones
	name = "Do not use."
	icon_state = "landingzone_2"
	minimap_color = MINIMAP_AREA_LZ
	is_resin_allowed = FALSE

/area/strata/ag/exterior/landing_zones/lz2
	name = "Landing Zone 2 Pad - Ice Fields"
	unlimited_power = 1 //So the DS computer always works for the Queen
	weather_enabled = FALSE
	is_landing_zone = TRUE

/area/strata/ag/exterior/landing_zones/near_lz2
	name = "Landing Zone 2 - Ice Fields"
	icon_state = "nearlz2"
	weather_enabled = TRUE

/area/strata/ag/interior/landing_zones
	name = "Do not use."
	icon_state = "landingzone_1"
	minimap_color = MINIMAP_AREA_LZ
	weather_enabled = FALSE
	is_resin_allowed = FALSE

/area/strata/ag/interior/landing_zones/lz1
	name = "Landing Zone 1 Pad - Mining Aerodrome"
	unlimited_power = 1 //So the DS computer always works for the Queen
	is_landing_zone = TRUE

/area/strata/ag/interior/landing_zones/near_lz1
	name = "Landing Zone 1 - Mining Aerodrome"
	icon_state = "nearlz1"


//-Caves
/area/strata/ag/exterior/caves
	name = "Do not use."
	icon_state = "lzcaves"

/area/strata/ag/exterior/caves/shed_five_caves
	name = "Terminal Five Topside Caves"
	is_resin_allowed = TRUE

/area/strata/ag/exterior/caves/lz_caves
	name = "External Mining Aerodrome Caves"

//-Marsh

/area/strata/ag/exterior/marsh
	name = "Do not use."
	icon_state = "marsh"

/area/strata/ag/exterior/marsh/spring_marshes
	name = "Cryo-Thermal Springs Marshes"

/area/strata/ag/exterior/marsh/water_marshes
	name = "Cryo-Thermal Water Marshes"

/area/strata/ag/exterior/marsh/island_marshes
	name = "Cryo-Thermal Island Marshes"

/area/strata/ag/exterior/marsh/relay_marshes
	name = "Cryo-Thermal Relay Marshes"

/area/strata/ag/exterior/marsh/center
	name = "Cryo-Thermal Springs"
	icon_state = "marshcenter"

/area/strata/ag/exterior/marsh/river
	name = "Cryo-Thermal River"
	icon_state = "marshriver"

/area/strata/ag/exterior/marsh/crash
	name = "Cryo-Thermal Crashed Lifeboat"
	icon_state = "marshship"

/area/strata/ag/exterior/marsh/water
	name = "Cryo-Thermal Water"
	icon_state = "marshwater"
	temperature = TCMB //space cold

//-Outpost

/area/strata/ag/exterior/outpost_decks
	name = "Outpost Decks"
	icon_state = "rdecks"
	is_resin_allowed = TRUE
	minimap_color = MINIMAP_AREA_RESEARCH


//-Paths

/area/strata/ag/exterior/paths //parent entity, just for sorting within the object tree, if anything, very generic, use as a placeholder.
	name = "Ice Path"
	icon_state = "path"

/area/strata/ag/exterior/paths/flight_control_exterior
	name = "Flight Control Exterior"

/area/strata/ag/exterior/paths/mining_outpost_exterior
	name = "Mining Outpost Exterior"
	is_resin_allowed = FALSE

/area/strata/ag/exterior/paths/north_outpost
	name = "Outpost - North Access Channel"
	icon_state = "outpost_gen_2"

/area/strata/ag/exterior/paths/far_north_outpost
	name = "Far North Of The Outpost"
	icon_state = "cabin"

/area/strata/ag/interior/paths/wooden_hospital
	name = "Wooden Hospital - Hospital Proper"
	icon_state = "cabin3"

/area/strata/ag/exterior/paths/south_outpost
	minimap_color = MINIMAP_AREA_RESEARCH
	name = "South Of The Outpost"

//-Underground "open" Lake




// ------===| Interior |===------


//-Outpost



//-Mining Outpost

/area/strata/ag/interior/mining_outpost
	name = "Do not use."
	is_resin_allowed = FALSE

/area/strata/ag/interior/mining_outpost/central
	name = "Mining Outpost Central Hallway"
	icon_state = "dorms_0"

/area/strata/ag/interior/mining_outpost/south_dormitories
	name = "Mining Outpost South Dormitories"
	icon_state = "dorms_3"

/area/strata/ag/interior/mining_outpost/maintenance
	name = "Mining Outpost Dormitory Maintenance"
	icon_state = "outpost_maint"
	is_resin_allowed = TRUE

/area/strata/ag/interior/mining_outpost/hive
	name = "Mining Outpost Dormitory Thermal Storage"
	icon_state = "dorms_beno"
	is_resin_allowed = TRUE

/area/strata/ag/interior/mining_outpost/canteen
	name = "Mining Outpost Dormitory Canteen"
	icon_state = "dorms_canteen"

/area/strata/ag/interior/mining_outpost/flight_control
	name = "Mining Outpost Flight Control"
	icon_state = "dorms_lobby"



//-Outside interiors




//-Underground Dorms

/area/strata/ug/interior/outpost/underground_dorms
	name = "Do not use."
	icon_state = "ug_jung_dorm"
	minimap_color = MINIMAP_AREA_CAVES

/area/strata/ug/interior/outpost/underground_dorms/sec1
	name = "Underground Security Dorm #1"

/area/strata/ug/interior/outpost/underground_dorms/sec2
	name = "Underground Security Dorm #2"

/area/strata/ug/interior/outpost/underground_dorms/admin1
	name = "Underground General Staff Dorm #1"

/area/strata/ug/interior/outpost/underground_dorms/admin2
	name = "Underground General Staff Dorm #2"

/area/strata/ug/interior/outpost/underground_dorms/admin3
	name = "Underground General Staff Dorm #3"

/area/strata/ug/interior/outpost/underground_dorms/admin4
	name = "Underground General Staff Dorm #4"

/area/strata/ug/interior/outpost/underground_dorms/med1
	name = "Underground Medical Dorm #1"

/area/strata/ug/interior/outpost/underground_dorms/med2
	name = "Underground Medical Dorm #2"

//-Underground platform

/area/strata/ug/interior/outpost/platform
	name = "Underground Platform"
	icon_state = "ug_jung_1"
	minimap_color = MINIMAP_AREA_JUNGLE


//-Underground Jungle

/area/strata/ug/interior/jungle/deep
	name = "Deep Jungle"
	ceiling = CEILING_DEEP_UNDERGROUND

/area/strata/ug/interior/jungle/deep/carplake
	name = "Deep Jungle - Carp Lake Shores"
	icon_state = "ug_jung_2"
