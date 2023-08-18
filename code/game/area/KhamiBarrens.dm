//Areas for the Kutjevo Refinery

/area/khami_barrens
	name = "Khami Barrens"
	icon = 'icons/turf/area_kutjevo.dmi'
	//ambience = list('figuresomethingout.ogg')
	icon_state = "khami_barrens"
	can_build_special = TRUE //T-Comms structure
	temperature = 308.7 //kelvin, 35c, 95f
	lighting_use_dynamic = 1
	minimap_color = MINIMAP_AREA_ENGI

/area/shuttle/drop1/khami_barrens
	name = "Khami Barrens - Dropship Alamo Landing Zone"
	icon_state = "shuttle"
	icon = 'icons/turf/area_kutjevo.dmi'
	lighting_use_dynamic = 1

/area/shuttle/drop2/khami_barrens
	name = "Khami Barrens - Dropship Normandy Landing Zone"
	icon_state = "shuttle2"
	icon = 'icons/turf/area_kutjevo.dmi'
	lighting_use_dynamic = 1

/area/khami_barrens/exterior
	name = "Khami Barrens - Exterior"
	ceiling = CEILING_NONE
	icon_state = "ext"


/area/khami_barrens/interior
	name = "Khami Barrens - Interior"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	icon_state = "int"
	requires_power = 1

/area/khami_barrens/interior/oob
	name = "Khami Barrens -  Out Of Bounds"
	ceiling = CEILING_MAX
	icon_state = "oob"
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL

/area/khami_barrens/interior/oob/dev_room
	name = "Khami Barrens - Credits Room"
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL
	icon_state = "khami_barrens"

//exterior map areas

/area/khami_barrens/exterior/lz_pad
	name = "Kutjevo Auxilliary Landing Zone"
	icon_state = "lz_pad"
	weather_enabled = FALSE
	unlimited_power = 1//ds computer
	is_resin_allowed = FALSE
	is_landing_zone = TRUE

/area/khami_barrens/exterior/lz_dunes
	name = "Khami Barrens - Landing Zone Dunes"
	icon_state = "lz_dunes"
	is_resin_allowed = FALSE
	weather_enabled =  FALSE
	unlimited_power = 1//DS Computer
	is_landing_zone = TRUE

/area/khami_barrens/exterior/lz_river
	name = "Khami Barrens - Power Station River"
	icon_state = "lz_river"

/area/khami_barrens/exterior/scrubland
	name = "Khami Barrens - Scrubland"
	icon_state = "scrubland"

/area/khami_barrens/exterior/stonyfields
	name = "Khami Barrens - Stony Fields"
	icon_state = "stone_fields"

/area/khami_barrens/exterior/Northwest_Colony
	name = "Khami Barrens - Northwest Colony Grounds"
	icon_state = "rf_dunes"
	is_resin_allowed = FALSE

/area/khami_barrens/exterior/runoff_dunes
	name = "Khami Barrens - Runoff Dunes"
	icon_state = "rf_dunes"

/area/khami_barrens/exterior/runoff_river
	name = "Khami Barrens - Runoff River"
	icon_state = "rf_river"

/area/khami_barrens/exterior/runoff_bridge
	name = "Khami Barrens - Runoff Bridge"
	icon_state = "rf_bridge"

/area/khami_barrens/exterior/overlook
	name = "Khami Barrens - Runoff River Overlook"
	icon_state = "rf_overlook"

/area/khami_barrens/exterior/botany_bay_ext
	name = "Khami Barrens - Space Weed Farm Exterior"
	icon_state = "weed_ext"

/area/khami_barrens/exterior/construction
	name = "Khami Barrens - Abandoned Construction"
	icon_state = "construction"

/area/khami_barrens/exterior/complex_border
	name = "Kutjevo Complex - Exterior"
	icon_state = "khami_barrens"

/area/khami_barrens/exterior/complex_border/botany_medical_cave
	name = "Kutjevo Complex - Botany - Medical Cave"
	icon_state = "med_ext"

/area/khami_barrens/exterior/complex_border/med_park
	name = "Kutjevo Complex - Medical Park"
	icon_state = "med_ext"

/area/khami_barrens/exterior/complex_border/med_rec
	name = "Kutjevo Complex - Water Tank Cave"
	icon_state = "construction2"

//telecomms areas
/area/khami_barrens/exterior/telecomm
	name = "Khami Barrens - Communications Relay"
	icon_state = "ass_line"
	is_resin_allowed = FALSE
	ceiling_muffle = FALSE
	base_muffle = MUFFLE_LOW

/area/khami_barrens/exterior/telecomm/lz1_north
	name = "Khami Barrens - North LZ1 Communications Relay"

/area/khami_barrens/exterior/telecomm/lz1_south
	name = "Khami Barrens - South LZ1 Communications Relay"

/area/khami_barrens/exterior/telecomm/lz2_north
	name = "Khami Barrens - North LZ2 Communications Relay"

/area/khami_barrens/exterior/telecomm/lz2_south
	name = "Khami Barrens - South LZ2 Communications Relay"

//interior areas + caves

//Primary Colony Buildings
/area/khami_barrens/interior/complex
	name = "Kutjevo Complex"
	ceiling = CEILING_METAL
	icon_state = "khami_barrens"

