/*
/turf

	/open - all turfs with density = FALSE are turf/open

		/floor - floors are constructed floor as opposed to natural grounds

		/space

		/shuttle - shuttle floors are separated from real floors because they're magic

		/snow - snow is one type of non-floor open turf

	/closed - all turfs with density = TRUE are turf/closed

		/wall - walls are constructed walls as opposed to natural solid turfs

			/r_wall

		/shuttle - shuttle walls are separated from real walls because they're magic, and don't smoothes with walls.

		/ice_rock - ice_rock is one type of non-wall closed turf

*/


/turf
	icon = 'icons/turf/floors/floors.dmi'
	vis_flags = VIS_INHERIT_PLANE|VIS_INHERIT_ID

	var/base_icon

	///Blending
	var/list/wall_connections = list("0", "0", "0", "0")
	var/neighbors_list = 0
	var/special_icon = TRUE
	var/list/blend_turfs = list()
	var/list/noblend_turfs = list() //Turfs to avoid blending with
	var/list/blend_objects = list() // Objects which to blend with
	var/list/noblend_objects = list() //Objects to avoid blending with (such as children of listed blend objects.

	var/intact_tile = 1 //used by floors to distinguish floor with/without a floortile(e.g. plating).
	var/can_bloody = TRUE //Can blood spawn on this turf?
	var/list/linked_pylons
	var/obj/effect/alien/weeds/weeds

	var/list/datum/automata_cell/autocells
	/**
	 * Associative list of cleanable types (strings) mapped to
	 * cleanable objects
	 *
	 * The cleanable object does not necessarily need to be
	 * on the turf, it can simply be for handling how the
	 * overlays or placing new cleanables of the same type work
	 */
	var/list/obj/effect/decal/cleanable/cleanables

	var/antipierce = 2

	var/list/baseturfs = /turf/baseturf_bottom
	var/changing_turf = FALSE
	var/chemexploded = FALSE // Prevents explosion stacking

	/// 1 = Can't be deconstructed by tools or thermite. Used for Sulaco walls
	var/hull_tile = 0

	var/turf_flags = NO_FLAGS

	// Fishing
	var/supports_fishing = FALSE // set to false when MRing, this is just for testing

	///Lumcount added by sources other than lighting datum objects, such as the overlay lighting component.
	var/dynamic_lumcount = 0

	///List of light sources affecting this turf.
	///Which directions does this turf block the vision of, taking into account both the turf's opacity and the movable opacity_sources.
	var/directional_opacity = NONE
	///Lazylist of movable atoms providing opacity sources.
	var/list/atom/movable/opacity_sources

	///hybrid lights affecting this turf
	var/tmp/list/atom/movable/lighting_mask/hybrid_lights_affecting

/turf/Initialize(mapload)
	SHOULD_CALL_PARENT(FALSE) // this doesn't parent call for optimisation reasons
	if(flags_atom & INITIALIZED)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	flags_atom |= INITIALIZED

	// by default, vis_contents is inherited from the turf that was here before
	vis_contents.Cut()

	GLOB.turfs += src


	assemble_baseturfs()

	levelupdate()

	pass_flags = GLOB.pass_flags_cache[type]
	if (isnull(pass_flags))
		pass_flags = new()
		initialize_pass_flags(pass_flags)
		GLOB.pass_flags_cache[type] = pass_flags
	else
		initialize_pass_flags()

	for(var/atom/movable/AM in src)
		Entered(AM)

	if(light_power && light_range)
		update_light()

	if(opacity)
		directional_opacity = ALL_CARDINALS

	if(mapload)
		return INITIALIZE_HINT_LATELOAD
	else
		//Get area light
		var/area/current_area = loc
		if(current_area?.lighting_effect)
			overlays += current_area.lighting_effect
		multiz_turfs()
		if(!special_icon)
			update_connections(TRUE)
		update_icon()
	return INITIALIZE_HINT_NORMAL

/turf/LateInitialize()
	SHOULD_CALL_PARENT(FALSE)
	//Get area light
	var/area/current_area = loc
	if(current_area?.lighting_effect)
		overlays += current_area.lighting_effect
	multiz_turfs()
	if(!special_icon)
		update_connections(FALSE)
	update_icon()

/turf/Destroy(force)
	var/turf/T = SSmapping.get_turf_above(src)
	if(T)
		T.multiz_turf_del(src, DOWN)
	T = SSmapping.get_turf_below(src)
	if(T)
		T.multiz_turf_del(src, UP)

	if(hybrid_lights_affecting)
		for(var/atom/movable/lighting_mask/mask as anything in hybrid_lights_affecting)
			LAZYREMOVE(mask.affecting_turfs, src)
		hybrid_lights_affecting.Cut()

	. = QDEL_HINT_IWILLGC
	if(!changing_turf)
		stack_trace("Incorrect turf deletion")
	changing_turf = FALSE
	for(var/cleanable_type in cleanables)
		var/obj/effect/decal/cleanable/C = cleanables[cleanable_type]
		C.cleanup_cleanable()
	if(force)
		..()
		//this will completely wipe turf state
		var/turf/B = new world.turf(src)
		for(var/A in B.contents)
			qdel(A)
		for(var/I in B.vars)
			B.vars[I] = null
		return
	flags_atom &= ~INITIALIZED
	..()

