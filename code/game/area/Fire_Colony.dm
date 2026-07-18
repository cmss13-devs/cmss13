
// Areas for LV-376 Charon's Crucible (nickname is "Fire Colony")

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
	name = "\improper Fire Colony - Exterior"
	icon_state = "cliff_blocked"
	requires_power = 1
	always_unpowered = 1
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE
	temperature = T20C
	soundscape_playlist = SCAPE_PL_LV522_OUTDOORS

//Equivalent of space. None of this area should be accessible.

/area/fire_colony/exterior/cliff
	name = "\improper Basalt Cliffs"
	icon_state = "cliff_blocked"
	ceiling = CEILING_MAX
	is_resin_allowed = FALSE
	flags_area = AREA_NOBURROW
	minimap_color = MINIMAP_AREA_OOB
	requires_power = FALSE

//Everything around the physical landing pad

/area/fire_colony/exterior/landing_pad
	name = "\improper Old Seegson - Aerodrome - Landing Pad"
	icon_state = "landing_pad"
	minimap_color = MINIMAP_AREA_LZ

/area/fire_colony/exterior/landing_pad_external
	name = "\improper Old Seegson - Aerodrome - Landing Valley"
	icon_state = "clear_pass"
	minimap_color = MINIMAP_AREA_LZ

/area/fire_colony/exterior/container_yard
	name = "\improper Old Seegson - Aerodrome - Container Yard"
	icon_state = "green"

// Lava River - Bridge

/area/fire_colony/exterior/lava_bridge
	name = "\improper Colony Central - Lava Transit Bridge"
	icon_state = "red"

//
/// Valleys
//

/area/fire_colony/exterior/valley
	name = "\improper Basalt Cliffs Valley"
	icon_state = "clear_pass"

/area/fire_colony/exterior/valley/north
	name = "\improper Northern Valleys"
	icon_state = "clear_pass"

/area/fire_colony/exterior/valley/northeast
	name = "\improper North Eastern Valleys"
	icon_state = "clear_pass"

/area/fire_colony/exterior/valley/northwest
	name = "\improper North Western Valleys"
	icon_state = "clear_pass"

/area/fire_colony/exterior/valley/west
	name = "\improper Western Valleys"
	icon_state = "clear_pass"

/area/fire_colony/exterior/valley/south
	name = "\improper Southern Valleys"
	icon_state = "clear_pass"

/area/fire_colony/exterior/valley/southeast
	name = "\improper Eastern Valleys"
	icon_state = "clear_pass"

/area/fire_colony/exterior/valley/southwest
	name = "\improper South Western Valleys"
	icon_state = "clear_pass"

//
// Clearing
// The Colony Center, so to speak
//

/area/fire_colony/exterior/clearing
	name = "\improper Fire Colony - Clearing"
	icon_state = "clear_pass"

/area/fire_colony/exterior/clearing/pass
	name = "\improper Colony Central Valley"
	icon_state = "clear_pass"

/area/fire_colony/exterior/clearing/south
	name = "\improper Colony Southern Clearing"
	icon_state = "clear_pass"

/area/fire_colony/exterior/clearing/south_west
	name = "\improper Colony South Western Clearing"
	icon_state = "clear_pass"

/area/fire_colony/exterior/clearing/north
	name = "\improper Colony Northern Clearing"
	icon_state = "clear_pass"

/area/fire_colony/exterior/clearing/north_east
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
	ceiling_muffle = FALSE

/area/fire_colony/exterior/underground/excavation/south
	name = "\improper Southern Valleys - Excavation Site"
	icon_state = "alarm_down"

/area/fire_colony/exterior/underground/excavation/north
	name = "\improper North Eastern Valleys - Excavation Site"
	icon_state = "alarm_down"

/area/fire_colony/exterior/underground/excavation/south/excavation
	name = "\improper Southern Valleys - Excavation Site - Checkpoint"
	icon_state = "security"

/area/fire_colony/exterior/underground/excavation/north/excavation
	name = "\improper North Eastern Valleys - Excavation Site - Checkpoint"
	icon_state = "security"

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
	ceiling_muffle = FALSE

/area/fire_colony/exterior/underground/caves/south_west
	icon_state = "alarm_down"

