/datum/action/xeno_action
	var/ability_name // Our name

	var/plasma_cost = 0
	var/macro_path
	var/action_type = XENO_ACTION_CLICK // Determines how macros interact with this action. Defines are in xeno.dm in the defines folder.
	var/ability_primacy = XENO_NOT_PRIMARY_ACTION // Determines how the default ability macros handle this.

	// Cooldown
	var/list/cooldowns = null   // Initialize this when you want to use age cooldowns. 
								// How this list works: each index is the cooldown. Each index in this list MUCH be used.
								// If this list is not initialized (which it should be) the ability will attempt to fall back to using the cooldown var
								// after printing an error message to log_debug. 
								// Should always be 4 items long: (3, 2, 2, 1) means to use 3 deciseconds at young-, 2 deciseconds at mature/elder, and 1 decisecond at ancient.
								// Note that this can be initialized on subtypes or mutated, depending on your preference/requirements
	
	var/cooldown_timer_id = TIMER_ID_NULL // holds our timer ID

	// Track state so we can effectively REDUCE cooldowns by removing and replacing timers.
	var/current_cooldown_start_time = 0
	var/current_cooldown_duration = 0


// Actually applies the effects of the action. 
// Circa 1/2020, effects for even non-activable abilities are moved
// under this proc.
// __MUST__ call apply_cooldown if cooldowns are desired.
// Should where possible modify no state on the host Xenos besides
// state intrinsic to all Xenos.
// Any strain or caste-specific state should be stored on behavior_delegate objects
// which use_ability invocations can modify using typechecks and typecasts where appropriate.
/datum/action/xeno_action/proc/use_ability(atom/A)
	if(!owner)
		return
	track_xeno_ability_stats()
	for(var/X in owner.actions)
		var/datum/action/act = X
		act.update_button_icon()
	return

// Track statistics for this ability
/datum/action/xeno_action/proc/track_xeno_ability_stats()
	if(!owner)
		return
	var/mob/living/carbon/Xenomorph/X = owner
	if (ability_name && round_statistics)
		round_statistics.track_ability_usage(ability_name)
		X.track_ability_usage(ability_name, X.caste_name)

/datum/action/xeno_action/can_use_action()
	if(!owner)
		return
	var/mob/living/carbon/Xenomorph/X = owner
	if(X && !X.is_mob_incapacitated() && !X.dazed && !X.lying && !X.buckled && X.plasma_stored >= plasma_cost)
		return TRUE

/datum/action/xeno_action/give_action(mob/living/L)
	..()
	if(macro_path)
		L.verbs += macro_path

/datum/action/xeno_action/update_button_icon()
	if(!button)
		return
	if(!can_use_action())
		button.color = rgb(128,0,0,128)
	else if(!action_cooldown_check())
		button.color = rgb(240,180,0,200)
	else
		button.color = rgb(255,255,255,255)

// Helper proc that checks and uses plasma if possible, returning TRUE 
// if the use was successful
/datum/action/xeno_action/proc/check_and_use_plasma_owner()
	if (!check_plasma_owner())
		return FALSE
	
	use_plasma_owner()
	return TRUE

// Checks the host Xeno's plasma. Returns TRUE if the amount of plasma
// is sufficient to use the ability and FALSE otherwise.
/datum/action/xeno_action/proc/check_plasma_owner()
	if(!owner)
		return
	var/mob/living/carbon/Xenomorph/X = owner
	return X.check_plasma(plasma_cost)

// Uses plasma on the owner.
/datum/action/xeno_action/proc/use_plasma_owner()
	if(!owner)
		return
	var/mob/living/carbon/Xenomorph/X = owner
	X.use_plasma(plasma_cost)

// Activable actions - most abilities in the game. Require Shift/Middle click to do their 'main' effects.
// The action_activate code of these actions does NOT call use_ability.
/datum/action/xeno_action/activable

// Called when the action is clicked on.
// For non-activable Xeno actions, this is used to 
// actually DO the action. 
/datum/action/xeno_action/activable/action_activate()
	if(!owner)
		return
	var/mob/living/carbon/Xenomorph/X = owner
	if(X.selected_ability == src)
		to_chat(X, "You will no longer use [ability_name] with \
			[X.client && X.client.prefs && X.client.prefs.toggle_prefs & TOGGLE_MIDDLE_MOUSE_CLICK ? "middle-click" : "shift-click"].")
		button.icon_state = "template"
		X.selected_ability = null
	else
		to_chat(X, "You will now use [ability_name] with \
			[X.client && X.client.prefs && X.client.prefs.toggle_prefs & TOGGLE_MIDDLE_MOUSE_CLICK ? "middle-click" : "shift-click"].")
		if(X.selected_ability)
			X.selected_ability.button.icon_state = "template"
			X.selected_ability = null
		button.icon_state = "template_on"
		X.selected_ability = src

/datum/action/xeno_action/activable/remove_action(mob/living/carbon/Xenomorph/X)
	..()
	if(X.selected_ability == src)
		X.selected_ability = null
	if(macro_path)
		X.verbs -= macro_path


