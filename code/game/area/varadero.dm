
//areas for New  Varadero (waterworld), aka Ice Underground revamped.

/area/varadero
	name = "New Varadero"
	icon = 'icons/turf/area_varadero.dmi'
	ambience_exterior = AMBIENCE_NV
	icon_state = "varadero"
	can_build_special = TRUE //T-Comms structure
	powernet_name = "ground"
	temperature = TROPICAL_TEMP
	minimap_color = MINIMAP_AREA_COLONY

//shuttle stuff

/area/shuttle/drop1/varadero
	name = "New Varadero - Dropship Alamo Landing Zone"
	icon_state = "shuttle"
	icon = 'icons/turf/area_varadero.dmi'
	linked_lz = DROPSHIP_LZ1
	minimap_color = MINIMAP_AREA_LZ


/area/shuttle/drop2/varadero
	name = "New Varadero - Dropship Normandy Landing Zone"
	icon_state = "shuttle2"
	icon = 'icons/turf/area_varadero.dmi'
	linked_lz = DROPSHIP_LZ2
	minimap_color = MINIMAP_AREA_LZ

//Parent areas

/area/varadero/exterior
	name = "New Varadero - Exterior"
	ceiling = CEILING_NONE
	ambience_exterior = AMBIENCE_NV
	//soundscape_playlist

/area/varadero/interior
	name = "New Varadero - Interior"
	ceiling = CEILING_GLASS
	ambience_exterior = AMBIENCE_PRISON
	//soundscape_playlist
	sound_environment = SOUND_ENVIRONMENT_ROOM

/area/varadero/interior_protected
	name = "New Varadero - Interior"
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
	icon_state = "NV_no_CAS"

/area/varadero/interior/comms1
	name = "New Varadero - Cargo Generator"
	linked_lz = DROPSHIP_LZ1
	icon_state = "comms1"
	minimap_color = MINIMAP_AREA_ENGI_CAVE

/area/varadero/interior/comms2
	name = "New Varadero - Communications Project Site"
	icon_state = "comms2"
	minimap_color = MINIMAP_AREA_ENGI_CAVE
	linked_lz = DROPSHIP_LZ2

/area/varadero/interior/comms3
	name = "New Varadero - Engineering Communications"
	icon_state = "comms3"
	minimap_color = MINIMAP_AREA_ENGI_CAVE
	linked_lz = DROPSHIP_LZ2

/area/varadero/exterior/comms4
	name = "New Varadero - Walkway Extension"
	linked_lz = DROPSHIP_LZ1
	icon_state = "comms4"
	minimap_color = MINIMAP_AREA_ENGI_CAVE

/area/varadero/interior/oob
	name = "New Varadero - Out Of Bounds"
	ceiling = CEILING_MAX
	icon_state = "oob"
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL|AREA_UNWEEDABLE

//landing zone computers

/area/varadero/exterior/lz1_console
	name = "New Varadero - Pontoon Dock"
	requires_power = FALSE
	minimap_color = MINIMAP_AREA_LZ
	is_landing_zone = TRUE

/area/varadero/exterior/lz1_console/two
	name = "New Varadero - Palm Airfield"
	requires_power = FALSE
	minimap_color = MINIMAP_AREA_LZ

//exterior areas

/area/varadero/exterior/lz1_near
	name = "New Varadero - Pontoon Airfield"
	icon_state = "lz1"
	linked_lz = DROPSHIP_LZ1
	minimap_color = MINIMAP_AREA_LZ
	is_landing_zone = TRUE

/area/varadero/exterior/lz2_near
	name = "New Varadero - Palm Airfield"
	icon_state = "lz2"
	linked_lz = DROPSHIP_LZ2
	minimap_color = MINIMAP_AREA_LZ
	is_landing_zone = TRUE

/area/varadero/exterior/pontoon_beach
	name = "New Varadero - Rockabilly Beach"
	icon_state = "varadero0"
	linked_lz = list(DROPSHIP_LZ1, DROPSHIP_LZ2)
	minimap_color = MINIMAP_AREA_JUNGLE

