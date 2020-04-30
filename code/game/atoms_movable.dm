/atom/movable
	layer = OBJ_LAYER
	var/last_move_dir = null
	var/anchored = 0
	var/drag_delay = 3 //delay (in deciseconds) added to mob's move_delay when pulling it.
	var/l_move_time = 1
	var/throwing = 0
	var/atom/thrower = null
	var/turf/throw_source = null
	var/throw_speed = SPEED_FAST // Speed that an atom will go when thrown by a carbon mob
	var/throw_range = 7
	var/cur_speed = MIN_SPEED // Current speed of an atom (account for speed when launched/thrown as well)
	var/moved_recently = 0
	var/mob/pulledby = null
	var/diagonal_movement = DIAG_MOVE_DEFAULT 	// Type of diagonal movement (whether it checks for obstacles adjacent to start turf)
	var/rebounds = FALSE
	var/rebounding = FALSE // whether an object that was launched was rebounded (to prevent infinite recursive loops from wall bouncing)

	var/acid_damage = 0 //Counter for stomach acid damage. At ~60 ticks, dissolved

	var/move_intentionally = FALSE // this is for some deep stuff optimization. This means that it is regular movement that can only be NSWE and you don't need to perform checks on diagonals. ALWAYS reset it back to FALSE when done



//===========================================================================
/atom/movable/Dispose()
	for(var/atom/movable/I in contents) qdel(I)
	if(pulledby) pulledby.stop_pulling()
	if(throw_source) throw_source = null

	if(loc)
		loc.on_stored_atom_del(src) //things that container need to do when a movable atom inside it is deleted
	vis_contents.Cut()
	. = ..()
	loc = null //so we move into null space. Must be after ..() b/c atom's Dispose handles deleting our lighting stuff

//===========================================================================

/atom/movable/Move(NewLoc, direct)
	var/atom/oldloc = loc
	var/old_dir = dir

	. = ..()
	if (flags_atom & DIRLOCK)
		dir = old_dir
	else
		if (old_dir & EAST|WEST) // Can no longer face NW/NE/SW/SE after moving/being moved
			dir &= NORTH|SOUTH
		else
			dir &= EAST|WEST
	l_move_time = world.time
	if ((oldloc != loc && oldloc && oldloc.z == z))
		last_move_dir = get_dir(oldloc, loc)
	if (.)
		Moved(oldloc,direct)
	else if(directional_lum && light && dir != old_dir) //for objects with directional light that were blocked from moving, but still rotated
		light.changed()

/atom/movable/proc/Collide(atom/A)
	if (throwing)
		launch_impact(A)

	if (A && !A.disposed)
		A.last_bumped = world.time
		A.Collided(src)
	return

/atom/movable/Collided(atom/movable/AM)
	if(isliving(AM) && !anchored)
		var/target_dir = get_dir(AM, src)
		var/turf/target_turf = get_step(loc, target_dir)
		Move(target_turf)
	return

/atom/movable/proc/Moved(atom/OldLoc,Dir)
	if (isturf(loc))
		if (opacity)
			OldLoc.UpdateAffectingLights()
		else
			if (light)
				light.changed()
	return

/atom/movable/proc/forceMove(atom/destination)
	if (destination)
		if (pulledby)
			pulledby.stop_pulling()
		var/oldLoc
		if (loc)
			oldLoc = loc
			loc.Exited(src)
		loc = destination
		loc.Entered(src)
		var/area/old_area
		if (oldLoc)
			old_area = get_area(oldLoc)
		var/area/new_area = get_area(destination)
		if (new_area && old_area != new_area)
			new_area.Entered(src)
		for (var/atom/movable/AM in destination)
			if (AM == src)
				continue
			AM.Crossed(src)
		if (oldLoc)
			Moved(oldLoc,dir)
		return 1
	return 0


//called when src is thrown into hit_atom
/atom/movable/proc/launch_impact(atom/hit_atom)
	if (isliving(hit_atom))
		mob_launch_collision(hit_atom)
	else if (isobj(hit_atom)) // Thrown object hits another object and moves it
		obj_launch_collision(hit_atom)
	else if (isturf(hit_atom))
		var/turf/T = hit_atom
		if (T.density)
			turf_launch_collision(T)

	throwing = FALSE
	rebounding = FALSE