/turf/setDir(newDir)
	..()
	update_connections(FALSE)
	update_icon()

/turf/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(VV_HK_EXPLODE, "Trigger Explosion")
	VV_DROPDOWN_OPTION(VV_HK_EMPULSE, "Trigger EM Pulse")

/turf/vv_edit_var(var_name, new_value)
	var/static/list/banned_edits = list(NAMEOF_STATIC(src, x), NAMEOF_STATIC(src, y), NAMEOF_STATIC(src, z))
	if(var_name in banned_edits)
		return FALSE
	. = ..()

/turf/proc/update_overlays()
	if(QDELETED(src))
		return

/turf/ex_act(severity)
	return 0

/// Call to move a turf from its current area to a new one
/turf/proc/change_area(area/old_area, area/new_area)
	//dont waste our time
	if(old_area == new_area)
		return

	//move the turf
	new_area.contents += src

	//changes to make after turf has moved
	on_change_area(old_area, new_area)

/// Allows for reactions to an area change without inherently requiring change_area() be called (I hate maploading)
/turf/proc/on_change_area(area/old_area, area/new_area)
	transfer_area_lighting(old_area, new_area)

/turf/proc/multiz_turf_del(turf/source, direction)
	if(turf_flags & TURF_TRANSPARENT)
		if(direction == DOWN)
			update_multi_z()
	if(direction == UP && !(source.turf_flags & TURF_TRANSPARENT) && !(turf_flags & TURF_TRANSPARENT))
		vis_contents -= GLOB.openspace_shadow_one_for_all
	SEND_SIGNAL(src, COMSIG_TURF_MULTIZ_DEL, source, direction)

/turf/proc/multiz_turf_new(turf/source, direction)
	if(turf_flags & TURF_TRANSPARENT)
		if(direction == DOWN)
			update_multi_z()
	if(direction == UP && !(source.turf_flags & TURF_TRANSPARENT) && !(turf_flags & TURF_TRANSPARENT))
		vis_contents |= GLOB.openspace_shadow_one_for_all
	SEND_SIGNAL(src, COMSIG_TURF_MULTIZ_NEW, source, direction)

/turf/proc/multiz_turfs()
	var/turf/turf_inform = SSmapping.get_turf_above(src)
	if(turf_inform)
		turf_inform.multiz_turf_new(src, DOWN)
		if(!(turf_inform.turf_flags & TURF_TRANSPARENT) && !(turf_flags & TURF_TRANSPARENT))
			vis_contents |= GLOB.openspace_shadow_one_for_all
		if(!(turf_inform.turf_flags & TURF_NO_MULTIZ_SUPPORT) && !(turf_flags & TURF_NO_MULTIZ_SUPPORT))
			if(!(/turf/open/openspace in turf_inform.baseturfs))
				var/list/baseturfsold = list(/turf/open/openspace)
				baseturfsold |= turf_inform.baseturfs
				turf_inform.baseturfs = baseturfsold - turf_inform.type

	turf_inform = SSmapping.get_turf_below(src)
	if(turf_inform)
		turf_inform.multiz_turf_new(src, UP)
		if(!(turf_inform.turf_flags & TURF_NO_MULTIZ_SUPPORT) && !(turf_flags & TURF_NO_MULTIZ_SUPPORT))
			var/list/baseturfsold = list(/turf/open/openspace)
			baseturfsold |= baseturfs
			baseturfs = baseturfsold - turf_inform.type

/turf/proc/add_cleanable_overlays()
	for(var/cleanable_type in cleanables)
		var/obj/effect/decal/cleanable/C = cleanables[cleanable_type]
		if(C.overlayed_image)
			overlays += C.overlayed_image

/turf/proc/loc_to_string()
	var/text
	text = " ( [x], [y], [z])"// Desc is the <area name> (x, y)
	return text

/turf/process()
	return

