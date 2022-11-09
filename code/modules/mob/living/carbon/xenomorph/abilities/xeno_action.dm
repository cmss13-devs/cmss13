/datum/action/xeno_action
	icon_file = 'icons/mob/hud/actions_xeno.dmi'
	var/ability_name // Our name

	var/plasma_cost = 0
	var/macro_path
	var/action_type = XENO_ACTION_CLICK // Determines how macros interact with this action. Defines are in xeno.dm in the defines folder.
	var/ability_primacy = XENO_NOT_PRIMARY_ACTION // Determines how the default ability macros handle this.

	// Cooldown
	/// Cooldown of the ability (do not use the cooldown var)
	/// Probably should only have the cooldown var, but that is for another rework
	var/xeno_cooldown = null
	var/cooldown_message = null
	var/no_cooldown_msg = FALSE

	var/cooldown_timer_id = TIMER_ID_NULL // holds our timer ID

	// Track state so we can effectively REDUCE xeno_cooldown by removing and replacing timers.
	var/current_cooldown_start_time = 0
	var/current_cooldown_duration = 0

	// Charging
	/// When set, an ability has to be charged up by being the active ability before it can be used
	var/charge_time = null
	var/charge_ready = TRUE
	var/charge_timer_id = TIMER_ID_NULL

	var/charges = NO_ACTION_CHARGES

/datum/action/xeno_action/New(Target, override_icon_state)
	. = ..()
	if(charges != NO_ACTION_CHARGES)
		RegisterSignal(src, COMSIG_XENO_ACTION_USED, .proc/remove_charge)
	if(charge_time)
		charge_ready = FALSE
	update_button_icon()

/datum/action/xeno_action/proc/remove_charge()
	SIGNAL_HANDLER
	charges--
	if(!charges)
		remove_from(owner)

// Actually applies the effects of the action.
// Circa 1/2020, effects for even non-activable abilities are moved
// under this proc.
// __MUST__ call apply_cooldown if xeno_cooldown are desired.
// Should where possible modify no state on the host Xenos besides
// state intrinsic to all Xenos.
// Any strain or caste-specific state should be stored on behavior_delegate objects
// which use_ability invocations can modify using typechecks and typecasts where appropriate.
/datum/action/xeno_action/proc/use_ability(atom/target)
	if(!owner)
		return FALSE
	track_xeno_ability_stats()
	for(var/datum/action/action in owner.actions)
		action.update_button_icon()
	return TRUE

// Track statistics for this ability
/datum/action/xeno_action/proc/track_xeno_ability_stats()
	if(!owner)
		return
	var/mob/living/carbon/Xenomorph/X = owner
	if (ability_name && round_statistics)
		round_statistics.track_ability_usage(ability_name)
		X.track_ability_usage(ability_name, X.caste_type)

/datum/action/xeno_action/can_use_action()
	if(!owner)
		return FALSE
	var/mob/living/carbon/Xenomorph/X = owner
	if(X && !X.is_mob_incapacitated() && !X.dazed && !X.lying && !X.buckled && X.plasma_stored >= plasma_cost)
		return TRUE

/datum/action/xeno_action/give_to(mob/living/L)
	..()
	if(macro_path)
		add_verb(L, macro_path)

/datum/action/xeno_action/update_button_icon()
	if(!button)
		return
	if(!can_use_action())
		button.color = rgb(128,0,0,128)
	else if(!action_cooldown_check())
		if(cooldown_timer_id == TIMER_ID_NULL) // if this is null, we're here because we haven't charged up yet
			button.color = rgb(200, 65, 115, 200)
		else
			button.color = rgb(240,180,0,200)
	else
		button.color = rgb(255,255,255,255)

// Helper proc that checks and uses plasma if possible, returning TRUE
// if the use was successful
/datum/action/xeno_action/proc/check_and_use_plasma_owner(var/plasma_to_use)
	if (!check_plasma_owner(plasma_to_use))
		return FALSE

	use_plasma_owner(plasma_to_use)
	return TRUE

