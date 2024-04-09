//lv759 AREAS--------------------------------------//cabv

/area/lv759
	name = "LV759 - Hybrisa Prospera"
	icon = 'icons/turf/hybrisareas.dmi'
	icon_state = "hybrisa"
	can_build_special = TRUE
	powernet_name = "ground"
	minimap_color = MINIMAP_AREA_COLONY

//parent types

/area/lv759/indoors
	name = "Hybrisa - Outdoors"
	icon_state = "cliff_blocked" //because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_METAL
	soundscape_playlist = SCAPE_PL_LV522_INDOORS


/area/lv759/outdoors
	name = "Hybrisa - Outdoors"
	icon_state = "cliff_blocked" //because this is a PARENT TYPE and you should not be using it and should also be changing the icon!!!
	ceiling = CEILING_NONE
	soundscape_playlist = SCAPE_PL_LV759_OUTDOORS
/area/lv759/oob
	name = "LV759 - Out Of Bounds"
	icon_state = "oob"
	ceiling = CEILING_MAX
	is_resin_allowed = FALSE
	flags_area = AREA_NOTUNNEL

//Landing Zone 1

/area/lv759/landing_zone_1
	name = "Hybrisa - Landing Zone One"
	icon_state = "explored"
	is_resin_allowed =  FALSE
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ

/area/lv759/landing_zone_1/ceiling
	ceiling = CEILING_METAL

/area/lv759/landing_zone_1/tunnel
	name = "Hybrisa - Landing Zone One Tunnels"
	ceiling = CEILING_METAL

/area/shuttle/drop1/lv759
	name = "Hybrisa - Dropship Alamo Landing Zone"
	icon_state = "shuttle"
	icon = 'icons/turf/area_shiva.dmi'

/area/lv759/landing_zone_1/lz1_console
	name = "Hybrisa - Dropship Alamo Console"
	icon_state = "tcomsatcham"
	requires_power = FALSE

//Landing Zone 2

/area/lv759/landing_zone_2
	name = "Hybrisa - Landing Zone Two"
	icon_state = "explored"
	is_resin_allowed =  FALSE
	is_landing_zone = TRUE
	minimap_color = MINIMAP_AREA_LZ

/area/lv759/landing_zone_2/ceiling
	ceiling = CEILING_METAL

/area/shuttle/drop2/lv759
	name = "Hybrisa - Dropship Normandy Landing Zone"
	icon_state = "shuttle2"
	icon = 'icons/turf/area_shiva.dmi'

/area/lv759/landing_zone_2/lz2_console
	name = "Hybrisa - Dropship Normandy Console"
	icon_state = "tcomsatcham"
	requires_power = FALSE

//Outdoors areas

// Caves
/area/lv759/outdoors/caves
	name = "Hybrisa - Caverns"
	icon_state = "caves_north"
	ceiling = CEILING_NONE
	soundscape_playlist = SCAPE_PL_LV759_CAVES
/area/lv759/outdoors/caves/west_caves
	name = "Caverns - West"
	icon_state = "caves_west"
/area/lv759/outdoors/caves/east_caves
	name = "Caverns - East"
	icon_state = "caves_east"
/area/lv759/outdoors/caves/south_caves
	name = "Caverns - South"
	icon_state = "caves_south"
/area/lv759/outdoors/caves/south_east_caves
	name = "Caverns - Southeast"
	icon_state = "caves_southeast"
/area/lv759/outdoors/caves/south_west_caves
	name = "Caverns - Southwest"
	icon_state = "caves_southwest"
/area/lv759/outdoors/caves/north_west_caves
	name = "Caverns - Northwest"
	icon_state = "caves_northwest"
/area/lv759/outdoors/caves/north_east_caves
	name = "Caverns - Northeast"
	icon_state = "caves_northeast"
/area/lv759/outdoors/caves/north_caves
	name = "Caverns - North"
	icon_state = "caves_north"
/area/lv759/outdoors/caves/central_caves
	name = "Caverns - Central"
	icon_state = "caves_central"

// Caves Central Plateau
/area/lv759/outdoors/caveplateau
	name = "Caverns - Plateau"
	icon_state = "caves_plateau"
	ceiling = CEILING_NONE
	soundscape_playlist = SCAPE_PL_LV522_OUTDOORS

