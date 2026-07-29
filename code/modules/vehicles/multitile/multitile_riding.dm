//-----------------------------
// On-hull riding. Lets a mob or obj stand atop a multitile vehicle's hull, tracked
// via the /datum/component/vehicle_rider component.
//-----------------------------

/// TRUE while `user` should be granted an instant climb onto this vehicle. No-op except for the tank's Praetorian Dancer interaction.
/obj/vehicle/multitile/proc/has_instant_dancer_climb(mob/living/user)
	return FALSE

/**
 * Marks a mob as riding atop this vehicle's hull.
 *
 * Adds the mob to on_top_mobs, attaches a /datum/component/vehicle_rider, and applies rider visuals.
 * Un-hides a hidden xeno, if applicable.
 *
 * Arguments:
 * * mob/living/rider_mob = The mob being marked ontop.
 */
/obj/vehicle/multitile/proc/mark_on_top(mob/living/rider_mob)
	if(!istype(rider_mob))
		return
	if(rider_mob.z != z)
		return
	if(!(get_turf(rider_mob) in locs))
		return
	if(rider_mob.get_tank_on_top_of() == src)
		return
	on_top_mobs |= rider_mob
	rider_mob.AddComponent(/datum/component/vehicle_rider, src)
	_apply_rider_visuals(rider_mob)

	if(isxeno(rider_mob))
		var/mob/living/carbon/xenomorph/X = rider_mob
		if(X.layer == XENO_HIDING_LAYER)
			var/datum/action/xeno_action/onclick/xenohide/hide = get_action(X, /datum/action/xeno_action/onclick/xenohide)
			if(hide)
				hide.remove_hide_status() // prevents cheesing the layer system

/**
 * mark_on_top() for a mob mounted via a collision rather than a consensual climb_onto().
 * Also brings along whichever of `rider_mob`'s two held items ended up dropped on the ground.
 *
 * Arguments:
 * * mob/living/rider_mob = The mob being mounted.
 * * obj/item/prev_l_hand = Whatever was in rider_mob's left hand right before the collision, or null.
 * * obj/item/prev_r_hand = Whatever was in rider_mob's right hand right before the collision, or null.
 */
/obj/vehicle/multitile/proc/mark_on_top_after_ram(mob/living/rider_mob, obj/item/prev_l_hand, obj/item/prev_r_hand)
	mark_on_top(rider_mob)
	for(var/obj/item/dropped_item in list(prev_l_hand, prev_r_hand))
		if(!dropped_item || QDELETED(dropped_item))
			continue
		if(dropped_item.loc == rider_mob) // still held - travels with rider_mob automatically, nothing to do
			continue
		obj_mark_on_top(dropped_item)

/**
 * mark_on_top(), but for an obj/ instead of a mob.
 *
 * Arguments:
 * * obj/rider_obj = The obj being marked ontop.
 */
/obj/vehicle/multitile/proc/obj_mark_on_top(obj/rider_obj)
	if(!istype(rider_obj))
		return
	if(!rider_obj.is_allowed_atop_vehicle)
		return
	if(rider_obj.z != z)
		return
	if(!(get_turf(rider_obj) in locs))
		return
	if(rider_obj.get_tank_on_top_of() == src)
		rider_obj.layer = TANK_RIDER_OBJ_LAYER // prevents a visual bug with layering
		return
	on_top_obj |= rider_obj
	rider_obj.AddComponent(/datum/component/vehicle_rider, src)
	rider_obj.layer = TANK_RIDER_OBJ_LAYER
	if(istype(rider_obj, /obj/structure/closet/bodybag))
		var/obj/structure/closet/bodybag/BB = rider_obj
		if(BB.roller_buckled)
			BB.pixel_y = BB.buckle_offset + 12
		else
			BB.pixel_y = initial(rider_obj.pixel_y) + 12
	else
		rider_obj.pixel_y = initial(rider_obj.pixel_y) + 12

