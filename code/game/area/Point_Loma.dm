// Parent Areas //

/area/point_loma
	name = "Point Loma" //abstract
	icon = 'icons/turf/area_point_loma.dmi'
	icon_state = "point_loma"
	can_build_special = TRUE //T-Comms structure
	powernet_name = "ground"
	minimap_color = MINIMAP_AREA_COLONY
	ceiling = CEILING_NONE

/area/point_loma/lz_computer
	name = "Mining Colony Landing Zone - Dropship Computer"
	icon_state = "lz_computer"
	linked_lz = DROPSHIP_LZ1
	requires_power = FALSE
	minimap_color = MINIMAP_AREA_LZ
	is_landing_zone = TRUE

/area/point_loma/lz_computer/two
	name = "Unused Landing Zone - Dropship Computer"
	linked_lz = DROPSHIP_LZ2

/area/shuttle/drop1/point_loma
	name = "USASF Point Loma - Mining Colony Landing Zone"
	icon = 'icons/turf/area_point_loma.dmi'
	icon_state = "lz1"
	linked_lz = DROPSHIP_LZ1
	minimap_color = MINIMAP_AREA_LZ
	is_resin_allowed =  FALSE
	is_landing_zone = TRUE

/area/shuttle/drop2/point_loma
	name = "USASF Point Loma - Unused Landing Zone"
	icon = 'icons/turf/area_point_loma.dmi'
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
	icon_state = "beach"
	minimap_color = MINIMAP_AREA_OOB
	ceiling = CEILING_NONE

/area/point_loma/oob/beach/cave
	name = "Point Loma - Beach - Cave"
	icon_state = "beach_cave"
	ceiling = CEILING_DEEP_UNDERGROUND

/area/point_loma/oob/sky
	name = "Point Loma - Open Sky" // reserved for sky noises
	icon_state = "open_sky"
	flags_area = AREA_UNWEEDABLE
	is_resin_allowed = FALSE
	ceiling = CEILING_NONE
	minimap_color = MINIMAP_AREA_GLASS
	soundscape_playlist = FALSE
	ambience_exterior = FALSE

/area/point_loma/oob/sky/lower // reserved for sky noises closer to water
	icon_state = "open_sky_lower"
	soundscape_playlist = FALSE
	ambience_exterior = FALSE

/area/point_loma/oob/ocean //reserved for ocean - water noises
	name = "Point Loma - Open Ocean"
	icon_state = "ocean"
	minimap_color = MINIMAP_AREA_CONTESTED_ZONE

// USASF Airbase //

/area/point_loma/airbase //abstract
	name = "USASF Point Loma Airbase"
	icon_state = "airbase"
	sound_environment = SOUND_ENVIRONMENT_PARKING_LOT

/area/point_loma/airbase/interior //abstract
	ceiling = CEILING_METAL
	sound_environment = SOUND_ENVIRONMENT_LIVINGROOM

/area/point_loma/airbase/interior/atc
	name = "Air Traffic Control"
	icon_state = "airbase_atc"
	minimap_color = MINIMAP_AREA_COMMAND_CAVE

/area/point_loma/airbase/interior/atc/upper
	name = "Airbase Air Traffic Control - Upper"
	icon_state = "airbase_atc_upper"

/area/point_loma/airbase/interior/atc/top
	name = "Airbase Air Traffic Control - Roof"
	icon_state = "airbase_atc_top"
	ceiling = CEILING_NONE

/area/point/loma/airbase/interior/atc/lower
	name = "Airbase Air Traffic Control - Lower"
	icon_state = "airbase_atc_lower"

/area/point_loma/airbase/interior/cargo
	name = "Airbase Cargo"
	icon_state = "airbase_cargo"
	minimap_color = MINIMAP_AREA_CARGO

/area/point_loma/airbase/interior/cargo/upper
	name = "Airbase Cargo - Upper"
	icon_state = "airbase_cargo_upper"

/area/point_loma/airbase/interior/cargo/lower
	name = "Airbase Cargo - Lower"
	icon_state = "airbase_cargo_lower"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/point_loma/airbase/interior/fire_station
	name = "Airbase Fire Station"
	icon_state = "airbase_fire_station"

/area/point_loma/airbase/interior/fuel_storage
	name = "Airbase Fuel Storage"
	icon_state = "airbase_fuel_storage"

/area/point_loma/airbase/interior/garage
	name = "Utility Vehicle Garage"
	icon_state = "airbase_garage"

