//westerneye AREAS--------------------------------------//
// Fore = SOUTH  | Aft = NORTH //
// Port = EAST | Starboard = WEST //
/area/westerneye
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

/area/shuttle/westerneye/elevator_maintenance/upperdeck
	name = "\improper Maintenance Elevator"
	icon_state = "shuttle"
	fake_zlevel = 1

/area/shuttle/westerneye/elevator_maintenance/lowerdeck
	name = "\improper Maintenance Elevator"
	icon_state = "shuttle"
	fake_zlevel = 2

/area/shuttle/westerneye/elevator_hangar/lowerdeck
	name = "\improper Hangar Elevator"
	icon_state = "shuttle"
	fake_zlevel = 2 // lowerdeck

/area/shuttle/westerneye/elevator_hangar/underdeck
	name = "\improper Hangar Elevator"
	icon_state = "shuttle"
	fake_zlevel = 3

/obj/structure/machinery/computer/shuttle_control/westerneye/hangar
	name = "Elevator Console"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "supply"
	unslashable = TRUE
	unacidable = TRUE
	exproof = 1
	density = 1
	req_access = null
	shuttle_tag = "Hangar"

/obj/structure/machinery/computer/shuttle_control/westerneye/maintenance
	name = "Elevator Console"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "shuttle"
	unslashable = TRUE
	unacidable = TRUE
	exproof = 1
	density = 1
	req_access = null
	shuttle_tag = "Maintenance"

/area/westerneye/command/docking_coordination
	name = "\improper Combat Information Center"
	icon_state = "cic"
	fake_zlevel = 3 // lowerdeck

/area/westerneye/command/cic
	name = "\improper Combat Information Center"
	icon_state = "cic"
	fake_zlevel = 1 // upperdeck
	soundscape_playlist = SCAPE_PL_CIC
	soundscape_interval = 20
	flags_area = AREA_NOTUNNEL

/area/westerneye/command/officer_prep
	name = "\improper Officer Preperation"
	icon_state = "airoom"
	fake_zlevel = 3 // upperdeck

/area/westerneye/command/cichallway
	name = "\improper Secure Command Hallway"
	icon_state = "airoom"
	fake_zlevel = 1 // upperdeck

/area/westerneye/command/airoom
	name = "\improper AI Core"
	icon_state = "airoom"
	fake_zlevel = 1 // upperdeck
	soundscape_playlist = SCAPE_PL_ARES
	soundscape_interval = 8
	flags_area = AREA_NOTUNNEL

/area/westerneye/command/securestorage
	name = "\improper Secure Storage"
	icon_state = "corporatespace"
	fake_zlevel = 1 // upperdeck

/area/westerneye/command/computerlab
	name = "\improper Computer Lab"
	icon_state = "ceroom"
	fake_zlevel = 1 // upperdeck

/area/westerneye/command/telecomms
	name = "\improper Telecommunications"
	icon_state = "tcomms"
	fake_zlevel = 1 // upperdeck
	flags_area = AREA_NOTUNNEL

/area/westerneye/command/self_destruct
	name = "\improper Self-Destruct Core Room"
	icon_state = "selfdestruct"
	fake_zlevel = 3
	flags_area = AREA_NOTUNNEL

/area/westerneye/command/corporateliason
	name = "\improper Corporate Liaison Office"
	icon_state = "corporatespace"
	fake_zlevel = 2

/area/westerneye/engineering/upper_engineering
	name = "\improper Upper Engineering"
	icon_state = "upperengineering"
	fake_zlevel = 1 // upperdeck

/area/westerneye/engineering/upper_engineering/notunnel
	flags_area = AREA_NOTUNNEL

/area/westerneye/engineering/dorms_port
	name = "\improper Port Engineering Dorms"
	fake_zlevel = 2

/area/westerneye/engineering/dorms_starboard
	name = "\improper Starboard Engineering Dorms"
	fake_zlevel = 2

/area/westerneye/engineering/ce_room
	name = "\improper Chief Engineer Office"
	icon_state = "ceroom"
	fake_zlevel = 1 // upperdeck

