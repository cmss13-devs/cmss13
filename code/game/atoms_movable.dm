/atom/movable
	layer = OBJ_LAYER
	var/last_move_dir = null
	var/anchored = FALSE
	var/drag_delay = 3 //delay (in deciseconds) added to mob's move_delay when pulling it.
	var/l_move_time = 1
	var/throwing = 0
	var/throw_speed = SPEED_FAST // Speed that an atom will go when thrown by a carbon mob
	var/throw_range = 7
	var/cur_speed = MIN_SPEED // Current speed of an atom (account for speed when launched/thrown as well)
	var/mob/pulledby = null
	var/rebounds = FALSE
	var/rebounding = FALSE // whether an object that was launched was rebounded (to prevent infinite recursive loops from wall bouncing)
	var/atom/movable/pulling = null

	var/acid_damage = 0 //Counter for stomach acid damage. At ~60 ticks, dissolved

	var/mob/living/buckled_mob

	var/move_intentionally = FALSE // this is for some deep stuff optimization. This means that it is regular movement that can only be NSWE and you don't need to perform checks on diagonals. ALWAYS reset it back to FALSE when done

	/// How much this mob|object is worth when lowered into the ASRS pit while the black market is unlocked.
	var/black_market_value = 0

	var/datum/component/orbiter/orbiting

	///is the mob currently ascending or descending through z levels?
	var/currently_z_moving

	/// Either FALSE, [EMISSIVE_BLOCK_GENERIC], or [EMISSIVE_BLOCK_UNIQUE]
	var/blocks_emissive = FALSE
	///Internal holder for emissive blocker object, do not use directly use blocks_emissive
	var/atom/movable/emissive_blocker/em_block

	///Lazylist to keep track on the sources of illumination.
	var/list/affected_movable_lights
	///Highest-intensity light affecting us, which determines our visibility.
	var/affecting_dynamic_lumi = 0

	/// Holds a reference to the emissive blocker overlay
	var/emissive_overlay

//===========================================================================
/atom/movable/Destroy(force)
	for(var/atom/movable/I in contents)
		qdel(I)
	if(pulledby)
		pulledby.stop_pulling()
	QDEL_NULL(launch_metadata)
	QDEL_NULL(em_block)
	QDEL_NULL(emissive_overlay)

	if(loc)
		loc.on_stored_atom_del(src) //things that container need to do when a movable atom inside it is deleted
	if(orbiting)
		orbiting.end_orbit(src)
		orbiting = null

	vis_locs = null //clears this atom out of all viscontents
	if(length(vis_contents))
		vis_contents.Cut()
	. = ..()
	moveToNullspace() //so we move into null space. Must be after ..() b/c atom's Dispose handles deleting our lighting stuff

	QDEL_NULL(light)
	QDEL_NULL(static_light)

//===========================================================================

//Overlays
/atom/movable/overlay
	var/atom/master = null
	anchored = TRUE

/atom/movable/overlay/New()
	..()
	verbs.Cut()
	return

/atom/movable/overlay/attackby(a, b)
	if (src.master)
		return src.master.attackby(a, b)
	return

/atom/movable/overlay/attack_hand(a, b, c)
	if (src.master)
		return src.master.attack_hand(a, b, c)
	return

/atom/movable/Initialize(mapload, ...)
	. = ..()

	update_emissive_block()

	if(opacity)
		AddElement(/datum/element/light_blocking)
	if(light_system == MOVABLE_LIGHT)
		AddComponent(/datum/component/overlay_lighting)
	if(light_system == DIRECTIONAL_LIGHT)
		AddComponent(/datum/component/overlay_lighting, is_directional = TRUE)

/atom/movable/proc/update_emissive_block()
	if(emissive_overlay)
		overlays -= emissive_overlay

	switch(blocks_emissive)
		if(EMISSIVE_BLOCK_GENERIC)
			var/mutable_appearance/gen_emissive_blocker = mutable_appearance(icon, icon_state, plane = EMISSIVE_PLANE, alpha = src.alpha)
			gen_emissive_blocker.color = GLOB.em_block_color
			gen_emissive_blocker.dir = dir
			gen_emissive_blocker.appearance_flags |= appearance_flags
			emissive_overlay = gen_emissive_blocker
			overlays += gen_emissive_blocker
		if(EMISSIVE_BLOCK_UNIQUE)
			render_target = ref(src)
			em_block = new(src, render_target)
			emissive_overlay = em_block
			overlays += list(em_block)

