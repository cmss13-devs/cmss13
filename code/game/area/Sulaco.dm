//SULACO AREAS--------------------------------------//
/area/ship/sulaco
	icon = 'icons/turf/area_almayer.dmi'
	icon_state = "almayer"
	powernet_name = "almayer"
	sound_environment = SOUND_ENVIRONMENT_ROOM
	soundscape_interval = 30
	ambience_exterior = AMBIENCE_ALMAYER

/area/ship/sulaco/Initialize(mapload, ...)
	. = ..()

	if(hijack_evacuation_area)
		SShijack.progress_areas[src] = power_equip

/area/ship/sulaco/bridge
	name = "\improper Sulaco Bridge"
	icon_state = "cic"
	fake_zlevel = 1 //upperdeck
	hijack_evacuation_area = TRUE
	hijack_evacuation_weight = 1.1
	hijack_evacuation_type = EVACUATION_TYPE_MULTIPLICATIVE

/area/ship/sulaco/bridge/quarters
	name = "\improper Sulaco Officer's Quarters"
	icon_state = "livingspace"
	fake_zlevel = 1 //upperdeck
	hijack_evacuation_area = FALSE

/area/ship/sulaco/bridge/office
	name = "\improper Sulaco Executive's Office"
	icon_state = "livingspace"
	fake_zlevel = 1 //upperdeck
	hijack_evacuation_area = FALSE

/area/ship/sulaco/cap_office
	name = "\improper Sulaco Captain's Office"
	icon_state = "livingspace"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/bridge/maint
	name = "\improper Sulaco Bridge Maintenance"
	icon_state = "upperhull"
	fake_zlevel = 1 //upperdeck
	hijack_evacuation_area = FALSE

/area/ship/sulaco/medbay
	name = "\improper Sulaco Medbay"
	icon_state = "medical"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/medbay/storage
	name = "\improper Sulaco Medbay Storage"
	icon_state = "medical"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/medbay/storage2
	name = "\improper Sulaco Medbay Storage"
	icon_state = "medical"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/medbay/west
	name = "\improper Sulaco Medbay West"
	icon_state = "medical"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/medbay/hangar
	name = "\improper Sulaco Medbay Hangar"
	icon_state = "medical"
	fake_zlevel = 2 //lowerdeck

/area/ship/sulaco/medbay/surgery_one
	name = "\improper Sulaco Operating Theatre I"
	icon_state = "operating"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/medbay/surgery_two
	name = "\improper Sulaco Operating Theatre II"
	icon_state = "operating"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/medbay/chemistry
	name = "\improper Sulaco Chemistry"
	icon_state = "chemistry"
	fake_zlevel = 2 //lowerdeck

/area/ship/sulaco/disposal
	name = "\improper Sulaco Disposal"
	icon_state = "upperhull"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/brig
	name = "\improper Sulaco Brig"
	icon_state = "brig"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/solar
	name = "Sulaco Solar Array"
	requires_power = 1
	always_unpowered = 1
	luminosity = 1

/area/ship/sulaco/solar/south
	icon_state = "panelsA"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/solar/north
	icon_state = "panelsP"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/hallway
	name = "\improper Sulaco Hallway"
	icon_state = "hallC1"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/hallway/central_hall
	name = "\improper Sulaco Central Hallway"
	icon_state = "aft"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/hallway/central_hall2
	name = "\improper Sulaco Central Hallway"
	icon_state = "stern"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/hallway/central_hall3
	name = "\improper Sulaco Central Hallway"
	icon_state = "stern"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/hallway/lower_main_hall
	name = "\improper Sulaco Main Hallway"
	icon_state = "aft"
	fake_zlevel = 2 //lowerdeck

/area/ship/sulaco/briefing
	name = "\improper Sulaco Briefing Room"
	icon_state = "briefing"
	fake_zlevel = 1 //upperdeck