/**
 * Removes rider effects from a mob who was previously atop this vehicle.
 * Resets layer/plane/pixel_y, removes from on_top_mobs, removes the vehicle_rider component.
 *
 * Arguments:
 * * mob/living/rider_mob = The mob who has disembarked.
 */
/obj/vehicle/multitile/proc/clear_on_top(mob/living/rider_mob)
	if(!istype(rider_mob))
		return
	on_top_mobs -= rider_mob
	qdel(rider_mob.GetComponent(/datum/component/vehicle_rider))
	rider_mob.layer   = initial(rider_mob.layer)
	rider_mob.plane   = initial(rider_mob.plane)
	rider_mob.pixel_y = initial(rider_mob.pixel_y)

/// clear_on_top(), but for an obj/ instead of a mob.
/obj/vehicle/multitile/proc/obj_clear_on_top(obj/rider_obj)
	if(!istype(rider_obj))
		return
	on_top_obj -= rider_obj
	qdel(rider_obj.GetComponent(/datum/component/vehicle_rider))
	rider_obj.layer = initial(rider_obj.layer)
	if(istype(rider_obj, /obj/structure/closet/bodybag))
		var/obj/structure/closet/bodybag/BB = rider_obj
		if(BB.roller_buckled)
			BB.pixel_y = BB.buckle_offset
		else
			BB.pixel_y = initial(rider_obj.pixel_y)
	else
		rider_obj.pixel_y = initial(rider_obj.pixel_y)

/// Removes any rider that's no longer actually standing on this vehicle's footprint, refreshes visuals for the rest. Called defensively after a crash or forced move.
/obj/vehicle/multitile/proc/revalidate_on_top()
	for(var/mob/living/M in on_top_mobs.Copy())
		if(!M || M.z != z || !(get_turf(M) in locs))
			clear_on_top(M)
		else
			_apply_rider_visuals(M)

/// Whether AM is a mob/living currently riding on top of this specific vehicle.
/obj/vehicle/multitile/proc/_is_our_rider(atom/movable/AM)
	if(!ismob(AM))
		return FALSE
	var/mob/living/rider_mob = AM
	return istype(rider_mob) && rider_mob.get_tank_on_top_of() == src

/**
 * Lets a mob climb onto this vehicle's hull. Called by Collided() (multitile_bump.dm) or a mob's own climb verb.
 * Runs edge case checks, waits out a climb delay, then commits, pulling any grabbed mob/obj along.
 *
 * Arguments:
 * * mob/living/user = The mob trying to get atop the vehicle.
 * * turf/preferred = The exact turf of the vehicle being climbed onto.
 */
/obj/vehicle/multitile/proc/climb_onto(mob/living/user, turf/preferred)
	if(!istype(user))
		return

	if(user.action_busy)
		return

	if(exceeds_desant_cap())
		to_chat(user, SPAN_WARNING("[src] is moving too fast to climb onto!"))
		return

	if(!_validate_climb_target(user, preferred, TRUE))
		to_chat(user, SPAN_WARNING("You can't climb there."))
		return

	user.visible_message(
		SPAN_WARNING("[user] starts climbing onto [src]."),
		SPAN_WARNING("You start climbing onto [src]."))

	var/climb_speed_factor = (move_momentum / move_max_momentum) // % of our max speed attained.

	if(has_instant_dancer_climb(user))
		// Dodge's evasive stance skips every delay branch below entirely.

	else if(health == 0) // When broken, everyone takes 0.20 seconds to climb up. Keep in mind that the real perceived value is around 2-3x higher when you take in account lag.
		if(!do_after (user, 0.20 SECONDS, INTERRUPT_MOVED, BUSY_ICON_CLIMBING, numticks = 1))
			to_chat(user, SPAN_WARNING("You stop climbing onto [src]."))
			return

	else if(isxeno(user)) // Xenos take longer to climb to avoid accidentally getting on top while slashing inside boiler gas.
		// takes between 0.8 seconds when still and 2 seconds when at full speed. (You'd have to climb through one of the sides) OR pounce on it.
		if(!do_after(user, max((2 * climb_speed_factor), 0.80) SECONDS, INTERRUPT_MOVED, BUSY_ICON_CLIMBING, numticks = 4))
			to_chat(user, SPAN_WARNING("You stop climbing onto [src]."))
			return

	// Humans and preds climb up faster. Humans can't climb down instantly.
	// takes between 0.25 seconds when still and 1.20 second when at full speed (You'd have to climb through one of the sides)
	else if(!do_after(user, max((1.20 * climb_speed_factor), 0.30) SECONDS, INTERRUPT_MOVED, BUSY_ICON_CLIMBING, numticks = 3))
		to_chat(user, SPAN_WARNING("You stop climbing onto [src]."))
		return

	if(!_validate_climb_target(user, preferred, TRUE))
		to_chat(user, SPAN_WARNING("The spot on [src] is no longer reachable."))
		return

	_carry_move_with_grabs(user, preferred)
	user.visible_message(
		SPAN_WARNING("[user] climbs onto [src]."),
		SPAN_WARNING("You climb onto [src]."))
	return

