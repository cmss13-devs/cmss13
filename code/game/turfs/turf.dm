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

	var/list/baseturfs = /turf/baseturf_bottom
	var/changing_turf = FALSE
	var/chemexploded = FALSE // Prevents explosion stacking

	var/turf_flags = NO_FLAGS

	/// Whether we've broken through the ceiling yet
	var/ceiling_debrised = FALSE

	// Fishing
	var/supports_fishing = FALSE // set to false when MRing, this is just for testing

	///Lumcount added by sources other than lighting datum objects, such as the overlay lighting component.
	var/dynamic_lumcount = 0

	///List of light sources affecting this turf.
	///Which directions does this turf block the vision of, taking into account both the turf's opacity and the movable opacity_sources.
	var/directional_opacity = NONE
	///Lazylist of movable atoms providing opacity sources.
	var/list/atom/movable/opacity_sources

	///Lazylist of movable atoms that can block movement
	var/list/atom/movable/movement_blockers

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

	//Get area light
	var/area/current_area = loc
	if(current_area?.lighting_effect)
		overlays += current_area.lighting_effect

	if(opacity)
		directional_opacity = ALL_CARDINALS

	return INITIALIZE_HINT_NORMAL

/turf/Destroy(force)
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

/turf/vv_get_dropdown()
	. = ..()
	VV_DROPDOWN_OPTION(VV_HK_EXPLODE, "Trigger Explosion")
	VV_DROPDOWN_OPTION(VV_HK_EMPULSE, "Trigger EM Pulse")

/turf/vv_edit_var(var_name, new_value)
	var/static/list/banned_edits = list(NAMEOF_STATIC(src, x), NAMEOF_STATIC(src, y), NAMEOF_STATIC(src, z))
	if(var_name in banned_edits)
		return FALSE
	. = ..()

/turf/ex_act(severity)
	return 0

/turf/proc/update_icon() //Base parent. - Abby
	return

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

#define START_TURF 1
#define DIAGONAL_TURF_LONG 2
#define DIAGONAL_TURF_LAT 3
#define TARGET_TURF 4
#define PROCESS_POTENTIAL_BLOCKER(blocker) \
if (turf_type == START_TURF) { \
	blocking_dir = (blocker.BlockedExitDirs(mover, target_dir) & target_dir); \
} else if (turf_type == DIAGONAL_TURF_LONG && (blocker.BlockedExitDirs(mover, latitudinal_dir) || blocker.BlockedPassDirs(mover, longitudinal_dir))) { \
	blocking_dir = longitudinal_dir; \
} \
else if (turf_type == DIAGONAL_TURF_LAT && (blocker.BlockedExitDirs(mover, longitudinal_dir) || blocker.BlockedPassDirs(mover, latitudinal_dir))) { \
	blocking_dir = latitudinal_dir; \
} \
else if (turf_type == TARGET_TURF) { \
	blocking_dir = (blocker.BlockedPassDirs(mover, target_dir) & target_dir); \
} \
else { \
	blocking_dir = NO_BLOCKED_MOVEMENT; \
} \
if (blocking_dir & target_dir) { \
	if (!longitudinal_dir || blocking_dir & longitudinal_dir) { \
		longitudinal_dir_count += 1; \
	} \
	if (!latitudinal_dir || blocking_dir & latitudinal_dir) { \
		latitudinal_dir_count += 1; \
	} \
	if (blocker.flags_atom & ON_BORDER) { LAZYSET(border_blockers, blocker, blocking_dir); } \
	else { LAZYSET(non_border_blockers, blocker, blocking_dir); } \
}
#define PROCESS_POTENTIAL_BLOCKERS \
if ((!longitudinal_dir || longitudinal_dir_count) && (!latitudinal_dir || latitudinal_dir_count)) { \
	was_blocked = FALSE; \
	for (var/border_blocker in border_blockers) { \
		if (!(mover.Collide(border_blocker) & MOVABLE_COLLIDE_NOT_BLOCKED)) { \
			was_blocked = TRUE; \
		} \
		border_blockers -= border_blocker; \
	} \
	if (was_blocked) { return FALSE; } \
	for (var/non_border_blocker in non_border_blockers) { \
		if (!(mover.Collide(non_border_blocker) & MOVABLE_COLLIDE_NOT_BLOCKED)) { \
			was_blocked = TRUE; \
		} \
		blocking_dir = non_border_blockers[non_border_blocker]; \
		if (!longitudinal_dir || blocking_dir & longitudinal_dir) { \
			longitudinal_dir_count -= 1; \
		} \
		if (!latitudinal_dir || blocking_dir & latitudinal_dir) { \
			latitudinal_dir_count -= 1; \
		} \
		non_border_blockers -= non_border_blocker; \
	} \
	if (was_blocked) { return FALSE; }; \
}

