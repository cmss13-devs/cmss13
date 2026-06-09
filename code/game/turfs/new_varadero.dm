//================================================================== NEW VARADERO OPEN TURFS

//---------------concrete tile
/turf/open/point_loma/dock_concrete
	icon = 'icons/turf/floors/point_loma/concrete_floor_tile.dmi'
	icon_state = "concretefloor"


//---------------CEMENT

/turf/open/asphalt/cement_shaded
	name = "foundation cement"
	icon = 'icons/turf/floors/point_loma/shaded_cement.dmi'
	icon_state = "sunbleached_asphalt"

/turf/open/asphalt/cement_shaded/full
	icon_state = "cement5"

/turf/open/asphalt/cement_shaded/east
	icon_state = "cement1"

/turf/open/asphalt/cement_shaded/west
	icon_state = "cement3"

/turf/open/asphalt/cement_shaded/north
	icon_state = "cement4"

/turf/open/asphalt/cement_shaded/south
	icon_state = "cement12"

/turf/open/asphalt/cement_shaded/northwest
	icon_state = "cement2"

/turf/open/asphalt/cement_shaded/northeast
	icon_state = "cement9"

/turf/open/asphalt/cement_shaded/southwest
	icon_state = "cement14"

/turf/open/asphalt/cement_shaded/southeast
	icon_state = "cement15"

/turf/open/asphalt/cement_shaded/tip_east
	icon_state = "cement16"

/turf/open/asphalt/cement_shaded/tip_south
	icon_state = "cement17"

/turf/open/asphalt/cement_shaded/west_east
	icon_state = "cement13"

/turf/open/asphalt/cement_shaded/north_south
	icon_state = "cement18"

//---------------New Varadero Beach
//AVOID USING BASE COASTAL, use auto-turf coastal

/turf/open/coastal
	name = "coastal ground"
	icon = 'icons/turf/floors/point_loma/auto_sand_rock_nv.dmi'
	icon_state = "white_sand_0"
	baseturfs = /turf/open/coastal

/turf/open/coastal/sand/gritty
	icon_state = "white_sand_misc"
	is_weedable = NOT_WEEDABLE

/turf/open/coastal/sand/scattered_rock
	icon_state = "white_sand_misc_1"
	is_weedable = NOT_WEEDABLE

/turf/open/coastal/sand/tough_sand
	icon_state = "white_sand_misc_2"
	is_weedable = NOT_WEEDABLE

/turf/open/coastal/sand/rocky
	icon_state = "white_sand_misc_3"
	is_weedable = NOT_WEEDABLE

/turf/open/coastal/rock
	icon_state = "rock_0"

/turf/open/coastal/rock/alt_1
	icon_state = "rock_alt"

/turf/open/coastal/rock/alt_2
	icon_state = "rock_alt_1"

/turf/open/coastal/rock/alt_3
	icon_state = "rock_alt_2"

/turf/open/coastal/rock/alt_4
	icon_state = "rock_alt_3"

//--------------- FOUNDATION TURFS

/turf/open/point_loma
	name = "foundation ground"
	icon = 'icons/turf/floors/point_loma/concrete_bits.dmi'
	icon_state = "dark_asteroidplating"
	baseturfs = /turf/open/point_loma

/turf/open/point_loma/taupe_concrete
	icon_state = "dark_asteroidfloor"

/turf/open/point_loma/taupe_concrete/grate
	icon_state = "warning_grate"
	dir = NORTH

/turf/open/point_loma/taupe_concrete/grate_s
	icon_state = "warning_grate"
	dir = EAST

/turf/open/point_loma/taupe_concrete/warning
	icon_state = "dark_asteroidwarning"
	dir = NORTH

/turf/open/point_loma/taupe_concrete/warning/south
	dir = SOUTH

/turf/open/point_loma/taupe_concrete/warning/west
	dir = WEST

/turf/open/point_loma/taupe_concrete/warning/east
	dir = EAST

/turf/open/point_loma/taupe_concrete/warning/corner
	dir = NORTHWEST

/turf/open/point_loma/taupe_concrete/warning/corner/northeast
	dir = NORTHEAST

/turf/open/point_loma/taupe_concrete/warning/corner/southwest
	dir = SOUTHWEST

