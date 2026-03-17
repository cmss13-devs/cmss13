/datum/tutorial/ss13/debug
	name = "Debug"
	desc = "..."
	tutorial_id = "ss13_basic_0"
	tutorial_template = /datum/map_template/tutorial/debug

// START OF SCRIPTING

/datum/tutorial/ss13/debug/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	init_mob()
	message_to_player("This is the tutorial for the basics of <b>Space Station 13</b>. Any current instructions can be found in the top-right corner, in the status panel.")
	update_objective("Here's where it'll be!")

	addtimer(CALLBACK(src, PROC_REF(lightup)), 2 SECONDS) // check if this is a good amount of time

/datum/tutorial/ss13/debug/proc/lightup()
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/device/reagent_scanner/adv/objective, radio)
	add_highlight(radio, COLOR_RED)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/surface/table/almayer, table)
	add_highlight(table, COLOR_BLUE)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/structure/machinery/door/airlock/almayer/engineering, door)
	add_highlight(door, COLOR_GREEN)

/datum/tutorial/ss13/debug/init_map()
	var/area/misc/tutorial/tutorial_area = get_area(bottom_left_corner)
	var/list/tracking_markers = tutorial_area.atom_tracking_landmarks.Copy()

	for(var/obj/effect/landmark/tutorial_tracking_marker/tracker in tracking_markers)
		if(!tracker.tracking_target_type)
			tracking_markers -= tracker
			continue
		var/atom/tracking_atom
		if(istype(get_turf(tracker), tracker.tracking_target_type))
			tracking_atom = get_turf(tracker)
		else
			tracking_atom = locate(tracker.tracking_target_type) in tracker.loc
		if(!tracking_atom)
			qdel(tracker)
			continue
		add_to_tracking_atoms(tracking_atom)

/datum/tutorial/ss13/debug/Destroy(force)
	var/area/misc/tutorial/tutorial_area = get_area(bottom_left_corner)
	var/list/tracking_markers = tutorial_area.atom_tracking_landmarks
	QDEL_LIST(tracking_markers)
	return ..()

/datum/tutorial/ss13/debug/init_mob()
	. = ..()
	tutorial_mob.forceMove(loc_from_corner(2, 1))
