/// Distress Signal Global Setup Structure spawners
/obj/effect/landmark/structure_spawner/setup/distress
	name = "abstract distress spawner"
	mode_flags = MODE_INFESTATION

/obj/effect/landmark/structure_spawner/setup/distress/xeno_wall
	name = "Distress Xeno wall spawner"
	icon_state = "wall"
	path_to_spawn = /turf/closed/wall/resin
	is_turf = TRUE

/obj/effect/landmark/structure_spawner/setup/distress/xeno_membrane
	name = "Distress Xeno membrane spawner"
	icon_state = "membrane"
	path_to_spawn = /turf/closed/wall/resin/membrane
	is_turf = TRUE

/obj/effect/landmark/structure_spawner/setup/distress/xeno_door
	name = "Distress Xeno door spawner"
	icon_state = "door"
	path_to_spawn = /obj/structure/mineral_door/resin

/obj/effect/landmark/structure_spawner/setup/distress/xeno_nest
	name = "Distress Xeno nest spawner"
	icon_state = "nest"
	path_to_spawn = /obj/structure/bed/nest

/obj/effect/landmark/structure_spawner/setup/distress/xeno_weed_node
	name = "Distress Xeno weed node spawner"
	icon_state = "weednode"
	path_to_spawn = /obj/effect/alien/weeds/node

/obj/effect/landmark/structure_spawner/setup/distress/xeno_sticky
	name = "Distress Xeno sticky spawner"
	icon = 'icons/mob/xenos/effects.dmi'
	icon_state = "sticky"
	path_to_spawn = /obj/effect/alien/resin/sticky

/obj/effect/landmark/structure_spawner/setup/distress/xeno_wall_reinforced
	name = "Distress Xeno reinforced wall spawner"
	icon_state = "wall_r"
	path_to_spawn = /turf/closed/wall/resin/thick
	is_turf = TRUE

/obj/effect/landmark/structure_spawner/setup/distress/xeno_door_reinforced
	name = "Distress Xeno reinforced door spawner"
	icon_state = "door_r"
	path_to_spawn = /obj/structure/mineral_door/resin/thick
