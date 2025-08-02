//ALMAYER AREAS--------------------------------------//
// Fore = West  | Aft = East //
// Port = South | Starboard = North //
// Bow = Western|Stern = Eastern //(those are the front and back small sections)
// Naming convention is to start by port or starboard then put eitheir (bow,fore,midship,aft,stern)
/area/almayer
	icon = 'icons/turf/area_almayer.dmi'
	// ambience = list('sound/ambience/shipambience.ogg')
	icon_state = "almayer"
	ceiling = CEILING_METAL
	powernet_name = "almayer"
	sound_environment = SOUND_ENVIRONMENT_ROOM
	soundscape_interval = 30
	// soundscape_playlist = list('sound/effects/xylophone1.ogg', 'sound/effects/xylophone2.ogg', 'sound/effects/xylophone3.ogg')
	ambience_exterior = AMBIENCE_ALMAYER
	ceiling_muffle = FALSE
	flags_area = AREA_NOSECURECADES
	weather_enabled = FALSE

	///Whether this area is used for hijack evacuation progress
	var/hijack_evacuation_area = FALSE

	///The weight this area gives towards hijack evacuation progress
	var/hijack_evacuation_weight = 0

	///Whether this area is additive or multiplicative towards evacuation progress
	var/hijack_evacuation_type = EVACUATION_TYPE_NONE

/area/almayer/Initialize(mapload, ...)
	. = ..()

	if(hijack_evacuation_area)
		SShijack.progress_areas[src] = power_equip

/obj/structure/machinery/computer/shuttle_control/almayer/hangar
	name = "Elevator Console"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "supply"
	unslashable = TRUE
	unacidable = TRUE
	explo_proof = TRUE
	density = TRUE
	req_access = null
	shuttle_tag = "Hangar"

/obj/structure/machinery/computer/shuttle_control/almayer/maintenance
	name = "Elevator Console"
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "shuttle"
	unslashable = TRUE
	unacidable = TRUE
	explo_proof = TRUE
	density = TRUE
	req_access = null
	shuttle_tag = "Maintenance"

/area/almayer/command
	minimap_color = MINIMAP_AREA_COMMAND

/area/almayer/command/cic
	name = "\improper Combat Information Center"
	icon_state = "cic"
	fake_zlevel = 1 // upperdeck
	soundscape_playlist = SCAPE_PL_CIC
	soundscape_interval = 50
	flags_area = AREA_NOTUNNEL

/area/almayer/command/cichallway
	name = "\improper Secure Command Hallway"
	icon_state = "airoom"
	fake_zlevel = 1 // upperdeck

/area/almayer/command/cicconference
	name = "\improper CIC Conference Room"
	icon_state = "cic"
	fake_zlevel = 1 // upperdeck

/area/almayer/command/airoom
	name = "\improper AI Core"
	icon_state = "airoom"
	fake_zlevel = 1 // upperdeck
	soundscape_playlist = SCAPE_PL_ARES
	soundscape_interval = 120
	flags_area = AREA_NOTUNNEL|AREA_UNWEEDABLE
	can_build_special = FALSE
	is_resin_allowed = FALSE
	resin_construction_allowed = FALSE

/area/almayer/command/securestorage
	name = "\improper Computer Lab Secure Storage"
	icon_state = "corporatespace"
	fake_zlevel = 1 // upperdeck

/area/almayer/command/computerlab
	name = "\improper Upper Deck Computer Lab"
	icon_state = "ceroom"
	fake_zlevel = 1 // upperdeck

/area/almayer/command/telecomms
	name = "\improper Upper Deck Telecommunications"
	icon_state = "tcomms"
	fake_zlevel = 1 // upperdeck
	flags_area = AREA_NOTUNNEL

/area/almayer/command/self_destruct
	name = "\improper Upper Deck Self-Destruct Core Room"
	icon_state = "selfdestruct"
	fake_zlevel = 1 // upperdeck
	flags_area = AREA_NOTUNNEL

/area/almayer/command/corporateliaison
	name = "\improper Corporate Liaison Office"
	icon_state = "corporatespace"
	fake_zlevel = 1 // upperdeck

/area/almayer/command/combat_correspondent
	name = "\improper Upper Deck Combat Correspondent Office"
	icon_state = "selfdestruct"
	fake_zlevel = 1 // upperdeck

// engineering

/area/almayer/engineering
	minimap_color = MINIMAP_AREA_ENGI

// lower deck

