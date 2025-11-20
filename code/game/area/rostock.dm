//ROSTOCK AREAS (Different to Almayer)--------------------------------------//
// Fore = East  | Aft = West //
// Port = North | Starboard = South //
// Bow = Eastern |Stern = Western //(those are the front and back small sections)
// Naming convention is to start by port or starboard then put eitheir (bow,fore,midship,aft,stern)

/area/rostock
	name = "SSV Rostock"
	icon = 'icons/turf/area_almayer.dmi'
	// ambience = list('sound/ambience/shipambience.ogg')
	icon_state = "almayer"
	flags_area = AREA_NOTUNNEL
//	requires_power = TRUE
//	unlimited_power = TRUE
	ceiling = CEILING_METAL
	powernet_name = "rostock"
	sound_environment = SOUND_ENVIRONMENT_ROOM
	soundscape_interval = 30
	// soundscape_playlist = list('sound/effects/xylophone1.ogg', 'sound/effects/xylophone2.ogg', 'sound/effects/xylophone3.ogg')
	ambience_exterior = AMBIENCE_ALMAYER
	ceiling_muffle = FALSE

// Upper Deck Misc
/area/rostock/upper_deck
	fake_zlevel = 1 // upperdeck

/area/rostock/upper_deck/hallway
	name = "SSV Rostock - Upper Deck Midship Hallway"
	icon_state = "stern"

// Hanger Deck

/area/rostock/hangar
	fake_zlevel = 1 // upperdeck

/area/rostock/hangar/hangarbay
	name = "SSV Rostock - Hangar"
	icon_state = "hangar"
	soundscape_playlist = SCAPE_PL_HANGAR
	soundscape_interval = 50

/area/rostock/hangar/pilotbunk
	name = "SSV Rostock - Pilot Cryogenics"
	icon_state = "livingspace"

/area/rostock/hangar/repairbay
	name = "SSV Rostock - Dropship Repair Bay"
	icon_state = "dropshiprepair"

// Medical Deck (Upper/Lower)

/area/rostock/medical

/area/rostock/medical/lobby
	name = "SSV Rostock - Medbay Lobby"
	icon_state = "medical"
	fake_zlevel = 1 // upperdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 120

/area/rostock/medical/storage
	name = "SSV Rostock - Deployment Storage"
	icon_state = "medical"
	fake_zlevel = 1 // upperdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 120

/area/rostock/medical/surgery
	name = "SSV Rostock - Operating Theatre"
	icon_state = "operating"
	fake_zlevel = 1 // upperdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 120

/area/rostock/medical/chemistry
	name = "SSV Rostock - Chemical Laboratory"
	icon_state = "chemistry"
	fake_zlevel = 1 // upperdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 120

/area/rostock/medical/accessway
	name = "SSV Rostock - Rear Corridor"
	icon_state = "medical"
	fake_zlevel = 1 // upperdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 120

/area/rostock/medical/prep
	name = "SSV Rostock - Medical Preperation Room"
	icon_state = "medical"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
	soundscape_interval = 120

/area/rostock/medical/morgue
	name = "SSV Rostock - Morgue"
	icon_state = "medical"
	fake_zlevel = 2 // lowerdeck

// Military Police Deck (Upper/Lower)

/area/rostock/security

/area/rostock/security/brig_accessway
	name = "SSV Rostock - Brig Accessway"
	icon_state = "brig"
	fake_zlevel = 1 //upperdeck

/area/rostock/security/brig_entryway
	name = "SSV Rostock - Brig Observation Area"
	icon_state = "brig"
	fake_zlevel = 1 //upperdeck

/area/rostock/security/brig_holding_area
	name = "SSV Rostock - Prisoner Holding Area"
	icon_state = "brigcells"
	fake_zlevel = 1 //upperdeck

/area/rostock/security/execution_room
	name = "SSV Rostock - Execution Room"
	icon_state = "brigcells"
	fake_zlevel = 1 //upperdeck

/area/rostock/security/execution_storage
	name = "SSV Rostock - Execution Storage Room"
	icon_state = "brigcells"
	fake_zlevel = 1 //upperdeck

/area/rostock/security/brig_office
	name = "SSV Rostock - Brig Office"
	icon_state = "brig"
	fake_zlevel = 1 //upperdeck

/area/rostock/security/headquarters_lobby
	name = "SSV Rostock - Politsiya HQ Lobby"
	icon_state = "brig"
	fake_zlevel = 2 //upperdeck

/area/rostock/security/headquarters_interrogation
	name = "SSV Rostock - Interrogation Room"
	icon_state = "brig"
	fake_zlevel = 2 //upperdeck

