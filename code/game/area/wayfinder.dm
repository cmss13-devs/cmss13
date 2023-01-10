//wayfinder AREAS--------------------------------------//
// Fore = SOUTH  | Aft = NORTH //
// Port = EAST | Starboard = WEST //
/area/wayfinder
	icon = 'icons/turf/area_almayer.dmi'
	//ambience = list('sound/ambience/shipambience.ogg')
	icon_state = "almayer"
	ceiling = CEILING_METAL
	powernet_name = "almayer"
	sound_environment = SOUND_ENVIRONMENT_ROOM
	soundscape_interval = 30
	//soundscape_playlist = list('sound/effects/xylophone1.ogg', 'sound/effects/xylophone2.ogg', 'sound/effects/xylophone3.ogg')
	ambience_exterior = AMBIENCE_ALMAYER
	ceiling_muffle = FALSE

/area/shuttle/wayfinder/elevator_maintenance/upperdeck
	name = "\improper Maintenance Elevator"
	icon_state = "shuttle"
	fake_zlevel = 1

/area/shuttle/wayfinder/elevator_maintenance/lowerdeck
	name = "\improper Maintenance Elevator"
	icon_state = "shuttle"
	fake_zlevel = 2

/area/shuttle/wayfinder/elevator_hangar/lowerdeck
	name = "\improper Hangar Elevator"
	icon_state = "shuttle"
	fake_zlevel = 2 // lowerdeck

/area/shuttle/wayfinder/elevator_hangar/underdeck
	name = "\improper Hangar Elevator"
	icon_state = "shuttle"
	fake_zlevel = 3

/obj/structure/machinery/computer/shuttle_control/wayfinder/hangar
	name = "Elevator Console"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "supply"
	unslashable = TRUE
	unacidable = TRUE
	exproof = 1
	density = 1
	req_access = null
	shuttle_tag = "Hangar"

/obj/structure/machinery/computer/shuttle_control/wayfinder/maintenance
	name = "Elevator Console"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "shuttle"
	unslashable = TRUE
	unacidable = TRUE
	exproof = 1
	density = 1
	req_access = null
	shuttle_tag = "Maintenance"

/area/wayfinder/command/cic
	name = "\improper Combat Information Center"
	icon_state = "cic"
	fake_zlevel = 1 // upperdeck
	soundscape_playlist = SCAPE_PL_CIC
	soundscape_interval = 20
	flags_area = AREA_NOTUNNEL

/area/wayfinder/command/officer_prep
	name = "\improper Officer Preperation"
	icon_state = "airoom"
	fake_zlevel = 3 // upperdeck

/area/wayfinder/command/cichallway
	name = "\improper Secure Command Hallway"
	icon_state = "airoom"
	fake_zlevel = 1 // upperdeck

/area/wayfinder/command/airoom
	name = "\improper AI Core"
	icon_state = "airoom"
	fake_zlevel = 1 // upperdeck
	soundscape_playlist = SCAPE_PL_ARES
	soundscape_interval = 8
	flags_area = AREA_NOTUNNEL

/area/wayfinder/command/securestorage
	name = "\improper Secure Storage"
	icon_state = "corporatespace"
	fake_zlevel = 1 // upperdeck

/area/wayfinder/command/computerlab
	name = "\improper Computer Lab"
	icon_state = "ceroom"
	fake_zlevel = 1 // upperdeck

/area/wayfinder/command/telecomms
	name = "\improper Telecommunications"
	icon_state = "tcomms"
	fake_zlevel = 1 // upperdeck
	flags_area = AREA_NOTUNNEL

/area/wayfinder/command/self_destruct
	name = "\improper Self-Destruct Core Room"
	icon_state = "selfdestruct"
	fake_zlevel = 3
	flags_area = AREA_NOTUNNEL

/area/wayfinder/command/corporateliason
	name = "\improper Corporate Liaison Office"
	icon_state = "corporatespace"
	fake_zlevel = 2

/area/wayfinder/engineering/upper_engineering
	name = "\improper Upper Engineering"
	icon_state = "upperengineering"
	fake_zlevel = 1 // upperdeck

/area/wayfinder/engineering/upper_engineering/notunnel
	flags_area = AREA_NOTUNNEL

