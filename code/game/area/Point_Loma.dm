// Parent Areas //

/area/point_loma
	name = "Point Loma"
	icon = 'icons/turf/area_varadero.dmi'
	//ambience_exterior = AMBIENCE_NV
	icon_state = "varadero"
	can_build_special = TRUE //T-Comms structure
	powernet_name = "ground"
	minimap_color = MINIMAP_AREA_COLONY
	ceiling = CEILING_NONE

/area/point_loma/lz_computer
	name = "Mining Colony Landing Zone - Dropship Computer"
	icon_state = "lz1_comp"
	linked_lz = DROPSHIP_LZ1
	requires_power = FALSE
	minimap_color = MINIMAP_AREA_LZ
	is_landing_zone = TRUE

/area/point_loma/lz_computer/two
	name = "Unused Landing Zone - Dropship Computer"
	icon_state = "lz2_comp"
	linked_lz = DROPSHIP_LZ2

/area/shuttle/drop1/point_loma
	name = "USASF Point Loma - Mining Colony Landing Zone"
	icon = 'icons/turf/area_varadero.dmi'
	icon_state = "lz1"
	linked_lz = DROPSHIP_LZ1
	minimap_color = MINIMAP_AREA_LZ
	is_resin_allowed =  FALSE
	is_landing_zone = TRUE


/area/shuttle/drop2/point_loma
	name = "USASF Point Loma - Unused Landing Zone"
	icon = 'icons/turf/area_varadero.dmi'
	icon_state = "lz2"
	linked_lz = DROPSHIP_LZ2
	minimap_color = MINIMAP_AREA_LZ
	is_resin_allowed =  FALSE
	is_landing_zone = TRUE

/area/point_loma/oob
	name = "Out of Bounds"
	icon_state = "oob"
	soundscape_playlist = FALSE
	ambience_exterior = FALSE
	requires_power = FALSE
	is_resin_allowed = FALSE
	allow_construction = FALSE
	flags_area = AREA_NOBURROW|AREA_UNWEEDABLE
	ceiling = CEILING_MAX
	minimap_color = MINIMAP_AREA_OOB

/area/point_loma/oob/beach
	name = "Point Loma - Beach" // reserved for beach + water noises
	icon_state = "nv_no_ob"
	minimap_color = MINIMAP_AREA_OOB
	ceiling = CEILING_NONE

/area/point_loma/oob/beach/cave
	name = "Point Loma - Beach - Cave"
	ceiling = CEILING_DEEP_UNDERGROUND

/area/point_loma/oob/sky
	name = "Point Loma - Open Sky" // reserved for sky noises
	icon = 'icons/turf/areas.dmi'
	icon_state = "clear"
	flags_area = AREA_UNWEEDABLE
	is_resin_allowed = FALSE
	ceiling = CEILING_NONE
	minimap_color = MINIMAP_AREA_GLASS
	soundscape_playlist = FALSE
	ambience_exterior = FALSE

/area/point_loma/oob/sky/lower // reserved for sky noises closer to water
	soundscape_playlist = FALSE
	ambience_exterior = FALSE

/area/point_loma/oob/ocean //reserved for ocean - water noises
	name = "Point Loma - Open Ocean"
	minimap_color = MINIMAP_AREA_CONTESTED_ZONE

// USASF Airbase //

/area/point_loma/airbase
	name = "USASF Point Loma Airbase"
	icon_state = "shuttle"

/area/point_loma/airbase/interior
	ceiling = CEILING_METAL

/area/point_loma/airbase/interior/atc
	name = "Air Traffic Control"
	icon_state = "offices4"
	minimap_color = MINIMAP_AREA_COMMAND_CAVE

/area/point_loma/airbase/interior/atc/upper
	name = "Airbase Air Traffic Control - Upper"
	icon_state = "offices3"

/area/point_loma/airbase/interior/atc/top
	name = "Airbase Air Traffic Control - Roof"
	ceiling = CEILING_NONE

