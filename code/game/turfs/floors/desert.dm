
//Desert Map

/turf/open/desert //Basic groundmap turf parent
	name = "desert dirt"
	icon = 'icons/turf/floors/desert.dmi'
	icon_state = "desert1"
	is_groundmap_turf = TRUE

/turf/open/desert/ex_act(severity) //Should make it indestructible
	return

/turf/open/desert/fire_act(exposed_temperature, exposed_volume)
	return

/turf/open/desert/attackby() //This should fix everything else. No cables, etc
	return

//turf/open/desert/desert
// name = "desert"
// icon_state = "desert1"

/turf/open/desert/dirt
	name = "desert"
	icon_state = "desert1"
	is_weedable = FULLY_WEEDABLE

/turf/open/desert/dirt/desert_transition_edge1
	icon_state = "desert_transition_edge1"

/turf/open/desert/dirt/desert_transition_edge1/southwest
	dir = SOUTHWEST

/turf/open/desert/dirt/dirt_transition_edge1
	name = "desert"
	icon_state = "dirt4_transition_edge1"
/turf/open/desert/dirt/dirt_transition_corner1
	name = "desert"
	icon_state = "dirt4_transition_corner1"
/turf/open/desert/dirt/dirt_transition_edge2
	name = "desert"
	icon_state = "dirt4_transition_edge2"
/turf/open/desert/dirt/dirt_transition_corner2
	name = "desert"
	icon_state = "dirt4_transition_corner2"

/turf/open/desert/dirt/desert_transition_corner1
	icon_state = "desert_transition_corner1"

/turf/open/desert/dirt/desert_transition_corner1/north
	dir = NORTH

/turf/open/desert/dirt/desert_transition_edge1/north
	dir = NORTH

/turf/open/desert/dirt/desert_transition_corner1/east
	dir = EAST

/turf/open/desert/dirt/desert_transition_edge1/east
	dir = EAST

/turf/open/desert/dirt/desert_transition_edge1/northeast
	dir = NORTHEAST

/turf/open/desert/dirt/desert_transition_edge1/southeast
	dir = SOUTHEAST

/turf/open/desert/dirt/desert_transition_corner1/west
	dir = WEST

/turf/open/desert/dirt/desert_transition_edge1/west
	dir = WEST

/turf/open/desert/dirt/desert_transition_edge1/northwest
	dir = NORTHWEST

/turf/open/desert/dirt/dirt2
	icon_state = "dirt2"

/turf/open/desert/dirt/rock1
	icon_state = "rock1"

//desert floor
/turf/open/desert/rock
	name = "rock"
	icon_state = "rock1"
	is_weedable = FULLY_WEEDABLE

/turf/open/desert/rock/edge1
	name = "desert"
	icon_state = "desert_transition_edge1"
/*
/turf/open/desert/rock/edge2
	name = "desert"
	icon_state = "desert_transition_edge2"
/turf/open/desert/rock/edge3
	name = "desert"
	icon_state = "desert_transition_edge3"
*/
/turf/open/desert/rock/corner1
	name = "desert"
	icon_state = "desert_transition_corner1"
/*
/turf/open/desert/rock/corner2
	name = "desert"
	icon_state = "desert_transition_corner2"
/turf/open/desert/rock/corner3
	name = "desert"
	icon_state = "desert_transition_corner3"
*/

//desert floor
/turf/open/desert/rock/deep
	name = "cave"
	icon_state = "rock2"

/turf/open/desert/rock/deep/rock3
	icon_state = "rock3"

/turf/open/desert/rock/deep/rock4
	icon_state = "rock4"

/turf/open/desert/rock/edge1/east
	dir = EAST

/turf/open/desert/rock/deep/transition
	icon_state = "rock2_transition"

/turf/open/desert/rock/deep/transition/southwest
	dir = SOUTHWEST

/turf/open/desert/rock/deep/transition/north
	dir = NORTH

/turf/open/desert/rock/deep/transition/east
	dir = EAST

/turf/open/desert/rock/deep/transition/northeast
	dir = NORTHEAST

/turf/open/desert/rock/deep/transition/southeast
	dir = SOUTHEAST

/turf/open/desert/rock/deep/transition/west
	dir = WEST

/turf/open/desert/rock/deep/transition/northwest
	dir = NORTHWEST

//Desert grass
/turf/open/desert/desertgrass
	name = "desert"
	icon_state = "desert_grass"
