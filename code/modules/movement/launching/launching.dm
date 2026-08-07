/datum/launch_metadata
	// Parameters
	var/pass_flags = NO_FLAGS // Pass flags to add temporarily

	var/list/turf/path
	var/atom/movable/thrown
	var/atom/target
	var/range
	var/speed
	var/atom/thrower
	var/tracking = FALSE
	var/spin

	/// How often to have SSlaunch tick us in deciseconds. This will be set based on throw speed.
	/// SSlaunch itself runs at about 0.1s tick so you won't get any faster, sorry
	var/delay = 1 DECISECONDS

	/// Speed prior to throwing
	var/old_speed

	// A list of callbacks to invoke when an atom of a specific type is hit (keys are typepaths and values are proc paths)
	// These should only be for CUSTOM procs to invoke when an atom of a specific type is collided with, otherwise will default to using
	// the appropriate mob/obj/turf collision procs
	// The callbacks can be standard or dynamic, though dynamic callbacks can only be called by the atom being thrown
	var/list/collision_callbacks

	/// A list of callbacks to invoke when the throw completes successfully
	var/list/end_throw_callbacks

	// Tracked information
	var/dist = 0

/datum/launch_metadata/Destroy(force, ...)
	thrown?.launch_metadata = null
	target = null
	thrower = null
	thrown = null
	path = null
	SSlaunch.cancel_throw(src)
	return ..()


/datum/launch_metadata/proc/get_collision_callbacks(atom/A)
	var/highest_matching = null
	var/list/matching = list()

	if (isnull(collision_callbacks))
		return null

	for (var/path in collision_callbacks)
		if (ispath(path) && istype(A, path))
			// A is going to be of type `path` and `highest_matching`, so check whether
			// `highest_matching` is a parent of `path` (lower in the type tree)
			if (isnull(highest_matching) || !ispath(highest_matching, path))
				highest_matching = path
			matching += path

	if (isnull(highest_matching))
		return null
	return list(collision_callbacks[highest_matching])

/// Invoke end_throw_callbacks on this metadata.
/// Takes argument of type /atom/movable
/datum/launch_metadata/proc/invoke_end_throw_callbacks(atom/movable/movable_atom)
	if(length(end_throw_callbacks))
		for(var/datum/callback/callback as anything in end_throw_callbacks)
			if(istype(callback, /datum/callback/dynamic))
				callback.Invoke(movable_atom)
			else
				callback.Invoke()

/atom/movable/var/datum/launch_metadata/launch_metadata = null

//called when src is thrown into hit_atom
/atom/movable/proc/launch_impact(atom/hit_atom)
	if (isnull(launch_metadata))
		CRASH("launch_impact called without any stored metadata")

	var/list/collision_callbacks = launch_metadata?.get_collision_callbacks(hit_atom)
	if (islist(collision_callbacks))
		for(var/datum/callback/CB as anything in collision_callbacks)
			if(istype(CB, /datum/callback/dynamic))
				CB.Invoke(src, hit_atom)
			else
				CB.Invoke(hit_atom)
	else if (isliving(hit_atom))
		mob_launch_collision(hit_atom)
	else if (isobj(hit_atom)) // Thrown object hits another object and moves it
		obj_launch_collision(hit_atom)
	else if (isturf(hit_atom))
		var/turf/T = hit_atom
		if (T.density)
			turf_launch_collision(T)

	throwing = FALSE
	rebounding = FALSE

/atom/movable/proc/mob_launch_collision(mob/living/L)
	if (!rebounding)
		L.hitby(src)

/atom/movable/proc/obj_launch_collision(obj/O)
	if (!O.anchored && !rebounding && !isxeno(src))
		O.Move(get_step(O, dir))
	else if (!rebounding && rebounds)
		var/oldloc = loc
		var/launched_speed = cur_speed
		addtimer(CALLBACK(src, PROC_REF(rebound), oldloc, launched_speed), 0.5)

	if (!rebounding)
		O.hitby(src)

/atom/movable/proc/turf_launch_collision(turf/T)
	if (!rebounding && rebounds)
		var/oldloc = loc
		var/launched_speed = cur_speed
		addtimer(CALLBACK(src, PROC_REF(rebound), oldloc, launched_speed), 0.5)

	if (!rebounding)
		T.hitby(src)

