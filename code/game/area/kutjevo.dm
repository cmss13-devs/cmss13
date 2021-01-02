
//Areas for the Kutjevo Refinery

/area/kutjevo
	name = "Kutjevo Refinery"
	icon = 'icons/turf/area_kutjevo.dmi'
	//ambience = list('figuresomethingout.ogg')
	icon_state = "kutjevo"
	can_build_special = TRUE //T-Comms structure
	temperature = 308.7 //kelvin, 35c, 95f
	lighting_use_dynamic = 1

/area/shuttle/drop1/kutjevo
	name = "Kutjevo - Dropship Alamo Landing Zone"
	icon_state = "shuttle"
	icon = 'icons/turf/area_kutjevo.dmi'
	lighting_use_dynamic = 1

/area/shuttle/drop2/kutjevo
	name = "Kutjevo - Dropship Normandy Landing Zone"
	icon_state = "shuttle2"
	icon = 'icons/turf/area_kutjevo.dmi'
	lighting_use_dynamic = 1

/area/kutjevo/exterior
	name = "Kutjevo - Exterior"
	ceiling = CEILING_NONE
	icon_state = "ext"


/area/kutjevo/interior
	name = "Kutjevo - Interior"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	icon_state = "int"
	requires_power = 1

/area/kutjevo/interior/oob
	name = "Kutjevo -  Out Of Bounds"
	ceiling = CEILING_MAX
	icon_state = "oob"
	is_resin_allowed = FALSE
	flags_atom = AREA_NOTUNNEL

/area/kutjevo/interior/oob/dev_room
	name = "Kutjevo - Credits Room"
	is_resin_allowed = FALSE
	flags_atom = AREA_NOTUNNEL
	icon_state = "kutjevo"

//exterior map areas

/area/kutjevo/exterior/lz_pad
	name = "Kutjevo Auxilliary Landing Zone"
	icon_state = "lz_pad"
	weather_enabled = FALSE
	unlimited_power = 1//ds computer
	is_resin_allowed = FALSE

/area/kutjevo/exterior/lz_dunes
	name = "Kutjevo - Landing Zone Dunes"
	icon_state = "lz_dunes"
	is_resin_allowed = FALSE
/area/kutjevo/exterior/lz_river
	name = "Kutjevo - Power Station River"
	icon_state = "lz_river"

/area/kutjevo/exterior/scrubland
	name = "Kutjevo - Scrubland"
	icon_state = "scrubland"

/area/kutjevo/exterior/stonyfields
	name = "Kutjevo - Stony Fields"
	icon_state = "stone_fields"

/area/kutjevo/exterior/runoff_dunes
	name = "Kutjevo - Runoff Dunes"
	icon_state = "rf_dunes"

/area/kutjevo/exterior/runoff_river
	name = "Kutjevo - Runoff River"
	icon_state = "rf_river"

/area/kutjevo/exterior/runoff_bridge
	name = "Kutjevo - Runoff Bridge"
	icon_state = "rf_bridge"

/area/kutjevo/exterior/overlook
	name = "Kutjevo - Runoff River Overlook"
	icon_state = "rf_overlook"

/area/kutjevo/exterior/botany_bay_ext
	name = "Kutjevo - Space Weed Farm Exterior"
	icon_state = "weed_ext"

/area/kutjevo/exterior/construction
	name = "Kutjevo - Abandoned Construction"
	icon_state = "construction"

/area/kutjevo/exterior/complex_border
	name = "Kutjevo Complex - Exterior"
	icon_state = "kutjevo"

/area/kutjevo/exterior/complex_border/botany_medical_cave
	name = "Kutjevo Complex - Botany - Medical Cave"
	icon_state = "med_ext"

/area/kutjevo/exterior/complex_border/med_park
	name = "Kutjevo Complex - Medical Park"
	icon_state = "med_ext"

/area/kutjevo/exterior/complex_border/med_rec
	name = "Kutjevo Complex - Water Tank Cave"
	icon_state = "construction2"

//interior areas + caves

//Primary Colony Buildings
/area/kutjevo/interior/complex
	name = "Kutjevo Complex"
	ceiling = CEILING_METAL
	icon_state = "kutjevo"