// Handles whether an atom is able to enter the src turf
/turf/Enter(atom/movable/mover, atom/forget)
	if (!mover || !isturf(mover.loc))
		return FALSE

	var/override = SEND_SIGNAL(mover, COMSIG_MOVABLE_TURF_ENTER, src)
	override |= SEND_SIGNAL(src, COMSIG_TURF_ENTER, mover)
	if(override)
		return override & COMPONENT_TURF_ALLOW_MOVEMENT

	if(isobserver(mover) || istype(mover, /obj/projectile))
		return TRUE

	var/fdir = get_dir(mover, src)
	if (!fdir)
		return TRUE

	var/fd1 = fdir&(fdir-1) // X-component if fdir diagonal, 0 otherwise
	var/fd2 = fdir - fd1 // Y-component if fdir diagonal, fdir otherwise

	var/blocking_dir = 0 // The directions that the mover's path is being blocked by

	var/obstacle
	var/turf/T
	var/atom/A

	T = mover.loc
	blocking_dir |= T.BlockedExitDirs(mover, fdir)
	if ((!fd1 || blocking_dir & fd1) && (!fd2 || blocking_dir & fd2))
		mover.Collide(T)
		return FALSE
	for (obstacle in T) //First, check objects to block exit
		if (mover == obstacle || forget == obstacle)
			continue
		A = obstacle
		if (!istype(A) || !A.can_block_movement)
			continue
		blocking_dir |= A.BlockedExitDirs(mover, fdir)
		if ((!fd1 || blocking_dir & fd1) && (!fd2 || blocking_dir & fd2))
			mover.Collide(A)
			return FALSE

	for(var/atom/movable/thing as anything in contents)
		if(thing == mover || thing == mover.loc) // Multi tile objects and moving out of other objects
			continue
		thing.Cross(mover)

		// if we are thrown, moved, dragged, or in any other way abused by code - check our diagonals
	if(!mover.move_intentionally)
		// Check objects in adjacent turf EAST/WEST
		if(fd1 && fd1 != fdir)
			T = get_step(mover, fd1)
			if (T.BlockedExitDirs(mover, fd2) || T.BlockedPassDirs(mover, fd1))
				blocking_dir |= fd1
				if ((!fd1 || blocking_dir & fd1) && (!fd2 || blocking_dir & fd2))
					mover.Collide(T)
					return FALSE
			for(obstacle in T)
				if(forget == obstacle)
					continue
				A = obstacle
				if (!istype(A) || !A.can_block_movement)
					continue
				if (A.BlockedExitDirs(mover, fd2) || A.BlockedPassDirs(mover, fd1))
					blocking_dir |= fd1
					if ((!fd1 || blocking_dir & fd1) && (!fd2 || blocking_dir & fd2))
						mover.Collide(A)
						return FALSE

		// Check for borders in adjacent turf NORTH/SOUTH
		if(fd2 && fd2 != fdir)
			T = get_step(mover, fd2)
			if (T.BlockedExitDirs(mover, fd1) || T.BlockedPassDirs(mover, fd2))
				blocking_dir |= fd2
				if ((!fd1 || blocking_dir & fd1) && (!fd2 || blocking_dir & fd2))
					mover.Collide(T)
					return FALSE
			for(obstacle in T)
				if(forget == obstacle)
					continue
				A = obstacle
				if (!istype(A) || !A.can_block_movement)
					continue
				if (A.BlockedExitDirs(mover, fd1) || A.BlockedPassDirs(mover, fd2))
					blocking_dir |= fd2
					if ((!fd1 || blocking_dir & fd1) && (!fd2 || blocking_dir & fd2))
						mover.Collide(A)
						return FALSE
					break

	//Next, check the turf itself
	blocking_dir |= BlockedPassDirs(mover, fdir)
	if ((!fd1 || blocking_dir & fd1) && (!fd2 || blocking_dir & fd2))
		mover.Collide(src)
		return FALSE
	for(obstacle in src) //Then, check atoms in the target turf
		if(forget == obstacle)
			continue
		A = obstacle
		if (!istype(A) || !A.can_block_movement)
			continue
		blocking_dir |= A.BlockedPassDirs(mover, fdir)
		if ((!fd1 || blocking_dir & fd1) && (!fd2 || blocking_dir & fd2))
			if(!mover.Collide(A))
				return FALSE

	return TRUE //Nothing found to block so return success!

/turf/Entered(atom/movable/arrived, old_loc, list/old_locs)
	if(!istype(arrived))
		return

	SEND_SIGNAL(src, COMSIG_TURF_ENTERED, arrived, old_loc)
	SEND_SIGNAL(arrived, COMSIG_MOVABLE_TURF_ENTERED, src)

	// Let explosions know that the atom entered
	for(var/datum/automata_cell/explosion/E in autocells)
		E.on_turf_entered(arrived)
	return TRUE

//zPassIn doesn't necessarily pass an atom!
//direction is direction of travel of air
/turf/proc/zPassIn(atom/movable/A, direction, turf/source)
	return FALSE

//direction is direction of travel of air
/turf/proc/zPassOut(atom/movable/A, direction, turf/destination, allow_anchored_movement)
	return FALSE

/// Precipitates a movable (plus whatever buckled to it) to lower z levels if possible and then calls zImpact()
/turf/proc/zFall(atom/movable/falling, levels = 1, force = FALSE, falling_from_move = FALSE)
	var/direction = DOWN
	var/turf/target = get_step_multiz(src, direction)
	if(!target)
		return FALSE
	var/isliving = isliving(falling)
	if(!isliving && !isobj(falling))
		return
	if(isliving)
		var/mob/living/falling_living = falling
		//relay this mess to whatever the mob is buckled to.
		if(falling_living.buckled)
			falling = falling_living.buckled
	if(!falling_from_move && falling.currently_z_moving)
		return
	if(!force && !falling.can_z_move(direction, src, target, ZMOVE_FALL_FLAGS))
		falling.set_currently_z_moving(FALSE, TRUE)
		return FALSE

	// So it doesn't trigger other zFall calls. Cleared on zMove.
	falling.set_currently_z_moving(CURRENTLY_Z_FALLING)

	if(falling.can_paradrop() && levels > 2)
		playsound(get_turf(falling), "rustle", 50, 1, 6)

	if(istype(falling, /mob))
		var/mob/mob = falling
		mob.trainteleport(target)
	else
		falling.zMove(null, target, ZMOVE_CHECK_PULLEDBY)
	target.zImpact(falling, levels, src)