/area/wayfinder/engineering/dorms
	name = "\improper Engineering Dorms"
	fake_zlevel = 2

/area/wayfinder/engineering/ce_room
	name = "\improper Chief Engineer Office"
	icon_state = "ceroom"
	fake_zlevel = 1 // upperdeck

/area/wayfinder/engineering/lower_engine_monitoring
	name = "\improper Engine Reactor Monitoring"
	icon_state = "lowermonitoring"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/engineering/lower_engineering
	name = "\improper Engineering Lower"
	icon_state = "lowerengineering"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/engineering/engineering_workshop
	name = "\improper Engineering Workshop"
	icon_state = "workshop"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/engineering/engineering_workshop/hangar
	name = "\improper Ordnance workshop"

/area/wayfinder/engineering/engine_core
	name = "\improper Engine Reactor Core Room"
	icon_state = "coreroom"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ENG
	soundscape_interval = 15

/area/wayfinder/engineering/starboard_atmos
	name = "\improper Atmospherics Starboard"
	icon_state = "starboardatmos"
	fake_zlevel = 1 // upperdeck

/area/wayfinder/engineering/port_atmos
	name = "\improper Atmospherics Port"
	icon_state = "portatmos"
	fake_zlevel = 1 // upperdeck

/area/wayfinder/engineering/laundry
	name = "\improper Laundry Room"
	icon_state = "laundry"
	fake_zlevel = 1 // upperdeck

/area/wayfinder/shipboard/navigation
	name = "\improper Astronavigational Deck"
	icon_state = "astronavigation"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/shipboard/starboard_missiles
	name = "\improper Missile Tubes Starboard"
	icon_state = "starboardmissile"
	fake_zlevel = 1 // upperdeck

/area/wayfinder/shipboard/port_missiles
	name = "\improper Missile Tubes Port"
	icon_state = "portmissile"
	fake_zlevel = 1 // upperdeck

/area/wayfinder/shipboard/weapon_room
	name = "\improper Weapon Control Room"
	icon_state = "weaponroom"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/shipboard/weapon_room/notunnel
	flags_area = AREA_NOTUNNEL

/area/wayfinder/shipboard/starboard_point_defense
	name = "\improper Point Defense Starboard"
	icon_state = "starboardpd"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/shipboard/port_point_defense
	name = "\improper Point Defense Port"
	icon_state = "portpd"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/shipboard/brig
	name = "\improper Brig"
	icon_state = "brig"
	fake_zlevel = 1 //upperdeck

/area/wayfinder/shipboard/brig/lobby
	name = "\improper Brig Lobby"
	icon_state = "brig"

/area/wayfinder/shipboard/brig/armory
	name = "\improper Brig Armory"
	icon_state = "brig"

/area/wayfinder/shipboard/brig/main_office
	name = "\improper Brig Main Office"
	icon_state = "brig"

/area/wayfinder/shipboard/brig/perma
	name = "\improper Brig Perma Cells"
	icon_state = "brig"

/area/wayfinder/shipboard/brig/cryo
	name = "\improper Brig Cryo Pods"
	icon_state = "brig"

/area/wayfinder/shipboard/brig/surgery
	name = "\improper Brig Surgery"
	icon_state = "brig"

/area/wayfinder/shipboard/brig/general_equipment
	name = "\improper Brig General Equipment"
	icon_state = "brig"

/area/wayfinder/shipboard/brig/evidence_storage
	name = "\improper Brig Evidence Storage"
	icon_state = "brig"

/area/wayfinder/shipboard/brig/execution
	name = "\improper Brig Execution Room"
	icon_state = "brig"

/area/wayfinder/shipboard/brig/dress
	name = "\improper CIC Dress Uniform Room"
	icon_state = "brig"

/area/wayfinder/shipboard/brig/processing
	name = "\improper Brig Processing and Holding"
	icon_state = "brig"

/area/wayfinder/shipboard/brig/cells
	name = "\improper Brig Cells"
	icon_state = "brigcells"

/area/wayfinder/shipboard/brig/chief_mp_office
	name = "\improper Brig Chief MP Office"
	icon_state = "chiefmpoffice"

/area/wayfinder/shipboard/brig/dorms
	name = "\improper Brig Dorms"
	icon_state = "chiefmpoffice"

