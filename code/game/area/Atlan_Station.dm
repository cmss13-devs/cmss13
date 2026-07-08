
// Areas for Atlan Mining Platform hello world

/area/atlan
	name = "Atlan Station Mining Platform"
	icon = 'icons/turf/area_atlan.dmi'
	//ambience = list('figuresomethingout.ogg')
	icon_state = "atlan"
	can_build_special = TRUE //T-Comms structure
	temperature = T20C
	powernet_name = "ground"
	minimap_color = MINIMAP_AREA_COLONY
	sound_environment = SOUND_ENVIRONMENT_ROOM
	ambience_exterior = AMBIENCE_ALMAYER
	ceiling_muffle = FALSE
	soundscape_interval = 30
	weather_enabled = FALSE

/area/atlan/oob
	name = "Atlan Out Of Bounds"
	icon_state = "oob"
	requires_power = FALSE
	ceiling = CEILING_MAX
	is_resin_allowed = FALSE
	can_build_special = FALSE
	flags_area = AREA_NOBURROW|AREA_UNWEEDABLE


/area/atlan/oob/space
	name = "Atlan Space"
	base_lighting_alpha = 255

/area/atlan/oob/credits
	base_lighting_alpha = 255
	always_unpowered = FALSE

//asteroid caves / no CAS, no mortar, no OB, xeno playplace






// station areas

/area/atlan/station
	name = "Atlan - Station"
	icon_state = "station0"
	ceiling = CEILING_GLASS

/area/atlan/station/medical
	name = "Station - Medical Bay"
	icon_state = "station_med"
	minimap_color = MINIMAP_AREA_MEDBAY
	ceiling = CEILING_GLASS

/area/atlan/station/medical/morgue
	name = "Station - Medical Bay Morgue"
	icon_state = "station_med"
	minimap_color = MINIMAP_AREA_MEDBAY
	ceiling = CEILING_GLASS

/area/atlan/station/medical_maint
	name = "Station - Medical Maintenance"
	icon_state = "outpost_engi_3"
	ceiling = CEILING_GLASS

/area/atlan/station/admin
	name = "Station - Administration"
	icon_state = "station_admin"
	minimap_color = MINIMAP_AREA_COMMAND
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS

/area/atlan/station/botany
	name = "Station - Botany"
	icon_state = "botany"
	minimap_color = MINIMAP_AREA_RESEARCH
	ceiling = CEILING_GLASS

/area/atlan/station/botany_storage
	name = "Station - Botany Storage"
	icon_state = "botany_storage"
	minimap_color = MINIMAP_AREA_RESEARCH
	ceiling = CEILING_GLASS

/area/atlan/station/single_dorms
	name = "Hab Ring - Single Dorms"
	icon_state = "single_dorms"
	ceiling = CEILING_GLASS

/area/atlan/station/canteen
	name = "Hab Ring - Commissary"
	icon_state = "botany"
	linked_lz = DROPSHIP_LZ2

/area/atlan/station/double_dorms
	name = "Hab Ring - Double Dorms"
	icon_state = "double_dorms"
	ceiling = CEILING_GLASS
	linked_lz = DROPSHIP_LZ2

/area/atlan/station/water_tanks
	name = "Station - Water Recycling Tanks"
	icon_state = "water_tanks"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS
	ceiling_muffle = FALSE

/area/atlan/station/water_maintenance
	name = "Station - Water Tanks Maintenance"
	icon_state = "water_maints"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/atlan/station/security
	name = "Station - Security"
	icon_state = "security"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS
	minimap_color = MINIMAP_AREA_SEC

/area/atlan/station/cent_maintenace
	name = "Station - Central Maintenance"
	icon_state = "centmaint"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS

/area/atlan/station/walkway
	name = "Station - Walkway of the Proletariat"
	icon_state = "walkway"

/area/atlan/station/promenade
	name = "Hab Ring - Bar and Promenade"
	icon_state = "promenade"
	linked_lz = DROPSHIP_LZ2

/area/atlan/station/hab_docks
	name = "Hab Ring - Docks"
	icon_state = "habdocks"
	linked_lz = DROPSHIP_LZ2

/area/atlan/station/hab_rec
	name = "Hab Ring - Recreational Facilities"
	icon_state = "habringrec"
	linked_lz = DROPSHIP_LZ2

/area/atlan/station/hab_sec
	name = "Hab Ring - Security Checkpoint"
	icon_state = "habsec"
	linked_lz = DROPSHIP_LZ2
	minimap_color = MINIMAP_AREA_SEC

