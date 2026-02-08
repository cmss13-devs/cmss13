//lv759 AREAS--------------------------------------//

/area/tyrargo
//	name = "Tyrargo Rift"
	icon_state = "lv-626"
	can_build_special = TRUE
	powernet_name = "ground"
	minimap_color = MINIMAP_AREA_COLONY_RESANDCOM

//parent types

/area/tyrargo/indoors
	name = "Tyrargo - Indoors"
	icon_state = "unknown"
	ceiling = CEILING_METAL
	ambience_exterior = AMBIENCE_TYRARGO_CITY

/area/tyrargo/outdoors
	name = "Tyrargo - Outdoors"
	icon_state = "unknown"
	ceiling = CEILING_NONE
	ambience_exterior = AMBIENCE_TYRARGO_CITY

/area/tyrargo/underground
	name = "Tyrargo - Underground"
	icon_state = "unknown"
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS
	ambience_exterior = AMBIENCE_TYRARGO_SEWER_CITY
	soundscape_playlist = SCAPE_PL_LV759_INDOORS
	ceiling_muffle = FALSE

/area/tyrargo/oob
	name = "Out Of Bounds"
	icon_state = "unknown"
	ceiling = CEILING_MAX
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL
	minimap_color = MINIMAP_AREA_OOB
	requires_power = FALSE
	ambience_exterior = AMBIENCE_TYRARGO_CITY

/area/tyrargo/oob/outdoors
	ceiling_muffle = FALSE

// Landing Zone One

/area/tyrargo/landing_zone_1
	name = "Firebase Charlie - Landing Zone One"
	icon_state = "yellow"
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ
	linked_lz = DROPSHIP_LZ1
	requires_power = FALSE
	ambience_exterior = AMBIENCE_TYRARGO_CITY

/area/tyrargo/landing_zone_1/no_tunnel
	icon_state = "dk_yellow"
	flags_area = AREA_NOTUNNEL

/area/tyrargo/landing_zone_1/ceiling
	ceiling = CEILING_METAL

/area/tyrargo/landing_zone_1/underground
	ceiling = CEILING_UNDERGROUND_METAL_BLOCK_CAS

/area/tyrargo/landing_zone_1/west_trench
	name = "Firebase Charlie - Western Trench"
	icon_state = "ass_line"
	minimap_color = MINIMAP_AREA_CONTESTED_ZONE

/area/tyrargo/landing_zone_1/north_trench
	name = "Firebase Charlie - Northern Trench"
	icon_state = "ass_line"
	minimap_color = MINIMAP_AREA_CONTESTED_ZONE

/area/tyrargo/landing_zone_1/no_mans_land
	name = "Firebase Charlie - No Man's Land"
	icon_state = "security_sub"
	minimap_color = MINIMAP_LAVA

/area/tyrargo/landing_zone_1/comms
	name = "Firebase Charlie - Communications Control Bunker"
	requires_power = TRUE

// Landing Zone Two

/area/tyrargo/landing_zone_2
	name = "USASF Airbase Anderson - Landing Zone Two"
	icon_state = "yellow"
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ
	linked_lz = DROPSHIP_LZ2
	requires_power = FALSE
	ambience_exterior = AMBIENCE_TYRARGO_CITY

/area/tyrargo/landing_zone_2/road
	name = "USASF Airbase Anderson - Road"
	icon_state = "shuttle3"
	minimap_color = MINIMAP_AREA_SHIP

/area/tyrargo/landing_zone_2/strip
	name = "USASF Airbase Anderson - Airstrip"
	icon_state = "shuttle3"
	minimap_color = MINIMAP_AREA_COMMS
	flags_area = AREA_NOTUNNEL

/area/tyrargo/landing_zone_2/no_tunnel
	icon_state = "dk_yellow"
	flags_area = AREA_NOTUNNEL

/area/tyrargo/landing_zone_2/ceiling
	ceiling = CEILING_METAL
	minimap_color = MINIMAP_AREA_GLASS

/area/tyrargo/landing_zone_2/east_trench
	name = "USASF Airbase Anderson - North-East Trench"
	minimap_color = MINIMAP_AREA_CELL_MED

// Outskirts Road

/area/tyrargo/outdoors/outskirts_road
	name = "Outskirts Road"
	icon_state = "shuttle2"
	minimap_color = MINIMAP_AREA_SHIP
	requires_power = FALSE

/area/tyrargo/outdoors/outskirts_road/west
	name = "Outskirts Road - West"
	linked_lz = list(DROPSHIP_LZ1, DROPSHIP_LZ2)