/area/westerneye/engineering/lower_engine_monitoring
	name = "\improper Engine Reactor Monitoring"
	icon_state = "lowermonitoring"
	fake_zlevel = 2 // lowerdeck

/area/westerneye/engineering/lower_engineering
	name = "\improper Engineering Lower"
	icon_state = "lowerengineering"
	fake_zlevel = 2 // lowerdeck

/area/westerneye/engineering/engineering_workshop
	name = "\improper Engineering Workshop"
	icon_state = "workshop"
	fake_zlevel = 2 // lowerdeck

/area/westerneye/engineering/engineering_workshop/hangar
	name = "\improper Ordnance workshop"

/area/westerneye/engineering/engine_core
	name = "\improper Engine Reactor Core Room"
	icon_state = "coreroom"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ENG
	soundscape_interval = 15

/area/westerneye/engineering/starboard_atmos
	name = "\improper Atmospherics Starboard"
	icon_state = "starboardatmos"
	fake_zlevel = 1 // upperdeck

/area/westerneye/engineering/port_atmos
	name = "\improper Atmospherics Port"
	icon_state = "portatmos"
	fake_zlevel = 1 // upperdeck

/area/westerneye/engineering/laundry
	name = "\improper Laundry Room"
	icon_state = "laundry"
	fake_zlevel = 1 // upperdeck

/area/westerneye/shipboard/navigation
	name = "\improper Astronavigational Deck"
	icon_state = "astronavigation"
	fake_zlevel = 2 // lowerdeck

/area/westerneye/shipboard/starboard_missiles
	name = "\improper Missile Tubes Starboard"
	icon_state = "starboardmissile"
	fake_zlevel = 1 // upperdeck

/area/westerneye/shipboard/port_missiles
	name = "\improper Missile Tubes Port"
	icon_state = "portmissile"
	fake_zlevel = 1 // upperdeck

/area/westerneye/shipboard/weapon_room
	name = "\improper Weapon Control Room"
	icon_state = "weaponroom"
	fake_zlevel = 2 // lowerdeck

/area/westerneye/shipboard/weapon_room/notunnel
	flags_area = AREA_NOTUNNEL

/area/westerneye/shipboard/starboard_point_defense
	name = "\improper Point Defense Starboard"
	icon_state = "starboardpd"
	fake_zlevel = 2 // lowerdeck

/area/westerneye/shipboard/port_point_defense
	name = "\improper Point Defense Port"
	icon_state = "portpd"
	fake_zlevel = 2 // lowerdeck

/area/westerneye/shipboard/brig
	name = "\improper Brig"
	icon_state = "brig"
	fake_zlevel = 1 //upperdeck

/area/westerneye/shipboard/brig/lobby
	name = "\improper Brig Lobby"
	icon_state = "brig"

/area/westerneye/shipboard/brig/armory
	name = "\improper Brig Armory"
	icon_state = "brig"

/area/westerneye/shipboard/brig/main_office
	name = "\improper Brig Main Office"
	icon_state = "brig"

/area/westerneye/shipboard/brig/perma
	name = "\improper Brig Perma Cells"
	icon_state = "brig"

/area/westerneye/shipboard/brig/cryo
	name = "\improper Brig Cryo Pods"
	icon_state = "brig"

/area/westerneye/shipboard/brig/surgery
	name = "\improper Brig Surgery"
	icon_state = "brig"

/area/westerneye/shipboard/brig/general_equipment
	name = "\improper Brig General Equipment"
	icon_state = "brig"

/area/westerneye/shipboard/brig/evidence_storage
	name = "\improper Brig Evidence Storage"
	icon_state = "brig"

/area/westerneye/shipboard/brig/execution
	name = "\improper Brig Execution Room"
	icon_state = "brig"

/area/westerneye/shipboard/brig/dress
	name = "\improper CIC Dress Uniform Room"
	icon_state = "brig"

/area/westerneye/shipboard/brig/processing
	name = "\improper Brig Processing and Holding"
	icon_state = "brig"

/area/westerneye/shipboard/brig/cells
	name = "\improper Brig Cells"
	icon_state = "brigcells"

