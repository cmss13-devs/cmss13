#define COLLECTOR_XENOCON_RATE 1

/obj/effect/alien/resin/collector
	name = "hive collector"
	desc = "A disgusting mass of pulsating spores. It reeks of plasma."
	icon_state = "collector"
	pixel_x = -16
	pixel_y = -16
	health = 900
	density = FALSE
	unacidable = TRUE
	anchored = TRUE
	var/datum/hive_status/linked_hive
	var/obj/structure/resource_node/connected_node
	var/last_gathered_time
	var/gather_cooldown = 10 SECONDS

/obj/effect/alien/resin/collector/Initialize(mapload, hive_ref, new_node)
	. = ..()
	icon = get_icon_from_source(CONFIG_GET(string/alien_structures_64x64))
	if(hive_ref)
		linked_hive = hive_ref
		if(linked_hive.living_xeno_queen)
			var/current_area_name = get_area_name(src)
			xeno_message("Hive: \A [src] has been constructed at [sanitize(current_area_name)]!", 3, linked_hive.hivenumber)
	if(new_node)
		connected_node = new_node
		connected_node.update_icon()
	START_PROCESSING(SSobj, src)
	update_icon()

/obj/effect/alien/resin/collector/Destroy()
	linked_hive = null
	if(connected_node)
		connected_node.update_icon()
	connected_node = null
	STOP_PROCESSING(SSobj, src)
	. = ..()


// /obj/effect/alien/resin/collector/examine(mob/user)
// 	..()
// 	if(isXeno(user) || isobserver(user))
// 		to_chat(user, "It has [connected_node.amount_left] resources left.")

/obj/effect/alien/resin/collector/process()
	if(!linked_hive || world.time < (last_gathered_time + gather_cooldown))
		return
	var/current_area_name = get_area_name(src)
	if(!connected_node)
		visible_message(SPAN_DANGER("\The [src] groans and collapses as its contents are reduced to nothing!"))
		if(linked_hive.living_xeno_queen)
			xeno_message("Hive: \A [src] has been depleted at [sanitize(current_area_name)]!", 3, linked_hive.hivenumber)
		qdel(src)
		return
	last_gathered_time = world.time
	linked_hive.crystal_stored += connected_node.gather_resource()
	linked_hive.xenocon_points += COLLECTOR_XENOCON_RATE
	flick("[icon_state]_gather", src)
