// --- Helper for crash response

/**
 * _scatter_riders_on_crash joustles mobs riding atop the tank in a random direction.
 *
 * This proc applies a 1.5s WEAKEN effect to all mobs atop it when the tank crashes into something with sufficient speed.
 * This includes large mobs such as ravagers, queens, kings, et-cetera.
 *
 * If a mob happens to be thrown OFF of a tank tile, they will instead get a 3 second stun.
 * ^^ See Move() function inside living.dm
 *
 * The intent of this proc is double: Allowing tank drivers to defend themselves and have a chance against xenos
 * atop the tank and also punish tank drivers for bad driving by fucking up the marines on top.
 *
 * Also scatters objs on top!
 *
 */
/obj/vehicle/multitile/tank/proc/_scatter_riders_on_crash()
	if(abs(move_momentum) < 1.6)
		return

	var/sweep_range = 3

	// Obj throwing is handled differently for performance
	// there's still a lot to optimize in case this is performance intensive. (I don't expect joustling to happen that often)
	// First order of business would be finding a way to do those calculations outside of the for loop ...
	// and use one single cur,throw_dir and start for all objs but that might produce throws with inconsistent directions

	for(var/obj/O in on_top_obj.Copy())
		if(!O || O.z != src.z)
			obj_clear_on_top(O)
			continue

		var/turf/start = get_turf(O)
		var/throw_dir = get_dir(src, start)
		if(!throw_dir)
			throw_dir = pick(GLOB.cardinals)

		var/turf/target = get_step(start, throw_dir)
		if(!target || (target in src.locs))
			step_away(O, src, sweep_range, 3)
			var/turf/cur = get_turf(O)
			target = get_step(cur, throw_dir)

		if(target && !(target in src.locs))
			obj_clear_on_top(O)
			O.throw_atom(target, sweep_range, SPEED_FAST)

	for(var/mob/living/M in on_top_mobs.Copy())
		if(!M || M.z != src.z)
			clear_on_top(M)
			continue

		var/turf/start = get_turf(M)
		var/throw_dir = get_dir(src, start)
		if(!throw_dir)
			throw_dir = pick(GLOB.cardinals)

		var/turf/next_out = get_step(start, throw_dir)
		if(next_out && !(next_out in src.locs))
			clear_on_top(M)
			step(M, throw_dir)
		else
			step_away(M, src, sweep_range, 3)

			var/turf/cur = get_turf(M)
			var/turf/next2 = get_step(cur, throw_dir)
			if(next2 && !(next2 in src.locs))
				clear_on_top(M)
				step(M, throw_dir)

		to_chat(M, SPAN_WARNING("You're thrown from [src]!"))
		playsound(M, "punch", 25, TRUE)
		shake_camera(M, 2, 1)

		if(!(get_turf(M) in src.locs))
			M.apply_effect(3, WEAKEN)
			clear_on_top(M)
			continue

		var/turf/current = get_turf(M)
		var/list/hull_neighbors = list()
		for(var/d in GLOB.cardinals)
			var/turf/H = get_step(current, d)
			if(H && (H in src.locs))
				hull_neighbors += H
		if(hull_neighbors.len)
			var/turf/spot = pick(hull_neighbors)
			var/ndir = get_dir(current, spot)
			if(ndir)
				step(M, ndir)
			M.apply_effect(1.5, WEAKEN)
			mark_on_top(M)

// --- motion geometry and transform math

/**
 * _current_center() builds a matrix of the tank's tiles and returns the center pair.
 *
 * The tank occupies a 3x3 set of tiles. We can imagine it as a matrix:
 *
 *(10,20) (11,20) (12,20)
 *(10,21) (11,21) (12,21)
 *(10,22) (11,22) (12,22)
 *
 * This proc gets the middle (1,1) element of the matrix and returns it, in this case, (11,21)
 *
 * Returns:
 * *  A LIST of two integer elements. [11,21]
 */
/obj/vehicle/multitile/tank/proc/_current_center()
	var/first = TRUE
	var/minx
	var/miny
	var/maxx
	var/maxy
	for(var/turf/T in locs)
		if(first)
			minx = maxx = T.x
			miny = maxy = T.y
			first = FALSE
		else
			if(T.x < minx)
				minx = T.x
			if(T.x > maxx)
				maxx = T.x
			if(T.y < miny)
				miny = T.y
			if(T.y > maxy)
				maxy = T.y

	return list(minx + 1, miny + 1)

