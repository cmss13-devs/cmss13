/atom/movable
	layer = OBJ_LAYER
	var/last_move_dir = null
	var/anchored = 0
	var/drag_delay = 3 //delay (in deciseconds) added to mob's move_delay when pulling it.
	var/l_move_time = 1
	var/throwing = 0
	var/atom/thrower = null
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
/atom/movable/Destroy()
	for(var/atom/movable/I in contents)
		qdel(I)
	if(pulledby)
		pulledby.stop_pulling()
	QDEL_NULL(launch_metadata)

	if(loc)
		loc.on_stored_atom_del(src) //things that container need to do when a movable atom inside it is deleted
	vis_contents.Cut()
	. = ..()
	moveToNullspace() //so we move into null space. Must be after ..() b/c atom's Dispose handles deleting our lighting stuff

//===========================================================================

//Overlays
/atom/movable/overlay
	var/atom/master = null
	anchored = 1

/atom/movable/overlay/New()
	..()
	remove_verb(src, verbs)
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
/atom/movable/clone/attack_remote(mob/user)
	return src.mstr.attack_remote(user)

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
	clone.forceMove(locate(x + clone.proj_x, y + clone.proj_y, z))
	//Translate clone position by projection factor
	//This is done first to reduce movement latency

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