///Called each time the target falls down a z level possibly making their trajectory come to a halt. see __DEFINES/movement.dm.
/turf/proc/zImpact(atom/movable/falling, levels = 1, turf/prev_turf)
	var/flags_fall = NO_FLAGS
	var/list/falling_movables = falling.get_z_move_affected()
	var/list/falling_mov_names
	for(var/atom/movable/falling_mov as anything in falling_movables)
		falling_mov_names += falling_mov.name
	for(var/i in contents)
		var/atom/thing = i
		flags_fall |= thing.intercept_zImpact(falling_movables, levels)
		if(flags_fall & FALL_STOP_INTERCEPTING)
			break
	if(prev_turf && !(flags_fall & FALL_NO_MESSAGE))
		for(var/mov_name in falling_mov_names)
			prev_turf.visible_message(SPAN_DANGER("[mov_name] falls through [prev_turf]!"))
	if(!(flags_fall & FALL_INTERCEPTED) && zFall(falling, levels + 1))
		return FALSE
	for(var/atom/movable/falling_mov as anything in falling_movables)
		if(!(flags_fall & FALL_RETAIN_PULL))
			falling_mov.stop_pulling()
		if(!(flags_fall & FALL_INTERCEPTED))
			falling_mov.onZImpact(src, levels)
		if(falling_mov.pulledby && (falling_mov.z != falling_mov.pulledby.z || get_dist(falling_mov, falling_mov.pulledby) > 1))
			falling_mov.pulledby.stop_pulling()
	return TRUE

/turf/proc/is_plating()
	return 0
/turf/proc/is_asteroid_floor()
	return 0
/turf/proc/is_plasteel_floor()
	return 0
/turf/proc/is_light_floor()
	return 0
/turf/proc/is_grass_floor()
	return 0
/turf/proc/is_wood_floor()
	return 0
/turf/proc/is_carpet_floor()
	return 0
/turf/proc/return_siding_icon_state() //used for grass floors, which have siding.
	return 0

/turf/proc/inertial_drift(atom/movable/A as mob|obj)
	if(A.anchored)
		return
	if(!(A.last_move_dir)) return
	if((istype(A, /mob/) && src.x > 2 && src.x < (world.maxx - 1) && src.y > 2 && src.y < (world.maxy-1)))
		var/mob/M = A
		if(M.Process_Spacemove(1))
			M.inertia_dir  = 0
			return
		spawn(5)
			if((M && !(M.anchored) && !(M.pulledby) && (M.loc == src)))
				if(M.inertia_dir)
					step(M, M.inertia_dir)
					return
				M.inertia_dir = M.last_move_dir
				step(M, M.inertia_dir)
	return

/turf/proc/levelupdate()
	for(var/obj/O in src)
		if(O.level == 1)
			O.hide(intact_tile)

// A proc in case it needs to be recreated or badmins want to change the baseturfs
/turf/proc/assemble_baseturfs(turf/fake_baseturf_type)
	var/static/list/created_baseturf_lists = list()
	var/turf/current_target
	if(fake_baseturf_type)
		if(length(fake_baseturf_type)) // We were given a list, just apply it and move on
			baseturfs = fake_baseturf_type
			return
		current_target = fake_baseturf_type
	else
		if(length(baseturfs))
			return // No replacement baseturf has been given and the current baseturfs value is already a list/assembled
		if(!baseturfs)
			current_target = initial(baseturfs) || type // This should never happen but just in case...
			stack_trace("baseturfs var was null for [type]. Failsafe activated and it has been given a new baseturfs value of [current_target].")
		else
			current_target = baseturfs

	// If we've made the output before we don't need to regenerate it
	if(created_baseturf_lists[current_target])
		var/list/premade_baseturfs = created_baseturf_lists[current_target]
		if(length(premade_baseturfs))
			baseturfs = premade_baseturfs.Copy()
		else
			baseturfs = premade_baseturfs
		return baseturfs

	var/turf/next_target = initial(current_target.baseturfs)
	//Most things only have 1 baseturf so this loop won't run in most cases
	if(current_target == next_target)
		baseturfs = current_target
		created_baseturf_lists[current_target] = current_target
		return current_target
	var/list/new_baseturfs = list(current_target)
	for(var/i=0;current_target != next_target;i++)
		if(i > 100)
			// A baseturfs list over 100 members long is silly
			// Because of how this is all structured it will only runtime/message once per type
			stack_trace("A turf <[type]> created a baseturfs list over 100 members long. This is most likely an infinite loop.")
			message_admins("A turf <[type]> created a baseturfs list over 100 members long. This is most likely an infinite loop.")
			break
		new_baseturfs.Insert(1, next_target)
		current_target = next_target
		next_target = initial(current_target.baseturfs)

	baseturfs = new_baseturfs
	created_baseturf_lists[new_baseturfs[length(new_baseturfs)]] = new_baseturfs.Copy()
	return new_baseturfs