/area/khami_barrens/interior/complex/botany
	name = "Kutjevo Complex - Botany Bay"
	icon_state = "botany0"
	minimap_color = MINIMAP_AREA_RESEARCH

/area/khami_barrens/interior/complex/botany/east
	name = "Kutjevo Complex - Botany East Hall"
	icon_state = "botany1"

/area/khami_barrens/interior/complex/botany/east_tech
	name = "Kutjevo Complex - Powerplant Access Hall"
	icon_state = "botany1"

/area/khami_barrens/interior/complex/botany/locks
	name = "Kutjevo Complex - Botany Stormlocks"
	icon_state = "botany0"

/area/khami_barrens/interior/complex/med
	name = "Kutjevo Complex - Medical Foyer"
	icon_state = "med0"
	minimap_color = MINIMAP_AREA_MEDBAY

/area/khami_barrens/interior/complex/med/auto_doc
	name = "Kutjevo Complex - Medical Autodoc Hallway"
	icon_state = "med2"

/area/khami_barrens/interior/complex/med/operating
	name = "Kutjevo Complex - Medical Operation Hallway"
	icon_state = "med3"

/area/khami_barrens/interior/complex/med/triage
	name = "Kutjevo Complex - Medical Triage Hallway"
	icon_state = "med4"

/area/khami_barrens/interior/complex/med/cells
	name = "Kutjevo Complex - Medical Cryocells"
	icon_state = "med5"

/area/khami_barrens/interior/complex/med/pano
	name = "Kutjevo Complex - Medical Panopticon"
	icon_state = "med3"

/area/khami_barrens/interior/complex/med/locks
	name = "Kutjevo Complex - Medical Stormlocks"
	icon_state = "med1"

/area/khami_barrens/interior/complex/Northwest_Dorms
	name = "Kutjevo Complex - Northwest Colony Dorms"
	icon_state = "Colony_int"
	ceiling = CEILING_METAL
	is_resin_allowed = FALSE

/area/khami_barrens/interior/complex/Northwest_Flight_Control
	name =  "Kutjevo Complex - Northwest Flight Control Room"
	icon_state = "Colony_int"
	ceiling = CEILING_METAL
	is_resin_allowed = FALSE

/area/khami_barrens/interior/complex/Northwest_Security_Checkpoint
	name = "Kutjevo Complex - Northwest Security Checkpoint"
	icon_state = "Colony_int"
	ceiling = CEILING_METAL
	is_resin_allowed = FALSE
	minimap_color = MINIMAP_AREA_SEC

//Out buildings + foremans
/area/khami_barrens/interior/power
	name = "Khami Barrens - Hydroelectric Dam Substation"
	ceiling = CEILING_METAL
	icon_state = "power"
	minimap_color = MINIMAP_AREA_ENGI

/area/khami_barrens/interior/power/comms
	name = "Khami Barrens - Hydroelectric Dam Comms Relay"
	ceiling = CEILING_METAL
	icon_state = "power"

/area/khami_barrens/interior/construction
	name = "Khami Barrens - Abandoned Construction Interior"
	ceiling = CEILING_METAL
	icon_state = "construction_int"

/area/khami_barrens/interior/foremans_office
	name = "Khami Barrens - Foreman's Office"
	ceiling = CEILING_METAL
	icon_state = "foremans"

/area/khami_barrens/interior/botany_bay_int
	name = "Khami Barrens - Space Weed Farm Interior"
	ceiling = CEILING_METAL
	icon_state = "weed_int"

/area/khami_barrens/interior/power_pt2_electric_boogaloo
	name = "Khami Barrens - Power Plant"
	ceiling = CEILING_METAL
	icon_state = "power_2"

/area/khami_barrens/interior/colony
	name = "Khami Barrens - Colony Building Interior"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS
	icon_state = "colony_int"

/area/khami_barrens/interior/colony_central
	name = "Khami Barrens - Central Colony Caves"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	icon_state = "colony_caves_0"
	minimap_color = MINIMAP_AREA_CAVES

/area/khami_barrens/interior/colony_central/mine_elevator
	name = "Khami Barrens - Central Colony Elevator"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	icon_state = "colony_caves_0"

/area/khami_barrens/interior/colony_north
	name = "Khami Barrens - North Colony Caves"
	ceiling = CEILING_DEEP_UNDERGROUND
	icon_state = "colony_caves_1"

/area/khami_barrens/interior/colony_S_East
	name = "Khami Barrens - North East Colony Caves"
	ceiling = CEILING_DEEP_UNDERGROUND
	icon_state = "colony_caves_2"

/area/khami_barrens/interior/colony_N_East
	name = "Khami Barrens - South East Colony Caves"
	ceiling = CEILING_DEEP_UNDERGROUND
	icon_state = "colony_caves_2"

/area/khami_barrens/interior/colony_South
	name = "Khami Barrens - South Colony Caves"
	ceiling = CEILING_DEEP_UNDERGROUND
	icon_state = "colony_caves_3"

/area/khami_barrens/interior/colony_South/power2
	name = "Khami Barrens - South Colony Treatment Plant"
	ceiling = CEILING_DEEP_UNDERGROUND
	icon_state = "colony_caves_3"
	minimap_color = MINIMAP_AREA_ENGI_CAVE