/area/almayer/engineering/lower
	name = "\improper Lower Deck Engineering"
	icon_state = "lowerengineering"
	fake_zlevel = 2 // lowerdeck

/area/almayer/engineering/lower/engine_monitoring//this is not used  so could be remove?
	name = "\improper Lower Deck Engine Reactor Monitoring"
	icon_state = "lowermonitoring"

/area/almayer/engineering/lower/workshop
	name = "\improper Lower Deck Engineering Workshop"
	icon_state = "workshop"

/area/almayer/engineering/lower/workshop/hangar
	name = "\improper Ordnance Workshop"

/area/almayer/engineering/lower/engine_core
	name = "\improper Engine Reactor Core Room"
	icon_state = "coreroom"
	soundscape_playlist = SCAPE_PL_ENG
	soundscape_interval = 15
	hijack_evacuation_area = TRUE
	hijack_evacuation_weight = 0.2
	hijack_evacuation_type = EVACUATION_TYPE_ADDITIVE

// upper deck

/area/almayer/engineering/upper_engineering
	name = "\improper Upper Deck Engineering"
	icon_state = "upperengineering"
	fake_zlevel = 1 // upperdeck

/area/almayer/engineering/upper_engineering/starboard
	name = "\improper Upper Deck Starboard Engineering"

/area/almayer/engineering/upper_engineering/port
	name = "\improper Upper Deck Port Engineering"

/area/almayer/engineering/upper_engineering/notunnel
	flags_area = AREA_NOTUNNEL
	requires_power = FALSE

/area/almayer/engineering/ce_room
	name = "\improper Upper Deck Chief Engineer Office"
	icon_state = "ceroom"
	fake_zlevel = 1 // upperdeck

/area/almayer/engineering/starboard_atmos
	name = "\improper Upper Deck Starboard Atmospherics"
	icon_state = "starboardatmos"
	fake_zlevel = 1 // upperdeck

/area/almayer/command/intel_bunks
	name = "\improper Upper Deck Intel Officer's Bunks"
	icon_state = "blue"
	fake_zlevel = 1 // upperdeck

/area/almayer/engineering/laundry
	name = "\improper Upper Deck Laundry Room"
	icon_state = "laundry"
	fake_zlevel = 1 // upperdeck

/area/almayer/shipboard
	minimap_color = MINIMAP_AREA_SEC

/area/almayer/shipboard/navigation
	name = "\improper Astronavigational Deck"
	icon_state = "astronavigation"
	fake_zlevel = 2 // lowerdeck
	hijack_evacuation_area = TRUE
	hijack_evacuation_weight = 1.1
	hijack_evacuation_type = EVACUATION_TYPE_MULTIPLICATIVE

/area/almayer/shipboard/panic
	name = "\improper Hangar Panic Room"
	icon_state = "brig"
	fake_zlevel = 2 // lowerdeck

/area/almayer/shipboard/starboard_missiles
	name = "\improper Upper Deck Starboard Missile Tubes"
	icon_state = "starboardmissile"
	fake_zlevel = 1 // upperdeck

/area/almayer/shipboard/port_missiles
	name = "\improper Upper Deck Port Missile Tubes"
	icon_state = "portmissile"
	fake_zlevel = 1 // upperdeck

/area/almayer/shipboard/weapon_room
	name = "\improper Lower Deck Weapon Control"
	icon_state = "weaponroom"
	fake_zlevel = 2 // lowerdeck

/area/almayer/shipboard/weapon_room/notunnel
	flags_area = AREA_NOTUNNEL
	requires_power = FALSE

/area/almayer/shipboard/starboard_point_defense
	name = "\improper Lower Deck Starboard Point Defense"
	icon_state = "starboardpd"
	fake_zlevel = 2 // lowerdeck

/area/almayer/shipboard/port_point_defense
	name = "\improper Lower Deck Port Point Defense"
	icon_state = "portpd"
	fake_zlevel = 2 // lowerdeck

/area/almayer/shipboard/stern_point_defense
	name = "\improper Lower Deck Stern Point Defense"
	icon_state = "portpd"
	fake_zlevel = 2 // lowerdeck

// brig

/area/almayer/shipboard/brig
	name = "\improper Brig"
	icon_state = "brig"
	fake_zlevel = 1 //upperdeck

/area/almayer/shipboard/brig/lobby
	name = "\improper Brig Lobby"

/area/almayer/shipboard/brig/armory
	name = "\improper Brig Armory"