// Creates a new turf
// new_baseturfs can be either a single type or list of types, formated the same as baseturfs. see turf.dm
/turf/proc/ChangeTurf(path, list/new_baseturfs, flags)
	switch(path)
		if(null)
			return
		if(/turf/baseturf_bottom)
			path = SSmapping.level_trait(z, ZTRAIT_BASETURF) || /turf/open/space
		if(/turf/open/space/basic)
			path = /turf/open/space

	//if(src.type == new_turf_path) // Put this back if shit starts breaking
	// return src

	var/pylons = linked_pylons
	var/old_weeds = weeds

	var/list/old_baseturfs = baseturfs

	var/old_dynamic_lumcount = dynamic_lumcount

	//static lighting
	var/old_lighting_object = static_lighting_object
	var/old_lighting_corner_NE = lighting_corner_NE
	var/old_lighting_corner_SE = lighting_corner_SE
	var/old_lighting_corner_SW = lighting_corner_SW
	var/old_lighting_corner_NW = lighting_corner_NW
	//hybrid lighting
	var/list/old_hybrid_lights_affecting = hybrid_lights_affecting?.Copy()
	var/old_directional_opacity = directional_opacity

	changing_turf = TRUE
	qdel(src) //Just get the side effects and call Destroy
	var/turf/W = new path(src)

	for(var/i in W.contents)
		var/datum/A = i
		SEND_SIGNAL(A, COMSIG_ATOM_TURF_CHANGE, src)

	W.linked_pylons = pylons
	W.weeds = old_weeds

	if(new_baseturfs)
		W.baseturfs = new_baseturfs
	else
		W.baseturfs = old_baseturfs

	W.hybrid_lights_affecting = old_hybrid_lights_affecting
	W.dynamic_lumcount = old_dynamic_lumcount

	lighting_corner_NE = old_lighting_corner_NE
	lighting_corner_SE = old_lighting_corner_SE
	lighting_corner_SW = old_lighting_corner_SW
	lighting_corner_NW = old_lighting_corner_NW

	//static Update
	if(SSlighting.initialized)
		recalculate_directional_opacity()

		W.static_lighting_object = old_lighting_object

		if(static_lighting_object && !static_lighting_object.needs_update)
			static_lighting_object.update()

	//Since the old turf was removed from hybrid_lights_affecting, readd the new turf here
	if(W.hybrid_lights_affecting)
		for(var/atom/movable/lighting_mask/mask as anything in W.hybrid_lights_affecting)
			LAZYADD(mask.affecting_turfs, W)

	if(W.directional_opacity != old_directional_opacity)
		W.reconsider_lights()

	var/area/thisarea = get_area(W)
	if(thisarea.lighting_effect)
		W.overlays += thisarea.lighting_effect

	W.levelupdate()
	multiz_turfs()
	return W

//If you modify this function, ensure it works correctly with lateloaded map templates.
/turf/proc/AfterChange(flags, oldType) //called after a turf has been replaced in ChangeTurf()
	return // Placeholder. This is mostly used by /tg/ code for atmos updates

// Take off the top layer turf and replace it with the next baseturf down
/turf/proc/ScrapeAway(amount=1, flags)
	if(!amount)
		return
	if(length(baseturfs))
		var/list/new_baseturfs = baseturfs.Copy()
		var/turf_type = new_baseturfs[max(1, length(new_baseturfs) - amount + 1)]
		while(ispath(turf_type, /turf/baseturf_skipover))
			amount++
			if(amount > length(new_baseturfs))
				CRASH("The bottomost baseturf of a turf is a skipover [src]([type])")
			turf_type = new_baseturfs[max(1, length(new_baseturfs) - amount + 1)]
		new_baseturfs.len -= min(amount, length(new_baseturfs) - 1) // No removing the very bottom
		if(length(new_baseturfs) == 1)
			new_baseturfs = new_baseturfs[1]
		return ChangeTurf(turf_type, new_baseturfs, flags)

	if(baseturfs == type)
		return src

	return ChangeTurf(baseturfs, baseturfs, flags) // The bottom baseturf will never go away

/turf/proc/ReplaceWithLattice()
	src.ChangeTurf(/turf/open/space)
	new /obj/structure/lattice( locate(src.x, src.y, src.z) )

/turf/proc/AdjacentTurfs()
	var/L[] = new()
	FOR_DOVIEW(var/turf/t, 1, src, HIDE_INVISIBLE_OBSERVER)
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				L.Add(t)
	FOR_DOVIEW_END
	return L

/turf/proc/AdjacentTurfsSpace()
	var/L[] = new()
	FOR_DOVIEW(var/turf/t, 1, src, HIDE_INVISIBLE_OBSERVER)
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				L.Add(t)
	FOR_DOVIEW_END
	return L

/turf/proc/Distance(turf/t)
	if(get_dist(src,t) == 1)
		var/cost = (src.x - t.x) * (src.x - t.x) + (src.y - t.y) * (src.y - t.y)
		return cost
	else
		return get_dist(src,t)


//for xeno corrosive acid, 0 for unmeltable, 1 for regular, 2 for strong walls that require strong acid and more time.
/turf/proc/can_be_dissolved()
	return 0