/area/atlan/station/hab_flight
	name = "Hab Ring - Flight Control Office"
	icon_state = "flight"
	linked_lz = DROPSHIP_LZ2
	minimap_color = MINIMAP_AREA_COMMAND

/area/atlan/station/atmospherics
	name = "Station - Atmospherics"
	icon_state = "atmos"
	linked_lz = list(DROPSHIP_LZ1, DROPSHIP_LZ2)
	minimap_color = MINIMAP_AREA_ENGI
	ceiling = CEILING_METAL

/area/atlan/station/stairs1
	name = "Station - West Staircase"
	icon_state = "weststairs"
	linked_lz = DROPSHIP_LZ1
	ceiling = CEILING_METAL

/area/atlan/station/stairs2
	name = "Station - South Staircase"
	icon_state = "weststairs"
	linked_lz = DROPSHIP_LZ2
	ceiling = CEILING_METAL

/area/atlan/station/substation
	name = "Hab Ring - Electrical Substation"
	icon_state = "outpost_engi_1"
	minimap_color = MINIMAP_AREA_ENGI
	ceiling = CEILING_METAL

/area/atlan/station/cargo
	name = "Station - Cargo"
	icon_state = "cargo"
	linked_lz = DROPSHIP_LZ1

/area/atlan/station/storage
	name = "Station - Storage"
	icon_state = "storage"
	linked_lz = DROPSHIP_LZ1

/area/atlan/station/repairoffice
	name = "Station - Drydock Offices"
	icon_state = "repairs_office"
	linked_lz = DROPSHIP_LZ1

/area/atlan/station/cargooffice
	name = "Station - Cargo Offices"
	icon_state = "cargo_office"
	linked_lz = DROPSHIP_LZ1

/area/atlan/station/airlock_west
	name = "Station - Drydock West Airlock"
	icon_state = "airlock_west"
	linked_lz = DROPSHIP_LZ1
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/atlan/station/airlock_east
	name = "Station - Drydock East Airlock"
	icon_state = "airlock_east"
	linked_lz = DROPSHIP_LZ1
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/atlan/station/airlock_maints
	name = "Station - Drydock Maintenance"
	icon_state = "airlock_maints"
	linked_lz = DROPSHIP_LZ1

/area/atlan/station/drydock
	name = "Station - Drydock"
	icon_state = "drydock"
	flags_area = AREA_NOBURROW|AREA_UNWEEDABLE
	linked_lz = DROPSHIP_LZ1
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/atlan/station/repairs_lift
	name = "Station - Drydock Cargo Lift"
	icon_state = "cargolift"
	linked_lz = DROPSHIP_LZ1



//THE LZZZZZS!!!
/area/atlan/lz
	ceiling = CEILING_GLASS
	name = "Atlan - LZ"
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ

/area/atlan/lz/lz1
	name = "NW LZ1 Pad - Cargo and Drydock"
	unlimited_power = 1 //So the DS computer always works for the Queen
	requires_power = FALSE
	icon_state = "lz1"
	is_landing_zone = TRUE
	linked_lz = DROPSHIP_LZ1

/area/atlan/lz/near_lz1
	name = "NW LZ1 - Cargo and Drydock"
	icon_state = "lz1"
	is_landing_zone = TRUE
	linked_lz = DROPSHIP_LZ1

/area/atlan/lz/lz2
	name = "SW LZ2 Pad - Habitation Ring"
	unlimited_power = 1 //So the DS computer always works for the Queen
	requires_power = FALSE
	icon_state = "lz2"
	is_landing_zone = TRUE
	linked_lz = DROPSHIP_LZ2

/area/atlan/lz/near_lz2
	name = "SW LZ2 - Habitation Ring"
	icon_state = "lz2"
	is_landing_zone = TRUE
	linked_lz = DROPSHIP_LZ2



//comms relays
/area/atlan/comms
	name = "Atlan - Comms"
	icon_state = "telecomms"
	ceiling = CEILING_GLASS

/area/atlan/comms/lz1_control
	name = "Station - Drydock Control Office Relay"
	icon_state = "telecomms"
	minimap_color = MINIMAP_AREA_SEC
	linked_lz = DROPSHIP_LZ1
	ceiling = CEILING_METAL

/area/atlan/comms/lz1_lift
	name = "Station - Drydock Cargo Relay"
	icon_state = "telecomms"
	linked_lz = DROPSHIP_LZ1

/area/atlan/comms/lz1_engineering
	name = "Station - Engineering Relay"
	icon_state = "telecomms"
	minimap_color = MINIMAP_AREA_ENGI
	linked_lz = DROPSHIP_LZ1