/turf/open/point_loma/taupe_concrete/warning/corner/southeast
	dir = SOUTHEAST

/turf/open/point_loma/taupe_concrete/warning/corner_edge
	icon_state = "dark_asteroidfloor_corner"

/turf/open/point_loma/taupe_concrete/warning/corner_edge/northeast
	dir = 1

/turf/open/point_loma/taupe_concrete/warning/corner_edge/southwest
	dir = 4

/turf/open/point_loma/taupe_concrete/warning/corner_edge/southeast
	dir = 8

/turf/open/point_loma/taupe_concrete/filtration
	icon_state = "filtrationside"

/turf/open/point_loma/taupe_concrete/filtration/south
	dir = SOUTH

/turf/open/point_loma/taupe_concrete/filtration/west
	dir = WEST

/turf/open/point_loma/taupe_concrete/filtration/east
	dir = EAST

/turf/open/point_loma/taupe_concrete/filtration/northwest
	dir = NORTHWEST

/turf/open/point_loma/taupe_concrete/filtration/northeast
	dir = NORTHEAST

/turf/open/point_loma/taupe_concrete/filtration/southwest
	dir = SOUTHWEST

/turf/open/point_loma/taupe_concrete/filtration/southeast
	dir = SOUTHEAST

/turf/open/point_loma/taupe_concrete/filtration_straight
	icon_state = "filtrationside_straight"
	dir = NORTH

/turf/open/point_loma/taupe_concrete/filtration_straight/south
	dir = SOUTH

/turf/open/point_loma/taupe_concrete/filtration_straight/west
	dir = WEST

/turf/open/point_loma/taupe_concrete/filtration_straight/east
	dir = EAST

//---------------ALTERNATE
//used more than the taupe version

/turf/open/point_loma/alt_concrete
	icon_state = "dark_asteroidplating_alt"

/turf/open/point_loma/alt_concrete/floor
	icon_state = "dark_asteroidfloor_alt"

/turf/open/point_loma/alt_concrete/grate
	icon_state = "warning_grate_alt"
	dir = NORTH

/turf/open/point_loma/alt_concrete/grate_s
	icon_state = "warning_grate_alt"
	dir = EAST

/turf/open/point_loma/alt_concrete/warning
	icon_state = "dark_asteroidwarning_alt"
	dir = NORTH

/turf/open/point_loma/alt_concrete/warning/south
	dir = SOUTH

/turf/open/point_loma/alt_concrete/warning/west
	dir = WEST

/turf/open/point_loma/alt_concrete/warning/east
	dir = EAST

/turf/open/point_loma/alt_concrete/warning/corner
	dir = NORTHWEST

/turf/open/point_loma/alt_concrete/warning/corner/northeast
	dir = NORTHEAST

/turf/open/point_loma/alt_concrete/warning/corner/southwest
	dir = SOUTHWEST

/turf/open/point_loma/alt_concrete/warning/corner/southeast
	dir = SOUTHEAST

/turf/open/point_loma/alt_concrete/warning/corner_edge
	icon_state = "dark_asteroidfloor_corner_alt"
	dir = 2

/turf/open/point_loma/alt_concrete/warning/corner_edge/northeast
	dir = 1

/turf/open/point_loma/alt_concrete/warning/corner_edge/southwest
	dir = 4

/turf/open/point_loma/alt_concrete/warning/corner_edge/southeast
	dir = 8

/turf/open/point_loma/alt_concrete/filtration
	icon_state = "filtrationside_alt"

/turf/open/point_loma/alt_concrete/filtration/south
	dir = SOUTH

/turf/open/point_loma/alt_concrete/filtration/west
	dir = WEST

/turf/open/point_loma/alt_concrete/filtration/east
	dir = EAST

/turf/open/point_loma/alt_concrete/filtration/northwest
	dir = NORTHWEST

/turf/open/point_loma/alt_concrete/filtration/northeast
	dir = NORTHEAST

/turf/open/point_loma/alt_concrete/filtration/southwest
	dir = SOUTHWEST

/turf/open/point_loma/alt_concrete/filtration/southeast
	dir = SOUTHEAST

/turf/open/point_loma/alt_concrete/filtration_straight
	icon_state = "filtrationside_straight_alt"
	dir = NORTH