/area/almayer/shipboard/brig/mp_bunks
	name = "\improper Brig MP Bunks"

/area/almayer/shipboard/brig/starboard_hallway
	name = "\improper Brig Starboard Hallway"

/area/almayer/shipboard/brig/perma
	name = "\improper Brig Perma Cells"

/area/almayer/shipboard/brig/cryo
	name = "\improper Brig Cryo Pods"

/area/almayer/shipboard/brig/medical
	name = "\improper Brig Medical"

/area/almayer/shipboard/brig/interrogation
	name = "\improper Brig Interrogation Room"

/area/almayer/shipboard/brig/general_equipment
	name = "\improper Brig General Equipment"

/area/almayer/shipboard/brig/evidence_storage
	name = "\improper Brig Evidence Storage"

/area/almayer/shipboard/brig/execution
	name = "\improper Brig Execution Room"

/area/almayer/shipboard/brig/execution_storage
	name = "\improper Brig Execution Storage"

/area/almayer/shipboard/brig/cic_hallway
	name = "\improper Brig CiC Hallway"

/area/almayer/shipboard/brig/dress
	name = "\improper CIC Dress Uniform Room"

/area/almayer/shipboard/brig/processing
	name = "\improper Brig Processing and Holding"

/area/almayer/shipboard/brig/cells
	name = "\improper Brig Cells"
	icon_state = "brigcells"

/area/almayer/shipboard/brig/chief_mp_office
	name = "\improper Brig Chief MP Office"
	icon_state = "chiefmpoffice"

/area/almayer/shipboard/brig/warden_office
	name = "\improper Brig Warden Office"
	icon_state = "chiefmpoffice"

/area/almayer/shipboard/sea_office
	name = "\improper Lower Deck Senior Enlisted Advisor Office"
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

/area/almayer/hallways/hangar
	name = "\improper Hangar"
	icon_state = "hangar"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_HANGAR
	soundscape_interval = 50

/area/almayer/hallways/lower
	fake_zlevel = 2 // lowerdeck

/area/almayer/hallways/lower/vehiclehangar
	name = "\improper Lower Deck Vehicle Storage"
	icon_state = "exoarmor"

/area/almayer/hallways/lower/repair_bay
	name = "\improper Lower Deck Deployment Workshop"
	icon_state = "dropshiprepair"

/area/almayer/hallways/lower/starboard_umbilical
	name = "\improper Lower Deck Starboard Umbilical Hallway"
	icon_state = "starboardumbilical"

/area/almayer/hallways/lower/port_umbilical
	name = "\improper Lower Deck Port Umbilical Hallway"
	icon_state = "portumbilical"

//port
/area/almayer/hallways/lower/port_fore_hallway
	name = "\improper Lower Deck Port-Fore Hallway"
	icon_state = "port"

/area/almayer/hallways/lower/port_midship_hallway
	name = "\improper Lower Deck Port-Midship Hallway"
	icon_state = "port"

/area/almayer/hallways/lower/port_aft_hallway
	name = "\improper Lower Deck Port-Aft Hallway"
	icon_state = "port"

//starboard
/area/almayer/hallways/lower/starboard_fore_hallway
	name = "\improper Lower Deck Starboard-Fore Hallway"
	icon_state = "starboard"

/area/almayer/hallways/lower/starboard_midship_hallway
	name = "\improper Lower Deck Starboard-Midship Hallway"
	icon_state = "starboard"

/area/almayer/hallways/lower/starboard_aft_hallway
	name = "\improper Lower Deck Starboard-Aft Hallway"
	icon_state = "starboard"

/area/almayer/hallways/upper
	fake_zlevel = 1 // upperdeck

/area/almayer/hallways/upper/aft_hallway
	name = "\improper Upper Deck Aft Hallway"
	icon_state = "aft"

/area/almayer/hallways/upper/fore_hallway
	name = "\improper Upper Deck Fore Hallway"
	icon_state = "stern"

/area/almayer/hallways/upper/midship_hallway
	name = "\improper Upper Deck Midship Hallway"
	icon_state = "stern"

/area/almayer/hallways/upper/port
	name = "\improper Upper Deck Port Hallway"
	icon_state = "port"

/area/almayer/hallways/upper/starboard
	name = "\improper Upper Deck Starboard Hallway"
	icon_state = "starboard"

//area that are used for transition between decks.
/area/almayer/stair_clone
	name = "\improper Stairs"
	icon_state = "stairs_lowerdeck"
	resin_construction_allowed = FALSE

