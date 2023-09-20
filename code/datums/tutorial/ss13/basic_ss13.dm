/datum/tutorial/ss13/basic
	name = "Space Station 13 - Basic"
	tutorial_id = "ss13_basic_1"
	tutorial_template = /datum/map_template/tutorial/ss13_basic

// START OF SCRIPTING

/datum/tutorial/ss13/basic/start_tutorial(mob/starting_mob)
	. = ..()
	if(!.)
		return

	init_mob()
	message_to_player("This is the tutorial for the basics of <b>Space Station 13</b>. Any current instructions can be found in the top-right corner, in the status panel.")
	update_objective("Here's where it'll be!")

	addtimer(CALLBACK(src, PROC_REF(require_move)), 4 SECONDS) // check if this is a good amount of time

/datum/tutorial/ss13/basic/proc/require_move()
	message_to_player("Now, move in any direction using <b>W</b>, <b>A</b>, <b>S</b>, or <b>D</b>.")
	update_objective("Move in any direction using the standard WASD keys.")

	RegisterSignal(tutorial_mob, COMSIG_MOB_MOVE_OR_LOOK, PROC_REF(on_move))

/datum/tutorial/ss13/basic/proc/on_move(datum/source, actually_moving, direction, specific_direction)
	SIGNAL_HANDLER

	if(!actually_moving) // The mob just looked in a different dir instead of moving
		return

	UnregisterSignal(tutorial_mob, COMSIG_MOB_MOVE_OR_LOOK)

	message_to_player("Good. Now, switch hands with <b>X</b>.")
	update_objective("Switch hands with X.")

	RegisterSignal(tutorial_mob, COMSIG_MOB_SWAPPED_HAND, PROC_REF(on_hand_swap))

/datum/tutorial/ss13/basic/proc/on_hand_swap(datum/source)
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_MOB_SWAPPED_HAND)

	message_to_player("Good. Now, pick up the <b>satchel</b> that just spawned and equip it with <b>E</b>.")
	update_objective("Pick up the satchel and equip it with E.")

	var/obj/item/storage/backpack/marine/satchel/satchel = new(loc_from_corner(2, 2))
	add_to_tracking_atoms(satchel)
	add_highlight(satchel)

	RegisterSignal(tutorial_mob, COMSIG_HUMAN_EQUIPPED_ITEM, PROC_REF(on_satchel_equip))

/datum/tutorial/ss13/basic/proc/on_satchel_equip(datum/source, obj/item/equipped, slot)
	SIGNAL_HANDLER

	if(!istype(equipped, /obj/item/storage/backpack/marine/satchel) || (slot != WEAR_BACK))
		return

	UnregisterSignal(tutorial_mob, COMSIG_HUMAN_EQUIPPED_ITEM)
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/storage/backpack/marine/satchel, satchel)
	remove_highlight(satchel)
	message_to_player("Now, say anything by pressing <b>T</b>.")
	update_objective("Speak using T.")

	RegisterSignal(tutorial_mob, COMSIG_LIVING_SPEAK, PROC_REF(on_speak))

/datum/tutorial/ss13/basic/proc/on_speak(datum/source)
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_LIVING_SPEAK)
	message_to_player("Excellent. To finish the tutorial, enter the nearby cryopod by <b>dragging your sprite</b> to the outlined <b>cryopod</b>.")
	update_objective("Enter the cryopod by dragging your sprite to it.")

	var/obj/structure/machinery/cryopod/tutorial/end_pod = new(loc_from_corner(0, 0)) // ZONENOTE: come back to this when save files are done so I can make this end properly
	add_to_tracking_atoms(end_pod)
	add_highlight(end_pod)

// END OF SCRIPTING
// START OF SCRIPT HELPERS



// END OF SCRIPT HELPERS

/datum/tutorial/ss13/basic/init_mob()
	. = ..()
	tutorial_mob.forceMove(loc_from_corner(2, 1))
