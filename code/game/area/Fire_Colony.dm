
// Areas for the Fire Colony map (nickname is "Shiva's Snowball")

//Base Instance
/area/fire_colony
	name = "\improper Fire Colony"
	icon_state = "ice_colony"
	icon_state = "cliff_blocked"
	can_build_special = TRUE
	powernet_name = "ground"
	minimap_color = MINIMAP_AREA_COLONY

/*
 *  ----------------
 * | Exterior Areas |
 *  ----------------
 */

/area/fire_colony/exterior
	name = "\improper Fire Colony"
	icon_state = "cliff_blocked"
	requires_power = 1
	always_unpowered = 1
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE
	temperature = T20C

//
/// Exterior - Surface
//

/area/fire_colony/exterior/surface
	name = "\improper Fire Colony - Exterior Surface"
	soundscape_playlist = SCAPE_PL_LV522_OUTDOORS

//Equivalent of space. None of this area should be accessible.
/area/fire_colony/exterior/surface/cliff
	name = "\improper Basalt Cliffs"
	icon_state = "cliff_blocked"

/area/fire_colony/exterior/surface/landing_pad
	name = "\improper Aerodrome Landing Pad"
	icon_state = "landing_pad"
	minimap_color = MINIMAP_AREA_LZ

//Everything around the physical landing pad
/area/fire_colony/exterior/surface/landing_pad_external
	name = "\improper Aerodrome Landing Valley"
	icon_state = "clear_pass"
	minimap_color = MINIMAP_AREA_LZ

/area/fire_colony/exterior/surface/container_yard
	name = "\improper Aerodrome Container Yard"
	icon_state = "green"
	minimap_color = MINIMAP_AREA_LZ

//
/// Valleys
//

/area/fire_colony/exterior/surface/valley
	name = "\improper Ice Cliffs Valley"
	icon_state = "clear_pass"

/area/fire_colony/exterior/surface/valley/north
	name = "\improper Northern Valleys"
	icon_state = "clear_pass"

/area/fire_colony/exterior/surface/valley/northeast
	name = "\improper North Eastern Valleys"
	icon_state = "clear_pass"

/area/fire_colony/exterior/surface/valley/northwest
	name = "\improper North Western Valleys"
	icon_state = "clear_pass"

/area/fire_colony/exterior/surface/valley/west
	name = "\improper Western Valleys"
	icon_state = "clear_pass"

/area/fire_colony/exterior/surface/valley/south
	name = "\improper Southern Valleys"
	icon_state = "clear_pass"

/area/fire_colony/exterior/surface/valley/southeast
	name = "\improper Eastern Valleys"
	icon_state = "clear_pass"

/area/fire_colony/exterior/surface/valley/southwest
	name = "\improper South Western Valleys"
	icon_state = "clear_pass"

//
// Clearing
// The Colony Center, so to speak
//

/area/fire_colony/exterior/surface/clearing
	name = "\improper Fire Colony - Clearing"
	icon_state = "clear_pass"

/area/fire_colony/exterior/surface/clearing/pass
	name = "\improper Colony Central Valley"
	icon_state = "clear_pass"

/area/fire_colony/exterior/surface/clearing/south
	name = "\improper Colony Southern Clearing"
	icon_state = "clear_pass"

/area/fire_colony/exterior/surface/clearing/south_west
	name = "\improper Colony South Western Clearing"
	icon_state = "clear_pass"

/area/fire_colony/exterior/surface/clearing/north
	name = "\improper Colony Northern Clearing"
	icon_state = "clear_pass"

/area/fire_colony/exterior/surface/clearing/north_east
	name = "\improper Colony North Eastern Clearing"
	icon_state = "clear_pass"

//
/// Excavation - Underground ruins
//

/area/fire_colony/exterior/underground
	name = "\improper Fire Colony - Exterior Underground"
	icon_state = "alarm_down"
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
	soundscape_playlist = SCAPE_PL_CAVE
	soundscape_interval = 25
	ambience_exterior = AMBIENCE_CAVE
	minimap_color = MINIMAP_AREA_CAVES
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS

/area/fire_colony/exterior/underground/excavation/south
	name = "\improper Southern Valleys - Excavation Site"
	icon_state = "alarm_down"

/area/fire_colony/exterior/underground/excavation/north
	name = "\improper North Eastern Valleys - Excavation Site"
	icon_state = "alarm_down"

//
/// Caves
//

/area/fire_colony/exterior/underground/caves
	name = "\improper Underground Caves"
	icon_state = "alarm_down"
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
	soundscape_playlist = SCAPE_PL_CAVE
	soundscape_interval = 25
	ambience_exterior = AMBIENCE_CAVE
	minimap_color = MINIMAP_AREA_CAVES
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS

/area/fire_colony/exterior/underground/caves/south_west
	icon_state = "alarm_down"

/area/fire_colony/exterior/underground/caves/north_west
	icon_state = "alarm_down"

