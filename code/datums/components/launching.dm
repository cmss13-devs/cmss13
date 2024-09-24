/datum/component/launching
	dupe_mode = COMPONENT_DUPE_UNIQUE_PASSARGS

	var/const/LAUNCH_RESULT_SUCCESSFUL = 1
	var/const/LAUNCH_RESULT_STOPPED = 2
	var/const/LAUNCH_RESULT_DELETED = 3

	VAR_PRIVATE/datum/weakref/target_ref
	VAR_PRIVATE/turf/target_turf

	VAR_PRIVATE/range
	VAR_PRIVATE/speed
	VAR_PRIVATE/datum/weakref/thrower_ref
	VAR_PRIVATE/spin
	/// Pass flags to add to movable temporarily
	VAR_PRIVATE/pass_flags = NO_FLAGS
	VAR_PRIVATE/datum/callback/collision_callback
	VAR_PRIVATE/datum/callback/end_throw_callback
	/**
	 * A predetermined path to follow for a launch.
	 *
	 * This list is processed as a STACK, so order of the list should be from the target destination to the first
	 * turf the launched object is moved to.
	 */
	VAR_PRIVATE/list/turf/custom_turf_path

	// Tracked information
	/// The path of movable reversed
	VAR_PRIVATE/list/turf_path
	/// Last turf that the movable was launched to
	VAR_PRIVATE/turf/last_turf
	/// Speed of movable prior to launch
	VAR_PRIVATE/old_speed
	/// Time since last movement (in seconds)
	VAR_PRIVATE/time_since_last_move

	/// Output of launch
	VAR_PRIVATE/datum/launch_result/launch_result

/datum/component/launching/proc/operator""()
	var/target = VAL_OR_DEFAULT(target_ref?.resolve(), VAL_OR_DEFAULT(target_turf, "<was deleted>"))
	return "launching(target=[target], range=[range], speed=[speed], spin=[spin], pass_flags=[pass_flags], collision_callback=[collision_callback], end_throw_callback=[end_throw_callback])"

/datum/component/launching/Initialize(atom/target, range, speed, atom/thrower, spin, pass_flags, datum/callback/collision_callback, datum/callback/end_throw_callback, list/turf/custom_turf_path)
	if (!target)
		return COMPONENT_INCOMPATIBLE

	setup_launching_parameters(arglist(args))
	SSlaunching.in_launch |= src

/datum/component/launching/proc/setup_launching_parameters(atom/target, range, speed, atom/thrower, spin, pass_flags, datum/callback/collision_callback, datum/callback/end_throw_callback, list/turf/custom_turf_path)
	src.target_ref = isturf(target) ? null : WEAKREF(target)
	src.target_turf = get_turf(target)
	src.range = range
	src.speed = speed
	src.thrower_ref = WEAKREF(thrower)
	src.spin = spin
	src.pass_flags = pass_flags
	src.collision_callback = collision_callback
	src.end_throw_callback = end_throw_callback
	src.custom_turf_path = custom_turf_path

	var/zone_selected = null
	if (isliving(thrower))
		var/mob/living/living_thrower = thrower
		zone_selected = living_thrower.zone_selected
	src.launch_result = new(thrower_ref, zone_selected)

/datum/component/launching/Destroy(force, ...)
	target_ref = null
	target_turf = null
	thrower_ref = null
	last_turf = null
	QDEL_NULL(launch_result)
	return ..()

#define CLEAR_SIGNALS \
UnregisterSignal(parent, COMSIG_MOVABLE_COLLIDE); var/target = target_ref?.resolve(); if (target) { UnregisterSignal(target, COMSIG_ATOM_CROSSED); };

/datum/component/launching/RegisterWithParent()
	var/sigresult = SEND_SIGNAL(parent, COMSIG_MOVABLE_LAUNCHING, src)
	if (sigresult & COMPONENT_CANCEL_LAUNCH)
		qdel(src)
		return

	// TODO: Add function here for movable to call when it is launched
	RegisterSignal(parent, COMSIG_MOVABLE_COLLIDE, PROC_REF(complete_launch))
	ADD_TRAIT(parent, TRAIT_LAUNCHED, LAUNCHED_TRAIT)

/datum/component/launching/UnregisterFromParent()
	CLEAR_SIGNALS
	REMOVE_TRAIT(parent, TRAIT_LAUNCHED, LAUNCHED_TRAIT)
	// Cleanup
	var/atom/movable/launched = parent
	if (launched.loc)
		launched.cur_speed = old_speed
		launched.remove_temp_pass_flags(pass_flags)
		end_throw_callback?.Invoke(launched)

/datum/component/launching/InheritComponent(datum/component/C, i_am_original, atom/target, range, speed, atom/thrower, spin, pass_flags, datum/callback/collision_callback, datum/callback/end_throw_callback, list/turf/custom_turf_path)
	var/sigresult = SEND_SIGNAL(parent, COMSIG_MOVABLE_LAUNCHING_OVERRIDE)
	if (sigresult & COMPONENT_CANCEL_LAUNCH)
		qdel(src)
		return

	// Uses of `src` here to distinguish between this proc's arguments and parameters of previous launch
	var/atom/movable/launched = parent
	if (launched.loc)
		launched.cur_speed = src.old_speed
		launched.remove_temp_pass_flags(src.pass_flags)
		var/datum/callback/to_call = src.end_throw_callback
		src.end_throw_callback = null
		to_call?.Invoke(launched)
	ASSERT(target, "Launched [parent.type] ([text_ref(parent)]) with no target")
	var/list/args_copy = args.Copy()
	args_copy.Cut(1,3)
	setup_launching_parameters(arglist(args_copy))
	src.turf_path = null
	SEND_SIGNAL(parent, COMSIG_MOVABLE_LAUNCHING, src)


