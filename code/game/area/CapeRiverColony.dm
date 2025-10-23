//CAPE RIVER COLONY AREAS-----------------------------//

/area/caperiver
	name = "Cape River Mining Colony"
	icon_state = "unknown"
	can_build_special = TRUE
	powernet_name = "ground"
	minimap_color = MINIMAP_MARS_DIRT

//parent types

/area/caperiver/indoors
	name = "Cape River - Indoors"
	ceiling = CEILING_METAL
	ambience_exterior = AMBIENCE_BIGRED
//	ambience_exterior = AMBIENCE_HYBRISA_INTERIOR

/area/caperiver/outdoors
	name = "Cape River - Outdoors"
	ceiling = CEILING_NONE
	ambience_exterior = AMBIENCE_BIGRED
//	ambience_exterior = AMBIENCE_CITY
//	soundscape_interval = 25

/area/caperiver/oob
	name = "Out Of Bounds"
	icon_state = "cliff_blocked"
	ceiling = CEILING_MAX
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL
	minimap_color = MINIMAP_AREA_OOB
	requires_power = FALSE
	ambience_exterior = AMBIENCE_BIGRED
	ceiling_muffle = FALSE

//// -- Outdoors -- \\\\

// - Cave - \\

/area/caperiver/indoors/caves
	name = "Caves"
	icon_state = "cave"
	ambience_exterior = AMBIENCE_HYBRISA_CAVES
	soundscape_playlist = SCAPE_PL_LV759_DEEPCAVES
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	ceiling_muffle = FALSE
	minimap_color = MINIMAP_AREA_MINING
	unoviable_timer = FALSE
	always_unpowered = TRUE

/area/caperiver/indoors/caves/central
	name = "Caves - Central"

/area/caperiver/indoors/caves/sw
	name = "Caves - South West"
	icon_state = "caves_sw"

/area/caperiver/indoors/caves/se
	name = "Caves - South East"
	icon_state = "bunker01_caves"
	ambience_exterior = AMBIENCE_CULT
	soundscape_interval = 40
	base_muffle = MUFFLE_HIGH

/area/caperiver/indoors/caves/s
	name = "Caves - South"
	icon_state = "bunker01_caves_outpost"

/area/caperiver/indoors/caves/nw
	name = "Caves - North West"
	icon_state = "caves_north"

/area/caperiver/indoors/caves/n
	name = "Caves - North"
	icon_state = "caves_north"

/area/caperiver/indoors/caves/ne
	name = "Caves - North East"
	icon_state = "caves_lambda"
	ambience_exterior = AMBIENCE_CULT
	soundscape_interval = 40
	base_muffle = MUFFLE_MEDIUM

/area/caperiver/indoors/caves/e
	name = "Caves - East"
	icon_state = "caves_east"

/area/caperiver/indoors/caves/w
	name = "Caves - West"
	icon_state = "caves_virology"

// - Road - \\

/area/caperiver/outdoors/road
	name = "Colony Roads"
	minimap_color = MINIMAP_SNOW
	icon_state = "shuttle"

/area/caperiver/outdoors/road/south
	name = "Colony Roads - South"
	linked_lz = list(DROPSHIP_LZ1, DROPSHIP_LZ2)

/area/caperiver/outdoors/road/central/antiweed
	linked_lz = DROPSHIP_LZ2

/area/caperiver/outdoors/road/central

/area/caperiver/outdoors/road/west
	name = "Colony Roads - West"

/area/caperiver/outdoors/road/west/antiweed
	linked_lz = DROPSHIP_LZ1

/area/caperiver/outdoors/road/north
	name = "Colony Roads - North"

// - Scrublands - \\

/area/caperiver/outdoors/scrublands
	name = "Scrublands"
	icon_state = "valley"

/area/caperiver/outdoors/scrublands/south
	name = "Scrublands - South"
	icon_state = "valley_south"

/area/caperiver/outdoors/scrublands/south/antiweed
	linked_lz = DROPSHIP_LZ1

/area/caperiver/outdoors/scrublands/south_east
	name = "Scrublands - South East"
	icon_state = "valley_south"
	linked_lz = DROPSHIP_LZ2

/area/caperiver/outdoors/scrublands/west
	name = "Scrublands - West"
	icon_state = "valley_west"

/area/caperiver/outdoors/scrublands/west/antiweed
	linked_lz = DROPSHIP_LZ1

/area/caperiver/outdoors/scrublands/central
	name = "Scrublands - Central"
	icon_state = "valley"

/area/caperiver/outdoors/scrublands/north
	name = "Scrublands - North"
	icon_state = "valley_north"
	unoviable_timer = FALSE

/area/caperiver/outdoors/scrublands/north_west
	name = "Scrublands - North West"
	icon_state = "valley_north_west"
	unoviable_timer = FALSE

/area/caperiver/outdoors/scrublands/north_east
	name = "Scrublands - North East"
	icon_state = "valley_north_east"
	unoviable_timer = FALSE