/turf/open/point_loma/alt_concrete/filtration_straight/south
	dir = SOUTH

/turf/open/point_loma/alt_concrete/filtration_straight/west
	dir = WEST

/turf/open/point_loma/alt_concrete/filtration_straight/east
	dir = EAST

//---------------SIDEWALK
// Closely Matches Alt Foundation Turf
/turf/open/point_loma/sidewalk
	icon = 'icons/turf/floors/point_loma/side_walk_alt.dmi'
	icon_state = "sidewalk"

/turf/open/point_loma/sidewalk/sidewalkfull
	icon_state = "sidewalkfull"

/turf/open/point_loma/sidewalk/south
	dir = SOUTH

/turf/open/point_loma/sidewalk/north
	dir = NORTH

/turf/open/point_loma/sidewalk/west
	dir = WEST

/turf/open/point_loma/sidewalk/east
	dir = EAST

/turf/open/point_loma/sidewalk/northeast
	dir = NORTHEAST

/turf/open/point_loma/sidewalk/southwest
	dir = SOUTHWEST

/turf/open/point_loma/sidewalk/northwest
	dir = NORTHWEST

/turf/open/point_loma/sidewalk/southeast
	dir = SOUTHEAST

/turf/open/point_loma/sidewalk/sidewalkcorner
	icon_state = "sidewalkcorner"

/turf/open/point_loma/sidewalk/sidewalkcorner/northeast
	dir = 1

/turf/open/point_loma/sidewalk/sidewalkcorner/southwest
	dir = 4

/turf/open/point_loma/sidewalk/sidewalkcorner/southeast
	dir = 8

/turf/open/point_loma/sidewalk/sidewalkcenter
	icon_state = "sidewalkcenter"

/turf/open/point_loma/sidewalk/sidewalkcenter/south
	dir = SOUTH

/turf/open/point_loma/sidewalk/sidewalkcenter/north
	dir = NORTH

/turf/open/point_loma/sidewalk/sidewalkcenter/west
	dir = WEST

/turf/open/point_loma/sidewalk/sidewalkcenter/east
	dir = EAST

/turf/open/point_loma/sidewalk/sidewalkcenter_darker
	icon_state = "sidewalkcenter_darker"

/turf/open/point_loma/sidewalk/sidewalkcenter_darker/south
	dir = SOUTH

/turf/open/point_loma/sidewalk/sidewalkcenter_darker/north
	dir = NORTH

/turf/open/point_loma/sidewalk/sidewalkcenter_darker/west
	dir = WEST

/turf/open/point_loma/sidewalk/sidewalkcenter_darker/east
	dir = EAST

//---------------Ship Tile, thats it

/turf/open/point_loma/ship/simple
	icon = 'icons/turf/floors/point_loma/ship_flooring_tile.dmi'
	icon_state = "ship_floor"

//---------------GRATES

/turf/open/point_loma/grate
	icon = 'icons/turf/floors/point_loma/point_loma_turfs.dmi'
	icon_state = "full_grate"
	is_weedable = SEMI_WEEDABLE
	desc = "This design of grates have every-so-tiny prongs on it while it doesn't hurt to be on it; its intent is to prevent build-up from debris."

/turf/open/point_loma/grate/full/north
	dir = NORTH

/turf/open/point_loma/grate/full/south
	dir = SOUTH

/turf/open/point_loma/grate/full/west
	dir = WEST

/turf/open/point_loma/grate/full/east
	dir = EAST

/turf/open/point_loma/grate/full_side
	icon_state = "full_grate_side"

/turf/open/point_loma/grate/full_side/north
	dir = NORTH

/turf/open/point_loma/grate/full_side/south
	dir = SOUTH

/turf/open/point_loma/grate/full_side/west
	dir = WEST

/turf/open/point_loma/grate/full_side/east
	dir = EAST

/turf/open/point_loma/grate/full_tip
	icon_state = "full_grate_tip"

/turf/open/point_loma/grate/full_tip/north
	dir = NORTH

/turf/open/point_loma/grate/full_tip/south
	dir = SOUTH

/turf/open/point_loma/grate/full_tip/west
	dir = WEST

/turf/open/point_loma/grate/full_tip/east
	dir = EAST