/turf/proc/air_strike(protection_penetration, turf/target_turf, landing_type = 0, checking = FALSE)
	if(landing_type == 1 && src == target_turf)
		return src

	var/turf/turf_above = SSmapping.get_turf_above(src)
	if(protection_penetration <= 0)
		if(turf_above)
			return turf_above
		return src

	if(!checking)
		if(turf_above && !istype(turf_above, /turf/open/openspace))
			if(landing_type == 2)
				return turf_above
			if(!turf_above.hull_tile)
				turf_above.ceiling_debris(protection_penetration)
				turf_above.ChangeTurf(/turf/open/openspace)

	protection_penetration -= get_pylon_protection_level()
	if(hull_tile)
		protection_penetration -= 10
	else
		protection_penetration -= antipierce

	var/turf/turf_below = SSmapping.get_turf_below(src)
	if(!turf_below)
		return src
	else
		return turf_below.air_strike(protection_penetration, target_turf, checking, landing_type)

/turf/proc/ceiling_debris_check(size = 1)
	return

/turf/proc/ceiling_debris(size = 1) //debris falling in response to airstrikes, etc
	if(turf_flags & TURF_DEBRISED)
		return

	var/turf/below_turf = SSmapping.get_turf_below(src)
	if(!below_turf)
		return

	var/spread = floor(sqrt(size)*1.5)
	var/list/turfs = list(below_turf)
	for(var/turf/open/floor/F in range(below_turf, spread))
		turfs += F

	if(istype(src, /turf/open/floor/glass))
		playsound(below_turf, "sound/effects/Glassbr1.ogg", 60, 1)
		spawn(8)
			if(size > 1)
				below_turf.visible_message(SPAN_BOLDNOTICE("Shards of glass rain down from above!"))
			for(var/i = 1 to size)
				new /obj/item/shard(pick(turfs))
				new /obj/item/shard(pick(turfs))
	else if(istype(src, /turf/open/floor/roof/metal) || istype(src, /turf/open/floor/roof/sheet) || istype(src, /turf/open/floor/roof/ship_hull))
		playsound(below_turf, "sound/effects/metal_crash.ogg", 60, 1)
		spawn(8)
			if(size > 1)
				below_turf.visible_message(SPAN_BOLDNOTICE("Pieces of metal crash down from above!"))
			for(var/i = 1 to size)
				new /obj/item/stack/sheet/metal(pick(turfs))
	else if(istype(src, /turf/open/desert/rock) || istype(src, /turf/closed/wall/mineral))
		playsound(below_turf, "sound/effects/meteorimpact.ogg", 60, 1)
		spawn(8)
			if(size > 1)
				below_turf.visible_message(SPAN_BOLDNOTICE("Chunks of rock crash down from above!"))
			for(var/i = 1 to size)
				new /obj/item/ore(pick(turfs))
				new /obj/item/ore(pick(turfs))
	else if(istype(src, /turf/open) || istype(src, /turf/closed))
		playsound(below_turf, "sound/effects/metal_crash.ogg", 60, 1)
		spawn(8)
			for(var/i = 1 to size)
				new /obj/item/stack/sheet/metal(pick(turfs))
				new /obj/item/stack/sheet/metal(pick(turfs))

	turf_flags |= TURF_DEBRISED

/turf/proc/ceiling_desc(mob/user)
	if(length(linked_pylons))
		var/protection_level = get_pylon_protection_level()
		if(protection_level < 10)
			return "The ceiling above is made of light resin. Doesn't look like it's going to stop much."
		if(protection_level < 20)
			return "The ceiling above is made of resin. Seems about as strong as a cavern roof."
		else
			return "The ceiling above is made of thick resin. Nothing is getting through that."

	var/turf/ceiling = get_step_multiz(src, UP)
	if(!ceiling || istype(ceiling, /turf/open/openspace) || istype(ceiling, /turf/open/space/openspace))
		return "It is in the open."
	if(ceiling.hull_tile)
		return "The ceiling above is made of thick material. Nothing is getting through that."
	if(ceiling.turf_flags & TURF_TRANSPARENT)
		return "The ceiling above is glass. That's not going to stop anything."
	if(ceiling.antipierce < 3)
		return "The ceiling above is metal. You can't see through it with a camera from above, but that's not going to stop anything."
	if(ceiling.antipierce < 4)
		return "The roof lies above. Doesn't look like it's going to stop much."
	if(ceiling.antipierce < 6)
		return "The thin roof lies above. Can probably stop most ordnance."
	if(ceiling.antipierce < 11)
		return "The very thin roof lies above. Almost nothing is getting through that."
	return "The ceiling above is made of thick material. Nothing is getting through that."

/turf/proc/wet_floor()
	return

/turf/proc/get_cell(type)
	for(var/datum/automata_cell/C in autocells)
		if(istype(C, type))
			return C
	return null

//////////////////////////////////////////////////////////

//Check if you can plant weeds on that turf.
//Does NOT return a message, just a 0 or 1.
/turf/proc/is_weedable()
	return density ? NOT_WEEDABLE : FULLY_WEEDABLE

/turf/open/space/is_weedable()
	return NOT_WEEDABLE

/turf/open/gm/grass/is_weedable()
	return SEMI_WEEDABLE

/turf/open/gm/dirtgrassborder/is_weedable()
	return SEMI_WEEDABLE

/turf/open/gm/river/is_weedable()
	return NOT_WEEDABLE

/turf/open/gm/coast/is_weedable()
	return NOT_WEEDABLE

