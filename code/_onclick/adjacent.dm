/*
	Adjacency proc for determining touch range

	This is mostly to determine if a user can enter a square for the purposes of touching something.
	Examples include reaching a square diagonally or reaching something on the other side of a glass window.

	This is calculated by looking for border items, or in the case of clicking diagonally from yourself, dense items.
	This proc will NOT notice if you are trying to attack a window on the other side of a dense object in its turf.  There is a window helper for that.

	Note that in all cases the neighbor is handled simply; this is usually the user's mob, in which case it is up to you
	to check that the mob is not inside of something
*/
/atom/proc/Adjacent(atom/neighbor) // basic inheritance, unused
	return FALSE

// Not a sane use of the function and (for now) indicative of an error elsewhere
/area/Adjacent(atom/neighbor)
	CRASH("Call to /area/Adjacent(), unimplemented proc")


/*
	Adjacency (to turf):
	* If you are in the same turf, always true
	* If you are vertically/horizontally adjacent, ensure there are no border objects
	* If you are diagonally adjacent, ensure you can pass through at least one of the mutually adjacent square.
		* Passing through in this case ignores anything with the throwpass flag, such as tables, racks, and morgue trays.
*/
/turf/Adjacent(atom/neighbor, atom/target = null, list/ignore_list)
	var/turf/T0 = get_turf(neighbor)
	if(T0 == src)
		return TRUE
	if(get_dist(src,T0) > 1)
		return FALSE

	if(T0.x == x || T0.y == y)
		// Check for border blockages
		return T0.ClickCross(get_dir(T0,src), border_only = 1, ignore_list = ignore_list) && src.ClickCross(get_dir(src,T0), border_only = 1, target_atom = target, ignore_list = ignore_list)

	// Not orthagonal
	var/in_dir = get_dir(neighbor,src) // eg. northwest (1+8)
	var/d1 = in_dir&(in_dir-1) // eg west (1+8)&(8) = 8
	var/d2 = in_dir - d1 // eg north (1+8) - 8 = 1

	for(var/d in list(d1,d2))
		if(!T0.ClickCross(d, border_only = 1, ignore_list = ignore_list))
			continue // could not leave T0 in that direction

		var/turf/T1 = get_step(T0,d)
		if(!T1 || T1.density || !T1.ClickCross(get_dir(T1,T0)|get_dir(T1,src), border_only = 0, ignore_list = ignore_list))
			continue // couldn't enter or couldn't leave T1

		if(!src.ClickCross(get_dir(src,T1), border_only = 1, target_atom = target, ignore_list = ignore_list))
			continue // could not enter src

		return TRUE // we don't care about our own density
	return FALSE

/*
Quick adjacency (to turf):
* If you are in the same turf, always true
* If you are not adjacent, then false
*/
/turf/proc/AdjacentQuick(atom/neighbor, atom/target = null)
	var/turf/T0 = get_turf(neighbor)
	if(T0 == src)
		return TRUE

	if(get_dist(src,T0) > 1)
		return FALSE

	return TRUE

/*
	Adjacency (to anything else):
	* Must be on a turf
	* In the case of a multiple-tile object, all valid locations are checked for adjacency.

	Note: Multiple-tile objects are created when the bound_width and bound_height are creater than the tile size.
	This is not used in stock /tg/station currently.
*/
/atom/movable/Adjacent(atom/neighbor)
	if(neighbor == loc)
		return TRUE
	if(!isturf(loc))
		return FALSE
	for(var/turf/T in locs)
		if(isnull(T))
			continue
		if(T.Adjacent(neighbor,src))
			return TRUE
	return FALSE

// This is necessary for storage items not on your person.
/obj/item/Adjacent(atom/neighbor, recurse = 1)
	if(neighbor == loc || (loc && neighbor == loc.loc))
		return TRUE

	// Internal storages have special relationships with the object they are connected to and we still want two depth adjacency for storages
	if(istype(loc?.loc, /obj/item/storage/internal) && recurse > 0)
		return loc.loc.Adjacent(neighbor, recurse)

	if(issurface(loc))
		return loc.Adjacent(neighbor, recurse) //Surfaces don't count as storage depth.
	else if(istype(loc, /obj/item))
		if(recurse > 0)
			return loc.Adjacent(neighbor, recurse - 1)
		return FALSE
	else if(isxeno(loc)) //Xenos don't count as storage depth.
		return loc.Adjacent(neighbor, recurse)
	return ..()