/area/westerneye/shipboard/brig/chief_mp_office
	name = "\improper Brig Chief MP Office"
	icon_state = "chiefmpoffice"

/area/westerneye/shipboard/brig/dorms
	name = "\improper Brig Dorms"
	icon_state = "chiefmpoffice"

/area/westerneye/shipboard/sea_office
	name = "\improper Senior Enlisted Advisor Office"
	icon_state = "chiefmpoffice"
	fake_zlevel = 2 // lowerdeck

/area/westerneye/shipboard/firing_range_north
	name = "\improper Starboard Firing Range"
	icon_state = "firingrange"
	fake_zlevel = 2 // lowerdeck

/area/westerneye/shipboard/firing_range_south
	name = "\improper Port Firing Range"
	icon_state = "firingrange"
	fake_zlevel = 2 // lowerdeck

/area/westerneye/shipboard/sensors
	name = "\improper Sensor Room"
	icon_state = "sensor"

/area/westerneye/hallways/hangar
	name = "\improper Hangar"
	icon_state = "hangar"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_HANGAR
	soundscape_interval = 35

/area/westerneye/hallways/vehiclehangar
	name = "\improper Vehicle Storage"
	icon_state = "exoarmor"
	fake_zlevel = 2

/area/westerneye/hallways/lower_overlook
	name = "\improper Lower Fore Hallway"
	icon_state = "hangar"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_HANGAR
	soundscape_interval = 35

/area/westerneye/living/ReqNMessDorms
	name = "\improper Requisitions & Mess Dorms"
	fake_zlevel = 2

/area/westerneye/living/guestdorms
	name = "\improper Guest Dormitories"
	icon_state = "livingspace"
	fake_zlevel = 3
/area/westerneye/living/meseum
	name = "\improper Meseum"
	icon_state = "livingspace"
	fake_zlevel = 3

/area/westerneye/living/tankerbunks
	name = "\improper Vehicle Crew Bunks"
	icon_state = "livingspace"
	fake_zlevel = 3

/area/westerneye/squads/tankdeliveries
	name = "\improper Vehicle ASRS"
	icon_state = "req"
	fake_zlevel = 2

/area/westerneye/hallways/exoarmor
	name = "\improper Vehicle Armor Storage"
	icon_state = "exoarmor"
	fake_zlevel = 2 // lowerdeck

/area/westerneye/hallways/repair_bay
	name = "\improper Deployment Workshop"
	icon_state = "dropshiprepair"
	fake_zlevel = 2 // MidDeck

/area/westerneye/hallways/mission_planner
	name = "\improper Dropship Central Computer Room"
	icon_state = "missionplanner"
	fake_zlevel = 2 // lowerdeck

/area/westerneye/hallways/starboard_umbilical
	name = "\improper Umbilical Starboard"
	icon_state = "starboardumbilical"
	fake_zlevel = 2 // lowerdeck

/area/westerneye/hallways/port_umbilical
	name = "\improper Umbilical Port"
	icon_state = "portumbilical"
	fake_zlevel = 2 // lowerdeck

/area/westerneye/hallways/upper_aft_hallway
	name = "\improper Upperdeck Hallway Aft"
	icon_state = "aft"
	fake_zlevel = 1 // upperdeck

/area/westerneye/hallways/upper_port_hallway
	name = "\improper Upperdeck Port Hallway"
	icon_state = "port"
	fake_zlevel = 1 // upperdeck

/area/westerneye/hallways/upper_starboard_hallway
	name = "\improper Upperdeck Starboard Hallway"
	icon_state = "starboard"
	fake_zlevel = 1 // upperdeck

/area/westerneye/hallways/midship_aft_hallway
	name = "\improper Middeck Hallway Aft"
	icon_state = "stern"
	fake_zlevel = 2 // middeck

/area/westerneye/hallways/midship_port_hallway
	name = "\improper Middeck Port Hallway"
	icon_state = "stern"
	fake_zlevel = 2 // middeck

/area/westerneye/hallways/midship_starboard_hallway
	name = "\improper Middeck Starboard Hallway"
	icon_state = "starboard"
	fake_zlevel = 2 // middeck

