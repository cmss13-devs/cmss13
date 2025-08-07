// ------ Hybrisa tiles ------ //

/turf/open/hybrisa
	name = "floor"
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	icon_state = "hybrisa"

/turf/open/floor/hybrisa
	name = "floor"
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	icon_state = "hybrisa"

/turf/open/floor/hybrisa/is_plasteel_floor()
	return FALSE

/turf/open/floor/plating/engineer_ship
	icon = 'icons/turf/floors/engineership.dmi'
	turf_flags = TURF_BREAKABLE

/turf/open/floor/plating/hybrisa_rock
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	turf_flags = TURF_BREAKABLE

// Hybrisa auto-turf

/turf/open/auto_turf/hybrisa_auto_turf
	layer_name = list("aged igneous","weathered loam","volcanic plate rock","volcanic plate and rock")
	icon = 'icons/turf/floors/hybrisa_auto_turf.dmi'
	icon_prefix = "hybrisa"

/turf/open/auto_turf/hybrisa_auto_turf/get_dirt_type()
	return DIRT_TYPE_SAND

/turf/open/auto_turf/hybrisa_auto_turf/layer0
	icon_state = "hybrisa_0"
	bleed_layer = 0

/turf/open/auto_turf/hybrisa_auto_turf/layer1
	icon_state = "hybrisa_1"
	bleed_layer = 1

/turf/open/auto_turf/hybrisa_auto_turf/layer2
	icon_state = "hybrisa_2"
	bleed_layer = 2

/turf/open/auto_turf/hybrisa_auto_turf/layer3
	icon_state = "hybrisa_3"
	bleed_layer = 3

// Street

/turf/open/hybrisa/street
	name = "floor"
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	icon_state = "cement1"

/turf/open/hybrisa/street/cement1
	icon_state = "cement1"

/turf/open/hybrisa/street/cement2
	icon_state = "cement2"

/turf/open/hybrisa/street/cement3
	icon_state = "cement3"

/turf/open/hybrisa/street/asphalt
	icon_state = "asphalt_old"

// Side-walk


/turf/open/hybrisa/street/sidewalkfull
	icon_state = "sidewalkfull"

/turf/open/hybrisa/street/sidewalkcorner
	icon_state = "sidewalkcorner"

// Side-Walk

/turf/open/hybrisa/street/sidewalk
	icon_state = "sidewalk"

/turf/open/hybrisa/street/sidewalk/south
	dir = SOUTH

/turf/open/hybrisa/street/sidewalk/north
	dir = NORTH

/turf/open/hybrisa/street/sidewalk/west
	dir = WEST

/turf/open/hybrisa/street/sidewalk/east
	dir = EAST

/turf/open/hybrisa/street/sidewalk/northeast
	dir = NORTHEAST

/turf/open/hybrisa/street/sidewalk/southwest
	dir = SOUTHWEST

/turf/open/hybrisa/street/sidewalk/northwest
	dir = NORTHWEST

/turf/open/hybrisa/street/sidewalk/southeast
	dir = SOUTHEAST


// Center

/turf/open/hybrisa/street/sidewalkcenter
	icon_state = "sidewalkcenter"

/turf/open/hybrisa/street/sidewalkcenter/south
	dir = SOUTH

/turf/open/hybrisa/street/sidewalkcenter/north
	dir = NORTH

/turf/open/hybrisa/street/sidewalkcenter/west
	dir = WEST

/turf/open/hybrisa/street/sidewalkcenter/east
	dir = EAST

//-------------------------------------//

/turf/open/hybrisa/street/roadlines
	icon_state = "asphalt_old_roadlines"
/turf/open/hybrisa/street/roadlines2
	icon_state = "asphalt_old_roadlines2"
/turf/open/hybrisa/street/roadlines3
	icon_state = "asphalt_old_roadlines3"
/turf/open/hybrisa/street/roadlines4
	icon_state = "asphalt_old_roadlines4"

/turf/open/hybrisa/street/CMB_4x4_emblem
	icon_state = "marshallsemblem_concrete_2x2"
	name = "Office of the Colonial Marshals - Concrete Emblem"
	desc = "A small inscription reads - The laws of Earth stretch beyond the Sol. To live, to serve, wherever humanity roams."

/turf/open/hybrisa/street/CMB_4x4_emblem/north
	dir = NORTH

/turf/open/hybrisa/street/CMB_4x4_emblem/east
	dir = EAST

/turf/open/hybrisa/street/CMB_4x4_emblem/west
	dir = WEST

// NSPA Emblem

/turf/open/hybrisa/street/NSPA_2x2_emblem
	icon_state = "NSPA_emblem_concrete_2x2"
	name = "NSPA - Concrete Sakrua Emblem"
	desc = "A concrete emblem resembling a (Sakura Flower), the symbol of the NSPA, below is is an inscription reading - (Empire and Honor, Bound by Duty. Duty Beyond Borders, Justice Across Worlds)."

/turf/open/hybrisa/street/NSPA_2x2_emblem/north
	dir = NORTH

/turf/open/hybrisa/street/NSPA_2x2_emblem/east
	dir = EAST

/turf/open/hybrisa/street/NSPA_2x2_emblem/west
	dir = WEST


// Unweedable

/turf/open/hybrisa/street/underground_unweedable
	name = "floor"
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	icon_state = "underground"
	allow_construction = FALSE

/turf/open/hybrisa/metal/underground_unweedable
	name = "floor"
	icon = 'icons/turf/floors/floors.dmi'
	icon_state = "bcircuit"
	allow_construction = FALSE


/turf/open/hybrisa/street/underground_unweedable/is_weedable()
	return NOT_WEEDABLE

// Engineer Ship Hull

/turf/open/floor/hybrisa/engineership/ship_hull
	name = "strange metal wall"
	desc = "Nigh indestructible walls that make up the hull of an unknown ancient ship, looks like nothing you can do will penetrate the hull."
	icon = 'icons/turf/floors/engineership.dmi'
	icon_state = "engineerwallfloor1"
	allow_construction = FALSE