/turf/open/desert/desertgrass/grass_edge
	name = "desert"
	icon_state = "desert_grass_transition_edge1"



//Desert shore

/turf/open/desert/desert_shore
	icon = 'icons/turf/floors/desert_water.dmi'
	icon_state = "shore1"
	var/toxic = 0
	supports_surgery = FALSE
	is_weedable = NOT_WEEDABLE

/turf/open/desert/desert_shore/update_icon()
	..()
	switch(toxic)
		if(1)
			set_light(2)
			icon = 'icons/turf/floors/desert_water_toxic.dmi'
		if(0)
			set_light(0)
			icon = 'icons/turf/floors/desert_water.dmi'
		if(-1)
			set_light(1)
			icon = 'icons/turf/floors/desert_water_transition.dmi'

/turf/open/desert/desert_shore/desert_shore1
	name = "shore"
	icon_state = "shore1"

/turf/open/desert/desert_shore/desert_shore1/north
	dir = NORTH

/turf/open/desert/desert_shore/desert_shore1/east
	dir = EAST

/turf/open/desert/desert_shore/desert_shore1/west
	dir = WEST

/turf/open/desert/desert_shore/shore_corner1/north
	dir = NORTH

/turf/open/desert/desert_shore/shore_corner1/west
	dir = WEST

/turf/open/desert/desert_shore/shore_corner2/north
	dir = NORTH

/turf/open/desert/desert_shore/shore_corner2/east
	dir = EAST

/turf/open/desert/desert_shore/shore_corner2/west
	dir = WEST

/turf/open/desert/desert_shore/shore_edge1/north
	dir = NORTH

/turf/open/desert/desert_shore/shore_edge1/east
	dir = EAST

/turf/open/desert/desert_shore/shore_edge1/west
	dir = WEST

/*
/turf/open/desert/desert_shore/desert_shore2
	name = "shore"
	icon_state = "shore2"
/turf/open/desert/desert_shore/desert_shore3
	name = "shore"
	icon_state = "shore3"
*/


/turf/open/desert/desert_shore/shore_edge1
	name = "shore"
	icon_state = "shore_edge1"
/turf/open/desert/desert_shore/shore_corner1
	name = "shore"
	icon_state = "shore_corner1"
/turf/open/desert/desert_shore/shore_corner2
	name = "shore"
	icon_state = "shore_corner2"

//Desert Waterway
/turf/open/desert/waterway
	icon = 'icons/turf/floors/desert_water.dmi'
	icon_state = "dock"
	supports_surgery = FALSE

/turf/open/desert/waterway/desert_waterway
	icon = 'icons/turf/floors/desert_water.dmi'
	icon_state = "dock"
/turf/open/desert/waterway/desert_waterway_c
	icon = 'icons/turf/floors/desert_water.dmi'
	icon_state = "dock_c"
/turf/open/desert/waterway/desert_waterway_cave
	icon = 'icons/turf/floors/desert_water.dmi'
	icon_state = "dock_caves"
/turf/open/desert/waterway/desert_waterway_cave_c
	icon = 'icons/turf/floors/desert_water.dmi'
	icon_state = "dock_caves_c"


//Desert Cave
/turf/open/desert/cave
	icon = 'icons/turf/floors/desertdam_map.dmi'
	icon_state = "outer_cave_floor1"

//desert floor to outer cave floor transition
/turf/open/desert/cave/desert_into_outer_cave_floor
	name = "cave"
	icon_state = "outer_cave_transition1"

//outer cave floor
/turf/open/desert/cave/outer_cave_floor
	name = "cave"
	icon_state = "outer_cave_floor1"

//outer to inner cave floor transition
/turf/open/desert/cave/outer_cave_to_inner_cave
	name = "cave"
	icon_state = "outer_cave_to_inner1"

//inner cave floor
/turf/open/desert/cave/inner_cave_floor
	name = "cave"
	icon_state = "inner_cave_1"

//inner cave shore
/turf/open/desert/cave/cave_shore
	name = "cave shore"
	icon = 'icons/turf/floors/desert_water.dmi'
	icon_state = "shore_caves"
	var/toxic = 0