/area/almayer/stair_clone/lower
	name = "\improper Lower Deck Stairs"
	icon_state = "stairs_upperdeck"
	fake_zlevel = 2 // lowerdeck

/area/almayer/stair_clone/lower/starboard_aft
	name = "\improper Lower Deck Starboard Aft Stairs"

/area/almayer/stair_clone/lower/port_aft
	name = "\improper Lower Deck Port Aft Stairs"

/area/almayer/stair_clone/lower/starboard_fore
	name = "\improper Lower Deck Starboard Fore Stairs"

/area/almayer/stair_clone/lower/port_fore
	name = "\improper Lower Deck Port Fore Stairs"

/area/almayer/stair_clone/upper
	name = "\improper Upper Deck Stairs"
	icon_state = "stairs_upperdeck"
	fake_zlevel = 1 // upperdeck

/area/almayer/stair_clone/upper/starboard_aft
	name = "\improper Upper Deck Starboard Aft Stairs"

/area/almayer/stair_clone/upper/port_aft
	name = "\improper Upper Deck Port Aft Stairs"

/area/almayer/stair_clone/upper/starboard_fore
	name = "\improper Upper Deck Starboard Fore Stairs"

/area/almayer/stair_clone/upper/port_fore
	name = "\improper Upper Deck Port Fore Stairs"

// maintenance areas

/area/almayer/maint

//lower maintenance areas

/area/almayer/maint/lower
	name = "\improper Lower Deck Maintenance"
	icon_state = "lowerhull"
	fake_zlevel = 2 // lowerdeck

/area/almayer/maint/lower/constr
	name = "\improper Lower Deck Construction Site"

/area/almayer/maint/lower/s_bow
	name = "\improper Lower Deck Starboard-Bow Maintenance"

/area/almayer/maint/lower/cryo_cells
	name = "\improper Lower Deck Cryo Cells Maintenance"

// Upper maintainance areas
/area/almayer/maint/upper
	name = "\improper Upper Deck Maintenance"
	icon_state = "upperhull"
	fake_zlevel = 1 // upperdeck

/area/almayer/maint/upper/mess
	name = "\improper Upper Deck Mess Maintenance"

/area/almayer/maint/upper/u_m_p
	name = "\improper Upper Deck Port-Midship Maintenance"

/area/almayer/maint/upper/u_m_s
	name = "\improper Upper Deck Starboard-Midship Maintenance"

/area/almayer/maint/upper/u_f_p
	name = "\improper Upper Deck Port-Fore Maintenance"

/area/almayer/maint/upper/u_f_s
	name = "\improper Upper Deck Starboard-Fore Maintenance"

/area/almayer/maint/upper/u_a_p
	name = "\improper Upper Deck Port-Aft Maintenance"

/area/almayer/maint/upper/u_a_s
	name = "\improper Upper Deck Starboard-Aft Maintenance"

// hull areas
/area/almayer/maint/hull

// lower deck hull areas
/area/almayer/maint/hull/lower
	name = "\improper Lower Deck Hull"
	icon_state = "lowerhull"
	fake_zlevel = 2 // lowerdeck
// stairs.

/area/almayer/maint/hull/lower/stairs
	name = "\improper Lower Deck Stairs Hull"

/area/almayer/maint/hull/lower/stern
	name = "\improper Lower Deck Stern Hull"

/area/almayer/maint/hull/lower/p_bow
	name = "\improper Lower Deck Port-Bow Hull"

/area/almayer/maint/hull/lower/lower_astronav
	name = "\improper Lower Deck Weapons Control Maintenance"

/area/almayer/maint/hull/lower/s_bow
	name = "\improper Lower Deck Starboard-Bow Hull"

/area/almayer/maint/hull/lower/l_f_s
	name = "\improper Lower Deck Starboard-Fore Hull"

/area/almayer/maint/hull/lower/l_m_s
	name = "\improper Lower Deck Starboard-Midship Hull"

/area/almayer/maint/hull/lower/l_a_s
	name = "\improper Lower Deck Starboard-Aft Hull"

/area/almayer/maint/hull/lower/l_f_p
	name = "\improper Lower Deck Port-Fore Hull"

/area/almayer/maint/hull/lower/l_m_p
	name = "\improper Lower Deck Port-Midship Hull"

/area/almayer/maint/hull/lower/l_a_p
	name = "\improper Lower Deck Port-Aft Hull"

// upper deck hull areas

