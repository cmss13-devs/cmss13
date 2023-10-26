/// Distress Signal Global Setup Structure spawners
/obj/effect/landmark/structure_spawner/setup/distress
	name = "abstract distress spawner"
	mode_flags = MODE_INFESTATION

/obj/effect/landmark/structure_spawner/setup/distress/xeno
	name = "abstract distress Xeno effects spawner"
	var/hive_faction = XENO_HIVE_NORMAL

///Sets the new item to the correct xeno faction
/obj/effect/landmark/structure_spawner/setup/distress/xeno/proc/set_hive_faction(atom/xeno_item)
	set_hive_data(xeno_item, hive_faction)

/obj/effect/landmark/structure_spawner/setup/distress/xeno/apply(atom/target_location)
	var/atom/xeno_item = ..()
	if(!istypestrict(xeno_item, path_to_spawn))
		return
	set_hive_faction(xeno_item)

/obj/effect/landmark/structure_spawner/setup/distress/xeno/wall
	name = "Distress Xeno wall spawner"
	icon_state = "wall"
	path_to_spawn = /turf/closed/wall/resin
	is_turf = TRUE

/obj/effect/landmark/structure_spawner/setup/distress/xeno/wall/set_hive_faction(turf/closed/wall/resin/resin_wall)
	. = ..()
	resin_wall.hivenumber = hive_faction

/obj/effect/landmark/structure_spawner/setup/distress/xeno/wall/thick
	name = "Distress Xeno thick wall spawner"
	path_to_spawn = /turf/closed/wall/resin/thick

/obj/effect/landmark/structure_spawner/setup/distress/xeno/membrane
	name = "Distress Xeno membrane spawner"
	icon_state = "membrane"
	path_to_spawn = /turf/closed/wall/resin/membrane
	is_turf = TRUE

/obj/effect/landmark/structure_spawner/setup/distress/xeno/membrane/set_hive_faction(turf/closed/wall/resin/membrane/resin_membrane)
	. = ..()
	resin_membrane.hivenumber = hive_faction

/obj/effect/landmark/structure_spawner/setup/distress/xeno/membrane/thick
	name = "Distress Xeno thick membrane spawner"
	path_to_spawn = /turf/closed/wall/resin/membrane/thick

/obj/effect/landmark/structure_spawner/setup/distress/xeno/door
	name = "Distress Xeno door spawner"
	icon_state = "door"
	path_to_spawn = /obj/structure/mineral_door/resin

/obj/effect/landmark/structure_spawner/setup/distress/xeno/door/set_hive_faction(obj/structure/mineral_door/resin/resin_door)
	. = ..()
	resin_door.hivenumber = hive_faction

/obj/effect/landmark/structure_spawner/setup/distress/xeno/door/thick
	name = "Distress Xeno thick door spawner"
	path_to_spawn = /obj/structure/mineral_door/resin/thick

/obj/effect/landmark/structure_spawner/setup/distress/xeno/weed_node
	name = "Distress Xeno weed node spawner"
	icon_state = "weednode"
	path_to_spawn = /obj/effect/alien/weeds/node
	///The minimum is_weedable required for the weeds to be planted normally
	var/weed_strength_required = FULLY_WEEDABLE

/obj/effect/landmark/structure_spawner/setup/distress/xeno/weed_node/set_hive_faction(obj/effect/alien/weeds/node/weed_node)
	. = ..()
	weed_node.hivenumber = hive_faction
	weed_node.linked_hive = GLOB.hive_datum[hive_faction]

/obj/effect/landmark/structure_spawner/setup/distress/xeno/weed_node/Initialize(mapload, ...)
	. = ..()
	if(!is_admin_level(z) && !is_ground_level(z) && !is_mainship_level(z) && !is_reserved_level(z)) //Is it a real area? for the create and destroy unit tests
		return
	var/turf/node_tile = loc
	if(node_tile.is_weedable() >= weed_strength_required)
		return
	CRASH("[src] at [x],[y],[z] is on a turf where weeds cannot normally grow.")

/obj/effect/landmark/structure_spawner/setup/distress/xeno/weed_node/hardy
	name = "Distress Xeno hardy node spawner"
	path_to_spawn = /obj/effect/alien/weeds/node/hardy
	weed_strength_required = SEMI_WEEDABLE

/obj/effect/landmark/structure_spawner/setup/distress/xeno/tunnel
	name = "Distress Xeno tunnel spawner"
	icon_state = "xeno_tunnel"
	path_to_spawn = /obj/structure/tunnel

/obj/effect/landmark/structure_spawner/setup/distress/xeno/tunnel/set_hive_faction(obj/structure/tunnel/tunnel)
	. = ..()
	tunnel.hivenumber = hive_faction

/obj/effect/landmark/structure_spawner/setup/distress/xeno/tunnel/Initialize(mapload, ...)
	. = ..()
	if(!is_admin_level(z) && !is_ground_level(z) && !is_mainship_level(z) && !is_reserved_level(z)) //Is it a real area? for the create and destroy unit tests
		return
	var/turf/tunnel_tile = loc
	if(tunnel_tile.can_dig_xeno_tunnel())
		return
	CRASH("[src] at [x],[y],[z] is on a turf where tunnels cannot normally be built.")

/obj/effect/landmark/structure_spawner/setup/distress/xeno/tunnel/maintenance
	name = "Distress Xeno maintenance tunnel spawner"
	path_to_spawn = /obj/structure/tunnel/maint_tunnel