/area/ship/sulaco/cryosleep
	name = "\improper Sulaco Cryogenic Storage"
	icon_state = "cryo"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/showers
	name = "\improper Sulaco Showers"
	icon_state = "livingspace"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/cafeteria
	name = "\improper Sulaco Cafeteria"
	icon_state = "gruntrnr"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/cargo
	name = "\improper Sulaco Main Cargo Bay"
	icon_state = "req"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/ob_aa_cannon
	name = "\improper Sulaco OB and AA Cannon"
	icon_state = "weapon_room"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/cargo/office
	name = "\improper Sulaco Cargo Office"
	icon_state = "req"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/maintenance
	name = "\improper Sulaco Maintenance"
	icon_state = "upperhull"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/engineering
	name = "\improper Sulaco Engineering"
	icon_state = "workshop"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/engineering/storage
	name = "\improper Sulaco Engineering Storage"
	icon_state = "workshop"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/engineering/ce
	name = "\improper Sulaco Chief's Office"
	icon_state = "ceroom"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/engineering/atmos
	name = "\improper Sulaco Atmospherics"
	icon_state = "lifesupport"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/engineering/engine
	name = "\improper Sulaco Engine Chamber"
	icon_state = "coreroom"
	fake_zlevel = 1 //upperdeck
	hijack_evacuation_area = TRUE
	hijack_evacuation_weight = 0.2
	hijack_evacuation_type = EVACUATION_TYPE_ADDITIVE

/area/ship/sulaco/engineering/smes
	name = "\improper Sulaco Engineering SMES"
	icon_state = "coreroom"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/marine
	name = "\improper Sulaco Marine Prep"
	icon_state = "ab_shared"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/marine/alpha
	name = "\improper Sulaco Alpha Marine Prep"
	icon_state = "alpha"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/marine/bravo
	name = "\improper Sulaco Bravo Marine Prep"
	icon_state = "bravo"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/marine/charlie
	name = "\improper Sulaco Charlie Marine Prep"
	icon_state = "charlie"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/marine/delta
	name = "\improper Sulaco Delta Marine Prep"
	icon_state = "delta"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/command/armory
	name = "\improper Sulaco Secure Armory"
	icon_state = "weaponroom"
	fake_zlevel = 2 //lowerdeck

/area/ship/sulaco/command/combat_correspondent
	name = "\improper Sulaco Combat Correspondent Office"
	icon_state = "selfdestruct"
	fake_zlevel = 1 // upperdeck

/area/ship/sulaco/command/intelligence
	name = "\improper Sulaco Intelligence Office"
	icon_state = "corporatespace"
	fake_zlevel = 2 // lowerdeck

/area/ship/sulaco/command/sea
	name = "\improper Sulaco Senior Enlisted Advisor Office"
	icon_state = "chiefmpoffice"
	fake_zlevel = 2 // lowerdeck

/area/ship/sulaco/research
	name = "\improper Sulaco Research Division"
	icon_state = "science"
	fake_zlevel = 2 //lowerdeck

/area/ship/sulaco/telecomms
	name = "\improper Sulaco Telecomms Central"
	icon_state = "tcomms"
	fake_zlevel = 2 //lowerdeck

/area/ship/sulaco/telecomms/office
	name = "\improper Sulaco Telecomms Monitoring"
	icon_state = "tcomms"
	fake_zlevel = 2 //lowerdeck

/area/ship/sulaco/command/ai
	name = "\improper Sulaco AI Chamber"
	icon_state = "airoom"
	fake_zlevel = 2 //lowerdeck

/area/ship/sulaco/liaison
	name = "\improper Sulaco Liaison's Office"
	icon_state = "corporatespace"
	fake_zlevel = 2 //lowerdeck

/area/ship/sulaco/liaison/quarters
	name = "\improper Sulaco Liaison's Quarters"
	icon_state = "corporatespace"
	fake_zlevel = 2 //lowerdeck

/area/ship/sulaco/recroom
	name = "\improper Sulaco Rec Room"
	icon_state = "red"

/area/ship/sulaco/maintenance/lower_maint
	name = "\improper Sulaco Maintenance"
	icon_state = "exoarmor"
	fake_zlevel = 2 //lowerdeck

/area/ship/sulaco/morgue
	name = "\improper Sulaco Morgue"
	icon_state = "operating"
	fake_zlevel = 2 //lowerdeck

/area/ship/sulaco/hangar
	name = "\improper Sulaco Dropship Hangar"
	icon_state = "hangar"
	fake_zlevel = 2 //lowerdeck

/area/ship/sulaco/hangar/range
	name = "\improper Sulaco Firing Range"
	icon_state = "firingrange"
	fake_zlevel = 2 //lowerdeck

/area/ship/sulaco/hangar/atmos
	name = "\improper Sulaco Lower Atmospherics"
	icon_state = "lifesupport"
	fake_zlevel = 2 //lowerdeck