/area/rostock/security/headquarters_bunk
	name = "SSV Rostock - Politsiya Bunks"
	icon_state = "brig"
	fake_zlevel = 2 //upperdeck

/area/rostock/security/headquarters_storage
	name = "SSV Rostock - Politsiya Equipment Storage"
	icon_state = "brig"
	fake_zlevel = 2 //upperdeck

/area/rostock/security/headquarters_armory
	name = "SSV Rostock - Politsiya Armory"
	icon_state = "brig"
	fake_zlevel = 2 //upperdeck

// Vehicle Storage

/area/rostock/vehiclehangar
	name = "SSV Rostock - Vehicle Hangar"
	icon_state = "exoarmor"
	fake_zlevel = 2 //upperdeck

// Engineering Deck

/area/rostock/engineering

/area/rostock/engineering/main_area
	name = "SSV Rostock - Engineering"
	icon_state = "upperengineering"
	fake_zlevel = 1 //upperdeck

/area/rostock/engineering/reactor
	name = "SSV Rostock - Reactor Core"
	icon_state = "upperengineering"
	fake_zlevel = 1 //upperdeck

/area/rostock/engineering/lower_aft_corridor
	name = "SSV Rostock - Upper Aft Entrance Corridor"
	icon_state = "upperengineering"
	fake_zlevel = 1 //upperdeck

/area/rostock/engineering/port_aft_accessway
	name = "SSV Rostock - Port Aft Accessway"
	icon_state = "upperengineering"
	fake_zlevel = 1 //upperdeck

/area/rostock/engineering/starboard_aft_accessway
	name = "SSV Rostock - Starboard Aft Accessway"
	icon_state = "upperengineering"
	fake_zlevel = 1 //upperdeck

// Upperdeck Maintenance

/area/rostock/upperdeck_maint
	fake_zlevel = 1 //upperdeck

/area/rostock/upperdeck_maint/p_a
	name = "SSV Rostock - Upper Port-Aft Maintenance"
	icon_state = "upperhull"

/area/rostock/upperdeck_maint/p_m
	name = "SSV Rostock - Upper Port-Midship Maintenance"
	icon_state = "upperhull"

/area/rostock/upperdeck_maint/p_f
	name = "SSV Rostock - Upper Port-Fore Maintenance"
	icon_state = "upperhull"

/area/rostock/upperdeck_maint/s_a
	name = "SSV Rostock - Upper Starboard-Aft Maintenance"
	icon_state = "upperhull"

/area/rostock/upperdeck_maint/s_m
	name = "SSV Rostock - Upper Starboard-Midship Maintenance"
	icon_state = "upperhull"

/area/rostock/upperdeck_maint/s_f
	name = "SSV Rostock - Upper Starboard-Fore Maintenance"
	icon_state = "upperhull"

// ERT Docking Ports

/area/rostock/ert_dock

/area/rostock/ert_dock/port
	name = "SSV Rostock - Port Emergency Docking"
	icon_state = "starboardpd"
	fake_zlevel = 1 // upperdeck

/area/rostock/ert_dock/starboard
	name = "SSV Rostock - Starboard Emergency Docking"
	icon_state = "starboardpd"
	fake_zlevel = 1 // upperdeck

// Stairs
/area/rostock/stair_clone
	name = "SSV Rostock - Lower Deck Stairs"
	icon_state = "stairs_lowerdeck"
	fake_zlevel = 2 // lowerdeck
	resin_construction_allowed = FALSE
	requires_power = FALSE

/area/rostock/stair_clone/upper
	name = "SSV Rostock - Upper Deck Stairs"
	icon_state = "stairs_upperdeck"
	fake_zlevel = 1 // upperdeck

// Command

/area/rostock/command

/area/rostock/command/astronavigation
	name = "SSV Rostock - Astronavigational Deck"
	icon_state = "astronavigation"
	fake_zlevel = 2 // lowerdeck

/area/rostock/command/cic
	name = "SSV Rostock - Combat Information Centre"
	icon_state = "cic"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_CIC
	soundscape_interval = 50
	flags_area = AREA_NOTUNNEL

/area/rostock/command/armory
	name = "SSV Rostock - Command Armory"
	icon_state = "cic"
	fake_zlevel = 2 // lowerdeck

/area/rostock/command/hallway
	name = "SSV Rostock - Command Hallway"
	icon_state = "cic"
	fake_zlevel = 2 // lowerdeck

/area/rostock/command/dining
	name = "SSV Rostock - Command Dining Hall"
	icon_state = "cic"
	fake_zlevel = 2 // lowerdeck

/area/rostock/command/co
	name = "SSV Rostock - Commanding Officer's Quarters"
	icon_state = "officerrnr"
	fake_zlevel = 2 // lowerdeck

