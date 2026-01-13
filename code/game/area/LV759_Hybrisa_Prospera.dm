//lv759 AREAS--------------------------------------//

/area/lv759
	name = "LV-759 Hybrisa Prospera"
	icon = 'icons/turf/hybrisareas.dmi'
	icon_state = "hybrisa"
	can_build_special = TRUE
	powernet_name = "ground"
	minimap_color = MINIMAP_AREA_COLONY_RESANDCOM

//parent types

/area/lv759/indoors
	name = "Hybrisa - Indoors"
	icon_state = "cliff_blocked"//because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV759_INDOORS
	ambience_exterior = AMBIENCE_HYBRISA_INTERIOR

/area/lv759/outdoors
	name = "Hybrisa - Outdoors"
	icon_state = "cliff_blocked"//because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_NONE
	soundscape_playlist = SCAPE_PL_LV759_OUTDOORS
	ambience_exterior = AMBIENCE_CITY
	soundscape_interval = 25

/area/lv759/oob
	name = "Out Of Bounds"
	icon_state = "oob"
	ceiling = CEILING_MAX
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL
	minimap_color = MINIMAP_AREA_OOB
	requires_power = FALSE

/area/lv759/bunker
	name = "Out Of Bounds"
	icon_state = "oob"
	ceiling = CEILING_MAX
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL
	minimap_color = MINIMAP_AREA_OOB

/area/lv759/bunker/gonzo
	name = "Gonzo's hide-out"
	icon_state = "cliff_blocked"
	ceiling = CEILING_MAX
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL
	minimap_color = MINIMAP_AREA_OOB
	soundscape_playlist = SCAPE_PL_LV759_INDOORS
	ambience_exterior = AMBIENCE_HYBRISA_INTERIOR
	requires_power = FALSE

/area/lv759/bunker/checkpoint
	name = "Checkpoint & Hidden Bunker - Entrance"
	icon_state = "cliff_blocked"
	ceiling = CEILING_MAX
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL
	minimap_color = MINIMAP_AREA_OOB
	soundscape_playlist = SCAPE_PL_LV759_INDOORS
	ambience_exterior = AMBIENCE_HYBRISA_INTERIOR

// Landing Zone 1

/area/lv759/outdoors/landing_zone_1
	name = "Nova Medica Hospital Complex - Emergency Response - Landing Zone One"
	icon_state = "medical_lz1"
	is_resin_allowed =  FALSE
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ
	ceiling = CEILING_NONE
	linked_lz = DROPSHIP_LZ1

/area/lv759/indoors/landing_zone_1/flight_control_room
	name = "Nova Medica Hospital Complex - Emergency Response - Landing Zone One - Flight Control Room"
	icon_state = "hybrisa"
	ceiling = CEILING_METAL
	is_landing_zone = TRUE
	linked_lz = DROPSHIP_LZ1

/area/lv759/indoors/landing_zone_1/lz1_console
	name = "Nova Medica Hospital Complex - Emergency Response - Landing Zone One - Dropship Alamo Console"
	icon_state = "hybrisa"
	requires_power = FALSE
	ceiling = CEILING_METAL
	is_landing_zone = TRUE
	linked_lz = DROPSHIP_LZ1

// Landing Zone 2

/area/lv759/outdoors/landing_zone_2
	name = "KMCC Interstellar Freight Hub - Landing Zone Two"
	icon_state = "mining_lz2"
	is_resin_allowed =  FALSE
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ
	ceiling = CEILING_NONE
	linked_lz = DROPSHIP_LZ2

/area/lv759/indoors/landing_zone_2/kmcc_hub_flight_control_room
	name = "KMCC Interstellar Freight Hub - Flight Control Room"
	icon_state = "hybrisa"
	ceiling = CEILING_METAL
	linked_lz = DROPSHIP_LZ2

/area/lv759/indoors/landing_zone_2/kmcc_hub_security
	name = "KMCC Interstellar Freight Hub - Security Checkpoint Office"
	icon_state = "security_checkpoint"
	ceiling = CEILING_METAL
	linked_lz = DROPSHIP_LZ2

/area/lv759/indoors/landing_zone_2/kmcc_hub_lounge_north
	name = "KMCC Interstellar Freight Hub - Passenger Departures - Lounge North"
	icon_state = "hybrisa"
	ceiling = CEILING_METAL
	linked_lz = DROPSHIP_LZ2

/area/lv759/indoors/landing_zone_2/kmcc_hub_fuel
	name = "KMCC Interstellar Freight Hub - Fuel Storage & Maintenance - North"
	icon_state = "hybrisa"
	ceiling = CEILING_METAL
	linked_lz = DROPSHIP_LZ2

/area/lv759/indoors/landing_zone_2/kmcc_hub_lounge_south
	name = "KMCC Interstellar Freight Hub - Passenger Departures - Lounge South"
	icon_state = "hybrisa"
	ceiling = CEILING_METAL
	linked_lz = DROPSHIP_LZ2

/area/lv759/indoors/landing_zone_2/kmcc_hub_lounge_hallway
	name = "KMCC Interstellar Freight Hub - Passenger Departures - Hallway"
	icon_state = "hybrisa"
	ceiling = CEILING_METAL
	linked_lz = DROPSHIP_LZ2

/area/lv759/indoors/landing_zone_2/kmcc_hub_south_office
	name = "KMCC Interstellar Freight Hub - Passenger Departures - South Office"
	icon_state = "hybrisa"
	ceiling = CEILING_METAL
	linked_lz = DROPSHIP_LZ2

/area/lv759/indoors/landing_zone_2/kmcc_hub_maintenance
	name = "KMCC Interstellar Freight Hub - Passenger Departures - Maintenance"
	icon_state = "hybrisa"
	ceiling = CEILING_METAL
	linked_lz = DROPSHIP_LZ2

/area/lv759/indoors/landing_zone_2/kmcc_hub/lz2_console
	name = "KMCC Interstellar Freight Hub - Dropship Normandy Console"
	icon_state = "hybrisa"
	requires_power = FALSE
	ceiling = CEILING_METAL
	linked_lz = DROPSHIP_LZ2

/area/lv759/indoors/landing_zone_2/kmcc_hub_cargo
	name = "KMCC Interstellar Freight Hub - Cargo Processing Center"
	icon_state = "mining_cargo"
	ceiling = CEILING_METAL
	minimap_color = MINIMAP_AREA_COLONY_RESANDCOM
	linked_lz = DROPSHIP_LZ2

/area/lv759/indoors/landing_zone_2/kmcc_hub_maintenance_north
	name = "KMCC Interstellar Freight Hub - Cargo Processing Center - Maintenance"
	icon_state = "mining"
	ceiling = CEILING_METAL
	minimap_color = MINIMAP_AREA_COLONY_RESANDCOM
	linked_lz = DROPSHIP_LZ2

/area/lv759/outdoors/landing_zone_2/kmcc_hub_cargo_entrance_south
	name = "KMCC Interstellar Freight Hub - Cargo Processing Center - Main Entrance & South Unloading Platform"
	icon_state = "mining"
	ceiling = CEILING_NONE
	minimap_color = MINIMAP_AREA_COLONY
	linked_lz = DROPSHIP_LZ2