/turf/open/floor/hybrisa/engineership/ship_hull/is_weedable()
	return NOT_WEEDABLE

/turf/open/floor/hybrisa/engineership/ship_hull/non_weedable_hull
	icon_state = "outerhull_dir"

/turf/open/floor/hybrisa/engineership/ship_hull/non_weedable_hull/southwest
	dir = SOUTHWEST

/turf/open/floor/hybrisa/engineership/ship_hull/non_weedable_hull/north
	dir = NORTH

/turf/open/floor/hybrisa/engineership/ship_hull/non_weedable_hull/east
	dir = EAST

/turf/open/floor/hybrisa/engineership/ship_hull/non_weedable_hull/northeast
	dir = NORTHEAST

/turf/open/floor/hybrisa/engineership/ship_hull/non_weedable_hull/southeast
	dir = SOUTHEAST

/turf/open/floor/hybrisa/engineership/ship_hull/non_weedable_hull/west
	dir = WEST

/turf/open/floor/hybrisa/engineership/ship_hull/non_weedable_hull/northwest
	dir = NORTHWEST

// Carpet

/turf/open/floor/hybrisa/carpet
	name = "floor"
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	icon_state = "carpetred"

/turf/open/floor/hybrisa/carpet/carpet_colorable
	icon_state = "carpet_colorable"

/turf/open/floor/hybrisa/carpet/carpet_colorable/twe_blue
	icon_state = "carpet_colorable"
	color = "#697ead"

/turf/open/floor/hybrisa/carpet/carpet_colorable/twe_red
	icon_state = "carpet_colorable"
	color = "#ca6664"

/turf/open/floor/hybrisa/carpet/carpet_colorable/blue_grey
	icon_state = "carpet_colorable"
	color = "#718184"

/turf/open/floor/hybrisa/carpet/carpet_colorable/blue
	icon_state = "carpet_colorable"
	color = "#6e7f8b"

/turf/open/floor/hybrisa/carpet/carpet_colorable/pink
	icon_state = "carpet_colorable"
	color = "#9f8184"


/turf/open/floor/hybrisa/carpet/carpet_deco_colorable
	icon_state = "carpet_deco_colorable"

/turf/open/floor/hybrisa/carpet/blue_grey
	icon_state = "carpet_deco_colorable"
	color = "#718184"

/turf/open/floor/hybrisa/carpet/pink
	icon_state = "carpet_deco_colorable"
	color = "#9f8184"

// Rug Colorable

/turf/open/floor/hybrisa/carpet/rug_colorable
	icon_state = "rug_colorable"

/turf/open/floor/hybrisa/carpet/rug_colorable/south
	dir = SOUTH

/turf/open/floor/hybrisa/carpet/rug_colorable/north
	dir = NORTH

/turf/open/floor/hybrisa/carpet/rug_colorable/west
	dir = WEST

/turf/open/floor/hybrisa/carpet/rug_colorable/east
	dir = EAST

/turf/open/floor/hybrisa/carpet/rug_colorable/northeast
	dir = NORTHEAST

/turf/open/floor/hybrisa/carpet/rug_colorable/southwest
	dir = SOUTHWEST

/turf/open/floor/hybrisa/carpet/rug_colorable/northwest
	dir = NORTHWEST

/turf/open/floor/hybrisa/carpet/rug_colorable/southeast
	dir = SOUTHEAST

// Rug Pink

/turf/open/floor/hybrisa/carpet/rug_colorable/pink
	icon_state = "rug_colorable"
	color = "#9f8184"

/turf/open/floor/hybrisa/carpet/rug_colorable/pink/south
	dir = SOUTH

/turf/open/floor/hybrisa/carpet/rug_colorable/pink/north
	dir = NORTH

/turf/open/floor/hybrisa/carpet/rug_colorable/pink/west
	dir = WEST

/turf/open/floor/hybrisa/carpet/rug_colorable/pink/east
	dir = EAST

/turf/open/floor/hybrisa/carpet/rug_colorable/pink/northeast
	dir = NORTHEAST

/turf/open/floor/hybrisa/carpet/rug_colorable/pink/southwest
	dir = SOUTHWEST

/turf/open/floor/hybrisa/carpet/rug_colorable/pink/northwest
	dir = NORTHWEST

/turf/open/floor/hybrisa/carpet/rug_colorable/pink/southeast
	dir = SOUTHEAST

// Rug Grey Blue

/turf/open/floor/hybrisa/carpet/rug_colorable/grey_blue
	icon_state = "rug_colorable"
	color = "#718184"

/turf/open/floor/hybrisa/carpet/rug_colorable/grey_blue/south
	dir = SOUTH

/turf/open/floor/hybrisa/carpet/rug_colorable/grey_blue/north
	dir = NORTH

/turf/open/floor/hybrisa/carpet/rug_colorable/grey_blue/west
	dir = WEST

/turf/open/floor/hybrisa/carpet/rug_colorable/grey_blue/east
	dir = EAST

/turf/open/floor/hybrisa/carpet/rug_colorable/grey_blue/northeast
	dir = NORTHEAST

/turf/open/floor/hybrisa/carpet/rug_colorable/grey_blue/southwest
	dir = SOUTHWEST

/turf/open/floor/hybrisa/carpet/rug_colorable/grey_blue/northwest
	dir = NORTHWEST

/turf/open/floor/hybrisa/carpet/rug_colorable/grey_blue/southeast
	dir = SOUTHEAST

// Rug Black

/turf/open/floor/hybrisa/carpet/rug_colorable/black
	icon_state = "rug_colorable"
	color = "#5d5d5d"

/turf/open/floor/hybrisa/carpet/rug_colorable/black/south
	dir = SOUTH

/turf/open/floor/hybrisa/carpet/rug_colorable/black/north
	dir = NORTH

/turf/open/floor/hybrisa/carpet/rug_colorable/black/west
	dir = WEST

/turf/open/floor/hybrisa/carpet/rug_colorable/black/east
	dir = EAST