/atom/movable/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(VV_HK_EDIT_PARTICLES, "Edit Particles")

/atom/movable/vv_do_topic(list/href_list)
	. = ..()

	if(!.)
		return

	if(href_list[VV_HK_EDIT_PARTICLES] && check_rights(R_VAREDIT))
		var/client/C = usr.client
		C?.open_particle_editor(src)

/atom/movable/vv_edit_var(var_name, var_value)
	var/static/list/banned_edits = list(NAMEOF_STATIC(src, step_x) = TRUE, NAMEOF_STATIC(src, step_y) = TRUE, NAMEOF_STATIC(src, step_size) = TRUE, NAMEOF_STATIC(src, bounds) = TRUE)
	var/static/list/careful_edits = list(NAMEOF_STATIC(src, bound_x) = TRUE, NAMEOF_STATIC(src, bound_y) = TRUE, NAMEOF_STATIC(src, bound_width) = TRUE, NAMEOF_STATIC(src, bound_height) = TRUE)
	var/static/list/not_falsey_edits = list(NAMEOF_STATIC(src, bound_width) = TRUE, NAMEOF_STATIC(src, bound_height) = TRUE)
	if(banned_edits[var_name])
		return FALSE //PLEASE no.
	if(careful_edits[var_name] && (var_value % world.icon_size) != 0)
		return FALSE
	if(not_falsey_edits[var_name] && !var_value)
		return FALSE

	if(!isnull(.))
		datum_flags |= DF_VAR_EDITED
		return

	return ..()

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
/atom/movable/proc/spin(duration, turn_delay = 1, clockwise = 0, cardinal_only = 1)
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
		setDir(turn(dir, spin_degree))
		duration -= turn_delay

/atom/movable/proc/spin_circle(num_circles = 1, turn_delay = 1, clockwise = 0, cardinal_only = 1)
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
		setDir(turn(dir, spin_degree))


/**
 * meant for movement with zero side effects. only use for objects that are supposed to move "invisibly" (like camera mobs or ghosts)
 * if you want something to move onto a tile with a beartrap or recycler or tripmine or mouse without that object knowing about it at all, use this
 * most of the time you want forceMove()
 */
/atom/movable/proc/abstract_move(atom/new_loc)
	var/atom/old_loc = loc
	loc = new_loc
	Moved(old_loc)

//called when a mob tries to breathe while inside us.
/atom/movable/proc/handle_internal_lifeform(mob/lifeform_inside_me)
	. = return_air()

//---CLONE---//

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

/atom/movable/clone/attack_alien(mob/living/carbon/xenomorph/M, dam_bonus)
	return src.mstr.attack_alien(M, dam_bonus)

/atom/movable/clone/attack_animal(mob/living/M as mob)
	return src.mstr.attack_animal(M)

/atom/movable/clone/attackby(obj/item/I, mob/living/user)
	return src.mstr.attackby(I, user)

/atom/movable/clone/get_examine_text(mob/user)
	return src.mstr.get_examine_text(user)

/atom/movable/clone/bullet_act(obj/projectile/P)
	return src.mstr.bullet_act(P)
/////////////////////

/atom/movable/proc/create_clone_movable(shift_x, shift_y)
	var/atom/movable/clone/C = new /atom/movable/clone(src.loc)
	C.density = FALSE
	C.proj_x = shift_x
	C.proj_y = shift_y

	GLOB.clones.Add(C)
	C.mstr = src //Link clone and master
	src.clone = C