/area/westerneye/hallways/lowerdeck_aft_hallway
	name = "\improper Lowerdeck Starboard Hallway"
	icon_state = "starboard"
	fake_zlevel = 3 // lowerdeck

/area/westerneye/hallways/lowerdeck_starboard_hallway
	name = "\improper Lowerdeck Starboard Hallway"
	icon_state = "starboard"
	fake_zlevel = 3 // lowerdeck

/area/westerneye/hallways/lowerdeck_port_hallway
	name = "\improper Lowerdeck Port Hallway"
	icon_state = "port"
	fake_zlevel = 3 // lowerdeck

/area/westerneye/hallways/lowerdeck_fore_starboard_hallway
	name = "\improper Lowerdeck Starboard Hallway"
	icon_state = "starboard"
	fake_zlevel = 3 // lowerdeck

/area/westerneye/hallways/lowerdeck_fore_port_hallway
	name = "\improper Lowerdeck Port Hallway"
	icon_state = "port"
	fake_zlevel = 3 // lowerdeck

/area/westerneye/hallways/lower_starboard_escape_hallway
	name = "\improper Lower Starboard Escape Pods"
	icon_state = "starboard"
	fake_zlevel = 3

/area/westerneye/hallways/lower_port_escape_hallway
	name = "\improper Lower Port Escape Pods"
	icon_state = "port"
	fake_zlevel = 3

/area/westerneye/hallways/starboard_escape_hallway
	name = "\improper Starboard Escape Pods"
	icon_state = "starboard"
	fake_zlevel = 2

/area/westerneye/hallways/port_escape_hallway
	name = "\improper Port Escape Pods"
	icon_state = "port"
	fake_zlevel = 2

/area/westerneye/hallways/fore_starboard_escape_hallway
	name = "\improper Starboard Escape Pods"
	icon_state = "starboard"
	fake_zlevel = 2

/area/westerneye/hallways/fore_port_escape_hallway
	name = "\improper Port Escape Pods"
	icon_state = "port"
	fake_zlevel = 2

/area/westerneye/stair_clone
	name = "\improper Stairs"
	icon_state = "stairs_lowerdeck"
	fake_zlevel = 2 // lowerdeck
	resin_construction_allowed = FALSE

/area/westerneye/stair_clone/upper
	icon_state = "stairs_upperdeck"
	fake_zlevel = 1 // upperdeck

/area/westerneye/hull/upper_hull
	name = "\improper Hull Upper"
	icon_state = "upperhull"
	fake_zlevel = 1 // upperdeck

/area/westerneye/hull/upper_hull/u_f_s
	name = "\improper Upper Fore-Starboard Hull"

/area/westerneye/hull/upper_hull/u_m_s
	name = "\improper Upper Midship-Starboard Hull"

/area/westerneye/hull/upper_hull/u_a_s
	name = "\improper Upper Aft-Starboard Hull"

/area/westerneye/hull/upper_hull/u_f_p
	name = "\improper Upper Fore-Port Hull"

/area/westerneye/hull/upper_hull/u_m_p
	name = "\improper Upper Midship-Port Hull"

/area/westerneye/hull/upper_hull/u_a_p
	name = "\improper Upper Aft-Port Hull"

/area/westerneye/hull/mid_hull
	name = "\improper Hull Lower"
	icon_state = "lowerhull"
	fake_zlevel = 2 // midship

/area/westerneye/hull/mid_hull/l_f_s
	name = "\improper Lower Fore-Starboard Hull"

/area/westerneye/hull/mid_hull/l_m_s
	name = "\improper Lower Midship-Starboard Hull"

/area/westerneye/hull/mid_hull/l_a_s
	name = "\improper Lower Aft-Starboard Hull"

/area/westerneye/hull/mid_hull/l_f_p
	name = "\improper Lower Fore-Port Hull"

/area/westerneye/hull/mid_hull/l_m_p
	name = "\improper Lower Midship-Port Hull"

/area/westerneye/hull/mid_hull/l_a_p
	name = "\improper Lower Aft-Port Hull"

/area/westerneye/hull/lower_hull
	name = "\improper Hull Lower"
	icon_state = "lowerhull"
	fake_zlevel = 3 // lowerdeck