/atom/movable/proc/mob_launch_collision(var/mob/living/L)
	if (!rebounding)
		L.hitby(src)

/atom/movable/proc/obj_launch_collision(var/obj/O)
	if (!O.anchored && !rebounding && !isXeno(src))
		O.Move(get_step(O, dir))
	else if (!rebounding && rebounds)
		var/oldloc = loc
		var/launched_speed = cur_speed
		add_timer(CALLBACK(src, .proc/rebound, oldloc, launched_speed), 0.5)

	if (!rebounding)
		O.hitby(src)

/atom/movable/proc/turf_launch_collision(var/turf/T)
	if (!rebounding && rebounds)
		var/oldloc = loc
		var/launched_speed = cur_speed
		add_timer(CALLBACK(src, .proc/rebound, oldloc, launched_speed), 0.5)

/atom/movable/proc/rebound(var/oldloc, var/launched_speed)
	if (loc == oldloc)
		rebounding = TRUE
		launch_towards(get_step(src, turn(dir, 180)), 1, launched_speed, launch_type = LOW_LAUNCH)

// Proc for throwing or propelling movable atoms towards a target
/atom/movable/proc/launch_towards(var/atom/target, var/range, var/speed = 0, var/atom/thrower, var/spin, var/launch_type = NORMAL_LAUNCH, var/pass_flags = NO_FLAGS)
	if (!target || !src)
		return

	if (spin)
		animation_spin(5, 1 + min(1, range/20))

	var/old_speed = cur_speed
	cur_speed = Clamp(speed, MIN_SPEED, MAX_SPEED) // Sanity check, also ~1 sec delay between each launch move is not very reasonable
	var/delay = 10/cur_speed - 0.5 // scales delay back to deciseconds for when sleep is called

	throwing = TRUE
	thrower = thrower
	throw_source = get_turf(src)	//store the origin turf

	var/temp_pass_flags = pass_flags
	switch (launch_type)
		if (NORMAL_LAUNCH)
			temp_pass_flags |= (ismob(src) ? PASS_OVER_THROW_MOB : PASS_OVER_THROW_ITEM)
		if (HIGH_LAUNCH)
			temp_pass_flags |= PASS_HIGH_OVER
	flags_pass_temp |= temp_pass_flags

	var/turf/start_turf = get_step_towards(src, target)
	var/list/turf/path = getline2(start_turf, target)
	var/last_loc = loc

	var/dist_travelled = 0
	for (var/turf/T in path)
		if (!src || !throwing || loc != last_loc || !isturf(src.loc))
			break
		if (dist_travelled >= range)
			break
		if (!Move(T)) // IF THIS RETURNS FALSE, THEN THE THROWN OBJECT COLLIDED WITH SOMETHING
			break
		last_loc = loc
		if (++dist_travelled >= range)
			break
		sleep(delay)

	//done throwing, either because it hit something or it finished moving
	if (isobj(src) && throwing)
		launch_impact(get_turf(src))
	if (loc)
		throwing = FALSE
		rebounding = FALSE
		thrower = null
		throw_source = null
		cur_speed = old_speed
		flags_pass_temp &= ~temp_pass_flags


//Overlays
/atom/movable/overlay
	var/atom/master = null
	anchored = 1

/atom/movable/overlay/New()
	..()
	for(var/x in src.verbs)
		src.verbs -= x
	return

/atom/movable/overlay/attackby(a, b)
	if (src.master)
		return src.master.attackby(a, b)
	return

/atom/movable/overlay/attack_hand(a, b, c)
	if (src.master)
		return src.master.attack_hand(a, b, c)
	return






//when a mob interact with something that gives them a special view,
//check_eye() is called to verify that they're still eligible.
//if they are not check_eye() usually reset the mob's view.
/atom/proc/check_eye(mob/user)
	return


/mob/proc/set_interaction(atom/movable/AM)
	if(interactee)
		if(interactee == AM) //already set
			return
		else
			unset_interaction()
	interactee = AM
	if(istype(interactee)) //some stupid code is setting datums as interactee...
		interactee.on_set_interaction(src)