/**
 * calculates how many 90-degree rotations are needed to go from one cardinal direction to another.
 *
 * NORTH → EAST  = +1 (90° CW)
 * NORTH → WEST  = -1 (90° CCW)
 * NORTH → SOUTH = +2 (180°)
 * EAST → SOUTH  = +1 (90° CW)
 * SOUTH → WEST  = +1 (90° CW)
 *
 * This proc is a key part of the positioning system when the vehicle rotates.
 *
 * Arguments:
 * * old_dir = The direction we are initially at
 * * new_dir = The direction we want to be at
 *
 * Returns:
 * * 0 : No rotation needed
 * * 1 : 90° clockwise rotation
 * * -1: 90° counter-clockwise rotation
 * * 2 : 180° rotation. Will never happen because the tank can't turn over like that in one move.
 */
/obj/vehicle/multitile/tank/proc/_quarter_turns(old_dir, new_dir)
	if(old_dir == new_dir)
		return 0
	switch(old_dir)
		if(NORTH)
			if(new_dir == EAST)
				return 1
			if(new_dir == WEST)
				return -1
			if(new_dir == SOUTH)
				return 2
		if(SOUTH)
			if(new_dir == WEST)
				return 1
			if(new_dir == EAST)
				return -1
			if(new_dir == NORTH)
				return 2
		if(EAST)
			if(new_dir == SOUTH)
				return 1
			if(new_dir == NORTH)
				return -1
			if(new_dir == WEST)
				return 2
		if(WEST)
			if(new_dir == NORTH)
				return 1
			if(new_dir == SOUTH)
				return -1
			if(new_dir == EAST)
				return 2
	return 0

/**
 * _rotated_offset takes an offset (dx, dy) and rotates it by 90% degree increments
 *
 * this proc applies 2D coordinate rotation mathematics to transform a position offset
 * based on the rotation amount calculated by _quarter_turns.
 *
 * Arguments:
 * * dx = x axis position, relative to the tank
 * * dy = y axis position, relative to the tank
 * * k  = a numeric value acquired from _quarter_turns to know how many turns we have to do
 *
 * Returns:
 * * a LIST, containing a 2-slot permutation of {{dx, -dx} {dy, -dy}} depending on K.
 */
/obj/vehicle/multitile/tank/proc/_rotated_offset(dx, dy, k)
	if(!k)
		return list(dx, dy)
	if(k == 2)
		return list(-dx, -dy)  // 180°
	if(k == 1)
		return list(dy, -dx)   // CW 90°
	// k == -1 (CCW 90°)
	return list(-dy, dx)

/**
 * _update_riders_after_motion coordinates moving all mobs atop the tank whenever it moves or rotates.
 *
 * This proc is the main coordination function that handles moving all riders atop the tank.
 * It combines translation, rotation, and collision detection to keep riders properly positioned on the hull.
 *
 * First it calls _quarter_turns to understand what kind of rotations it'll need to turn from one orientation to the other.
 * Then it calls _rotated_offset to know where to position the riders.
 * Lastly, it applies those changes.
 *
 * Arguments:
 * * old_cx   = the X axis position currently occupied by the tank
 * * old_cy   = the y axis position currently occupied by the tank
 * * old_dir  = the direction the tank is currently facing. N/E/S/W
 * * new_cx   = the X axis position that we are moving to
 * * new_cy   = the y axis position that we are moving to
 * * new_dir  = the direction we want to face. N/E/S/W
 *
 */