/area/tyrargo/outdoors/outskirts_road/central
	name = "Outskirts Road - Central"

/area/tyrargo/outdoors/outskirts_road/east
	name = "Outskirts Road - East"

// Colony Streets

/area/tyrargo/outdoors/colony_streets
	name = "Colony Streets"
	icon_state = "shuttle3"
	ceiling = CEILING_NONE
	minimap_color = MINIMAP_AREA_COLONY_STREETS
	requires_power = FALSE
	unoviable_timer = FALSE
	soundscape_playlist = SCAPE_PL_TYRARGO_ALERT
	soundscape_interval = 45

/area/tyrargo/outdoors/colony_streets/north_west
	name = "Colony Streets - North-West"

/area/tyrargo/outdoors/colony_streets/west
	name = "Colony Streets - West"

/area/tyrargo/outdoors/colony_streets/south_west
	name = "Colony Streets - South-West"

/area/tyrargo/outdoors/colony_streets/north
	name = "Colony Streets - North"

/area/tyrargo/outdoors/colony_streets/north_east
	name = "Colony Streets - North-East"

/area/tyrargo/outdoors/colony_streets/east
	name = "Colony Streets - East"

/area/tyrargo/outdoors/colony_streets/south_east
	name = "Colony Streets - South-East"

// Colony Exterior

/area/tyrargo/outdoors/colony_exterior
	name = "Colony Exterior"
	icon_state = "mining"
	ceiling = CEILING_NONE
	minimap_color = MINIMAP_AREA_JUNGLE
	requires_power = FALSE
	unoviable_timer = FALSE
	soundscape_playlist = SCAPE_PL_TYRARGO_ALERT
	soundscape_interval = 45

/area/tyrargo/outdoors/colony_exterior/north_west
	name = "Colony Exterior - North-West"

/area/tyrargo/outdoors/colony_exterior/west
	name = "Colony Exterior - West"

/area/tyrargo/outdoors/colony_exterior/south_west
	name = "Colony Exterior - South-West"

/area/tyrargo/outdoors/colony_exterior/north
	name = "Colony Exterior - North"

/area/tyrargo/outdoors/colony_exterior/north_east
	name = "Colony Exterior - North-East"

/area/tyrargo/outdoors/colony_exterior/east
	name = "Colony Exterior - East"

/area/tyrargo/outdoors/colony_exterior/south_east
	name = "Colony Exterior - South-East"

// Colony Walkways

/area/tyrargo/outdoors/walkway_access
	name = "External Access Walkway"
	icon_state = "showroom"
	ceiling = CEILING_NONE
	minimap_color = MINIMAP_AREA_CELL_HIGH
	requires_power = FALSE
	unoviable_timer = FALSE
	soundscape_playlist = SCAPE_PL_TYRARGO_ALERT
	soundscape_interval = 45

/area/tyrargo/outdoors/walkway_access/power_sewer
	name = "External Walkway - Power/Sewer"

/area/tyrargo/outdoors/walkway_access/sewer_apart
	name = "External Walkway - Sewer/Apartments"

/area/tyrargo/outdoors/walkway_access/power_apart
	name = "External Walkway - Power/Apartments"

/area/tyrargo/outdoors/walkway_access/apart_gararge
	name = "External Walkway - Apartments/Gararge"

/area/tyrargo/outdoors/walkway_access/gararge_admin
	name = "External Walkway - Gararge/Admin"

/area/tyrargo/outdoors/walkway_access/museum_central
	name = "External Walkway - Museum"

//// Colony Buildings ////

// Apartment

/area/tyrargo/indoors/apartment
	minimap_color = MINIMAP_AREA_COLONY_RESANDCOM
	icon_state = "quart"
	unoviable_timer = FALSE
	soundscape_playlist = SCAPE_PL_TYRARGO_ALERT
	soundscape_interval = 45

/area/tyrargo/indoors/apartment/north_ground
	name = "Standfeld Apartment Complex - North-Ground"

/area/tyrargo/indoors/apartment/north_upper
	name = "Standfeld Apartment Complex - North-Upper"

/area/tyrargo/indoors/apartment/south_ground
	name = "Standfeld Apartment Complex - South-Ground"

/area/tyrargo/indoors/apartment/south_upper
	name = "Standfeld Apartment Complex - South-Upper"

// Bar

/area/tyrargo/indoors/bar
	minimap_color = MINIMAP_AREA_CELL_VIP
	icon_state = "bar"
	unoviable_timer = FALSE
	soundscape_playlist = SCAPE_PL_TYRARGO_ALERT
	soundscape_interval = 45