/area/point_loma/airbase/interior/hangar
	name = "Airbase Hangar"
	icon_state = "airbase_hangar"
	sound_environment = SOUND_ENVIRONMENT_HANGAR

/area/point_loma/airbase/interior/research
	name = "Fuel Mixing Facility"
	icon_state = "research_facility"
	minimap_color = MINIMAP_AREA_RESEARCH

/area/point_loma/airbase/interior/hospital
	name = "Airbase Paramedic Station"
	icon_state = "airbase_hospital"
	minimap_color = MINIMAP_AREA_MEDBAY

/area/point_loma/airbase/interior/workshop
	name = "Airbase Aircraft and Munitions Workshop"
	minimap_color = MINIMAP_AREA_ENGI_CAVE
	icon_state = "airbase_workshop"
	sound_environment = SOUND_ENVIRONMENT_HANGAR

/area/point_loma/airbase/interior/workshop/upper
	name = "Airbase Aircraft and Munitions Workshop - Upper"
	icon_state = "airbase_workshop_upper"

/area/point_loma/airbase/exterior
	name = "USASF Point Loma Airbase - Exterior" //abstract
	always_unpowered = TRUE // always off
	icon_state = "airbase_exterior"

/area/point_loma/airbase/exterior/opening // Unused
	name = "USASF Point Loma Airbase - Sink Hole"
	icon_state = "airbase_sink_hole"
	minimap_color = MINIMAP_AREA_HYBRISARESEARCH

/area/point_loma/airbase/exterior/crash_site
	name = "Runway Crash Site"
	icon_state = "airbase_crash_site"

/area/point_loma/airbase/exterior/crash_site/opening
	name = "Runway Crash Site - Sink Hole"
	icon_state = "airbase_crash_opening"
	minimap_color = MINIMAP_AREA_HYBRISARESEARCH

/area/point_loma/airbase/exterior/north
	name = "USASF Point Loma Airbase - North" // maybe some wind / sea noises?
	icon_state = "airbase_exterior_north"

/area/point_loma/airbase/exterior/east
	name = "USASF Point Loma Airbase - East"
	icon_state = "airbase_exterior_east"

/area/point_loma/airbase/exterior/west
	name = "USASF Point Loma Airbase - West"
	icon_state = "airbase_exterior_west"

/area/point_loma/airbase/exterior/south
	name = "USASF Point Loma Airbase - South"
	icon_state = "airbase_exterior_south"

/area/point_loma/airbase/cave
	name = "Point Loma Airbase - Caves" //abstract
	minimap_color = MINIMAP_AREA_CAVES_DEEP
	icon_state = "airbase_cave"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	always_unpowered = TRUE // always off
	sound_environment = SOUND_ENVIRONMENT_CAVE

/area/point_loma/airbase/cave/south
	name = "Point Loma Airbase - Caves - South"
	icon_state = "airbase_cave_south"

/area/point_loma/airbase/cave/south/upper
	name = "Point Loma Airbase - Caves - South - Upper"
	icon_state = "airbase_cave_south_upper"

/area/point_loma/airbase/cave/south_west
	name = "Point Loma Airbase - Caves - South West"
	icon_state = "airbase_cave_south_west"

/area/point_loma/airbase/cave/west
	name = "Point Loma Airbase - Caves - West"
	icon_state = "airbase_cave_west"

/area/point_loma/airbase/cave/west/upper
	name = "Point Loma Airbase - Caves - West - Upper"
	icon_state = "airbase_cave_west_upper"

/area/point_loma/airbase/cave/north
	name = "Point Loma Airbase - Caves - North"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	icon_state = "airbase_cave_north"

/area/point_loma/airbase/cave/opening
	name = "Point Loma Airbase - Cave Sinkhole"
	minimap_color = MINIMAP_AREA_HYBRISARESEARCH
	icon_state = "airbase_cave_opening"

// Alpha-Tech Hardware Corporation Underground Research Facility //

/area/point_loma/research_facility
	name = "Alpha-Tech Hardware Research Facility" //abstract
	unoviable_timer = FALSE
	icon_state = "research_facility"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	sound_environment = SOUND_ENVIRONMENT_ROOM

/area/point_loma/research_facility/cave
	name = "Alpha-Tech Research Facility Cave"
	minimap_color = MINIMAP_AREA_CAVES_DEEP
	icon_state = "research_facility_cave"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	always_unpowered = TRUE // always off
	sound_environment = SOUND_ENVIRONMENT_CAVE

/area/point_loma/research_facility/cave/west
	name = "Alpha-Tech Research Facility Cave - West"
	icon_state = "research_facility_cave_west"