/area/point/loma/airbase/interior/atc/lower
	name = "Airbase Air Traffic Control - Lower"

/area/point_loma/airbase/interior/cargo
	name = "Airbase Cargo"
	icon_state = "req0"
	minimap_color = MINIMAP_AREA_CARGO

/area/point_loma/airbase/interior/cargo/upper
	name = "Airbase Cargo - Upper"

/area/point_loma/airbase/interior/cargo/lower
	name = "Airbase Cargo - Lower"
	icon_state = "req4"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/point_loma/airbase/interior/fire_station
	name = "Airbase Fire Station"

/area/point_loma/airbase/interior/fuel_storage
	name = "Airbase Fuel Storage"

/area/point_loma/airbase/interior/garage
	name = "Utility Vehicle Garage"
	icon = 'icons/turf/area_hybrisa.dmi'
	icon_state = "garage"

/area/point_loma/airbase/interior/hangar
	icon = 'icons/turf/area_almayer.dmi'
	icon_state = "hangar"

/area/point_loma/airbase/interior/research
	name = "Fuel Mixing Facility"
	icon = 'icons/turf/area_hybrisa.dmi'
	icon_state = "wylab"
	minimap_color = MINIMAP_AREA_RESEARCH

/area/point_loma/airbase/interior/hospital
	name = "Airbase Paramedic Station"
	icon = 'icons/turf/area_kutjevo.dmi'
	icon_state = "med0"
	minimap_color = MINIMAP_AREA_MEDBAY

/area/point_loma/airbase/interior/workshop
	name = "Airbase Aircraft and Munitions Workshop"
	minimap_color = MINIMAP_AREA_ENGI_CAVE
	icon = 'icons/turf/area_kutjevo.dmi'
	icon_state = "construction3"

/area/point_loma/airbase/interior/workshop/upper
	name = "Airbase Aircraft and Munitions Workshop - Upper"

/area/point_loma/airbase/exterior
	name = "USASF Point Loma Airbase - Exterior"
	always_unpowered = TRUE // always off

/area/point_loma/airbase/exterior/opening
	name = "USASF Point Loma Airbase - Sink Hole"
	minimap_color = MINIMAP_AREA_HYBRISARESEARCH

/area/point_loma/airbase/exterior/crash_site
	name = "Runway Crash Site"
	icon_state = "predship"

/area/point_loma/airbase/exterior/crash_site/opening
	name = "Runway Crash Site - Sink Hole"
	minimap_color = MINIMAP_AREA_HYBRISARESEARCH

/area/point_loma/airbase/exterior/north
	name = "USASF Point Loma Airbase - North" // maybe some wind / sea noises?

/area/point_loma/airbase/exterior/east
	name = "USASF Point Loma Airbase - East"

/area/point_loma/airbase/exterior/west
	name = "USASF Point Loma Airbase - West"

/area/point_loma/airbase/exterior/south
	name = "USASF Point Loma Airbase - South"

/area/point_loma/airbase/cave
	name = "Point Loma Airbase - Caves"
	minimap_color = MINIMAP_AREA_CAVES_DEEP
	icon_state = "tunnels0"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	always_unpowered = TRUE // always off

/area/point_loma/airbase/cave/south
	name = "Point Loma Airbase - Caves - South"

/area/point_loma/airbase/cave/south/upper
	name = "Point Loma Airbase - Caves - South - Upper"


/area/point_loma/airbase/cave/south_west
	name = "Point Loma Airbase - Caves - South West"

/area/point_loma/airbase/cave/west
	name = "Point Loma Airbase - Caves - West"

/area/point_loma/airbase/cave/west/upper
	name = "Point Loma Airbase - Caves - West - Upper"

/area/point_loma/airbase/cave/north
	name = "Point Loma Airbase - Caves - North"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS

/area/point_loma/airbase/cave/opening
	name = "Point Loma Airbase - Cave Sinkhole"
	minimap_color = MINIMAP_AREA_HYBRISARESEARCH


