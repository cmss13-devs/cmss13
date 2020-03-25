#define COLLECTOR_XENOCON_RATE 2

/obj/effect/alien/resin/collector
	name = "hive collector"
	icon = 'icons/mob/xenos/structures64x64.dmi'
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
	var/gather_cooldown = SECONDS_10

/obj/effect/alien/resin/collector/New(loc, var/hive_ref, var/new_node)
	..()
	if(hive_ref)
		linked_hive = hive_ref
		if(linked_hive.living_xeno_queen)
			var/area/current_area = get_area(src)
			xeno_message("Hive: \A [src] has been constructed at [sanitize(current_area)]!", 3, linked_hive.hivenumber)
	if(new_node)
		connected_node = new_node
		connected_node.update_icon()
	processing_objects.Add(src)
	update_icon()

/obj/effect/alien/resin/collector/Dispose()
	linked_hive = null
	if(connected_node)
		connected_node.update_icon()
	connected_node = null
	processing_objects.Remove(src)
	. = ..()


// /obj/effect/alien/resin/collector/examine(mob/user)
// 	..()
// 	if(isXeno(user) || isobserver(user))
// 		to_chat(user, "It has [connected_node.amount_left] resources left.")

/obj/effect/alien/resin/collector/process()
	if(!linked_hive || world.time < (last_gathered_time + gather_cooldown))
		return
	var/area/current_area = get_area(src)
	if(!connected_node)
		visible_message(SPAN_DANGER("\The [src] groans and collapses as its contents are reduced to nothing!"))
		if(linked_hive.living_xeno_queen)
			xeno_message("Hive: \A [src] has been depleted at [sanitize(current_area)]!", 3, linked_hive.hivenumber)
		qdel(src)
		return
	last_gathered_time = world.time
	linked_hive.crystal_stored += connected_node.gather_resource()
	linked_hive.xenocon_points += COLLECTOR_XENOCON_RATE
	flick("[icon_state]_gather", src)