/mob/proc/unset_interaction()
	if(interactee)
		if(istype(interactee))
			interactee.on_unset_interaction(src)
		interactee = null


//things the user's machine must do just after we set the user's machine.
/atom/movable/proc/on_set_interaction(mob/user)
	return


/obj/on_set_interaction(mob/user)
	..()
	in_use = 1


//things the user's machine must do just before we unset the user's machine.
/atom/movable/proc/on_unset_interaction(mob/user)
	return


// Spin for a set amount of time at a set speed using directional states
/atom/movable/proc/spin(var/duration, var/turn_delay = 1, var/clockwise = 0, var/cardinal_only = 1)
	set waitfor = 0

	if (turn_delay < 1)
		return

	var/spin_degree = 90

	if (!cardinal_only)
		spin_degree = 45

	if (clockwise)
		spin_degree *= -1

	while (duration > turn_delay)
		sleep(turn_delay)
		dir = turn(dir, spin_degree)
		duration -= turn_delay

/atom/movable/proc/spin_circle(var/num_circles = 1, var/turn_delay = 1, var/clockwise = 0, var/cardinal_only = 1)
	set waitfor = 0

	if (num_circles < 1 || turn_delay < 1)
		return

	var/spin_degree = 90
	num_circles *= 4

	if (!cardinal_only)
		spin_degree = 45
		num_circles *= 2

	if (clockwise)
		spin_degree *= -1

	for (var/x in 0 to num_circles -1)
		sleep(turn_delay)
		dir = turn(dir, spin_degree)


//called when a mob tries to breathe while inside us.
/atom/movable/proc/handle_internal_lifeform(mob/lifeform_inside_me)
	. = return_air()

///---CLONE---///

/atom/movable/clone
	var/atom/movable/mstr = null //Used by clones for referral
	var/proj_x = 0
	var/proj_y = 0
	unacidable = TRUE

	var/list/image/hud_list

//REDIRECT TO MASTER//
/atom/movable/clone/attack_ai(mob/user)
	return src.mstr.attack_ai(user)

/atom/movable/clone/attack_hand(mob/user)
	return src.mstr.attack_hand(user)

/atom/movable/clone/attack_alien(mob/living/carbon/Xenomorph/M, dam_bonus)
	return src.mstr.attack_alien(M, dam_bonus)

/atom/movable/clone/attack_animal(mob/living/M as mob)
	return src.mstr.attack_animal(M)

/atom/movable/clone/attackby(obj/item/I, mob/living/user)
	return src.mstr.attackby(I, user)

/atom/movable/clone/examine(mob/user)
	return src.mstr.examine(user)

/atom/movable/clone/bullet_act(obj/item/projectile/P)
	return src.mstr.bullet_act(P)
/////////////////////

/atom/movable/proc/create_clone_movable(shift_x, shift_y)
	var/atom/movable/clone/C = new /atom/movable/clone(src.loc)
	C.density = 0
	C.proj_x = shift_x
	C.proj_y = shift_y

	clones.Add(C)
	C.mstr = src //Link clone and master
	src.clone = C

/atom/movable/proc/update_clone()
	///---Var-Copy---////
	clone.x = x + clone.proj_x //Translate clone position by projection factor
	clone.y = y + clone.proj_y //This is done first to reduce movement latency

	clone.anchored 		= anchored //Some of these may be suitable for Init
	clone.appearance 	= appearance
	clone.dir 			= dir
	clone.flags_atom 	= flags_atom
	clone.density 		= density
	clone.layer 		= layer
	clone.level 		= level
	clone.name 			= name
	clone.pixel_x 		= pixel_x
	clone.pixel_y 		= pixel_y
	clone.transform 	= transform
	clone.invisibility 	= invisibility
	////////////////////

	if(light) //Clone lighting
		if(!clone.light)
			clone.SetLuminosity(luminosity) //Create clone light
	else
		if(clone.light)
			clone.SetLuminosity(0) //Kill clone light

/atom/movable/proc/destroy_clone()
	clones.Remove(src.clone)
	qdel(src.clone)
	src.clone = null
