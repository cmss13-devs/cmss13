/// Survive Mode Global Setup Structure spawners
/obj/effect/landmark/structure_spawner/setup/survive
	name = "abstract survive mode spawner"
	mode_flags = MODE_SURVIVE

/obj/effect/landmark/structure_spawner/setup/survive/xeno_wall
	name = "Survive Xeno wall spawner"
	icon_state = "wall"
	path_to_spawn = /turf/closed/wall/resin
	is_turf = TRUE

/obj/effect/landmark/structure_spawner/setup/survive/xeno_membrane
	name = "Survive Xeno membrane spawner"
	icon_state = "membrane"
	path_to_spawn = /turf/closed/wall/resin/membrane
	is_turf = TRUE

/obj/effect/landmark/structure_spawner/setup/survive/xeno_door
	name = "Survive Xeno door spawner"
	icon_state = "door"
	path_to_spawn = /obj/structure/mineral_door/resin
	delay_apply = TRUE

/obj/effect/landmark/structure_spawner/setup/survive/xeno_nest
	name = "Survive Xeno nest spawner"
	icon_state = "nest"
	path_to_spawn = /obj/structure/bed/nest



/obj/effect/landmark/structure_spawner/setup/survive/xeno_weed_node
	name = "Survive Xeno weed node spawner"
	icon_state = "weednode"
	path_to_spawn = /obj/effect/alien/weeds/node

/obj/effect/landmark/structure_spawner/setup/survive/xeno_sticky
	name = "Survive Xeno sticky spawner"
	icon = 'icons/mob/xenos/effects.dmi'
	icon_state = "sticky"
	path_to_spawn = /obj/effect/alien/resin/sticky

/obj/effect/landmark/structure_spawner/setup/survive/xeno_wall_reinforced
	name = "Survive Xeno reinforced wall spawner"
	icon_state = "wall_r"
	path_to_spawn = /turf/closed/wall/resin/thick
	is_turf = TRUE

/obj/effect/landmark/structure_spawner/setup/survive/xeno_door_reinforced
	name = "Survive Xeno reinforced door spawner"
	icon_state = "door_r"
	path_to_spawn = /obj/structure/mineral_door/resin/thick
	delay_apply = TRUE


/obj/effect/landmark/structure_spawner/setup/survive/xeno_wall_hull
	name = "Survive Xeno hull wall spawner"
	icon_state = "wall_h"
	path_to_spawn = /turf/closed/wall/mineral/bone_resin
	is_turf = TRUE

/obj/effect/landmark/structure_spawner/setup/survive/xeno_door_hull
	name = "Survive Xeno hull door spawner"
	icon_state = "door_h"
	path_to_spawn = /obj/structure/mineral_door/resin/bone_resin
	delay_apply = TRUE

// K-Series

/obj/effect/landmark/structure_spawner/setup/survive/xeno_nest/kseries
	path_to_spawn = /obj/structure/bed/nest/kseries

/obj/effect/landmark/structure_spawner/setup/survive/xeno_wall/kseries
	path_to_spawn = /turf/closed/wall/resin/kseries