/turf/open/point_loma/grate/full_ALT
	icon_state = "full_grate_ALT"

/turf/open/point_loma/grate/full_ALT/north
	dir = NORTH

/turf/open/point_loma/grate/full_ALT/south
	dir = SOUTH

/turf/open/point_loma/grate/full_ALT/west
	dir = WEST

/turf/open/point_loma/grate/full_ALT/east
	dir = EAST

/turf/open/point_loma/grate/full_side_ALT
	icon_state = "full_grate_ALT_side"

/turf/open/point_loma/grate/full_side_ALT/north
	dir = NORTH

/turf/open/point_loma/grate/full_side_ALT/south
	dir = SOUTH

/turf/open/point_loma/grate/full_side_ALT/west
	dir = WEST

/turf/open/point_loma/grate/full_side_ALT/east
	dir = EAST

/turf/open/point_loma/grate/edge
	icon_state = "grate_edge_straight"
	dir = NORTH

/turf/open/point_loma/grate/edge/south
	dir = SOUTH

/turf/open/point_loma/grate/edge/west
	dir = WEST

/turf/open/point_loma/grate/edge/east
	dir = EAST

/turf/open/point_loma/grate/edge/corner
	icon_state = "grate_edge_corner"
	dir = NORTH

/turf/open/point_loma/grate/edge/corner/southwest
	dir = SOUTH

/turf/open/point_loma/grate/edge/corner/northwest
	dir = WEST

/turf/open/point_loma/grate/edge/corner/northeast
	dir = EAST

/turf/open/point_loma/grate/edge/tsection
	icon_state = "grate_edge_Tsection"
	dir = NORTH

/turf/open/point_loma/grate/edge/tsection/northwest
	dir = SOUTH

/turf/open/point_loma/grate/edge/tsection/southeast
	dir = WEST

/turf/open/point_loma/grate/edge/tsection/southwest
	dir = EAST

/turf/open/point_loma/grate/edge/alt
	icon_state = "grate_edge_ALT_straight"
	dir = NORTH

/turf/open/point_loma/grate/edge/alt/south
	dir = SOUTH

/turf/open/point_loma/grate/edge/alt/west
	dir = WEST

/turf/open/point_loma/grate/edge/alt/east
	dir = EAST

/turf/open/point_loma/grate/edge/alt/corner
	icon_state = "grate_edge_ALT_corner"
	dir = NORTH

/turf/open/point_loma/grate/edge/alt/corner/southwest
	dir = SOUTH

/turf/open/point_loma/grate/edge/alt/corner/northwest
	dir = WEST

/turf/open/point_loma/grate/edge/alt/corner/northeast
	dir = EAST

/turf/open/point_loma/grate/edge/alt/tsection
	icon_state = "grate_edge_ALT_Tsection"
	dir = NORTH

/turf/open/point_loma/grate/edge/alt/tsection/northwest
	dir = SOUTH

/turf/open/point_loma/grate/edge/alt/tsection/southeast
	dir = WEST

/turf/open/point_loma/grate/edge/alt/tsection/southwest
	dir = EAST

/turf/open/point_loma/grate/center
	icon_state = "grate_center_straight"
	dir = NORTH

/turf/open/point_loma/grate/center/south
	dir = SOUTH

/turf/open/point_loma/grate/center/west
	dir = WEST

/turf/open/point_loma/grate/center/east
	dir = EAST

/turf/open/point_loma/grate/center/corner
	icon_state = "grate_center_corner"
	dir = NORTH

/turf/open/point_loma/grate/center/corner/southwest
	dir = SOUTH

/turf/open/point_loma/grate/center/corner/northwest
	dir = WEST

/turf/open/point_loma/grate/center/corner/northeast
	dir = EAST

/turf/open/point_loma/grate/center/tsection
	icon_state = "grate_center_Tsection"
	dir = NORTH

/turf/open/point_loma/grate/center/tsection/northwest
	dir = SOUTH

/turf/open/point_loma/grate/center/tsection/southeast
	dir = WEST

/turf/open/point_loma/grate/center/tsection/southwest
	dir = EAST

/turf/open/point_loma/grate/center/alt
	icon_state = "grate_center_ALT_straight"
	dir = NORTH