/area/westerneye/hull/lower_hull/l_f_s
	name = "\improper Lower Fore-Starboard Hull"

/area/westerneye/hull/lower_hull/l_m_s
	name = "\improper Lower Midship-Starboard Hull"

/area/westerneye/hull/lower_hull/l_a_s
	name = "\improper Lower Aft-Starboard Hull"

/area/westerneye/hull/lower_hull/l_f_p
	name = "\improper Lower Fore-Port Hull"

/area/westerneye/hull/lower_hull/l_m_p
	name = "\improper Lower Midship-Port Hull"

/area/westerneye/hull/lower_hull/l_a_p
	name = "\improper Lower Aft-Port Hull"

/area/westerneye/hull/starboard_warehouse
	name = "\improper Starboard Warehouse"

/area/westerneye/hull/starboard_warehouse_mini
	name = "\improper Secondary Starboard Warehouse"
/area/westerneye/hull/port_warehouse
	name = "\improper Port Warehouse"

/area/westerneye/hull/port_warehouse_mini
	name = "\improper Secondary Port Warehouse"
/area/westerneye/living/cryo_cells
	name = "\improper Cryo Cells"
	icon_state = "cryo"
	fake_zlevel = 2 // middeck

/area/westerneye/living/cryo_cell_showers
	name = "\improper Showers"
	icon_state = "cryo"
	fake_zlevel = 2 // middeck

/area/westerneye/living/briefing
	name = "\improper Briefing Area"
	icon_state = "briefing"
	fake_zlevel = 1

/area/westerneye/living/alpha_bunks
	name = "\improper Extended Mission Alpha Bunks"
	icon_state = "alpha"
	fake_zlevel = 2 // middeck

/area/westerneye/living/bravo_bunks
	name = "\improper Extended Mission Bravo Bunks"
	icon_state = "bravo"
	fake_zlevel = 2 // middeck

/area/westerneye/living/charlie_bunks
	name = "\improper Extended Mission Charlie Bunks"
	icon_state = "charlie"
	fake_zlevel = 2 // middeck

/area/westerneye/living/delta_bunks
	name = "\improper Extended Mission Delta Bunks"
	icon_state = "delta"
	fake_zlevel = 2 // middeck

/area/westerneye/living/port_garden
	name = "\improper Garden"
	icon_state = "portemb"
	fake_zlevel = 1 // upperdeck

/area/westerneye/living/starboard_garden
	name = "\improper Garden"
	icon_state = "starboardemb"
	fake_zlevel = 1 // upperdeck

/area/westerneye/living/basketball
	name = "\improper Basketball Court"
	icon_state = "basketball"
	fake_zlevel = 1 // upperdeck

/area/westerneye/living/grunt_rnr
	name = "\improper Lounge"
	icon_state = "gruntrnr"
	fake_zlevel = 2 // lowerdeck

/area/westerneye/living/mess_hall
	name = "\improper Mess Hall"
	icon_state = "gruntrnr"
	fake_zlevel = 2 // lowerdeck

/area/westerneye/living/officer_rnr
	name = "\improper Officer's Lounge"
	icon_state = "officerrnr"
	fake_zlevel = 1 // upperdeck

/area/westerneye/living/officer_study
	name = "\improper Officer's Study"
	icon_state = "officerstudy"
	fake_zlevel = 1 // upperdeck

/area/westerneye/living/cafeteria_port
	name = "\improper Cafeteria Port"
	icon_state = "food"
	fake_zlevel = 2 // lowerdeck

/area/westerneye/living/cafeteria_starboard
	name = "\improper Cafeteria Starboard"
	icon_state = "food"
	fake_zlevel = 2 // lowerdeck

/area/westerneye/living/gym
	name = "\improper Gym"
	icon_state = "officerrnr"
	fake_zlevel = 2 // lowerdeck

/area/westerneye/living/cafeteria_officer
	name = "\improper Officer Cafeteria"
	icon_state = "food"
	fake_zlevel = 1 // upperdeck

/area/westerneye/living/offices
	name = "\improper Conference Office"
	icon_state = "briefing"
	fake_zlevel = 2 // lowerdeck