/area/fire_colony/exterior/underground/caves/dig
	icon_state = "mining_living"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS


/*
 *  ---------------------
 * | Built Surface Areas |
 *  ---------------------
 */

/area/fire_colony/surface
	name = "\improper Fire Colony - Built Surface"
	icon_state = "clear_pass"
	ceiling = CEILING_METAL

/*
 * Surface - Bar
 */


/area/fire_colony/surface/bar
	name = "\improper The Lava Lamp - Bar"
	icon_state = "bar"

/area/fire_colony/surface/bar/canteen
	name = "\improper The Lava Lamp - Canteen"
	icon_state = "bar"

/*
 * Surface - Seegson - Eastern Large Facility
 */

/area/fire_colony/surface/seegson
	name = "\improper Seegson"
	icon_state = "dk_yellow"
	soundscape_playlist = SCAPE_PL_LV759_INDOORS
	ambience_exterior = AMBIENCE_HYBRISA_INTERIOR
	minimap_color = MINIMAP_AREA_CELL_HIGH

/area/fire_colony/surface/seegson/synthetic_storage
	name = "\improper Seegson - Synthetic Storage Facility"

/area/fire_colony/surface/seegson/operations
	name = "\improper Seegson - Synthetic Operations"

/area/fire_colony/surface/seegson/smelting
	name = "\improper Seegson - Refinement & Production"

/area/fire_colony/surface/seegson/engineering
	name = "\improper Seegson - Power Management Center"

/area/fire_colony/surface/seegson/engineering/electric_storage
	name = "\improper Seegson - Power Management Center - Electric Storage"

/area/fire_colony/surface/seegson/engineering/generator_room
	name = "\improper Seegson - Power Management Center - Generator Room"

/area/fire_colony/surface/seegson/engineering/tool_storage
	name = "\improper Seegson - Power Management Center - Tool Storage"

/area/fire_colony/surface/seegson/ai_core
	name = "\improper Seegson - Synthetic Control Mainframe"
	icon_state = "alarm_ready"

/area/fire_colony/surface/seegson/ai_core/lobby
	name = "\improper Seegson - Synthetic Control - Lobby"
	icon_state = "alarm_ready"


/*
 * Surface - Disposals
 */

/area/fire_colony/surface/disposals
	name = "\improper Seegson - Disposals Unit"
	icon_state = "disposal"

/*
 * Surface - Dormitories
 */

/area/fire_colony/surface/dorms
	name = "\improper Dormitories"
	icon_state = "alarm_evac"

/area/fire_colony/surface/dorms/canteen
	name = "\improper Dormitories Canteen"
	icon_state = "alarm_evac"

/area/fire_colony/surface/dorms/lavatory
	name = "\improper Dormitories Lavatory"
	icon_state = "alarm_evac"

/area/fire_colony/surface/dorms/restroom_w
	name = "\improper Dormitories West Restroom"
	icon_state = "alarm_evac"

/area/fire_colony/surface/dorms/restroom_e
	name = "\improper Dormitories East Restroom"
	icon_state = "alarm_evac"

/*
 * Surface - Excavation Preparation
 */

/area/fire_colony/surface/excavation
	name = "\improper Lasalle Bionational - Excavation Outpost"
	icon_state = "mining_outpost"
	minimap_color = MINIMAP_AREA_ENGI

/area/fire_colony/surface/excavation/storage
	name = "\improper Lasalle Bionational - Excavation Outpost External Storage"
	icon_state = "mining_storage"

/*
 * Surface - Garage
 */

/area/fire_colony/surface/garage
	name = "\improper Seegson - Old Mining Power & Stroag"
	icon_state = "garage"

/area/fire_colony/surface/garage/one
	name = "\improper Seegson - Synthetic Storage Facility"
	icon_state = "garage_one"

/*
 * Surface - Hangar
 */

/area/fire_colony/surface/hangar
	name = "\improper Aerodrome Hangar"
	icon_state = "hangar"

/area/fire_colony/surface/hangar/hallway
	name = "\improper Aerodrome Hangar Hallway"

/area/fire_colony/surface/hangar/alpha
	name = "\improper Aerodrome Hangar 'Alpha'"
	icon_state = "hangar_alpha"

/area/fire_colony/surface/hangar/beta
	name = "\improper Aerodrome Hangar 'Beta'"
	icon_state = "hangar_beta"

/area/fire_colony/surface/hangar/checkpoint
	name = "\improper Aerodrome Hangar Security Checkpoint"
	icon_state = "security"

/*
 * Surface - Hydroponics
 */

/area/fire_colony/surface/hydroponics
	name = "\improper Fire Colony - Hydroponics"
	icon_state = "hydro"
	ceiling = CEILING_GLASS
	minimap_color = MINIMAP_AREA_RESEARCH

/area/fire_colony/surface/hydroponics/lobby
	name = "\improper Hydroponics Relaxation Module"
	icon_state = "garden"

