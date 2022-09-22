//ALMAYER AREAS--------------------------------------//
// Fore = West  | Aft = East //
// Port = South | Starboard = North //
/area/almayer
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

/area/shuttle/almayer/elevator_maintenance/upperdeck
	name = "\improper Maintenance Elevator"
	icon_state = "shuttle"
	fake_zlevel = 1

/area/shuttle/almayer/elevator_maintenance/lowerdeck
	name = "\improper Maintenance Elevator"
	icon_state = "shuttle"
	fake_zlevel = 2

/area/shuttle/almayer/elevator_hangar/lowerdeck
	name = "\improper Hangar Elevator"
	icon_state = "shuttle"
	fake_zlevel = 2 // lowerdeck

/area/shuttle/almayer/elevator_hangar/underdeck
	name = "\improper Hangar Elevator"
	icon_state = "shuttle"
	fake_zlevel = 3

/obj/structure/machinery/computer/shuttle_control/almayer/hangar
	name = "Elevator Console"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "supply"
	unslashable = TRUE
	unacidable = TRUE
	exproof = 1
	density = 1
	req_access = null
	shuttle_tag = "Hangar"

/obj/structure/machinery/computer/shuttle_control/almayer/maintenance
	name = "Elevator Console"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "shuttle"
	unslashable = TRUE
	unacidable = TRUE
	exproof = 1
	density = 1
	req_access = null
	shuttle_tag = "Maintenance"

/area/almayer/command/cic
	name = "\improper Combat Information Center"
	icon_state = "cic"
	fake_zlevel = 1 // upperdeck
	soundscape_playlist = SCAPE_PL_CIC
	soundscape_interval = 20
	flags_area = AREA_NOTUNNEL

/area/almayer/command/cichallway
	name = "\improper Secure Command Hallway"
	icon_state = "airoom"
	fake_zlevel = 1 // upperdeck

/area/almayer/command/airoom
	name = "\improper AI Core"
	icon_state = "airoom"
	fake_zlevel = 1 // upperdeck
	soundscape_playlist = SCAPE_PL_ARES
	soundscape_interval = 8
	flags_area = AREA_NOTUNNEL

/area/almayer/command/securestorage
	name = "\improper Secure Storage"
	icon_state = "corporatespace"
	fake_zlevel = 1 // upperdeck

/area/almayer/command/computerlab
	name = "\improper Computer Lab"
	icon_state = "ceroom"
	fake_zlevel = 1 // upperdeck

/area/almayer/command/telecomms
	name = "\improper Telecommunications"
	icon_state = "tcomms"
	fake_zlevel = 1 // upperdeck
	flags_area = AREA_NOTUNNEL

/area/almayer/command/self_destruct
	name = "\improper Self-Destruct Core Room"
	icon_state = "selfdestruct"
	fake_zlevel = 1 // upperdeck
	flags_area = AREA_NOTUNNEL

/area/almayer/command/corporateliason
	name = "\improper Corporate Liaison Office"
	icon_state = "corporatespace"
	fake_zlevel = 1 // upperdeck

/area/almayer/engineering/upper_engineering
	name = "\improper Upper Engineering"
	icon_state = "upperengineering"
	fake_zlevel = 1 // upperdeck

/area/almayer/engineering/upper_engineering/notunnel
	flags_area = AREA_NOTUNNEL

/area/almayer/engineering/ce_room
	name = "\improper Chief Engineer Office"
	icon_state = "ceroom"
	fake_zlevel = 1 // upperdeck

/area/almayer/engineering/lower_engine_monitoring
	name = "\improper Engine Reactor Monitoring"
	icon_state = "lowermonitoring"
	fake_zlevel = 2 // lowerdeck

/area/almayer/engineering/lower_engineering
	name = "\improper Engineering Lower"
	icon_state = "lowerengineering"
	fake_zlevel = 2 // lowerdeck

/area/almayer/engineering/engineering_workshop
	name = "\improper Engineering Workshop"
	icon_state = "workshop"
	fake_zlevel = 2 // lowerdeck