/area/ship/sulaco/command/eva
	name = "\improper Sulaco EVA Storage"
	icon_state = "stern"
	fake_zlevel = 1 //upperdeck

/area/ship/sulaco/maintenance/rear_maintenance
	name = "\improper Sulaco Lower Maintenance Deck"
	icon_state = "lowerhull"

/area/ship/sulaco/maintenance/north_solar_maint
	name = "\improper Sulaco Solar Maintenance Deck"
	icon_state = "upperhull"

/area/ship/sulaco/maintenance/south_solar_maint
	name = "\improper Sulaco Solar Maintenance Deck"
	icon_state = "upperhull"

/area/ship/sulaco/maintenance/lower_maint2
	name = "\improper Sulaco Maintenance"
	icon_state = "lowerhull"
	fake_zlevel = 2 //lowerdeck

/area/ship/sulaco/hub/top
	name = "\improper Sulaco Maintenance Hub"
	icon_state = "yellow"

/area/ship/sulaco/hub/bottom
	name = "\improper Sulaco Maintenance Hub"
	icon_state = "yellow"

/area/ship/sulaco/lifeboat_pumps
	name = "Lifeboat Fuel Pumps"
	icon_state = "lifeboat_pump"
	requires_power = 1
	fake_zlevel = 1
	hijack_evacuation_area = TRUE
	hijack_evacuation_weight = 0.1
	hijack_evacuation_type = EVACUATION_TYPE_ADDITIVE


/area/ship/sulaco/lifeboat_pumps/lower_north
	name = "Lower Deck Northern Lifeboat Fuel Pump"

/area/ship/sulaco/lifeboat_pumps/lower_south
	name = "Lower Deck Southern Lifeboat Fuel Pump"

/area/ship/sulaco/lifeboat_pumps/upper_north
	name = "Upper Deck Northern Lifeboat Fuel Pump"

/area/ship/sulaco/lifeboat_pumps/upper_south
	name = "Upper Deck Southern Lifeboat Fuel Pump"

/area/shuttle
	ceiling = CEILING_METAL
	requires_power = 0
	ambience_exterior = AMBIENCE_ALMAYER
	ceiling_muffle = FALSE

//Drop Pods
/area/shuttle/drop1
	//soundscape_playlist = list('sound/soundscape/drum1.ogg')
	soundscape_interval = 30 //seconds
	flags_area = AREA_NOBURROW
	is_landing_zone = TRUE
	ceiling = CEILING_REINFORCED_METAL
	base_lighting_alpha = 0

/area/shuttle/drop1/Enter(atom/movable/O, atom/oldloc)
	if(istype(O, /obj/structure/barricade))
		return FALSE
	return TRUE

/area/shuttle/drop1/sulaco
	name = "\improper Dropship Alamo"
	icon_state = "shuttlered"
	base_muffle = MUFFLE_HIGH
	base_lighting_alpha = 255
	is_resin_allowed = FALSE

/area/shuttle/drop1/LV624
	name = "\improper Dropship Alamo"
	ambience_exterior = AMBIENCE_LV624
	icon_state = "shuttle"

/area/shuttle/drop1/prison
	name = "\improper Dropship Alamo"
	ambience_exterior = AMBIENCE_PRISON
	icon_state = "shuttle"

/area/shuttle/drop1/BigRed
	name = "\improper Dropship Alamo"
	ambience_exterior = AMBIENCE_BIGRED
	icon_state = "shuttle"

/area/shuttle/drop1/ice_colony
	name = "\improper Dropship Alamo"
	icon_state = "shuttle"

/area/shuttle/drop1/DesertDam
	name = "\improper Dropship Alamo"
	ambience_exterior = AMBIENCE_TRIJENT
	icon_state = "shuttle"

/area/shuttle/drop1/transit
	ambience_exterior = 'sound/ambience/dropship_ambience_loop.ogg'
	name = "\improper Dropship Alamo Transit"
	icon_state = "shuttle2"

/area/shuttle/drop1/lz1
	name = "\improper Alamo Landing Zone"
	icon_state = "away1"




/area/shuttle/drop2
	//soundscape_playlist = list('sound/soundscape/drum1.ogg')
	soundscape_interval = 30 //seconds
	flags_area = AREA_NOBURROW
	is_landing_zone = TRUE
	ceiling = CEILING_REINFORCED_METAL
	base_lighting_alpha = 0

