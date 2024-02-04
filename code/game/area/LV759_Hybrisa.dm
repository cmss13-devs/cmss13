//lv759 AREAS--------------------------------------//

/area/lv759
	icon_state = "lv-626"
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
	soundscape_playlist = SCAPE_PL_LV522_OUTDOORS

/area/lv759/oob
	name = "LV759 - Out Of Bounds"
	icon_state = "unknown"
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

//Landing Zone 3 & 4

/area/lv759/landing_zone
	name = "Hybrisa - Shuttle"
	icon_state = "shuttle"
	ceiling =  CEILING_METAL

/area/lv759/landing_zone/landing_zone_3
	name = "Hybrisa - Landing Zone 3"
	icon_state = "blue"
	ceiling = CEILING_NONE

/area/lv759/landing_zone/landing_zone_4
	name = "Hybrisa - Landing Zone 4"
	icon_state = "blue"
	ceiling = CEILING_NONE

/area/lv759/landing_zone/UD10M_Bentley
	name = "Hybrisa - UD10M Bentley"
	requires_power = FALSE

/area/lv759/landing_zone/UD8M_Rover
	name = "Hybrisa - UD8M Rover"
	requires_power = FALSE

//Outdoors areas
/area/lv759/outdoors/colony_streets
	name = "Colony Streets"
	icon_state = "green"
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
	icon_state = "west"

/area/lv759/outdoors/colony_streets/east_central_street
	name = "Central Street - East"
	icon_state = "east"

/area/lv759/outdoors/colony_streets/south_street
	name = "Colony Streets - South"
	icon_state = "south"

/area/lv759/outdoors/colony_streets/south_east_street
	name = "Colony Streets - Southeast"
	icon_state = "southeast"

/area/lv759/outdoors/colony_streets/south_west_street
	name = "Colony Streets - Southwest"
	icon_state = "southwest"

/area/lv759/outdoors/colony_streets/north_west_street
	name = "Colony Streets - Northwest"
	icon_state = "northwest"

/area/lv759/outdoors/colony_streets/north_east_street
	name = "Colony Streets - Northeast"
	icon_state = "northeast"

/area/lv759/outdoors/colony_streets/north_street
	name = "Colony Streets - North"
	icon_state = "north"

//spaceport indoors
/area/lv759/indoors/spaceport
	name = "North LZ1 - Spaceport Auxiliary"
	icon_state = "green"
	minimap_color = MINIMAP_AREA_LZ

/area/lv759/indoors/spaceport/engineering
	name = "North LZ1 - Spaceport Engineering"
	icon_state = "engine_smes"
	minimap_color = MINIMAP_AREA_LZ

/area/lv759/indoors/spaceport/administration/east
	name = "North LZ1 - Spaceport West Administration"
	icon_state = "blue"
	minimap_color = MINIMAP_AREA_LZ

/area/lv759/indoors/spaceport/administration/west
	name = "North LZ1 - Spaceport East Administration"
	icon_state = "blue"
	minimap_color = MINIMAP_AREA_LZ

/area/lv759/indoors/spaceport/security
	name = "North LZ1 - Spaceport Engineering"
	icon_state = "red"
	minimap_color = MINIMAP_AREA_LZ

/area/lv759/indoors/spaceport/cargo
	name = "North LZ1 - Spaceport Cargo"
	icon_state = "red"
	minimap_color = MINIMAP_AREA_LZ

/area/lv759/indoors/spaceport/cuppajoes
	name = "North LZ1 - Spaceport Cuppajoes"
	icon_state = "red"
	minimap_color = MINIMAP_AREA_LZ

// Garage

/area/lv759/indoors/garage_office
	name = "LV759 - Garage Office"
	icon_state = "yellow"
	minimap_color = MINIMAP_AREA_ENGI

/area/lv759/indoors/garage_workshop
	name = "LV759 - Garage Workshop"
	icon_state = "engine_smes"
	minimap_color = MINIMAP_AREA_ENGI

//Recreation

/area/lv759/indoors/casino
	name = "LV759 - Night Gold Casino"
	icon_state = "red"
	minimap_color = MINIMAP_AREA_ENGI

/area/lv759/indoors/pizzaria
	name = "LV759 - Pizzaria"
	icon_state = "yellow"
	minimap_color = MINIMAP_AREA_ENGI

/area/lv759/indoors/weymart
	name = "LV759 - Weymart Floor"
	icon_state = "blue"
	minimap_color = MINIMAP_AREA_COMMAND
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC

/area/lv759/indoors/weymart_backrooms
	name = "LV759 - Weymart Backrooms"
	icon_state = "blue"
	minimap_color = MINIMAP_AREA_COMMAND

/area/lv759/indoors/chapel
	name = "LV759 - Chapel Pulpit"
	icon_state = "red"
	minimap_color = MINIMAP_AREA_COLONY
	soundscape_playlist = SCAPE_PL_ELEVATOR_MUSIC