/area/wayfinder/shipboard/sea_office
	name = "\improper Senior Enlisted Advisor Office"
	icon_state = "chiefmpoffice"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/shipboard/firing_range_north
	name = "\improper Starboard Firing Range"
	icon_state = "firingrange"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/shipboard/firing_range_south
	name = "\improper Port Firing Range"
	icon_state = "firingrange"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/shipboard/sensors
	name = "\improper Sensor Room"
	icon_state = "sensor"

/area/wayfinder/hallways/hangar
	name = "\improper Hangar"
	icon_state = "hangar"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_HANGAR
	soundscape_interval = 35

/area/wayfinder/hallways/vehiclehangar
	name = "\improper Vehicle Storage"
	icon_state = "exoarmor"
	fake_zlevel = 2

/area/wayfinder/hallways/lower_overlook
	name = "\improper Lower Fore Hallway"
	icon_state = "hangar"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_HANGAR
	soundscape_interval = 35

/area/wayfinder/living/tankerbunks
	name = "\improper Vehicle Crew Bunks"
	icon_state = "livingspace"
	fake_zlevel = 3

/area/wayfinder/squads/tankdeliveries
	name = "\improper Vehicle ASRS"
	icon_state = "req"
	fake_zlevel = 2

/area/wayfinder/hallways/exoarmor
	name = "\improper Vehicle Armor Storage"
	icon_state = "exoarmor"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/hallways/repair_bay
	name = "\improper Deployment Workshop"
	icon_state = "dropshiprepair"
	fake_zlevel = 2 // MidDeck

/area/wayfinder/hallways/mission_planner
	name = "\improper Dropship Central Computer Room"
	icon_state = "missionplanner"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/hallways/starboard_umbilical
	name = "\improper Umbilical Starboard"
	icon_state = "starboardumbilical"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/hallways/port_umbilical
	name = "\improper Umbilical Port"
	icon_state = "portumbilical"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/hallways/upper_aft_hallway
	name = "\improper Upperdeck Hallway Aft"
	icon_state = "aft"
	fake_zlevel = 1 // upperdeck

/area/wayfinder/hallways/upper_port_hallway
	name = "\improper Upperdeck Port Hallway"
	icon_state = "port"
	fake_zlevel = 1 // upperdeck

/area/wayfinder/hallways/upper_starboard_hallway
	name = "\improper Upperdeck Starboard Hallway"
	icon_state = "starboard"
	fake_zlevel = 1 // upperdeck

/area/wayfinder/hallways/midship_aft_hallway
	name = "\improper Middeck Hallway Aft"
	icon_state = "stern"
	fake_zlevel = 2 // middeck

/area/wayfinder/hallways/midship_port_hallway
	name = "\improper Middeck Port Hallway"
	icon_state = "stern"
	fake_zlevel = 2 // middeck

/area/wayfinder/hallways/midship_starboard_hallway
	name = "\improper Middeck Starboard Hallway"
	icon_state = "starboard"
	fake_zlevel = 2 // middeck

/area/wayfinder/hallways/lowerdeck_starboard_hallway
	name = "\improper Lowerdeck Starboard Hallway"
	icon_state = "starboard"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/hallways/lowerdeck_port_hallway
	name = "\improper Lowerdeck Port Hallway"
	icon_state = "port"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/hallways/starboard_escape_hallway
	name = "\improper Starboard Escape Pods"
	icon_state = "starboard"
	fake_zlevel = 2

/area/wayfinder/hallways/port_escape_hallway
	name = "\improper Port Escape Pods"
	icon_state = "port"
	fake_zlevel = 2

/area/wayfinder/stair_clone
	name = "\improper Stairs"
	icon_state = "stairs_lowerdeck"
	fake_zlevel = 2 // lowerdeck
	resin_construction_allowed = FALSE

/area/wayfinder/stair_clone/upper
	icon_state = "stairs_upperdeck"
	fake_zlevel = 1 // upperdeck

/area/wayfinder/hull/upper_hull
	name = "\improper Hull Upper"
	icon_state = "upperhull"
	fake_zlevel = 1 // upperdeck

/area/wayfinder/hull/upper_hull/u_f_s
	name = "\improper Upper Fore-Starboard Hull"