/obj/vehicle/multitile/tank/proc/_update_riders_after_motion(old_cx, old_cy, old_dir, new_cx, new_cy, new_dir)
	var/k = _quarter_turns(old_dir, new_dir) // -1,0,1,2

	// simpler version for objs
	for(var/obj/O in on_top_obj.Copy())
		if(!O || O.z != src.z)
			obj_clear_on_top(O)
			continue

		// Don't move body bags atop roller beds. We will handle those when we move the roller beds themselves.
		if(istype(O, /obj/structure/closet/bodybag))
			var/obj/structure/closet/bodybag/BB = O
			if(BB.roller_buckled)
				continue

		var/turf/from = get_turf(O)
		if(!from)
			obj_clear_on_top(O)
			continue

		var/list/rd = _rotated_offset(from.x - old_cx, from.y - old_cy, k)
		var/turf/target = locate(new_cx + rd[1], new_cy + rd[2], src.z)

		if(target && (target in src.locs) && target != from)
			O.forceMove(target)
			obj_mark_on_top(O)
			if(istype(O, /obj/structure/bed/roller))
				var/obj/structure/bed/roller/R = O
				if(R.buckled_bodybag)
					R.buckled_bodybag.forceMove(target)
					obj_mark_on_top(R.buckled_bodybag)
		else if(from in src.locs)
			obj_mark_on_top(O)
		else
			obj_clear_on_top(O)

	for(var/mob/living/M in on_top_mobs.Copy())
		if(!M || M.z != src.z)
			clear_on_top(M)
			continue

		var/turf/from = get_turf(M)
		if(!from)
			clear_on_top(M)
			continue

		// If the mob is buckled to something, we'll skip it, because the buckled obj has already moved with it.
		if(M.buckled)
			continue

		// Offset from OLD center -> rotate by k -> translate to NEW center
		var/odx = from.x - old_cx
		var/ody = from.y - old_cy
		var/list/rd = _rotated_offset(odx, ody, k)
		var/ndx = rd[1]
		var/ndy = rd[2]
		var/turf/target = locate(new_cx + ndx, new_cy + ndy, src.z)

		// this shouldn't happen, but just to be safe.
		if(!target || !(target in src.locs))
			if(from in src.locs)
				mark_on_top(M)
			else
				clear_on_top(M)
			continue

		// If target is blocked by a non-rider dense atom, (shouldn't happen cuz tank runs over shit) keep if possible
		var/blocked = FALSE
		if(target.density)
			blocked = TRUE
		else
			for(var/atom/A in target)
				if(A != src && A.density && (!ismob(A) || !(A in on_top_mobs)))
					blocked = TRUE
					break

		if(blocked)
			if(from in src.locs)
				mark_on_top(M)
			else
				clear_on_top(M)
			continue

		// Move and keep elevation
		if(target != from)
			M.forceMove(target)
		mark_on_top(M)

// --- Helper for layering effects

/**
 * simply brings a rider's layer atop the tanks.
 *
 * TANK_RIDER_LAYER being at 4.51 is not arbitrary.
 * The tank chassis is set at 4.1, but the turret is at 4.5.
 * Therefore, 4.51 is needed to avoid clipping.
 *
 * Arguments:
 * * mob/living/M = Mob whose layer priority is being increased.
 */
/obj/vehicle/multitile/tank/proc/_apply_rider_visuals(mob/living/M)
	M.layer = TANK_RIDER_LAYER
	M.pixel_y = M.old_y + 12

// --- helpers for handlign interactions with grabbed mobs

/**
 * This proc allows a marine to pull another one up the tank once he finishes climbing.
 *
 * _carry_move_with_grabs does something similar to grabbing someone as you climb a window frame:
 * You'll pull the marine you're grabbing up with you as soon as YOUR climb_onto finishes.
 * The marine pulled up will get a 2 second weaken, but they can be shaked out of it.
 *
 * !!!! The order of the operations of clearing, marking and moving is not arbitrary !!!!
 *
 * Arguments:
 * * mob/living/user = Mob doing the pulling.
 * * turf/dest       = Which turf on the tank we're moving to
 */
/obj/vehicle/multitile/tank/proc/_carry_move_with_grabs(mob/living/user, turf/dest)
	var/list/grabbed_things = list()
	for(var/obj/item/grab/G in list(user.l_hand, user.r_hand))
		if(G?.grabbed_thing)
			grabbed_things += G.grabbed_thing

	for(var/atom/movable/thing as anything in grabbed_things)
		if(isliving(thing))
			var/mob/living/L = thing
			L.apply_effect(2, WEAKEN)
			_add_to_top_buckled_to(L, dest)
			L.forceMove(dest)
			mark_on_top(L)

		else if(isobj(thing))
			var/obj/O = thing
			if(O.is_allowed_atop_vehicle)
				_add_to_top_buckled_entity(O, dest)

	user.forceMove(dest)
	mark_on_top(user)