/turf/open/desert/cave/cave_shore/update_icon()
	..()
	switch(toxic)
		if(1)
			set_light(2)
			icon = 'icons/turf/floors/desert_water_toxic.dmi'
		if(0)
			set_light(0)
			icon = 'icons/turf/floors/desert_water.dmi'
		if(-1)
			set_light(1)
			icon = 'icons/turf/floors/desert_water_transition.dmi'

/turf/open/desert/cave/cave_shore/east
	dir = EAST

/turf/open/desert/cave/cave_shore/northeast
	dir = NORTHEAST

/turf/open/desert/cave/cave_shore/southeast
	dir = SOUTHEAST

//Desert River Toxic
/turf/open/gm/river/desert
	name = "water"
	icon = 'icons/turf/floors/desert_water.dmi'
	icon_state = "shallow"
	icon_overlay = "_shallow"
	var/toxic = 0
	default_name = "water"
	is_weedable = NOT_WEEDABLE

/turf/open/gm/river/desert/update_icon()
	..()
	switch(toxic)
		if(1)
			set_light(2)
			icon = 'icons/turf/floors/desert_water_toxic.dmi'
		if(0)
			set_light(0)
			icon = 'icons/turf/floors/desert_water.dmi'
		if(-1)
			set_light(1)
			icon = 'icons/turf/floors/desert_water_transition.dmi'
	update_overlays()


//shallow water
/turf/open/gm/river/desert/shallow
	icon_state = "shallow"
	icon_overlay = "_shallow"

/turf/open/gm/river/desert/shallow/covered
	covered = TRUE
	icon = 'icons/turf/floors/desert_water_covered.dmi'

/turf/open/gm/river/desert/shallow/toxic
	icon = 'icons/turf/floors/desert_water_toxic.dmi'

/turf/open/gm/river/desert/shallow/pool
	name = "pool"

//shallow water transition to deep
/turf/open/gm/river/desert/shallow_edge
	icon_state = "shallow_edge"
	icon_overlay = "shallow_edge_overlay"

/turf/open/gm/river/desert/shallow_edge/southwest
	dir = SOUTHWEST

/turf/open/gm/river/desert/shallow_edge/north
	dir = NORTH

/turf/open/gm/river/desert/shallow_edge/east
	dir = EAST

/turf/open/gm/river/desert/shallow_edge/northeast
	dir = NORTHEAST

/turf/open/gm/river/desert/shallow_edge/southeast
	dir = SOUTHEAST

/turf/open/gm/river/desert/shallow_edge/west
	dir = WEST

/turf/open/gm/river/desert/shallow_edge/northwest
	dir = NORTHWEST

/turf/open/gm/river/desert/shallow_edge/covered
	covered = TRUE
	icon = 'icons/turf/floors/desert_water_covered.dmi'

/turf/open/gm/river/desert/shallow_edge/covered/north
	dir = NORTH

/turf/open/gm/river/desert/shallow_edge/covered/east
	dir = EAST

/turf/open/gm/river/desert/shallow_edge/covered/northeast
	dir = NORTHEAST

/turf/open/gm/river/desert/shallow_edge/covered/west
	dir = WEST

//shallow water transition to deep corner
/turf/open/gm/river/desert/shallow_corner
	icon_state = "shallow_c"
	icon_overlay = "shallow_c_overlay"

/turf/open/gm/river/desert/shallow_corner/covered
	covered = TRUE
	icon = 'icons/turf/floors/desert_water_covered.dmi'

/turf/open/gm/river/desert/shallow_corner/north
	dir = NORTH

/turf/open/gm/river/desert/shallow_corner/east
	dir = EAST

/turf/open/gm/river/desert/shallow_corner/west
	dir = WEST


//deep water
/turf/open/gm/river/desert/deep
	icon_state = "deep"
	icon_overlay = "_deep"

/turf/open/gm/river/desert/deep/no_slowdown
	base_river_slowdown = 0

/turf/open/gm/river/desert/deep/covered
	covered = TRUE
	icon = 'icons/turf/floors/desert_water_covered.dmi'

/turf/open/gm/river/desert/deep/toxic
	icon = 'icons/turf/floors/desert_water_toxic.dmi'

//shallow water channel plain
/turf/open/gm/river/desert/channel
	icon_state = "channel"

//shallow water channel edge
/turf/open/gm/river/desert/channel_edge
	icon_state = "channel_edge"

//shallow water channel corner
/turf/open/gm/river/desert/channel_three
	icon_state = "channel_three"


/turf/open/desert/excavation
	icon = 'icons/turf/floors/desert_excavation.dmi'
	icon_state = null