/**
 * Lets a mob climb down off this vehicle's hull onto an adjacent turf. Only interrupts on
 * incapacitation, so disembarking still works while the vehicle is moving.
 *
 * Arguments:
 * * mob/living/user = The mob trying to get down.
 * * turf/target = The turf being climbed down onto.
 */
/obj/vehicle/multitile/proc/climb_down(mob/living/user, turf/target)
	if(user.action_busy)
		return

	if(!_validate_climb_target(user, target, FALSE))
		return

	var/climb_speed_factor = (move_momentum / move_max_momentum) // % of our max speed attained.

	user.visible_message(
		SPAN_WARNING("[user] starts climbing down from [src]."),
		SPAN_WARNING("You start climbing down from [src]."))

	if(has_instant_dancer_climb(user))
		// Dodge's evasive stance skips the delay entirely.

	else if(!ishuman(user)) // Xenos and preds can always climb down with almost no delay to avoid situations where they get stuck atop the vehicle.
		// The tiny delay here is meant to prevent fast castes from accidentally disembarking from a misinput
		if(!do_after(user,  0.20 SECONDS, INTERRUPT_INCAPACITATED, BUSY_ICON_GENERIC, numticks = 1))
			to_chat(user, SPAN_WARNING("You stop climbing down from [src]."))
			return

	// Humans take at most 0.9 seconds to climb down at full speed, and 0.30 when standing still.
	else if(!do_after(user, max((0.9 * climb_speed_factor), 0.30) SECONDS, INTERRUPT_INCAPACITATED, BUSY_ICON_GENERIC, numticks = 3))
		to_chat(user, SPAN_WARNING("You stop climbing down from [src]."))
		return

	// edge case where the vehicle moves while we're climbing down
	if(!_validate_climb_target(user, target, FALSE))
		to_chat(user, SPAN_WARNING("The spot is no longer reachable."))
		return
	_carry_remove_with_grabs(user, target)
	user.visible_message(
		SPAN_WARNING("[user] climbs down from [src]."),
		SPAN_WARNING("You climb down from [src]."))
	return

/**
 * Allows a mob to move freely atop this vehicle, or into/out of it while riding.
 * Overrides /atom's BlockedPassDirs.
 *
 * Arguments:
 * * atom/movable/mover = The atom attempting to move on this vehicle's turf.
 * * target_dir = The direction being moved towards.
 */