/area/tyrargo/indoors/bar/ground
	name = "Last Throw Bar - Ground"

/area/tyrargo/indoors/bar/upper
	name = "Last Throw Bar - Upper"

/area/tyrargo/indoors/bar/upper/external
	name = "Last Throw Bar - Upper/External"
	ceiling = CEILING_NONE
	requires_power = FALSE

// Power-Plant

/area/tyrargo/indoors/engineering
	minimap_color = MINIMAP_AREA_COLONY_ENGINEERING
	icon_state = "maint_engine"
	unoviable_timer = FALSE
	soundscape_playlist = SCAPE_PL_TYRARGO_ALERT
	soundscape_interval = 45

/area/tyrargo/indoors/engineering/ground
	name = "Sector F: Power Plant - Ground"

/area/tyrargo/indoors/engineering/upper
	name = "Sector F: Power Plant - Upper"

/area/tyrargo/indoors/engineering/upper/external
	name = "Sector F: Power Plant - Upper/External"
	ceiling = CEILING_NONE
	requires_power = FALSE

// Sewer Treatment

/area/tyrargo/indoors/sewer_treatment
	minimap_color = MINIMAP_AREA_HYBRISARESEARCH
	icon_state = "explored"
	unoviable_timer = FALSE
	soundscape_playlist = SCAPE_PL_TYRARGO_ALERT
	soundscape_interval = 45

/area/tyrargo/indoors/sewer_treatment/ground
	name = "Sewer Treatment Plant - Ground"

/area/tyrargo/indoors/sewer_treatment/upper
	name = "Sewer Treatment Plant - Upper"

/area/tyrargo/indoors/sewer_treatment/lower
	name = "Sewer Treatment Plant - Underground Access"

/area/tyrargo/indoors/sewer_treatment/upper/external
	name = "Sewer Treatment Plant - Upper/External"
	ceiling = CEILING_NONE
	requires_power = FALSE

// Ancillery Comms

/area/tyrargo/indoors/comms
	minimap_color = MINIMAP_AREA_COLONY_ENGINEERING
	icon_state = "ai_upload"
	unoviable_timer = FALSE
	soundscape_playlist = SCAPE_PL_TYRARGO_ALERT
	soundscape_interval = 45

/area/tyrargo/indoors/comms/ground
	name = "Ancillery Communications System - Ground"

/area/tyrargo/indoors/comms/upper
	name = "Ancillery Communications System - Upper"
	ceiling = CEILING_NONE
	requires_power = FALSE

// Gararge

/area/tyrargo/indoors/gararge
	minimap_color = MINIMAP_AREA_CELL_MED
	icon_state = "HH_Mines"
	unoviable_timer = FALSE
	soundscape_playlist = SCAPE_PL_TYRARGO_ALERT
	soundscape_interval = 45

/area/tyrargo/indoors/gararge/ground
	name = "Busters Car Repair - Ground"

/area/tyrargo/indoors/gararge/upper
	name = "Busters Car Repair - Ground"
	ceiling = CEILING_NONE

/area/tyrargo/indoors/gararge/upper/external
	name = "Busters Car Repair - Upper/External"
	ceiling = CEILING_NONE
	requires_power = FALSE

// Mall

/area/tyrargo/indoors/mall
	name = "Tyrargo Wesfeld Mall - Ground"
	minimap_color = MINIMAP_AREA_COLONY_RESANDCOM
	icon_state = "HH_Mines"
	unoviable_timer = FALSE
	soundscape_playlist = SCAPE_PL_TYRARGO_ALERT
	soundscape_interval = 45

/area/tyrargo/indoors/mall/upper
	name = "Tyrargo Wesfeld Mall - Upper"

/area/tyrargo/indoors/mall/upper/external
	name = "Tyrargo Wesfeld Mall - Upper/External"
	ceiling = CEILING_NONE
	requires_power = FALSE

// Administration

/area/tyrargo/indoors/admin
	minimap_color = MINIMAP_AREA_COLONY_SPACE_PORT
	icon_state = "storage"
	unoviable_timer = FALSE
	soundscape_playlist = SCAPE_PL_TYRARGO_ALERT
	soundscape_interval = 45

/area/tyrargo/indoors/admin/ground
	name = "Sector F: Government Administration - Ground"

/area/tyrargo/indoors/admin/upper
	name = "Sector F: Government Administration - Upper"

/area/tyrargo/indoors/admin/upper/external
	name = "Sector F: Government Administration - Upper-External"
	ceiling = CEILING_NONE
	requires_power = FALSE

// Market