// Checks the host Xeno's plasma. Returns TRUE if the amount of plasma
// is sufficient to use the ability and FALSE otherwise.
/datum/action/xeno_action/proc/check_plasma_owner(var/plasma_to_use)
	if(!owner)
		return

	var/plasma_to_check = plasma_cost
	if(plasma_to_use)
		plasma_to_check = plasma_to_use

	var/mob/living/carbon/Xenomorph/X = owner
	return X.check_plasma(plasma_to_check)

// Uses plasma on the owner.
/datum/action/xeno_action/proc/use_plasma_owner(var/plasma_to_use)
	if(!owner)
		return

	var/plasma_to_check = plasma_cost
	if(plasma_to_use)
		plasma_to_check = plasma_to_use

	var/mob/living/carbon/Xenomorph/X = owner
	X.use_plasma(plasma_to_check)

/// A wrapper for use_ability that sends a signal
/datum/action/xeno_action/proc/use_ability_wrapper(...)
	// TODO: make hidden a part of can_use_action
	if(!hidden && can_use_action() && use_ability(arglist(args)))
		SEND_SIGNAL(src, COMSIG_XENO_ACTION_USED, owner)

// Activable actions - most abilities in the game. Require Shift/Middle click to do their 'main' effects.
// The action_activate code of these actions does NOT call use_ability.
/datum/action/xeno_action/activable

/datum/action/xeno_action/activable/can_use_action()
	return TRUE

// Called when the action is clicked on.
// For non-activable Xeno actions, this is used to
// actually DO the action.
/datum/action/xeno_action/activable/action_activate()
	if(!owner)
		return
	if(hidden)
		return // There's no where we want a hidden action to be selectable right?
	var/mob/living/carbon/Xenomorph/xeno = owner
	if(xeno.selected_ability == src)
		if(xeno.deselect_timer > world.time)
			return // We clicked the same ability in a very short time
		to_chat(xeno, "You will no longer use [ability_name] with \
			[xeno.client && xeno.client.prefs && xeno.client.prefs.toggle_prefs & TOGGLE_MIDDLE_MOUSE_CLICK ? "middle-click" : "shift-click"].")
		button.icon_state = "template"
		xeno.selected_ability = null
		if(charge_time)
			stop_charging_ability()
	else
		to_chat(xeno, "You will now use [ability_name] with \
			[xeno.client && xeno.client.prefs && xeno.client.prefs.toggle_prefs & TOGGLE_MIDDLE_MOUSE_CLICK ? "middle-click" : "shift-click"].")
		if(xeno.selected_ability)
			xeno.selected_ability.action_deselect()
			if(xeno.selected_ability.charge_time)
				xeno.selected_ability.stop_charging_ability()
		button.icon_state = "template_on"
		xeno.selected_ability = src
		xeno.deselect_timer = world.time + 5 // Half a second
		if(charges != NO_ACTION_CHARGES)
			to_chat(xeno, SPAN_INFO("It has [charges] uses left."))
		if(charge_time)
			start_charging_ability()

// Called when a different action is clicked on and this one is deselected.
/datum/action/xeno_action/activable/proc/action_deselect()
	button.icon_state = "template"


/datum/action/xeno_action/activable/remove_from(mob/living/carbon/Xenomorph/xeno)
	..()
	if(xeno.selected_ability == src)
		xeno.selected_ability = null
	if(macro_path)
		remove_verb(xeno, macro_path)


// 'Onclick' actions - the bulk of the ability's work is done when the button is clicked. Just a thin wrapper that immediately calls into
// use_ability. Anything that uses onclick should not require an argument to be handed to action_activate in order to function.
/datum/action/xeno_action/onclick
	action_type = XENO_ACTION_CLICK
	no_cooldown_msg = TRUE

/datum/action/xeno_action/onclick/action_activate()
	use_ability_wrapper(null)

