GLOBAL_LIST_EMPTY_TYPED(ongoing_tutorials, /datum/tutorial)

/// A tutorial datum contains a set of instructions for a player tutorial, such as what to spawn, what's scripted to occur, and so on.
/datum/tutorial
	/// What the tutorial is called, is player facing
	var/name = "Base"
	/// Internal ID of the tutorial, kept for save files. Format is "tutorialtype_specifictutorial_number". So, the first basic xeno tutorial would be "xeno_basic_1", and the 2nd marine medical tutorial would be "marine_medical_2"
	var/tutorial_id = "base"
	/// A short 1-2 sentence description of the tutorial itself
	var/desc = ""
	/// What the tutorial's icon in the UI should look like
	var/icon_state = ""
	/// What category the tutorial should be under
	var/category = TUTORIAL_CATEGORY_BASE
	/// Ref to the bottom-left corner tile of the tutorial room
	var/turf/bottom_left_corner
	/// Ref to the turf reservation for this tutorial
	var/datum/turf_reservation/reservation
	/// Ref to the player who is doing the tutorial
	var/mob/tutorial_mob
	/// If the tutorial will be ending soon
	var/tutorial_ending = FALSE
	/// A dict of type:atom ref for some important junk that should be trackable
	var/list/tracking_atoms = list()
	/// What map template should be used for the tutorial
	var/datum/map_template/tutorial/tutorial_template = /datum/map_template/tutorial/s12x12
	/// What is the parent path of this, to exclude from the tutorial menu
	var/parent_path = /datum/tutorial
	/// A dictionary of "bind_name" : "keybind_button". The inverse of `key_bindings` on a client's prefs
	var/list/player_bind_dict = list()
	/// If the tutorial has been completed. This doesn't need to be modified if you call end_tutorial() with a param of TRUE
	var/completion_marked = FALSE
	/// The tutorial_id of what tutorial has to be completed before being able to do this tutorial
	var/required_tutorial
	var/suspended_objective_update
	var/template_safety_override = FALSE

/datum/tutorial/Destroy(force, ...)
	GLOB.ongoing_tutorials -= src
	QDEL_NULL(reservation) // Its Destroy() handles releasing reserved turfs

	tutorial_mob = null // We don't delete it because the turf reservation will typically clean it up

	QDEL_LIST_ASSOC_VAL(tracking_atoms)

	return ..()

/// The proc to begin doing everything related to the tutorial
/datum/tutorial/proc/start_tutorial(mob/starting_mob)
	SHOULD_CALL_PARENT(TRUE)

	if(!starting_mob?.client)
		return FALSE

	ADD_TRAIT(starting_mob, TRAIT_IN_TUTORIAL, TRAIT_SOURCE_TUTORIAL)

	tutorial_mob = starting_mob

	reservation = SSmapping.request_turf_block_reservation(initial(tutorial_template.width), initial(tutorial_template.height), 1)
	if(!reservation)
		abort_tutorial()
		return FALSE

	var/turf/bottom_left_corner_reservation = reservation.bottom_left_turfs[1]
	var/datum/map_template/tutorial/template = new tutorial_template
	template.load(bottom_left_corner_reservation, FALSE, TRUE)
	var/obj/landmark = locate(/obj/effect/landmark/tutorial_bottom_left) in GLOB.landmarks_list
	bottom_left_corner = get_turf(landmark)
	qdel(landmark)

	if(!verify_template_loaded())
		abort_tutorial()
		return FALSE

	generate_binds()

	GLOB.ongoing_tutorials |= src
	var/area/tutorial_area = get_area(bottom_left_corner)
	tutorial_area.update_base_lighting() // this will be entirely dark otherwise
	init_map()
	if(!tutorial_mob)
		end_tutorial()

	return TRUE