/area/almayer/engineering/engineering_workshop/hangar
	name = "\improper Ordnance workshop"

/area/almayer/engineering/engine_core
	name = "\improper Engine Reactor Core Room"
	icon_state = "coreroom"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ENG
	soundscape_interval = 15

/area/almayer/engineering/starboard_atmos
	name = "\improper Atmospherics Starboard"
	icon_state = "starboardatmos"
	fake_zlevel = 1 // upperdeck

/area/almayer/engineering/port_atmos
	name = "\improper Atmospherics Port"
	icon_state = "portatmos"
	fake_zlevel = 1 // upperdeck

/area/almayer/engineering/laundry
	name = "\improper Laundry Room"
	icon_state = "laundry"
	fake_zlevel = 1 // upperdeck

/area/almayer/shipboard/navigation
	name = "\improper Astronavigational Deck"
	icon_state = "astronavigation"
	fake_zlevel = 2 // lowerdeck

/area/almayer/shipboard/starboard_missiles
	name = "\improper Missile Tubes Starboard"
	icon_state = "starboardmissile"
	fake_zlevel = 1 // upperdeck

/area/almayer/shipboard/port_missiles
	name = "\improper Missile Tubes Port"
	icon_state = "portmissile"
	fake_zlevel = 1 // upperdeck

/area/almayer/shipboard/weapon_room
	name = "\improper Weapon Control Room"
	icon_state = "weaponroom"
	fake_zlevel = 2 // lowerdeck

/area/almayer/shipboard/weapon_room/notunnel
	flags_area = AREA_NOTUNNEL

/area/almayer/shipboard/starboard_point_defense
	name = "\improper Point Defense Starboard"
	icon_state = "starboardpd"
	fake_zlevel = 2 // lowerdeck

/area/almayer/shipboard/port_point_defense
	name = "\improper Point Defense Port"
	icon_state = "portpd"
	fake_zlevel = 2 // lowerdeck

/area/almayer/shipboard/brig
	name = "\improper Brig"
	icon_state = "brig"
	fake_zlevel = 1 //upperdeck

/area/almayer/shipboard/brig/lobby
	name = "\improper Brig Lobby"
	icon_state = "brig"

/area/almayer/shipboard/brig/armory
	name = "\improper Brig Armory"
	icon_state = "brig"

/area/almayer/shipboard/brig/main_office
	name = "\improper Brig Main Office"
	icon_state = "brig"

/area/almayer/shipboard/brig/perma
	name = "\improper Brig Perma Cells"
	icon_state = "brig"

/area/almayer/shipboard/brig/cryo
	name = "\improper Brig Cryo Pods"
	icon_state = "brig"

/area/almayer/shipboard/brig/surgery
	name = "\improper Brig Surgery"
	icon_state = "brig"

/area/almayer/shipboard/brig/general_equipment
	name = "\improper Brig General Equipment"
	icon_state = "brig"

/area/almayer/shipboard/brig/evidence_storage
	name = "\improper Brig Evidence Storage"
	icon_state = "brig"

/area/almayer/shipboard/brig/execution
	name = "\improper Brig Execution Room"
	icon_state = "brig"

/area/almayer/shipboard/brig/cic_hallway
	name = "\improper Brig CiC Hallway"
	icon_state = "brig"

/area/almayer/shipboard/brig/dress
	name = "\improper CIC Dress Uniform Room"
	icon_state = "brig"

/area/almayer/shipboard/brig/processing
	name = "\improper Brig Processing and Holding"
	icon_state = "brig"

/area/almayer/shipboard/brig/cells
	name = "\improper Brig Cells"
	icon_state = "brigcells"

/area/almayer/shipboard/brig/chief_mp_office
	name = "\improper Brig Chief MP Office"
	icon_state = "chiefmpoffice"

/area/almayer/shipboard/sea_office
	name = "\improper Senior Enlisted Advisor Office"
	icon_state = "chiefmpoffice"
	fake_zlevel = 2 // lowerdeck