// Handles whether an atom is able to enter the src turf
/turf/Enter(atom/movable/mover, atom/forget)
	. = TRUE
	if (!mover || !isturf(mover.loc))
		return FALSE

	var/override = SEND_SIGNAL(mover, COMSIG_MOVABLE_TURF_ENTER, src)
	override |= SEND_SIGNAL(src, COMSIG_TURF_ENTER, mover)
	if(override)
		return override & COMPONENT_TURF_ALLOW_MOVEMENT

	if(isobserver(mover) || istype(mover, /obj/projectile))
		return TRUE

	/// the actual dir between the start and target turf
	var/target_dir = get_dir(mover, src)
	if (!target_dir)
		return TRUE

	/// NORTH or SOUTH component of target direction
	var/longitudinal_dir = target_dir & (target_dir-1)
	/// The number of blockers for longitudinal_dir
	var/longitudinal_dir_count = 0
	/// EAST or WEST component of target direction
	var/latitudinal_dir = target_dir - longitudinal_dir
	/// The number of blockers for latitudinal_dir
	var/latitudinal_dir_count = 0
	/// Assoc list of blockers that are at the edge of a turf, prioritized when checking blockers.
	/// The key is the blocker itself and the value is the direction the blocker is blocking.
	var/list/border_blockers = list()
	/// Assoc list of blockers that are not on the edge of a turf.
	/// The key is the blocker itself and the value is the direction the blocker is blocking.
	var/list/non_border_blockers = list()

	var/was_blocked

	/// The direction that mover's path is being blocked by
	var/blocking_dir
	var/turf/turf_to_check
	var/atom/movable/obstacle
	var/turf_type

	/**
	 * Check atoms in the current turf (including turf itself)
	 *
	 * For each atom, including the current turf, we check:
	 * 1. Whether that atom will allow us to exit in either the longitudinal
	 * or latitudinal directions
	 */
	turf_type = START_TURF
	var/turf/start_turf = mover.loc
	PROCESS_POTENTIAL_BLOCKER(start_turf)
	for (obstacle as anything in start_turf.movement_blockers) //First, check objects to block exit
		if (mover == obstacle || forget == obstacle)
			continue
		PROCESS_POTENTIAL_BLOCKER(obstacle)
	PROCESS_POTENTIAL_BLOCKERS

	/**
	 * Check atoms in the adjacent turf (including turf itself) to the EAST or WEST when moving diagonally
	 *
	 * For each atom, including the turf to the EAST or WEST, we check:
	 * 1. Whether that atom will block us from exiting into the target turf from its turf (by NORTH or SOUTH depending on latitudinal_dir)
	 * 2. Whether that atom will block us from entering into its turf from the current turf (by EAST or WEST depending on longitudinal_dir)
	 */
	turf_type = DIAGONAL_TURF_LONG
	if (!mover.move_intentionally && longitudinal_dir && longitudinal_dir != target_dir)
		turf_to_check = get_step(start_turf, longitudinal_dir)
		PROCESS_POTENTIAL_BLOCKER(turf_to_check)
		for (obstacle as anything in turf_to_check.movement_blockers)
			if (obstacle == forget)
				continue
			PROCESS_POTENTIAL_BLOCKER(obstacle)
		PROCESS_POTENTIAL_BLOCKERS


	/**
	 * Check atoms in the adjacent turf (including turf itself) to the NORTH or SOUTH when moving diagonally
	 *
	 * For each atom, including the turf to the NORTH or SOUTH, we check:
	 * 1. Whether that atom will block us from exiting into the target turf from its turf (by EAST or WEST depending on longitudinal_dir)
	 * 2. Whether that atom will block us from entering into its turf from the current turf (by NORTH or SOUTH depending on latitudinal_dir)
	 */
	turf_type = DIAGONAL_TURF_LAT
	if (!mover.move_intentionally && latitudinal_dir && latitudinal_dir != target_dir)
		turf_to_check = get_step(start_turf, latitudinal_dir)
		PROCESS_POTENTIAL_BLOCKER(turf_to_check)
		for (obstacle as anything in turf_to_check.movement_blockers)
			if (!isStructure(obstacle) && !ismob(obstacle) && !isVehicle(obstacle))
				continue
			if(obstacle in forget)
				continue
			PROCESS_POTENTIAL_BLOCKER(obstacle)
		PROCESS_POTENTIAL_BLOCKERS

	/**
	 * Check atoms in the target turf (including turf itself)
	 *
	 * For each atom, including the target turf, we check:
	 * 1. Whether that atom will allow us to enter in either the longitudinal or
	 * latitudinal directions
	 */
	turf_type = TARGET_TURF
	PROCESS_POTENTIAL_BLOCKER(src)
	for (obstacle as anything in src.movement_blockers) // Finally, check atoms in the target turf
		if (obstacle in forget)
			continue
		if (!isStructure(obstacle) && !ismob(obstacle) && !isVehicle(obstacle))
			continue
		PROCESS_POTENTIAL_BLOCKER(obstacle)
	PROCESS_POTENTIAL_BLOCKERS