/area/caperiver/outdoors/scrublands/lz_cave
	name = "Scrublands - Landing Zone Cave"
	icon_state = "valley_south_excv"
	ceiling = CEILING_SANDSTONE_ALLOW_CAS
	minimap_color = MINIMAP_AREA_CELL_MAX
	linked_lz = DROPSHIP_LZ1

/area/caperiver/outdoors/scrublands/nw_cave
	name = "Scrublands - North West Cave"
	icon_state = "valley_south_excv"
	ceiling = CEILING_SANDSTONE_ALLOW_CAS
	minimap_color = MINIMAP_AREA_CELL_MAX

// - Mining Base Exterior - \\

/area/caperiver/outdoors/mining_base_exterior
	name = "Mining Base Exterior"
	icon_state = "mining"

/area/caperiver/outdoors/mining_base_exterior/south
	name = "Mining Base - South Of Chasm - Exterior"
	icon_state = "south"

/area/caperiver/outdoors/mining_base_exterior/north
	name = "Mining Base - North Of Chasm - Exterior"
	icon_state = "north"
	unoviable_timer = FALSE

// - Con-Am Base Exterior - \\

/area/caperiver/outdoors/con_am_exterior
	name = "Con-Amalagated Base Exterior"
	icon_state = "mining"

/area/caperiver/outdoors/con_am_exterior/south
	name = "Con-Amalagated Base - South Of Chasm - Exterior"
	icon_state = "south"

/area/caperiver/outdoors/con_am_exterior/south/antiweed
	linked_lz = DROPSHIP_LZ2

/area/caperiver/outdoors/con_am_exterior/north
	name = "Con-Amalagated Base - North Of Chasm - Exterior"
	icon_state = "north"
	unoviable_timer = FALSE

// - Misc - \\

/area/caperiver/outdoors/bushlands
	name = "Bushlands"
	icon_state = "south"
	linked_lz = list(DROPSHIP_LZ1, DROPSHIP_LZ2)

/area/caperiver/outdoors/chasm
	name = "Chasm"
	icon_state = "shuttle"
	always_unpowered = TRUE
	minimap_color = MINIMAP_WATER

//// -- Indoors -- \\\\

// - Cape River Base Interior - \\

/area/caperiver/indoors/miningbase
	name = "Cape River - Mining Base"
	icon_state = "mining"
	minimap_color = MINIMAP_AREA_COLONY_SPACE_PORT

/area/caperiver/indoors/miningbase/engi
	name = "Cape River - Engineering"
	icon_state = "engine"
	minimap_color = MINIMAP_AREA_ENGI

/area/caperiver/indoors/miningbase/dorm
	name = "Cape River - Dormitory"
	icon_state = "maint_dormitory"

/area/caperiver/indoors/miningbase/checkpoint
	name = "Cape River - Entry Checkpoint"
	icon_state = "security"
//	minimap_color = MINIMAP_AREA_SEC_CAVE

/area/caperiver/indoors/miningbase/security
	name = "Cape River - Security"
	icon_state = "security"
	minimap_color = MINIMAP_AREA_SEC
	unoviable_timer = FALSE

/area/caperiver/indoors/miningbase/hydro
	name = "Cape River - Hydroponics"
	icon_state = "hydro"
//	minimap_color = MINIMAP_AREA_JUNGLE

/area/caperiver/indoors/miningbase/rec
	name = "Cape River - Recreation"
	icon_state = "bar"

/area/caperiver/indoors/miningbase/admin
	name = "Cape River - Administration"
	icon_state = "bunker01_command"
	minimap_color = MINIMAP_AREA_COMMAND
	unoviable_timer = FALSE

/area/caperiver/indoors/miningbase/medical
	name = "Cape River - Medical Bay"
	icon_state = "medbay"
	unoviable_timer = FALSE

// - Con-Am 'Corestone Base' Interior - \\

/area/caperiver/indoors/conambase
	name = "Con-Am 'Corestone Base'"
	icon_state = "head_quarters"
	minimap_color = MINIMAP_AREA_RESEARCH

/area/caperiver/indoors/conambase/delivery
	name = "Con-Am 'Corestone Base' - Delivery"
	icon_state = "maint_cargo"

/area/caperiver/indoors/conambase/medical
	name = "Con-Am 'Corestone Base' - Medical"
	icon_state = "Holodeck"

/area/caperiver/indoors/conambase/bunker
	name = "Con-Am 'Corestone Base' - Bunker"
	icon_state = "bunker01_main"
	minimap_color = MINIMAP_AREA_CAVES_DEEP

/area/caperiver/indoors/conambase/recreational
	name = "Con-Am 'Corestone Base' - Recreational"
	icon_state = "maint_bar"

/area/caperiver/indoors/conambase/engi
	name = "Con-Am 'Corestone Base' - Engineering"
	icon_state = "engine_waste"

/area/caperiver/indoors/conambase/support
	name = "Con-Am 'Corestone Base' - Support Services"
	icon_state = "prototype_engine"