/area/almayer/maint/hull/upper
	name = "\improper Upper Deck Hull"
	icon_state = "upperhull"
	fake_zlevel = 1 // upperdeck

// Stairs.
/area/almayer/maint/hull/upper/stairs
	name = "\improper Upper Deck Stairs Hull"

/area/almayer/maint/hull/upper/p_bow
	name = "\improper Upper Deck Port-Bow Hull"

/area/almayer/maint/hull/upper/s_bow
	name = "\improper Upper Deck Starboard-Bow Hull"

/area/almayer/maint/hull/upper/p_stern
	name = "\improper Upper Deck Port-Stern Hull"

/area/almayer/maint/hull/upper/s_stern
	name = "\improper Upper Deck Starboard-Stern Hull"

/area/almayer/maint/hull/upper/u_f_s
	name = "\improper Upper Deck Starboard-Fore Hull"

/area/almayer/maint/hull/upper/u_m_s
	name = "\improper Upper Deck Starboard-Midship Hull"

/area/almayer/maint/hull/upper/u_a_s
	name = "\improper Upper Deck Starboard-Aft Hull"

/area/almayer/maint/hull/upper/u_f_p
	name = "\improper Upper Deck Port-Fore Hull"

/area/almayer/maint/hull/upper/u_m_p
	name = "\improper Upper Deck Port-Midship Hull"

/area/almayer/maint/hull/upper/u_a_p
	name = "\improper Upper Deck Port-Aft Hull"

/area/almayer/living
	minimap_color = MINIMAP_AREA_COLONY

/area/almayer/living/tankerbunks
	name = "\improper Lower Deck Vehicle Crew Bunks"
	icon_state = "livingspace"
	fake_zlevel = 2

/area/almayer/living/cryo_cells
	name = "\improper Lower Deck Cryo Cells"
	icon_state = "cryo"
	fake_zlevel = 2 // lowerdeck

/area/almayer/living/briefing
	name = "\improper Briefing Area"
	icon_state = "briefing"
	fake_zlevel = 2 // lowerdeck

/area/almayer/living/port_emb
	name = "\improper Lower Deck Port Extended Mission Bunks"
	icon_state = "portemb"
	fake_zlevel = 2 // lowerdeck

/area/almayer/living/starboard_emb
	name = "\improper Lower Deck Starboard Extended Mission Bunks"
	icon_state = "starboardemb"
	fake_zlevel = 2 // lowerdeck

/area/almayer/living/port_garden
	name = "\improper Port Garden"
	icon_state = "portemb"
	fake_zlevel = 1 // upperdeck

/area/almayer/living/starboard_garden
	name = "\improper Starboard Garden"
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
	name = "\improper Upper Deck Officer's Lounge"
	icon_state = "officerrnr"
	fake_zlevel = 1 // upperdeck

/area/almayer/living/officer_study
	name = "\improper Upper Deck Officer's Study"
	icon_state = "officerstudy"
	fake_zlevel = 1 // upperdeck

/area/almayer/living/auxiliary_officer_office
	name = "\improper Upper Deck Auxiliary Support Officer office"
	icon_state = "livingspace"
	fake_zlevel = 1 // upperdeck

/area/almayer/living/intel
	name = "\improper Intelligence Officer's Bunks"
	icon_state = "livingspace"
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
	name = "\improper Lower Deck Gym"
	icon_state = "officerrnr"
	fake_zlevel = 2 // lowerdeck

/area/almayer/living/cafeteria_officer
	name = "\improper Upper Deck Officer Cafeteria"
	icon_state = "food"
	fake_zlevel = 1 // upperdeck

/area/almayer/living/offices
	name = "\improper Lower Deck Conference Office"
	icon_state = "briefing"
	fake_zlevel = 2 // lowerdeck

/area/almayer/living/offices/cryo
	name = "\improper Support Crew Cryogenics Bay"
	icon_state = "cryo"
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
	name = "\improper Upper Deck Synthetic Storage Closet"
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

/area/almayer/medical
	minimap_color = MINIMAP_AREA_MEDBAY

/area/almayer/medical/lower_medical_lobby
	name = "\improper Medical Lower Lobby"
	icon_state = "medical"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 120

/area/almayer/medical/upper_medical
	name = "\improper Medical Upper"
	icon_state = "medical"
	fake_zlevel = 1 // upperdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 120

/area/almayer/medical/morgue
	name = "\improper Morgue"
	icon_state = "operating"
	fake_zlevel = 1 // upperdeck