/turf/open/point_loma/grate/center/alt/south
	dir = SOUTH

/turf/open/point_loma/grate/center/alt/west
	dir = WEST

/turf/open/point_loma/grate/center/alt/east
	dir = EAST

/turf/open/point_loma/grate/center/alt/corner
	icon_state = "grate_center_ALT_corner"
	dir = NORTH

/turf/open/point_loma/grate/center/alt/corner/southwest
	dir = SOUTH

/turf/open/point_loma/grate/center/alt/corner/northwest
	dir = WEST

/turf/open/point_loma/grate/center/alt/corner/northeast
	dir = EAST

/turf/open/point_loma/grate/center/alt/tsection
	icon_state = "grate_center_ALT_Tsection"
	dir = NORTH

/turf/open/point_loma/grate/center/alt/tsection/northwest
	dir = SOUTH

/turf/open/point_loma/grate/center/alt/tsection/southeast
	dir = WEST

/turf/open/point_loma/grate/center/alt/tsection/southwest
	dir = EAST

//---------------EXTERIORS
/turf/open/point_loma/grate/exterior/yellow
	icon_state = "yext_straight"
	dir = NORTH

/turf/open/point_loma/grate/exterior/yellow/south
	dir = SOUTH

/turf/open/point_loma/grate/exterior/yellow/west
	dir = WEST

/turf/open/point_loma/grate/exterior/yellow/east
	dir = EAST

/turf/open/point_loma/grate/exterior/yellow/warning
	icon_state = "yext_straight_warning"
	dir = NORTH

/turf/open/point_loma/grate/exterior/yellow/warning/south
	dir = SOUTH

/turf/open/point_loma/grate/exterior/yellow/warning/west
	dir = WEST

/turf/open/point_loma/grate/exterior/yellow/warning/east
	dir = EAST

/turf/open/point_loma/grate/exterior/yellow/panel
	icon_state = "yext_panel"
	dir = NORTH

/turf/open/point_loma/grate/exterior/yellow/panel/turned
	dir = WEST

/turf/open/point_loma/grate/exterior/yellow/plate
	icon_state = "yext_fullplate"
	dir = NORTH

/turf/open/point_loma/grate/exterior/yellow/plate/southwest
	dir = SOUTH

/turf/open/point_loma/grate/exterior/yellow/plate/northeast
	dir = WEST

/turf/open/point_loma/grate/exterior/yellow/plate/southeast
	dir = EAST

/turf/open/point_loma/grate/exterior/brown
	icon_state = "bext_straight"
	dir = NORTH

/turf/open/point_loma/grate/exterior/brown/south
	dir = SOUTH

/turf/open/point_loma/grate/exterior/brown/west
	dir = WEST

/turf/open/point_loma/grate/exterior/brown/east
	dir = EAST

/turf/open/point_loma/grate/exterior/brown/warning
	icon_state = "bext_straight_warning"
	dir = NORTH

/turf/open/point_loma/grate/exterior/brown/warning/south
	dir = SOUTH

/turf/open/point_loma/grate/exterior/brown/warning/west
	dir = WEST

/turf/open/point_loma/grate/exterior/brown/warning/east
	dir = EAST

/turf/open/point_loma/grate/exterior/brown/panel
	icon_state = "bext_panel"
	dir = NORTH

/turf/open/point_loma/grate/exterior/brown/panel/turned
	dir = WEST

/turf/open/point_loma/grate/exterior/brown/plate
	icon_state = "bext_fullplate"
	dir = NORTH

/turf/open/point_loma/grate/exterior/brown/plate/southwest
	dir = SOUTH

/turf/open/point_loma/grate/exterior/brown/plate/northeast
	dir = WEST

/turf/open/point_loma/grate/exterior/brown/plate/southeast
	dir = EAST

/turf/open/point_loma/grate/exterior/green
	icon_state = "gext_straight"
	dir = NORTH

/turf/open/point_loma/grate/exterior/green/south
	dir = SOUTH

/turf/open/point_loma/grate/exterior/green/west
	dir = WEST

/turf/open/point_loma/grate/exterior/green/east
	dir = EAST

/turf/open/point_loma/grate/exterior/green/warning
	icon_state = "gext_straight_warning"
	dir = NORTH

