/datum/tutorial/marine/example
	name = "Example Tutorial"
	tutorial_id = "example" // This won't show up in the list, so this'll be irrelevant anyway.
	category = TUTORIAL_CATEGORY_BASE
	parent_path = /datum/tutorial/marine/example

// START OF SCRIPTING

/datum/tutorial/marine/example/start_tutorial(mob/starting_mob)
	// Here, we're calling parent and checking its return value. If it has a falsey one (as done by !.), then something went wrong and we should abort
	// There isn't really a reason that you _shouldn't_ have this
	. = ..()
	if(!.)
		return

	// Init_mob() isn't called by default, so we call it here
	init_mob()
	// As is standard, we give a message to the player and update their status panel with what we want done.
	message_to_player("This is an example tutorial. Perform any emote to continue.")
	update_objective("Do any emote.")
	// This makes the player (tutorial_mob) listen for the COMSIG_MOB_EMOTE event, which will then call on_emote() when it hears it.
	RegisterSignal(tutorial_mob, COMSIG_MOB_EMOTE, PROC_REF(on_emote))

/datum/tutorial/marine/example/proc/on_emote(datum/source)
	// With any proc called via signal (see the RegisterSignal line above for details), we add SIGNAL_HANDLER to it.
	SIGNAL_HANDLER

	// Now that we've gotten the signal and started the script, we want to immediately stop listening for it.
	UnregisterSignal(tutorial_mob, COMSIG_MOB_EMOTE)
	message_to_player("Good. Now, pick up that can of <b>Weyland-Yutani Aspen Beer</b>.")
	update_objective("Pick up that can.")
	// This macro takes a specific type path (the same used in init_map()) and a variable name to retrieve an object from the tracked object list
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/food/drinks/cans/aspen, beer_can)
	// Now we're adding a yellow highlight around the can to make sure people know what we're talking about
	add_highlight(beer_can)
	// Now, we always prefer to register signals on the tutorial_mob (as opposed to the beer_can) whenever possible
	RegisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM, PROC_REF(on_can_pickup))

/// We get these arguments from the signal's definition. If you have VSC, ctrl+click on COMSIG_MOB_PICKUP_ITEM above. When dealing with a signal proc, `datum/source` is always the first argument, then any added ones
/datum/tutorial/marine/example/proc/on_can_pickup(datum/source, obj/item/picked_up)
	SIGNAL_HANDLER

	// Since we're just listening for the mob picking anything up, we want to confirm that the picked up item is the can before continuing. If it's not, then we return and keep listening.
	if(!istype(picked_up, /obj/item/reagent_container/food/drinks/cans/aspen))
		// If we hit this return here, then the picked up item wasn't the can, so we abort and keep listening.
		return

	// Since we passed the above if statement, stop listening for item pickups.
	UnregisterSignal(tutorial_mob, COMSIG_MOB_PICKUP_ITEM)
	// Let's get the tracked beer can again.
	TUTORIAL_ATOM_FROM_TRACKING(/obj/item/reagent_container/food/drinks/cans/aspen, beer_can)
	// And remove the highlight now that it's picked up
	remove_highlight(beer_can)
	message_to_player("Very good. This is the end of the example tutorial. You will be sent back to the lobby screen momentarily.")
	// 7.5 seconds after the above message is sent, kick the player out and end the tutorial.
	tutorial_end_in(7.5 SECONDS, TRUE)


// END OF SCRIPTING
// START OF SCRIPT HELPERS

// END OF SCRIPT HELPERS

/datum/tutorial/marine/example/init_mob()
	. = ..()
	// We give the tutorial mob a basic ID so they can use general vendors and etc. This is here because not all marine tutorials may want to use a naked equipment preset.
	arm_equipment(tutorial_mob, /datum/equipment_preset/tutorial)


/datum/tutorial/marine/example/init_map()
	// Here we're initializing a new can that we want to track, so we spawn it 2 tiles to the left and up from the bottom left corner of the tutorial zone
	var/obj/item/reagent_container/food/drinks/cans/aspen/the_can = new(loc_from_corner(2, 2))
	// Now we start tracking it
	add_to_tracking_atoms(the_can)