/area/wayfinder/hull/upper_hull/u_m_s
	name = "\improper Upper Midship-Starboard Hull"

/area/wayfinder/hull/upper_hull/u_a_s
	name = "\improper Upper Aft-Starboard Hull"

/area/wayfinder/hull/upper_hull/u_f_p
	name = "\improper Upper Fore-Port Hull"

/area/wayfinder/hull/upper_hull/u_m_p
	name = "\improper Upper Midship-Port Hull"

/area/wayfinder/hull/upper_hull/u_a_p
	name = "\improper Upper Aft-Port Hull"

/area/wayfinder/hull/mid_hull
	name = "\improper Hull Lower"
	icon_state = "lowerhull"
	fake_zlevel = 2 // midship

/area/wayfinder/hull/mid_hull/l_f_s
	name = "\improper Lower Fore-Starboard Hull"

/area/wayfinder/hull/mid_hull/l_m_s
	name = "\improper Lower Midship-Starboard Hull"

/area/wayfinder/hull/mid_hull/l_a_s
	name = "\improper Lower Aft-Starboard Hull"

/area/wayfinder/hull/mid_hull/l_f_p
	name = "\improper Lower Fore-Port Hull"

/area/wayfinder/hull/mid_hull/l_m_p
	name = "\improper Lower Midship-Port Hull"

/area/wayfinder/hull/mid_hull/l_a_p
	name = "\improper Lower Aft-Port Hull"

/area/wayfinder/hull/lower_hull
	name = "\improper Hull Lower"
	icon_state = "lowerhull"
	fake_zlevel = 3 // lowerdeck

/area/wayfinder/hull/lower_hull/l_f_s
	name = "\improper Lower Fore-Starboard Hull"

/area/wayfinder/hull/lower_hull/l_m_s
	name = "\improper Lower Midship-Starboard Hull"

/area/wayfinder/hull/lower_hull/l_a_s
	name = "\improper Lower Aft-Starboard Hull"

/area/wayfinder/hull/lower_hull/l_f_p
	name = "\improper Lower Fore-Port Hull"

/area/wayfinder/hull/lower_hull/l_m_p
	name = "\improper Lower Midship-Port Hull"

/area/wayfinder/hull/lower_hull/l_a_p
	name = "\improper Lower Aft-Port Hull"

/area/wayfinder/hull/starboard_warehouse
	name = "\improper Starboard Warehouse"

/area/wayfinder/hull/starboard_warehouse_mini
	name = "\improper Secondary Starboard Warehouse"
/area/wayfinder/hull/port_warehouse
	name = "\improper Port Warehouse"

/area/wayfinder/hull/port_warehouse_mini
	name = "\improper Secondary Port Warehouse"
/area/wayfinder/living/cryo_cells
	name = "\improper Cryo Cells"
	icon_state = "cryo"
	fake_zlevel = 2 // middeck

/area/wayfinder/living/cryo_cell_showers
	name = "\improper Showers"
	icon_state = "cryo"
	fake_zlevel = 2 // middeck

/area/wayfinder/living/briefing
	name = "\improper Briefing Area"
	icon_state = "briefing"
	fake_zlevel = 1

/area/wayfinder/living/port_emb
	name = "\improper Extended Mission Bunks"
	icon_state = "portemb"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/living/starboard_emb
	name = "\improper Extended Mission Bunks"
	icon_state = "starboardemb"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/living/port_garden
	name = "\improper Garden"
	icon_state = "portemb"
	fake_zlevel = 1 // upperdeck

/area/wayfinder/living/starboard_garden
	name = "\improper Garden"
	icon_state = "starboardemb"
	fake_zlevel = 1 // upperdeck

/area/wayfinder/living/basketball
	name = "\improper Basketball Court"
	icon_state = "basketball"
	fake_zlevel = 1 // upperdeck

/area/wayfinder/living/grunt_rnr
	name = "\improper Lounge"
	icon_state = "gruntrnr"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/living/mess_hall
	name = "\improper Mess Hall"
	icon_state = "gruntrnr"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/living/officer_rnr
	name = "\improper Officer's Lounge"
	icon_state = "officerrnr"
	fake_zlevel = 1 // upperdeck