/turf/open/point_loma/grate/exterior/green/warning/south
	dir = SOUTH

/turf/open/point_loma/grate/exterior/green/warning/west
	dir = WEST

/turf/open/point_loma/grate/exterior/green/warning/east
	dir = EAST

/turf/open/point_loma/grate/exterior/green/panel
	icon_state = "gext_panel"
	dir = NORTH

/turf/open/point_loma/grate/exterior/green/panel/turned
	dir = WEST

/turf/open/point_loma/grate/exterior/green/plate
	icon_state = "gext_fullplate"
	dir = NORTH

/turf/open/point_loma/grate/exterior/green/plate/southwest
	dir = SOUTH

/turf/open/point_loma/grate/exterior/green/plate/northeast
	dir = WEST

/turf/open/point_loma/grate/exterior/green/plate/southeast
	dir = EAST

/turf/open/point_loma/grate/exterior/blue
	icon_state = "aext_straight"
	dir = NORTH

/turf/open/point_loma/grate/exterior/blue/south
	dir = SOUTH

/turf/open/point_loma/grate/exterior/blue/west
	dir = WEST

/turf/open/point_loma/grate/exterior/blue/east
	dir = EAST

/turf/open/point_loma/grate/exterior/blue/warning
	icon_state = "aext_straight_warning"
	dir = NORTH

/turf/open/point_loma/grate/exterior/blue/warning/south
	dir = SOUTH

/turf/open/point_loma/grate/exterior/blue/warning/west
	dir = WEST

/turf/open/point_loma/grate/exterior/blue/warning/east
	dir = EAST

/turf/open/point_loma/grate/exterior/blue/panel
	icon_state = "aext_panel"
	dir = NORTH

/turf/open/point_loma/grate/exterior/blue/panel/turned
	dir = WEST

/turf/open/point_loma/grate/exterior/blue/plate
	icon_state = "aext_fullplate"
	dir = NORTH

/turf/open/point_loma/grate/exterior/blue/plate/southwest
	dir = SOUTH

/turf/open/point_loma/grate/exterior/blue/plate/northeast
	dir = WEST

/turf/open/point_loma/grate/exterior/blue/plate/southeast
	dir = EAST
//================================================================== NEW VARADERO WALL TYPES

//---------------FOUNDATION WALLS

/turf/closed/wall/point_loma
	name = "foundation wall"
	desc = "A concrete wall with metal reinforcements."
	icon = 'icons/turf/walls/point_loma/point_loma_wall.dmi'
	icon_state = "new_varadero"
	walltype = WALL_NEW_VARADERO

/turf/closed/wall/point_loma/reinforced
	name = "secured foundation wall"
	desc = "A concrete wall with metal reinforcements. The plating seems to have more rivets giving a daunting finish."
	icon_state = "new_varadero_reinforced"
	walltype = WALL_NEW_VARADERO_REINFORCED
	damage_cap = HEALTH_WALL_REINFORCED

/turf/closed/wall/point_loma/reinforced/hull
	desc = "A concrete wall with metal reinforcements. The plating seems to have more rivets giving a daunting finish. This seems impenetrable to most conventional stands."
	icon_state = "new_varadero_hull"
	turf_flags = TURF_HULL

//---------------CONCRETE WALL

/turf/closed/wall/point_loma/concrete
	name = "concrete wall"
	desc = "What's inside here? That's concrete, baby!"
	icon = 'icons/turf/walls/point_loma/point_loma_wall.dmi'
	icon_state = "concrete"
	walltype = WALL_CONCRETE
	damage_cap = HEALTH_WALL

/turf/closed/wall/point_loma/concrete/reinforced
	desc = "What's inside here? That's concrete, baby! It also has some metal bars inside to reinforce it."
	damage_cap = HEALTH_WALL_REINFORCED
	icon_state = "concrete_reinforced"

/turf/closed/wall/point_loma/concrete/hull
	name = "concrete wall"
	desc = "What's inside here? That's concrete, baby with that roman regeneration techniques that are still used even now."
	icon = 'icons/turf/walls/point_loma/point_loma_wall.dmi'
	icon_state = "concrete_hull"
	turf_flags = TURF_HULL