// Alpha-Tech Hardware Corporation Underground Research Facility //

/area/point_loma/research_facility
	name = "Alpha-Tech Hardware Research Facility"
	unoviable_timer = FALSE
	icon = 'icons/turf/area_almayer.dmi'
	icon_state = "science"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS

/area/point_loma/research_facility/cave
	name = "Alpha-Tech Research Facility Cave"
	minimap_color = MINIMAP_AREA_CAVES_DEEP
	icon = 'icons/turf/area_varadero.dmi'
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	always_unpowered = TRUE // always off

/area/point_loma/research_facility/cave/west
	name = "Alpha-Tech Research Facility Cave - West"
	icon_state = "deepcaves1"

/area/point_loma/research_facility/cave/west/opening
	name = "Alpha-Tech Research Facility - West  Cave - Sinkhole"
	minimap_color = MINIMAP_AREA_HYBRISARESEARCH

/area/point_loma/research_facility/cave/south
	name = "Alpha-Tech Research Facility Cave - South"
	icon_state = "deepcaves2"

/area/point_loma/research_facility/cave/south/opening
	name = "Alpha-Tech Research Facility - South Cave - Sink Hole"
	minimap_color = MINIMAP_AREA_HYBRISARESEARCH

/area/point_loma/research_facility/cave/south_east
	name = "Alpha-Tech Research Facility Cave - South East"
	icon_state = "deepcaves3"


/area/point_loma/research_facility/hallway
	name = "Alpha-Tech Hardware - Research Facility Hallway"
	icon = 'icons/turf/area_varadero.dmi'
	icon_state = "hall0"

/area/point_loma/research_facility/hallway/central
	name = "Alpha-Tech Hardware - Research Facility Hallway - Central"

/area/point_loma/research_facility/hallway/east
	name = "Alpha-Tech Hardware - Research Facility Hallway - East"
	icon_state = "hall4"

/area/point_loma/research_facility/hallway/west
	name = "Alpha-Tech Hardware - Research Facility Hallway - West"
	icon_state = "hall1"

/area/point_loma/research_facility/hallway/south
	name = "Alpha-Tech Hardware - Research Facility Hallway - South"
	icon_state = "hall2"

/area/point_loma/research_facility/hallway/north
	name = "Alpha-Tech Hardware - Research Facility Hallway - North"
	icon_state = "hall3"

/area/point_loma/research_facility/super_death_cannon
	name = "Super Death Cannon"
	icon = 'icons/turf/areas.dmi'
	icon_state = "Tactical"
	minimap_color = MINIMAP_AREA_RESEARCH_CAVE
	ceiling = CEILING_DEEP_UNDERGROUND_METAL

/area/point_loma/research_facility/super_death_cannon/ammo_elevator
	name = "Super Death Cannon - Ammo Elevator"
	icon_state = "nuke_storage"

/area/point_loma/research_facility/super_death_cannon/ammo_elevator/upper
	name = "Super Death Cannon - Ammo Elevator"

/area/point_loma/research_facility/super_death_cannon/cannon
	name = "Super Death Cannon - Cannon Room"
	icon_state = "firingrange"

/area/point_loma/research_facility/super_death_cannon/observation
	name = "Super Death Cannon - Research Observation Room"

/area/point_loma/research_facility/super_death_cannon/observation/civ
	name = "Super Death Cannon - Civilian Observation Room"
	icon = 'icons/turf/area_almayer.dmi'
	icon_state = "corporatespace"

/area/point_loma/research_facility/super_death_cannon/observation/catwalk
	name = "Super Death Cannon - Outside Catwalk"
	ceiling = CEILING_NONE
	requires_power = FALSE

/area/point_loma/research_facility/super_death_cannon/engineering
	name = "Super Death Cannon - Control Room"
	icon_state = "substation"
	minimap_color = MINIMAP_AREA_ENGI_CAVE