/turf/open/floor/hybrisa/carpet/rug_colorable/black/northeast
	dir = NORTHEAST

/turf/open/floor/hybrisa/carpet/rug_colorable/black/southwest
	dir = SOUTHWEST

/turf/open/floor/hybrisa/carpet/rug_colorable/black/northwest
	dir = NORTHWEST

/turf/open/floor/hybrisa/carpet/rug_colorable/black/southeast
	dir = SOUTHEAST

// Rug Blue

/turf/open/floor/hybrisa/carpet/rug_colorable/blue
	icon_state = "rug_colorable"

	color = "#61727e"

/turf/open/floor/hybrisa/carpet/rug_colorable/blue/south
	dir = SOUTH

/turf/open/floor/hybrisa/carpet/rug_colorable/blue/north
	dir = NORTH

/turf/open/floor/hybrisa/carpet/rug_colorable/blue/west
	dir = WEST

/turf/open/floor/hybrisa/carpet/rug_colorable/blue/east
	dir = EAST

/turf/open/floor/hybrisa/carpet/rug_colorable/blue/northeast
	dir = NORTHEAST

/turf/open/floor/hybrisa/carpet/rug_colorable/blue/southwest
	dir = SOUTHWEST

/turf/open/floor/hybrisa/carpet/rug_colorable/blue/northwest
	dir = NORTHWEST

/turf/open/floor/hybrisa/carpet/rug_colorable/blue/southeast
	dir = SOUTHEAST

// Rug Biege

/turf/open/floor/hybrisa/carpet/rug_colorable/biege
	icon_state = "rug_colorable"

	color = "#84776b"

/turf/open/floor/hybrisa/carpet/rug_colorable/biege/south
	dir = SOUTH

/turf/open/floor/hybrisa/carpet/rug_colorable/biege/north
	dir = NORTH

/turf/open/floor/hybrisa/carpet/rug_colorable/biege/west
	dir = WEST

/turf/open/floor/hybrisa/carpet/rug_colorable/biege/east
	dir = EAST

/turf/open/floor/hybrisa/carpet/rug_colorable/biege/northeast
	dir = NORTHEAST

/turf/open/floor/hybrisa/carpet/rug_colorable/biege/southwest
	dir = SOUTHWEST

/turf/open/floor/hybrisa/carpet/rug_colorable/biege/northwest
	dir = NORTHWEST

/turf/open/floor/hybrisa/carpet/rug_colorable/biege/southeast
	dir = SOUTHEAST

/turf/open/floor/hybrisa/carpet/carpetfadedred
	icon_state = "carpetfadedred"
/turf/open/floor/hybrisa/carpet/carpetgreen
	icon_state = "carpetgreen"
/turf/open/floor/hybrisa/carpet/carpetbeige
	icon_state = "carpetbeige"
/turf/open/floor/hybrisa/carpet/carpetblack
	icon_state = "carpetblack"
/turf/open/floor/hybrisa/carpet/carpetred
	icon_state = "carpetred"
/turf/open/floor/hybrisa/carpet/carpetdarkerblue
	icon_state = "carpetdarkerblue"
/turf/open/floor/hybrisa/carpet/carpetorangered
	icon_state = "carpetorangered"
/turf/open/floor/hybrisa/carpet/carpetblue
	icon_state = "carpetblue"
/turf/open/floor/hybrisa/carpet/carpetpatternblue
	icon_state = "carpetpatternblue"
/turf/open/floor/hybrisa/carpet/carpetpatternbrown
	icon_state = "carpetpatternbrown"
/turf/open/floor/hybrisa/carpet/carpetreddeco
	icon_state = "carpetred_deco"
/turf/open/floor/hybrisa/carpet/carpetbluedeco
	icon_state = "carpetblue_deco"
/turf/open/floor/hybrisa/carpet/carpetblackdeco
	icon_state = "carpetblack_deco"
/turf/open/floor/hybrisa/carpet/carpetbeigedeco
	icon_state = "carpetbeige_deco"
/turf/open/floor/hybrisa/carpet/carpetgreendeco
	icon_state = "carpetgreen_deco"

// Tile

/turf/open/floor/hybrisa/tile
	name = "floor"
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	icon_state = "supermartfloor1"

/turf/open/floor/hybrisa/tile/supermartfloor1
	icon_state = "supermartfloor1"
/turf/open/floor/hybrisa/tile/supermartfloor2
	icon_state = "supermartfloor2"
/turf/open/floor/hybrisa/tile/cuppajoesfloor
	icon_state = "cuppafloor"
/turf/open/floor/hybrisa/tile/tilered
	icon_state = "tilered"
/turf/open/floor/hybrisa/tile/tileblue
	icon_state = "tileblue"
/turf/open/floor/hybrisa/tile/tilegreen
	icon_state = "tilegreen"
/turf/open/floor/hybrisa/tile/tileblackcheckered
	icon_state = "tileblack"
/turf/open/floor/hybrisa/tile/tilewhitecheckered
	icon_state = "tilewhitecheck"
/turf/open/floor/hybrisa/tile/tilewhitecheckered/biege
	icon_state = "tilewhitecheck"
	color = "#f7e8db"
/turf/open/floor/hybrisa/tile/tilewhitecheckered/blue
	icon_state = "tilewhitecheck"
	color = "#c8d9dc"
/turf/open/floor/hybrisa/tile/tilelightbeige
	icon_state = "tilelightbeige"
/turf/open/floor/hybrisa/tile/tilebeigecheckered
	icon_state = "tilebeigecheck"
/turf/open/floor/hybrisa/tile/tilebeige
	icon_state = "tilebeige"
/turf/open/floor/hybrisa/tile/tilewhite
	icon_state = "tilewhite"
/turf/open/floor/hybrisa/tile/tilegrey
	icon_state = "tilegrey"
/turf/open/floor/hybrisa/tile/tileblack
	icon_state = "tileblack2"
/turf/open/floor/hybrisa/tile/beigetileshiny
	icon_state = "beigetileshiny"