/area/almayer/shipboard/firing_range_north
	name = "\improper Starboard Firing Range"
	icon_state = "firingrange"
	fake_zlevel = 2 // lowerdeck

/area/almayer/shipboard/firing_range_south
	name = "\improper Port Firing Range"
	icon_state = "firingrange"
	fake_zlevel = 2 // lowerdeck

/area/almayer/shipboard/sensors
	name = "\improper Sensor Room"
	icon_state = "sensor"

/area/almayer/hallways/hangar
	name = "\improper Hangar"
	icon_state = "hangar"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_HANGAR
	soundscape_interval = 35

/area/almayer/hallways/vehiclehangar
	name = "\improper Vehicle Storage"
	icon_state = "exoarmor"
	fake_zlevel = 2

/area/almayer/living/tankerbunks
	name = "\improper Vehicle Crew Bunks"
	icon_state = "livingspace"
	fake_zlevel = 2

/area/almayer/squads/tankdeliveries
	name = "\improper Vehicle ASRS"
	icon_state = "req"
	fake_zlevel = 2

/area/almayer/hallways/exoarmor
	name = "\improper Vehicle Armor Storage"
	icon_state = "exoarmor"
	fake_zlevel = 2 // lowerdeck

/area/almayer/hallways/repair_bay
	name = "\improper Deployment Workshop"
	icon_state = "dropshiprepair"
	fake_zlevel = 2 // lowerdeck

/area/almayer/hallways/mission_planner
	name = "\improper Dropship Central Computer Room"
	icon_state = "missionplanner"
	fake_zlevel = 2 // lowerdeck

/area/almayer/hallways/starboard_umbilical
	name = "\improper Umbilical Starboard"
	icon_state = "starboardumbilical"
	fake_zlevel = 2 // lowerdeck

/area/almayer/hallways/port_umbilical
	name = "\improper Umbilical Port"
	icon_state = "portumbilical"
	fake_zlevel = 2 // lowerdeck

/area/almayer/hallways/aft_hallway
	name = "\improper Hallway Aft"
	icon_state = "aft"
	fake_zlevel = 1 // upperdeck

/area/almayer/hallways/stern_hallway
	name = "\improper Hallway Stern"
	icon_state = "stern"
	fake_zlevel = 1 // upperdeck

/area/almayer/hallways/port_hallway
	name = "\improper Hallway Port"
	icon_state = "port"
	fake_zlevel = 2 // lowerdeck

/area/almayer/hallways/starboard_hallway
	name = "\improper Hallway Starboard"
	icon_state = "starboard"
	fake_zlevel = 2 // lowerdeck

/area/almayer/stair_clone
	name = "\improper Stairs"
	icon_state = "stairs_lowerdeck"
	fake_zlevel = 2 // lowerdeck
	resin_construction_allowed = FALSE

/area/almayer/stair_clone/upper
	icon_state = "stairs_upperdeck"
	fake_zlevel = 1 // upperdeck

/area/almayer/hull/lower_hull
	name = "\improper Hull Lower"
	icon_state = "lowerhull"
	fake_zlevel = 2 // lowerdeck

/area/almayer/hull/upper_hull
	name = "\improper Hull Upper"
	icon_state = "upperhull"
	fake_zlevel = 1 // upperdeck

/area/almayer/hull/upper_hull/u_f_s
	name = "\improper Upper Fore-Starboard Hull"
	icon_state = "upperhull"

/area/almayer/hull/upper_hull/u_m_s
	name = "\improper Upper Midship-Starboard Hull"
	icon_state = "upperhull"

/area/almayer/hull/upper_hull/u_a_s
	name = "\improper Upper Aft-Starboard Hull"
	icon_state = "upperhull"

/area/almayer/hull/upper_hull/u_f_p
	name = "\improper Upper Fore-Port Hull"
	icon_state = "upperhull"

/area/almayer/hull/upper_hull/u_m_p
	name = "\improper Upper Midship-Port Hull"
	icon_state = "upperhull"