/*
	Special case: This allows you to reach a door when it is visally on top of,
	but technically behind, a fire door

	You could try to rewrite this to be faster, but I'm not sure anything would be.
	This can be safely removed if border firedoors are ever moved to be on top of doors
	so they can be interacted with without opening the door.
*/
/obj/structure/machinery/door/Adjacent(atom/neighbor)
	var/obj/structure/machinery/door/firedoor/border_only/BOD = locate() in loc
	if(BOD)
		BOD.throwpass = 1 // allow click to pass
		. = ..()
		BOD.throwpass = 0
		return .
	return ..()

/*
	This checks if you there is uninterrupted airspace between that turf and this one.
	This is defined as any dense ON_BORDER object, or any dense object without throwpass.
	The border_only flag allows you to not objects (for source and destination squares)
*/
/turf/proc/ClickCross(target_dir, border_only, target_atom = null, list/ignore_list)
	for(var/obj/O in src)
		if(O in ignore_list)
			continue

		if(!O.density || O == target_atom || O.throwpass)
			continue // throwpass is used for anything you can click through

		if(O.flags_atom & ON_BORDER) // windows have throwpass but are on border, check them first
			if(O.dir & target_dir || O.dir&(O.dir-1)) // full tile windows are just diagonals mechanically
				var/obj/structure/window/W = target_atom
				if (!istype(W))
					return FALSE
				else if (!W.is_full_window()) //exception for breaking full tile windows on top of single pane windows
					return FALSE

		else if( !border_only ) // dense, not on border, cannot pass over
			return FALSE
	return TRUE

/*
 * handle_barriers checks if src is going to be attacked by A, or if A will instead attack a barrier. For now only considers
 * a single barrier on each direction.
 *
 * I am considering making it so that handle_barriers will loop through ALL blocking objects, though this requires testing
 * for performance impact.
 * Assumes dist <= 1
 */