/turf/open/floor/hybrisa/tile/blacktileshiny
	icon_state = "blacktileshiny"
/turf/open/floor/hybrisa/tile/cementflat
	icon_state = "cementflat"
/turf/open/floor/hybrisa/tile/beige_bigtile
	icon_state = "beige_bigtile"
/turf/open/floor/hybrisa/tile/yellow_bigtile
	icon_state = "yellow_bigtile"
/turf/open/floor/hybrisa/tile/darkgrey_bigtile
	icon_state = "darkgrey_bigtile"

/turf/open/floor/hybrisa/tile/darkbrown_bigtile
	icon_state = "darkbrown_bigtile"

/turf/open/floor/hybrisa/tile/darkbrown_bigtile/north
	dir = NORTH

/turf/open/floor/hybrisa/tile/darkbrown_bigtile/southwest
	dir = SOUTHWEST

/turf/open/floor/hybrisa/tile/darkbrown_bigtile/south
	dir = SOUTH

/turf/open/floor/hybrisa/tile/darkbrown_bigtile/east
	dir = EAST

/turf/open/floor/hybrisa/tile/darkbrown_bigtile/northeast
	dir = NORTHEAST

/turf/open/floor/hybrisa/tile/darkbrown_bigtile/southeast
	dir = SOUTHEAST

/turf/open/floor/hybrisa/tile/darkbrown_bigtile/west
	dir = WEST

/turf/open/floor/hybrisa/tile/darkbrown_bigtile/northwest
	dir = NORTHWEST

/turf/open/floor/hybrisa/tile/darkbrowncorner_bigtile
	icon_state = "darkbrowncorner_bigtile"

/turf/open/floor/hybrisa/tile/darkbrowncorner_bigtile/west
	dir = WEST

/turf/open/floor/hybrisa/tile/darkbrowncorner_bigtile/east
	dir = EAST

/turf/open/floor/hybrisa/tile/darkbrowncorner_bigtile/south
	dir = SOUTH

/turf/open/floor/hybrisa/tile/darkbrowncorner_bigtile/north
	dir = NORTH

/turf/open/floor/hybrisa/tile/asteroidfloor_bigtile
	icon_state = "asteroidfloor_bigtile"

/turf/open/floor/hybrisa/tile/asteroidwarning_bigtile
	icon_state = "asteroidwarning_bigtile"

/turf/open/floor/hybrisa/tile/asteroidwarning_bigtile/north
	dir = NORTH

/turf/open/floor/hybrisa/tile/asteroidwarning_bigtile/east
	dir = EAST

/turf/open/floor/hybrisa/tile/asteroidwarning_bigtile/west
	dir = WEST

/turf/open/floor/hybrisa/tile/lightbeige_bigtile
	icon_state = "lightbeige_bigtile"
/turf/open/floor/hybrisa/tile/greencorner_bigtile
	icon_state = "greencorner_bigtile"
/turf/open/floor/hybrisa/tile/greenfull_bigtile
	icon_state = "greenfull_bigtile"

// Green Tile

/turf/open/floor/hybrisa/tile/green_bigtile
	icon_state = "green_bigtile"

/turf/open/floor/hybrisa/tile/green_bigtile/south
	dir = SOUTH

/turf/open/floor/hybrisa/tile/green_bigtile/north
	dir = NORTH

/turf/open/floor/hybrisa/tile/green_bigtile/west
	dir = WEST

/turf/open/floor/hybrisa/tile/green_bigtile/east
	dir = EAST

/turf/open/floor/hybrisa/tile/green_bigtile/northeast
	dir = NORTHEAST

/turf/open/floor/hybrisa/tile/green_bigtile/southwest
	dir = SOUTHWEST

/turf/open/floor/hybrisa/tile/green_bigtile/northwest
	dir = NORTHWEST

/turf/open/floor/hybrisa/tile/green_bigtile/southeast
	dir = SOUTHEAST

/turf/open/floor/hybrisa/tile/greencorner_bigtile
	icon_state = "greencorner_bigtile"

/turf/open/floor/hybrisa/tile/greencorner_bigtile/south
	dir = SOUTH

/turf/open/floor/hybrisa/tile/greencorner_bigtile/north
	dir = NORTH

/turf/open/floor/hybrisa/tile/greencorner_bigtile/west
	dir = WEST

/turf/open/floor/hybrisa/tile/greencorner_bigtile/east
	dir = EAST

// Wood

/turf/open/floor/hybrisa/wood
	name = "floor"
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	icon_state = "darkerwood"

/turf/open/floor/hybrisa/wood/greywood
	icon_state = "greywood"
/turf/open/floor/hybrisa/wood/blackwood
	icon_state = "blackwood"
/turf/open/floor/hybrisa/wood/darkerwood
	icon_state = "darkerwood"
/turf/open/floor/hybrisa/wood/redwood
	icon_state = "redwood"

// Metal

/turf/open/floor/hybrisa/metal
	name = "floor"
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	icon_state = "bluemetal1"

/turf/open/floor/hybrisa/metal/red_warning_floor
	icon_state = "warning_red_floor"

/turf/open/floor/hybrisa/metal/yellow_warning_floor
	icon_state = "warning_yellow_floor"

/turf/open/floor/hybrisa/metal/bluemetal1
	icon_state = "bluemetal1"

/turf/open/floor/hybrisa/metal/bluemetal1/southwest
	dir = SOUTHWEST

/turf/open/floor/hybrisa/metal/bluemetal1/north
	dir = NORTH

/turf/open/floor/hybrisa/metal/bluemetal1/east
	dir = EAST

/turf/open/floor/hybrisa/metal/bluemetal1/northeast
	dir = NORTHEAST

/turf/open/floor/hybrisa/metal/bluemetal1/southeast
	dir = SOUTHEAST

/turf/open/floor/hybrisa/metal/bluemetal1/west
	dir = WEST

/turf/open/floor/hybrisa/metal/bluemetal1/northwest
	dir = NORTHWEST

/turf/open/floor/hybrisa/metal/bluemetalfull
	icon_state = "bluemetalfull"