/obj/vehicle/multitile/BlockedPassDirs(atom/movable/mover, target_dir)
	if(ismob(mover))
		var/mob/living/mover_mob = mover
		if(istype(mover_mob) && mover_mob.get_tank_on_top_of() == src)
			var/turf/start = get_turf(mover_mob)
			var/turf/target = get_step(start, target_dir)
			if(target && (target in src.locs))
				return NO_BLOCKED_MOVEMENT
	else if(isobj(mover))
		var/obj/mover_obj = mover
		if(mover_obj.is_atop_vehicle())
			var/turf/start = get_turf(mover_obj)
			var/turf/target = get_step(start, target_dir)
			if(target && (target in src.locs))
				return NO_BLOCKED_MOVEMENT
	var/ret = ..()
	if(ret != null)
		return ret
	return null

/// Brings a rider's layer atop the vehicle's own.
/obj/vehicle/multitile/proc/_apply_rider_visuals(mob/living/M)
	M.update_layer()
	M.pixel_y = M.old_y + 12

/**
 * Pulls a grabbed mob/obj up onto the vehicle along with `user` once their climb finishes.
 * The order of clearing, marking, and moving is not arbitrary.
 *
 * Arguments:
 * * mob/living/user = Mob doing the pulling.
 * * turf/dest = Which turf on the vehicle we're moving to.
 */
/obj/vehicle/multitile/proc/_carry_move_with_grabs(mob/living/user, turf/dest)
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
			_reignite_mounted_flame(L)

		else if(isobj(thing))
			var/obj/O = thing
			if(O.is_allowed_atop_vehicle)
				_add_to_top_buckled_entity(O, dest)

	user.forceMove(dest)
	mark_on_top(user)
	_reignite_mounted_flame(user)

/// Re-fires Crossed() on any flame at a rider's tile, since forceMove() runs before mark_on_top().
/obj/vehicle/multitile/proc/_reignite_mounted_flame(mob/living/rider)
	var/obj/flamer_fire/mounted_fire = locate() in get_turf(rider)
	if(mounted_fire)
		mounted_fire.Crossed(rider)

/// Brings a roller bed `L` is buckled to up onto the vehicle alongside them.
/obj/vehicle/multitile/proc/_add_to_top_buckled_to(mob/living/L, turf/dest)
	if(L.buckled && istype(L.buckled, /obj/structure/bed/roller))
		var/obj/structure/bed/roller/R = L.buckled
		R.forceMove(dest)
		obj_mark_on_top(R)

/// Brings whatever's buckled to `object` (a roller bed's mob/bodybag) up onto the vehicle alongside it.
/obj/vehicle/multitile/proc/_add_to_top_buckled_entity(obj/object, turf/dest)
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
 * Pulls a grabbed mob/obj down off the vehicle along with `user` once their climb-down finishes.
 * The order of clearing, marking, and moving is not arbitrary.
 *
 * Arguments:
 * * mob/living/user = Mob doing the pulling.
 * * turf/dest = Which turf off the vehicle we're moving to.
 */
/obj/vehicle/multitile/proc/_carry_remove_with_grabs(mob/living/user, turf/dest)
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

/// Brings a roller bed `L` is buckled to down off the vehicle alongside them.
/obj/vehicle/multitile/proc/_remove_from_top_buckled_to(mob/living/L, turf/dest)
	if(L.buckled && istype(L.buckled, /obj/structure/bed/roller))
		var/obj/structure/bed/roller/R = L.buckled
		R.forceMove(dest)
		obj_clear_on_top(R)

/// Brings whatever's buckled to `object` (a roller bed's mob/bodybag) down off the vehicle alongside it.
/obj/vehicle/multitile/proc/_remove_from_top_buckled_entity(obj/object, turf/dest)
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

/**
 * Whether turf T has anything dense on it, other than a mob. If user and from are both
 * supplied, directional obstacles like barricades get a real directional check. Falls back
 * to a blanket density scan otherwise.
 *
 * Arguments:
 * * T = The turf being checked for dense atoms.
 * * user = Whoever is trying to move there, needed for the directional check.
 * * from = The turf the mover is actually coming from, if known.
 *
 * Returns:
 * * TRUE = Something blocks this direction, or something dense that isn't a mob is present.
 * * FALSE = The turf is clear, only mobs are present, or the obstacle doesn't block.
 */
