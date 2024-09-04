/datum/component/launching
	dupe_mode = COMPONENT_DUPE_HIGHLANDER

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
	var/target = VALORDEFAULT(target_ref?.resolve(), "<was deleted>")
	return "launching(target=[target], range=[range], speed=[speed], spin=[spin], pass_flags=[pass_flags], collision_callback=[collision_callback], end_throw_callback=[end_throw_callback])"

/datum/component/launching/Initialize(atom/target, range, speed, atom/thrower, spin, pass_flags, datum/callback/collision_callback, datum/callback/end_throw_callback)
	if (target)
		src.target_ref = isturf(target) ? null : WEAKREF(target)
		src.target_turf = get_turf(target)
	src.range = range
	src.speed = speed
	src.thrower_ref = WEAKREF(thrower)
	src.spin = spin
	src.pass_flags = pass_flags
	src.collision_callback = collision_callback
	src.end_throw_callback = end_throw_callback

	var/zone_selected = null
	if (isliving(thrower))
		var/mob/living/living_thrower = thrower
		zone_selected = living_thrower.zone_selected
	src.launch_result = new(thrower_ref, zone_selected)
	SSlaunching.in_launch |= src

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
	..()
	SEND_SIGNAL(parent, COMSIG_MOVABLE_LAUNCHED, src)
	// TODO: Add function here for movable to call when it is launched
	RegisterSignal(parent, COMSIG_MOVABLE_COLLIDE, PROC_REF(complete_launch))
	ADD_TRAIT(parent, TRAIT_LAUNCHED, LAUNCHED_TRAIT)

	var/mob/target = target_ref?.resolve()
	// TODO: Instead of this snowflake check, design a better system for handling
	// Crossed() launch collisions
	if (ismob(target))
		RegisterSignal(target, COMSIG_ATOM_CROSSED, PROC_REF(handle_target_crossed))

/datum/component/launching/UnregisterFromParent()
	. = ..()
	CLEAR_SIGNALS
	REMOVE_TRAIT(parent, TRAIT_LAUNCHED, LAUNCHED_TRAIT)

/datum/component/launching/proc/handle_target_crossed(atom/target, atom/movable/launched)
	if (isturf(target.loc))
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

	// Cleanup
	if (launched.loc)
		launched.cur_speed = old_speed
		launched.remove_temp_pass_flags(pass_flags)
		end_throw_callback?.Invoke(launched)

	// Component has outlived its usefulness, time to die :salute:
	qdel(src)
	if (launch_hint & LAUNCH_COLLISION_SKIP_DEFAULT_COLLIDE)
		return COMPONENT_SKIP_DEFAULT_COLLIDE

#undef CLEAR_SIGNALS

/// Handle movement of launched atom to next turf
/// If launched atom is deleted at any point this should not be called
/datum/component/launching/process(delta_time)
	. = LAUNCH_RESULT_SUCCESSFUL
	var/atom/movable/launched = parent

	var/moved = turf_path
	if (!moved)
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
		last_turf = launched.loc
		launch_result.dist++
		if (launch_result.dist >= range)
			. = LAUNCH_RESULT_STOPPED

	// If we are not at end of path or throw was not forcefully stopped
	// THEN keep going
	if (length(turf_path) && . != LAUNCH_RESULT_STOPPED)
		return

	// End of the road, did not hit our intended target (if it existed)
	complete_launch(launched, get_turf(launched))
	. = LAUNCH_RESULT_STOPPED
