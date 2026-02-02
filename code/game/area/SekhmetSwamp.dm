//==================================================================SEKHMET SWAMP
//BASE
/area/sekhmet
	name = "Sekhmet Swamp"
	icon_state = "lv626"
	can_build_special = TRUE
	powernet_name = "ground"
	minimap_color = MINIMAP_AREA_COLONY
//============================================================PARENTS
/area/sekhmet/outside
	name = "Sekhmet Exterior"
	ceiling = CEILING_NONE
/area/sekhmet/int_glass
	name = "Sekhmet Glass"
	ceiling = CEILING_GLASS
/area/sekhmet/int_reg
	name = "Sekhmet Metal"
	ceiling = CEILING_METAL
/area/sekhmet/int_heavy
	name = "Sekhmet Reinforced"
	ceiling = CEILING_REINFORCED_METAL
/area/sekhmet/caves
	name = "Sekhmet Caves"
	ceiling = CEILING_DEEP_UNDERGROUND
//============================================================SHUTTLES
/area/sekhmet/shuttles/drop1
	name = "Sekhmet - Military Landing Pad"
	icon_state = "shuttle"
	icon = 'icons/turf/area_varadero.dmi'
	minimap_color = MINIMAP_AREA_LZ
/area/sekhmet/shuttles/drop2
	name = "Sekhmet - Open Field"
	icon_state = "shuttle2"
	icon = 'icons/turf/area_varadero.dmi'
	minimap_color = MINIMAP_AREA_LZ
/area/sekhmet/shuttles/drop3
	name = "Sekhmet - Research Landing Pad"
	icon_state = "shuttle"
	icon = 'icons/turf/area_varadero.dmi'
	minimap_color = MINIMAP_AREA_LZ
//============================================================NORTHWEST PORTION (military base, swamps, communication lower, air filtration, caves)
/area/sekhmet/int_reg/military_hangar
	name = "UPP Military Landing Zone"
	icon_state = "away1"
/area/sekhmet/int_reg/catwalk
	name = "Swamp Catwalk"
	icon_state = "away2"
/area/sekhmet/outside/swamp
	name = "Sekhmet Swamp"
	icon_state = "northwest"
/area/sekhmet/int_reg/comms_lower
	name = "Sekhmet Lower Commmunication Hall"
	icon_state = "away3"
/area/sekhmet/int_reg/air_filters
	name = "Sekhmet Air Filtrators"
	icon_state = "away3"
/area/sekhmet/caves/west_cave
	name = "Sekhmet West Caves"
	icon_state = "cave"
//============================================================SOUTHWEST PORTION (airfield, medbay, warehouse)
/area/sekhmet/outside/airfield
	name = "Sekhmet Clearing"
	icon_state = "southwest"
/area/sekhmet/int_glass/hosptial
	name = "Sekhmet Treatment Center"
	icon_state = "medbay"
/area/sekhmet/int_reg/southwest_complex
	name = "Sekhmet Southwestern Complex"
	icon_state = "away1"
/area/sekhmet/int_reg/warehouse
	name = "Sekhmet Warehouse"
	icon_state = "cargo"
/area/sekhmet/outside/southroad
	name = "Sekhmet Southern Path"
	icon_state = "south"
/area/sekhmet/caves/south_cave
	name = "Sekhmet South Caves"
	icon_state = "cave"
//============================================================CENTRAL PORTION (central complex, yard, roadways, comms)
/area/sekhmet/outside/central_road
	name = "Sekhmet Central Path"
	icon_state = "away2"
/area/sekhmet/int_glass/complex_generic
	name = "Sekhmet Central Complex"
	icon_state = "away1"
/area/sekhmet/int_reg/complex_intel
	name = "Sekhmet Intelligence"
	icon_state = "blue-red2"
/area/sekhmet/int_reg/complex_operation
	name = "Sekhmet Operations"
	icon_state = "blue"
/area/sekhmet/int_reg/complex_comms
	name = "Sekhmet Communication Array"
	icon_state = "away3"
/area/sekhmet/int_glass/south_complex
	name = "Sekhmet Southern Complex"
	icon_state = "green"
/area/sekhmet/int_reg/water_filters
	name = "Sekhmet Water Filtration"
	icon_state = "red"
/area/sekhmet/int_glass/offices
	name = "Sekhmet Administrators Office"
	icon_state = "yellow"
/area/sekhmet/int_reg/engineering
	name = "Sekhmet Engineering"
	icon_state = "SMES"
/area/sekhmet/int_heavy/entry_zone
	name = "Sekhmet Entry Zone"
	icon_state = "red"
/area/sekhmet/int_reg/yard
	name = "Sekhmet Breaking Yard"
	icon_state = "blue-red2"
//============================================================EAST PORTION (research, jungle, temple)
/area/sekhmet/outside/east_jungle
	name = "Sekhmet Eastern Jungle"
	icon_state = "east"
/area/sekhmet/caves/temple
	name = "Sekhmet Ruins"
	icon_state = "cave"
/area/sekhmet/outside/temple_outer
	name = "Sekhmet Outer Ruins"
	icon_state = "northwest"
/area/sekhmet/outside/southeast_road
	name = "Sekhmet Southeastern Path"
	icon_state = "southeast"
/area/sekhmet/int_heavy/research
	name = "Sekhmet Research Main Floor"
	icon_state = "research"
/area/sekhmet/int_reg/garage
	name = "Sekhmet Garage"
	icon_state = "yellow"
//============================================================UNDERGROUND PORTION (Very Lazy Two Sectors)
/area/sekhmet/int_heavy/low_level_gen
	name = "Sekhmet Lower Complex"
	icon_state = "red"
/area/sekhmet/int_heavy/low_level_rsr
	name = "Sekhmet Lower Research"
	icon_state = "green"
//============================================================EXTRA PORTION
/area/sekhmet/int_reg/ship1
	name = "Mikhail GENESIS-class Freight Hauler"
	icon_state = "blue-red2"
/area/sekhmet/int_reg/ship2
	name = "Atreus SEQUOD-class Transport Ship"
	icon_state = "blue-red2"