/area/fire_colony/exterior/underground/caves/north_west
	icon_state = "alarm_down"

/*
 *  ---------------------
 * | Built Surface Areas |
 *  ---------------------
 */

/area/fire_colony/interior
	name = "\improper Fire Colony - Interior"
	icon_state = "clear_pass"
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV759_INDOORS
	ambience_exterior = AMBIENCE_HYBRISA_INTERIOR

/*
 * Surface - Refurbished Bar
 */

/area/fire_colony/interior/bar
	name = "\improper The Lava Lamp - Bar"
	icon_state = "bar"

/area/fire_colony/interior/bar/canteen
	name = "\improper The Lava Lamp - Canteen"
	icon_state = "bar"

/*
 * Surface - Seegson - Eastern Large Facility
 */

/area/fire_colony/interior/seegson
	name = "\improper Old Seegson"
	icon_state = "dk_yellow"
	minimap_color = MINIMAP_AREA_CELL_HIGH
	ceiling = CEILING_METAL

/area/fire_colony/interior/seegson/synthetic_storage
	name = "\improper Old Seegson - Synthetic Storage Facility"

/area/fire_colony/interior/seegson/operations
	name = "\improper Old Seegson - Synthetic Operations"

/area/fire_colony/interior/seegson/smelting
	name = "\improper Old Seegson - Refinement & Production"
	ceiling = CEILING_GLASS

/area/fire_colony/interior/seegson/engineering
	name = "\improper Old Seegson - Power Management Center"

/area/fire_colony/interior/seegson/engineering/electric_storage
	name = "\improper Old Seegson - Power Management Center - Electric Storage"

/area/fire_colony/interior/seegson/engineering/generator_room
	name = "\improper Old Seegson - Power Management Center - Generator Room"

/area/fire_colony/interior/seegson/engineering/tool_storage
	name = "\improper Old Seegson - Power Management Center - Tool Storage"

/area/fire_colony/interior/seegson/ai_core
	name = "\improper Old Seegson - Synthetic Control Mainframe"
	icon_state = "alarm_ready"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/fire_colony/interior/seegson/ai_core/lobby
	name = "\improper Old Seegson - Synthetic Control - Lobby"
	icon_state = "alarm_ready"
	ceiling = CEILING_GLASS

/*
 * Surface - Seegson - Disposals
 */

/area/fire_colony/interior/disposals
	name = "\improper Old Seegson - Disposals Unit"
	icon_state = "disposal"

/*
 * Surface - Seegson - Habitation Complex
 */

/area/fire_colony/interior/dorms
	name = "\improper Old Seegson - Habitation Complex"
	icon_state = "alarm_evac"
	ceiling = CEILING_GLASS

/area/fire_colony/interior/dorms/north
	name = "\improper Old Seegson - Habitation Complex - North"
	icon_state = "alarm_evac"

/area/fire_colony/interior/dorms/south
	name = "\improper Old Seegson - Habitation Complex - South"
	icon_state = "alarm_evac"
	ceiling = CEILING_METAL

/area/fire_colony/interior/dorms/relaxation
	name = "\improper Old Seegson - Habitation Complex - Relaxation Module"
	icon_state = "alarm_evac"

/area/fire_colony/interior/dorms/offices
	name = "\improper Old Seegson - Habitation Complex - Management Offices"
	icon_state = "alarm_evac"

/area/fire_colony/interior/dorms/dorms_p
	name = "\improper Old Seegson - Habitation Complex - Private Accommodation Units"
	icon_state = "alarm_evac"
	ceiling = CEILING_METAL

/area/fire_colony/interior/dorms/dorms_f
	name = "\improper Old Seegson - Habitation Complex - Female Accommodation Wing"
	icon_state = "alarm_evac"
	ceiling = CEILING_METAL

/area/fire_colony/interior/dorms/dorms_m
	name = "\improper Old Seegson - Habitation Complex - Male Accommodation Wing"
	icon_state = "alarm_evac"
	ceiling = CEILING_METAL

/*
 * Surface - Excavation Preparation
 */

/area/fire_colony/interior/excavation
	name = "\improper Lasalle Bionational - Excavation Outpost"
	icon_state = "mining_outpost"
	minimap_color = MINIMAP_AREA_ENGI

