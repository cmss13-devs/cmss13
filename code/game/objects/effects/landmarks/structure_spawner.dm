/obj/effect/landmark/structure_spawner
	name = "structure spawner"
	icon_state = "x2"
	var/path_to_spawn

/obj/effect/landmark/structure_spawner/xenos/Initialize(mapload, ...)
	. = ..()

/obj/effect/landmark/structure_spawner/xenos/wall
	name = "xeno wall spawner"
	icon_state = "wall"
	path_to_spawn = /turf/closed/wall/resin

/obj/effect/landmark/structure_spawner/xenos/door
	name = "xeno door spawner"
	icon_state = "door"
	path_to_spawn = /obj/structure/mineral_door/resin

/obj/effect/landmark/structure_spawner/xenos/nest
	name = "xeno nest spawner"
	icon_state = "nest"
	path_to_spawn = /obj/structure/bed/nest

/obj/effect/landmark/structure_spawner/xenos/core
	name = "xeno core spawner"
	icon_state = "core"
	path_to_spawn = /obj/effect/alien/resin/special/pylon/core

/obj/effect/landmark/structure_spawner/xenos/pool
	name = "xeno pool spawner"
	icon_state = "pool"
	path_to_spawn = /obj/effect/alien/resin/special/pool