/area/westerneye/living/shipstore
	name = "\improper Ship Store"
	fake_zlevel = 2

/area/westerneye/living/offices/flight
	name = "\improper Flight Office"

/area/westerneye/living/captain_mess
	name = "\improper Captain's Mess"
	icon_state = "briefing"
	fake_zlevel = 1 // upperdeck

/area/westerneye/living/pilotbunks
	name = "\improper Pilot's Bunks"
	icon_state = "livingspace"
	fake_zlevel = 1

/area/westerneye/living/bridgebunks
	name = "\improper Staff Officer Bunks"
	icon_state = "livingspace"
	fake_zlevel = 1 // upperdeck

/area/westerneye/living/commandbunks
	name = "\improper Commanding Officer's Bunk"
	icon_state = "livingspace"
	fake_zlevel = 1 // upperdeck

/area/westerneye/living/synthcloset
	name = "\improper Synthetic Storage Closet"
	icon_state = "livingspace"
	fake_zlevel = 1 // upperdeck

/area/westerneye/living/numbertwobunks
	name = "\improper Executive Officer's Bunk"
	icon_state = "livingspace"
	fake_zlevel = 1 // upperdeck

/area/westerneye/living/chapel
	name = "\improper westerneye Chapel"
	icon_state = "officerrnr"
	fake_zlevel = 1 // upperdeck


/area/westerneye/medical
	icon_state = "medical"

/area/westerneye/medical/cmo
	icon_state = "Chief Medical Officer Office"


/area/westerneye/medical/fore_medical_lobby
	name = "\improper Medical Fore Lobby"
	icon_state = "medical"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 50

/area/westerneye/medical/aft_medical_lobby
	name = "\improper Medical Aft Lobby"
	icon_state = "medical"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 50

/area/westerneye/medical/dorms
	name = "\improper Medical Dorms"

/area/westerneye/medical/port_hallway
	name = "\improper Medical Port Hallway"

/area/westerneye/medical/starboard_hallway
	name = "\improper Medical Starboard Hallway"

/area/westerneye/medical/morgue
	name = "\improper Morgue"
	icon_state = "operating"
	fake_zlevel = 2 // middeck

/area/westerneye/medical/operating_room_one
	name = "\improper Medical Operating Room 1"
	icon_state = "operating"
	fake_zlevel = 2 // middeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 50

/area/westerneye/medical/operating_room_two
	name = "\improper Medical Operating Room 2"
	icon_state = "operating"
	fake_zlevel = 2 // middeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 50

/area/westerneye/medical/operating_room_three
	name = "\improper Medical Operating Room 3"
	icon_state = "operating"
	fake_zlevel = 2 // middeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 50

/area/westerneye/medical/operating_room_four
	name = "\improper Medical Operating Room 4"
	icon_state = "operating"
	fake_zlevel = 2 // middeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 50

/area/westerneye/medical/medical_science
	name = "\improper Medical Research laboratories"
	icon_state = "science"
	fake_zlevel = 1 // upperdeck

/area/westerneye/medical/hydroponics
	name = "\improper Medical Research hydroponics"
	icon_state = "science"
	fake_zlevel = 1 // upperdeck

/area/westerneye/medical/testlab
	name = "\improper Medical Research workshop"
	icon_state = "science"
	fake_zlevel = 1 // upperdeck

/area/westerneye/medical/containment
	name = "\improper Medical Research containment"
	icon_state = "science"
	fake_zlevel = 1 // upperdeck

/area/westerneye/medical/containment/cell
	name = "\improper Medical Research containment cells"
	icon_state = "science"
	fake_zlevel = 1 // upperdeck
	flags_area = AREA_AVOID_BIOSCAN|AREA_NOTUNNEL|AREA_CONTAINMENT

/area/westerneye/medical/containment/cell/cl
	name = "\improper Containment"

/area/westerneye/medical/chemistry
	name = "\improper Medical Chemical laboratory"
	icon_state = "chemistry"
	fake_zlevel = 2 // lowerdeck

/area/westerneye/medical/lockerroom
	name = "\improper Medical Locker Room"
	icon_state = "science"
	fake_zlevel = 2 // lowerdeck