/area/fire_colony/interior/excavation/storage
	name = "\improper Lasalle Bionational - Excavation Outpost External Storage"
	icon_state = "mining_storage"
	ceiling = CEILING_NONE

/*
 * Surface - Garage
 */

/area/fire_colony/interior/garage
	name = "\improper Old Seegson - Old Mining Power & Stroag"
	icon_state = "garage"

/area/fire_colony/interior/garage/one
	name = "\improper Old Seegson - Synthetic Storage Facility"
	icon_state = "garage_one"

/*
 * Surface - Hangar
 */

/area/fire_colony/interior/hangar
	name = "\improper Old Seegson - Aerodrome - Hangar"
	icon_state = "hangar"

/area/fire_colony/interior/hangar/hallway
	name = "\improper Old Seegson - Aerodrome - Hangar - Hallway"

/area/fire_colony/interior/hangar/hallway_north
	name = "\improper Old Seegson - Aerodrome - Hangar - Hallway"
	icon_state = "hangar"

/area/fire_colony/interior/hangar/alpha
	name = "\improper Old Seegson - Aerodrome - Hangar - 'Alpha'"
	icon_state = "hangar_alpha"

/area/fire_colony/interior/hangar/beta
	name = "\improper Old Seegson - Aerodrome - Hangar - 'Beta'"
	icon_state = "hangar_beta"

/area/fire_colony/interior/hangar/broken_dropship
	name = "\improper Old Seegson - Aerodrome - Hangar - 'Beta' - Broken Dropship"
	icon_state = "green"

/area/fire_colony/interior/hangar/lb_dropship
	name = "\improper Old Seegson - Aerodrome - Hangar - 'Alpha' - UD2-LB 'Remedy'"
	icon_state = "green"
	ceiling = CEILING_METAL
	requires_power = 0
	ambience_exterior = AMBIENCE_ALMAYER
	ceiling_muffle = FALSE

/area/fire_colony/interior/hangar/checkpoint
	name = "\improper Old Seegson - Aerodrome - Hangar - Seegson Security Facility - Checkpoint"
	icon_state = "security"

/area/fire_colony/interior/hangar/checkpoint/excavation
	name = "\improper Old Seegson - Aerodrome - Landing Pad - Excavation Checkpoint"
	icon_state = "security"

/area/fire_colony/interior/hangar/security
	name = "\improper Old Seegson - Aerodrome - Hangar - Seegson Security Facility"
	icon_state = "security"

/area/fire_colony/interior/hangar/security/armory
	name = "\improper Old Seegson - Aerodrome - Hangar - Seegson Security Facility - Armory"
	icon_state = "security"

/*
 * Surface - Hydroponics
 */

/area/fire_colony/interior/hydroponics
	name = "\improper Lasalle Bionational - Xenoflora Research Complex"
	icon_state = "hydro"
	ceiling = CEILING_GLASS
	minimap_color = MINIMAP_AREA_RESEARCH

/area/fire_colony/interior/hydroponics/lobby
	name = "\improper Lasalle Bionational - Xenoflora Research Complex - Relaxation Module"
	icon_state = "garden"

/area/fire_colony/interior/hydroponics/north
	name = "\improper Lasalle Bionational - Xenoflora Research Complex - Greenhouse - North Wing"
	icon_state = "hydro_north"

/area/fire_colony/interior/hydroponics/south
	name = "\improper Lasalle Bionational - Xenoflora Research Complex - Greenhouse - South Wing"
	icon_state = "hydro_south"

/area/fire_colony/interior/hydroponics/science
	name = "\improper Lasalle Bionational - Xenoflora Research Complex - Science Module"
	icon_state = "garden"

/*
 * Surface - Mining
 */

/area/fire_colony/interior/mining
	name = "\improper Old Seegson - South Western Valleys - Old Mining Outpost - Power"
	icon_state = "mining_production"
	minimap_color = MINIMAP_AREA_ENGI

/area/fire_colony/interior/mining_garage
	name = "\improper Old Seegson - South Western Valleys - Old Mining Outpost - Garage"
	icon_state = "mining_production"
	minimap_color = MINIMAP_AREA_ENGI

/area/fire_colony/interior/mining_north_west
	name = "\improper Old Seegson - North Eastern Clearing - Old Mining Outpost"
	icon_state = "mining_production"
	minimap_color = MINIMAP_AREA_ENGI

