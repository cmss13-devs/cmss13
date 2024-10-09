// Generic Mob overwatch proc, very simple for now. If you want it to cancel the overwatch, hand in TRUE in the second var.
// Third var is only for custom event handlers for OW hud indicators, currently only used for the Queen icon
// If you use it, be sure to manually specify the second var, even if its the default value.
/mob/living/carbon/proc/overwatch(mob/living/carbon/target_mob, stop_overwatch = FALSE)
	if(stop_overwatch)
		var/mob/living/carbon/old_target = observed_mob
		observed_mob = null

		SEND_SIGNAL(src, COMSIG_XENO_STOP_OVERWATCH, old_target)
		UnregisterSignal(src, COMSIG_MOB_MOVE_OR_LOOK)

		if(old_target)
			to_chat(src, SPAN_XENOWARNING("You stop watching [old_target]."))
			UnregisterSignal(old_target, COMSIG_PARENT_QDELETING)
	else
		if(target_mob == src)
			to_chat(src, SPAN_XENOWARNING("You can't watch yourself!"))
			return

		if(observed_mob && target_mob && observed_mob == target_mob)
			to_chat(src, SPAN_XENOWARNING("You are already watching that target!"))
			return

		if(observed_mob)
			var/mob/living/carbon/xenomorph/oldXeno = observed_mob
			observed_mob = null

			SEND_SIGNAL(src, COMSIG_XENO_STOP_OVERWATCH_XENO, oldXeno)
			oldXeno.hud_set_queen_overwatch()
			UnregisterSignal(src, COMSIG_MOB_MOVE_OR_LOOK)
			UnregisterSignal(oldXeno, COMSIG_PARENT_QDELETING)

		observed_mob = target_mob

		SEND_SIGNAL(src, COMSIG_XENO_OVERWATCH_XENO, observed_mob)
		RegisterSignal(src, COMSIG_MOB_MOVE_OR_LOOK, PROC_REF(overwatch_handle_mob_move_or_look))
		RegisterSignal(observed_mob, COMSIG_PARENT_QDELETING, PROC_REF(overwatch_handle_deletion))

	src.reset_view()

/mob/living/carbon/proc/overwatch_handle_deletion(mob/living/carbon/xenomorph/deleted, forced)
	SIGNAL_HANDLER
	overwatch(deleted, TRUE)

// Called from Life()
// Makes sure that Xeno overwatch is reset when the overwatched Xeno dies.
/mob/living/carbon/proc/handle_overwatch()
	if(observed_mob)
		if(observed_mob.stat == DEAD || QDELETED(observed_mob))
			overwatch(null, TRUE)
			return

		if(HAS_TRAIT(observed_mob, TRAIT_HIVEMIND_INTERFERENCE))
			to_chat(src, SPAN_XENOWARNING("Our sister's psychic connection is cut off!"))
			overwatch(null, TRUE)
			return

	if(HAS_TRAIT(src, TRAIT_HIVEMIND_INTERFERENCE))
		overwatch(null, TRUE)
		return

/mob/living/carbon/proc/overwatch_handle_mob_move_or_look(mob/living/carbon/xenomorph/mover, actually_moving, direction, specific_direction)
	SIGNAL_HANDLER

	if(!actually_moving)
		return

	mover.overwatch(mover.observed_mob, TRUE) // Goodbye overwatch
	UnregisterSignal(mover, COMSIG_MOB_MOVE_OR_LOOK)
	return COMPONENT_OVERRIDE_MOB_MOVE_OR_LOOK