/area/caperiver/indoors/conambase/command
	name = "Con-Am 'Corestone Base' - Command Sector"
	icon_state = "bridge"
	minimap_color = MINIMAP_AREA_COMMAND
	unoviable_timer = FALSE

/area/caperiver/indoors/conambase/research_w
	name = "Con-Am 'Corestone Base' - Research/West"
	icon_state = "research"
	unoviable_timer = FALSE

/area/caperiver/indoors/conambase/research_e
	name = "Con-Am 'Corestone Base' - Research/East"
	icon_state = "research_dock"
	unoviable_timer = FALSE

/area/caperiver/indoors/conambase/unknown
	name = "c^n-Am S 'Co)es#ne B@se' A - V Un&ble To Dis@ern E S^ruct&re Func&%*# E. U.S -- &#AAA#.."
	icon_state = "research_dock"
	minimap_color = MINIMAP_DRAWING_YELLOW
	ambience_exterior = AMBIENCE_CULT
	soundscape_interval = 40
	ceiling_muffle = FALSE
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS
	is_resin_allowed =  FALSE
	requires_power = FALSE

// - Misc - \\

/area/caperiver/indoors/processing
	name = "Mineral Processing"
	icon_state = "head_quarters"
	minimap_color = MINIMAP_AREA_ENGI

/area/caperiver/indoors/clf_dropship
	name = "UD-9M 'Dogbite'"
	icon_state = "head_quarters"
	requires_power = FALSE
	minimap_color = MINIMAP_AREA_COLONY

//// -- Telecomms -- \\\\

/area/caperiver/telecomms
	name = "Cape River - Communications Relay"
	ceiling = CEILING_METAL
	icon_state = "tutorial"
	ambience_exterior = AMBIENCE_BIGRED

/area/caperiver/telecomms/telecomm_1
	name = "Cape River - Mining Base - Communications Relay"

/area/caperiver/telecomms/telecomm_2
	name = "Cape River - Scrublands - Exterior Communications Relay"
	ceiling = CEILING_NONE
	linked_lz = DROPSHIP_LZ1

/area/caperiver/telecomms/telecomm_3
	name = "Con-Am 'Corestone Base' - Primary Communications Relay"
	linked_lz = DROPSHIP_LZ2

/area/caperiver/telecomms/telecomm_4
	name = "Con-Am 'Corestone Base' - Cave - Ancillery Communications Relay"
	ceiling = CEILING_SANDSTONE_ALLOW_CAS
	linked_lz = DROPSHIP_LZ2

//// -- Landing Zones -- \\\\

// - Landing Zone 1 - \\

/area/caperiver/outdoors/landing_zone_1
	name = "Cape River Mining Colony - Cargo Transfer - Landing Zone One"
	icon_state = "away1"
	is_resin_allowed =  FALSE
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_CELL_HIGH
	linked_lz = DROPSHIP_LZ1

/area/caperiver/outdoors/landing_zone_1/interior
	name = "Cape River Mining Colony - Service Structures - Landing Zone One"
	icon_state = "away"
	ceiling = CEILING_METAL
	is_landing_zone = TRUE
	linked_lz = DROPSHIP_LZ1
	minimap_color = MINIMAP_AREA_CELL_MED

/area/caperiver/outdoors/landing_zone_1/cave
	name = "Cape River Mining Colony - East Cave Service Entrance - Landing Zone One"
	icon_state = "away"
	ceiling = CEILING_SANDSTONE_ALLOW_CAS
	is_landing_zone = TRUE
	linked_lz = DROPSHIP_LZ1
	minimap_color = MINIMAP_AREA_CELL_MAX

// Landing Zone 2

/area/caperiver/outdoors/landing_zone_2
	name = "Cape River - Unknown Encampment - Landing Zone Two"
	icon_state = "away2"
	is_resin_allowed =  FALSE
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_CELL_HIGH
	linked_lz = DROPSHIP_LZ2

/area/caperiver/outdoors/landing_zone_2/river
	name = "Cape River - Unknown Encampment - River - Landing Zone Two"
	is_landing_zone = TRUE
	linked_lz = DROPSHIP_LZ2
	always_unpowered = TRUE
	minimap_color = MINIMAP_WATER

/area/caperiver/outdoors/landing_zone_2/interior
	name = "Cape River - Unknown Encampment - Interior Structure - Landing Zone Two"
	icon_state = "away"
	ceiling = CEILING_METAL
	is_landing_zone = TRUE
	linked_lz = DROPSHIP_LZ2
	minimap_color = MINIMAP_AREA_CELL_MED

/area/caperiver/outdoors/landing_zone_2/cave
	name = "Cape River - Unknown Encampment - Cave System - Landing Zone Two"
	icon_state = "away3"
	ceiling = CEILING_SANDSTONE_ALLOW_CAS
	linked_lz = DROPSHIP_LZ2
	minimap_color = MINIMAP_AREA_CELL_MAX

