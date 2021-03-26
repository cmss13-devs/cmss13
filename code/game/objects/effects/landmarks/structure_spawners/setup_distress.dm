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