// Derelict Ship

/area/lv759/indoors/derelict_ship
	name = "Derelict Ship"
	icon_state = "derelictship"
	ceiling = CEILING_REINFORCED_METAL
	flags_area = AREA_NOTUNNEL
	ambience_exterior = AMBIENCE_DERELICT
	soundscape_playlist = SCAPE_PL_LV759_DERELICTSHIP
	ceiling_muffle = FALSE
	minimap_color = MINIMAP_AREA_HYBRISACAVES
	unoviable_timer = FALSE

// Caves

/area/lv759/indoors/caves
	name = "Caves"
	icon_state = "caves_plateau"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	ambience_exterior = AMBIENCE_HYBRISA_CAVES_ALARM
	soundscape_playlist = SCAPE_PL_LV759_DEEPCAVES
	ceiling_muffle = FALSE
	minimap_color = MINIMAP_AREA_HYBRISACAVES
	unoviable_timer = FALSE

/area/lv759/indoors/caves/wy_research_complex_entrance
	name = "Weyland-Yutani - Advanced Bio-Genomic Research Complex - North Main Entrance"
	icon_state = "wylab"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	ambience_exterior = AMBIENCE_HYBRISA_CAVES_ALARM
	soundscape_playlist = SCAPE_PL_LV759_DEEPCAVES
	ceiling_muffle = FALSE
	minimap_color = MINIMAP_AREA_HYBRISACAVES
	unoviable_timer = FALSE

/area/lv759/indoors/caves/west_caves
	name = "Caverns - West"
	icon_state = "caves_west"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	ambience_exterior = AMBIENCE_HYBRISA_CAVES
	soundscape_playlist = SCAPE_PL_LV759_CAVES
	ceiling_muffle = FALSE
	minimap_color = MINIMAP_AREA_HYBRISACAVES
	unoviable_timer = 25 MINUTES
	always_unpowered = TRUE

/area/lv759/indoors/caves/electric_fence1
	name = "Electrical Fence - West Caves"
	icon_state = "power0"

/area/lv759/indoors/caves/electric_fence2
	name = "Electrical Fence - East Caves"
	icon_state = "power0"

/area/lv759/indoors/caves/electric_fence3
	name = "Electrical Fence - Central Caves"
	icon_state = "power0"

/area/lv759/indoors/caves/electric_fence2
	name = "Electrical Fence - East Caves"
	icon_state = "power0"

/area/lv759/indoors/caves/comms_tower
	name = "Comms Tower - Central Caves"
	icon_state = "power0"

/area/lv759/indoors/caves/sensory_tower
	name = "Sensory Tower - Plateau Caves"
	icon_state = "power0"

/area/lv759/indoors/caves/west_caves_alarm
	name = "Caverns - West"
	icon_state = "caves_west"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	ambience_exterior = AMBIENCE_HYBRISA_CAVES_ALARM
	soundscape_playlist = SCAPE_PL_LV759_CAVES
	ceiling_muffle = FALSE
	minimap_color = MINIMAP_AREA_HYBRISACAVES

/area/lv759/indoors/caves/east_caves
	name = "Caverns - East"
	icon_state = "caves_east"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	ambience_exterior = AMBIENCE_HYBRISA_CAVES
	soundscape_playlist = SCAPE_PL_LV759_DEEPCAVES
	ceiling_muffle = FALSE
	minimap_color = MINIMAP_AREA_HYBRISACAVES
	always_unpowered = TRUE

/area/lv759/indoors/caves/east_caves/north
	name = "Caverns - East"
	icon_state = "caves_east"
	unoviable_timer = FALSE

/area/lv759/indoors/caves/south_caves
	name = "Caverns - South"
	icon_state = "caves_south"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	ambience_exterior = AMBIENCE_HYBRISA_CAVES
	soundscape_playlist = SCAPE_PL_LV759_DEEPCAVES
	ceiling_muffle = FALSE
	minimap_color = MINIMAP_AREA_HYBRISACAVES
	always_unpowered = TRUE

/area/lv759/indoors/caves/south_caves/derelict_ship
	name = "Caverns - South"
	icon_state = "caves_south"
	unoviable_timer = FALSE
	always_unpowered = TRUE

/area/lv759/indoors/caves/south_east_caves
	name = "Caverns - Southeast"
	icon_state = "caves_southeast"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	ambience_exterior = AMBIENCE_HYBRISA_CAVES
	soundscape_playlist = SCAPE_PL_LV759_DEEPCAVES
	ceiling_muffle = FALSE
	minimap_color = MINIMAP_AREA_HYBRISACAVES
	always_unpowered = TRUE

/area/lv759/indoors/caves/south_west_caves
	name = "Caverns - Southwest"
	icon_state = "caves_southwest"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	ambience_exterior = AMBIENCE_HYBRISA_CAVES
	soundscape_playlist = SCAPE_PL_LV759_DEEPCAVES
	ceiling_muffle = FALSE
	minimap_color = MINIMAP_AREA_HYBRISACAVES
	always_unpowered = TRUE

/area/lv759/indoors/caves/south_west_caves_alarm
	name = "Caverns - Southwest"
	icon_state = "wylab"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	ambience_exterior = AMBIENCE_HYBRISA_CAVES_ALARM
	soundscape_playlist = SCAPE_PL_LV759_DEEPCAVES
	ceiling_muffle = FALSE
	minimap_color = MINIMAP_AREA_HYBRISARESEARCH

/area/lv759/indoors/caves/north_west_caves
	name = "Caverns - Northwest"
	icon_state = "caves_northwest"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	ambience_exterior = AMBIENCE_HYBRISA_CAVES
	soundscape_playlist = SCAPE_PL_LV759_DEEPCAVES
	ceiling_muffle = FALSE
	minimap_color = MINIMAP_AREA_HYBRISACAVES
	unoviable_timer = 25 MINUTES

/area/lv759/outdoors/caves/north_west_caves_outdoors
	name = "Caverns - Northwest"
	icon_state = "caves_northwest"
	ceiling = CEILING_NONE
	ambience_exterior = AMBIENCE_HYBRISA_CAVES
	soundscape_playlist = SCAPE_PL_LV759_CAVES
	ceiling_muffle = FALSE
	minimap_color = MINIMAP_AREA_HYBRISACAVES
	unoviable_timer = 25 MINUTES

/area/lv759/indoors/caves/north_east_caves
	name = "Caverns - Northeast"
	icon_state = "caves_northeast"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	ambience_exterior = AMBIENCE_HYBRISA_CAVES
	soundscape_playlist = SCAPE_PL_LV759_CAVES
	ceiling_muffle = FALSE
	minimap_color = MINIMAP_AREA_HYBRISACAVES
	linked_lz = DROPSHIP_LZ1
	always_unpowered = TRUE

/area/lv759/indoors/caves/north_east_caves/south
	linked_lz = list(DROPSHIP_LZ1, DROPSHIP_LZ2)