/area/varadero/exterior/pontoon_beach/lz
	is_landing_zone = TRUE
	linked_lz = DROPSHIP_LZ1

/area/varadero/exterior/eastbeach
	name = "New Varadero - East Beach"
	linked_lz = DROPSHIP_LZ2
	icon_state = "varadero1"
	minimap_color = MINIMAP_AREA_JUNGLE

/area/varadero/exterior/monsoon
	name = "New Varadero - Monsoon"
	icon_state = "varadero1"
	minimap_color = MINIMAP_AREA_JUNGLE

/area/varadero/exterior/pool
	name = "New Varadero - Interior Pool"
	icon_state = "varadero1"
	minimap_color = MINIMAP_AREA_COMMAND_CAVE

/area/varadero/exterior/eastocean
	name = "New Varadero - East Ocean"
	linked_lz = DROPSHIP_LZ2
	flags_area = AREA_NOTUNNEL
	icon_state = "varadero2"
	minimap_color = MINIMAP_AREA_CONTESTED_ZONE

/area/varadero/exterior/farocean
	name = "New Varadero - Far Ocean"
	flags_area = AREA_NOTUNNEL
	icon_state = "varadero3"
	minimap_color = MINIMAP_AREA_CONTESTED_ZONE

/area/varadero/exterior/islands
	name = "New Varadero - Islands"
	icon_state = "varadero1"
	allow_construction = FALSE
	always_unpowered = 1


//interior areas


/area/varadero/interior/beach_bar
	name = "New Varadero - Beach Bar"
	icon_state = "varadero4"
	linked_lz = list(DROPSHIP_LZ1, DROPSHIP_LZ2)
	minimap_color = MINIMAP_AREA_JUNGLE
	sound_environment = SOUND_ENVIRONMENT_ROOM

/area/varadero/interior/dock_control
	name = "New Varadero - Dock Control"
	icon_state = "varadero3"
	linked_lz = DROPSHIP_LZ1
	minimap_color = MINIMAP_AREA_JUNGLE
	sound_environment = SOUND_ENVIRONMENT_ROOM
	is_landing_zone = TRUE

/area/varadero/interior/cargo
	name = "New Varadero - Cargo"
	icon_state = "req0"
	linked_lz = DROPSHIP_LZ1
	minimap_color = MINIMAP_AREA_ENGI

/area/varadero/interior/hall_NW
	name = "New Varadero - Hallway NW"
	icon_state = "hall0"

/area/varadero/interior/hall_N
	name = "New Varadero - Hallway N"
	icon_state = "hall2"
	linked_lz = DROPSHIP_LZ1

/area/varadero/interior/hall_SE
	name = "New Varadero - Hallway SE"
	icon_state = "hall1"

/area/varadero/interior/chapel
	name = "New Vardero - Chapel"
	icon_state = "offices1"
	linked_lz = DROPSHIP_LZ1
	minimap_color = MINIMAP_AREA_COMMAND_CAVE

/area/varadero/interior/morgue
	name = "New Varadero - Morgue"
	icon_state = "offices0"
	linked_lz = DROPSHIP_LZ1
	minimap_color = MINIMAP_AREA_MEDBAY_CAVE

/area/varadero/interior/medical
	name = "New Varadero - Medical"
	icon_state = "offices2"
	minimap_color = MINIMAP_AREA_MEDBAY

/area/varadero/interior/maintenance
	name = "New Varadero - Central Maintenance"
	icon_state = "tunnels0"

/area/varadero/interior/maintenance/north
	name = "New Varadero - Northern Maintenance"
	icon_state = "tunnels1"
	linked_lz = DROPSHIP_LZ1

/area/varadero/interior/maintenance/research
	name = "New Varadero - Research Maintenance"
	icon_state = "tunnels1"
	minimap_color = MINIMAP_AREA_RESEARCH_CAVE

/area/varadero/interior/maintenance/security
	name = "New Varadero - Sec. Maintenance"
	icon_state = "tunnels2"
	minimap_color = MINIMAP_AREA_SEC_CAVE