/area/lv759/indoors/chapel_maintenance
	name = "LV759 - Chapel Office and Maintenance"
	icon_state = "red"
	minimap_color = MINIMAP_AREA_COLONY

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

/area/lv759/indoors/bar
	name = "LV759 - Karl's Bar"
	icon_state = "green"
	minimap_color = MINIMAP_AREA_COLONY

/area/lv759/indoors/bar/recroom
	name = "LV759 - Karl's Bar Recroom and Bathrooms"

/area/lv759/indoors/bar/maintenance
	name = "LV759 - Karl's Bar Maintenance"

/area/lv759/indoors/bar/kitchen
	name = "LV759 - Karl's Bar Kitchen"

/area/lv759/indoors/bar/botany
	name = "LV759 - Karl's Bar Botany"

/area/lv759/indoors/hospital
	icon_state = "medbay"
	minimap_color = MINIMAP_AREA_MEDBAY
/area/lv759/indoors/hospital/paramedics_garage
	name = "LV759 - Elpida's Memorial Hospital Paramedic's Garage"

/area/lv759/indoors/hospital/cryo_room
	name = "LV759 - Elpida's Memorial Hospital Cryo Ward"

/area/lv759/indoors/hospital/emergency_room
	name = "LV759 - Elpida's Memorial Hospital Emergency Room"

/area/lv759/indoors/hospital/reception
	name = "LV759 - Elpida's Memorial Hospital Reception"

/area/lv759/indoors/hospital/cmo_office
	name = "LV759 - Elpida's Memorial Hospital Chief Medical Officer's Office"

/area/lv759/indoors/hospital/maintenance
	name = "LV759 - Elpida's Memorial Hospital Engineering Maintenance"

/area/lv759/indoors/hospital/pharmacy
	name = "LV759 - Elpida's Memorial Hospital Pharmacy and Outgoing Foyer"

/area/lv759/indoors/hospital/outgoing
	name = "LV759 - Elpida's Memorial Hospital Outgoing Ward"

/area/lv759/indoors/hospital/central_hallway
	name = "LV759 - Elpida's Memorial Hospital Central Hallway"

/area/lv759/indoors/hospital/east_hallway
	name = "LV759 - Elpida's Memorial Hospital East Hallway"

/area/lv759/indoors/hospital/medical_storage
	name = "LV759 - Elpida's Memorial Hospital Medical Storage"

/area/lv759/indoors/hospital/operation
	name = "LV759 - Elpida's Memorial Hospital Operation Theatres and Observation"

/area/lv759/indoors/hospital/patient_ward
	name = "LV759 - Elpida's Memorial Hospital Patient Ward"

/area/lv759/indoors/hospital/virology
	name = "LV759 - Elpida's Memorial Hospital Virology"

/area/lv759/indoors/hospital/morgue
	name = "LV759 - Elpida's Memorial Hospital Morgue"

/area/lv759/indoors/hospital/icu
	name = "LV759 - Elpida's Memorial Hospital Intensive Care Ward"

/area/lv759/lone_buildings/mining_outpost
	name = "LV759 - North Mining Outpost"
	icon_state = "yellow"
	minimap_color = MINIMAP_AREA_COLONY

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

/area/lv759/colonial_marshals
	name = "LV759 - CMB Police Station Prisoner's Recroom"
	icon_state = "red"
	minimap_color = MINIMAP_AREA_SEC

/area/lv759/colonial_marshals/prisoners_cells
	name = "LV759 - CMB Police Station Prisoner's Cells"

/area/lv759/colonial_marshals/garage
	name = "LV759 - CMB Police Station Garage and Lockers"

/area/lv759/colonial_marshals/armory
	name = "LV759 - CMB Police Station Armory"

/area/lv759/colonial_marshals/office
	name = "LV759 - CMB Police Station South Office"

/area/lv759/colonial_marshals/hallway
	name = "LV759 - CMB Police Station Central Hallway"

/area/lv759/colonial_marshals/holding_cells
	name = "LV759 - CMB Police Station Holding Cells"

/area/lv759/colonial_marshals/head_office
	name = "LV759 - CMB Police Station Head Office"

/area/lv759/colonial_marshals/north_office
	name = "LV759 - CMB Police Station North Office"

/area/lv759/colonial_marshals/press_room
	name = "LV759 - CMB Police Station Press Room"

/area/lv759/lone_buildings/jacks_surplus
	name = "LV759 - Jack's Surplus"
	icon_state = "green"
	minimap_color = MINIMAP_AREA_COLONY

/area/lv759/lone_buildings/south_public_restroom
	name = "LV759 - Southern Public Restroom"
	icon_state = "green"
	minimap_color = MINIMAP_AREA_COLONY