/area/lv759/indoors/caves/north_caves
	name = "Caverns - North"
	icon_state = "caves_north"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	ambience_exterior = AMBIENCE_HYBRISA_CAVES
	soundscape_playlist = SCAPE_PL_LV759_DEEPCAVES
	ceiling_muffle = FALSE
	minimap_color = MINIMAP_AREA_HYBRISACAVES
	always_unpowered = TRUE

/area/lv759/indoors/caves/north_caves/east
	linked_lz = DROPSHIP_LZ1
	always_unpowered = TRUE

/area/lv759/indoors/caves/central_caves
	name = "Caverns - Central"
	icon_state = "caves_central"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	ambience_exterior = AMBIENCE_HYBRISA_CAVES
	soundscape_playlist = SCAPE_PL_LV759_CAVES
	ceiling_muffle = FALSE
	minimap_color = MINIMAP_AREA_HYBRISACAVES
	unoviable_timer = FALSE
	always_unpowered = TRUE

/area/lv759/indoors/caves/central_caves_north
	name = "Caverns - Central"
	icon_state = "caves_central"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	ambience_exterior = AMBIENCE_HYBRISA_CAVES
	soundscape_playlist = SCAPE_PL_LV759_CAVES
	ceiling_muffle = FALSE
	minimap_color = MINIMAP_AREA_HYBRISACAVES
	always_unpowered = TRUE

/area/lv759/indoors/caves/north_east_caves_comms
	name = "KMCC - Mining Outpost - East - Subspace-Communications"
	icon_state = "comms_1"
	ceiling = CEILING_NONE
	minimap_color = MINIMAP_AREA_COMMS
	linked_lz = list(DROPSHIP_LZ1, DROPSHIP_LZ2)

/area/lv759/indoors/caves/north_east_caves_comms_2
	name = "NMHC - Emergency Response - Landing Zone One - Caverns - Northeast - Subspace-Communications"
	icon_state = "comms_1"
	minimap_color = MINIMAP_AREA_COMMS
	linked_lz = DROPSHIP_LZ1

// Caves Central Plateau

/area/lv759/outdoors/caveplateau
	name = "Caverns - Plateau"
	icon_state = "caves_plateau"
	ceiling = CEILING_NONE
	ambience_exterior = AMBIENCE_HYBRISA_CAVES
	soundscape_playlist = SCAPE_PL_LV759_PLATEAU_OUTDOORS
	minimap_color = MINIMAP_AREA_HYBRISACAVES
	unoviable_timer = FALSE
	always_unpowered = TRUE

// Colony Streets

/area/lv759/outdoors/colony_streets
	name = "Colony Streets"
	icon_state = "colonystreets_north"
	ceiling = CEILING_NONE
	minimap_color = MINIMAP_AREA_COLONY_STREETS

/area/lv759/outdoors/colony_streets/central_streets
	name = "Central Street - West"
	icon_state = "colonystreets_west"

/area/lv759/outdoors/colony_streets/east_central_street
	name = "Central Street - East"
	icon_state = "colonystreets_east"
	linked_lz = DROPSHIP_LZ1

/area/lv759/outdoors/colony_streets/east_central_street_left
	name = "Central Street - East"
	icon_state = "colonystreets_east"

/area/lv759/outdoors/colony_streets/south_street
	name = "Colony Streets - South"
	icon_state = "colonystreets_south"

/area/lv759/outdoors/colony_streets/south_east_street
	name = "Colony Streets - Southeast"
	icon_state = "colonystreets_southeast"
	linked_lz = DROPSHIP_LZ2

/area/lv759/outdoors/colony_streets/south_west_street
	name = "Colony Streets - Southwest - WY Checkpoint Passthrough"
	icon_state = "colonystreets_southwest"
	ceiling = CEILING_NONE
	ambience_exterior = AMBIENCE_HYBRISA_CAVES
	soundscape_playlist = SCAPE_PL_LV759_CAVES

/area/lv759/outdoors/colony_streets/south_east_street_comms
	name = "Colony Streets - Southeast - Subspace-Communications"
	icon_state = "comms_1"
	ceiling = CEILING_NONE
	minimap_color = MINIMAP_AREA_COMMS
	linked_lz = DROPSHIP_LZ2

/area/lv759/outdoors/colony_streets/north_west_street
	name = "Colony Streets - Northwest"
	icon_state = "colonystreets_northwest"

/area/lv759/outdoors/colony_streets/north_east_street
	name = "Colony Streets - Northeast"
	icon_state = "colonystreets_northeast"
	linked_lz = DROPSHIP_LZ1

/area/lv759/outdoors/colony_streets/north_east_street_LZ
	name = "Colony Streets - Northeast"
	icon_state = "colonystreets_northeast"
	is_landing_zone = TRUE
	linked_lz = DROPSHIP_LZ1

/area/lv759/outdoors/colony_streets/north_street
	name = "Colony Streets - North"
	icon_state = "colonystreets_north"

//Spaceport Indoors

/area/lv759/indoors/spaceport
	minimap_color = MINIMAP_AREA_COLONY_SPACE_PORT
	unoviable_timer = FALSE

/area/lv759/indoors/spaceport/hallway_northeast
	name = "Weyland-Yutani Celestia Gateway Space-Port - Hallway - Northeast"
	icon_state = "WYSpaceport"

/area/lv759/indoors/spaceport/hallway_north
	name = "Weyland-Yutani Celestia Gateway Space-Port - Hallway - North"
	icon_state = "WYSpaceport"

/area/lv759/indoors/spaceport/hallway_northwest
	name = "Weyland-Yutani Celestia Gateway Space-Port - Hallway - Northwest"
	icon_state = "WYSpaceport"

/area/lv759/indoors/spaceport/hallway_east
	name = "Weyland-Yutani Celestia Gateway Space-Port - Hallway - East"
	icon_state = "WYSpaceport"

/area/lv759/indoors/spaceport/heavyequip
	name = "Weyland-Yutani Celestia Gateway Space-Port - Heavy Equipment Storage"
	icon_state = "WYSpaceport"

/area/lv759/indoors/spaceport/engineering
	name = "Weyland-Yutani Celestia Gateway Space-Port - Fuel Storage & Processing"
	icon_state = "WYSpaceport"

/area/lv759/indoors/spaceport/janitor
	name = "Weyland-Yutani Celestia Gateway Space-Port - Janitorial Storage Room"
	icon_state = "WYSpaceport"

/area/lv759/indoors/spaceport/maintenance_east
	name = "Weyland-Yutani Celestia Gateway Space-Port - Maintenance - East"
	icon_state = "WYSpaceport"

/area/lv759/indoors/spaceport/communications_office
	name = "Weyland-Yutani Celestia Gateway Space-Port - Communications & Administration Office"
	icon_state = "WYSpaceportadmin"

/area/lv759/indoors/spaceport/flight_control_room
	name = "Weyland-Yutani Celestia Gateway Space-Port - Flight Control Room"
	icon_state = "WYSpaceportadmin"

/area/lv759/indoors/spaceport/security
	name = "Weyland-Yutani Celestia Gateway Space-Port - Security- Observation & Office"
	icon_state = "security_checkpoint"

/area/lv759/indoors/spaceport/security_office
	name = "Weyland-Yutani Celestia Gateway Space-Port - Office"
	icon_state = "security_checkpoint"

