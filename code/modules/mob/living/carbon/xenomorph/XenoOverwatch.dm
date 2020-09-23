// File that holds everything related to Xeno overwatch.
// The action for watching another Xeno (Queen still has some shitty leftovers, but it's mostly been cleaned out)
/datum/action/xeno_action/watch_xeno
	name = "Watch Xenomorph"
	action_icon_state = "watch_xeno"
	plasma_cost = 0
	macro_path = /datum/action/xeno_action/verb/verb_watch_xeno

/datum/action/xeno_action/watch_xeno/can_use_action()
	var/mob/living/carbon/Xenomorph/X = owner
	if (X.is_mob_incapacitated() || X.buckled)
		return FALSE
	else
		return TRUE

/datum/action/xeno_action/watch_xeno/action_activate()
	var/mob/living/carbon/Xenomorph/X = owner
	if (!X.check_state(1))
		return FALSE

	var/isQueen = FALSE
	if (X.caste_name == "Queen")
		isQueen = TRUE

	if(!X.hive.living_xeno_queen && !X.hive.allow_no_queen_actions)
		to_chat(X, SPAN_WARNING("There is no Queen. You are alone."))
		return

	// We are already overwatching something
	if (X.observed_xeno)
		if (isQueen)
			var/mob/living/carbon/Xenomorph/oldXeno = X.observed_xeno
			X.overwatch(X.observed_xeno, TRUE)
			if (oldXeno)
				oldXeno.hud_set_queen_overwatch()
		else
			X.overwatch(X.observed_xeno, TRUE)
		return

	var/list/possible_xenos = list()
	for(var/mob/living/carbon/Xenomorph/T in living_mob_list)
		if (T != X && T.z != ADMIN_Z_LEVEL && X.hivenumber == T.hivenumber) // Can't overwatch yourself, Xenos in Thunderdome, or Xenos in other hives
			possible_xenos += T

	var/mob/living/carbon/Xenomorph/selected_xeno = input(X, "Target", "Watch which xenomorph?") as null|anything in possible_xenos

	if (!selected_xeno || selected_xeno.disposed || selected_xeno == X.observed_xeno || selected_xeno.stat == DEAD || selected_xeno.z == ADMIN_Z_LEVEL || !X.check_state(1))
		X.overwatch(X.observed_xeno, TRUE) // Cancel OW
	else if (!isQueen) // Regular Xeno OW vs Queen
		X.overwatch(selected_xeno)
	else // We are a queen
		var/mob/living/carbon/Xenomorph/oldXeno = X.observed_xeno
		X.overwatch(selected_xeno, FALSE, /datum/event_handler/xeno_overwatch_onmovement/queen)
		if (oldXeno)
			oldXeno.hud_set_queen_overwatch()
	
	if (selected_xeno && !selected_xeno.disposed)
		selected_xeno.hud_set_queen_overwatch()

// Generic Xeno overwatch proc, very simple for now. If you want it to cancel the overwatch, hand in TRUE in the second var.
// Third var is only for custom event handlers for OW hud indicators, currently only used for the Queen icon
// If you use it, be sure to manually specify the second var, even if its the default value.
/mob/living/carbon/Xenomorph/proc/overwatch(mob/living/carbon/Xenomorph/targetXeno, stop_overwatch = FALSE, movement_event_handler = /datum/event_handler/xeno_overwatch_onmovement)

	if (stop_overwatch)
		if (observed_xeno)
			to_chat(src, SPAN_XENOWARNING("You stop watching [observed_xeno]."))
		observed_xeno = null

	else
		if(!hive)
			return

		if(!hive.living_xeno_queen && !hive.allow_no_queen_actions)
			to_chat(src, SPAN_WARNING("There is no Queen. You are alone."))
			return

		if (targetXeno == src)
			to_chat(src, SPAN_XENOWARNING("You can't watch yourself!"))
			return

		if(targetXeno.interference)
			to_chat(src, SPAN_XENOWARNING("Your target's psychic connection is cut off!"))
			return

		if (observed_xeno && targetXeno && observed_xeno == targetXeno)
			to_chat(src, SPAN_XENOWARNING("You are already watching that sister!"))
			return

		if (caste_name != "Queen" && is_zoomed)
			zoom_out()
			visible_message(SPAN_NOTICE("[src] stops looking off into the distance."), \
			SPAN_NOTICE("You stop looking off into the distance."), null, 5)

		observed_xeno = targetXeno 
		src.add_movement_handler(new movement_event_handler(src))

	src.reset_view()