/area/rostock/command/xo
	name = "SSV Rostock - Kapitan's Quarter's"
	icon_state = "officerrnr"
	fake_zlevel = 2 // lowerdeck

/area/rostock/command/polcom
	name = "SSV Rostock - Political Officer's Quarters"
	icon_state = "officerrnr"
	fake_zlevel = 2 // lowerdeck

/area/rostock/command/so
	name = "SSV Rostock - Staff Officer's Bunks"
	icon_state = "officerrnr"
	fake_zlevel = 2 // lowerdeck

// Lower Deck Misc

/area/rostock/lower_deck
	fake_zlevel = 2 // lowerdeck

/area/rostock/lower_deck/m_hallway
	name = "SSV Rostock - Lower Deck Midship Hallway"
	icon_state = "stern"

/area/rostock/lower_deck/p_hallway
	name = "SSV Rostock - Lower Deck Port Hallway"
	icon_state = "port"

/area/rostock/lower_deck/s_a_hallway
	name = "SSV Rostock - Lower Deck Starboard-Aft Hallway"
	icon_state = "starboard"

/area/rostock/lower_deck/p_a_hallway
	name = "SSV Rostock - Lower Deck Port-Aft Hallway"
	icon_state = "port"

/area/rostock/lower_deck/engineering_lower_access
	name = "SSV Rostock - Lower Deck Engineering Starboard Aft Accessway"
	icon_state = "port"

/area/rostock/lower_deck/cryogenics
	name = "SSV Rostock - Cryogenic Cells"
	icon_state = "cryo"

/area/rostock/lower_deck/prep
	name = "SSV Rostock - Troop Preperation"
	icon_state = "gruntrnr"

/area/rostock/lower_deck/bunk
	name = "SSV Rostock - Extended Mission Bunks"
	icon_state = "gruntrnr"

/area/rostock/lower_deck/kitchen
	name = "SSV Rostock - Meal Hall"
	icon_state = "gruntrnr"

/area/rostock/lower_deck/bathroom
	name = "SSV Rostock - Unisex Bathroom"
	icon_state = "missionplanner"

/area/rostock/lower_deck/ammunition_storage
	name = "SSV Rostock - Heavy Ordinance Storage"
	icon_state = "missionplanner"

/area/rostock/lower_deck/briefing
	name = "SSV Rostock - Briefing Hall"
	icon_state = "briefing"

/area/rostock/lower_deck/starboard_umbilical
	name = "\improper Lower Deck Starboard Umbilical Hallway"
	icon_state = "portumbilical"

// Lower Deck Maintenance

/area/rostock/lowerdeck_maint
	fake_zlevel = 2 //lowerdeck

/area/rostock/lowerdeck_maint/p_a
	name = "SSV Rostock - Lower Port-Aft Maintenance"
	icon_state = "lowerhull"

/area/rostock/lowerdeck_maint/p_m
	name = "SSV Rostock - Lower Port-Midship Maintenance"
	icon_state = "lowerhull"

/area/rostock/lowerdeck_maint/p_f
	name = "SSV Rostock - Lower Port-Fore Maintenance"
	icon_state = "lowerhull"

/area/rostock/lowerdeck_maint/s_a
	name = "SSV Rostock - Lower Starboard-Aft Maintenance"
	icon_state = "lowerhull"

/area/rostock/lowerdeck_maint/s_m
	name = "SSV Rostock - Lower Starboard-Midship Maintenance"
	icon_state = "lowerhull"

/area/rostock/lowerdeck_maint/s_f
	name = "SSV Rostock - Lower Starboard-Fore Maintenance"
	icon_state = "lowerhull"

// Railguns

/area/rostock/railgun
	name = "SSV Rostock - Port Railgun Control Room"
	icon_state = "weaponroom"

/area/rostock/railgun/starboard
	name = "SSV Rostock - Starboard Railgun Control Room"
	icon_state = "weaponroom"

// AI Core - 1VAN/3

/area/rostock/airoom
	name = "SSV Rostock - AI Core"
	icon_state = "airoom"
	fake_zlevel = 2 // lowerdeck
	soundscape_playlist = SCAPE_PL_ARES
	soundscape_interval = 120
	flags_area = AREA_NOTUNNEL|AREA_UNWEEDABLE
	can_build_special = FALSE
	is_resin_allowed = FALSE
	resin_construction_allowed = FALSE

// Requisitions Bay

/area/rostock/req
	name = "SSV Rostock - Requisitions"
	icon_state = "req"
	fake_zlevel = 2 // lowerdeck

// Lifeboat

/area/rostock/lifeboat
	name = "SSV Rostock - Lifeboat Docking Port"
	icon_state = "selfdestruct"
	fake_zlevel = 2 // lowerdeck