// 'Onclick' actions - the bulk of the ability's work is done when the button is clicked. Just a thin wrapper that immediately calls into
// use_ability. Anything that uses onclick should not require an argument to be handed to action_activate in order to function.
/datum/action/xeno_action/onclick
	action_type = XENO_ACTION_CLICK

/datum/action/xeno_action/onclick/action_activate()
	use_ability(null)
	return

// Adds a cooldown to this
// According to the cooldown variables set on this and
// the the age of the host Xenomorph, where applicable
// IF YOU WANT AGE SCALING SET IT 
// THIS PROC SHOULD NEVER BE OVERRIDDEN BY CHILDREN
// AND SHOULD __ALWAYS__ BE CALLED IN USE_ABILITY
/datum/action/xeno_action/proc/apply_cooldown()
	if(!owner)
		return
	// Uh oh! STINKY! already on cooldown
	if (cooldown_timer_id != TIMER_ID_NULL)
		log_debug("Xeno action [src] tried to go on cooldown while already on cooldown.")
		log_admin("Xeno action [src] tried to go on cooldown while already on cooldown.")
		return

	// First determine the appopriate cooldown
	var/cooldown_to_apply = cooldown // Use this as fallback

	// Determine the age of our owner
	var/mob/living/carbon/Xenomorph/X = owner

	if (cooldowns && cooldowns.len)
		var/index_to_use
		if (X.upgrade == -1)
			index_to_use = 1
		else if (X.upgrade == 4)
			index_to_use = 4
		else 
			index_to_use = X.upgrade + 1
		
		cooldown_to_apply = cooldowns[index_to_use]

	// Add a unique timer
	cooldown_timer_id = add_timer(CALLBACK(src, .proc/on_cooldown_end), cooldown_to_apply, TIMER_UNIQUE | TIMER_STOPPABLE)
	current_cooldown_duration = cooldown_to_apply
	current_cooldown_start_time = world.time
	
	// Update our button
	update_button_icon()

	return

// Call when you absolutely MUST have a cooldown of the passed duration
// Useful for things like abilities with 2 cooldowns
// Otherwise identical to apply_cooldown, but likewise should not be overridden
/datum/action/xeno_action/proc/apply_cooldown_override(cooldown_duration)

	// Note: no check to see if we're already on CD. we just flat override whatever's there

	cooldown_timer_id = add_timer(CALLBACK(src, .proc/on_cooldown_end), cooldown_duration, TIMER_OVERRIDE_UNIQUE | TIMER_STOPPABLE)
	current_cooldown_duration = cooldown_duration
	current_cooldown_start_time = world.time
	return

// Checks whether the action is on cooldown. Should not be overridden.
// Returns TRUE if the action can be used and FALSE otherwise.
/datum/action/xeno_action/proc/action_cooldown_check()
	return (cooldown_timer_id == TIMER_ID_NULL)

// What occurs when a cooldown ends NATURALLY. Ties into ability_cooldown_over, which tells the source Xeno
// that it can do stuff again and handles any other end-of-cooldown behavior. ability_cooldown_over
// is called when a cooldown ends prematurely and otherwise.
/datum/action/xeno_action/proc/on_cooldown_end()
	if (cooldown_timer_id == TIMER_ID_NULL)
		log_debug("Xeno action [src] tried to go off cooldown while already off cooldown.")
		log_admin("Xeno action [src] tried to go off cooldown while already off cooldown.")
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
		log_debug("Xeno action [src] tried to force end cooldown while already off cooldown.")
		log_admin("Xeno action [src] tried to force end cooldown while already off cooldown.")
		return

	delete_timer(cooldown_timer_id)
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
		log_debug("Xeno action [src] tried to force end cooldown while already off cooldown.")
		log_admin("Xeno action [src] tried to force end cooldown while already off cooldown.")
		return
	
	// Unconditionally delete the first timer
	delete_timer(cooldown_timer_id)
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
		cooldown_timer_id = add_timer(CALLBACK(src, .proc/on_cooldown_end), new_cooldown_duration, TIMER_UNIQUE | TIMER_STOPPABLE)
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
	if (!istype(src, /datum/action/xeno_action/onclick))
		to_chat(owner, SPAN_XENODANGER("You feel your strength return! You can use [name] again!"))
	return

// Helper proc to get an action on a target Xeno by type.
// Used to interact with abilities from the outside
/proc/get_xeno_action_by_type(mob/living/carbon/Xenomorph/X, var/typepath)
	if (!istype(X))
		CRASH("xeno_action.dm@256: get_xeno_action_by_type invoked with non-xeno first argument.")

	for (var/datum/action/xeno_action/XA in X.actions)
		if (istype(XA, typepath))
			return XA
	return null

// Helper proc to check if there is anything blocking the way from mob M to the atom A
// Max distance can be supplied to check some of the way instead of the whole way.
/proc/check_clear_path_to_target(var/mob/M, var/atom/A, var/smash_windows = TRUE, var/max_distance = 1000)
	var/list/turf/path = getline2(M, A, include_from_atom = FALSE)
	var/distance = 0
	for(var/turf/T in path)
		if(distance >= max_distance)
			break
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