// Called from xeno Life()
// Makes sure that Xeno overwatch is reset when the overwatched Xeno dies.
/mob/living/carbon/Xenomorph/proc/handle_overwatch()
	if (observed_xeno && (observed_xeno == DEAD || observed_xeno.disposed))
		overwatch(null, TRUE)

// Sets the Xeno's view to its observed target if that target is set. Otherwise, resets the xeno's view to itself.
// Please handle typechecking outside this proc
/mob/living/carbon/Xenomorph/reset_view(atom/A)
	if (client)

		// Is our observed xeno configured and are we alive?
		if(observed_xeno && !stat)
			client.perspective = EYE_PERSPECTIVE
			client.eye = observed_xeno

		// Otherwise, use default reset_view 
		else
			. = ..(A)

// Handle HREF clicks through hive status and hivemind
/mob/living/carbon/Xenomorph/Topic(href, href_list)
	if(href_list[XENO_OVERWATCH_TARGET_HREF])
		if(!check_state(1))
			return

		var/isQueen = (src.caste_name == "Queen")

		var/mob/living/carbon/Xenomorph/xenoTarget = locate(href_list[XENO_OVERWATCH_TARGET_HREF]) in living_mob_list
		var/mob/living/carbon/Xenomorph/xenoSrc = locate(href_list[XENO_OVERWATCH_SRC_HREF]) in living_mob_list

		if(!istype(xenoTarget) || xenoTarget.stat == DEAD || xenoTarget.z == ADMIN_Z_LEVEL)
			return

		if(!istype(xenoSrc) || xenoSrc.stat == DEAD)
			return

		if (!isQueen)
			xenoSrc.overwatch(xenoTarget)
		else
			var/mob/living/carbon/Xenomorph/oldXeno = xenoSrc.observed_xeno
			xenoSrc.overwatch(xenoTarget, FALSE, /datum/event_handler/xeno_overwatch_onmovement/queen)
			if (oldXeno)
				oldXeno.hud_set_queen_overwatch()
			if (xenoTarget && !xenoTarget.disposed)
				xenoTarget.hud_set_queen_overwatch()

	..()

// Event handler so we reset on movement 
// I'd recommend reading the event handler code before you try to understand this 
/datum/event_handler/xeno_overwatch_onmovement
	flags_handler = NO_FLAGS
	var/mob/living/carbon/Xenomorph/X = null

/datum/event_handler/xeno_overwatch_onmovement/New(mob/living/carbon/Xenomorph/X)
	src.X = X

/datum/event_handler/xeno_overwatch_onmovement/Destroy()
	X = null 
	return ..()
	
/datum/event_handler/xeno_overwatch_onmovement/handle(sender, datum/event_args/ev_args)
	var/datum/event_args/mob_movement/event_args = ev_args
	var/isMoving = event_args.moving

	if (!isMoving)
		return

	if (X && !X.disposed)
		X.overwatch(X.observed_xeno, TRUE) // Goodbye overwatch
											// Even if we hand in null here, it doesn't matter
		X.event_movement.remove_handler(src)   // Clean ourselves up 
		return 0 

// modified for the queen
/datum/event_handler/xeno_overwatch_onmovement/queen

/datum/event_handler/xeno_overwatch_onmovement/handle(sender, datum/event_args/ev_args)
	var/datum/event_args/mob_movement/event_args = ev_args
	var/isMoving = event_args.moving

	if (!isMoving)
		return

	// This is mostly exactly the same but with some special code for dealing with the queen hud
	var/mob/living/carbon/Xenomorph/oldXeno = X.observed_xeno
	if (X && !X.disposed)
		X.overwatch(X.observed_xeno, TRUE)
	if (oldXeno)
		oldXeno.hud_set_queen_overwatch()

	X.event_movement.remove_handler(src)
	return 0