/area/lv759/indoors/spaceport/cargo
	name = "Weyland-Yutani Celestia Gateway Space-Port - Cargo Bay"
	icon_state = "WYSpaceportcargo"

/area/lv759/indoors/spaceport/cargo_maintenance
	name = "Weyland-Yutani Celestia Gateway Space-Port - Cargo - Maintenance"
	icon_state = "WYSpaceportcargo"

/area/lv759/indoors/spaceport/baggagehandling
	name = "Weyland-Yutani Celestia Gateway Space-Port - Baggage Storage & Handling"
	icon_state = "WYSpaceportbaggage"

/area/lv759/indoors/spaceport/cuppajoes
	name = "Weyland-Yutani Celestia Gateway Space-Port - Cuppa Joe's"
	icon_state = "cuppajoes"

/area/lv759/indoors/spaceport/kitchen
	name = "Weyland-Yutani Celestia Gateway Space-Port - Kitchen"
	icon_state = "WYSpaceportblue"

/area/lv759/indoors/spaceport/docking_bay_2
	name = "Weyland-Yutani Celestia Gateway Space-Port - Docking Bay: 2 - Refueling and Maintenance"
	icon_state = "WYSpaceportblue"

/area/lv759/indoors/spaceport/docking_bay_1
	name = "Weyland-Yutani Celestia Gateway Space-Port - Docking Bay: 1"
	icon_state = "WYSpaceport"

// Ships

/area/lv759/indoors/spaceport/starglider
	name = "WY-LWI StarGlider SG-200"
	icon_state = "wydropship"
	requires_power = FALSE
	minimap_color = MINIMAP_AREA_COLONY

/area/lv759/indoors/spaceport/horizon_runner
	name = "WY-LWI Horizon Runner HR-150"
	icon_state = "wydropship"
	requires_power = FALSE
	minimap_color = MINIMAP_AREA_COLONY

/area/lv759/indoors/spaceport/clf_dropship
	name = "UD-9M 'Dogbite'"
	icon_state = "wydropship"
	requires_power = FALSE
	minimap_color = MINIMAP_AREA_COLONY

// Garage

/area/lv759/indoors/garage_reception
	name = "Garage - Reception"
	icon_state = "garage"

/area/lv759/indoors/garage_workshop
	name = "Garage - Workshop"
	icon_state = "garage"

/area/lv759/indoors/garage_workshop_storage
	name = "Garage - Workshop - Storage Room"
	icon_state = "garage"

/area/lv759/indoors/garage_managersoffice
	name = "Garage - Managers Office"
	icon_state = "garage"

/area/lv759/indoors/garage_restroom
	name = "Garage - Restroom"
	icon_state = "garage"

// Meridian Offices & Factory Floor

/area/lv759/indoors/meridian/meridian_foyer
	name = "Meridian - Foyer"
	icon_state = "meridian"

/area/lv759/indoors/meridian/meridian_showroom
	name = "Meridian - Showroom"
	icon_state = "meridian"

/area/lv759/indoors/meridian/meridian_office
	name = "Meridian - Offices"
	icon_state = "meridian"

/area/lv759/indoors/meridian/meridian_managersoffice
	name = "Meridian - Manager's Office"
	icon_state = "meridian"

/area/lv759/indoors/meridian/meridian_factory
	name = "Meridian - Factory Floor"
	icon_state = "meridian_factory"

/area/lv759/indoors/meridian/meridian_restroom
	name = "Meridian - Restroom"
	icon_state = "meridian"

/area/lv759/indoors/meridian/meridian_maintenance
	name = "Meridian - Maintenance"
	icon_state = "meridian"

/area/lv759/indoors/meridian/meridian_maintenance_east
	name = "Meridian - Factory Floor - Maintenance"
	icon_state = "meridian"

// Apartments (Dorms)

/area/lv759/indoors/apartment
	minimap_color = MINIMAP_AREA_COLONY_RESANDCOM

/area/lv759/indoors/apartment/westfoyer
	name = "Westhaven Apartment Complex - West - Foyer"
	icon_state = "apartments"

/area/lv759/indoors/apartment/westhallway
	name = "Westhaven Apartment Complex - West - Hallway"
	icon_state = "apartments"

/area/lv759/indoors/apartment/westbedrooms
	name = "Westhaven Apartment Complex - West - Apartments"
	icon_state = "apartments"

/area/lv759/indoors/apartment/westshowers
	name = "Westhaven Apartment Complex - West - Showers"
	icon_state = "apartments"

/area/lv759/indoors/apartment/westrestroom
	name = "Westhaven Apartment Complex - West - Restrooms"
	icon_state = "apartments"

/area/lv759/indoors/apartment/westentertainment
	name = "Westhaven Apartment Complex - West - Recreation Hub"
	icon_state = "apartments"

/area/lv759/indoors/apartment/eastentrance
	name = "Westhaven Apartment Complex - East - Entrance Room"
	icon_state = "apartments"

/area/lv759/indoors/apartment/eastfoyer
	name = "Westhaven Apartment Complex - East - Foyer"
	icon_state = "apartments"

/area/lv759/indoors/apartment/eastrestroomsshower
	name = "Westhaven Apartment Complex - East - Restrooms & Showers"
	icon_state = "apartments"

/area/lv759/indoors/apartment/eastbedrooms
	name = "Westhaven Apartment Complex - East - Bedrooms"
	icon_state = "apartments"

/area/lv759/indoors/apartment/eastbedroomsstorage
	name = "Westhaven Apartment Complex - East - Bedrooms - Storage Room"
	icon_state = "apartments"

/area/lv759/indoors/apartment/northfoyer
	name = "Westhaven Apartment Complex - North - Foyer"
	icon_state = "apartments"

/area/lv759/indoors/apartment/northhallway
	name = "Westhaven Apartment Complex - North - Hallway"
	icon_state = "apartments"

/area/lv759/indoors/apartment/northapartments
	name = "Westhaven Apartment Complex - North - Apartments"
	icon_state = "apartments"

// Weyland-Yutani Offices

/area/lv759/indoors/weyyu_office
	name = "Weyland-Yutani Offices - Reception Hallway"
	icon_state = "wyoffice"
	minimap_color = MINIMAP_AREA_COMMAND

/area/lv759/indoors/weyyu_office/hallway
	name = "Weyland-Yutani Offices - West Foyer"
	icon_state = "wyoffice"

/area/lv759/indoors/weyyu_office/floor
	name = "Weyland-Yutani Offices - Main Office Floor"

/area/lv759/indoors/weyyu_office/breakroom
	name = "Weyland-Yutani Offices - Breakroom"

/area/lv759/indoors/weyyu_office/vip
	name = "Weyland-Yutani Offices - Conference Room"

/area/lv759/indoors/weyyu_office/pressroom
	name = "Weyland-Yutani Offices - Assembly Hall"

/area/lv759/indoors/weyyu_office/supervisor
	name = "Weyland-Yutani Offices - Colony Supervisors Office"

// Weyland-Yutani Offices

/area/lv759/indoors/twe_souter_outpost
	name = "IASF Outpost Souter - Entrance"
	icon_state = "security_hub"
	minimap_color = MINIMAP_AREA_COMMAND