/**
 * Handles the addition of a roller bed whom a Mob is buckled to onto the top of the tank
 *
 * Mobs can be buckled to roller beds and pulled atop the tank. If this happens, we need to take the roller bed up with us
 *
 * Arguments:
 * * mob/living/L     = The mob that may be buckled to a roller bed.
 * * turf/dest        = Which turf onto the tank we're moving to
 */

/obj/vehicle/multitile/tank/proc/_add_to_top_buckled_to(mob/living/L, turf/dest)
	if(L.buckled && istype(L.buckled, /obj/structure/bed/roller))
		var/obj/structure/bed/roller/R = L.buckled
		R.forceMove(dest)
		obj_mark_on_top(R)

/**
 * Handles the addition of entities buckled to an obj to atop the tank
 *
 * Roller beds can have mobs and body or stasis bags attached to it. If we are pulling a roller bed onhto the tank with an attached...
 * bag or mob, we should ensure those go up with it correctly.
 *
 * Arguments:
 * * obj/object      = The object that may have living beings buckled to it
 * * turf/dest       = Which turf onto the tank we're moving to
 */

/obj/vehicle/multitile/tank/proc/_add_to_top_buckled_entity(obj/object, turf/dest)
	if(istype(object, /obj/structure/bed/roller))
		var/obj/structure/bed/roller/R = object

		R.forceMove(dest)
		obj_mark_on_top(R)
		if(R.buckled_mob)
			var/mob/living/L = R.buckled_mob
			L.forceMove(dest)
			mark_on_top(L)
		else if (R.buckled_bodybag)
			var/obj/structure/closet/bodybag/BB = R.buckled_bodybag
			BB.forceMove(dest)
			obj_mark_on_top(BB)
	else if (istype(object, /obj/structure/closet/bodybag)) // Grab is on a bodybag, possibly atop a roller.
		var/obj/structure/closet/bodybag/BB = object

		if (BB.roller_buckled)
			var/obj/structure/bed/roller/R = BB.roller_buckled
			R.forceMove(dest)
			obj_mark_on_top(R) // mark ASAP to prevent bodybag from unbuckling
			BB.forceMove(dest)
			obj_mark_on_top(BB)

		else // lone bodybag
			BB.forceMove(dest)
			obj_mark_on_top(BB)

	else // any other obj
		object.forceMove(dest)
		obj_mark_on_top(object)

/**
 * This proc allows a marine to pull another one DOWN the tank once he finishes climbing down.
 *
 * Opposite of carry_move_with_grabs. This one does the same thing but for climbing DOWN.
 *
 * !!!! The order of the operations of clearing, marking and moving is not arbitrary !!!!
 *
 * Arguments:
 * * mob/living/user = Mob doing the pulling.
 * * turf/dest       = Which turf on the tank we're moving to
 */
/obj/vehicle/multitile/tank/proc/_carry_remove_with_grabs(mob/living/user, turf/dest)
	var/list/grabbed_things = list()
	for(var/obj/item/grab/G in list(user.l_hand, user.r_hand))
		if(G?.grabbed_thing)
			grabbed_things += G.grabbed_thing

	for(var/atom/movable/thing as anything in grabbed_things)
		if(isliving(thing)) // GRAB is on MOB
			var/mob/living/L = thing
			_remove_from_top_buckled_to(L, dest)
			clear_on_top(L)
			L.forceMove(dest)

		else if(isobj(thing)) // GRAB is on OBJ
			var/obj/O = thing
			if(O.is_allowed_atop_vehicle)
				_remove_from_top_buckled_entity(O, dest)

	clear_on_top(user)
	user.forceMove(dest)

/**
 * Handles the removal of a roller bed whom a Mob is buckled to off the top of the tank
 *
 * Mobs can be buckled to roller beds and pulled off of the tank. If this happens, we need to take the roller bed down with us
 *
 * Arguments:
 * * mob/living/L     = The mob that may be buckled to a roller bed.
 * * turf/dest        = Which turf off the tank we're moving to
 */

/obj/vehicle/multitile/tank/proc/_remove_from_top_buckled_to(mob/living/L, turf/dest)
	if(L.buckled && istype(L.buckled, /obj/structure/bed/roller))
		var/obj/structure/bed/roller/R = L.buckled
		R.forceMove(dest)
		obj_clear_on_top(R)