/area/varadero/interior/maintenance/security/north
	name = "New Varadero - North Sec. Maintenance"
	linked_lz = DROPSHIP_LZ2

/area/varadero/interior/maintenance/security/south
	name = "New Varadero - South Sec. Maintenance"

/area/varadero/interior/research
	name = "New Varadero - Research Offices"
	icon_state = "offices4"
	minimap_color = MINIMAP_AREA_RESEARCH

/area/varadero/interior/electrical
	name = "New Varadero - Electrical Annex"
	icon_state = "req4"
	minimap_color = MINIMAP_AREA_ENGI
	linked_lz = DROPSHIP_LZ2

/area/varadero/interior/toilets
	name = "New Varadero - Restrooms"
	icon_state = "req0"

/area/varadero/interior/technical_storage
	name = "New Varadero - Technical Storage"
	icon_state = "req3"
	minimap_color = MINIMAP_AREA_ENGI

/area/varadero/interior/laundry
	name = "New Varadero - Laundry"
	icon_state = "req2"

/area/varadero/interior/disposals
	name = "New Varadero - Disposals"
	icon_state = "offices4"
	minimap_color = MINIMAP_AREA_ENGI

/area/varadero/interior/administration
	name = "New Varadero - Administrative Offices"
	icon_state = "offices2"
	minimap_color = MINIMAP_AREA_COMMAND

/area/varadero/interior/library
	name = "New Varadero - Library"
	icon_state = "offices0"
	linked_lz = DROPSHIP_LZ1
	minimap_color = MINIMAP_AREA_COMMAND_CAVE

/area/varadero/interior/court
	name = "New Varadero - Basketball Court"
	icon_state = "req4"
	minimap_color = MINIMAP_AREA_COMMAND_CAVE

/area/varadero/interior/mess
	name = "New Varadero - Mess Hall"
	icon_state = "req2"
	minimap_color = MINIMAP_AREA_COMMAND_CAVE

/area/varadero/interior/bunks
	name = "New Varadero - Level 1 Quarters"
	icon_state = "req3"
	minimap_color = MINIMAP_AREA_JUNGLE

/area/varadero/interior/security
	name = "New Varadero - Security Offices"
	icon_state = "offices0"
	minimap_color = MINIMAP_AREA_SEC

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
	sound_environment = SOUND_ENVIRONMENT_AUDITORIUM
	minimap_color = MINIMAP_AREA_CAVES

/area/varadero/interior/caves/north_research
	name = "New Varadero - North Research Caves"
	icon_state = "tunnels4"

/area/varadero/interior/caves/east
	name = "New Varadero - Beach Caves"
	icon_state = "tunnels2"

/area/varadero/interior_protected/caves
	name = "New Varadero - South Research Caves"
	icon_state = "deepcaves0"
	power_light = FALSE
	power_equip = FALSE
	power_environ = FALSE
	minimap_color = MINIMAP_AREA_RESEARCH_CAVE
	unoviable_timer = FALSE

/area/varadero/interior_protected/caves/central
	name = "New Varadero - Grass Caves"
	icon_state = "deepcaves2"
	minimap_color = MINIMAP_AREA_CAVES

/area/varadero/interior_protected/caves/digsite
	name = "New Varadero - Dig Site"
	icon_state = "deepcaves3"

/area/varadero/interior_protected/caves/makeshift_tent
	name = "New Varadero - Makeshift Tent"
	icon_state = "offices4"

/area/varadero/interior_protected/caves/swcaves
	name = "New Varadero - Southwest Caves"
	icon_state = "deepcaves3"

/area/varadero/interior_protected/maintenance/south
	name = "New Varadero - Southern Maintenance"
	icon_state = "deepcaves4"
	minimap_color = MINIMAP_AREA_CAVES
	unoviable_timer = FALSE

/area/varadero/interior_protected/vessel
	name = "New Varadero - Unknown Vessel"
	icon_state = "predship"
	minimap_color = MINIMAP_AREA_SHIP
	unoviable_timer = FALSE