// Colony Streets
/area/lv759/outdoors/colony_streets
	name = "Colony Streets"
	icon_state = "colonystreets_north"
	ceiling = CEILING_NONE
/area/lv759/outdoors/colony_streets/windbreaker
	name = "Colony Windbreakers"
	icon_state = "tcomsatcham"
	requires_power = FALSE
	ceiling = CEILING_NONE

/area/lv759/outdoors/colony_streets/windbreaker/observation
	name = "Colony Windbreakers - Observation"
	icon_state = "purple"
	requires_power = FALSE
	ceiling = CEILING_GLASS
	soundscape_playlist = SCAPE_PL_LV522_INDOORS

/area/lv759/outdoors/colony_streets/central_streets
	name = "Central Street - West"
	icon_state = "colonystreets_west"

/area/lv759/outdoors/colony_streets/east_central_street
	name = "Central Street - East"
	icon_state = "colonystreets_east"

/area/lv759/outdoors/colony_streets/south_street
	name = "Colony Streets - South"
	icon_state = "colonystreets_south"

/area/lv759/outdoors/colony_streets/south_east_street
	name = "Colony Streets - Southeast"
	icon_state = "colonystreets_southeast"

/area/lv759/outdoors/colony_streets/south_west_street
	name = "Colony Streets - Southwest"
	icon_state = "colonystreets_southwest"

/area/lv759/outdoors/colony_streets/north_west_street
	name = "Colony Streets - Northwest"
	icon_state = "colonystreets_northwest"

/area/lv759/outdoors/colony_streets/north_east_street
	name = "Colony Streets - Northeast"
	icon_state = "colonystreets_northeast"

/area/lv759/outdoors/colony_streets/north_street
	name = "Colony Streets - North"
	icon_state = "colonystreets_north"

//Spaceport Indoors
/area/lv759/indoors/spaceport
	name = "North LZ1 - Spaceport Auxiliary"
	icon_state = "green"
	minimap_color = MINIMAP_AREA_LZ
/area/lv759/indoors/spaceport/engineering
	name = "North LZ1 - Spaceport Engineering"
	icon_state = "engine_smes"
	minimap_color = MINIMAP_AREA_LZ
/area/lv759/indoors/spaceport/administration/east
	name = "Weyland Yutani Celestia Gateway Space-Port - Communications & Administration Office"
	icon_state = "WYSpaceportadmin"
	minimap_color = MINIMAP_AREA_LZ
/area/lv759/indoors/spaceport/administration/west
	name = "Weyland Yutani Celestia Gateway Space-Port - Flight Control Room"
	icon_state = "WYSpaceportadmin"
	minimap_color = MINIMAP_AREA_LZ
/area/lv759/indoors/spaceport/security
	name = "North LZ1 - Spaceport Engineering"
	icon_state = "red"
	minimap_color = MINIMAP_AREA_LZ
/area/lv759/indoors/spaceport/cargo
	name = "Weyland Yutani Celestia Gateway Space-Port - Cargo"
	icon_state = "WYSpaceportcargo"
	minimap_color = MINIMAP_AREA_LZ
/area/lv759/indoors/spaceport/baggagehandling
	name = "Weyland Yutani Celestia Gateway Space-Port - Baggage Storage & Handling"
	icon_state = "WYSpaceportbaggage"
	minimap_color = MINIMAP_AREA_LZ
/area/lv759/indoors/spaceport/cuppajoes
	name = "Weyland Yutani Celestia Gateway Space-Port - Cuppa Joe's"
	icon_state = "cuppajoes"
	minimap_color = MINIMAP_AREA_LZ
/area/lv759/landing_zone
	name = "Hybrisa - Shuttle"
	icon_state = "shuttle"
	ceiling =  CEILING_METAL
/area/lv759/landing_zone/landing_zone_3
	name = "Weyland Yutani Celestia Gateway Space-Port - Docking Bay: 2 - Refueling and Maintenance"
	icon_state = "WYSpaceportblue"
	ceiling = CEILING_NONE
/area/lv759/landing_zone/landing_zone_4
	name = "Weyland Yutani Celestia Gateway Space-Port - Docking Bay: 1"
	icon_state = "WYSpaceport"
	ceiling = CEILING_NONE