/area/lv759/indoors/twe_souter_outpost/reception
	name = "IASF Outpost Souter - Reception Office"

/area/lv759/indoors/twe_souter_outpost/hallway
	name = "IASF Outpost Souter - Main Hall"

/area/lv759/indoors/twe_souter_outpost/dorm
	name = "IASF Outpost Souter - Dormitory"

/area/lv759/indoors/twe_souter_outpost/maint
	name = "IASF Outpost Souter - Flight Maintenance Room"

/area/lv759/indoors/twe_souter_outpost/hangar
	name = "IASF Outpost Souter - Hangar"

/area/lv759/indoors/twe_souter_outpost/flight
	name = "IASF Outpost Souter - Flight Control"

/area/lv759/indoors/twe_souter_outpost/armoury
	name = "IASF Outpost Souter - Armoury"
// Using 'armoury' is correct here since its for a base controlled by future British people, not Americans

/area/lv759/indoors/twe_souter_outpost/twe_gunship
	name = "TWE UD4-UK"
	icon_state = "wydropship"
	requires_power = FALSE
	minimap_color = MINIMAP_AREA_COLONY

// Bar & Entertainment Complex

/area/lv759/indoors/bar
	name = "Bar"
	icon_state = "bar"

/area/lv759/indoors/bar/entertainment
	name = "Bar - Entertainment Subsection"

/area/lv759/indoors/bar/bathroom
	name = "Bar - Restrooms"

/area/lv759/indoors/bar/maintenance
	name = "Bar - Maintenance"

/area/lv759/indoors/bar/kitchen
	name = "Bar - Kitchen"

//Botany

/area/lv759/indoors/botany/botany_greenhouse
	name = "Botany - Greenhouse"
	icon_state = "botany"

/area/lv759/indoors/botany/botany_hallway
	name = "Botany - Hallway"
	icon_state = "botany"

/area/lv759/indoors/botany/botany_maintenance
	name = "Botany - Maintenance"
	icon_state = "botany"

/area/lv759/indoors/botany/botany_mainroom
	name = "Botany - Main Room"
	icon_state = "botany"

// Hotel

/area/lv759/indoors/hotel
	minimap_color = MINIMAP_AREA_COLONY_RESANDCOM

/area/lv759/indoors/hotel/hotel_hallway
	name = "Prospera Grand Hotel - Hallway"
	icon_state = "apartments"

/area/lv759/indoors/hotel/hotel_rooms
	name = "Prospera Grand Hotel - Room"
	icon_state = "apartments"

// Hosptial

/area/lv759/indoors/hospital
	icon_state = "medical"
	minimap_color = MINIMAP_AREA_MEDBAY
	linked_lz = DROPSHIP_LZ1

/area/lv759/indoors/hospital/paramedics_garage
	name = "Nova Medica Hospital Complex - Paramedic's Garage"

/area/lv759/indoors/hospital/cryo_room
	name = "Nova Medica Hospital Complex - Cryo Ward"

/area/lv759/indoors/hospital/emergency_room
	name = "Nova Medica Hospital Complex - Emergency Room"

/area/lv759/indoors/hospital/reception
	name = "Nova Medica Hospital Complex - Reception"

/area/lv759/indoors/hospital/cmo_office
	name = "Nova Medica Hospital Complex - Chief Medical Officer's Office"

/area/lv759/indoors/hospital/maintenance
	name = "Nova Medica Hospital Complex - Subspace Communications & Electrical Systems"
	icon_state = "comms_1"
	minimap_color = MINIMAP_AREA_COMMS

/area/lv759/indoors/hospital/break_room
	name = "Nova Medica Hospital Complex - Breakroom"

/area/lv759/indoors/hospital/pharmacy
	name = "Nova Medica Hospital Complex - Pharmacy & Outgoing Foyer"

/area/lv759/indoors/hospital/outgoing
	name = "Nova Medica Hospital Complex - Outgoing Ward"

/area/lv759/indoors/hospital/central_hallway
	name = "Nova Medica Hospital Complex - Central Hallway"

/area/lv759/indoors/hospital/east_hallway
	name = "Nova Medica Hospital Complex - East Hallway"

/area/lv759/indoors/hospital/medical_storage
	name = "Nova Medica Hospital Complex - Medical Storage"

/area/lv759/indoors/hospital/operation
	name = "Nova Medica Hospital Complex - Operation Theatres & Observation"

/area/lv759/indoors/hospital/patient_ward
	name = "Nova Medica Hospital Complex - Patient Ward"

/area/lv759/indoors/hospital/virology
	name = "Nova Medica Hospital Complex - Virology"

/area/lv759/indoors/hospital/morgue
	name = "Nova Medica Hospital Complex - Morgue"

/area/lv759/indoors/hospital/icu
	name = "Nova Medica Hospital Complex - Intensive Care Ward"

/area/lv759/indoors/hospital/storage
	name = "Nova Medica Hospital Complex - Office"

/area/lv759/indoors/hospital/maintenance_north
	name = "Nova Medica Hospital Complex - Maintenance North"

/area/lv759/indoors/hospital/maintenance_south
	name = "Nova Medica Hospital Complex - Unisex-Restroom"

/area/lv759/indoors/hospital/janitor
	name = "Nova Medica Hospital Complex - Janitors Closet"

// Mining

/area/lv759/indoors/mining_outpost
	icon_state = "mining"
	minimap_color = MINIMAP_AREA_MINING

/area/lv759/indoors/mining_outpost/north
	name = "KMCC - Mining Outpost - North"
	icon_state = "mining"

/area/lv759/indoors/mining_outpost/north_maint
	name = "KMCC - Mining Outpost - North - Maintenance"
	icon_state = "mining"

/area/lv759/indoors/mining_outpost/northeast
	name = "KMCC - Mining Outpost - Northeast"
	icon_state = "mining"
	is_landing_zone = TRUE
	linked_lz = DROPSHIP_LZ1

/area/lv759/indoors/mining_outpost/south
	name = "KMCC - Mining Outpost - Southeast"
	icon_state = "mining"

/area/lv759/indoors/mining_outpost/vehicledeployment
	name = "KMCC - Mining Outpost - South - Vehicle Deployment"
	icon_state = "mining"
	linked_lz = DROPSHIP_LZ2

/area/lv759/indoors/mining_outpost/processing
	name = "KMCC - Mining Outpost - South - Processing & Storage"
	icon_state = "mining"
	linked_lz = DROPSHIP_LZ2

/area/lv759/indoors/mining_outpost/east
	name = "KMCC - Mining Outpost - East"
	icon_state = "mining"
	linked_lz = list(DROPSHIP_LZ1, DROPSHIP_LZ2)

/area/lv759/indoors/mining_outpost/east_dorms
	name = "KMCC - Mining Outpost - East - Dorms"
	icon_state = "mining"
	linked_lz = DROPSHIP_LZ2

/area/lv759/indoors/mining_outpost/east_deploymentbay
	name = "KMCC - Mining Outpost - East - Deployment Bay"
	icon_state = "mining"
	linked_lz = DROPSHIP_LZ2

