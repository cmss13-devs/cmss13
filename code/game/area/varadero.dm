
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
	minimap_color = MINIMAP_AREA_COLONY

//shuttle stuff

/area/shuttle/drop1/varadero
	name = "New Varadero - Dropship Alamo Landing Zone"
	icon_state = "shuttle"
	icon = 'icons/turf/area_varadero.dmi'
	lighting_use_dynamic = TRUE
	is_resin_allowed = FALSE
	minimap_color = MINIMAP_AREA_LZ


/area/shuttle/drop2/varadero
	name = "New Varadero - Dropship Normandy Landing Zone"
	icon_state = "shuttle2"
	icon = 'icons/turf/area_varadero.dmi'
	lighting_use_dynamic = TRUE
	is_resin_allowed = FALSE
	minimap_color = MINIMAP_AREA_LZ

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
	icon_state = "NV_no_OB"

/area/varadero/interior/comms1
	name = "New Varadero - Cargo Generator"
	icon_state = "comms1"

/area/varadero/interior/comms2
	name = "New Varadero - Communications Project Site"
	is_resin_allowed = FALSE
	icon_state = "comms2"

/area/varadero/interior/comms3
	name = "New Varadero - Fishing Hole"
	is_resin_allowed = FALSE
	icon_state = "comms3"

/area/varadero/exterior/comms4
	name = "New Varadero - Walkway Extension"
	icon_state = "comms4"

/area/varadero/exterior/eastbeach
	name = "New Varadero - East Beach"
	icon_state = "varadero1"

/area/varadero/exterior/eastocean
	name = "New Varadero - East Ocean"
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL
	icon_state = "varadero2"

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
	is_resin_allowed = FALSE
	minimap_color = MINIMAP_AREA_LZ

/area/varadero/exterior/lz1_console/two
	name = "New Varadero - Palm Airfield"
	requires_power = FALSE
	is_resin_allowed = FALSE
	minimap_color = MINIMAP_AREA_LZ

//exterior areas

/area/varadero/exterior/lz1_near
	name = "New Varadero - Pontoon Airfield"
	icon_state = "lz1"
	is_resin_allowed = FALSE
	minimap_color = MINIMAP_AREA_LZ

/area/varadero/exterior/lz2_near
	name = "New Varadero - Palm Airfield"
	icon_state = "lz2"
	is_resin_allowed = FALSE
	minimap_color = MINIMAP_AREA_LZ

/area/varadero/exterior/pontoon_beach
	name = "New Varadero - Rockabilly Beach"
	icon_state = "varadero0"
	is_resin_allowed = FALSE

//interior areas

/area/varadero/interior/cargo
	name = "New Varadero - Cargo"
	icon_state = "req0"
	is_resin_allowed = FALSE
	minimap_color = MINIMAP_AREA_ENGI

/area/varadero/interior/hall_NW
	name = "New Varadero - Hallway NW"
	icon_state = "hall0"

/area/varadero/interior/hall_N
	name = "New Varadero - Hallway N"
	icon_state = "hall2"
	is_resin_allowed = FALSE

/area/varadero/interior/hall_SE
	name = "New Varadero - Hallway SE"
	icon_state = "hall1"

/area/varadero/interior/chapel
	name = "New Vardero - Chapel"
	icon_state = "offices1"
	is_resin_allowed = FALSE

/area/varadero/interior/morgue
	name = "New Varadero - Morgue"
	icon_state = "offices0"
	is_resin_allowed = FALSE

/area/varadero/interior/medical
	name = "New Varadero - Medical"
	icon_state = "offices2"

/area/varadero/interior/maintenance
	name = "New Varadero - Central Maintenance"
	icon_state = "tunnels0"

/area/varadero/interior/maintenance/north
	name = "New Varadero - Northern Maintenance"
	icon_state = "tunnels1"
	is_resin_allowed = FALSE

/area/varadero/interior/maintenance/research
	name = "New Varadero - Research Maintenance"
	icon_state = "tunnels1"

/area/varadero/interior/maintenance/security
	name = "New Varadero - Security Maintenance"
	icon_state = "tunnels2"

/area/varadero/interior/research
	name = "New Varadero - Research Offices"
	icon_state = "offices4"
	minimap_color = MINIMAP_AREA_RESEARCH

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
	is_resin_allowed = FALSE

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

/area/varadero/interior/caves
	name = "New Varadero - PARENT TYPE CAVES"
	icon_state = "tunnels0"
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE
	luminosity = 0
	lighting_use_dynamic = 1
	minimap_color = MINIMAP_AREA_CAVES

/area/varadero/interior/caves/north_research
	name = "New Varadero - North Research Caves"
	icon_state = "tunnels4"
	minimap_color = MINIMAP_AREA_RESEARCH_CAVE

/area/varadero/interior/caves/east
	name = "New Varadero - Beach Caves"
	icon_state = "tunnels2"

/area/varadero/interior_protected/caves
	name = "New Varadero - South Research Caves"
	icon_state = "deepcaves0"
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE
	luminosity = 0
	lighting_use_dynamic = 1
	minimap_color = MINIMAP_AREA_RESEARCH_CAVE


/area/varadero/interior_protected/caves/central
	name = "New Varadero - Grass Caves"
	icon_state = "deepcaves2"

/area/varadero/interior_protected/caves/digsite
	name = "New Varadero - Dig Site"
	icon_state = "deepcaves3"

/area/varadero/interior_protected/maintenance/south
	name = "New Varadero - Southern Maintenance"
	icon_state = "deepcaves4"

/area/varadero/interior_protected/vessel
	name = "New Varadero - Unknown Vessel"
	icon_state = "predship"
	minimap_color = MINIMAP_AREA_SHIP