// Adds a cooldown to this
// According to the cooldown variables set on this and
// the age of the host Xenomorph, where applicable
// IF YOU WANT AGE SCALING SET IT
// THIS PROC SHOULD NEVER BE OVERRIDDEN BY CHILDREN
// AND SHOULD __ALWAYS__ BE CALLED IN USE_ABILITY
/datum/action/xeno_action/proc/apply_cooldown(var/cooldown_modifier = 1)
	if(!owner)
		return
	var/mob/living/carbon/Xenomorph/X = owner
	// Uh oh! STINKY! already on cooldown
	if (cooldown_timer_id != TIMER_ID_NULL)
	/*
		Debug log disabled due to our historical inability at doing anything meaningful about it
		And to make room for ones that matter more in regard to our ability to fix.
		The whole of ability code is fucked up, the 'SHOULD NEVER BE OVERRIDEN' note above is
		completely ignored as about 20 procs override it ALREADY...
		This is broken beyond repair and should just be reimplemented
		log_debug("Xeno action [src] tried to go on cooldown while already on cooldown.")
		log_admin("Xeno action [src] tried to go on cooldown while already on cooldown.")
		*/
		return

	var/cooldown_to_apply = xeno_cooldown * cooldown_modifier

	if(!cooldown_to_apply)
		return

	cooldown_to_apply = cooldown_to_apply * (1 - Clamp(X.cooldown_reduction_percentage, 0, 0.5))

	// Add a unique timer
	cooldown_timer_id = addtimer(CALLBACK(src, .proc/on_cooldown_end), cooldown_to_apply, TIMER_UNIQUE|TIMER_STOPPABLE)
	current_cooldown_duration = cooldown_to_apply
	current_cooldown_start_time = world.time

	// Update our button
	update_button_icon()

// Call when you absolutely MUST have a cooldown of the passed duration
// Useful for things like abilities with 2 xeno_cooldown
// Otherwise identical to apply_cooldown, but likewise should not be overridden
/datum/action/xeno_action/proc/apply_cooldown_override(cooldown_duration)
	if(!owner)
		return

	if(cooldown_timer_id != TIMER_ID_NULL)
		deltimer(cooldown_timer_id)

	var/mob/living/carbon/Xenomorph/X = owner
	// Note: no check to see if we're already on CD. we just flat override whatever's there
	cooldown_duration = cooldown_duration * (1 - Clamp(X.cooldown_reduction_percentage, 0, 0.5))
	cooldown_timer_id = addtimer(CALLBACK(src, .proc/on_cooldown_end), cooldown_duration, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_STOPPABLE)
	current_cooldown_duration = cooldown_duration
	current_cooldown_start_time = world.time

// Checks whether the action is on cooldown. Should not be overridden.
// Returns TRUE if the action can be used and FALSE otherwise.
/datum/action/xeno_action/proc/action_cooldown_check()
	return (cooldown_timer_id == TIMER_ID_NULL) && (!charge_time || charge_ready)

// What occurs when a cooldown ends NATURALLY. Ties into ability_cooldown_over, which tells the source Xeno
// that it can do stuff again and handles any other end-of-cooldown behavior. ability_cooldown_over
// is called when a cooldown ends prematurely and otherwise.
/datum/action/xeno_action/proc/on_cooldown_end()
	if (cooldown_timer_id == TIMER_ID_NULL)
		/* See notes above in apply_cooldown()
		log_debug("Xeno action [src] tried to go off cooldown while already off cooldown.")
		log_admin("Xeno action [src] tried to go off cooldown while already off cooldown.")
		*/
		return

	cooldown_timer_id = TIMER_ID_NULL
	// Don't need to clean up our timer
	current_cooldown_start_time = 0
	current_cooldown_duration = 0
	ability_cooldown_over()
	return

// Immediately force-ends the current cooldown.
/datum/action/xeno_action/proc/end_cooldown()
	if (cooldown_timer_id == TIMER_ID_NULL)
		/* See notes above in apply_cooldown()
		log_debug("Xeno action [src] tried to force end cooldown while already off cooldown.")
		log_admin("Xeno action [src] tried to force end cooldown while already off cooldown.")
		*/
		return

	deltimer(cooldown_timer_id)
	cooldown_timer_id = TIMER_ID_NULL
	current_cooldown_start_time = 0
	current_cooldown_duration = 0
	ability_cooldown_over()
	return