/area/shuttle/drop2/Enter(atom/movable/O, atom/oldloc)
	if(istype(O, /obj/structure/barricade))
		return FALSE
	return TRUE

/area/shuttle/drop2/sulaco
	name = "\improper Dropship Normandy"
	icon_state = "shuttle"
	base_muffle = MUFFLE_HIGH
	base_lighting_alpha = 255
	is_resin_allowed = FALSE

/area/shuttle/drop2/LV624
	name = "\improper Dropship Normandy"
	ambience_exterior = AMBIENCE_LV624
	icon_state = "shuttle2"

/area/shuttle/drop2/prison
	name = "\improper Dropship Normandy"
	ambience_exterior = AMBIENCE_PRISON
	icon_state = "shuttle2"

/area/shuttle/drop2/BigRed
	name = "\improper Dropship Normandy"
	ambience_exterior = AMBIENCE_BIGRED
	icon_state = "shuttle2"

/area/shuttle/drop2/ice_colony
	name = "\improper Dropship Normandy"
	icon_state = "shuttle2"

/area/shuttle/drop2/DesertDam
	name = "\improper Dropship Normandy"
	ambience_exterior = AMBIENCE_TRIJENT
	icon_state = "shuttle2"

/area/shuttle/drop2/transit
	ambience_exterior = 'sound/ambience/dropship_ambience_loop.ogg'
	name = "\improper Dropship Normandy Transit"
	icon_state = "shuttlered"

/area/shuttle/drop2/lz2
	name = "\improper Normandy Landing Zone"
	icon_state = "away2"

/area/shuttle/drop3
	//soundscape_playlist = list('sound/soundscape/drum1.ogg')
	soundscape_interval = 30 //seconds
	flags_area = AREA_NOBURROW
	is_landing_zone = TRUE
	ceiling = CEILING_REINFORCED_METAL
	base_lighting_alpha = 0

/area/shuttle/drop3/Enter(atom/movable/O, atom/oldloc)
	if(istype(O, /obj/structure/barricade))
		return FALSE
	return TRUE

/area/shuttle/drop3/sulaco
	name = "\improper Dropship Saipan"
	icon_state = "shuttle"
	base_muffle = MUFFLE_HIGH
	base_lighting_alpha = 255

/area/shuttle/drop3/LV624
	name = "\improper Dropship Saipan"
	ambience_exterior = AMBIENCE_LV624
	icon_state = "shuttle2"

/area/shuttle/drop3/prison
	name = "\improper Dropship Saipan"
	ambience_exterior = AMBIENCE_PRISON
	icon_state = "shuttle2"

/area/shuttle/drop3/BigRed
	name = "\improper Dropship Saipan"
	ambience_exterior = AMBIENCE_BIGRED
	icon_state = "shuttle2"

/area/shuttle/drop3/ice_colony
	name = "\improper Dropship Saipan"
	icon_state = "shuttle2"

/area/shuttle/drop3/DesertDam
	name = "\improper Dropship Saipan"
	ambience_exterior = AMBIENCE_TRIJENT
	icon_state = "shuttle2"

/area/shuttle/drop3/transit
	ambience_exterior = 'sound/ambience/dropship_ambience_loop.ogg'
	name = "\improper Dropship Saipan Transit"
	icon_state = "shuttlered"

/area/shuttle/drop3/lz3
	name = "\improper Saipan Landing Zone"
	icon_state = "away2"

//UPP DROPSHIP

/area/shuttle/drop_upp/Enter(atom/movable/O, atom/oldloc)
	if(istype(O, /obj/structure/barricade))
		return FALSE
	return TRUE

/area/shuttle/drop_upp
	soundscape_interval = 30 //seconds
	flags_area = AREA_NOBURROW
	is_landing_zone = TRUE
	ceiling = CEILING_REINFORCED_METAL
	base_lighting_alpha = 0

/area/shuttle/drop_upp/morana
	name = "\improper Dropship Morana"
	icon_state = "shuttle"
	base_muffle = MUFFLE_HIGH
	base_lighting_alpha = 255

/area/shuttle/drop_upp/LV624
	name = "\improper Dropship Morana"
	ambience_exterior = AMBIENCE_LV624
	icon_state = "shuttle2"

/area/shuttle/drop_upp/prison
	name = "\improper Dropship Morana"
	ambience_exterior = AMBIENCE_PRISON
	icon_state = "shuttle2"