/// The proc used to end and clean up the tutorial
/datum/tutorial/proc/end_tutorial(completed = FALSE)
	SHOULD_CALL_PARENT(TRUE)

	deltimer(suspended_objective_update)

	var/mob/old_tutorial_mob = tutorial_mob
	if(old_tutorial_mob)
		tutorial_mob = null // Clear it out so we don't double end the tutorial on logout via transfer_to
		if(old_tutorial_mob.client)
			UnregisterSignal(old_tutorial_mob.client, list(COMSIG_CLIENT_SCREEN_ADD, COMSIG_CLIENT_SCREEN_REMOVE))
		remove_action(old_tutorial_mob, /datum/action/tutorial_end) // Just in case to make sure the client can't try and leave the tutorial while it's mid-cleanup
		if(old_tutorial_mob.client?.prefs && (completed || completion_marked))
			old_tutorial_mob.client.prefs.completed_tutorials |= tutorial_id
			old_tutorial_mob.client.prefs.save_preferences()
		var/mob/new_player/new_player = new
		if(!old_tutorial_mob.mind)
			old_tutorial_mob.mind_initialize()

		old_tutorial_mob.mind.transfer_to(new_player)

	if(!QDELETED(src))
		qdel(src)

/// Verify the template loaded fully and without error.
/datum/tutorial/proc/verify_template_loaded()
	if(template_safety_override)
		return TRUE
	// We subtract 1 from x and y because the bottom left corner doesn't start at the walls.
	var/turf/true_bottom_left_corner = reservation.bottom_left_turfs[1]
	for(var/turf/tile as anything in CORNER_BLOCK(true_bottom_left_corner, initial(tutorial_template.width), initial(tutorial_template.height)))
		// For some reason I'm unsure of, the template will not always fully load, leaving some tiles to be space tiles. So, we check all tiles in the (small) tutorial area
		// and tell start_tutorial to abort if there's any space tiles.
		if(istype(tile, /turf/open/space))
			return FALSE

	return TRUE

/// Something went very, very wrong during load so let's abort
/datum/tutorial/proc/abort_tutorial()
	to_chat(tutorial_mob, SPAN_BOLDWARNING("Something went wrong during tutorial load, please try again!"))
	end_tutorial(FALSE)

/datum/tutorial/proc/add_highlight(atom/target, color = "#d19a02")
	target.add_filter("tutorial_highlight", 2, list("type" = "outline", "color" = color, "size" = 1))

/datum/tutorial/proc/remove_highlight(atom/target)
	target.remove_filter("tutorial_highlight")

/datum/tutorial/proc/add_to_tracking_atoms(atom/reference)
	tracking_atoms[reference.type] = reference

/datum/tutorial/proc/remove_from_tracking_atoms(atom/reference)
	tracking_atoms -= reference.type

/// Broadcast a message to the player's screen
/datum/tutorial/proc/message_to_player(message, message_type = /atom/movable/screen/text/screen_text/command_order/tutorial)
	playsound_client(tutorial_mob.client, 'sound/effects/radiostatic.ogg', tutorial_mob.loc, 25, FALSE)
	tutorial_mob.play_screen_text(message, message_type, rgb(103, 214, 146))
	to_chat(tutorial_mob, SPAN_NOTICE(message))

/// Broadcast a message to the player's screen
/datum/tutorial/proc/dynamic_message_to_player(list/script)
	var/final_fade_out_delay
	var/scene_length = 0 SECONDS
	for(var/message in script)
		var/aproximate_word_count = 0
		for(var/character in 1 to length_char(message))
			// ASCII 32 = spacebar thing
			if(text2ascii(message, character) == 32)
				aproximate_word_count++
			character++

		if(!aproximate_word_count)
			return FALSE

		var/atom/movable/screen/text/screen_text/message_atom = new /atom/movable/screen/text/screen_text/command_order/tutorial
		final_fade_out_delay = message_atom.fade_out_time
		var/message_reading_time = max(round(aproximate_word_count * 0.4, 0.1), 1.5) SECONDS
		message_atom.fade_out_delay = message_reading_time
		message_reading_time += message_atom.fade_out_time
		if(!scene_length)
			message_to_player(message, message_atom)
		else
			addtimer(CALLBACK(src, PROC_REF(message_to_player), message, message_atom), scene_length)
		scene_length += message_reading_time

	return scene_length + final_fade_out_delay

/// Updates a player's objective in their status tab
/datum/tutorial/proc/update_objective(message, shown_onscreen = TRUE)
	SEND_SIGNAL(tutorial_mob, COMSIG_MOB_TUTORIAL_UPDATE_OBJECTIVE, message)
	var/datum/hud/tutorial_hud = tutorial_mob.hud_used
	if(!shown_onscreen)
		return
	if(length(tutorial_hud.tutorial_objective.maptext))
		animate(tutorial_hud.tutorial_objective, alpha = 0, time = 0.5 SECONDS)
		addtimer(CALLBACK(src, PROC_REF(handle_onscreen_objective), message, tutorial_hud), 0.6 SECONDS)
	else
		handle_onscreen_objective(message, tutorial_hud)