/turf/open/floor/hybrisa/metal/bluemetalcorner
	icon_state = "bluemetalcorner"

/turf/open/floor/hybrisa/metal/bluemetalcorner/north
	dir = NORTH

/turf/open/floor/hybrisa/metal/bluemetalcorner/east
	dir = EAST

/turf/open/floor/hybrisa/metal/bluemetalcorner/west
	dir = WEST

/turf/open/floor/hybrisa/metal/orangelinecorner
	icon_state = "orangelinecorner"

/turf/open/floor/hybrisa/metal/orangelinecorner/north
	dir = NORTH

/turf/open/floor/hybrisa/metal/orangelinecorner/east
	dir = EAST

/turf/open/floor/hybrisa/metal/orangelinecorner/west
	dir = WEST

/turf/open/floor/hybrisa/metal/orangeline
	icon_state = "orangeline"

/turf/open/floor/hybrisa/metal/orangeline/north
	dir = NORTH

/turf/open/floor/hybrisa/metal/orangeline/east
	dir = EAST

/turf/open/floor/hybrisa/metal/orangeline/west
	dir = WEST

/turf/open/floor/hybrisa/metal/darkblackmetal1
	icon_state = "darkblackmetal1"
/turf/open/floor/hybrisa/metal/darkblackmetal2
	icon_state = "darkblackmetal2"
/turf/open/floor/hybrisa/metal/darkredfull2
	icon_state = "darkredfull2"
/turf/open/floor/hybrisa/metal/redcorner
	icon_state = "zredcorner"

/turf/open/floor/hybrisa/metal/grated
	icon_state = "rampsmaller"

/turf/open/floor/hybrisa/metal/grated/north
	dir = NORTH

/turf/open/floor/hybrisa/metal/grated/east
	dir = EAST

/turf/open/floor/hybrisa/metal/grated/west
	dir = WEST

/turf/open/floor/hybrisa/metal/stripe_red
	icon_state = "stripe_red"

/turf/open/floor/hybrisa/metal/stripe_red/north
	dir = NORTH

/turf/open/floor/hybrisa/metal/stripe_red/east
	dir = EAST

/turf/open/floor/hybrisa/metal/stripe_red/west
	dir = WEST

/turf/open/floor/hybrisa/metal/zbrownfloor1
	icon_state = "zbrownfloor1"

/turf/open/floor/hybrisa/metal/zbrownfloor1/southwest
	dir = SOUTHWEST

/turf/open/floor/hybrisa/metal/zbrownfloor1/north
	dir = NORTH

/turf/open/floor/hybrisa/metal/zbrownfloor1/east
	dir = EAST

/turf/open/floor/hybrisa/metal/zbrownfloor1/northeast
	dir = NORTHEAST

/turf/open/floor/hybrisa/metal/zbrownfloor1/southeast
	dir = SOUTHEAST

/turf/open/floor/hybrisa/metal/zbrownfloor1/west
	dir = WEST

/turf/open/floor/hybrisa/metal/zbrownfloor1/northwest
	dir = NORTHWEST

/turf/open/floor/hybrisa/metal/zbrownfloor2
	icon_state = "zbrownfloor2"

/turf/open/floor/hybrisa/metal/zbrownfloor2/southwest
	dir = SOUTHWEST

/turf/open/floor/hybrisa/metal/zbrownfloor2/north
	dir = NORTH

/turf/open/floor/hybrisa/metal/zbrownfloor2/east
	dir = EAST

/turf/open/floor/hybrisa/metal/zbrownfloor2/west
	dir = WEST

/turf/open/floor/hybrisa/metal/zbrownfloor_corner
	icon_state = "zbrownfloorcorner1"

/turf/open/floor/hybrisa/metal/zbrownfloor_corner/north
	dir = NORTH

/turf/open/floor/hybrisa/metal/zbrownfloor_corner/east
	dir = EAST

/turf/open/floor/hybrisa/metal/zbrownfloor_corner/west
	dir = WEST

/turf/open/floor/hybrisa/metal/zbrownfloor_full
	icon_state = "zbrownfloorfull1"

/turf/open/floor/hybrisa/metal/greenmetal1
	icon_state = "greenmetal1"

/turf/open/floor/hybrisa/metal/greenmetal1/southwest
	dir = SOUTHWEST

/turf/open/floor/hybrisa/metal/greenmetal1/north
	dir = NORTH

/turf/open/floor/hybrisa/metal/greenmetal1/east
	dir = EAST

/turf/open/floor/hybrisa/metal/greenmetal1/northeast
	dir = NORTHEAST

/turf/open/floor/hybrisa/metal/greenmetal1/southeast
	dir = SOUTHEAST

/turf/open/floor/hybrisa/metal/greenmetal1/west
	dir = WEST

/turf/open/floor/hybrisa/metal/greenmetal1/northwest
	dir = NORTHWEST

/turf/open/floor/hybrisa/metal/greenmetalfull
	icon_state = "greenmetalfull"
/turf/open/floor/hybrisa/metal/greenmetalcorner
	icon_state = "greenmetalcorner"
/turf/open/floor/hybrisa/metal/metalwhitefull
	icon_state = "metalwhitefull"

// Plating

/turf/open/floor/plating/hybrisa
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	turf_flags = TURF_BREAKABLE

/turf/open/floor/plating/hybrisa/darkredfull2
	icon_state = "darkredfull2"

// Misc

/turf/open/floor/hybrisa/misc
	name = "floor"
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	icon_state = "marshallsemblem"

/turf/open/floor/hybrisa/misc/marshallsemblem
	icon_state = "marshallsemblem"
	desc = "A small inscription reads - The laws of Earth stretch beyond the Sol. To live, to serve, wherever humanity roams."
	name = "Office of the Colonial Marshals Emblem"

/turf/open/floor/hybrisa/misc/NSPA_emblem
	icon_state = "NSPAemblem"
	desc = "A golden emblem resembling a (Sakura Flower), the symbol of the NSPA."
	name = "NSPA - Golden Sakura Emblem"

