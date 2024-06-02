/datum/tutorial/ss13/basic
	name = "Space Station 13 - Basic"
	desc = "Learn the very basics of Space Station 13. Recommended if you haven't played before."
	tutorial_id = "ss13_basic_1"
	tutorial_template = /datum/map_template/tutorial/s7x7

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
	message_to_player("Now, move in any direction using <b>[retrieve_bind("North")]</b>, <b>[retrieve_bind("West")]</b>, <b>[retrieve_bind("South")]</b>, or <b>[retrieve_bind("East")]</b>.")
	update_objective("Move in any direction using the [retrieve_bind("North")][retrieve_bind("West")][retrieve_bind("South")][retrieve_bind("East")] keys.")

	RegisterSignal(tutorial_mob, COMSIG_MOB_MOVE_OR_LOOK, PROC_REF(on_move))

/datum/tutorial/ss13/basic/proc/on_move(datum/source, actually_moving, direction, specific_direction)
	SIGNAL_HANDLER

	if(!actually_moving) // The mob just looked in a different dir instead of moving
		return

	UnregisterSignal(tutorial_mob, COMSIG_MOB_MOVE_OR_LOOK)

	message_to_player("Good. Now, switch hands with <b>[retrieve_bind("swap_hands")]</b>.")
	update_objective("Switch hands with [retrieve_bind("swap_hands")].")

	RegisterSignal(tutorial_mob, COMSIG_MOB_SWAPPED_HAND, PROC_REF(on_hand_swap))

/datum/tutorial/ss13/basic/proc/on_hand_swap(datum/source)
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_MOB_SWAPPED_HAND)

	message_to_player("Good. Now, pick up the <b>satchel</b> that just spawned and equip it with <b>[retrieve_bind("quick_equip")]</b>.")
	update_objective("Pick up the satchel and equip it with [retrieve_bind("quick_equip")].")

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
	message_to_player("Now, say anything by pressing <b>[retrieve_bind("Say")]</b>.")
	update_objective("Speak using [retrieve_bind("Say")].")

	RegisterSignal(tutorial_mob, COMSIG_LIVING_SPEAK, PROC_REF(on_speak))

/datum/tutorial/ss13/basic/proc/on_speak(datum/source)
	SIGNAL_HANDLER

	UnregisterSignal(tutorial_mob, COMSIG_LIVING_SPEAK)
	message_to_player("Excellent. The next tutorial will cover <b>intents</b>. The tutorial will end shortly.")
	update_objective("")
	tutorial_end_in(5 SECONDS, TRUE)

// END OF SCRIPTING
// START OF SCRIPT HELPERS



// END OF SCRIPT HELPERS

/datum/tutorial/ss13/basic/init_mob()
	. = ..()
	tutorial_mob.forceMove(loc_from_corner(2, 1))