#undef PROCESS_POTENTIAL_BLOCKER
#undef PROCESS_POTENTIAL_BLOCKERS
#undef START_TURF
#undef DIAGONAL_TURF_LONG
#undef DIAGONAL_TURF_LAT
#undef TARGET_TURF

/turf/Entered(atom/movable/mover)
	if (!istype(mover))
		return

	SEND_SIGNAL(src, COMSIG_TURF_ENTERED, mover)
	SEND_SIGNAL(mover, COMSIG_MOVABLE_TURF_ENTERED, src)

	// Let explosions know that the atom entered
	for(var/datum/automata_cell/explosion/E in autocells)
		E.on_turf_entered(mover)

	if (mover.can_block_movement)
		LAZYADD(movement_blockers, mover)

/turf/Exited(atom/movable/mover)
	if (!istype(mover))
		return

	if (mover.can_block_movement)
		LAZYREMOVE(movement_blockers, mover)

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
			path = /turf/open/floor/plating

	//if(src.type == new_turf_path) // Put this back if shit starts breaking
	// return src

	var/pylons = linked_pylons

	var/list/old_baseturfs = baseturfs

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

	if(new_baseturfs)
		W.baseturfs = new_baseturfs
	else
		W.baseturfs = old_baseturfs

	W.linked_pylons = pylons

	W.hybrid_lights_affecting = old_hybrid_lights_affecting
	W.dynamic_lumcount = dynamic_lumcount

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
			if(!LinkBlocked(src, t))
				L.Add(t)
	FOR_DOVIEW_END
	return L

/turf/proc/AdjacentTurfsSpace()
	var/L[] = new()
	FOR_DOVIEW(var/turf/t, 1, src, HIDE_INVISIBLE_OBSERVER)
		if(!t.density)
			if(!LinkBlocked(src, t))
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

/turf/proc/ceiling_debris_check(size = 1)
	return