/area/almayer/hull/upper_hull/u_a_p
	name = "\improper Upper Aft-Port Hull"
	icon_state = "upperhull"

/area/almayer/hull/lower_hull/l_f_s
	name = "\improper Lower Fore-Starboard Hull"
	icon_state = "upperhull"

/area/almayer/hull/lower_hull/l_m_s
	name = "\improper Lower Midship-Starboard Hull"
	icon_state = "upperhull"

/area/almayer/hull/lower_hull/l_a_s
	name = "\improper Lower Aft-Starboard Hull"
	icon_state = "upperhull"

/area/almayer/hull/lower_hull/l_f_p
	name = "\improper Lower Fore-Port Hull"
	icon_state = "upperhull"

/area/almayer/hull/lower_hull/l_m_p
	name = "\improper Lower Midship-Port Hull"
	icon_state = "upperhull"

/area/almayer/hull/lower_hull/l_a_p
	name = "\improper Lower Aft-Port Hull"
	icon_state = "upperhull"

/area/almayer/living/cryo_cells
	name = "\improper Cryo Cells"
	icon_state = "cryo"
	fake_zlevel = 2 // lowerdeck

/area/almayer/living/briefing
	name = "\improper Briefing Area"
	icon_state = "briefing"
	fake_zlevel = 2 // lowerdeck

/area/almayer/living/port_emb
	name = "\improper Extended Mission Bunks"
	icon_state = "portemb"
	fake_zlevel = 2 // lowerdeck

/area/almayer/living/starboard_emb
	name = "\improper Extended Mission Bunks"
	icon_state = "starboardemb"
	fake_zlevel = 2 // lowerdeck

/area/almayer/living/port_garden
	name = "\improper Garden"
	icon_state = "portemb"
	fake_zlevel = 1 // upperdeck

/area/almayer/living/starboard_garden
	name = "\improper Garden"
	icon_state = "starboardemb"
	fake_zlevel = 1 // upperdeck

/area/almayer/living/basketball
	name = "\improper Basketball Court"
	icon_state = "basketball"
	fake_zlevel = 1 // upperdeck

/area/almayer/living/grunt_rnr
	name = "\improper Lounge"
	icon_state = "gruntrnr"
	fake_zlevel = 2 // lowerdeck

/area/almayer/living/officer_rnr
	name = "\improper Officer's Lounge"
	icon_state = "officerrnr"
	fake_zlevel = 1 // upperdeck

/area/almayer/living/officer_study
	name = "\improper Officer's Study"
	icon_state = "officerstudy"
	fake_zlevel = 1 // upperdeck

/area/almayer/living/cafeteria_port
	name = "\improper Cafeteria Port"
	icon_state = "food"
	fake_zlevel = 2 // lowerdeck

/area/almayer/living/cafeteria_starboard
	name = "\improper Cafeteria Starboard"
	icon_state = "food"
	fake_zlevel = 2 // lowerdeck

/area/almayer/living/gym
	name = "\improper Gym"
	icon_state = "officerrnr"
	fake_zlevel = 2 // lowerdeck

/area/almayer/living/cafeteria_officer
	name = "\improper Officer Cafeteria"
	icon_state = "food"
	fake_zlevel = 1 // upperdeck

/area/almayer/living/offices
	name = "\improper Conference Office"
	icon_state = "briefing"
	fake_zlevel = 2 // lowerdeck

/area/almayer/living/offices/flight
	name = "\improper Flight Office"

/area/almayer/living/captain_mess
	name = "\improper Captain's Mess"
	icon_state = "briefing"
	fake_zlevel = 1 // upperdeck

/area/almayer/living/pilotbunks
	name = "\improper Pilot's Bunks"
	icon_state = "livingspace"
	fake_zlevel = 1

/area/almayer/living/bridgebunks
	name = "\improper Staff Officer Bunks"
	icon_state = "livingspace"
	fake_zlevel = 1 // upperdeck