/area/shuttle/drop_upp/BigRed
	name = "\improper Dropship Morana"
	ambience_exterior = AMBIENCE_BIGRED
	icon_state = "shuttle2"

/area/shuttle/drop_upp/ice_colony
	name = "\improper Dropship Morana"
	icon_state = "shuttle2"

/area/shuttle/drop_upp/DesertDam
	name = "\improper Dropship Morana"
	ambience_exterior = AMBIENCE_TRIJENT
	icon_state = "shuttle2"

/area/shuttle/drop_upp/transit
	ambience_exterior = 'sound/ambience/dropship_ambience_loop.ogg'
	name = "\improper Dropship Morana Transit"
	icon_state = "shuttlered"

/area/shuttle/drop_upp/lz_upp
	name = "\improper Morana Landing Zone"
	icon_state = "away2"

////

/area/shuttle/drop_upp2/devana
	name = "\improper Dropship Devana"
	icon_state = "shuttle"
	base_muffle = MUFFLE_HIGH
	base_lighting_alpha = 255

/area/shuttle/drop_upp2/LV624
	name = "\improper Dropship Devana"
	ambience_exterior = AMBIENCE_LV624
	icon_state = "shuttle2"

/area/shuttle/drop_upp2/prison
	name = "\improper Dropship Devana"
	ambience_exterior = AMBIENCE_PRISON
	icon_state = "shuttle2"

/area/shuttle/drop_upp2/BigRed
	name = "\improper Dropship Devana"
	ambience_exterior = AMBIENCE_BIGRED
	icon_state = "shuttle2"

/area/shuttle/drop_upp2/ice_colony
	name = "\improper Dropship Devana"
	icon_state = "shuttle2"

/area/shuttle/drop_upp2/DesertDam
	name = "\improper Dropship Devana"
	ambience_exterior = AMBIENCE_TRIJENT
	icon_state = "shuttle2"

/area/shuttle/drop_upp2/transit
	ambience_exterior = 'sound/ambience/dropship_ambience_loop.ogg'
	name = "\improper Dropship Devana Transit"
	icon_state = "shuttlered"

/area/shuttle/drop_upp2/lz_upp
	name = "\improper Devana Landing Zone"
	icon_state = "away2"

//DISTRESS SHUTTLES

/area/shuttle/distress
	base_lighting_alpha = 255
	unique = TRUE

/area/shuttle/distress/start
	name = "\improper Distress Shuttle"
	icon_state = "away1"
	flags_atom = AREA_ALLOW_XENO_JOIN

/area/shuttle/distress/transit
	name = "\improper Distress Shuttle Transit"
	icon_state = "away2"


/area/shuttle/distress/start_pmc
	name = "\improper Distress Shuttle PMC"
	icon_state = "away1"

/area/shuttle/distress/transit_pmc
	name = "\improper Distress Shuttle PMC Transit"
	icon_state = "away2"


/area/shuttle/distress/start_upp
	name = "\improper Distress Shuttle UPP"
	icon_state = "away1"


/area/shuttle/distress/transit_upp
	name = "\improper Distress Shuttle UPP Transit"
	icon_state = "away2"


/area/shuttle/distress/start_big
	name = "\improper Distress Shuttle Big"
	icon_state = "away1"


/area/shuttle/distress/transit_big
	name = "\improper Distress Shuttle Big Transit"
	icon_state = "away2"


/area/shuttle/distress/arrive_1
	name = "\improper Distress Shuttle"
	icon_state = "away3"

/area/shuttle/distress/arrive_2
	name = "\improper Distress Shuttle"
	icon_state = "away4"

/area/shuttle/distress/arrive_3
	name = "\improper Distress Shuttle"
	icon_state = "away"


/area/shuttle/distress/arrive_n_hangar
	name = "\improper Distress Shuttle"
	icon_state = "away"

/area/shuttle/distress/arrive_s_hangar
	name = "\improper Distress Shuttle"
	icon_state = "away3"

/area/shuttle/distress/start_small
	name = "\improper VIP Shuttle"
	icon_state = "away3"

/area/shuttle/distress/transit_small
	name = "\improper VIP Shuttle Transit"
	icon_state = "away2"

/area/shuttle/distress/arrive_n_engi
	name = "\improper VIP Shuttle"
	icon_state = "away"

/area/shuttle/distress/arrive_s_engi
	name = "\improper VIP Shuttle"
	icon_state = "away2"