/area/atlan/comms/lz2_hab_relay
	name = "Hab Ring - Double Dorms Relay"
	icon_state = "telecomms"
	linked_lz = DROPSHIP_LZ2

/area/atlan/comms/lz2_bar_south
	name = "Hab Ring - South Bar Relay"
	icon_state = "telecomms"
	linked_lz = DROPSHIP_LZ2


// Atlan Underground Caves

/area/atlan/asteroid
	name = "Atlan Asteroid"
	icon_state = "tumor0"
	temperature = 309.15
	ceiling = CEILING_UNDERGROUND_BLOCK_CAS
	minimap_color = MINIMAP_AREA_CAVES_DEEP
	unoviable_timer = FALSE

/area/atlan/asteroid/processing_seperation
	name = "Processing - Distillation Vats"
	icon_state = "prosep"
	minimap_color = MINIMAP_AREA_MINING

/area/atlan/asteroid/processing_seperation/interior
	name = "Processing - Distillation Vats"
	icon_state = "prosep"
	minimap_color = MINIMAP_AREA_MINING
	temperature = ICE_COLONY_TEMPERATURE

/area/atlan/asteroid/processing_seperation/cas
	name = "Processing - Distillation Vats"
	icon_state = "prosep"
	minimap_color = MINIMAP_AREA_MINING
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/atlan/asteroid/processing_cooling
	name = "Processing - Cooling Vats"
	icon_state = "proco"
	minimap_color = MINIMAP_AREA_MINING

/area/atlan/asteroid/processing_dock
	name = "Processing - Transfer Dock"
	icon_state = "prodock"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/atlan/asteroid/processing_dock/cas
	name = "Processing - Transfer Dock"
	icon_state = "prodock"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/atlan/asteroid/processing_caves
	name = "Processing - Caves"
	icon_state = "procave"
	minimap_color = MINIMAP_AREA_CAVES_DEEP

/area/atlan/asteroid/processing_handling
	name = "Processing - Handling"
	icon_state = "prohan"
	minimap_color = MINIMAP_AREA_MINING

/area/atlan/asteroid/processing_handling/cas
	name = "Processing - Handling"
	icon_state = "prohan"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/atlan/asteroid/processing_aux
	name = "Processing - Auxililary Vats"
	icon_state = "proaux"
	minimap_color = MINIMAP_AREA_MINING
	ceiling = CEILING_MAX

/area/atlan/asteroid/processing_nw_train
	name = "Processing - NW Train"
	icon_state = "nwtrain"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	minimap_color = MINIMAP_AREA_CAVES

/area/atlan/asteroid/processing_ne_train
	name = "Processing - NE Train"
	icon_state = "netrain"
	minimap_color = MINIMAP_AREA_CAVES

/area/atlan/asteroid/processing_se_train
	name = "Processing - SE Train"
	icon_state = "setrain"
	minimap_color = MINIMAP_AREA_CAVES

/area/atlan/asteroid/processing_sw_train
	name = "Processing - SW Train"
	icon_state = "swtrain"
	minimap_color = MINIMAP_AREA_CAVES
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS

/area/atlan/asteroid/processing_train_control
	name = "Processing - Train Control"
	icon_state = "train"
	minimap_color = MINIMAP_AREA_COMMAND
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/atlan/asteroid/processing_offices
	name = "Processing - Offices"
	icon_state = "proff"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/atlan/asteroid/exports_cave
	name = "Processing - Exports Cave"
	icon_state = "exportscave"
	minimap_color = MINIMAP_AREA_CAVES_DEEP

/area/atlan/asteroid/exports_east
	name = "Processing - Exports East Dock"
	icon_state = "exportseast"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/atlan/asteroid/exports_west
	name = "Processing - Exports West Dock"
	icon_state = "exportswest"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/atlan/asteroid/exports_west/cas
	name = "Processing - Exports West Dock"
	icon_state = "exportswest"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS

/area/atlan/asteroid/servers
	name = "Station - Servers and Monitoring"
	icon_state = "sensors"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS
	minimap_color = MINIMAP_AREA_RESEARCH

/area/atlan/asteroid/caves
	name = "Asteroid Caves"
	icon_state = "sewers4"
	ceiling = CEILING_MAX
	minimap_color = MINIMAP_AREA_CAVES_DEEP
	always_unpowered = TRUE

/area/atlan/asteroid/ship
	name = "Voskhod Mining Skiff: PSV Malenkyi Shevnyk"
	icon_state = "sewers3"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