/obj/vehicle/multitile/proc/_blocked_except_mobs(turf/T, mob/living/user, turf/from)
	if(!istype(T))
		return TRUE

	if(user && from && from != T)
		var/direct = get_dir(from, T)
		if(direct)
			if(from.BlockedExitDirs(user, direct))
				return TRUE
			if(T.BlockedPassDirs(user, direct))
				return TRUE
			for(var/atom/A in from)
				if(A == src || ismob(A))
					continue
				if(A.BlockedExitDirs(user, direct))
					return TRUE
			for(var/atom/A in T)
				if(A == src || ismob(A))
					continue
				if(A.BlockedPassDirs(user, direct))
					return TRUE
			return FALSE

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
 * Whether spot is a valid climb target: same z, adjacent to user, and not blocked by
 * anything other than a mob.
 *
 * Arguments:
 * * user = Whoever wants to climb onto/down from spot.
 * * spot = The turf being climbed onto or down from.
 *
 * Returns:
 * * TRUE = Nothing is blocking the turf.
 * * FALSE = Something is blocking the turf.
 */
/obj/vehicle/multitile/proc/_validate_climb_target(mob/living/user, turf/spot)
	if(!istype(user) || !istype(spot))
		return FALSE
	if(user.z != z)
		return FALSE
	var/turf/user_turf = get_turf(user)
	if(get_dist(spot, user_turf) != 1)
		return FALSE
	if(_blocked_except_mobs(spot, user, user_turf))
		return FALSE
	return TRUE

//-----------------------------
// Rider tracking across movement. Keeps riders correctly positioned atop the hull whenever
// this vehicle moves, rotates, crashes, or gets knocked back.
//-----------------------------

/**
 * Joustles mobs riding atop this vehicle in a random direction when it crashes with enough speed.
 * A mob thrown clear of the hull gets a weaken; a mob thrown into a wall or off an edge falls off entirely.
 * Objs scatter the same way, except any flagged immune_to_tank_crash_scatter.
 *
 * Arguments:
 * * force_momentum = Momentum value to gate and scale this scatter on.
 * * min_force = force_momentum must reach at least this to trigger anything.
 * * exclude_xenos = If TRUE, xeno riders are left alone entirely.
 */
/obj/vehicle/multitile/proc/_scatter_riders_on_crash(force_momentum = move_momentum, min_force = 1.6, exclude_xenos = FALSE)
	if(abs(force_momentum) < min_force)
		return

	var/sweep_range = 3
	var/src_z = src.z
	var/list/src_locs = src.locs

	for(var/obj/O in on_top_obj.Copy())
		if(!O || O.z != src_z)
			obj_clear_on_top(O)
			continue

		if(O.immune_to_tank_crash_scatter)
			continue

		var/turf/start = get_turf(O)
		var/throw_dir = get_dir(src, start)
		if(!throw_dir)
			throw_dir = pick(GLOB.cardinals)

		var/turf/target = get_step(start, throw_dir)
		if(!target || (target in src_locs) || target.density)
			step_away(O, src, sweep_range, 3)
			var/turf/cur = get_turf(O)
			target = get_step(cur, throw_dir)

		if(target && !(target in src_locs) && !target.density)
			obj_clear_on_top(O)
			O.throw_atom(target, sweep_range, SPEED_FAST)
		else if(!(start in src_locs))
			obj_clear_on_top(O)

	for(var/mob/living/M in on_top_mobs.Copy())
		if(!M || M.z != src_z)
			clear_on_top(M)
			continue

		if(exclude_xenos && isxeno(M))
			continue

		var/turf/start = get_turf(M)
		var/throw_dir = get_dir(src, start)
		if(!throw_dir)
			throw_dir = pick(GLOB.cardinals)

		var/turf/next_out = get_step(start, throw_dir)

		if(next_out && !(next_out in src_locs) && !next_out.density)
			M.forceMove(next_out)
			clear_on_top(M)
		else
			step_away(M, src, sweep_range, 3)
			var/turf/cur = get_turf(M)
			var/turf/next2 = get_step(cur, throw_dir)
			if(next2 && !(next2 in src_locs) && !next2.density)
				M.forceMove(next2)
				clear_on_top(M)

		to_chat(M, SPAN_WARNING("You're thrown from [src]!"))
		playsound(M, "punch", 25, TRUE)
		shake_camera(M, 2, 1)

		var/turf/final_pos = get_turf(M)

		if(!(final_pos in src_locs))
			M.apply_effect(3, WEAKEN)
			clear_on_top(M)
			continue

		var/list/hull_neighbors = list()
		for(var/d in GLOB.cardinals)
			var/turf/H = get_step(final_pos, d)
			if(H && (H in src_locs) && !H.density)
				hull_neighbors += H

		if(hull_neighbors.len)
			var/turf/spot = pick(hull_neighbors)
			M.forceMove(spot)
			M.apply_effect(1.5, WEAKEN)
			mark_on_top(M)

