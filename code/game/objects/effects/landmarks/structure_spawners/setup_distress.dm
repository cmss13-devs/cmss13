/// Distress Signal Global Setup Structure spawners
/obj/effect/landmark/structure_spawner/setup/distress
	name = "abstract distress spawner"
	mode_flags = MODE_INFESTATION

/obj/effect/landmark/structure_spawner/setup/distress/xeno_wall
	name = "Distress Xeno wall spawner"
	icon_state = "wall"
	path_to_spawn = /turf/closed/wall/resin
	is_turf = TRUE

/obj/effect/landmark/structure_spawner/setup/distress/xeno_wall/thick
	name = "Distress Xeno thick wall spawner"
	path_to_spawn = /turf/closed/wall/resin/thick

/obj/effect/landmark/structure_spawner/setup/distress/xeno_membrane
	name = "Distress Xeno membrane spawner"
	icon_state = "membrane"
	path_to_spawn = /turf/closed/wall/resin/membrane
	is_turf = TRUE

/obj/effect/landmark/structure_spawner/setup/distress/xeno_membrane/thick
	name = "Distress Xeno thick membrane spawner"
	path_to_spawn = /turf/closed/wall/resin/membrane/thick

/obj/effect/landmark/structure_spawner/setup/distress/xeno_door
	name = "Distress Xeno door spawner"
	icon_state = "door"
	path_to_spawn = /obj/structure/mineral_door/resin

/obj/effect/landmark/structure_spawner/setup/distress/xeno_door/thick
	name = "Distress Xeno thick door spawner"
	path_to_spawn = /obj/structure/mineral_door/resin/thick

/obj/effect/landmark/structure_spawner/setup/distress/xeno_weed_node
	name = "Distress Xeno weed node spawner"
	icon_state = "weednode"
	path_to_spawn = /obj/effect/alien/weeds/node
	///The minimum is_weedable required for the weeds to be planted normally
	var/weed_strength_required = FULLY_WEEDABLE

/obj/effect/landmark/structure_spawner/setup/distress/xeno_weed_node/Initialize(mapload, ...)
	. = ..()
	var/turf/node_tile = loc
	if(!is_ground_level(z) && node_tile.is_weedable() < weed_strength_required)
		stack_trace("[src] at [x],[y],[z] is on a turf where weeds cannot normally grow.")

/obj/effect/landmark/structure_spawner/setup/distress/xeno_weed_node/hardy
	name = "Distress Xeno hardy node spawner"
	path_to_spawn = /obj/effect/alien/weeds/node/hardy
	weed_strength_required = SEMI_WEEDABLE

/obj/effect/landmark/structure_spawner/setup/distress/tunnel
	name = "Distress Xeno tunnel spawner"
	icon_state = "xeno_tunnel"
	path_to_spawn = /obj/structure/tunnel

/obj/effect/landmark/structure_spawner/setup/distress/tunnel/Initialize(mapload, ...)
	. = ..()
	var/turf/tunnel_tile = loc
	if(!is_ground_level(z) && !tunnel_tile.can_dig_xeno_tunnel())
		stack_trace("[src] at [x],[y],[z] is on a turf where tunnels cannot normally be built.")

/obj/effect/landmark/structure_spawner/setup/distress/tunnel/maintenance
	name = "Distress Xeno maintenance tunnel spawner"
	path_to_spawn = /obj/structure/tunnel/maint_tunnel