/area/lv759/landing_zone/starglider
	name = "Hybrisa - WY-LWI StarGlider SG-200"
	icon_state = "wydropship"
	requires_power = FALSE
/area/lv759/landing_zone/horizon_runner
	name = "Hybrisa - WY-LWI Horizon Runner HR-150"
	icon_state = "wydropship"
	requires_power = FALSE

// Garage

/area/lv759/indoors/garage_office
	name = "LV759 - Garage Office"
	icon_state = "yellow"
	minimap_color = MINIMAP_AREA_ENGI

/area/lv759/indoors/garage_workshop
	name = "LV759 - Garage Workshop"
	icon_state = "engine_smes"
	minimap_color = MINIMAP_AREA_ENGI

// Meridian Offices & Factory Floor
/area/lv759/indoors/meridian/meridian_foyer
	name = "LV759 - Meridian - Foyer"
	icon_state = "meridian"
	minimap_color = MINIMAP_AREA_COLONY
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
/area/lv759/indoors/meridian/meridian_showroom
	name = "LV759 - Meridian - Showroom"
	icon_state = "meridian"
	minimap_color = MINIMAP_AREA_COLONY
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC
/area/lv759/indoors/meridian/meridian_office
	name = "LV759 - Meridian - Office"
	icon_state = "meridian"
	minimap_color = MINIMAP_AREA_COLONY
/area/lv759/indoors/meridian/meridian_managersoffice
	name = "LV759 - Meridian - Manager's Office"
	icon_state = "meridian"
	minimap_color = MINIMAP_AREA_COLONY
/area/lv759/indoors/meridian/meridian_factory
	name = "LV759 - Meridian - Factory Floor"
	icon_state = "meridian_factory"
	minimap_color = MINIMAP_AREA_COLONY

// Apartments (Dorms)
/area/lv759/indoors/apartment/west
	name = "LV759 - West Apartment Bedrooms and Recroom"
	icon_state = "green"
	minimap_color = MINIMAP_AREA_COLONY

/area/lv759/indoors/apartment_services/west
	name = "LV759 - West Apartment Services"
	icon_state = "green"
	minimap_color = MINIMAP_AREA_COLONY

/area/lv759/indoors/apartment/east
	name = "LV759 - East Apartment Bedrooms and Foyer"
	icon_state = "green"
	minimap_color = MINIMAP_AREA_COLONY

/area/lv759/indoors/apartment_services/east
	name = "LV759 - East Apartment Services"
	icon_state = "green"
	minimap_color = MINIMAP_AREA_COLONY

// Weyland-Yutani Offices
/area/lv759/indoors/weyyu_office
	name = "LV759 - Weyland Yutani Offices Hallways"
	icon_state = "blue"
	minimap_color = MINIMAP_AREA_COMMAND

/area/lv759/indoors/weyyu_office/floor
	name = "LV759 - Weyland Yutani Offices Floor"

/area/lv759/indoors/weyyu_office/breakroom
	name = "LV759 - Weyland Yutani Offices Breakroom"

/area/lv759/indoors/weyyu_office/vip
	name = "LV759 - Weyland Yutani Offices VIP Meeting Room and Office"

/area/lv759/indoors/weyyu_office/pressroom
	name = "LV759 - Weyland Yutani Offices Press Room"

// Bar & Entertainment Complex
/area/lv759/indoors/bar
	name = "LV759 - Bar"
	icon_state = "green"
	minimap_color = MINIMAP_AREA_COLONY

/area/lv759/indoors/bar/entertainment
	name = "LV759 - Bar - Entertainment Subsection"
/area/lv759/indoors/bar/bathroom
	name = "LV759 - Bar - Bathrooms"
/area/lv759/indoors/bar/maintenance
	name = "LV759 - Bar - Maintenance"
/area/lv759/indoors/bar/kitchen
	name = "LV759 - Bar - Kitchen"
/area/lv759/indoors/bar/botany
	name = "LV759 - Bar - Botany"

// Hosptial
/area/lv759/indoors/hospital
	icon_state = "medical"
	minimap_color = MINIMAP_AREA_MEDBAY
/area/lv759/indoors/hospital/paramedics_garage
	name = "LV759 - Nova Medica Hospital Pavilion - Paramedic's Garage"