/turf/open/snow/is_weedable()
	return bleed_layer ? NOT_WEEDABLE : FULLY_WEEDABLE

/turf/open/mars/is_weedable()
	return SEMI_WEEDABLE

/turf/open/jungle/is_weedable()
	return NOT_WEEDABLE

/turf/open/auto_turf/shale/layer1/is_weedable()
	return SEMI_WEEDABLE

/turf/open/auto_turf/shale/layer2/is_weedable()
	return SEMI_WEEDABLE

/turf/closed/wall/is_weedable()
	return FULLY_WEEDABLE //so we can spawn weeds on the walls


/turf/proc/can_dig_xeno_tunnel()
	return FALSE

/turf/open/gm/can_dig_xeno_tunnel()
	return TRUE

/turf/open/gm/river/can_dig_xeno_tunnel()
	return FALSE

/turf/open/snow/can_dig_xeno_tunnel()
	return TRUE

/turf/open/mars/can_dig_xeno_tunnel()
	return TRUE

/turf/open/mars_cave/can_dig_xeno_tunnel()
	return TRUE

/turf/open/organic/can_dig_xeno_tunnel()
	return TRUE

/turf/open/floor/prison/can_dig_xeno_tunnel()
	return TRUE

/turf/open/desert/dirt/can_dig_xeno_tunnel()
	return TRUE

/turf/open/desert/rock/can_dig_xeno_tunnel()
	return TRUE

/turf/open/floor/ice/can_dig_xeno_tunnel()
	return TRUE

/turf/open/floor/wood/can_dig_xeno_tunnel()
	return TRUE

/turf/open/floor/corsat/can_dig_xeno_tunnel()
	return TRUE

/turf/closed/wall/almayer/research/containment/wall/divide/can_dig_xeno_tunnel()
	return FALSE

//what dirt type you can dig from this turf if any.
/turf/proc/get_dirt_type()
	return NO_DIRT

/turf/open/gm/get_dirt_type()
	return DIRT_TYPE_GROUND

/turf/open/organic/grass/get_dirt_type()
	return DIRT_TYPE_GROUND

/turf/open/gm/dirt/get_dirt_type()// looks like sand let it be sand
	return DIRT_TYPE_SAND

/turf/open/mars/get_dirt_type()
	return DIRT_TYPE_MARS

/turf/open/snow/get_dirt_type()
	if(bleed_layer)
		return DIRT_TYPE_SNOW
	else
		return DIRT_TYPE_GROUND

/turf/open/desert/dirt/get_dirt_type()
	return DIRT_TYPE_MARS

/turf/BlockedPassDirs(atom/movable/mover, target_dir)
	if(density)
		return BLOCKED_MOVEMENT
	return NO_BLOCKED_MOVEMENT

//whether the turf cancels a crusher charge
/turf/proc/stop_crusher_charge()
	return FALSE

/turf/proc/get_pylon_protection_level()
	var/protection_level = 0
	for(var/atom/pylon in linked_pylons)
		if(pylon.loc != null && istype(pylon, /obj/effect/alien/resin/special/pylon))
			var/obj/effect/alien/resin/special/pylon/P = pylon
			protection_level += P.protection_level
		else
			linked_pylons -= pylon

	return protection_level

GLOBAL_LIST_INIT(blacklisted_automated_baseturfs, typecacheof(list(
	/turf/open/space,
	/turf/baseturf_bottom,
	)))

// Make a new turf and put it on top
// The args behave identical to PlaceOnBottom except they go on top
// Things placed on top of closed turfs will ignore the topmost closed turf
// Returns the new turf
/turf/proc/PlaceOnTop(list/new_baseturfs, turf/fake_turf_type, flags)
	var/area/turf_area = loc
	if(new_baseturfs && !length(new_baseturfs))
		new_baseturfs = list(new_baseturfs)
	flags = turf_area.PlaceOnTopReact(new_baseturfs, fake_turf_type, flags) // A hook so areas can modify the incoming args

	var/turf/newT
	if(flags & CHANGETURF_SKIP) // We haven't been initialized
		if(flags_atom & INITIALIZED)
			stack_trace("CHANGETURF_SKIP was used in a PlaceOnTop call for a turf that's initialized. This is a mistake. [src]([type])")
		assemble_baseturfs()
	if(fake_turf_type)
		if(!new_baseturfs) // If no baseturfs list then we want to create one from the turf type
			if(!length(baseturfs))
				baseturfs = list(baseturfs)
			var/list/old_baseturfs = baseturfs.Copy()
			if(!istype(src, /turf/closed))
				old_baseturfs += type
			newT = ChangeTurf(fake_turf_type, null, flags)
			newT.assemble_baseturfs(initial(fake_turf_type.baseturfs)) // The baseturfs list is created like roundstart
			if(!length(newT.baseturfs))
				newT.baseturfs = list(baseturfs)
			newT.baseturfs -= GLOB.blacklisted_automated_baseturfs
			newT.baseturfs.Insert(1, old_baseturfs) // The old baseturfs are put underneath
			return newT
		if(!length(baseturfs))
			baseturfs = list(baseturfs)
		insert_self_into_baseturfs()
		baseturfs += new_baseturfs
		return ChangeTurf(fake_turf_type, null, flags)
	if(!length(baseturfs))
		baseturfs = list(baseturfs)
	insert_self_into_baseturfs()
	var/turf/change_type
	if(length(new_baseturfs))
		change_type = new_baseturfs[length(new_baseturfs)]
		new_baseturfs.len--
		if(length(new_baseturfs))
			baseturfs += new_baseturfs
	else
		change_type = new_baseturfs
	return ChangeTurf(change_type, null, flags)