/atom/movable/proc/update_clone()
	///---Var-Copy---////
	clone.forceMove(locate(x + clone.proj_x, y + clone.proj_y, z))
	//Translate clone position by projection factor
	//This is done first to reduce movement latency

	clone.anchored = anchored //Some of these may be suitable for Init
	clone.appearance = appearance
	clone.dir = dir
	clone.flags_atom = flags_atom
	clone.density = density
	clone.layer = layer
	clone.level = level
	clone.name = name
	clone.pixel_x = pixel_x
	clone.pixel_y = pixel_y
	clone.transform = transform
	clone.invisibility = invisibility
	////////////////////

	if(light) //Clone lighting
		if(!clone.light)
			clone.set_light(luminosity) //Create clone light
	else
		if(clone.light)
			clone.set_light(0) //Kill clone light

/atom/movable/proc/destroy_clone()
	GLOB.clones.Remove(src.clone)
	qdel(src.clone)
	src.clone = null

/**
* A wrapper for setDir that should only be able to fail by living mobs.
*
* Called from [/atom/movable/proc/keyLoop], this exists to be overwritten by living mobs with a check to see if we're actually alive enough to change directions
*/
/atom/movable/proc/keybind_face_direction(direction)
	setDir(direction)

/atom/movable/proc/onTransitZ(old_z,new_z)
	SEND_SIGNAL(src, COMSIG_MOVABLE_Z_CHANGED, old_z, new_z)
	for(var/item in src) // Notify contents of Z-transition. This can be overridden IF we know the items contents do not care.
		var/atom/movable/AM = item
		AM.onTransitZ(old_z,new_z)

/atom/movable/proc/safe_throw_at(atom/target, range, speed, mob/thrower, spin = TRUE)
	//if((force < (move_resist * MOVE_FORCE_THROW_RATIO)) || (move_resist == INFINITY))
	// return
	return throw_atom(target, range, speed, thrower, spin)

///Keeps track of the sources of dynamic luminosity and updates our visibility with the highest.
/atom/movable/proc/update_dynamic_luminosity()
	var/highest = 0
	for(var/i in affected_movable_lights)
		if(affected_movable_lights[i] <= highest)
			continue
		highest = affected_movable_lights[i]
	if(highest == affecting_dynamic_lumi)
		return
	luminosity -= affecting_dynamic_lumi
	affecting_dynamic_lumi = highest
	luminosity += affecting_dynamic_lumi


///Helper to change several lighting overlay settings.
/atom/movable/proc/set_light_range_power_color(range, power, color)
	set_light_range(range)
	set_light_power(power)
	set_light_color(color)

/*
 * The core multi-z movement proc. Used to move a movable through z levels.
 * If target is null, it'll be determined by the can_z_move proc, which can potentially return null if
 * conditions aren't met (see z_move_flags defines in __DEFINES/movement.dm for info) or if dir isn't set.
 * Bear in mind you don't need to set both target and dir when calling this proc, but at least one or two.
 * This will set the currently_z_moving to CURRENTLY_Z_MOVING_GENERIC if unset, and then clear it after
 * Forcemove().
 *
 *
 * Args:
 * * dir: the direction to go, UP or DOWN, only relevant if target is null.
 * * target: The target turf to move the src to. Set by can_z_move() if null.
 * * z_move_flags: bitflags used for various checks in both this proc and can_z_move(). See __DEFINES/movement.dm.
 */
/// Sets the currently_z_moving variable to a new value. Used to allow some zMovement sources to have precedence over others.
/atom/movable/proc/set_currently_z_moving(new_z_moving_value, forced = FALSE)
	if(forced)
		currently_z_moving = new_z_moving_value
		return TRUE
	var/old_z_moving_value = currently_z_moving
	currently_z_moving = max(currently_z_moving, new_z_moving_value)
	return currently_z_moving > old_z_moving_value