/area/lv759/indoors/hospital/cryo_room
	name = "LV759 - Nova Medica Hospital Pavilion - Cryo Ward"
/area/lv759/indoors/hospital/emergency_room
	name = "LV759 - Nova Medica Hospital Pavilion - Emergency Room"
/area/lv759/indoors/hospital/reception
	name = "LV759 - Nova Medica Hospital Pavilion - Reception"
/area/lv759/indoors/hospital/cmo_office
	name = "LV759 - Nova Medica Hospital Pavilion - Chief Medical Officer's Office"
/area/lv759/indoors/hospital/maintenance
	name = "LV759 - Nova Medica Hospital Pavilion - Engineering Maintenance"
/area/lv759/indoors/hospital/pharmacy
	name = "LV759 - Nova Medica Hospital Pavilion - Pharmacy and Outgoing Foyer"
/area/lv759/indoors/hospital/outgoing
	name = "LV759 - Nova Medica Hospital Pavilion - Outgoing Ward"
/area/lv759/indoors/hospital/central_hallway
	name = "LV759 - Nova Medica Hospital Pavilion - Central Hallway"
/area/lv759/indoors/hospital/east_hallway
	name = "LV759 - Nova Medica Hospital Pavilion - East Hallway"
/area/lv759/indoors/hospital/medical_storage
	name = "LV759 - Nova Medica Hospital Pavilion - Medical Storage"
/area/lv759/indoors/hospital/operation
	name = "LV759 - Nova Medica Hospital Pavilion - Operation Theatres and Observation"
/area/lv759/indoors/hospital/patient_ward
	name = "LV759 - Nova Medica Hospital Pavilion - Patient Ward"
/area/lv759/indoors/hospital/virology
	name = "LV759 - Nova Medica Hospital Pavilion - Virology"
/area/lv759/indoors/hospital/morgue
	name = "LV759 - Nova Medica Hospital Pavilion - Morgue"
/area/lv759/indoors/hospital/icu
	name = "LV759 - Nova Medica Hospital Pavilion - Intensive Care Ward"

// Mining
/area/lv759/lone_buildings/mining_outpost
	name = "LV759 - North Mining Outpost"
	icon_state = "yellow"
	minimap_color = MINIMAP_AREA_COLONY

// Power-Plant (Engineering)
/area/lv759/power_plant
	name = "LV759 - Power Plant Central Hallway"
	icon_state = "yellow"
	minimap_color = MINIMAP_AREA_COLONY
/area/lv759/power_plant/south_hallway
	name = "LV759 - Power Plant South Hallway"
/area/lv759/power_plant/geothermal_generators
	name = "LV759 - Power Plant Geothermal Generators Room"
/area/lv759/power_plant/power_storage
	name = "LV759 - Power Plant Battery Array and Transformers"
/area/lv759/power_plant/gas_generators
	name = "LV759 - Power Plant Backup Gas Generators"
/area/lv759/power_plant/fusion_generators
	name = "LV759 - Power Plant Fusion Generators"
/area/lv759/power_plant/telecomms
	name = "LV759 - Power Plant Telecommunications"
/area/lv759/power_plant/workers_canteen
	name = "LV759 - Power Plant Worker's Canteen"

// Marshalls
/area/lv759/colonial_marshals
	name = "LV759 - CMB - Sentinel Outpost - Prisoner's Recroom"
	icon_state = "security_hub"
	minimap_color = MINIMAP_AREA_SEC
/area/lv759/colonial_marshals/prisoners_cells
	name = "LV759 - CMB - Sentinel Outpost - Prisoner's Cells"
/area/lv759/colonial_marshals/garage
	name = "LV759 - CMB - Sentinel Outpost - Vehicle Deployment & Maintenace"
/area/lv759/colonial_marshals/armory
	name = "LV759 - CMB - Sentinel Outpost - Armory"
/area/lv759/colonial_marshals/office
	name = "LV759 - CMB - Sentinel Outpost - Office"
/area/lv759/colonial_marshals/hallway
	name = "LV759 - CMB - Sentinel Outpost - Central Hallway"
/area/lv759/colonial_marshals/hallway
	name = "LV759 - CMB - Sentinel Outpost - South Hallway"
