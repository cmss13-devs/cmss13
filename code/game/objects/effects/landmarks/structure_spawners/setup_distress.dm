#define OVERRIDE_AND_DELETE "DELETE"
/// Distress Signal Global Setup Structure spawners
/obj/effect/landmark/structure_spawner/setup/distress
	name = "abstract distress spawner"
	mode_flags = MODE_INFESTATION
	var/pathogen_path = OVERRIDE_AND_DELETE

/obj/effect/landmark/structure_spawner/setup/distress/set_pathogen_spawns()
	if(pathogen_path == OVERRIDE_AND_DELETE)
		qdel(src)
		return
	if(pathogen_path)
		path_to_spawn = pathogen_path

/obj/effect/landmark/structure_spawner/setup/distress/xeno_wall
	name = "Distress Xeno wall spawner"
	icon_state = "wall"
	path_to_spawn = /turf/closed/wall/resin
	pathogen_path = /turf/closed/wall/resin/pathogen
	is_turf = TRUE

/obj/effect/landmark/structure_spawner/setup/distress/xeno_membrane
	name = "Distress Xeno membrane spawner"
	icon_state = "membrane"
	path_to_spawn = /turf/closed/wall/resin/membrane
	pathogen_path = /turf/closed/wall/resin/membrane/pathogen
	is_turf = TRUE

/obj/effect/landmark/structure_spawner/setup/distress/xeno_door
	name = "Distress Xeno door spawner"
	icon_state = "door"
	path_to_spawn = /obj/structure/mineral_door/resin
	pathogen_path = /obj/structure/mineral_door/resin/pathogen

/obj/effect/landmark/structure_spawner/setup/distress/xeno_nest
	name = "Distress Xeno nest spawner"
	icon_state = "nest"
	path_to_spawn = /obj/structure/bed/nest
	pathogen_path = /obj/structure/bed/nest/pathogen



/obj/effect/landmark/structure_spawner/setup/distress/xeno_weed_node
	name = "Distress Xeno weed node spawner"
	icon_state = "weednode"
	path_to_spawn = /obj/effect/alien/weeds/node
	pathogen_path = /obj/effect/alien/weeds/node/pathogen

/obj/effect/landmark/structure_spawner/setup/distress/xeno_sticky
	name = "Distress Xeno sticky spawner"
	icon = 'icons/mob/xenos/effects.dmi'
	icon_state = "sticky"
	path_to_spawn = /obj/effect/alien/resin/sticky
	pathogen_path = OVERRIDE_AND_DELETE

/obj/effect/landmark/structure_spawner/setup/distress/xeno_wall_reinforced
	name = "Distress Xeno reinforced wall spawner"
	icon_state = "wall_r"
	path_to_spawn = /turf/closed/wall/resin/thick
	pathogen_path = /turf/closed/wall/resin/thick/pathogen
	is_turf = TRUE

/obj/effect/landmark/structure_spawner/setup/distress/xeno_door_reinforced
	name = "Distress Xeno reinforced door spawner"
	icon_state = "door_r"
	path_to_spawn = /obj/structure/mineral_door/resin/thick
	pathogen_path = /obj/structure/mineral_door/resin/pathogen/thick

// K-Series

/obj/effect/landmark/structure_spawner/setup/distress/xeno_nest/kseries
	path_to_spawn = /obj/structure/bed/nest/kseries

/obj/effect/landmark/structure_spawner/setup/distress/xeno_wall/kseries
	path_to_spawn = /turf/closed/wall/resin/kseries

#undef OVERRIDE_AND_DELETE