/area/point_loma/research_facility/cave/west/opening
	name = "Alpha-Tech Research Facility - West  Cave - Sinkhole"
	minimap_color = MINIMAP_AREA_HYBRISARESEARCH
	icon_state = "research_facility_cave_west_opening"
	sound_environment = SOUND_ENVIRONMENT_QUARRY

/area/point_loma/research_facility/cave/south
	name = "Alpha-Tech Research Facility Cave - South"
	icon_state = "research_facility_cave_south"

/area/point_loma/research_facility/cave/south/opening
	name = "Alpha-Tech Research Facility - South Cave - Sink Hole"
	minimap_color = MINIMAP_AREA_HYBRISARESEARCH
	icon_state = "research_facility_cave_south_opening"
	sound_environment = SOUND_ENVIRONMENT_QUARRY

/area/point_loma/research_facility/cave/south_east
	name = "Alpha-Tech Research Facility Cave - South East"
	icon_state = "research_facility_cave_south_east"

/area/point_loma/research_facility/hallway
	name = "Alpha-Tech Hardware - Research Facility Hallway" //abstract
	icon_state = "research_facility_hallway"
	sound_environment = SOUND_ENVIRONMENT_CONCERT_HALL

/area/point_loma/research_facility/hallway/central
	name = "Alpha-Tech Hardware - Research Facility Hallway - Central"
	icon_state = "research_facility_hallway_central"

/area/point_loma/research_facility/hallway/east
	name = "Alpha-Tech Hardware - Research Facility Hallway - East"
	icon_state = "research_facility_hallway_east"

/area/point_loma/research_facility/hallway/west
	name = "Alpha-Tech Hardware - Research Facility Hallway - West"
	icon_state = "research_facility_hallway_west"

/area/point_loma/research_facility/hallway/south
	name = "Alpha-Tech Hardware - Research Facility Hallway - South"
	icon_state = "research_facility_hallway_south"

/area/point_loma/research_facility/hallway/north
	name = "Alpha-Tech Hardware - Research Facility Hallway - North"
	icon_state = "research_facility_hallway_north"

/area/point_loma/research_facility/super_death_cannon
	name = "Super Death Cannon" // abstract
	icon_state = "research_facility_sdc"
	minimap_color = MINIMAP_AREA_RESEARCH_CAVE
	ceiling = CEILING_DEEP_UNDERGROUND_METAL
	sound_environment = SOUND_ENVIRONMENT_ROOM

/area/point_loma/research_facility/super_death_cannon/ammo_elevator
	name = "Super Death Cannon - Ammo Elevator"
	icon_state = "research_facility_sdc_ammo"
	sound_environment = SOUND_ENVIRONMENT_HALLWAY
/area/point_loma/research_facility/super_death_cannon/ammo_elevator/upper
	name = "Super Death Cannon - Ammo Elevator"
	icon_state = "research_facility_sdc_ammoup"
	sound_environment = SOUND_ENVIRONMENT_HALLWAY

/area/point_loma/research_facility/super_death_cannon/cannon
	name = "Super Death Cannon - Cannon Room"
	icon_state = "research_facility_sdc_cannon"

/area/point_loma/research_facility/super_death_cannon/observation
	name = "Super Death Cannon - Research Observation Room"
	icon_state = "research_facility_sdc_observ"

/area/point_loma/research_facility/super_death_cannon/observation/civ
	name = "Super Death Cannon - Civilian Observation Room"
	icon_state = "research_facility_observ"

/area/point_loma/research_facility/super_death_cannon/observation/catwalk
	name = "Super Death Cannon - Outside Catwalk"
	icon_state = "research_facility_observ_catwalk"
	ceiling = CEILING_NONE
	requires_power = FALSE
	sound_environment = SOUND_ENVIRONMENT_PARKING_LOT

/area/point_loma/research_facility/super_death_cannon/engineering
	name = "Super Death Cannon - Control Room"
	icon_state = "research_facility_sdc_engineer"
	minimap_color = MINIMAP_AREA_ENGI_CAVE

/area/point_loma/research_facility/briefing
	name = "Alpha-Tech - Meeting Hall and Press Office"
	icon_state = "research_facility_briefing"
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM

/area/point_loma/research_facility/corporate
	name = "Alpha-Tech Hardware Liaison Office"
	minimap_color = MINIMAP_SNOW
	icon_state = "research_facility_corpo"