/area/tyrargo/indoors/market
	minimap_color = MINIMAP_AREA_COLONY_HOSPITAL
	icon_state = "HH_Panic"
	unoviable_timer = FALSE
	soundscape_playlist = SCAPE_PL_TYRARGO_ALERT
	soundscape_interval = 30

/area/tyrargo/indoors/market/ground
	name = "Farmers Market - Ground"

/area/tyrargo/indoors/market/upper
	name = "Farmers Market - Upper"
	ceiling = CEILING_NONE
	requires_power = FALSE

// Security

/area/tyrargo/indoors/security
	minimap_color = MINIMAP_AREA_COLONY_MARSHALLS
	icon_state = "HH_Basement"
	unoviable_timer = FALSE
	soundscape_playlist = SCAPE_PL_TYRARGO_ALERT
	soundscape_interval = 30

/area/tyrargo/indoors/security/ground
	name = "Sector F: Marshals Outpost - Ground"

/area/tyrargo/indoors/security/upper
	name = "Sector F: Marshals Outpost - Upper"
	ceiling = CEILING_NONE
	requires_power = FALSE

// Museum West

/area/tyrargo/indoors/museum_storage
	minimap_color = MINIMAP_AREA_HYBRISARESEARCH
	icon_state = "auxstorage"
	unoviable_timer = FALSE
	soundscape_playlist = SCAPE_PL_TYRARGO_ALERT
	soundscape_interval = 30

/area/tyrargo/indoors/museum_storage/ground
	name = "Museum Carpark - Ground"

/area/tyrargo/indoors/museum_storage/upper
	name = "Museum Carpark - Upper"

/area/tyrargo/indoors/museum_storage/upper/external
	name = "Museum Carpark - Upper/External"
	ceiling = CEILING_NONE
	requires_power = FALSE

// fob generator area

/area/tyrargo/indoors/power_substation_outskirt
	name = "Power Substation: West Outskirts"
	icon_state = "maint_engine"
	minimap_color = MINIMAP_AREA_COLONY_ENGINEERING

// Western Outdoor Areas

/area/tyrargo/outdoors/outskirts
	name = "Outskirts"
	icon_state = "green"
	minimap_color = MINIMAP_AREA_JUNGLE
	requires_power = FALSE

/area/tyrargo/outdoors/outskirts/north_west_usasf
	name = "Outskirts  - Worth-West Anderson Airbase"
	linked_lz = list(DROPSHIP_LZ1, DROPSHIP_LZ2)

/area/tyrargo/outdoors/outskirts/north_east_usasf
	name = "Outskirts  - North-East Anderson Airbase"

/area/tyrargo/outdoors/outskirts/north_east_usasf/weedkiller
	linked_lz = DROPSHIP_LZ2

/area/tyrargo/outdoors/outskirts/central
	name = "Outskirts  - Central"

/area/tyrargo/outdoors/outskirts/central/landing_zone
	linked_lz = DROPSHIP_LZ1

/area/tyrargo/outdoors/outskirts/east
	name = "Outskirts  - East"

/area/tyrargo/outdoors/outskirts/river
	name = "Outskirts  - River"

/area/tyrargo/outdoors/outskirts/fsb_north
	name = "Fire Support Base - North"
	icon_state = "security_sub"
	minimap_color = MINIMAP_AREA_DERELICT
	requires_power = TRUE

/area/tyrargo/outdoors/outskirts/fsb_south
	name = "Fire Support Base - South"
	icon_state = "security_sub"
	minimap_color = MINIMAP_AREA_DERELICT
	requires_power = TRUE

/area/tyrargo/outdoors/outskirts/east_trench
	name = "Fire Support Base - Eastern Trench"
	icon_state = "ass_line"
	minimap_color = MINIMAP_AREA_GLASS

/area/tyrargo/outdoors/outskirts/no_mans_land
	name = "Fire Support Base - No Man's Land"
	icon_state = "security_sub"
	minimap_color = MINIMAP_LAVA

// Surface Bunker

/area/tyrargo/indoors/bunker
	name = "Surface Bunker"
	icon_state = "security"
	minimap_color = MINIMAP_AREA_SEC
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS
	base_muffle = MUFFLE_LOW

/area/tyrargo/indoors/bunker/north
	name = "Surface Bunker - Alpha"

/area/tyrargo/indoors/bunker/north_south
	name = "Surface Bunker - Bravo"

/area/tyrargo/indoors/bunker/central
	name = "Surface Bunker - Charlie"

/area/tyrargo/indoors/bunker/central_south
	name = "Surface Bunker - Delta"

// Underground Bunker