/area/almayer/living/commandbunks
	name = "\improper Commanding Officer's Bunk"
	icon_state = "livingspace"
	fake_zlevel = 1 // upperdeck

/area/almayer/living/synthcloset
	name = "\improper Synthetic Storage Closet"
	icon_state = "livingspace"
	fake_zlevel = 1 // upperdeck

/area/almayer/living/numbertwobunks
	name = "\improper Executive Officer's Bunk"
	icon_state = "livingspace"
	fake_zlevel = 1 // upperdeck

/area/almayer/living/chapel
	name = "\improper Almayer Chapel"
	icon_state = "officerrnr"
	fake_zlevel = 1 // upperdeck

/area/almayer/medical/lower_medical_lobby
	name = "\improper Medical Lower Lobby"
	icon_state = "medical"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 50

/area/almayer/medical/upper_medical
	name = "\improper Medical Upper"
	icon_state = "medical"
	fake_zlevel = 1 // upperdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 50

/area/almayer/medical/morgue
	name = "\improper Morgue"
	icon_state = "operating"
	fake_zlevel = 1 // upperdeck

/area/almayer/medical/operating_room_one
	name = "\improper Medical Operating Room 1"
	icon_state = "operating"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 50

/area/almayer/medical/operating_room_two
	name = "\improper Medical Operating Room 2"
	icon_state = "operating"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 50

/area/almayer/medical/operating_room_three
	name = "\improper Medical Operating Room 3"
	icon_state = "operating"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 50

/area/almayer/medical/operating_room_four
	name = "\improper Medical Operating Room 4"
	icon_state = "operating"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 50

/area/almayer/medical/medical_science
	name = "\improper Medical Research laboratories"
	icon_state = "science"
	fake_zlevel = 1 // upperdeck

/area/almayer/medical/hydroponics
	name = "\improper Medical Research hydroponics"
	icon_state = "science"
	fake_zlevel = 1 // upperdeck

/area/almayer/medical/testlab
	name = "\improper Medical Research workshop"
	icon_state = "science"
	fake_zlevel = 1 // upperdeck

/area/almayer/medical/containment
	name = "\improper Medical Research containment"
	icon_state = "science"
	fake_zlevel = 1 // upperdeck

/area/almayer/medical/containment/cell
	name = "\improper Medical Research containment cells"
	icon_state = "science"
	fake_zlevel = 1 // upperdeck
	flags_area = AREA_AVOID_BIOSCAN|AREA_NOTUNNEL|AREA_CONTAINMENT

/area/almayer/medical/containment/cell/cl
	name = "\improper Containment"

/area/almayer/medical/chemistry
	name = "\improper Medical Chemical laboratory"
	icon_state = "chemistry"
	fake_zlevel = 2 // lowerdeck

/area/almayer/medical/lockerroom
	name = "\improper Medical Locker Room"
	icon_state = "science"
	fake_zlevel = 2 // lowerdeck

/area/almayer/medical/cryo_tubes
	name = "\improper Medical Cryogenics Tubes"
	icon_state = "medical"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 50

/area/almayer/medical/lower_medical_medbay
	name = "\improper Medical Lower Medbay"
	icon_state = "medical"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 50

/area/almayer/squads/alpha
	name = "\improper Squad Alpha Preparation"
	icon_state = "alpha"
	fake_zlevel = 2 // lowerdeck

/area/almayer/squads/bravo
	name = "\improper Squad Bravo Preparation"
	icon_state = "bravo"
	fake_zlevel = 2 // lowerdeck

/area/almayer/squads/charlie
	name = "\improper Squad Charlie Preparation"
	icon_state = "charlie"
	fake_zlevel = 2 // lowerdeck

/area/almayer/squads/delta
	name = "\improper Squad Delta Preparation"
	icon_state = "delta"
	fake_zlevel = 2 // lowerdeck

/area/almayer/squads/alpha_bravo_shared
	name = "\improper Alpha Bravo Equipment Preparation"
	icon_state = "ab_shared"
	fake_zlevel = 2 // lowerdeck