/area/point_loma/research_facility/command
	name = "Alpha-Tech - Offices"
	minimap_color = MINIMAP_AREA_COMMAND
	icon_state = "research_facility_cic"

/area/point_loma/research_facility/command/mess
	name = "Alpha-Tech - Executive Mess"
	icon_state = "research_facility_cic_mess"

/area/point_loma/research_facility/chapel
	name = "Alpha-Tech - Chapel"
	icon_state = "research_facility_chapel"

/area/point_loma/research_facility/dorms
	name = "Alpha-Tech - Dorms"
	icon_state = "research_facility_dorms"

/area/point_loma/research_facility/crash_site
	name = "Alpha-Tech - Crash Site"
	icon_state = "research_facility_crash_site"
	always_unpowered = TRUE // always off
	sound_environment = SOUND_ENVIRONMENT_CONCERT_HALL

/area/point_loma/research_facility/crash_site/opening
	name = "Alpha-tech - Crash Site - Opening"
	minimap_color = MINIMAP_AREA_HYBRISARESEARCH
	sound_environment = SOUND_ENVIRONMENT_QUARRY

/area/point_loma/research_facility/engineering
	name = "Alpha-Tech - Engineering"
	icon_state = "research_facility_engineer"
	minimap_color = MINIMAP_AREA_ENGI
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/point_loma/research_facility/gym
	name = "Alpha-Tech - Gymnasium"
	icon_state = "research_facility_gym"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS
	sound_environment = SOUND_ENVIRONMENT_HALLWAY

/area/point_loma/research_facility/gym/basketball
	name = "Alpha-Tech - Basketball Court"
	icon_state = "research_facility_gym_bball"

/area/point_loma/research_facility/laundry
	name = "Alpha-Tech - Laundry"
	icon_state = "research_facility_laundry"
	sound_environment = SOUND_ENVIRONMENT_HALLWAY

/area/point_loma/research_facility/library
	name = "Alpha-Tech - Library"
	icon_state = "research_facility_library"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS
	sound_environment = SOUND_ENVIRONMENT_HALLWAY

/area/point_loma/research_facility/medical
	name = "Alpha-Tech - Medbay"
	icon_state = "research_facility_medical"
	minimap_color = MINIMAP_AREA_MEDBAY
	sound_environment = SOUND_ENVIRONMENT_HALLWAY

/area/point_loma/research_facility/pool
	name = "Alpha-Tech - Pool and Sauna"
	icon_state = "research_facility_pool"
	sound_environment = SOUND_ENVIRONMENT_HALLWAY

/area/point_loma/research_facility/pool/water
	temperature = ICE_COLONY_TEMPERATURE // -50 degrees celcius, so the cold icon comes up
	icon_state = "water"

/area/point_loma/research_facility/pool/sauna
	temperature = T120C // 120 degrees celcius, so the heat icon comes up
	icon_state = "sauna"

/area/point_loma/research_facility/research
	name = "Alpha-Tech Research Facility"
	minimap_color = MINIMAP_AREA_RESEARCH
	icon_state = "research_facility_research"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS
	sound_environment = SOUND_ENVIRONMENT_HALLWAY

/area/point_loma/research_facility/research/park
	name = "Alpha-Tech Research Facility - Park"
	minimap_color = MINIMAP_AREA_JUNGLE
	icon_state = "research_facility_park"
	sound_environment = SOUND_ENVIRONMENT_FOREST

/area/point_loma/research_facility/research/park/opening
	name = "Alpha-Tech Research Facility - Park - Sinkhole"
	minimap_color = MINIMAP_AREA_HYBRISARESEARCH
	icon_state = "research_facility_park_opening"

/area/point_loma/research_facility/research/west
	name = "Alpha-Tech Research Facility - West"
	icon_state = "research_facility_research_west"

/area/point_loma/research_facility/research/east
	name = "Alpha-Tech Research Facility - East"
	icon_state = "research_facility_research_east"

/area/point_loma/research_facility/security_hq
	name = "Point Loma - Security Police HQ and Detention"
	minimap_color = MINIMAP_AREA_SEC
	icon_state = "research_facility_security"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

// Mining Colony //

/area/point_loma/airbase/mining_colony
	name = "Point Loma Mining Colony" // abstract
	linked_lz = DROPSHIP_LZ1 // entire mining colony will be cleaned by weedkiller
	minimap_color = MINIMAP_AREA_ENGI_CAVE
	icon_state = "mining_colony"
	sound_environment = SOUND_ENVIRONMENT_QUARRY

