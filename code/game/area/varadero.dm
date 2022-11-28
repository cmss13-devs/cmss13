
//areas for New  Varadero (waterworld), aka Ice Underground revamped.

/area/varadero
	name = "New Varadero"
	icon = 'icons/turf/area_varadero.dmi'
	ambience_exterior = AMBIENCE_LV624
	sound_environment = SOUND_ENVIRONMENT_MOUNTAINS
	icon_state = "varadero"
	can_build_special = TRUE //T-Comms structure
	temperature = TROPICAL_TEMP
	lighting_use_dynamic = TRUE

//shuttle stuff

/area/shuttle/drop1/varadero
	name = "New Varadero - Dropship Alamo Landing Zone"
	icon_state = "shuttle"
	icon = 'icons/turf/area_varadero.dmi'
	lighting_use_dynamic = TRUE
	is_resin_allowed = FALSE


/area/shuttle/drop2/varadero
	name = "New Varadero - Dropship Normandy Landing Zone"
	icon_state = "shuttle2"
	icon = 'icons/turf/area_varadero.dmi'
	lighting_use_dynamic = TRUE
	is_resin_allowed = FALSE

//Parent areas

/area/varadero/exterior
	name = "New Varadero - Exterior"
	ceiling = CEILING_NONE
	ambience_exterior = AMBIENCE_LV624
	//soundscape_playlist
	sound_environment = SOUND_ENVIRONMENT_MOUNTAINS

/area/varadero/interior
	name = "New Varadero - Interior"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	ambience_exterior = AMBIENCE_PRISON
	//soundscape_playlist
	sound_environment = SOUND_ENVIRONMENT_ROOM

/area/varadero/interior_protected
	name = "New Varadero - Interior"
	ceiling = CEILING_DEEP_UNDERGROUND

/area/varadero/interior_protected/comms1
	name = "New Varadero - Cargo Generator"

/area/varadero/interior_protected/comms2
	name = "New Varadero - Communications Project Site"

/area/varadero/interior_protected/comms3
	name = "New Varadero - Fishing Hole"

/area/varadero/exterior/comms4
	name = "New Varadero - Walkway Extension"

/area/varadero/interior/oob
	name = "New Varadero - Out Of Bounds"
	ceiling = CEILING_MAX
	icon_state = "oob"
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL

//landing zone computers

/area/varadero/exterior/lz1_console
	name = "New Varadero - Pontoon Dock"
	requires_power = FALSE

/area/varadero/exterior/lz1_console/two
	name = "Varadero - Palm Airfield"

//exterior areas

/area/varadero/exterior/lz1_near
	name = "New Varadero - Pontoon Airfield"
	icon_state = "lz1"
	is_resin_allowed = FALSE

/area/varadero/exterior/lz2_near
	name = "New Varadero - Palm Airfield"
	icon_state = "lz2"
	is_resin_allowed = FALSE

/area/varadero/exterior/pontoon_beach
	name = "New Varadero - Rockabilly Beach"
	icon_state = "varadero0"

//interior areas

/area/varadero/interior/cargo
	name = "New Varadero - Cargo"
	icon_state = "req0"

/area/varadero/interior/hall_NW
	name = "New Varadero - Hallway NW"
	icon_state = "hall0"

/area/varadero/interior/hall_SE
	name = "New Varadero - Hallway SE"
	icon_state = "hall1"

/area/varadero/interior/chapel
	name = "New Vardero - Chapel"
	icon_state = "offices1"

/area/varadero/interior/morgue
	name = "New Varadero - Morgue"
	icon_state = "offices0"

/area/varadero/interior/medical
	name = "New Varadero - Medical"
	icon_state = "offices2"

/area/varadero/interior/maintenance
	name = "New Varadero - Central Maintenance"
	icon_state = "tunnels0"

/area/varadero/interior/maintenance/north
	name = "New Varadero - Northern Maintenance"
	icon_state = "tunnels1"

/area/varadero/interior/maintenance/research
	name = "New Varadero - Research Maintenance"
	icon_state = "tunnels1"

/area/varadero/interior/maintenance/security
	name = "New Varadero - Security Maintenance"
	icon_state = "tunnels2"

/area/varadero/interior/maintenance/south
	name = "New Varadero - Southern Maintenance"
	icon_state = "tunnels3"

/area/varadero/interior/research
	name = "New Varadero - Research Offices"
	icon_state = "offices4"

/area/varadero/interior/electrical
	name = "New Varadero - Electrical Annex"
	icon_state = "req4"

/area/varadero/interior/toilets
	name = "New Varadero - Restrooms"
	icon_state = "req0"

/area/varadero/interior/technical_storage
	name = "New Varadero - Technical Storage"
	icon_state = "req3"

/area/varadero/interior/laundry
	name = "New Varadero - Laundry"
	icon_state = "req2"

/area/varadero/interior/disposals
	name = "New Varadero - Disposals"
	icon_state = "offices4"

/area/varadero/interior/administration
	name = "New Varadero - Administrative Offices"
	icon_state = "offices2"

/area/varadero/interior/library
	name = "New Varadero - Library"
	icon_state = "offices0"

/area/varadero/interior/court
	name = "New Varadero - Basketball Court"
	icon_state = "req4"

/area/varadero/interior/mess
	name = "New Varadero - Mess Hall"
	icon_state = "req2"

/area/varadero/interior/bunks
	name = "New Varadero - Level 1 Quarters"
	icon_state = "req3"

/area/varadero/interior/security
	name = "New Varadero - Security Offices"
	icon_state = "offices0"

/area/varadero/interior/records
	name = "New Varadero - Records"
	icon_state = "offices2"

/area/varadero/interior/rear_elevator
	name = "New Varadero - Main Lift"
	icon_state = "req3"

/area/varadero/interior_protected/caves
	name = "New Varadero - Research Caves"
	icon_state = "tunnels4"
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE
	luminosity = 0
	lighting_use_dynamic = 1


/area/varadero/interior_protected/caves/east
	name = "New Varadero - Beach Caves"
	icon_state = "tunnels4"

/area/varadero/interior_protected/caves/central
	name = "New Varadero - Grass Caves"
	icon_state = "tunnels3"

/area/varadero/interior_protected/caves/digsite
	name = "New Varadero - Dig Site"
	icon_state = "tunnels4"

/area/varadero/interior_protected/vessel
	name = "New Varadero - Unknown Vessel"
	icon_state = "req0"


