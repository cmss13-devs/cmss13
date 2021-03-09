/*
/turf

	/open - all turfs with density = 0 are turf/open

		/floor - floors are constructed floor as opposed to natural grounds

		/space

		/shuttle - shuttle floors are separated from real floors because they're magic

		/snow - snow is one type of non-floor open turf

	/closed - all turfs with density = 1 are turf/closed

		/wall - walls are constructed walls as opposed to natural solid turfs

			/r_wall

		/shuttle - shuttle walls are separated from real walls because they're magic, and don't smoothes with walls.

		/ice_rock - ice_rock is one type of non-wall closed turf

*/



/turf
	icon = 'icons/turf/floors/floors.dmi'
	var/intact_tile = 1 //used by floors to distinguish floor with/without a floortile(e.g. plating).
	var/can_bloody = TRUE //Can blood spawn on this turf?
	var/list/linked_pylons = list()
	var/obj/effect/alien/weeds/weeds

	var/list/datum/automata_cell/autocells = list()
	/**
	 * Associative list of cleanable types (strings) mapped to
	 * cleanable objects
	 *
	 * The cleanable object does not necessarily need to be
	 * on the turf, it can simply be for handling how the
	 * overlays or placing new cleanables of the same type work
	 */
	var/list/cleanables

	var/list/baseturfs = /turf/baseturf_bottom
	var/changing_turf = FALSE
	var/chemexploded = FALSE // Prevents explosion stacking

	var/flags_turf = NO_FLAGS

/turf/Initialize(mapload)
	SHOULD_CALL_PARENT(FALSE) // this doesn't parent call for optimisation reasons
	if(flags_atom & INITIALIZED)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	flags_atom |= INITIALIZED

	// by default, vis_contents is inherited from the turf that was here before
	vis_contents.Cut()

	turfs += src
	if(is_ground_level(z))
		z1turfs += src

	assemble_baseturfs()

	levelupdate()

	visibilityChanged()

	pass_flags = pass_flags_cache[type]
	if (isnull(pass_flags))
		pass_flags = new()
		initialize_pass_flags(pass_flags)
		pass_flags_cache[type] = pass_flags
	else
		initialize_pass_flags()

	for(var/atom/movable/AM in src)
		Entered(AM)

	if(luminosity)
		if(light)	WARNING("[type] - Don't set lights up manually during New(), We do it automatically.")
		trueLuminosity = luminosity * luminosity
		light = new(src)

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
	visibilityChanged()
	flags_atom &= ~INITIALIZED
	..()

/turf/ex_act(severity)
	return 0

/turf/proc/update_icon() //Base parent. - Abby
	return

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

	var/override = SEND_SIGNAL(mover, COMSIG_TURF_ENTER, src)
	if(override)
		return override & COMPONENT_TURF_ALLOW_MOVEMENT

	if(isobserver(mover) || istype(mover, /obj/item/projectile))
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

/turf/Entered(atom/movable/A)
	if(!istype(A))
		return

	SEND_SIGNAL(A, COMSIG_MOVABLE_TURF_ENTERED, src)

	// Let explosions know that the atom entered
	for(var/datum/automata_cell/explosion/E in autocells)
		E.on_turf_entered(A)

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
/turf/proc/return_siding_icon_state()		//used for grass floors, which have siding.
	return 0

/turf/proc/inertial_drift(atom/movable/A as mob|obj)
	if(A.anchored)
		return
	if(!(A.last_move_dir))	return
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
	created_baseturf_lists[new_baseturfs[new_baseturfs.len]] = new_baseturfs.Copy()
	return new_baseturfs

// Creates a new turf
// new_baseturfs can be either a single type or list of types, formated the same as baseturfs. see turf.dm
/turf/proc/ChangeTurf(path, list/new_baseturfs, flags)
	switch(path)
		if(null)
			return
		if(/turf/baseturf_bottom)
			path = /turf/open/floor/plating

	var/old_lumcount = lighting_lumcount - initial(lighting_lumcount)

	//if(src.type == new_turf_path) // Put this back if shit starts breaking
	//	return src

	var/pylons = linked_pylons

	var/list/old_baseturfs = baseturfs

	changing_turf = TRUE
	qdel(src)	//Just get the side effects and call Destroy
	var/turf/W = new path(src)

	for(var/i in W.contents)
		var/datum/A = i
		SEND_SIGNAL(A, COMSIG_ATOM_TURF_CHANGE, src)

	if(new_baseturfs)
		W.baseturfs = new_baseturfs
	else
		W.baseturfs = old_baseturfs

	W.linked_pylons = pylons

	W.lighting_lumcount += old_lumcount
	if(old_lumcount != W.lighting_lumcount)
		W.lighting_changed = 1
		SSlighting.changed_turfs += W

	W.levelupdate()
	return W