/area/wayfinder/living/officer_study
	name = "\improper Officer's Study"
	icon_state = "officerstudy"
	fake_zlevel = 1 // upperdeck

/area/wayfinder/living/cafeteria_port
	name = "\improper Cafeteria Port"
	icon_state = "food"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/living/cafeteria_starboard
	name = "\improper Cafeteria Starboard"
	icon_state = "food"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/living/gym
	name = "\improper Gym"
	icon_state = "officerrnr"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/living/cafeteria_officer
	name = "\improper Officer Cafeteria"
	icon_state = "food"
	fake_zlevel = 1 // upperdeck

/area/wayfinder/living/offices
	name = "\improper Conference Office"
	icon_state = "briefing"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/living/offices/flight
	name = "\improper Flight Office"

/area/wayfinder/living/captain_mess
	name = "\improper Captain's Mess"
	icon_state = "briefing"
	fake_zlevel = 1 // upperdeck

/area/wayfinder/living/pilotbunks
	name = "\improper Pilot's Bunks"
	icon_state = "livingspace"
	fake_zlevel = 1

/area/wayfinder/living/bridgebunks
	name = "\improper Staff Officer Bunks"
	icon_state = "livingspace"
	fake_zlevel = 1 // upperdeck

/area/wayfinder/living/commandbunks
	name = "\improper Commanding Officer's Bunk"
	icon_state = "livingspace"
	fake_zlevel = 1 // upperdeck

/area/wayfinder/living/synthcloset
	name = "\improper Synthetic Storage Closet"
	icon_state = "livingspace"
	fake_zlevel = 1 // upperdeck

/area/wayfinder/living/numbertwobunks
	name = "\improper Executive Officer's Bunk"
	icon_state = "livingspace"
	fake_zlevel = 1 // upperdeck

/area/wayfinder/living/chapel
	name = "\improper wayfinder Chapel"
	icon_state = "officerrnr"
	fake_zlevel = 1 // upperdeck


/area/wayfinder/medical
	icon_state = "medical"

/area/wayfinder/medical/cmo
	icon_state = "Chief Medical Officer Office"


/area/wayfinder/medical/fore_medical_lobby
	name = "\improper Medical Fore Lobby"
	icon_state = "medical"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 50

/area/wayfinder/medical/aft_medical_lobby
	name = "\improper Medical Aft Lobby"
	icon_state = "medical"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 50

/area/wayfinder/medical/dorms
	name = "\improper Medical Dorms"

/area/wayfinder/medical/port_hallway
	name = "\improper Medical Port Hallway"

/area/wayfinder/medical/starboard_hallway
	name = "\improper Medical Starboard Hallway"

/area/wayfinder/medical/morgue
	name = "\improper Morgue"
	icon_state = "operating"
	fake_zlevel = 2 // middeck

/area/wayfinder/medical/operating_room_one
	name = "\improper Medical Operating Room 1"
	icon_state = "operating"
	fake_zlevel = 2 // middeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 50

/area/wayfinder/medical/operating_room_two
	name = "\improper Medical Operating Room 2"
	icon_state = "operating"
	fake_zlevel = 2 // middeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 50

/area/wayfinder/medical/operating_room_three
	name = "\improper Medical Operating Room 3"
	icon_state = "operating"
	fake_zlevel = 2 // middeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 50

/area/wayfinder/medical/operating_room_four
	name = "\improper Medical Operating Room 4"
	icon_state = "operating"
	fake_zlevel = 2 // middeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 50

/area/wayfinder/medical/medical_science
	name = "\improper Medical Research laboratories"
	icon_state = "science"
	fake_zlevel = 1 // upperdeck

/area/wayfinder/medical/hydroponics
	name = "\improper Medical Research hydroponics"
	icon_state = "science"
	fake_zlevel = 1 // upperdeck

/area/wayfinder/medical/testlab
	name = "\improper Medical Research workshop"
	icon_state = "science"
	fake_zlevel = 1 // upperdeck

/area/wayfinder/medical/containment
	name = "\improper Medical Research containment"
	icon_state = "science"
	fake_zlevel = 1 // upperdeck