/area/tyrargo/underground/bunker
	name = "Underground Bunker"
	icon_state = "security"
	minimap_color = MINIMAP_AREA_SEC

/area/tyrargo/underground/bunker/north
	name = "Bunker Network - Sector Tango-12"

/area/tyrargo/underground/bunker/south
	name = "Bunker Network - Sector Epsilon-29"

/area/tyrargo/underground/bunker/ammo_dump_entrance
	name = "USASF Airbase Anderson - Underground Ammo Dump"
	linked_lz = DROPSHIP_LZ2

/area/tyrargo/underground/bunker/ammo_dump_connection
	name = "USASF Airbase Anderson - Underground Cave Network"
	requires_power = FALSE
	linked_lz = DROPSHIP_LZ2

// Underground Sewer

/area/tyrargo/underground/sewer
	name = "City Sewer"
	icon_state = "security"
	minimap_color = MINIMAP_AREA_COLONY_STREETS

/area/tyrargo/underground/sewer/south
	name = "City Sewers - South"

/area/tyrargo/underground/sewer/north
	name = "City Sewers - North"

// Underground Other

/area/tyrargo/underground/oob_area
	name = "Disconnected Underground Bunker Network"
	minimap_color = MINIMAP_AREA_OOB
	icon_state = "Holodeck"
	ceiling = CEILING_MAX
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL
	requires_power = FALSE

/area/tyrargo/underground/engineering
	name = "Sector F: Power Plant - Underground"
	minimap_color = MINIMAP_AREA_COLONY_ENGINEERING
	icon_state = "maint_engine"
	soundscape_playlist = SCAPE_PL_LV759_INDOORS
	ambience_exterior = AMBIENCE_HYBRISA_INTERIOR

/area/tyrargo/underground/apartment
	name = "Standfeld Apartment Complex - Underground"
	minimap_color = MINIMAP_AREA_COLONY_RESANDCOM
	icon_state = "quart"
	soundscape_playlist = SCAPE_PL_LV759_INDOORS
	ambience_exterior = AMBIENCE_HYBRISA_INTERIOR

/area/tyrargo/underground/mall
	name = "Tyrargo Wesfeld Mall - Underground"
	minimap_color = MINIMAP_AREA_COLONY_RESANDCOM
	icon_state = "HH_Mines"
	soundscape_playlist = SCAPE_PL_LV759_INDOORS
	ambience_exterior = AMBIENCE_HYBRISA_INTERIOR

/area/tyrargo/underground/museum_carpark
	name = "Museum Carpark - Underground"
	minimap_color = MINIMAP_AREA_COLONY_RESANDCOM
	icon_state = "auxstorage"
	soundscape_playlist = SCAPE_PL_LV759_INDOORS
	ambience_exterior = AMBIENCE_HYBRISA_INTERIOR

/area/tyrargo/underground/power_substation
	name = "Sewer - Power-Routing Substation"
	minimap_color = MINIMAP_AREA_COLONY_ENGINEERING
	icon_state = "maint_engine"
	soundscape_playlist = SCAPE_PL_LV759_INDOORS
	ambience_exterior = AMBIENCE_HYBRISA_INTERIOR

// Saipan

/area/tyrargo/indoors/saipan
	name = "Dropship Saipan"
	minimap_color = MINIMAP_SQUAD_ECHO
	icon_state = "Holodeck"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS
	requires_power = FALSE
	unoviable_timer = FALSE

// Tychon

/area/tyrargo/indoors/tychon
	name = "Dropship Tychon"
	minimap_color = MINIMAP_SQUAD_ECHO
	icon_state = "Holodeck"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS
	requires_power = FALSE
	unoviable_timer = FALSE
	ceiling_muffle = FALSE

// USS Heyst

/area/tyrargo/indoors/heyst
	name = "USS Heyst - Mid Deck"
	minimap_color = MINIMAP_SQUAD_ECHO
	icon_state = "Holodeck"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS
	soundscape_playlist = SCAPE_PL_LV759_INDOORS
	ambience_exterior = AMBIENCE_TYRARGO_CITY
	ceiling_muffle = FALSE
	base_muffle = MUFFLE_MEDIUM

/area/tyrargo/indoors/heyst/upper
	name = "USS Heyst - Upper Deck"

// ERT Spawn Area

/area/tyrargo/outdoors/army_staging
	name = "32nd Armor Division: Staging Area - Southern Outskirts"
	icon_state = "Holodeck"
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL
	minimap_color = MINIMAP_AREA_SEC_CAVE
	ceiling = CEILING_MAX
	ceiling_muffle = FALSE
	requires_power = FALSE