/turf/open/floor/hybrisa/misc/wybiglogo
	name = "Weyland-Yutani corp. - bulding better worlds."
	icon_state = "big8x8wylogo"

/turf/open/floor/hybrisa/misc/wybiglogo/southwest
	dir = SOUTHWEST

/turf/open/floor/hybrisa/misc/wybiglogo/north
	dir = NORTH

/turf/open/floor/hybrisa/misc/wybiglogo/east
	dir = EAST

/turf/open/floor/hybrisa/misc/wybiglogo/northeast
	dir = NORTHEAST

/turf/open/floor/hybrisa/misc/wybiglogo/southeast
	dir = SOUTHEAST

/turf/open/floor/hybrisa/misc/wybiglogo/west
	dir = WEST

/turf/open/floor/hybrisa/misc/wybiglogo/northwest
	dir = NORTHWEST

/turf/open/floor/hybrisa/misc/wysmallleft
	icon_state = "weylandyutanismall1"
/turf/open/floor/hybrisa/misc/wysmallright
	icon_state = "weylandyutanismall2"
/turf/open/floor/hybrisa/misc/spaceport1
	icon_state = "spaceport1"
/turf/open/floor/hybrisa/misc/spaceport2
	icon_state = "spaceport2"

// Dropship

/turf/open/hybrisa/dropship
	name = "floor"
	icon = 'icons/turf/floors/hybrisafloors.dmi'
	icon_state = "dropshipfloor1"
	supports_surgery = TRUE

/turf/open/hybrisa/dropship/dropship1
	icon_state = "dropshipfloor1"
/turf/open/hybrisa/dropship/dropship2
	icon_state = "dropshipfloor2"
/turf/open/hybrisa/dropship/dropship3
	icon_state = "dropshipfloor2"
/turf/open/hybrisa/dropship/dropship3
	icon_state = "dropshipfloor3"
/turf/open/hybrisa/dropship/dropship4
	icon_state = "dropshipfloor4"
/turf/open/hybrisa/dropship/dropshipfloorcorner1
	icon_state = "dropshipfloorcorner1"
/turf/open/hybrisa/dropship/dropshipfloorcorner2
	icon_state = "dropshipfloorcorner2"
/turf/open/hybrisa/dropship/dropshipfloorfull
	icon_state = "dropshipfloorfull"

/turf/open/hybrisa/dropship/no_surgery_allowed
	supports_surgery = FALSE

/turf/open/hybrisa/dropship/no_surgery_allowed/dropship1
	icon_state = "dropshipfloor1"
/turf/open/hybrisa/dropship/no_surgery_allowed/dropship2
	icon_state = "dropshipfloor2"
/turf/open/hybrisa/dropship/no_surgery_allowed/dropship3
	icon_state = "dropshipfloor2"
/turf/open/hybrisa/dropship/no_surgery_allowed/dropship3
	icon_state = "dropshipfloor3"
/turf/open/hybrisa/dropship/no_surgery_allowed/dropship4
	icon_state = "dropshipfloor4"
/turf/open/hybrisa/dropship/no_surgery_allowed/dropshipfloorcorner1
	icon_state = "dropshipfloorcorner1"
/turf/open/hybrisa/dropship/no_surgery_allowed/dropshipfloorcorner2
	icon_state = "dropshipfloorcorner2"
/turf/open/hybrisa/dropship/no_surgery_allowed/dropshipfloorfull
	icon_state = "dropshipfloorfull"

// Engineer tiles

/turf/open/floor/hybrisa/engineership
	name = "floor"
	desc = "A strange metal floor, unlike any metal you've seen before."
	icon = 'icons/turf/floors/engineership.dmi'
	icon_state = "hybrisa"
	plating_type = /turf/open/floor/plating/engineer_ship

/turf/open/floor/hybrisa/engineership/engineer_floor1
	icon_state = "engineer_metalfloor_3"
/turf/open/floor/hybrisa/engineership/engineer_floor2
	icon_state = "engineer_floor_4"
/turf/open/floor/hybrisa/engineership/engineer_floor3
	icon_state = "engineer_metalfloor_2"
/turf/open/floor/hybrisa/engineership/engineer_floor4
	icon_state = "engineer_metalfloor_1"
/turf/open/floor/hybrisa/engineership/engineer_floor5
	icon_state = "engineerlight"
/turf/open/floor/hybrisa/engineership/engineer_floor6
	icon_state = "engineer_floor_2"
/turf/open/floor/hybrisa/engineership/engineer_floor7
	icon_state = "engineer_floor_1"

/turf/open/floor/hybrisa/engineership/engineer_floor8
	icon_state = "engineer_floor_5"

/turf/open/floor/hybrisa/engineership/engineer_floor8/east
	dir = EAST

/turf/open/floor/hybrisa/engineership/engineer_floor8/west
	dir = WEST

/turf/open/floor/hybrisa/engineership/engineer_floor9
	icon_state = "engineer_metalfloor_4"
/turf/open/floor/hybrisa/engineership/engineer_floor10
	icon_state = "engineer_floor_corner1"
/turf/open/floor/hybrisa/engineership/engineer_floor11
	icon_state = "engineer_floor_corner2"
/turf/open/floor/hybrisa/engineership/engineer_floor12
	icon_state = "engineerwallfloor1"

/turf/open/floor/hybrisa/engineership/engineer_floor13
	icon_state = "outerhull_dir"

/turf/open/floor/hybrisa/engineership/engineer_floor13/southeast
	dir = SOUTHEAST

/turf/open/floor/hybrisa/engineership/engineer_floor13/southwest
	dir = SOUTHWEST

/turf/open/floor/hybrisa/engineership/engineer_floor13/north
	dir = NORTH

/turf/open/floor/hybrisa/engineership/engineer_floor13/east
	dir = EAST

/turf/open/floor/hybrisa/engineership/engineer_floor13/south
	dir = SOUTH

/turf/open/floor/hybrisa/engineership/engineer_floor13/west
	dir = WEST

