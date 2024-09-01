/proc/get_collision_callbacks(list/launch_metadata, atom/A)
	var/highest_matching = null
	var/list/matching = list()

	var/collision_callbacks = launch_metadata[PROP(launch_metadata, collision_callbacks)]
	if (isnull(collision_callbacks))
		return null

	for (var/path in collision_callbacks)
		if (ispath(path) && istype(A, path))
			// A is going to be of type `path` and `highest_matching`, so check whether
			// `highest_matching` is a parent of `path` (lower in the type tree)
			if (isnull(highest_matching) || !ispath(highest_matching, path))
				highest_matching = path
			matching += path

	var/call_all = launch_metadata[PROP(launch_metadata, call_all)]
	if (!call_all)
		if (isnull(highest_matching))
			return null
		return list(collision_callbacks[highest_matching])
	else
		if (length(matching) == 0)
			return null
		var/list/matching_procs = list()
		for(var/path in matching)
			matching_procs += collision_callbacks[path]
		return matching_procs

/// Invoke end_throw_callbacks on this metadata.
/// Takes argument of type /atom/movable
/proc/invoke_end_throw_callbacks(list/launch_metadata, atom/movable/movable_atom)
	var/end_throw_callbacks = launch_metadata[PROP(launch_metadata, end_throw_callbacks)]
	if(length(end_throw_callbacks))
		for(var/datum/callback/callback as anything in end_throw_callbacks)
			if(istype(callback, /datum/callback/dynamic))
				callback.Invoke(movable_atom)
			else
				callback.Invoke()

/// Struct containing information to process when a mob is thrown
/// and how impacting mobs react to it
/atom/movable/var/list/launch_metadata

//called when src is thrown into hit_atom
/atom/movable/proc/launch_impact(atom/hit_atom)
	if (isnull(launch_metadata))
		CRASH("launch_impact called without any stored metadata")

	var/list/collision_callbacks = get_collision_callbacks(launch_metadata, hit_atom)
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
		var/list/launch_metadata = STRUCT(launch_metadata)
		launch_metadata[PROP(launch_metadata, target)] = get_step(src, turn(dir, 180))
		launch_metadata[PROP(launch_metadata, range)] = 1
		launch_metadata[PROP(launch_metadata, speed)] = launched_speed
		launch_metadata[PROP(launch_metadata, pass_flags)] = PASS_UNDER|(ismob(src) ? PASS_OVER_THROW_MOB : PASS_OVER_THROW_ITEM)

		launch_towards(launch_metadata)

/atom/movable/proc/try_to_throw(mob/living/user)
	return TRUE

// Proc for throwing items (should only really be used for throw)
/atom/movable/proc/throw_atom(atom/target, range, speed = 0, atom/thrower, spin, launch_type = NORMAL_LAUNCH, pass_flags = NO_FLAGS, list/end_throw_callbacks, list/collision_callbacks)
	var/temp_pass_flags = pass_flags
	switch (launch_type)
		if (NORMAL_LAUNCH)
			temp_pass_flags |= (ismob(src) ? PASS_OVER_THROW_MOB : PASS_OVER_THROW_ITEM)
		if (HIGH_LAUNCH)
			temp_pass_flags |= PASS_HIGH_OVER

	var/list/launch_metadata = STRUCT(launch_metadata)
	launch_metadata[PROP(launch_metadata, pass_flags)] = temp_pass_flags
	launch_metadata[PROP(launch_metadata, target)] = target
	launch_metadata[PROP(launch_metadata, range)] = range
	launch_metadata[PROP(launch_metadata, speed)] = speed
	launch_metadata[PROP(launch_metadata, thrower)] = thrower
	launch_metadata[PROP(launch_metadata, spin)] = spin
	if(end_throw_callbacks)
		launch_metadata[PROP(launch_metadata, end_throw_callbacks)] = end_throw_callbacks
	if(collision_callbacks)
		launch_metadata[PROP(launch_metadata, collision_callbacks)] = collision_callbacks

	if(SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_LAUNCH, launch_metadata) & COMPONENT_LAUNCH_CANCEL)
		return

	launch_towards(launch_metadata)

// Proc for throwing or propelling movable atoms towards a target
/atom/movable/proc/launch_towards(list/new_launch_metadata)
	if (!ISSTRUCT(new_launch_metadata, launch_metadata))
		CRASH("invalid launch_metadata passed to launch_towards")

	var/target = new_launch_metadata[PROP(launch_metadata, target)]
	if (!target || !src)
		return

	var/thrower = new_launch_metadata[PROP(launch_metadata, thrower)]
	if(SEND_SIGNAL(src, COMSIG_MOVABLE_PRE_THROW, thrower) & COMPONENT_CANCEL_THROW)
		return

	// If we already have launch_metadata (from a previous throw), reset it and qdel the old launch_metadata datum
	if (ISSTRUCT(launch_metadata, launch_metadata))
		QDEL_STRUCT(launch_metadata, launch_metadata)
	launch_metadata = new_launch_metadata

	var/spin = new_launch_metadata[PROP(launch_metadata, spin)]
	if (spin)
		var/range = new_launch_metadata[PROP(launch_metadata, spin)]
		animation_spin(5, 1 + min(1, range/20))

	var/old_speed = cur_speed
	var/metadata_speed = new_launch_metadata[PROP(launch_metadata, speed)]
	cur_speed = clamp(metadata_speed, MIN_SPEED, MAX_SPEED) // Sanity check, also ~1 sec delay between each launch move is not very reasonable
	var/delay = 10/cur_speed - 0.5 // scales delay back to deciseconds for when sleep is called
	var/pass_flags = new_launch_metadata[PROP(launch_metadata, pass_flags)]

	throwing = TRUE

	add_temp_pass_flags(pass_flags)

	var/turf/start_turf = get_step_towards(src, target)
	var/list/turf/path = get_line(start_turf, target)
	var/last_loc = loc

	var/early_exit = FALSE
	launch_metadata[PROP(launch_metadata, dist)] = 0
	for (var/turf/T in path)
		if (!src || !throwing || loc != last_loc || !isturf(src.loc))
			break
		if (!ISSTRUCT(launch_metadata, launch_metadata))
			early_exit = TRUE
			break
		var/dist = launch_metadata[PROP(launch_metadata, dist)]
		var/range = launch_metadata[PROP(launch_metadata, range)]
		if (dist >= range)
			break
		if (!Move(T)) // If this returns FALSE, then a collision happened
			break
		last_loc = loc
		dist = ++launch_metadata[PROP(launch_metadata, dist)]
		if (dist >= range)
			break
		sleep(delay)

	//done throwing, either because it hit something or it finished moving
	if ((isobj(src) || ismob(src)) && throwing && !early_exit)
		var/turf/T = get_turf(src)
		if(!istype(T))
			return
		var/atom/hit_atom = ismob(target) ? null : T // TODO, just check for LM.target, the ismob is to prevent funky behavior with grenades 'n crates
		if(!hit_atom)
			for(var/atom/A in T)
				if(A == target)
					hit_atom = A
					break
		launch_impact(hit_atom)
	if (loc)
		throwing = FALSE
		rebounding = FALSE
		cur_speed = old_speed
		remove_temp_pass_flags(pass_flags)
		invoke_end_throw_callbacks(new_launch_metadata, src)
	QDEL_NULL_STRUCT(launch_metadata, launch_metadata)

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