/*
 * Surface - Lasalle Bionational - Labs - NW corner of map
 */

/area/fire_colony/interior/epsilon_facility
	name = "\improper Lasalle Bionational - Epsilon Facility"
	icon_state = "purple"
	minimap_color = MINIMAP_AREA_RESEARCH
	ceiling = CEILING_DEEP_UNDERGROUND_METAL

/area/fire_colony/interior/epsilon_facility/containment
	name = "\improper Lasalle Bionational - Epsilon Facility - Secure Containment Annex"

/*
 * Surface - Lasalle Bionational - Hospital & Disembarking Lobby / Passthrough
 */

/area/fire_colony/interior/omicron_facility
	name = "\improper Lasalle Bionational - Omicron Facility"
	icon_state = "green"
	minimap_color = MINIMAP_AREA_ENGI

/area/fire_colony/interior/omicron_facility/hospital
	name = "\improper Lasalle Bionational - Omicron Facility - Hospital"
	icon_state = "medbay3"

/area/fire_colony/interior/omicron_facility/hospital/storage
	name = "\improper Lasalle Bionational - Omicron Facility - Hospital Storage"
	icon_state = "medbay3"

/area/fire_colony/interior/omicron_facility/passthrough
	name = "\improper Lasalle Bionational - Omicron Facility - Facility Passthrough"
	icon_state = "bluenew"
	ceiling = CEILING_GLASS

/area/fire_colony/interior/omicron_facility/lobby
	name = "\improper Lasalle Bionational - Omicron Facility - Departure Lounge"
	icon_state = "bluenew"

/*
 * Surface - Storage Units - Various small units across the map
 */

/area/fire_colony/interior/storage_unit
	name = "\improper Storage Unit"
	icon_state = "storage"

/area/fire_colony/interior/storage_unit/s_caves
	name = "\improper Storage Unit - South Excavation Caves"
	icon_state = "storage"

/area/fire_colony/interior/storage_unit/n_caves
	name = "\improper Storage Unit - North Caves"
	icon_state = "storage"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/fire_colony/interior/storage_unit/sw_valley
	name = "\improper Storage Unit - South Western Valley"
	icon_state = "storage"

/area/fire_colony/interior/storage_unit/e_valley
	name = "\improper Storage Unit - Eastern Valley"
	icon_state = "storage"

/area/fire_colony/interior/storage_unit/e_valley
	name = "\improper Storage Unit - Eastern Valley"
	icon_state = "storage"

/area/fire_colony/interior/storage_unit/t_comms_storage
	name = "\improper Telecommunications - Storage Unit - Southern Clearing"
	icon_state = "storage"

/*
 * Surface - Telecommunications
 */

/area/fire_colony/exterior/tcomms/container_one
	name = "\improper Old Seegson - Aerodrome - Container Yard - Colony Telecommunications"
	icon_state = "blueold"
	ceiling = CEILING_NONE

/area/fire_colony/exterior/tcomms/container_two
	name = "\improper Old Seegson - Aerodrome - Container Yard - Colony Telecommunications"
	icon_state = "blueold"
	ceiling = CEILING_NONE

/area/fire_colony/exterior/tcomms/lz2
	name = "\improper Lasalle Bionational - Omicron Facility - Colony Telecommunications"
	icon_state = "blueold"
	ceiling = CEILING_NONE

/area/fire_colony/exterior/tcomms/lz1
	name = "\improper Old Seegson - South Bar - Colony Telecommunications"
	icon_state = "blueold"
	ceiling = CEILING_NONE


/*
 * Surface - Lasalle Bionational - Hangar
 */

/area/fire_colony/exterior/hangar
	name = "\improper Lasalle Bionational - Hangar"
	icon_state = "landing_pad_ext"
	ceiling = CEILING_NONE

/area/fire_colony/interior/hangar/flight_control
	name = "\improper Lasalle Bionational - Hangar - Flight Control Office"
	icon_state = "landing_pad_ext"
	ceiling = CEILING_METAL

/area/fire_colony/interior/hangar/garage
	name = "\improper Lasalle Bionational - Hangar - Garage"
	icon_state = "landing_pad_ext"
	ceiling = CEILING_METAL