/area/lv759/indoors/mining_outpost/east_command
	name = "KMCC - Mining Outpost - East - Command Center"
	icon_state = "mining"
	linked_lz = DROPSHIP_LZ2

/area/lv759/indoors/mining_outpost/cargo_maint
	name = "KMCC - Mining Outpost - East - Maintenance"
	icon_state = "mining"

/area/lv759/outdoors/mining_outpost/south_entrance
	name = "KMCC - Mining Outpost - South - Vehicle Deployment Entrance"
	icon_state = "mining"
	ceiling = CEILING_NONE
	minimap_color = MINIMAP_AREA_COLONY
	linked_lz = DROPSHIP_LZ2

// Electrical Substations

/area/lv759/indoors/electical_systems
	minimap_color = MINIMAP_AREA_COLONY_ENGINEERING

/area/lv759/indoors/electical_systems/substation1
	name = "Electrical Systems - Substation One - Control Room"
	icon_state = "power0"

/area/lv759/indoors/electical_systems/substation2
	name = "Electrical Systems - Substation Two"
	icon_state = "power0"
	linked_lz = DROPSHIP_LZ2

/area/lv759/indoors/electical_systems/substation3
	name = "Electrical Systems - Substation Three"
	icon_state = "power0"
	linked_lz = DROPSHIP_LZ1

// Power-Plant (Engineering)

/area/lv759/indoors/power_plant
	name = "Weyland-Yutani DynaGrid Nexus - Central Hallway"
	icon_state = "power0"
	minimap_color = MINIMAP_AREA_COLONY_ENGINEERING

/area/lv759/indoors/power_plant/Hallway_East
	name = "Weyland-Yutani DynaGrid Nexus - East Hallway"
	icon_state = "power0"
	minimap_color = MINIMAP_AREA_COLONY_ENGINEERING
	linked_lz = DROPSHIP_LZ1

/area/lv759/indoors/power_plant/south_hallway
	name = "Weyland-Yutani DynaGrid Nexus - South Hallway"

/area/lv759/indoors/power_plant/geothermal_generators
	name = "Weyland-Yutani DynaGrid Nexus - Geothermal Generators Room"

/area/lv759/indoors/power_plant/power_storage
	name = "Weyland-Yutani DynaGrid Nexus - Power Storage Room"

/area/lv759/outdoors/power_plant/transformers_north
	name = "Weyland-Yutani DynaGrid Nexus - Transformers - North"
	minimap_color = MINIMAP_AREA_COLONY_RESANDCOM
	linked_lz = DROPSHIP_LZ1

/area/lv759/outdoors/power_plant/transformers_south
	name = "Weyland-Yutani DynaGrid Nexus - Transformers - South"
	minimap_color = MINIMAP_AREA_COLONY_RESANDCOM
	linked_lz = DROPSHIP_LZ1

/area/lv759/indoors/power_plant/transformers_north
	name = "Weyland-Yutani DynaGrid Nexus - Transformers - North"

/area/lv759/indoors/power_plant/transformers_south
	name = "Weyland-Yutani DynaGrid Nexus - Transformers - South"

/area/lv759/indoors/power_plant/gas_generators
	name = "Weyland-Yutani DynaGrid Nexus - Gas Mixing & Storage "

/area/lv759/indoors/power_plant/fusion_generators
	name = "Weyland-Yutani DynaGrid Nexus - Control Center"

/area/lv759/indoors/power_plant/telecomms
	icon_state = "comms_1"
	name = "Weyland-Yutani DynaGrid Nexus - Telecommunications"
	minimap_color = MINIMAP_AREA_COMMS
	linked_lz = DROPSHIP_LZ1

/area/lv759/indoors/power_plant/workers_canteen
	name = "Weyland-Yutani DynaGrid Nexus - Worker's Canteen"
	linked_lz = DROPSHIP_LZ1

/area/lv759/indoors/power_plant/workers_canteen_kitchen
	name = "Weyland-Yutani DynaGrid Nexus - Worker's Canteen - Kitchen"
	linked_lz = DROPSHIP_LZ2

/area/lv759/indoors/power_plant/equipment_east
	name = "Weyland-Yutani DynaGrid Nexus - Equipment Storage Room - East"

/area/lv759/indoors/power_plant/equipment_west
	name = "Weyland-Yutani DynaGrid Nexus - Equipment Storage Room - West"

// Marshalls (NSPA)

/area/lv759/indoors/colonial_marshals
	name = "NSPA - Ironbridge Precinct"
	icon_state = "security_hub"
	minimap_color = MINIMAP_AREA_COLONY_MARSHALLS

/area/lv759/indoors/colonial_marshals/prisoners_cells
	name = "NSPA - Ironbridge Precinct - Maximum Security Ward - Cells"

/area/lv759/indoors/colonial_marshals/prisoners_foyer
	name = "NSPA - Ironbridge Precinct - Maximum Security Ward - Foyer"

/area/lv759/indoors/colonial_marshals/prisoners_recreation_area
	name = "NSPA - Ironbridge Precinct - Maximum Security Ward - Recreation Area & Shower Room"

/area/lv759/indoors/colonial_marshals/garage
	name = "NSPA - Ironbridge Precinct - Vehicle Deployment & Maintenace"
	linked_lz = DROPSHIP_LZ2

/area/lv759/indoors/colonial_marshals/armory_foyer
	name = "NSPA - Ironbridge Precinct - Armory Foyer"

/area/lv759/indoors/colonial_marshals/armory
	name = "NSPA - Ironbridge Precinct - Armory"

/area/lv759/indoors/colonial_marshals/armory_firingrange
	name = "NSPA - Ironbridge Precinct - Firing Range"

/area/lv759/indoors/colonial_marshals/armory_evidenceroom
	name = "NSPA - Ironbridge Precinct - Evidence Room"

/area/lv759/indoors/colonial_marshals/office
	name = "NSPA - Ironbridge Precinct - Office"

/area/lv759/indoors/colonial_marshals/reception
	name = "NSPA - Ironbridge Precinct - Reception Office"
	linked_lz = DROPSHIP_LZ2

/area/lv759/indoors/colonial_marshals/hallway_central
	name = "NSPA - Ironbridge Precinct - Central Hallway"
	linked_lz = DROPSHIP_LZ2

/area/lv759/indoors/colonial_marshals/hallway_south
	name = "NSPA - Ironbridge Precinct - South Hallway"

/area/lv759/indoors/colonial_marshals/hallway_reception
	name = "NSPA - Ironbridge Precinct - Reception Hallway"
	linked_lz = DROPSHIP_LZ2

/area/lv759/indoors/colonial_marshals/hallway_north
	name = "NSPA - Ironbridge Precinct - North Hallway"
	linked_lz = DROPSHIP_LZ2

/area/lv759/indoors/colonial_marshals/hallway_north_locker
	name = "NSPA - Ironbridge Precinct - North Hallway - Locker Room"

/area/lv759/indoors/colonial_marshals/holding_cells
	name = "NSPA - Ironbridge Precinct - Holding Cells"
	linked_lz = DROPSHIP_LZ2

