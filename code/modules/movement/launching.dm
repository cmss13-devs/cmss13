/// Stores useful metadata from time of launch that is used
/// by atoms hit by a thrown movable
/datum/launch_result
	/// Source of throw (if thrown)
	var/datum/weakref/thrower_ref
	/// Zone selected by thrower at time of throw
	var/zone_selected
	/// Distance travelled by launched object
	var/dist

/datum/launch_result/New(datum/weakref/thrower_ref = null, zone_selected = null)
	src.thrower_ref = thrower_ref
	src.zone_selected = zone_selected
	src.dist = 0

/datum/launch_result/Destroy(force, ...)
	. = ..()
	thrower_ref = null

/// Proc for throwing or propelling movable atoms towards a target
/atom/movable/proc/launch_towards(atom/target, range, speed, atom/thrower, spin, pass_flags = NO_FLAGS, datum/callback/collision_callback, datum/callback/end_throw_callback)
	SHOULD_NOT_OVERRIDE(TRUE)
	ASSERT(!QDELETED(target), "Launch towards called with qdel'd target")
	AddComponent(/datum/component/launching, target, range, speed, thrower, spin, pass_flags, collision_callback, end_throw_callback)


// Called when src is thrown into hit_atom
/atom/movable/proc/launch_impact(atom/hit_atom, datum/launch_result/launch_result)
	if (isliving(hit_atom))
		mob_launch_collision(hit_atom, launch_result)
	else if (isobj(hit_atom)) // Thrown object hits another object and moves it
		obj_launch_collision(hit_atom, launch_result)
	else if (isturf(hit_atom))
		var/turf/T = hit_atom
		if (T.density)
			turf_launch_collision(T, launch_result)

/atom/movable/proc/mob_launch_collision(mob/living/L, datum/launch_result/launch_result)
	if (!HAS_TRAIT(src, TRAIT_REBOUNDING))
		L.hitby(src, launch_result)

/atom/movable/proc/obj_launch_collision(obj/O, datum/launch_result/launch_result)
	if (HAS_TRAIT(src, TRAIT_REBOUNDING))
		return

	if (!O.anchored && !isxeno(src))
		O.Move(get_step(O, dir))
	else if (rebounds)
		
		var/oldloc = loc
		var/launched_speed = cur_speed
		addtimer(CALLBACK(src, PROC_REF(rebound), oldloc, launched_speed), 0.5 DECISECONDS)

	O.hitby(src, launch_result)

/atom/movable/proc/turf_launch_collision(turf/T, datum/launch_result/launch_result)
	if (HAS_TRAIT(src, TRAIT_REBOUNDING))
		return

	if (rebounds)
		var/oldloc = loc
		var/launched_speed = cur_speed
		addtimer(CALLBACK(src, PROC_REF(rebound), oldloc, launched_speed), 0.5 DECISECONDS)

	T.hitby(src, launch_result)

/atom/movable/proc/rebound(oldloc, launched_speed)
	if (loc != oldloc)
		return

	ADD_TRAIT(src, TRAIT_REBOUNDING, REBOUNDING_TRAIT)
	var/target = get_step(src, turn(dir, 180))
	var/range = 1
	var/speed = launched_speed
	var/pass_flags = PASS_UNDER
	pass_flags |= (ismob(src) ? PASS_OVER_THROW_MOB : PASS_OVER_THROW_ITEM)

	launch_towards(target, range, speed, pass_flags = pass_flags, end_throw_callback = CALLBACK(src, PROC_REF(end_rebound)))

/atom/movable/proc/end_rebound()
	REMOVE_TRAIT(src, TRAIT_REBOUNDING, REBOUNDING_TRAIT)

/atom/movable/proc/try_to_throw(mob/living/user)
	return TRUE

// Proc for throwing items (should only really be used for throw)
/atom/movable/proc/throw_atom(atom/target, range, speed = 0, atom/thrower, spin, launch_type = NORMAL_LAUNCH,  pass_flags = NO_FLAGS, collision_callback, end_throw_callback)
	var/temp_pass_flags = pass_flags
	switch (launch_type)
		if (NORMAL_LAUNCH)
			temp_pass_flags |= (ismob(src) ? PASS_OVER_THROW_MOB : PASS_OVER_THROW_ITEM)
		if (HIGH_LAUNCH)
			temp_pass_flags |= PASS_HIGH_OVER

	if(SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_LAUNCH) & COMPONENT_LAUNCH_CANCEL)
		return

	launch_towards(target, range, speed, thrower, spin, temp_pass_flags, collision_callback, end_throw_callback)

/atom/movable/proc/throw_random_direction(range, speed = 0, atom/thrower, spin, launch_type = NORMAL_LAUNCH, pass_flags = NO_FLAGS)
	var/throw_direction = pick(CARDINAL_ALL_DIRS)

	var/turf/furthest_turf = get_turf(src)
	var/turf/temp_turf = get_turf(src)
	for (var/x in 1 to range)
		temp_turf = get_step(furthest_turf, throw_direction)
		if (!temp_turf)
			break
		furthest_turf = temp_turf

	throw_atom(furthest_turf, range, speed, thrower, spin, launch_type, pass_flags)