/area/kutjevo/interior/complex/botany
	name = "Kutjevo Complex - Botany Bay"
	icon_state = "botany0"

/area/kutjevo/interior/complex/botany/east
	name = "Kutjevo Complex - Botany East Hall"
	icon_state = "botany1"

/area/kutjevo/interior/complex/botany/locks
	name = "Kutjevo Complex - Botany Stormlocks"
	icon_state = "botany0"

/area/kutjevo/interior/complex/med
	name = "Kutjevo Complex - Medical Foyer"
	icon_state = "med0"

/area/kutjevo/interior/complex/med/auto_doc
	name = "Kutjevo Complex - Medical Autodoc Hallway"
	icon_state = "med2"

/area/kutjevo/interior/complex/med/operating
	name = "Kutjevo Complex - Medical Operation Hallway"
	icon_state = "med3"

/area/kutjevo/interior/complex/med/triage
	name = "Kutjevo Complex - Medical Triage Hallway"
	icon_state = "med4"

/area/kutjevo/interior/complex/med/cells
	name = "Kutjevo Complex - Medical Cryocells"
	icon_state = "med5"

/area/kutjevo/interior/complex/med/pano
	name = "Kutjevo Complex - Medical Panopticon"
	icon_state = "med3"

/area/kutjevo/interior/complex/med/locks
	name = "Kutjevo Complex - Medical Stormlocks"
	icon_state = "med1"

//Out buildings + foremans
/area/kutjevo/interior/power
	name = "Kutjevo - Hydroelectric Dam Substation"
	ceiling = CEILING_METAL
	icon_state = "power"

/area/kutjevo/interior/construction
	name = "Kutjevo - Abandoned Construction Interior"
	ceiling = CEILING_METAL
	icon_state = "construction_int"

/area/kutjevo/interior/foremans_office
	name = "Kutjevo - Foreman's Office"
	ceiling = CEILING_METAL
	icon_state = "foremans"

/area/kutjevo/interior/botany_bay_int
	name = "Kutjevo - Space Weed Farm Interior"
	ceiling = CEILING_METAL
	icon_state = "weed_int"

/area/kutjevo/interior/power_pt2_electric_boogaloo
	name = "Kutjevo - Power Plant"
	ceiling = CEILING_METAL
	icon_state = "power_2"

/area/kutjevo/interior/colony
	name = "Kutjevo - Colony Building Interior"
	ceiling = CEILING_UNDERGROUND_METAL_ALLOW_CAS
	icon_state = "colony_int"
	can_hellhound_enter = 0

/area/kutjevo/interior/colony_central
	name = "Kutjevo - Central Colony Caves"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	icon_state = "colony_caves_0"
	can_hellhound_enter = 0

/area/kutjevo/interior/colony_central/mine_elevator
	name = "Kutjevo - Central Colony Elevator"
	ceiling = CEILING_UNDERGROUND_ALLOW_CAS
	icon_state = "colony_caves_0"
	can_hellhound_enter = 0

/area/kutjevo/interior/colony_north
	name = "Kutjevo - North Colony Caves"
	ceiling = CEILING_DEEP_UNDERGROUND
	icon_state = "colony_caves_1"
	can_hellhound_enter = 0

/area/kutjevo/interior/colony_S_East
	name = "Kutjevo - North East Colony Caves"
	ceiling = CEILING_DEEP_UNDERGROUND
	icon_state = "colony_caves_2"
	can_hellhound_enter = 0

/area/kutjevo/interior/colony_N_East
	name = "Kutjevo - South East Colony Caves"
	ceiling = CEILING_DEEP_UNDERGROUND
	icon_state = "colony_caves_2"
	can_hellhound_enter = 0

/area/kutjevo/interior/colony_South
	name = "Kutjevo - South Colony Caves"
	ceiling = CEILING_DEEP_UNDERGROUND
	icon_state = "colony_caves_3"
	can_hellhound_enter = 0

/area/kutjevo/interior/colony_South/power2
	name = "Kutjevo - South Colony Treatment Plant"
	ceiling = CEILING_DEEP_UNDERGROUND
	icon_state = "colony_caves_3"
	can_hellhound_enter = 0