/area/lv759/indoors/colonial_marshals/head_office
	name = "NSPA - Ironbridge Precinct - Forensics Office"
	linked_lz = DROPSHIP_LZ2

/area/lv759/indoors/colonial_marshals/north_office
	name = "NSPA - Ironbridge Precinct - North Office"
	linked_lz = DROPSHIP_LZ2

/area/lv759/indoors/colonial_marshals/wardens_office
	name = "NSPA - Ironbridge Precinct - Wardens Office"

/area/lv759/indoors/colonial_marshals/interrogation
	name = "NSPA - Ironbridge Precinct - Interrogation"

/area/lv759/indoors/colonial_marshals/press_room
	name = "NSPA - Ironbridge Precinct - Court Room"
	linked_lz = DROPSHIP_LZ2

/area/lv759/indoors/colonial_marshals/changing_room
	name = "NSPA - Ironbridge Precinct - Changing Room"

/area/lv759/indoors/colonial_marshals/restroom
	name = "NSPA - Ironbridge Precinct - Restroom & Showers"

/area/lv759/indoors/colonial_marshals/south_maintenance
	name = "NSPA - Ironbridge Precinct - Maintenance - South"
	linked_lz = DROPSHIP_LZ2

/area/lv759/indoors/colonial_marshals/north_maintenance
	name = "NSPA - Ironbridge Precinct - Maintenance - North"

/area/lv759/indoors/colonial_marshals/southwest_maintenance
	name = "NSPA - Ironbridge Precinct - Maintenance - Southwest"


// Jack's Surplus

/area/lv759/indoors/jacks_surplus
	name = "Jack's Military Surplus"
	icon_state = "jacks"
	minimap_color = MINIMAP_AREA_COLONY_RESANDCOM
	linked_lz = DROPSHIP_LZ2

//Weyland-Yutani - Resource Recovery Facility

/area/lv759/indoors/recycling_plant
	name = "Weyland-Yutani - Resource Recovery Facility"
	icon_state = "recycling"
	minimap_color = MINIMAP_AREA_COLONY_RESANDCOM
	linked_lz = DROPSHIP_LZ1

/area/lv759/indoors/recycling_plant/garage
	name = "Weyland-Yutani - Resource Recovery Facility - Garage"
	linked_lz = DROPSHIP_LZ1

/area/lv759/indoors/recycling_plant/synthetic_storage
	name = "Synthetic Storage"
	icon_state = "synthetic"
	linked_lz = DROPSHIP_LZ1

/area/lv759/indoors/recycling_plant_office
	name = "Weyland-Yutani - Resource Recovery Facility - Office"
	icon_state = "recycling"
	linked_lz = DROPSHIP_LZ1

/area/lv759/indoors/recycling_plant_waste_disposal_incinerator
	name = "Weyland-Yutani - Resource Recovery Facility - Waste Disposal Incinerating Room"
	icon_state = "recycling"
	linked_lz = DROPSHIP_LZ1

// Restrooms

/area/lv759/indoors/south_public_restroom
	name = "Public Restroom - South"
	icon_state = "restroom"
	minimap_color = MINIMAP_AREA_COLONY_RESANDCOM
	linked_lz = DROPSHIP_LZ2

/area/lv759/indoors/southwest_public_restroom
	name = "Public Restroom - Southwest"
	icon_state = "restroom"
	minimap_color = MINIMAP_AREA_COLONY_RESANDCOM
	linked_lz = DROPSHIP_LZ2

//Nightgold Casino

/area/lv759/indoors/casino
	name = "Night Gold Casino"
	icon_state = "nightgold"
	minimap_color = MINIMAP_AREA_COLONY_RESANDCOM

/area/lv759/indoors/casino/casino_office
	name = "Night Gold Casino - Managers Office"
	icon_state = "nightgold"

/area/lv759/indoors/casino/casino_restroom
	name = "Night Gold Casino - Restroom"
	icon_state = "nightgold"

/area/lv759/indoors/casino/casino_vault
	name = "Night Gold Casino - Vault"
	icon_state = "nightgold"

// Pizza

/area/lv759/indoors/pizzaria
	name = "Pizza Galaxy - Outpost Zeta"
	icon_state = "pizza"
	minimap_color = MINIMAP_AREA_COLONY_RESANDCOM

//T-comms

/area/lv759/indoors/tcomms_northwest
	name = "Telecommunications Substation - West"
	icon_state = "comms_1"
	minimap_color = MINIMAP_AREA_COMMS

// Weymart

/area/lv759/indoors/weymart
	name = "Weymart"
	icon_state = "weymart"
	minimap_color = MINIMAP_AREA_COLONY_RESANDCOM
	ambience_exterior = AMBIENCE_WEYMART

/area/lv759/indoors/weymart/backrooms
	name = "Weymart - Backrooms"
	icon_state = "weymartbackrooms"

/area/lv759/indoors/weymart/maintenance
	name = "Weymart - Maintenance"
	icon_state = "weymartbackrooms"

// WY Security Checkpoints

/area/lv759/indoors/wy_security
	minimap_color = MINIMAP_AREA_COLONY_MARSHALLS

/area/lv759/indoors/wy_security/checkpoint_northeast
	name = "Weyland-Yutani Security Checkpoint - North East"
	icon_state = "security_checkpoint_northeast"
	is_landing_zone = TRUE
	linked_lz = DROPSHIP_LZ1

/area/lv759/indoors/wy_security/checkpoint_east
	name = "Weyland-Yutani Security Checkpoint - East"
	icon_state = "security_checkpoint_east"
	linked_lz = list(DROPSHIP_LZ1, DROPSHIP_LZ2)

/area/lv759/indoors/wy_security/checkpoint_central
	name = "Weyland-Yutani Security Checkpoint - Central"
	icon_state = "security_checkpoint_central"

/area/lv759/indoors/wy_security/checkpoint_west
	name = "Weyland-Yutani Security Checkpoint - West"
	icon_state = "security_checkpoint_west"

/area/lv759/indoors/wy_security/checkpoint_northwest
	name = "Weyland-Yutani Security Checkpoint - North West"
	icon_state = "security_checkpoint_northwest"

// Misc

/area/lv759/indoors/hobosecret
	name = "Hidden Hobo Haven"
	icon_state = "hobo"
	ceiling = CEILING_REINFORCED_METAL
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL
	linked_lz = DROPSHIP_LZ2

// Weyland-Yutani Advanced Bio-Genomic Research Complex

/area/lv759/indoors/wy_research_complex
	name = "Weyland-Yutani - Advanced Bio-Genomic Research Complex"
	icon_state = "wylab"
	minimap_color = MINIMAP_AREA_HYBRISARESEARCH
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS
	unoviable_timer = FALSE
	ceiling_muffle = FALSE

/area/lv759/indoors/wy_research_complex/medical_annex
	name = "Weyland-Yutani - Advanced Bio-Genomic Research Complex - Medical Annex Building"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_LAB
	soundscape_playlist = SCAPE_PL_LV759_INDOORS

/area/lv759/indoors/wy_research_complex/reception
	name = "Weyland-Yutani - Advanced Bio-Genomic Research Complex - Reception & Administration"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_LAB_HALLWAY
	soundscape_playlist = SCAPE_PL_LV759_INDOORS

