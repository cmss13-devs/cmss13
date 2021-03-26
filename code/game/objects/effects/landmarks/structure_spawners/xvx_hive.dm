/// XvX Hive Spawn Structures, spawning alongside a queen in the same area
/obj/effect/landmark/structure_spawner/xvx_hive
	name = "abstract XvX hive spawner"
	mode_flags = MODE_XVX
	color = "#c9a9c2"

/obj/effect/landmark/structure_spawner/xvx_hive/xeno_wall
	name = "XvX Hive wall spawner"
	icon_state = "wall"
	path_to_spawn = /turf/closed/wall/resin
	is_turf = TRUE

/obj/effect/landmark/structure_spawner/xvx_hive/xeno_membrane
	name = "XvX Hive membrane spawner"
	icon_state = "membrane"
	path_to_spawn = /turf/closed/wall/resin/membrane
	is_turf = TRUE

/obj/effect/landmark/structure_spawner/xvx_hive/xeno_door
	name = "XvX Hive door spawner"
	icon_state = "door"
	path_to_spawn = /obj/structure/mineral_door/resin

/obj/effect/landmark/structure_spawner/xvx_hive/xeno_nest
	name = "XvX Hive nest spawner"
	icon_state = "nest"
	path_to_spawn = /obj/structure/bed/nest

/obj/effect/landmark/structure_spawner/xvx_hive/xeno_core
	name = "XvX Hive core spawner"
	icon_state = "core"
	path_to_spawn = /obj/effect/alien/resin/special/pylon/core

/obj/effect/landmark/structure_spawner/xvx_hive/xeno_pool
	name = "XvX Hive pool spawner"
	icon_state = "pool"
	path_to_spawn = /obj/effect/alien/resin/special/pool