/area/almayer/squads/charlie_delta_shared
	name = "\improper Charlie Delta Equipment Preparation"
	icon_state = "cd_shared"
	fake_zlevel = 2 // lowerdeck

/area/almayer/squads/req
	name = "\improper Requisitions"
	icon_state = "req"
	fake_zlevel = 2 // lowerdeck

/area/almayer/powered //for objects not intended to lose power
	name = "\improper Powered"
	icon_state = "selfdestruct"
	requires_power = 0

/area/almayer/powered/agent
	name = "\improper Unknown Area"
	icon_state = "selfdestruct"
	fake_zlevel = 2 // lowerdeck
	flags_area = AREA_AVOID_BIOSCAN|AREA_NOTUNNEL

/area/almayer/engineering/airmix
	icon_state = "selfdestruct"
	requires_power = 0
	flags_area = AREA_NOTUNNEL

/area/almayer/lifeboat_pumps
	name = "Lifeboat Fuel Pumps"
	icon_state = "lifeboat_pump"
	requires_power = 1
	fake_zlevel = 1

/area/almayer/lifeboat_pumps/north1
	name = "North West Lifeboat Fuel Pump"

/area/almayer/lifeboat_pumps/north2
	name = "North East Lifeboat Fuel Pump"

/area/almayer/lifeboat_pumps/south1
	name = "South West Lifeboat Fuel Pump"

/area/almayer/lifeboat_pumps/south2
	name = "South East Lifeboat Fuel Pump"

/area/almayer/command/lifeboat
	name = "\improper Lifeboat Docking Port"
	icon_state = "selfdestruct"
	fake_zlevel = 1 // upperdeck

/area/space/almayer/lifeboat_dock
	name = "\improper Lifeboat Docking Port"
	icon = 'icons/turf/area_almayer.dmi'
	icon_state = "lifeboat"
	fake_zlevel = 1 // upperdeck
	flags_atom = AREA_NOTUNNEL

/area/almayer/evacuation
	icon = 'icons/turf/areas.dmi'
	icon_state = "shuttle2"
	requires_power = 0
	flags_area = AREA_NOTUNNEL

//Placeholder.
/area/almayer/evacuation/pod1
/area/almayer/evacuation/pod2
/area/almayer/evacuation/pod3
/area/almayer/evacuation/pod4
/area/almayer/evacuation/pod5
/area/almayer/evacuation/pod6
/area/almayer/evacuation/pod7
/area/almayer/evacuation/pod8
/area/almayer/evacuation/pod9
/area/almayer/evacuation/pod10
/area/almayer/evacuation/pod11
/area/almayer/evacuation/pod12
/area/almayer/evacuation/pod13
/area/almayer/evacuation/pod14
/area/almayer/evacuation/pod15
/area/almayer/evacuation/pod16
/area/almayer/evacuation/pod17
/area/almayer/evacuation/pod18

/area/almayer/evacuation/stranded
	test_exemptions = MAP_TEST_EXEMPTION_SPACE

//Placeholder.
/area/almayer/evacuation/stranded/pod1
/area/almayer/evacuation/stranded/pod2
/area/almayer/evacuation/stranded/pod3
/area/almayer/evacuation/stranded/pod4
/area/almayer/evacuation/stranded/pod5
/area/almayer/evacuation/stranded/pod6
/area/almayer/evacuation/stranded/pod7
/area/almayer/evacuation/stranded/pod8
/area/almayer/evacuation/stranded/pod9
/area/almayer/evacuation/stranded/pod10
/area/almayer/evacuation/stranded/pod11
/area/almayer/evacuation/stranded/pod12
/area/almayer/evacuation/stranded/pod13
/area/almayer/evacuation/stranded/pod14
/area/almayer/evacuation/stranded/pod15
/area/almayer/evacuation/stranded/pod16
/area/almayer/evacuation/stranded/pod17
/area/almayer/evacuation/stranded/pod18