/area/wayfinder/medical/containment/cell
	name = "\improper Medical Research containment cells"
	icon_state = "science"
	fake_zlevel = 1 // upperdeck
	flags_area = AREA_AVOID_BIOSCAN|AREA_NOTUNNEL|AREA_CONTAINMENT

/area/wayfinder/medical/containment/cell/cl
	name = "\improper Containment"

/area/wayfinder/medical/chemistry
	name = "\improper Medical Chemical laboratory"
	icon_state = "chemistry"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/medical/lockerroom
	name = "\improper Medical Locker Room"
	icon_state = "science"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/medical/cryo_tubes
	name = "\improper Medical Cryogenics Tubes"
	icon_state = "medical"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 50

/area/wayfinder/medical/lower_medical_medbay
	name = "\improper Medical Lower Medbay"
	icon_state = "medical"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 50

/area/wayfinder/squads/alpha
	name = "\improper Squad Alpha Preparation"
	icon_state = "alpha"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/squads/bravo
	name = "\improper Squad Bravo Preparation"
	icon_state = "bravo"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/squads/charlie
	name = "\improper Squad Charlie Preparation"
	icon_state = "charlie"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/squads/delta
	name = "\improper Squad Delta Preparation"
	icon_state = "delta"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/squads/alpha_bravo_shared
	name = "\improper Alpha Bravo Equipment Preparation"
	icon_state = "ab_shared"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/squads/charlie_delta_shared
	name = "\improper Charlie Delta Equipment Preparation"
	icon_state = "cd_shared"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/squads/req
	name = "\improper Requisitions"
	icon_state = "req"
	fake_zlevel = 2 // lowerdeck

/area/wayfinder/powered //for objects not intended to lose power
	name = "\improper Powered"
	icon_state = "selfdestruct"
	requires_power = 0

/area/wayfinder/powered/agent
	name = "\improper Unknown Area"
	icon_state = "selfdestruct"
	fake_zlevel = 2 // lowerdeck
	flags_area = AREA_AVOID_BIOSCAN|AREA_NOTUNNEL

/area/wayfinder/engineering/airmix
	icon_state = "selfdestruct"
	requires_power = 0
	flags_area = AREA_NOTUNNEL

/area/wayfinder/lifeboat_pumps
	name = "Lifeboat Fuel Pumps"
	icon_state = "lifeboat_pump"
	requires_power = 1
	fake_zlevel = 1

/area/wayfinder/lifeboat_pumps/north1
	name = "North West Lifeboat Fuel Pump"

/area/wayfinder/lifeboat_pumps/north2
	name = "North East Lifeboat Fuel Pump"

/area/wayfinder/lifeboat_pumps/south1
	name = "South West Lifeboat Fuel Pump"

/area/wayfinder/lifeboat_pumps/south2
	name = "South East Lifeboat Fuel Pump"

/area/wayfinder/command/lifeboat
	name = "\improper Lifeboat Docking Port"
	icon_state = "selfdestruct"
	fake_zlevel = 1 // upperdeck

/area/space/wayfinder/lifeboat_dock
	name = "\improper Lifeboat Docking Port"
	icon = 'icons/turf/area_almayer.dmi'
	icon_state = "lifeboat"
	fake_zlevel = 1 // upperdeck
	flags_atom = AREA_NOTUNNEL

/area/wayfinder/evacuation
	icon = 'icons/turf/areas.dmi'
	icon_state = "shuttle2"
	requires_power = 0
	flags_area = AREA_NOTUNNEL

//Placeholder.
/area/wayfinder/evacuation/pod1
/area/wayfinder/evacuation/pod2
/area/wayfinder/evacuation/pod3
/area/wayfinder/evacuation/pod4
/area/wayfinder/evacuation/pod5
/area/wayfinder/evacuation/pod6
/area/wayfinder/evacuation/pod7
/area/wayfinder/evacuation/pod8
/area/wayfinder/evacuation/pod9
/area/wayfinder/evacuation/pod10
/area/wayfinder/evacuation/pod11
/area/wayfinder/evacuation/pod12
/area/wayfinder/evacuation/pod13
/area/wayfinder/evacuation/pod14
/area/wayfinder/evacuation/pod15
/area/wayfinder/evacuation/pod16
/area/wayfinder/evacuation/pod17
/area/wayfinder/evacuation/pod18