/atom/movable/proc/rebound(oldloc, launched_speed)
	if (loc == oldloc)
		rebounding = TRUE
		var/datum/launch_metadata/LM = new()
		LM.thrown = src
		LM.target = get_step(src, turn(dir, 180))
		LM.range = 1
		LM.speed = launched_speed
		LM.pass_flags = PASS_UNDER
		LM.pass_flags |= (ismob(src) ? PASS_OVER_THROW_MOB : PASS_OVER_THROW_ITEM)
		LM.old_speed = cur_speed

		launch_towards(LM)

/atom/movable/proc/try_to_throw(mob/living/user)
	return TRUE

// Proc for throwing items (should only really be used for throw)
/atom/movable/proc/throw_atom(atom/target, range, speed = 0, atom/thrower, spin, launch_type = NORMAL_LAUNCH, pass_flags = NO_FLAGS, list/end_throw_callbacks, list/collision_callbacks, tracking = FALSE)
	if(QDELETED(src))
		return // Why throw something deleting?

	var/temp_pass_flags = pass_flags
	switch (launch_type)
		if (NORMAL_LAUNCH)
			temp_pass_flags |= (ismob(src) ? PASS_OVER_THROW_MOB : PASS_OVER_THROW_ITEM)
		if (HIGH_LAUNCH)
			temp_pass_flags |= PASS_HIGH_OVER

	var/datum/launch_metadata/LM = new()
	LM.thrown = src
	LM.pass_flags = temp_pass_flags
	LM.target = target
	LM.range = range
	LM.speed = speed
	LM.thrower = thrower
	LM.spin = spin
	LM.tracking = tracking
	LM.old_speed = cur_speed

	if(end_throw_callbacks)
		LM.end_throw_callbacks = end_throw_callbacks
	if(collision_callbacks)
		LM.collision_callbacks = collision_callbacks

	if(SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_LAUNCH, LM) & COMPONENT_LAUNCH_CANCEL)
		qdel(LM)
		return

	launch_towards(LM)

/// Proc for throwing or propelling movable atoms towards a target. DON'T use this one, use throw_atom if possible.
/atom/movable/proc/launch_towards(datum/launch_metadata/LM)
	if(SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_THROW, LM.thrower) & COMPONENT_CANCEL_THROW)
		qdel(LM)
		return

	if(launch_metadata) // Override previous throw
		reset_throw()
	launch_metadata = LM

	if(!SSlaunch.launch(LM))
		return

	// Finally we prepare the atom state for throwing before SSlaunch kicks in
	add_temp_pass_flags(LM.pass_flags)
	if(LM.spin)
		animation_spin(5, 1 + min(1, LM.range/20))
	flags_atom |= NO_ZFALL
	throwing = TRUE

	var/turf/start_turf
	var/turf/above = SSmapping.get_turf_above(loc)
	var/datum/turf_reservation/reservation = SSmapping.used_turfs[loc]
	if(reservation && (reservation.is_below(loc, get_turf(LM.target))) || (LM.target.z > z) && istype(above, /turf/open_space))
		start_turf = above
	else
		start_turf = get_step_towards(src, LM.target)
		if(reservation && reservation.is_below(get_turf(LM.target), loc))
			start_turf = get_step_towards(src, SSmapping.get_turf_above(LM.target))

	LM.path = get_line(start_turf, LM.target)
	LM.dist = 0


/// Called by SSlaunch when enough time has elapsed to make us process movement of the throw
/atom/movable/proc/tick_throw(datum/launch_metadata/LM)
	var/turf/next_turf = popleft(LM.path)
	if(!throwing || ++LM.dist >= LM.range || !next_turf)
		return FALSE // Bail out.
	var/moved = Move(next_turf)

	if(!moved)
		var/turf/turf = get_turf(src)
		var/atom/hit_atom = ismob(LM.target) ? null : turf
		if(LM.target in turf)
			hit_atom = LM.target
		if(!hit_atom && LM.tracking && get_dist(src, LM.target) <= 1) // If we missed, but we are tracking and the target is still next to us then we still count it as a hit
			hit_atom = LM.target
		if(hit_atom)
			launch_impact(hit_atom)
		reset_throw()
		return FALSE

	return TRUE


/// Call to clear the throwing state completely, the item will stop in place
/atom/movable/proc/reset_throw()
	if(!launch_metadata)
		return

	var/turf/end_turf = get_turf(src)
	if(end_turf)
		end_turf.on_throw_end(src)

	remove_temp_pass_flags(launch_metadata?.pass_flags)
	cur_speed = launch_metadata.old_speed

	SSlaunch?.cancel_throw(launch_metadata)
	QDEL_NULL(launch_metadata)

	flags_atom &= ~NO_ZFALL
	throwing = FALSE
	rebounding = FALSE



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