/atom/movable/proc/zMove(dir, turf/target, z_move_flags = ZMOVE_FLIGHT_FLAGS)
	if(!target)
		target = can_z_move(dir, get_turf(src), null, z_move_flags)
		if(!target)
			set_currently_z_moving(FALSE, TRUE)
			return FALSE

	var/list/moving_movs = get_z_move_affected(z_move_flags)

	for(var/atom/movable/movable as anything in moving_movs)
		movable.currently_z_moving = currently_z_moving || CURRENTLY_Z_MOVING_GENERIC
		movable.forceMove(target)
		movable.set_currently_z_moving(FALSE, TRUE)
	// This is run after ALL movables have been moved, so pulls don't get broken unless they are actually out of range.
	if(z_move_flags & ZMOVE_CHECK_PULLS)
		for(var/atom/movable/moved_mov as anything in moving_movs)
			if(z_move_flags & ZMOVE_CHECK_PULLEDBY && moved_mov.pulledby && (moved_mov.z != moved_mov.pulledby.z || get_dist(moved_mov, moved_mov.pulledby) > 1))
				moved_mov.pulledby.stop_pulling()
			if(z_move_flags & ZMOVE_CHECK_PULLING)
				var/atom/movable/pullee = moved_mov.pulling
				if(pullee && (get_dist(src, pullee) > 1 || pullee.anchored || (!isturf(pulling.loc) && pullee.loc != loc))) //Is the pullee adjacent?
					moved_mov.stop_pulling()
	return TRUE

/// Returns a list of movables that should also be affected when src moves through zlevels, and src.
/atom/movable/proc/get_z_move_affected(z_move_flags)
	. = list(src)
	if(buckled_mob)
		. |= buckled_mob
	if(!(z_move_flags & ZMOVE_INCLUDE_PULLED))
		return
	for(var/mob/living/buckled as anything in buckled_mob)
		if(buckled.pulling)
			. |= buckled.pulling
	if(pulling)
		. |= pulling

/**
 * Checks if the destination turf is elegible for z movement from the start turf to a given direction and returns it if so.
 * Args:
 * * direction: the direction to go, UP or DOWN, only relevant if target is null.
 * * start: Each destination has a starting point on the other end. This is it. Most of the times the location of the source.
 * * z_move_flags: bitflags used for various checks. See __DEFINES/movement.dm.
 * * rider: A living mob in control of the movable. Only non-null when a mob is riding a vehicle through z-levels.
 */
/atom/movable/proc/can_z_move(direction, turf/start, turf/destination, z_move_flags = ZMOVE_FLIGHT_FLAGS, mob/living/rider)
	if(!start)
		start = get_turf(src)
		if(!start)
			return FALSE
	if(!direction)
		if(!destination)
			return FALSE
		direction = get_dir_multiz(start, destination)
	if(direction != UP && direction != DOWN)
		return FALSE
	if(!destination)
		destination = get_step_multiz(start, direction)
		if(!destination)
			if(z_move_flags & ZMOVE_FEEDBACK)
				to_chat(rider || src, SPAN_WARNING("There's nowhere to go in that direction!"))
			return FALSE
	if(z_move_flags & ZMOVE_FALL_CHECKS && throwing)
		return FALSE
	if(z_move_flags & ZMOVE_CAN_FLY_CHECKS)
		if(z_move_flags & ZMOVE_FEEDBACK)
			if(rider)
				to_chat(rider, SPAN_WARNING("[src] it is not capable of flight."))
			else
				to_chat(src, SPAN_WARNING("You are not Superman."))
		return FALSE
	if(istype(src, /obj/vehicle))
		z_move_flags |= ZMOVE_ALLOW_ANCHORED
	if(!(z_move_flags & ZMOVE_IGNORE_OBSTACLES) && !(start.zPassOut(src, direction, destination, (z_move_flags & ZMOVE_ALLOW_ANCHORED)) && destination.zPassIn(src, direction, start)))
		if(z_move_flags & ZMOVE_FEEDBACK)
			to_chat(rider || src, SPAN_WARNING("You couldn't move there!"))
		return FALSE
	return destination //used by some child types checks and zMove()

/atom/movable/proc/onZImpact(turf/impacted_turf, levels, message = TRUE)
	if(message)
		visible_message(SPAN_DANGER("[src] crashes into [impacted_turf]!"))
/* TODO (MULTIZ): Make something to deal with it, like teammates catches (CATCH ME THEN!) or damage dealing
	var/atom/highest = impacted_turf
	for(var/atom/hurt_atom as anything in impacted_turf.contents)
		if(!hurt_atom.density)
			continue
		if(isobj(hurt_atom) || ismob(hurt_atom))
			if(hurt_atom.layer > highest.layer)
				highest = hurt_atom
*/
	INVOKE_ASYNC(src, PROC_REF(SpinAnimation), 5, 2)
	return TRUE