/area/point_loma/airbase/mining_colony/caves
	name = "Mining Colony - South Caves"
	minimap_color = MINIMAP_AREA_MINING
	icon_state = "mining_colony_cave"
	ceiling = CEILING_SANDSTONE_ALLOW_CAS
	always_unpowered = TRUE // always off
	sound_environment = SOUND_ENVIRONMENT_CAVE

/area/point_loma/airbase/mining_colony/interior
	name = "Mining Colony - Interior" //abstract
	ceiling = CEILING_METAL
	sound_environment = SOUND_ENVIRONMENT_ROOM

/area/point_loma/airbase/mining_colony/interior/corporate
	name = "Mining Colony - Alpha-Tech Hardware - Corporate Office"
	minimap_color = MINIMAP_SNOW
	icon_state = "mining_colony_corpo"

/area/point_loma/airbase/mining_colony/interior/security
	name = "Point Loma Security Police Outpost"
	minimap_color = MINIMAP_AREA_SEC
	icon_state = "mining_colony_security"

/area/point_loma/airbase/mining_colony/interior/security/barracks
	name = "Point Loma Security Police Outpost - Barracks"
	icon_state = "mining_colony_security_barracks"

/area/point_loma/airbase/mining_colony/interior/engineering
	name = "Mining Colony - Engineering"
	minimap_color = MINIMAP_AREA_ENGI
	icon_state = "mining_colony_engineer"

/area/point_loma/airbase/mining_colony/interior/engineering/communications
	name = "Mining Colony - Communication Relay"
	minimap_color = MINIMAP_AREA_COMMS
	icon_state = "tcomms1"

/area/point_loma/airbase/mining_colony/interior/engineering/communications/two
	name = "Alpha-Tech Research Facility - Communications Relay"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS
	icon_state = "tcomms2"

/area/point_loma/airbase/mining_colony/interior/living_quarters
	name = "Mining Colony - Living Quarters"
	minimap_color = MINIMAP_AREA_COMMAND_CAVE
	icon_state = "mining_colony_living"

/area/point_loma/airbase/mining_colony/interior/storage
	name = "Mining Colony - Storage and Intake"
	minimap_color = MINIMAP_AREA_CARGO
	icon_state = "mining_colony_storage"

/area/point_loma/airbase/mining_colony/exterior
	name = "Mining Colony - Central" //abstract
	always_unpowered = TRUE // always off
	icon_state = "mining_colony_exterior"

/area/point_loma/airbase/mining_colony/exterior/north
	name = "Mining Colony - North"
	icon_state = "mining_colony_north"

/area/point_loma/airbase/mining_colony/exterior/west
	name = "Mining Colony - West"
	icon_state = "mining_colony_west"

/area/point_loma/airbase/mining_colony/exterior/lz
	name = "Mining Colony - Landing Zone"
	minimap_color = MINIMAP_AREA_LZ
	icon_state = "mining_colony_lz"

/area/point_loma/airbase/mining_colony/exterior/security
	name = "Mining Colony - Security Checkpoint" //abstract
	minimap_color = MINIMAP_AREA_SEC
	icon_state= "mining_colony_security"
	ceiling = CEILING_METAL

/area/point_loma/airbase/mining_colony/exterior/security/checkpoint
	name = "Mining Colony - Security Checkpoint - Exterior" //abstract
	minimap_color = MINIMAP_AREA_SEC_CAVE
	icon_state= "mining_colony_sec"

/area/point_loma/airbase/mining_colony/exterior/security/north
	name = "Mining Colony - Security Checkpoint - North"
	icon_state= "mining_colony_sec_north"

/area/point_loma/airbase/mining_colony/exterior/security/checkpoint/north
	name = "Mining Colony - Security Checkpoint - North - Exterior"
	icon_state= "mining_colony_sec_exterior_north"

/area/point_loma/airbase/mining_colony/exterior/security/central
	name = "Mining Colony - Security Checkpoint - Central"
	icon_state= "mining_colony_sec_central"

/area/point_loma/airbase/mining_colony/exterior/security/checkpoint/central
	name = "Mining Colony - Security Checkpoint - Central - Exterior"
	icon_state= "mining_colony_sec_exterior_central"

/area/point_loma/airbase/mining_colony/exterior/security/south
	name = "Mining Colony - Security Checkpoint - South"
	icon_state= "mining_colony_sec_south"

/area/point_loma/airbase/mining_colony/exterior/security/checkpoint/south
	name = "Mining Colony - Security Checkpoint - South - Exterior"
	icon_state= "mining_colony_sec_exterior_south"