/// Places a turf on top - for map loading
/turf/proc/load_on_top(turf/added_layer, flags)
	var/area/our_area = get_area(src)
	flags = our_area.PlaceOnTopReact(list(baseturfs), added_layer, flags)

	if(flags & CHANGETURF_SKIP) // We haven't been initialized
		if(flags_atom & INITIALIZED)
			stack_trace("CHANGETURF_SKIP was used in a PlaceOnTop call for a turf that's initialized. This is a mistake. [src]([type])")
		assemble_baseturfs()

	var/turf/new_turf
	if(!length(baseturfs))
		baseturfs = list(baseturfs)

	var/list/old_baseturfs = baseturfs.Copy()
	if(!isclosedturf(src))
		old_baseturfs += type

	new_turf = ChangeTurf(added_layer, null, flags)
	new_turf.assemble_baseturfs(initial(added_layer.baseturfs)) // The baseturfs list is created like roundstart
	if(!length(new_turf.baseturfs))
		new_turf.baseturfs = list(baseturfs)

	// The old baseturfs are put underneath, and we sort out the unwanted ones
	new_turf.baseturfs = baseturfs_string_list(old_baseturfs + (new_turf.baseturfs - GLOB.blacklisted_automated_baseturfs), new_turf)
	return new_turf

/turf/proc/insert_self_into_baseturfs()
	baseturfs += type

/// Remove all atoms except observers, landmarks, docking ports - clearing up the turf contents
/turf/proc/empty(turf_type=/turf/open/space, baseturf_type, list/ignore_typecache, flags)
	var/static/list/ignored_atoms = typecacheof(list(/mob/dead, /obj/effect/landmark, /obj/docking_port))
	var/list/removable_contents = typecache_filter_list_reverse(GetAllContentsIgnoring(ignore_typecache), ignored_atoms)
	removable_contents -= src
	for(var/i in 1 to length(removable_contents))
		var/thing = removable_contents[i]
		qdel(thing, force=TRUE)

	if(turf_type)
		ChangeTurf(turf_type, baseturf_type, flags)

// Copy an existing turf and put it on top
// Returns the new turf
/turf/proc/CopyOnTop(turf/copytarget, ignore_bottom=1, depth=INFINITY, copy_air = FALSE)
	var/list/new_baseturfs = list()
	new_baseturfs += baseturfs
	new_baseturfs += type

	if(depth)
		var/list/target_baseturfs
		if(length(copytarget.baseturfs))
			// with default inputs this would be Copy(clamp(2, -INFINITY, length(baseturfs)))
			// Don't forget a lower index is lower in the baseturfs stack, the bottom is baseturfs[1]
			target_baseturfs = copytarget.baseturfs.Copy(clamp(1 + ignore_bottom, 1 + length(copytarget.baseturfs) - depth, length(copytarget.baseturfs)))
		else if(!ignore_bottom)
			target_baseturfs = list(copytarget.baseturfs)
		if(target_baseturfs)
			target_baseturfs -= new_baseturfs & GLOB.blacklisted_automated_baseturfs
			new_baseturfs += target_baseturfs

	var/turf/newT = copytarget.copyTurf(src, copy_air)
	newT.baseturfs = new_baseturfs
	return newT

/turf/proc/copyTurf(turf/T)
	if(T.type != type)
		T.ChangeTurf(type)
	if(T.icon_state != icon_state)
		T.icon_state = icon_state
	if(T.icon != icon)
		T.icon = icon
	//if(color)
	// T.atom_colours = atom_colours.Copy()
	// T.update_atom_colour()
	if(T.dir != dir)
		T.setDir(dir)
	return T

/turf/proc/remove_flag(flag)
	turf_flags &= ~flag

/turf/proc/on_atom_created(atom/created_atom)
	return

/turf/proc/handle_transpare_turf()
	layer = OPENSPACE_LAYER
	plane = TRANSPARENT_FLOOR_PLANE

	var/turf/below_turf = get_step_multiz(src, DOWN)
	if(below_turf)
		vis_contents += below_turf
	update_multi_z()

///Updates the viscontents or underlays below this tile.
/turf/proc/update_multi_z()
	var/turf/below_turf = get_step_multiz(src, DOWN)
	if(!below_turf)
		vis_contents.Cut()
		var/turf/path = SSmapping.level_trait(z, ZTRAIT_BASETURF) || /turf/open/space
		var/mutable_appearance/underlay_appearance = mutable_appearance(initial(path.icon), initial(path.icon_state), layer = TURF_LAYER-0.02, plane = PLANE_SPACE)
		underlay_appearance.appearance_flags = RESET_ALPHA | RESET_COLOR
		underlays += underlay_appearance

/turf/handle_fall(mob/faller, forced)
	if(!forced)
		return
	playsound(src, get_sfx("bodyfall"), 50, 1)