/area/lv759/indoors/wy_research_complex/cargo
	name = "Weyland-Yutani - Advanced Bio-Genomic Research Complex - Requisitions & Cargo"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_LAB
	soundscape_playlist = SCAPE_PL_LV759_INDOORS

/area/lv759/indoors/wy_research_complex/researchanddevelopment
	name = "Weyland-Yutani - Advanced Bio-Genomic Research Complex - Technology Research & Development Lab"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_LAB
	soundscape_playlist = SCAPE_PL_LV759_INDOORS

/area/lv759/indoors/wy_research_complex/mainlabs
	name = "Weyland-Yutani - Advanced Bio-Genomic Research Complex - Advanced Chemical Testing & Research Lab"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_LAB
	soundscape_playlist = SCAPE_PL_LV759_INDOORS

/area/lv759/indoors/wy_research_complex/xenobiology
	name = "Weyland-Yutani - Advanced Bio-Genomic Research Complex - Advanced Xenobiology Lab"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_LAB_2
	soundscape_playlist = SCAPE_PL_LV759_INDOORS

/area/lv759/indoors/wy_research_complex/weaponresearchlab
	name = "Weyland-Yutani - Advanced Bio-Genomic Research Complex - Advanced Weapon Research Lab"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_LAB
	soundscape_playlist = SCAPE_PL_LV759_INDOORS

/area/lv759/indoors/wy_research_complex/weaponresearchlabtesting
	name = "Weyland-Yutani - Advanced Bio-Genomic Research Complex - Advanced Weapon Research Lab - Weapons Testing Range"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_LAB
	soundscape_playlist = SCAPE_PL_LV759_INDOORS

/area/lv759/indoors/wy_research_complex/xenoarcheology
	name = "Weyland-Yutani - Advanced Bio-Genomic Research Complex - Xenoarcheology Research Lab"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_LAB
	soundscape_playlist = SCAPE_PL_LV759_INDOORS

/area/lv759/indoors/wy_research_complex/vehicledeploymentbay
	name = "Weyland-Yutani - Advanced Bio-Genomic Research Complex - Vehicle Deployment & Maintenance Bay"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_LAB
	soundscape_playlist = SCAPE_PL_LV759_INDOORS

/area/lv759/indoors/wy_research_complex/janitor
	name = "Weyland-Yutani - Advanced Bio-Genomic Research Complex - Janitorial Supplies Storage"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_LAB
	soundscape_playlist = SCAPE_PL_LV759_INDOORS

/area/lv759/indoors/wy_research_complex/cafeteria
	name = "Weyland-Yutani - Advanced Bio-Genomic Research Complex - Cafeteria"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_LAB
	soundscape_playlist = SCAPE_PL_LV759_INDOORS

/area/lv759/indoors/wy_research_complex/cafeteriakitchen
	name = "Weyland-Yutani - Advanced Bio-Genomic Research Complex - Cafeteria - Kitchen"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_LAB
	soundscape_playlist = SCAPE_PL_LV759_INDOORS

/area/lv759/indoors/wy_research_complex/dormsfoyer
	name = "Weyland-Yutani - Advanced Bio-Genomic Research Complex - Dorms Foyer"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_LAB
	soundscape_playlist = SCAPE_PL_LV759_INDOORS

/area/lv759/indoors/wy_research_complex/dormsbedroom
	name = "Weyland-Yutani - Advanced Bio-Genomic Research Complex - Dorms"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_LAB
	soundscape_playlist = SCAPE_PL_LV759_INDOORS

/area/lv759/indoors/wy_research_complex/securitycommand
	name = "Weyland-Yutani - Advanced Bio-Genomic Research Complex - Security Command Center & Deployment"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_LAB
	soundscape_playlist = SCAPE_PL_LV759_INDOORS

/area/lv759/indoors/wy_research_complex/securityarmory
	name = "Weyland-Yutani - Advanced Bio-Genomic Research Complex - Armory"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_LAB
	soundscape_playlist = SCAPE_PL_LV759_INDOORS

/area/lv759/indoors/wy_research_complex/hangarbay
	name = "Weyland-Yutani - Advanced Bio-Genomic Research Complex - Hangar Bay"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_LAB_HALLWAY
	soundscape_playlist = SCAPE_PL_LV759_INDOORS

/area/lv759/indoors/wy_research_complex/hangarbayshuttle
	name = "Weyland-Yutani - Advanced Bio-Genomic Research Complex - Hangar Bay - Weyland-Yutani PMC ERT Shuttle"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_LAB
	soundscape_playlist = SCAPE_PL_LV759_INDOORS
	minimap_color = MINIMAP_AREA_COLONY
	requires_power = FALSE

/area/lv759/indoors/wy_research_complex/hallwaynorth
	name = "Weyland-Yutani - Advanced Bio-Genomic Research Complex - North Hallway"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_LAB_HALLWAY
	soundscape_playlist = SCAPE_PL_LV759_INDOORS

/area/lv759/indoors/wy_research_complex/hallwaynorthexit
	name = "Weyland-Yutani - Advanced Bio-Genomic Research Complex - North Hallway - Personnel Exit East"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_LAB_HALLWAY
	soundscape_playlist = SCAPE_PL_LV759_INDOORS

/area/lv759/indoors/wy_research_complex/hallwayeast
	name = "Weyland-Yutani - Advanced Bio-Genomic Research Complex - Hallway East"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_LAB_HALLWAY
	soundscape_playlist = SCAPE_PL_LV759_INDOORS

/area/lv759/indoors/wy_research_complex/hallwaycentral
	name = "Weyland-Yutani - Advanced Bio-Genomic Research Complex - Central Hallway"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_LAB_HALLWAY
	soundscape_playlist = SCAPE_PL_LV759_INDOORS

/area/lv759/indoors/wy_research_complex/hallwaysouthwest
	name = "Weyland-Yutani - Advanced Bio-Genomic Research Complex - South West Hallway"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_LAB_HALLWAY
	soundscape_playlist = SCAPE_PL_LV759_INDOORS

/area/lv759/indoors/wy_research_complex/hallwaysoutheast
	name = "Weyland-Yutani - Advanced Bio-Genomic Research Complex - South East Hallway"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_LAB_HALLWAY
	soundscape_playlist = SCAPE_PL_LV759_INDOORS

/area/lv759/indoors/wy_research_complex/southeastexit
	name = "Weyland-Yutani - Advanced Bio-Genomic Research Complex - South East Maintenace & Emergency Exit"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_LAB
	soundscape_playlist = SCAPE_PL_LV759_INDOORS

/area/lv759/indoors/wy_research_complex/changingroom
	name = "Weyland-Yutani - Advanced Bio-Genomic Research Complex - Locker Room"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_LAB
	soundscape_playlist = SCAPE_PL_LV759_INDOORS

/area/lv759/indoors/wy_research_complex/head_research_office
	name = "Weyland-Yutani - Advanced Bio-Genomic Research Complex - Head of Research's Office"
	icon_state = "wylab"
	ambience_exterior = AMBIENCE_LAB
	soundscape_playlist = SCAPE_PL_LV759_INDOORS