/area/lv759/colonial_marshals/hallway
	name = "LV759 - CMB - Sentinel Outpost - Reception Hallway"
/area/lv759/colonial_marshals/hallway
	name = "LV759 - CMB - Sentinel Outpost - North Hallway"
/area/lv759/colonial_marshals/holding_cells
	name = "LV759 - CMB - Sentinel Outpost - Holding Cells"
/area/lv759/colonial_marshals/head_office
	name = "LV759 - CMB - Sentinel Outpost - Forensics Office"
/area/lv759/colonial_marshals/north_office
	name = "LV759 - CMB - Sentinel Outpost - North Office"
/area/lv759/colonial_marshals/wardens_office
	name = "LV759 - CMB - Sentinel Outpost - Wardens Office"
/area/lv759/colonial_marshals/interrogation
	name = "LV759 - CMB - Sentinel Outpost - Interrogation"
/area/lv759/colonial_marshals/press_room
	name = "LV759 - CMB - Sentinel Outpost - Court Room"

// Lone Buildings

/area/lv759/lone_buildings/synthetic_storage
	name = "LV759 - Synthetic Storage"
	icon_state = "yellow"
	minimap_color = MINIMAP_AREA_COLONY
/area/lv759/recycling_plant
	name = "LV759 - Recycling Plant"
	icon_state = "yellow"
	minimap_color = MINIMAP_AREA_COLONY
/area/lv759/recycling_plant/garage
	name = "LV759 - Recycling Plant Garage"
	icon_state = "yellow"
	minimap_color = MINIMAP_AREA_COLONY
/area/lv759/lone_buildings/jacks_surplus
	name = "LV759 - Jack's Surplus"
	icon_state = "green"
	minimap_color = MINIMAP_AREA_COLONY
/area/lv759/lone_buildings/south_public_restroom
	name = "LV759 - Southern Public Restroom"
	icon_state = "green"
	minimap_color = MINIMAP_AREA_COLONY
/area/lv759/indoors/casino
	name = "LV759 - Night Gold Casino"
	icon_state = "red"
	minimap_color = MINIMAP_AREA_ENGI
/area/lv759/indoors/pizzaria
	name = "LV759 - Pizzaria"
	icon_state = "yellow"
	minimap_color = MINIMAP_AREA_ENGI

// Weymart
/area/lv759/indoors/weymart
	name = "LV759 - Weymart"
	icon_state = "weymart"
	minimap_color = MINIMAP_AREA_COMMAND
	soundscape_playlist = SCAPE_PL_LV759_WEYMART
/area/lv759/indoors/weymart_backrooms
	name = "LV759 - Weymart - Backrooms"
	icon_state = "weymartbackrooms"
	minimap_color = MINIMAP_AREA_COMMAND
/area/lv759/indoors/weymart_maintenance
	name = "LV759 - Weymart - Maintenance"
	icon_state = "weymartbackrooms"
	minimap_color = MINIMAP_AREA_COMMAND

// WY Security Checkpoints
/area/lv759/lone_buildings/wy_security_checkpoint_northeast
	name = "LV759 - Weyland Yutani Security Checkpoint - North East"
	icon_state = "security_checkpoint_northeast"
	minimap_color = MINIMAP_AREA_COLONY
/area/lv759/lone_buildings/wy_security_checkpoint_east
	name = "LV759 - Weyland Yutani Security Checkpoint - East"
	icon_state = "security_checkpoint_east"
/area/lv759/lone_buildings/wy_security_checkpoint_central
	name = "LV759 - Weyland Yutani Security Checkpoint - Central"
	icon_state = "security_checkpoint_central"
/area/lv759/lone_buildings/wy_security_checkpoint_west
	name = "LV759 - Weyland Yutani Security Checkpoint - West"
	icon_state = "security_checkpoint_west"
/area/lv759/lone_buildings/wy_security_checkpoint_northwest
	name = "LV759 - Weyland Yutani Security Checkpoint - North West"
	icon_state = "security_checkpoint_northwest"
// Misc
/area/lv759/derelict/derelictship
	name = "LV759 - Derelict Ship"
	icon_state = "derelictship"
	minimap_color = MINIMAP_AREA_COLONY
	ceiling = CEILING_MAX
	soundscape_playlist = SCAPE_PL_LV759_DERELICTSHIP