/datum/tutorial/proc/handle_onscreen_objective(message, datum/hud/tutorial_hud)
	if(suspended_objective_update)
		deltimer(suspended_objective_update)
	if(!tutorial_mob.client)
		return
	if(tutorial_mob.client.screen_texts)
		suspended_objective_update = addtimer(CALLBACK(src, PROC_REF(handle_onscreen_objective), message, tutorial_hud), 2.5 SECONDS, TIMER_STOPPABLE)
		return
	tutorial_hud.tutorial_objective.maptext = ""
	tutorial_hud.tutorial_objective.alpha = 255
	update_onscreen_objective_position()
	INVOKE_ASYNC(tutorial_hud.tutorial_objective, TYPE_PROC_REF(/atom/movable/screen/screentip/tutorial, update_onscreen_objective), message, tutorial_hud)

/datum/tutorial/proc/update_onscreen_objective_position()
	var/atom/movable/screen/action_button/hide_button = tutorial_mob.hud_used.hide_actions_toggle
	var/atom/movable/screen/screentip/tutorial/tutorial_objective = tutorial_mob.hud_used.tutorial_objective
	tutorial_objective.screen_loc = hide_button.get_button_screen_loc(length(tutorial_mob.actions) + 2)
	tutorial_objective.maptext_width = tutorial_objective.maptext_width - tutorial_objective.maptext_x - 8	// slight padding on the right
	if(tutorial_objective.maptext_width <= 240)	// smaller than half the screen, move it down a line instead
		tutorial_objective.screen_loc = initial(tutorial_objective.screen_loc)

/atom/movable/screen/screentip/tutorial/proc/update_onscreen_objective(message, datum/hud/tutorial_hud, list/style_override)

	var/name_part = "<span class='langchat langchat_yell'>Current Objective:</span><br>"

	var/list/lines_to_skip = list()
	var/static/html_locate_regex = regex("<.*>")
	var/tag_position = findtext(message, html_locate_regex)
	var/reading_tag = TRUE
	while(tag_position)
		if(reading_tag)
			if(message[tag_position] == ">")
				reading_tag = FALSE
			lines_to_skip += tag_position
			tag_position++
		else
			tag_position = findtext(message, html_locate_regex, tag_position)
			reading_tag = TRUE

	var/message_length = length(message)
	var/letters_per_update = 2

	for(var/letter = 2 to message_length + letters_per_update step letters_per_update)
		if(letter in lines_to_skip)
			continue
		tutorial_hud.tutorial_objective.maptext = "[name_part]<span class='langchat' style='font-size: 7px;'>[copytext_char(message, 1, letter)]</span>"
		sleep(0.5)

/// Initialize the tutorial mob.
/datum/tutorial/proc/init_mob()
	tutorial_mob.AddComponent(/datum/component/tutorial_status)
	RegisterSignal(tutorial_mob.client, list(COMSIG_CLIENT_SCREEN_ADD, COMSIG_CLIENT_SCREEN_REMOVE), PROC_REF(update_onscreen_objective_position))
	give_action(tutorial_mob, /datum/action/tutorial_end, null, null, src)
	ADD_TRAIT(tutorial_mob, TRAIT_IN_TUTORIAL, TRAIT_SOURCE_TUTORIAL)

/// Ends the tutorial after a certain amount of time.
/datum/tutorial/proc/tutorial_end_in(time = 5 SECONDS, completed = TRUE)
	if(completed)
		mark_completed() // This is done because if you're calling this proc with completed == TRUE, then the tutorial's a done deal. We shouldn't penalize the player if they exit a few seconds before it actually completes.
	tutorial_ending = TRUE
	addtimer(CALLBACK(src, PROC_REF(end_tutorial), completed), time)

/// Initialize any objects that need to be in the tutorial area from the beginning.
/datum/tutorial/proc/init_map()
	return

/datum/tutorial/proc/init_tracking_markers()
	var/area/misc/tutorial/tutorial_area = get_area(bottom_left_corner)
	var/list/tracking_markers = tutorial_area.atom_tracking_landmarks.Copy()

	if(!length(tracking_markers))
		return

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