/area/almayer/medical/operating_room_one
	name = "\improper Medical Operating Room 1"
	icon_state = "operating"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 120

/area/almayer/medical/operating_room_two
	name = "\improper Medical Operating Room 2"
	icon_state = "operating"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 120

/area/almayer/medical/operating_room_three
	name = "\improper Medical Operating Room 3"
	icon_state = "operating"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 120

/area/almayer/medical/operating_room_four
	name = "\improper Medical Operating Room 4"
	icon_state = "operating"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 120

/area/almayer/medical/medical_science
	name = "\improper Medical Research laboratories"
	icon_state = "science"
	fake_zlevel = 1 // upperdeck

/area/almayer/medical/hydroponics
	name = "\improper Medical Research hydroponics"
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
	name = "\improper Storage Room"

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
	soundscape_interval = 120

/area/almayer/medical/lower_medical_medbay
	name = "\improper Medical Lower Medbay"
	icon_state = "medical"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 120

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
	hijack_evacuation_area = TRUE
	hijack_evacuation_weight = 0.1
	hijack_evacuation_type = EVACUATION_TYPE_ADDITIVE

/area/almayer/lifeboat_pumps/north1
	name = "Starboard-Fore Lifeboat Fuel Pump"

/area/almayer/lifeboat_pumps/north2
	name = "Starboard-Aft Lifeboat Fuel Pump"

/area/almayer/lifeboat_pumps/south1
	name = "Port-Fore Lifeboat Fuel Pump"

/area/almayer/lifeboat_pumps/south2
	name = "Port-Aft Lifeboat Fuel Pump"

/area/almayer/command/lifeboat
	name = "\improper Lifeboat Docking Port"
	icon_state = "selfdestruct"
	fake_zlevel = 1 // upperdeck

/area/space/almayer/lifeboat_dock
	name = "\improper Port Lifeboat Docking"
	icon_state = "lifeboat"
	fake_zlevel = 1 // upperdeck
	flags_area = AREA_NOTUNNEL

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

//Mid-Deck

/area/almayer/middeck
	name = "USS Almayer - Middle Deck"
	allow_construction = FALSE
	icon_state = "lowerhull"

/area/almayer/middeck/hanger
	name = "Middle Deck - Hangerbay Catwalks"
	icon_state = "hangar"

/area/almayer/middeck/medical
	name = "Middle Deck - Medical Catwalks"
	icon_state = "medical"

/area/almayer/middeck/engineer
	name = "Middle Deck - Engineering Catwalks"
	icon_state = "workshop"

/area/almayer/middeck/req
	name = "Middle Deck - Requisition Catwalks"
	icon_state = "req"

/area/almayer/middeck/briefing
	name = "Middle Deck - Briefing Catwalks"
	icon_state = "briefing"

/area/almayer/middeck/maintenance
	name = "\improper Middle Deck Maintenance - Parent"

//Bow

/area/almayer/middeck/maintenance/bow
	name = "\improper Middle Deck Maintenance - Bow"

/area/almayer/middeck/maintenance/pb
	name = "\improper Middle Deck Maintenance - Port-Bow"

/area/almayer/middeck/maintenance/sb
	name = "\improper Middle Deck Maintenance - Starboard-Bow"

//Fore

/area/almayer/middeck/maintenance/amidship
	name = "\improper Middle Deck Maintenance - Amidship"

/area/almayer/middeck/maintenance/sf
	name = "\improper Middle Deck Maintenance - Starboard-Fore"

/area/almayer/middeck/maintenance/sp
	name = "\improper Middle Deck Maintenance - Port-Fore"

//Aft

/area/almayer/middeck/maintenance/aft
	name = "\improper Middle Deck Maintenance - Aft"

/area/almayer/middeck/maintenance/saft
	name = "\improper Middle Deck Maintenance - Starboard-Aft"

/area/almayer/middeck/maintenance/paft
	name = "\improper Middle Deck Maintenance - Port-Aft"

//Admin Lower Level

/area/almayer/underdeck/
	name = "USS Almayer - Under Deck"
	allow_construction = FALSE
	icon_state = "lowerhull"

/area/almayer/underdeck/hangar
	name = "USS Almayer - Under Deck Hangar"
	icon_state = "hangar"

/area/almayer/underdeck/req
	name = "USS Almayer - Under Deck Cargo"
	icon_state = "req"

/area/almayer/underdeck/vehicle
	name = "USS Almayer - Under Deck Vehicle Bay"
	icon_state = "req"