/atom/proc/handle_barriers(atom/A, list/atom/ignore = list(), pass_flags)
	ignore |= src // Make sure that you ignore your target
	A.add_temp_pass_flags(pass_flags)

	var/rdir = get_dir(src, A)
	var/fdir = get_dir(A, src)

	var/list/list/blockers = list(
		"fd1" = list(),
		"fd2" = list()
	)
	var/list/dense_blockers

	var/rd1 = rdir&(rdir-1) // eg west (1+8)&(8) = 8
	var/rd2 = rdir - rd1 // eg north (1+8) - 8 = 1
	var/fd1 = fdir&(fdir-1)
	var/fd2 = fdir - fd1

	if (!isturf(A))
		for (var/potential_blocker in A.loc) // Check if there are any barricades blocking attacker from their current loc
			if (potential_blocker in ignore)
				continue
			if (!isStructure(potential_blocker) && !ismob(potential_blocker) && !isVehicle(potential_blocker))
				continue
			var/atom/PB = potential_blocker
			if (!(PB.flags_atom & ON_BORDER) || !PB.BlockedExitDirs(A, fd1) || !PB.BlockedExitDirs(A, fd2))
				continue
			if (PB.dir & fd1)
				blockers["fd1"] += PB
			if (PB.dir & fd2)
				blockers["fd2"] += PB

	dense_blockers = list()
	if (fd1 && fd1 != fdir) // Check any obstacles blocking from the turf to the EAST/WEST of attacker
		var/turf/fd1loc = get_step(A, fd1)
		var/fd1dir_a = get_dir(fd1loc, A) // inverse direction for attacker
		var/fd1dir_d = get_dir(fd1loc, src) // inverse direction for target
		if (fd1loc.BlockedPassDirs(A, fd1))
			dense_blockers += fd1loc
		for (var/potential_blocker in fd1loc)
			if (potential_blocker in ignore)
				continue
			if (!isStructure(potential_blocker) && !ismob(potential_blocker) && !isVehicle(potential_blocker))
				continue
			var/atom/PB = potential_blocker
			if (!(PB.flags_atom & ON_BORDER))
				if(PB.BlockedPassDirs(A, fd1)) // If there is a solid object (e.g. a vendor) blocking
					dense_blockers += PB
				continue
			if (PB.dir & fd1dir_a && PB.BlockedPassDirs(A, fd1))
				blockers["fd1"] += PB
			else if (PB.dir & fd1dir_d && PB.BlockedExitDirs(A, fd2))
				blockers["fd1"] += PB
		blockers["fd1"] += dense_blockers

	dense_blockers.Cut()

	if (fd2 && fd2 != fdir) // Check any obstacles blocking from the turf to the NORTH/SOUTH of attacker
		var/turf/fd2loc = get_step(A, fd2)
		var/fd2dir_a = get_dir(fd2loc, A) // inverse direction for attacker
		var/fd2dir_d = get_dir(fd2loc, src) // inverse direction for target
		if (fd2loc.BlockedPassDirs(A, fd2))
			dense_blockers += fd2loc
		for (var/potential_blocker in fd2loc)
			if (potential_blocker in ignore)
				continue
			if (!isStructure(potential_blocker) && !ismob(potential_blocker) && !isVehicle(potential_blocker))
				continue
			var/atom/PB = potential_blocker
			if (!(PB.flags_atom & ON_BORDER))
				if (PB.BlockedPassDirs(A, fd2)) // If there is a solid object (e.g. a vendor) blocking
					dense_blockers += PB
				continue
			if (PB.dir & fd2dir_a && PB.BlockedPassDirs(A, fd2))
				blockers["fd2"] += PB
			else if (PB.dir & fd2dir_d && PB.BlockedExitDirs(A, fd1))
				blockers["fd2"] += PB
		blockers["fd2"] += dense_blockers

	dense_blockers = null

	for (var/potential_blocker in get_turf(src)) // Check if there are any barricades blocking attacker from the target's current loc (or target itself if it's a turf)
		if (potential_blocker in ignore)
			continue
		if (!isStructure(potential_blocker) && !ismob(potential_blocker) && !isVehicle(potential_blocker))
			continue
		var/atom/PB = potential_blocker
		if (!(PB.flags_atom & ON_BORDER))
			continue
		if (PB.dir & rd1 && PB.BlockedPassDirs(A, fd1))
			if (fd1 && fd2)
				blockers["fd2"] += PB
			else
				blockers["fd1"] += PB
		if (PB.dir & rd2 && PB.BlockedPassDirs(A, fd2))
			if (fd1 && fd2)
				blockers["fd1"] += PB
			else
				blockers["fd2"] += PB

	// Make sure pass flags are removed
	A.remove_temp_pass_flags(pass_flags)

	if ((fd1 && !blockers["fd1"].len) || (fd2 && !blockers["fd2"].len)) // This means that for a given direction it did not have a blocker
		return src

	if (blockers["fd1"].len || blockers["fd2"].len)
		var/guaranteed_hit = 0 // indicates whether there is a guaranteed hit (aka there is not chance to bypass blocker). 0 = nothing
		var/list/cur_dense_blockers = list()
		for (var/atom/blocker in blockers["fd1"])
			if (blocker.flags_barrier & HANDLE_BARRIER_CHANCE)
				if(blocker.handle_barrier_chance())
					return blocker
			else
				guaranteed_hit = 1
				cur_dense_blockers += blocker
				break

		for (var/atom/blocker in blockers["fd2"])
			if(blocker.flags_barrier & HANDLE_BARRIER_CHANCE)
				if(blocker.handle_barrier_chance())
					return blocker
			else
				guaranteed_hit++
				cur_dense_blockers += blocker
				break
		if (guaranteed_hit == 2)
			return pick(cur_dense_blockers) // Picks a random dense object from the list of dense objects

	return src // This should happen if the two barricades checked do not block the slash


/atom/proc/clear_path(atom/A, list/atom/ignore = list())
	if(get_dist(src, A) <= 1)
		return handle_barriers(A, ignore)

	var/turf/curT = get_turf(A)
	var/is_turf = isturf(A)
	for(var/turf/T in get_line(A, src))
		if(curT == T)
			continue
		if(T.density)
			return T
		for(var/atom/potential_dense_object in T)
			if(potential_dense_object.density)
				return potential_dense_object
		var/atom/result = T.handle_barriers(curT, list(A) + ignore)
		if(result != T)
			return result
		else if(is_turf && T == A || T == A.loc)
			break
	return src