/// Returns a turf offset by offset_x (left-to-right) and offset_y (up-to-down)
/datum/tutorial/proc/loc_from_corner(offset_x = 0, offset_y = 0)
	RETURN_TYPE(/turf)
	return locate(bottom_left_corner.x + offset_x, bottom_left_corner.y + offset_y, bottom_left_corner.z)

/// Handle the player ghosting out
/datum/tutorial/proc/on_ghost(datum/source, mob/dead/observer/ghost)
	SIGNAL_HANDLER

	var/mob/new_player/new_player = new
	if(!ghost.mind)
		ghost.mind_initialize()

	ghost.mind.transfer_to(new_player)

	end_tutorial(FALSE)

/// A wrapper for signals to call end_tutorial()
/datum/tutorial/proc/signal_end_tutorial(datum/source)
	SIGNAL_HANDLER

	end_tutorial(FALSE)

/// Called whenever the tutorial_mob logs out
/datum/tutorial/proc/on_logout(datum/source)
	SIGNAL_HANDLER

	if(!tutorial_mob || tutorial_mob.aghosted)
		return

	end_tutorial(FALSE)

/// Generate a dictionary of button : action for use of referencing what keys to press
/datum/tutorial/proc/generate_binds()
	if(!tutorial_mob.client?.prefs)
		return

	for(var/bind in tutorial_mob.client.prefs.key_bindings)
		var/action = tutorial_mob.client.prefs.key_bindings[bind]
		// We presume the first action under a certain binding is the one we want.
		if(action[1] in player_bind_dict)
			player_bind_dict[action[1]] += bind
		else
			player_bind_dict[action[1]] = list(bind)

/// Getter for player_bind_dict. Provide an action name like "North" or "quick_equip"
/datum/tutorial/proc/retrieve_bind(action_name)
	if(!action_name)
		return

	if(!(action_name in player_bind_dict))
		return "Undefined"

	return player_bind_dict[action_name][1]

/// When called, will make anything that ends the tutorial mark it as completed. Does not need to be called if end_tutorial(TRUE) is called instead
/datum/tutorial/proc/mark_completed()
	completion_marked = TRUE

/datum/action/tutorial_end
	name = "Stop Tutorial"
	action_icon_state = "hologram_exit"
	/// Weakref to the tutorial this is related to
	var/datum/weakref/tutorial

/datum/action/tutorial_end/New(Target, override_icon_state, datum/tutorial/selected_tutorial)
	. = ..()
	tutorial = WEAKREF(selected_tutorial)

/datum/action/tutorial_end/action_activate()
	. = ..()
	if(!tutorial)
		return

	var/datum/tutorial/selected_tutorial = tutorial.resolve()
	if(selected_tutorial.tutorial_ending)
		return

	selected_tutorial.end_tutorial()


/datum/map_template/tutorial
	name = "Tutorial Zone (12x12)"
	mappath = "maps/tutorial/tutorial_12x12.dmm"
	width = 12
	height = 12

/datum/map_template/tutorial/s12x12

/datum/map_template/tutorial/s8x9
	name = "Tutorial Zone (8x9)"
	mappath = "maps/tutorial/tutorial_8x9.dmm"
	width = 8
	height = 9

/datum/map_template/tutorial/s8x9/no_baselight
	name = "Tutorial Zone (8x9) (No Baselight)"
	mappath = "maps/tutorial/tutorial_8x9_nb.dmm"

/datum/map_template/tutorial/s7x7
	name = "Tutorial Zone (7x7)"
	mappath = "maps/tutorial/tutorial_7x7.dmm"
	width = 7
	height = 7

/datum/map_template/tutorial/s11x7
	name = "Tutorial Zone (11x7)"
	mappath = "maps/tutorial/tutorial_11x7.dmm"
	width = 11
	height = 7

/datum/map_template/tutorial/s15x10/hm
	name = "Tutorial Zone (15x10) (HM Tutorial)"
	mappath = "maps/tutorial/tutorial_15x10_hm.dmm"
	width = 15
	height = 10

/datum/map_template/tutorial/debug
	name = "Tutorial Zone (8x8) (debug)"
	mappath = "maps/tutorial/tutorial_test.dmm"
	width = 8
	height = 8