//Engineer Ship
/turf/open/desert/excavation/component1
	icon_state = "component1"

/turf/open/desert/excavation/component1/southwest
	dir = SOUTHWEST

/turf/open/desert/excavation/component1/north
	dir = NORTH

/turf/open/desert/excavation/component1/east
	dir = EAST

/turf/open/desert/excavation/component1/northeast
	dir = NORTHEAST

/turf/open/desert/excavation/component1/southeast
	dir = SOUTHEAST

/turf/open/desert/excavation/component1/west
	dir = WEST

/turf/open/desert/excavation/component2
	icon_state = "component2"

/turf/open/desert/excavation/component2/north
	dir = NORTH

/turf/open/desert/excavation/component2/east
	dir = EAST

/turf/open/desert/excavation/component2/southeast
	dir = SOUTHEAST

/turf/open/desert/excavation/component2/west
	dir = WEST

/turf/open/desert/excavation/component3
	icon_state = "component3"

/turf/open/desert/excavation/component3/southwest
	dir = SOUTHWEST

/turf/open/desert/excavation/component3/north
	dir = NORTH

/turf/open/desert/excavation/component3/east
	dir = EAST

/turf/open/desert/excavation/component3/northeast
	dir = NORTHEAST

/turf/open/desert/excavation/component3/southeast
	dir = SOUTHEAST

/turf/open/desert/excavation/component3/west
	dir = WEST

/turf/open/desert/excavation/component4
	icon_state = "component4"

/turf/open/desert/excavation/component4/north
	dir = NORTH

/turf/open/desert/excavation/component4/east
	dir = EAST

/turf/open/desert/excavation/component4/southeast
	dir = SOUTHEAST

/turf/open/desert/excavation/component4/west
	dir = WEST

/turf/open/desert/excavation/component5
	icon_state = "component5"

/turf/open/desert/excavation/component5/southwest
	dir = SOUTHWEST

/turf/open/desert/excavation/component5/north
	dir = NORTH

/turf/open/desert/excavation/component5/east
	dir = EAST

/turf/open/desert/excavation/component5/northeast
	dir = NORTHEAST

/turf/open/desert/excavation/component5/southeast
	dir = SOUTHEAST

/turf/open/desert/excavation/component5/west
	dir = WEST

/turf/open/desert/excavation/component6
	icon_state = "component6"

/turf/open/desert/excavation/component6/southwest
	dir = SOUTHWEST

/turf/open/desert/excavation/component6/north
	dir = NORTH

/turf/open/desert/excavation/component6/east
	dir = EAST

/turf/open/desert/excavation/component6/northeast
	dir = NORTHEAST

/turf/open/desert/excavation/component6/southeast
	dir = SOUTHEAST

/turf/open/desert/excavation/component6/west
	dir = WEST

/turf/open/desert/excavation/component7
	icon_state = "component7"

/turf/open/desert/excavation/component7/southwest
	dir = SOUTHWEST

/turf/open/desert/excavation/component7/north
	dir = NORTH

/turf/open/desert/excavation/component7/east
	dir = EAST

/turf/open/desert/excavation/component7/northeast
	dir = NORTHEAST

/turf/open/desert/excavation/component7/southeast
	dir = SOUTHEAST

/turf/open/desert/excavation/component7/west
	dir = WEST

/turf/open/desert/excavation/component8
	icon_state = "component8"

/turf/open/desert/excavation/component8/southwest
	dir = SOUTHWEST

/turf/open/desert/excavation/component8/north
	dir = NORTH

/turf/open/desert/excavation/component8/east
	dir = EAST

/turf/open/desert/excavation/component8/northeast
	dir = NORTHEAST

/turf/open/desert/excavation/component8/southeast
	dir = SOUTHEAST

/turf/open/desert/excavation/component8/west
	dir = WEST

/turf/open/desert/excavation/component8/northwest
	dir = NORTHWEST

/turf/open/desert/excavation/component9
	icon_state = "component9"

/turf/open/desert/excavation/component9/southwest
	dir = SOUTHWEST

/turf/open/desert/excavation/component9/north
	dir = NORTH

/turf/open/desert/excavation/component9/east
	dir = EAST

/turf/open/desert/excavation/component9/southeast
	dir = SOUTHEAST

/turf/open/desert/excavation/component9/west
	dir = WEST