/turf/open/floor/hybrisa/engineership/engineer_floor13/northeast
	dir = NORTHEAST

/turf/open/floor/hybrisa/engineership/engineer_floor13/northwest
	dir = NORTHWEST

/turf/open/floor/hybrisa/engineership/engineer_floor14
	icon_state = "engineer_floor_corner3"

/turf/open/floor/hybrisa/engineership/engineer_floor14/north
	dir = NORTH

/turf/open/floor/hybrisa/engineership/engineer_floor14/west
	dir = WEST

// Pillars

/turf/open/floor/hybrisa/engineership/pillars
	name = "strange metal pillar"
	desc = "A strange metal pillar, unlike any metal you've seen before."
	icon_state = "eng_pillar1"
	allow_construction = FALSE

/turf/open/floor/hybrisa/engineership/pillars/is_weedable()
	return NOT_WEEDABLE

/turf/open/floor/hybrisa/engineership/pillars/north/pillar1
	icon_state = "eng_pillar1"
/turf/open/floor/hybrisa/engineership/pillars/north/pillar2
	icon_state = "eng_pillar2"
/turf/open/floor/hybrisa/engineership/pillars/north/pillar3
	icon_state = "eng_pillar3"
/turf/open/floor/hybrisa/engineership/pillars/north/pillar4
	icon_state = "eng_pillar4"
/turf/open/floor/hybrisa/engineership/pillars/south/pillarsouth1
	icon_state = "eng_pillarsouth1"
/turf/open/floor/hybrisa/engineership/pillars/south/pillarsouth2
	icon_state = "eng_pillarsouth2"
/turf/open/floor/hybrisa/engineership/pillars/south/pillarsouth3
	icon_state = "eng_pillarsouth3"
/turf/open/floor/hybrisa/engineership/pillars/south/pillarsouth4
	icon_state = "eng_pillarsouth4"
/turf/open/floor/hybrisa/engineership/pillars/west/pillarwest1
	icon_state = "eng_pillarwest1"
/turf/open/floor/hybrisa/engineership/pillars/west/pillarwest2
	icon_state = "eng_pillarwest2"
/turf/open/floor/hybrisa/engineership/pillars/west/pillarwest3
	icon_state = "eng_pillarwest3"
/turf/open/floor/hybrisa/engineership/pillars/west/pillarwest4
	icon_state = "eng_pillarwest4"
/turf/open/floor/hybrisa/engineership/pillars/east/pillareast1
	icon_state = "eng_pillareast1"
/turf/open/floor/hybrisa/engineership/pillars/east/pillareast2
	icon_state = "eng_pillareast2"
/turf/open/floor/hybrisa/engineership/pillars/east/pillareast3
	icon_state = "eng_pillareast3"
/turf/open/floor/hybrisa/engineership/pillars/east/pillareast4
	icon_state = "eng_pillareast4"

// -------------------- // Hybrisa Wall types // ---------------- //

// Derelict Ship

/turf/closed/wall/engineership
	name = "strange metal wall"
	desc = "Nigh indestructible walls that make up the hull of an unknown ancient ship, looks like nothing you can do will penetrate the hull."
	icon = 'icons/turf/walls/engineership.dmi'
	icon_state = "metal"
	walltype = WALL_HUNTERSHIP
	turf_flags = TURF_HULL

/turf/closed/wall/engineership/destructible
	desc = "Nigh indestructible walls that make up the hull of an unknown ancient ship, with enough force they could break."
	turf_flags = NO_FLAGS
	damage_cap = HEALTH_WALL_ULTRA_REINFORCED
	baseturfs = /turf/open/floor/plating/engineer_ship

// Rock

/turf/closed/wall/hybrisa/rock
	name = "rock wall"
	desc = "Massive columns comprised of anicent sedimentary rocks loom before you."
	icon = 'icons/turf/walls/kutjevorockdark.dmi'
	icon_state = "rock"
	walltype = WALL_KUTJEVO_ROCK
	turf_flags = TURF_HULL
	baseturfs = /turf/open/floor/plating/hybrisa_rock

// Marshalls

/turf/closed/wall/hybrisa/marhsalls
	name = "metal wall"
	icon = 'icons/turf/walls/hybrisa_marshalls.dmi'
	icon_state = "metal"
	walltype = WALL_METAL

/turf/closed/wall/hybrisa/marhsalls/reinforced
	name = "reinforced metal wall"
	icon_state = "rwall"
	walltype = WALL_REINFORCED

/turf/closed/wall/hybrisa/marhsalls/unmeltable
	name = "heavy reinforced wall"
	desc = "A huge chunk of ultra-reinforced metal used to separate rooms. Looks virtually indestructible."
	icon_state = "hwall"
	walltype = WALL_REINFORCED
	turf_flags = TURF_HULL

// Research

/turf/closed/wall/hybrisa/research/ribbed //this guy is our reinforced replacement
	name = "ribbed facility walls"
	icon = 'icons/turf/walls/hybrisaresearchbrownwall.dmi'
	icon_state = "strata_ribbed_outpost_"
	desc = "A thick and chunky metal wall covered in jagged ribs."
	walltype = WALL_STRATA_OUTPOST_RIBBED
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/hybrisa/research
	name = "bare facility walls"
	icon = 'icons/turf/walls/hybrisaresearchbrownwall.dmi'
	icon_state = "strata_bare_outpost_"
	desc = "A thick and chunky metal wall. The surface is barren and imposing."
	walltype = WALL_STRATA_OUTPOST_BARE

/turf/closed/wall/hybrisa/research/reinforced
	name = "ribbed facility walls"
	icon_state = "strata_ribbed_outpost_"
	desc = "A thick and chunky metal wall covered in jagged ribs."
	walltype = WALL_STRATA_OUTPOST_RIBBED
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/hybrisa/research/reinforced/hull
	icon_state = "strata_hull"
	desc = "A thick and chunky metal wall that is, just by virtue of its placement and imposing presence, entirely indestructible."
	turf_flags = TURF_HULL