/// Whether this vehicle is currently moving too fast to safely carry riders, per desant_momentum_cap.
/obj/vehicle/multitile/proc/exceeds_desant_cap()
	if(!desant_momentum_cap || !move_max_momentum)
		return FALSE
	return (abs(move_momentum) / move_max_momentum) >= desant_momentum_cap

/**
 * Throws every non-xeno rider and item off this vehicle once it's moving too fast to carry them
 * safely, per desant_momentum_cap. No-ops if the cap isn't currently exceeded. Reuses
 * _scatter_riders_on_crash()'s own throw physics, minus its crash-force floor and with xenos exempt.
 */
/obj/vehicle/multitile/proc/_joust_riders_over_desant_cap()
	if(!exceeds_desant_cap())
		return
	if(!length(on_top_mobs) && !length(on_top_obj))
		return
	_scatter_riders_on_crash(move_momentum, min_force = 0, exclude_xenos = TRUE)

/**
 * Builds a matrix of this vehicle's occupied tiles and returns a consistent anchor coordinate pair
 * from it. Not necessarily the true geometric center for an even-width footprint, but consistent
 * between an old and new position, which is all the rider-translation math needs.
 *
 * Returns:
 * * A list of two integers, {x, y}.
 */
/obj/vehicle/multitile/proc/_current_center()
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
 * Calculates how many 90-degree rotations are needed to go from one cardinal direction to another.
 *
 * Arguments:
 * * old_dir = The direction we are initially at.
 * * new_dir = The direction we want to be at.
 *
 * Returns:
 * * 0 = No rotation needed.
 * * 1 = 90 degree clockwise rotation.
 * * -1 = 90 degree counter-clockwise rotation.
 * * 2 = 180 degree rotation.
 */
/obj/vehicle/multitile/proc/_quarter_turns(old_dir, new_dir)
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
 * Rotates an offset (dx, dy) by 90-degree increments, per _quarter_turns()'s result.
 *
 * Arguments:
 * * dx = X offset relative to the vehicle.
 * * dy = Y offset relative to the vehicle.
 * * k = Rotation amount from _quarter_turns().
 *
 * Returns:
 * * A list of two integers, the rotated {dx, dy}.
 */
/obj/vehicle/multitile/proc/_rotated_offset(dx, dy, k)
	if(!k)
		return list(dx, dy)
	if(k == 2)
		return list(-dx, -dy)  // 180°
	if(k == 1)
		return list(dy, -dx)   // CW 90°
	// k == -1 (CCW 90°)
	return list(-dy, dx)

