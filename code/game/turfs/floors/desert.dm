
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

/turf/open/desert/dirt/is_weedable()
	return FULLY_WEEDABLE

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

//desert riverbed
/turf/open/desert/riverbed/dirt1
	name = "riverbed"
	icon_state = "dirt1"
//turf/open/desert/riverbed/dirt2
// name = "riverbed"
// icon_state = "dirt2"
//turf/open/desert/riverbed/dirt3
// name = "riverbed"
// icon_state = "dirt3"

//desert floor
/turf/open/desert/rock
	name = "rock"
	icon_state = "rock1"

/turf/open/desert/rock/is_weedable()
	return FULLY_WEEDABLE

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
/turf/open/desert/rock/deep/transition
	icon_state = "rock2_transition"

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

/turf/open/desert/desert_shore/update_icon()
	..()
	switch(toxic)
		if(1)
			SetLuminosity(2)
			icon = 'icons/turf/floors/desert_water_toxic.dmi'
		if(0)
			SetLuminosity(1)
			icon = 'icons/turf/floors/desert_water.dmi'
		if(-1)
			SetLuminosity(1)
			icon = 'icons/turf/floors/desert_water_transition.dmi'

/turf/open/desert/desert_shore/is_weedable()
	return NOT_WEEDABLE

/turf/open/desert/desert_shore/desert_shore1
	name = "shore"
	icon_state = "shore1"
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
			SetLuminosity(2)
			icon = 'icons/turf/floors/desert_water_toxic.dmi'
		if(0)
			SetLuminosity(1)
			icon = 'icons/turf/floors/desert_water.dmi'
		if(-1)
			SetLuminosity(1)
			icon = 'icons/turf/floors/desert_water_transition.dmi'

//Desert River Toxic
/turf/open/gm/river/desert
	name = "water"
	icon = 'icons/turf/floors/desert_water.dmi'
	icon_state = "shallow"
	icon_overlay = "_shallow"
	var/toxic = 0
	default_name = "water"

/turf/open/gm/river/desert/is_weedable()
	return NOT_WEEDABLE

/turf/open/gm/river/desert/update_icon()
	..()
	switch(toxic)
		if(1)
			SetLuminosity(2)
			icon = 'icons/turf/floors/desert_water_toxic.dmi'
		if(0)
			SetLuminosity(1)
			icon = 'icons/turf/floors/desert_water.dmi'
		if(-1)
			SetLuminosity(1)
			icon = 'icons/turf/floors/desert_water_transition.dmi'
	update_overlays()


//shallow water
/turf/open/gm/river/desert/shallow
	icon_state = "shallow"
	icon_overlay = "_shallow"

/turf/open/gm/river/desert/shallow/covered
	covered = 1
	icon = 'icons/turf/floors/desert_water_covered.dmi'

//shallow water transition to deep
/turf/open/gm/river/desert/shallow_edge
	icon_state = "shallow_edge"
	icon_overlay = "shallow_edge_overlay"

/turf/open/gm/river/desert/shallow_edge/covered
	covered = 1
	icon = 'icons/turf/floors/desert_water_covered.dmi'

//shallow water transition to deep corner
/turf/open/gm/river/desert/shallow_corner
	icon_state = "shallow_c"
	icon_overlay = "shallow_c_overlay"

/turf/open/gm/river/desert/shallow_corner/covered
	covered = 1
	icon = 'icons/turf/floors/desert_water_covered.dmi'


//deep water
/turf/open/gm/river/desert/deep
	icon_state = "deep"
	icon_overlay = "_deep"

/turf/open/gm/river/desert/deep/covered
	covered = 1
	icon = 'icons/turf/floors/desert_water_covered.dmi'

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
//Engineer Ship
/turf/open/desert/excavation/component1
	icon_state = "component1"
/turf/open/desert/excavation/component2
	icon_state = "component2"
/turf/open/desert/excavation/component3
	icon_state = "component3"
/turf/open/desert/excavation/component4
	icon_state = "component4"
/turf/open/desert/excavation/component5
	icon_state = "component5"
/turf/open/desert/excavation/component6
	icon_state = "component6"
/turf/open/desert/excavation/component7
	icon_state = "component7"
/turf/open/desert/excavation/component8
	icon_state = "component8"
/turf/open/desert/excavation/component9
	icon_state = "component9"