// Colony Walls

/turf/closed/wall/hybrisa/colony/ribbed //this guy is our reinforced replacement
	name = "ribbed metal walls"
	icon = 'icons/turf/walls/hybrisa_colonywall.dmi'
	icon_state = "strata_ribbed_outpost_"
	desc = "A thick and chunky metal wall covered in jagged ribs."
	walltype = WALL_STRATA_OUTPOST_RIBBED
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/hybrisa/colony
	name = "bare metal walls"
	icon = 'icons/turf/walls/hybrisa_colonywall.dmi'
	icon_state = "strata_bare_outpost_"
	desc = "A thick and chunky metal wall. The surface is barren and imposing."
	walltype = WALL_STRATA_OUTPOST_BARE

/turf/closed/wall/hybrisa/colony/reinforced
	name = "ribbed metal walls"
	icon_state = "strata_ribbed_outpost_"
	desc = "A thick and chunky metal wall covered in jagged ribs."
	walltype = WALL_STRATA_OUTPOST_RIBBED
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/hybrisa/colony/reinforced/hull
	icon_state = "strata_hull"
	desc = "A thick and chunky metal wall that is, just by virtue of its placement and imposing presence, entirely indestructible."
	turf_flags = TURF_HULL

// Hospital

/turf/closed/wall/hybrisa/colony/hospital/ribbed //this guy is our reinforced replacement
	name = "ribbed metal walls"
	icon = 'icons/turf/walls/hybrisa_colonywall_hospital.dmi'
	icon_state = "strata_ribbed_outpost_"
	desc = "A thick and chunky metal wall covered in jagged ribs."
	walltype = WALL_STRATA_OUTPOST_RIBBED
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/hybrisa/colony/hospital
	name = "bare metal walls"
	icon = 'icons/turf/walls/hybrisa_colonywall_hospital.dmi'
	icon_state = "strata_bare_outpost_"
	desc = "A thick and chunky metal wall. The surface is barren and imposing."
	walltype = WALL_STRATA_OUTPOST_BARE

/turf/closed/wall/hybrisa/colony/hospital/reinforced
	name = "ribbed metal walls"
	icon_state = "strata_ribbed_outpost_"
	desc = "A thick and chunky metal wall covered in jagged ribs."
	walltype = WALL_STRATA_OUTPOST_RIBBED
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/hybrisa/colony/hospital/reinforced/hull
	icon_state = "strata_hull"
	desc = "A thick and chunky metal wall that is, just by virtue of its placement and imposing presence, entirely indestructible."
	turf_flags = TURF_HULL

// Offices

/turf/closed/wall/hybrisa/colony/office/ribbed //this guy is our reinforced replacement
	name = "ribbed metal walls"
	icon = 'icons/turf/walls/hybrisa_offices_colonywall.dmi'
	icon_state = "strata_ribbed_outpost_"
	desc = "A thick and chunky metal wall covered in jagged ribs."
	walltype = WALL_STRATA_OUTPOST_RIBBED
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/hybrisa/colony/office
	name = "bare metal walls"
	icon = 'icons/turf/walls/hybrisa_offices_colonywall.dmi'
	icon_state = "strata_bare_outpost_"
	desc = "A thick and chunky metal wall. The surface is barren and imposing."
	walltype = WALL_STRATA_OUTPOST_BARE

/turf/closed/wall/hybrisa/colony/office/reinforced
	name = "ribbed metal walls"
	icon_state = "strata_ribbed_outpost_"
	desc = "A thick and chunky metal wall covered in jagged ribs."
	walltype = WALL_STRATA_OUTPOST_RIBBED
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/hybrisa/colony/office/reinforced/hull
	icon_state = "strata_hull"
	desc = "A thick and chunky metal wall that is, just by virtue of its placement and imposing presence, entirely indestructible."
	turf_flags = TURF_HULL

// Engineering

/turf/closed/wall/hybrisa/colony/engineering/ribbed //this guy is our reinforced replacement
	name = "ribbed metal walls"
	icon = 'icons/turf/walls/hybrisa_engineering_wall.dmi'
	icon_state = "strata_ribbed_outpost_"
	desc = "A thick and chunky metal wall covered in jagged ribs."
	walltype = WALL_STRATA_OUTPOST_RIBBED
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/hybrisa/colony/engineering
	name = "bare metal walls"
	icon = 'icons/turf/walls/hybrisa_engineering_wall.dmi'
	icon_state = "strata_bare_outpost_"
	desc = "A thick and chunky metal wall. The surface is barren and imposing."
	walltype = WALL_STRATA_OUTPOST_BARE

/turf/closed/wall/hybrisa/colony/engineering/reinforced
	name = "ribbed metal walls"
	icon_state = "strata_ribbed_outpost_"
	desc = "A thick and chunky metal wall covered in jagged ribs."
	walltype = WALL_STRATA_OUTPOST_RIBBED
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/hybrisa/colony/engineering/reinforced/hull
	icon_state = "strata_hull"
	desc = "A thick and chunky metal wall that is, just by virtue of its placement and imposing presence, entirely indestructible."
	turf_flags = TURF_HULL

// Space-Port

/turf/closed/wall/hybrisa/spaceport
	name = "metal wall"
	icon = 'icons/turf/walls/hybrisa_spaceport_walls.dmi'
	icon_state = "metal"
	walltype = WALL_METAL

/turf/closed/wall/hybrisa/spaceport/reinforced
	name = "reinforced metal wall"
	icon = 'icons/turf/walls/hybrisa_spaceport_walls.dmi'
	icon_state = "rwall"
	walltype = WALL_REINFORCED

/turf/closed/wall/hybrisa/spaceport/unmeltable
	name = "heavy reinforced wall"
	desc = "A huge chunk of ultra-reinforced metal used to separate rooms. Looks virtually indestructible."
	icon = 'icons/turf/walls/hybrisa_spaceport_walls.dmi'
	icon_state = "hwall"
	walltype = WALL_REINFORCED
	turf_flags = TURF_HULL