/area/fire_colony/surface/hydroponics/north
	name = "\improper Hydroponics North Wing"
	icon_state = "hydro_north"

/area/fire_colony/surface/hydroponics/south
	name = "\improper Hydroponics South Wing"
	icon_state = "hydro_south"

/area/fire_colony/surface/hydroponics/science
	name = "\improper Lasalle Bionational - Hydroponics Science Module"
	icon_state = "garden"

/*
 * Surface - Mining
 */

/area/fire_colony/surface/mining
	name = "\improper Seegson - South Western Valleys - Old Mining Outpost - Power"
	icon_state = "mining_production"
	minimap_color = MINIMAP_AREA_ENGI

/area/fire_colony/surface/mining_garage
	name = "\improper Seegson - South Western Valleys - Old Mining Outpost - Garage"
	icon_state = "mining_production"
	minimap_color = MINIMAP_AREA_ENGI

/area/fire_colony/surface/mining_north_west
	name = "\improper Seegson - North Eastern Clearing - Old Mining Outpost"
	icon_state = "mining_production"
	minimap_color = MINIMAP_AREA_ENGI

/*
 * Surface - Lasalle Bionational - Labs - NW corner of map
 */

/area/fire_colony/surface/epsilon_facility
	name = "\improper Lasalle Bionational - Epsilon Facility"
	icon_state = "purple"
	minimap_color = MINIMAP_AREA_RESEARCH
	ceiling = CEILING_DEEP_UNDERGROUND_METAL

/area/fire_colony/surface/epsilon_facility/containment
	name = "\improper Lasalle Bionational - Epsilon Facility - Secure Containment Annex"

/*
 * Surface - Lasalle Bionational - Hospital & Disembarking Lobby / Passthrough
 */

/area/fire_colony/surface/omicron_facility
	name = "\improper Lasalle Bionational - Omicron Facility"
	icon_state = "green"
	minimap_color = MINIMAP_AREA_ENGI

/area/fire_colony/surface/omicron_facility/hospital
	name = "\improper Lasalle Bionational - Omicron Facility - Hospital"
	icon_state = "medbay3"

/area/fire_colony/surface/omicron_facility/hospital/storage
	name = "\improper Lasalle Bionational - Omicron Facility - Hospital Storage"
	icon_state = "medbay3"

/area/fire_colony/surface/omicron_facility/passthrough
	name = "\improper Lasalle Bionational - Omicron Facility - Facility Passthrough"
	icon_state = "bluenew"

/area/fire_colony/surface/omicron_facility/lobby
	name = "\improper Lasalle Bionational - Omicron Facility - Lobby"
	icon_state = "bluenew"

/*
 * Surface - Storage Units - Various small units across the map
 */

/area/fire_colony/surface/storage_unit
	name = "\improper Storage Unit"
	icon_state = "storage"

/area/fire_colony/surface/storage_unit/s_caves
	name = "\improper Storage Unit - South Excavation Caves"
	icon_state = "storage"

/area/fire_colony/surface/storage_unit/n_caves
	name = "\improper Storage Unit - North Caves"
	icon_state = "storage"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/fire_colony/surface/storage_unit/sw_valley
	name = "\improper Storage Unit - South Western Valley"
	icon_state = "storage"

/area/fire_colony/surface/storage_unit/e_valley
	name = "\improper Storage Unit - Eastern Valley"
	icon_state = "storage"

/area/fire_colony/surface/storage_unit/e_valley
	name = "\improper Storage Unit - Eastern Valley"
	icon_state = "storage"

/area/fire_colony/surface/storage_unit/t_comms_storage
	name = "\improper Telecommunications - Storage Unit - Southern Clearing"
	icon_state = "storage"

/*
 * Surface - Telecommunications
 */

/area/fire_colony/surface/tcomms
	name = "\improper Colony Telecommunications"
	icon_state = "blueold"

/*
 *  -------------------------
 * | Built Underground Areas |
 *  -------------------------
 */

/area/fire_colony/underground
	name = "\improper Fire Colony - Built Underground"
	icon_state = "explored"
	ceiling = CEILING_DEEP_UNDERGROUND_METAL
	ambience_exterior = AMBIENCE_ALMAYER
	ceiling_muffle = FALSE
	sound_environment = SOUND_ENVIRONMENT_ROOM
	minimap_color = MINIMAP_AREA_CAVES

/*
 * Underground - Hangar
 */

/area/fire_colony/underground/hangar
	name = "\improper Lasalle Bionational - Underground Hangar"
	icon_state = "landing_pad_ext"
	ceiling = CEILING_NONE

/area/fire_colony/underground/hangar/flight_control
	name = "\improper Lasalle Bionational - Underground Hangar - Flight Control Office"
	icon_state = "landing_pad_ext"
	ceiling = CEILING_METAL

/area/fire_colony/underground/hangar/garage
	name = "\improper Lasalle Bionational - Underground Hangar - Garage"
	icon_state = "landing_pad_ext"
	ceiling = CEILING_METAL