/datum/component/launching/proc/handle_target_crossed(atom/target, atom/movable/crossed_by)
	var/atom/movable/launched = parent
	if (isturf(target.loc) && crossed_by == launched)
		complete_launch(launched, target)

/**
 * Handling for when launched movable ends launch
 *
 * Ways for launch to resolve:
 * - Launched object collided with something via Collide() call
 * - Launched object collided with target via Crossed() call
 * - Launch ended without hitting target
 */
/datum/component/launching/proc/complete_launch(atom/movable/launched, atom/collided_with)
	SIGNAL_HANDLER

	CLEAR_SIGNALS
	var/launch_hint = LAUNCH_COLLISION_SKIP_DEFAULT_COLLIDE
	if (!isnull(collision_callback) && !isnull(collided_with))
		launch_hint |= collision_callback.Invoke(launched, collided_with, launch_result)

	if (launch_hint & LAUNCH_COLLISION_SKIP_LAUNCH_IMPACT)
		// Component has outlived its usefulness, time to die :salute:
		qdel(src)
		if (launch_hint & LAUNCH_COLLISION_SKIP_DEFAULT_COLLIDE)
			. |= COMPONENT_SKIP_DEFAULT_COLLIDE
		return


	launch_hint |= launched.launch_impact(collided_with, launch_result)

	// Component has outlived its usefulness, time to die :salute:
	qdel(src)
	if (launch_hint & LAUNCH_COLLISION_SKIP_DEFAULT_COLLIDE)
		return COMPONENT_SKIP_DEFAULT_COLLIDE

#undef CLEAR_SIGNALS

/// Handle movement of launched atom to next turf
/// If launched atom is deleted at any point this should not be called
/datum/component/launching/process(delta_time)
	/// Checks whether `launched` and `target` are in the same turf, always assumes `launched` exists and is not qdel'd (there are other checks for this in the proc)
	#define IN_SAME_TURF(launched, target) (!QDELETED(target) && isturf(launched.loc) && target.loc == launched.loc)

	. = LAUNCH_RESULT_SUCCESSFUL
	var/atom/movable/launched = parent

	var/moved = turf_path
	if (!moved)
		if (custom_turf_path)
			turf_path = custom_turf_path
		else
			var/turf/start_turf = get_step_towards(launched, target_turf)
			turf_path = reverselist(get_line(start_turf, target_turf))
		launched.add_temp_pass_flags(pass_flags)
		old_speed = launched.cur_speed
		launched.cur_speed = clamp(speed, MIN_SPEED, MAX_SPEED)
		last_turf = launched.loc

		if (spin)
			launched.animation_spin(5, 1 + min(1, range/20))

	time_since_last_move += delta_time
	var/move_speed = 1 / max(10/launched.cur_speed - 0.5, 0.01)
	// If we have not moved yet, perform at least 1 move
	var/move_count = max(time_since_last_move * move_speed, moved ? 0.0 : 1.0)
	var/turf/next_turf
	if (move_count >= 1)
		time_since_last_move = time_since_last_move - floor(time_since_last_move)
	var/atom/target = target_ref?.resolve()
	if (IN_SAME_TURF(launched, target))
		. = LAUNCH_RESULT_STOPPED
	while (. == LAUNCH_RESULT_SUCCESSFUL && move_count >= 1.0)
		if (!turf_path.len)
			. = LAUNCH_RESULT_STOPPED
			break
		move_count -= 1.0
		next_turf = turf_path[turf_path.len]
		turf_path.len--
		if (HAS_TRAIT_FROM(launched, TRAIT_IMMOBILIZED, BUCKLED_TRAIT))
			. = LAUNCH_RESULT_STOPPED
			break
		if (launched.loc != last_turf)
			. = LAUNCH_RESULT_STOPPED
			break
		if (!launched.Move(next_turf))
			. = LAUNCH_RESULT_STOPPED
			// Thing being launched can be launched again by any collisions from Move() call
			// If there is a desired execution of events (e.g. launch impact called BEFORE new throw), consider
			// changing any calls that launch the object to an INVOKE_NEXT_TICK call
			if (QDELETED(src))
				return LAUNCH_RESULT_DELETED
			break
		// Thing being launched can be launched again by any collisions from Move() call
		// If there is a desired execution of events (e.g. launch impact called BEFORE new throw), consider
		// changing any calls that launch the object to an INVOKE_NEXT_TICK call
		if (QDELETED(src))
			return LAUNCH_RESULT_DELETED
		if (IN_SAME_TURF(launched, target))
			. = LAUNCH_RESULT_STOPPED
			return
		last_turf = launched.loc
		launch_result.dist++
		if (launch_result.dist >= range)
			. = LAUNCH_RESULT_STOPPED

	// If we are not at end of path or throw was not forcefully stopped
	// THEN keep going
	if (launched.loc != target_turf && length(turf_path) && . != LAUNCH_RESULT_STOPPED)
		return

	// End of the road...
	var/atom/collided_with = target_turf
	// If our target is a mob and we are on the same turf, then directly hit them
	if (IN_SAME_TURF(launched, target) && ismob(target))
		collided_with = target
	complete_launch(launched, collided_with)
	// Need to set this in case the launch stopped because we reached the end of the throw path
	. = LAUNCH_RESULT_STOPPED

	#undef IN_SAME_TURF