/area/point_loma/research_facility/briefing
	name = "Alpha-Tech - Meeting Hall and Press Office"
	icon = 'icons/turf/areas.dmi'
	icon_state = "Theatre"

/area/point_loma/research_facility/corporate
	name = "Alpha-Tech Hardware Liaison Office"
	minimap_color = MINIMAP_SNOW
	icon = 'icons/turf/area_almayer.dmi'
	icon_state = "corporatespace"

/area/point_loma/research_facility/command
	name = "Alpha-Tech - Offices"
	minimap_color = MINIMAP_AREA_COMMAND
	icon = 'icons/turf/area_whiskey.dmi'
	icon_state = "CIC"

/area/point_loma/research_facility/command/mess
	name = "Alpha-Tech - Executive Mess"

/area/point_loma/research_facility/chapel
	name = "Alpha-Tech - Chapel"
//	icon = 'icons/turf/area_almayer.dmi'
//	icon_state = "CIC"

/area/point_loma/research_facility/dorms
	name = "Alpha-Tech - Dorms"
	icon = 'icons/turf/area_whiskey.dmi'
	icon_state = "livingspace"

/area/point_loma/research_facility/crash_site
	name = "Alpha-Tech - Crash Site"
	icon = 'icons/turf/area_varadero.dmi'
	icon_state = "predship"
	always_unpowered = TRUE // always off

/area/point_loma/research_facility/engineering
	name = "Alpha-Tech - Engineering"
	icon = 'icons/turf/area_almayer.dmi'
	icon_state = "engineering"
	minimap_color = MINIMAP_AREA_ENGI
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/point_loma/research_facility/gym
	name = "Alpha-Tech - Gymnasium"
	icon = 'icons/turf/area_almayer.dmi'
	icon_state = "gruntrnr"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/point_loma/research_facility/gym/basketball
	icon_state = "basketball"

/area/point_loma/research_facility/laundry
	name = "Alpha-Tech - Laundry"
	icon = 'icons/turf/area_almayer.dmi'
	icon_state = "laundry"

/area/point_loma/research_facility/library
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/point_loma/research_facility/medical
	name = "Alpha-Tech - Medbay"
	icon = 'icons/turf/area_kutjevo.dmi'
	icon_state = "med4"
	minimap_color = MINIMAP_AREA_MEDBAY

/area/point_loma/research_facility/pool
	name = "Alpha-Tech - Pool and Sauna"
	icon = 'icons/turf/area_whiskey.dmi'
	icon_state = "livingspace"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/point_loma/research_facility/pool/water
	temperature = ICE_COLONY_TEMPERATURE // -50 degrees celcius, so the cold icon comes up
	icon_state = "rivere"

/area/point_loma/research_facility/pool/sauna
	temperature = T120C // 120 degrees celcius, so the heat icon comes up
	icon_state = "riverw"

/area/point_loma/research_facility/research
	name = "Alpha-Tech Research Facility"
	minimap_color = MINIMAP_AREA_RESEARCH
	icon = 'icons/turf/area_hybrisa.dmi'
	icon_state = "wylab"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/point_loma/research_facility/research/park
	name = "Alpha-Tech Research Facility - Park"
	minimap_color = MINIMAP_AREA_JUNGLE
	icon_state = "botany"

/area/point_loma/research_facility/research/park/opening
	name = "Alpha-Tech Research Facility - Park - Sinkhole"
	minimap_color = MINIMAP_AREA_HYBRISARESEARCH

/area/point_loma/research_facility/research/west
	name = "Alpha-Tech Research Facility - West"

/area/point_loma/research_facility/research/east
	name = "Alpha-Tech Research Facility - East"

/area/point_loma/research_facility/security_hq
	name = "Point Loma - Security Police HQ and Detention"
	minimap_color = MINIMAP_AREA_SEC
	icon = 'icons/turf/area_strata.dmi'
	icon_state= "security_station"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

// Mining Colony //