/**
 * Handles the removal of entities buckled to an obj from atop the tank
 *
 * Roller beds can have mobs and body or stasis bags attached to it. If we are pulling a roller bed down the tank with an attached...
 * bag or mob, we should ensure those go down with it correctly.
 *
 * Arguments:
 * * obj/object      = The object that may have living beings buckled to it
 * * turf/dest       = Which turf off the tank we're moving to
 */

/obj/vehicle/multitile/tank/proc/_remove_from_top_buckled_entity(obj/object, turf/dest)
	if(istype(object, /obj/structure/bed/roller))
		var/obj/structure/bed/roller/R = object

		if(R.buckled_mob)
			var/mob/living/L = R.buckled_mob
			obj_clear_on_top(object) // clear first then move to prevent buckled mobs from getting debuffed for improperly dismounting.
			object.forceMove(dest)
			clear_on_top(L)

		else if (R.buckled_bodybag)
			var/obj/structure/closet/bodybag/BB = R.buckled_bodybag
			object.forceMove(dest)
			obj_clear_on_top(object)
			BB.forceMove(dest) // must be moved last to avoid unbuckling
			obj_clear_on_top(BB)

		else // empty roller bed
			object.forceMove(dest)
			obj_clear_on_top(object)

	else if (istype(object, /obj/structure/closet/bodybag)) // Grab is on a bodybag, possibly atop a roller.
		var/obj/structure/closet/bodybag/BB = object

		if (BB.roller_buckled)
			var/obj/structure/bed/roller/R = BB.roller_buckled
			R.forceMove(dest)
			obj_clear_on_top(R)
			BB.forceMove(dest) // must be moved last to avoid unbuckling
			obj_clear_on_top(BB)

		else // lone bodybag
			object.forceMove(dest)
			obj_clear_on_top(object)

	else // any other item
		object.forceMove(dest)
		obj_clear_on_top(object)

// --- blocking helpers. Checks if turf is blocked, etc.

/**
 * This proc checks a specific turf and returns false if anything dense is on it, except for a mob.
 *
 * _blocked_except_mobs is a helper that check if a turf/T has anything dense in it.
 * If there is something dense in it and it is NOT a mob, it returns TRUE, otherwise, it returns false.
 *
 * Arguments:
 * * turf/T  = Which turf we're checking for dense atoms in
 *
 * Returns:
 * * TRUE    = If something dense is present, and it is not a mob.
 * * FALSE   = If the turf is clear of dense objects, or if the only dense objects in it are mobs.
 */
/obj/vehicle/multitile/tank/proc/_blocked_except_mobs(turf/T)
	if(!istype(T))
		return TRUE
	if(T.density)
		return TRUE
	for(var/atom/A in T)
		if(A == src)
			continue
		if(ismob(A))
			continue
		if(A.density)
			return TRUE
	return FALSE

/**
 * This proc checks if a specific turf/spot is a valid climbing target
 *
 * We are mostly interested in ensuring that the tank hasn't moved too far away, and this function helps with that.
 * It also has a couple of other edge cases such as being in a different Z, or having a climb-spot blocked by
 * anything other than a mob, juuuuust to be safe.
 *
 * Arguments:
 * * turf/spot       = Which turf we want to climb onto
 * * mob/living/user = Whoever wants to climb onto spot
 *
 * Returns:
 * * TRUE    = If nothing is blocking the turf
 * * FALSE   = If something is blocking the turf.
 */
/obj/vehicle/multitile/tank/proc/_validate_climb_target(mob/living/user, turf/spot)
	if(!istype(user) || !istype(spot))
		return FALSE
	if(user.z != z)
		return FALSE
	if(get_dist(spot, get_turf(user)) != 1)
		return FALSE
	if(_blocked_except_mobs(spot))
		return FALSE
	return TRUE

/**
 * Helper function to know if a mob is a rider of this specific tank
 *
 * Checks if this tank is the 'tank_on_top_of' of a given mob.
 *
 * Arguments:
 * * atom/movable/AM = whatever mob/atom we want to check if its a rider.
 *
 * Returns:
 * * TRUE    = If AM is a mob/living and this tank is tank_on_top_of.
 * * FALSE   = If AM is not a mob/living, or if this tank is not tank_on_top_of.
 */
/obj/vehicle/multitile/tank/proc/_is_our_rider(atom/movable/AM)
	if(!ismob(AM))
		return FALSE
	var/mob/living/M = AM
	return istype(M) && M.tank_on_top_of == src