// Take off the top layer turf and replace it with the next baseturf down
/turf/proc/ScrapeAway(amount=1, flags)
	if(!amount)
		return
	if(length(baseturfs))
		var/list/new_baseturfs = baseturfs.Copy()
		var/turf_type = new_baseturfs[max(1, new_baseturfs.len - amount + 1)]
		while(ispath(turf_type, /turf/baseturf_skipover))
			amount++
			if(amount > new_baseturfs.len)
				CRASH("The bottomost baseturf of a turf is a skipover [src]([type])")
			turf_type = new_baseturfs[max(1, new_baseturfs.len - amount + 1)]
		new_baseturfs.len -= min(amount, new_baseturfs.len - 1) // No removing the very bottom
		if(new_baseturfs.len == 1)
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
	for(var/turf/t in oview(src,1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				L.Add(t)
	return L

/turf/proc/AdjacentTurfsSpace()
	var/L[] = new()
	for(var/turf/t in oview(src,1))
		if(!t.density)
			if(!LinkBlocked(src, t) && !TurfBlockedNonWindow(t))
				L.Add(t)
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

/turf/proc/ceiling_debris_check(var/size = 1)
	return

/turf/proc/ceiling_debris(var/size = 1) //debris falling in response to airstrikes, etc
	var/area/A = get_area(src)
	if(!A.ceiling) return

	var/amount = size
	var/spread = round(sqrt(size)*1.5)

	var/list/turfs = list()
	for(var/turf/open/floor/F in range(src,spread))
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

/turf/proc/ceiling_desc(mob/user)

	if (linked_pylons.len > 0)
		switch(get_pylon_protection_level())
			if(TURF_PROTECTION_MORTAR)
				to_chat(user, "The ceiling above is made of light resin.")
				return
			if(TURF_PROTECTION_CAS)
				to_chat(user, "The ceiling above is made of resin.")
				return
			if(TURF_PROTECTION_OB)
				to_chat(user, "The ceiling above is made of thick resin. Nothing is getting through that")
				return

	var/area/A = get_area(src)
	switch(A.ceiling)
		if(CEILING_GLASS)
			to_chat(user, "The ceiling above is glass.")
		if(CEILING_METAL)
			to_chat(user, "The ceiling above is metal.")
		if(CEILING_UNDERGROUND_ALLOW_CAS, CEILING_UNDERGROUND_BLOCK_CAS)
			to_chat(user, "It is underground. The cavern roof lies above.")
		if(CEILING_UNDERGROUND_METAL_ALLOW_CAS, CEILING_UNDERGROUND_METAL_BLOCK_CAS)
			to_chat(user, "It is underground. The ceiling above is metal.")
		if(CEILING_DEEP_UNDERGROUND)
			to_chat(user, "It is deep underground. The cavern roof lies above.")
		if(CEILING_DEEP_UNDERGROUND_METAL)
			to_chat(user, "It is deep underground. The ceiling above is metal.")
		if(CEILING_REINFORCED_METAL)
			to_chat(user, "The ceiling above is heavy reinforced metal. Nothing is getting through that.")
		else
			to_chat(user, "It is in the open.")

/turf/proc/wet_floor()
	return

/turf/proc/get_cell(var/type)
	for(var/datum/automata_cell/C in autocells)
		if(istype(C, type))
			return C
	return null

//////////////////////////////////////////////////////////

//Check if you can plant weeds on that turf.
//Does NOT return a message, just a 0 or 1.
/turf/proc/is_weedable()
	return !density

/turf/open/space/is_weedable()
	return FALSE

/turf/open/gm/grass/is_weedable()
	return FALSE

/turf/open/gm/dirtgrassborder/is_weedable()
	return FALSE

/turf/open/gm/river/is_weedable()
	return FALSE

/turf/open/gm/coast/is_weedable()
	return FALSE

/turf/open/snow/is_weedable()
	return !bleed_layer

/turf/open/mars/is_weedable()
	return FALSE

/turf/open/jungle/is_weedable()
	return FALSE

/turf/closed/wall/is_weedable()
	return TRUE //so we can spawn weeds on the walls


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
		if(!istype(src, /turf/closed))
			baseturfs += type
		baseturfs += new_baseturfs
		return ChangeTurf(fake_turf_type, null, flags)
	if(!length(baseturfs))
		baseturfs = list(baseturfs)
	if(!istype(src, /turf/closed))
		baseturfs += type
	var/turf/change_type
	if(length(new_baseturfs))
		change_type = new_baseturfs[new_baseturfs.len]
		new_baseturfs.len--
		if(new_baseturfs.len)
			baseturfs += new_baseturfs
	else
		change_type = new_baseturfs
	return ChangeTurf(change_type, null, flags)

/turf/proc/empty(turf_type=/turf/open/space, baseturf_type, list/ignore_typecache, flags)
	// Remove all atoms except observers, landmarks, docking ports
	var/static/list/ignored_atoms = typecacheof(list(/mob/dead, /obj/effect/landmark)) // shuttle TODO:
	var/list/allowed_contents = typecache_filter_list_reverse(GetAllContentsIgnoring(ignore_typecache), ignored_atoms)
	allowed_contents -= src
	for(var/i in 1 to allowed_contents.len)
		var/thing = allowed_contents[i]
		qdel(thing, force=TRUE)

	if(turf_type)
		ChangeTurf(turf_type, baseturf_type, flags)