/turf/proc/ceiling_debris(size = 1) //debris falling in response to airstrikes, etc
	if(ceiling_debrised)
		return

	var/area/A = get_area(src)
	if(!A.ceiling)
		return

	var/amount = size
	var/spread = floor(sqrt(size)*1.5)

	var/list/turfs = list()
	for(var/turf/open/floor/F in range(spread, src))
		turfs += F

	switch(A.ceiling)
		if(CEILING_GLASS)
			playsound(src, "sound/effects/Glassbr1.ogg", 60, 1)
			spawn(8)
				if(amount >1)
					visible_message(SPAN_BOLDNOTICE("Shards of glass rain down from above!"))
				for(var/i=1, i<=amount, i++)
					new /obj/item/shard(pick(turfs))
					new /obj/item/shard(pick(turfs))
		if(CEILING_METAL, CEILING_REINFORCED_METAL)
			playsound(src, "sound/effects/metal_crash.ogg", 60, 1)
			spawn(8)
				if(amount >1)
					visible_message(SPAN_BOLDNOTICE("Pieces of metal crash down from above!"))
				for(var/i=1, i<=amount, i++)
					new /obj/item/stack/sheet/metal(pick(turfs))
		if(CEILING_UNDERGROUND_ALLOW_CAS, CEILING_UNDERGROUND_BLOCK_CAS, CEILING_DEEP_UNDERGROUND)
			playsound(src, "sound/effects/meteorimpact.ogg", 60, 1)
			spawn(8)
				if(amount >1)
					visible_message(SPAN_BOLDNOTICE("Chunks of rock crash down from above!"))
				for(var/i=1, i<=amount, i++)
					new /obj/item/ore(pick(turfs))
					new /obj/item/ore(pick(turfs))
		if(CEILING_UNDERGROUND_METAL_ALLOW_CAS, CEILING_UNDERGROUND_METAL_BLOCK_CAS, CEILING_DEEP_UNDERGROUND_METAL)
			playsound(src, "sound/effects/metal_crash.ogg", 60, 1)
			spawn(8)
				for(var/i=1, i<=amount, i++)
					new /obj/item/stack/sheet/metal(pick(turfs))
					new /obj/item/ore(pick(turfs))
	ceiling_debrised = TRUE

/turf/proc/ceiling_desc(mob/user)

	if(LAZYLEN(linked_pylons))
		switch(get_pylon_protection_level())
			if(TURF_PROTECTION_MORTAR)
				return "The ceiling above is made of light resin. Doesn't look like it's going to stop much."
			if(TURF_PROTECTION_CAS)
				return "The ceiling above is made of resin. Seems about as strong as a cavern roof."
			if(TURF_PROTECTION_OB)
				return "The ceiling above is made of thick resin. Nothing is getting through that."

	var/area/A = get_area(src)
	switch(A.ceiling)
		if(CEILING_GLASS)
			return "The ceiling above is glass. That's not going to stop anything."
		if(CEILING_METAL)
			return "The ceiling above is metal. You can't see through it with a camera from above, but that's not going to stop anything."
		if(CEILING_UNDERGROUND_ALLOW_CAS)
			return "It is underground. A thin cavern roof lies above. Doesn't look like it's going to stop much."
		if(CEILING_UNDERGROUND_BLOCK_CAS)
			return "It is underground. The cavern roof lies above. Can probably stop most ordnance."
		if(CEILING_UNDERGROUND_METAL_ALLOW_CAS)
			return "It is underground. The ceiling above is made of thin metal. Doesn't look like it's going to stop much."
		if(CEILING_UNDERGROUND_METAL_BLOCK_CAS)
			return "It is underground. The ceiling above is made of metal.  Can probably stop most ordnance."
		if(CEILING_DEEP_UNDERGROUND)
			return "It is deep underground. The cavern roof lies above. Nothing is getting through that."
		if(CEILING_DEEP_UNDERGROUND_METAL)
			return "It is deep underground. The ceiling above is made of thick metal. Nothing is getting through that."
		if(CEILING_REINFORCED_METAL)
			return "The ceiling above is heavy reinforced metal. Nothing is getting through that."
		else
			return "It is in the open."

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
	var/protection_level = TURF_PROTECTION_NONE
	for (var/atom/pylon in linked_pylons)
		if (pylon.loc != null)
			var/obj/effect/alien/resin/special/pylon/P = pylon

			if(!istype(P))
				continue

			if(P.protection_level > protection_level)
				protection_level = P.protection_level
		else
			LAZYREMOVE(linked_pylons, pylon)

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