/area/point_loma/airbase/mining_colony
	name = "Point Loma Mining Colony"
	linked_lz = DROPSHIP_LZ1 // entire mining colony will be cleaned by weedkiller
	//temperature = TROPICAL_TEMP
	minimap_color = MINIMAP_AREA_ENGI_CAVE
	icon_state = "varadero4"

/area/point_loma/airbase/mining_colony/caves
	name = "Mining Colony - South Caves"
	minimap_color = MINIMAP_AREA_MINING
	icon_state = "tunnels4"
	ceiling = CEILING_SANDSTONE_ALLOW_CAS
	always_unpowered = TRUE // always off

/area/point_loma/airbase/mining_colony/interior
	name = "Mining Colony - Interior"
	ceiling = CEILING_METAL

/area/point_loma/airbase/mining_colony/interior/corporate
	name = "Mining Colony - Alpha-Tech Hardware - Corporate Office"
	minimap_color = MINIMAP_SNOW

/area/point_loma/airbase/mining_colony/interior/security
	name = "Point Loma Security Police Outpost"
	minimap_color = MINIMAP_AREA_SEC
	icon = 'icons/turf/area_strata.dmi'
	icon_state= "rdecks_sec"

/area/point_loma/airbase/mining_colony/interior/security/barracks
	name = "Point Loma Security Police Outpost - Barracks"

/area/point_loma/airbase/mining_colony/interior/engineering
	name = "Mining Colony - Engineering"
	minimap_color = MINIMAP_AREA_ENGI

/area/point_loma/airbase/mining_colony/interior/engineering/communications
	name = "Mining Colony - Communication Relay"
	minimap_color = MINIMAP_AREA_COMMS
	icon_state = "comms4"

/area/point_loma/airbase/mining_colony/interior/engineering/communications/two
	name = "Alpha-Tech Research Facility - Communications Relay"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/point_loma/airbase/mining_colony/interior/living_quarters
	name = "Mining Colony - Living Quarters"
	minimap_color = MINIMAP_AREA_COMMAND_CAVE

/area/point_loma/airbase/mining_colony/interior/storage
	name = "Mining Colony - Storage and Intake"
	minimap_color = MINIMAP_AREA_CARGO

/area/point_loma/airbase/mining_colony/exterior
	name = "Mining Colony - Central"
	always_unpowered = TRUE // always off

/area/point_loma/airbase/mining_colony/exterior/north
	name = "Mining Colony - North"

/area/point_loma/airbase/mining_colony/exterior/west
	name = "Mining Colony - West"

/area/point_loma/airbase/mining_colony/exterior/lz
	name = "Mining Colony - Landing Zone"
	minimap_color = MINIMAP_AREA_LZ

/area/point_loma/airbase/mining_colony/exterior/security
	name = "Mining Colony - Security Checkpoint"
	minimap_color = MINIMAP_AREA_SEC
	icon = 'icons/turf/area_strata.dmi'
	icon_state= "outpost_sec_0"
	ceiling = CEILING_METAL

/area/point_loma/airbase/mining_colony/exterior/security/checkpoint
	minimap_color = MINIMAP_AREA_SEC_CAVE
	icon_state= "outpost_sec_1"

/area/point_loma/airbase/mining_colony/exterior/security/north
	name = "Mining Colony - Security Checkpoint - North"

/area/point_loma/airbase/mining_colony/exterior/security/checkpoint/north
	name = "Mining Colony - Security Checkpoint - North - Exterior"

/area/point_loma/airbase/mining_colony/exterior/security/central
	name = "Mining Colony - Security Checkpoint - Central"

/area/point_loma/airbase/mining_colony/exterior/security/checkpoint/north
	name = "Mining Colony - Security Checkpoint - Central - Exterior"

/area/point_loma/airbase/mining_colony/exterior/security/south
	name = "Mining Colony - Security Checkpoint - South"

/area/point_loma/airbase/mining_colony/exterior/security/checkpoint/south
	name = "Mining Colony - Security Checkpoint - South - Exterior"