// Attempts to _reduce_ the cooldown by the passed amount in deciseconds. makes use of some state
// we tracked earlier, because unfortunately the timer SS doesn't support querying the time from
// an existing timer by ID. So we just delete it and add a new one if necessary
/datum/action/xeno_action/proc/reduce_cooldown(amount)
	if (cooldown_timer_id == TIMER_ID_NULL)
		/* See notes above in apply_cooldown()
		log_debug("Xeno action [src] tried to force end cooldown while already off cooldown.")
		log_admin("Xeno action [src] tried to force end cooldown while already off cooldown.")
		*/
		return

	// Unconditionally delete the first timer
	deltimer(cooldown_timer_id)
	cooldown_timer_id = TIMER_ID_NULL

	// Are we done, or do we need to add a new timer
	if ((current_cooldown_start_time + current_cooldown_duration - amount) < world.time)
		// We are done, no more cooldown.
		current_cooldown_start_time = 0
		current_cooldown_duration = 0
		ability_cooldown_over()
	else
		// Looks like timers are back on the menu, boys
		var/new_cooldown_duration = current_cooldown_duration - amount - (world.time - current_cooldown_start_time)
		cooldown_timer_id = addtimer(CALLBACK(src, .proc/on_cooldown_end), new_cooldown_duration, TIMER_UNIQUE | TIMER_STOPPABLE)
		current_cooldown_duration = new_cooldown_duration
		current_cooldown_start_time = world.time

	return

// Called when the cooldown ends from any source.
// This is VERY safe to override if you're looking to do extra things when a cooldown
// goes up.
// Possible extensions of this code: add procs that do this
// for all cases, so people that don't understand this code can more
// easily use it
/datum/action/xeno_action/proc/ability_cooldown_over()
	if(!owner)
		return
	for(var/X in owner.actions)
		var/datum/action/act = X
		act.update_button_icon()
	if(!no_cooldown_msg)
		if(cooldown_message)
			to_chat(owner, SPAN_XENODANGER("[cooldown_message]"))
		else
			to_chat(owner, SPAN_XENODANGER("You feel your strength return! You can use [name] again!"))

/datum/action/xeno_action/proc/start_charging_ability()
	charge_timer_id = addtimer(CALLBACK(src, .proc/finish_charging_ability), charge_time, TIMER_UNIQUE|TIMER_STOPPABLE)
	to_chat(owner, SPAN_XENOWARNING("You start charging up your <b>[name]</b>!"))

/datum/action/xeno_action/proc/finish_charging_ability()
	charge_timer_id = TIMER_ID_NULL
	charge_ready = TRUE
	update_button_icon()

/datum/action/xeno_action/proc/stop_charging_ability()
	charge_ready = FALSE
	update_button_icon()
	if(charge_timer_id == TIMER_ID_NULL)
		return
	deltimer(charge_timer_id)
	charge_timer_id = TIMER_ID_NULL

// Helper proc to get an action on a target Xeno by type.
// Used to interact with abilities from the outside
/proc/get_xeno_action_by_type(mob/living/carbon/Xenomorph/X, var/typepath)
	if (!istype(X))
		CRASH("xeno_action.dm: get_xeno_action_by_type invoked with non-xeno first argument.")

	for (var/datum/action/xeno_action/XA in X.actions)
		if (istype(XA, typepath))
			return XA
	return null

// Helper proc to check if there is anything blocking the way from mob M to the atom A
// Max distance can be supplied to check some of the way instead of the whole way.
/proc/check_clear_path_to_target(var/mob/M, var/atom/A, var/smash_windows = TRUE, var/max_distance = 1000)
	if(A.z != M.z)
		return FALSE

	var/list/turf/path = getline2(M, A, include_from_atom = FALSE)
	var/distance = 0
	for(var/turf/T in path)
		if(distance >= max_distance)
			return FALSE
		distance++

		if(T.density || T.opacity)
			return FALSE

		// H'yup, it's the snowflake check for dropships
		if(istype(T, /turf/closed/shuttle/))
			return FALSE

		for(var/obj/structure/S in T)
			if(istype(S, /obj/structure/window/framed) && smash_windows)
				var/obj/structure/window/framed/W = S
				if(!W.unslashable)
					W.shatter_window(TRUE)

			if(S.opacity)
				return FALSE

	return TRUE