/**
 * Coordinates moving every rider atop this vehicle whenever it moves or rotates. Combines
 * translation, rotation, and collision detection to keep riders correctly positioned on the hull.
 *
 * Arguments:
 * * old_cx = X position this vehicle occupied before this move.
 * * old_cy = Y position this vehicle occupied before this move.
 * * old_z = Z-level this vehicle was on before this move.
 * * old_dir = Direction this vehicle was facing before this move.
 * * new_cx = X position this vehicle is moving to.
 * * new_cy = Y position this vehicle is moving to.
 * * new_dir = Direction this vehicle is facing now.
 * * fallback_direction = Travel direction to use when from/target aren't a plain adjacent step.
 */
/obj/vehicle/multitile/proc/_update_riders_after_motion(old_cx, old_cy, old_z, old_dir, new_cx, new_cy, new_dir, fallback_direction = 0)
	var/k = _quarter_turns(old_dir, new_dir) // -1,0,1,2
	var/src_z = src.z
	var/list/src_locs = src.locs

	// simpler version for objs. Checked against old_z so a stairs z-transition doesn't drop riders.
	for(var/obj/O in on_top_obj.Copy())
		if(!O || O.z != old_z)
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
		var/turf/target = locate(new_cx + rd[1], new_cy + rd[2], src_z)

		if(target && (target in src_locs) && target != from)
			O.forceMove(target)
			obj_mark_on_top(O)
			if(istype(O, /obj/structure/bed/roller))
				var/obj/structure/bed/roller/R = O
				if(R.buckled_bodybag)
					R.buckled_bodybag.forceMove(target)
					obj_mark_on_top(R.buckled_bodybag)
		else if(from in src_locs)
			obj_mark_on_top(O)
		else
			obj_clear_on_top(O)

	for(var/mob/living/M in on_top_mobs.Copy())
		if(!M || M.z != old_z)
			clear_on_top(M)
			continue

		// If the mob is buckled to something, we'll skip it, because the buckled obj has already moved with it.
		if(M.buckled)
			continue
		var/turf/from = get_turf(M)
		if(!from)
			clear_on_top(M)
			continue

		// Offset from OLD center -> rotate by k -> translate to NEW center
		var/list/rd = _rotated_offset(from.x - old_cx, from.y - old_cy, k)
		var/turf/target = locate(new_cx + rd[1], new_cy + rd[2], src_z)

		// this shouldn't happen, but just to be safe.
		if(!target || !(target in src_locs))
			if(from in src_locs)
				mark_on_top(M)
			else
				clear_on_top(M)
			continue

		// If target is blocked by a non-rider dense atom, keep if possible. Direction-aware for a single
		// step, falls back to a blanket density check otherwise (e.g. a rotation).
		//
		// A stairs transition is a special case, so we use fallback_direction instead of get_dir().
		var/direct = (from.z == target.z && get_dist(from, target) <= 1) ? get_dir(from, target) : fallback_direction
		var/blocked = FALSE
		if(direct)
			if(target.BlockedPassDirs(M, direct) || from.BlockedExitDirs(M, direct))
				blocked = TRUE
			if(!blocked)
				for(var/atom/A in target)
					if(A == src || ismob(A))
						// Mobs never block a rider from moving into their own relative slot, riders can
						// share a tank tile now.
						continue
					if(A.BlockedPassDirs(M, direct))
						blocked = TRUE
						break
			if(!blocked)
				for(var/atom/A in from)
					if(A == src || ismob(A))
						continue
					if(A.BlockedExitDirs(M, direct))
						blocked = TRUE
						break
		else
			blocked = target.density  // Start with turf density check
			if(!blocked)
				for(var/atom/A in target)
					if(A != src && !ismob(A) && A.density)
						blocked = TRUE
						break

		if(blocked)
			if(from in src_locs)
				mark_on_top(M)
			else
				clear_on_top(M)
			continue

		// Move and keep elevation
		if(target != from)
			M.forceMove(target)
		mark_on_top(M)

	addtimer(CALLBACK(src, PROC_REF(_joust_riders_over_desant_cap)), 0)