/area/westerneye/medical/cryo_tubes
	name = "\improper Medical Cryogenics Tubes"
	icon_state = "medical"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 50

/area/westerneye/medical/lower_medical_medbay
	name = "\improper Medical Lower Medbay"
	icon_state = "medical"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 50

/area/westerneye/squads/alpha
	name = "\improper Squad Alpha Preparation"
	icon_state = "alpha"
	fake_zlevel = 2 // lowerdeck

/area/westerneye/squads/bravo
	name = "\improper Squad Bravo Preparation"
	icon_state = "bravo"
	fake_zlevel = 2 // lowerdeck

/area/westerneye/squads/charlie
	name = "\improper Squad Charlie Preparation"
	icon_state = "charlie"
	fake_zlevel = 2 // lowerdeck

/area/westerneye/squads/delta
	name = "\improper Squad Delta Preparation"
	icon_state = "delta"
	fake_zlevel = 2 // lowerdeck

/area/westerneye/squads/alpha_bravo_shared
	name = "\improper Alpha Bravo Equipment Preparation"
	icon_state = "ab_shared"
	fake_zlevel = 2 // lowerdeck

/area/westerneye/squads/charlie_delta_shared
	name = "\improper Charlie Delta Equipment Preparation"
	icon_state = "cd_shared"
	fake_zlevel = 2 // lowerdeck

/area/westerneye/squads/req
	name = "\improper Requisitions"
	icon_state = "req"
	fake_zlevel = 2 // lowerdeck

/area/westerneye/powered //for objects not intended to lose power
	name = "\improper Powered"
	icon_state = "selfdestruct"
	requires_power = 0

/area/westerneye/powered/agent
	name = "\improper Unknown Area"
	icon_state = "selfdestruct"
	fake_zlevel = 2 // lowerdeck
	flags_area = AREA_AVOID_BIOSCAN|AREA_NOTUNNEL

/area/westerneye/engineering/airmix
	icon_state = "selfdestruct"
	requires_power = 0
	flags_area = AREA_NOTUNNEL

/area/westerneye/lifeboat_pumps
	name = "Lifeboat Fuel Pumps"
	icon_state = "lifeboat_pump"
	requires_power = 1
	fake_zlevel = 1

/area/westerneye/lifeboat_pumps/north1
	name = "North West Lifeboat Fuel Pump"

/area/westerneye/lifeboat_pumps/north2
	name = "North East Lifeboat Fuel Pump"

/area/westerneye/lifeboat_pumps/south1
	name = "South West Lifeboat Fuel Pump"

/area/westerneye/lifeboat_pumps/south2
	name = "South East Lifeboat Fuel Pump"

/area/westerneye/command/lifeboat
	name = "\improper Lifeboat Docking Port"
	icon_state = "selfdestruct"
	fake_zlevel = 1 // upperdeck

/area/space/westerneye/lifeboat_dock
	name = "\improper Lifeboat Docking Port"
	icon = 'icons/turf/area_almayer.dmi'
	icon_state = "lifeboat"
	fake_zlevel = 1 // upperdeck
	flags_atom = AREA_NOTUNNEL

/area/westerneye/evacuation
	icon = 'icons/turf/areas.dmi'
	icon_state = "shuttle2"
	requires_power = 0
	flags_area = AREA_NOTUNNEL

//Placeholder.
/area/westerneye/evacuation/pod1
/area/westerneye/evacuation/pod2
/area/westerneye/evacuation/pod3
/area/westerneye/evacuation/pod4
/area/westerneye/evacuation/pod5
/area/westerneye/evacuation/pod6
/area/westerneye/evacuation/pod7
/area/westerneye/evacuation/pod8
/area/westerneye/evacuation/pod9
/area/westerneye/evacuation/pod10
/area/westerneye/evacuation/pod11
/area/westerneye/evacuation/pod12
/area/westerneye/evacuation/pod13
/area/westerneye/evacuation/pod14
/area/westerneye/evacuation/pod15
/area/westerneye/evacuation/pod16
/area/westerneye/evacuation/pod17
/area/westerneye/evacuation/pod18
