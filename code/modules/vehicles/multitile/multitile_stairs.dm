/*
 * Lets a multitile vehicle climb or descend a matching multiz staircase, sized to its own
 * footprint. Dispatched from try_move() (multitile_movement.dm) via get_stairs_edge_direction().
 */

/// How many tiles deep this vehicle's own footprint is along `direction`, the travel axis.
/obj/vehicle/multitile/proc/get_stairs_travel_distance(direction)
	var/bound_width_tiles = bound_width / world.icon_size
	var/bound_height_tiles = bound_height / world.icon_size
	return (direction & (NORTH|SOUTH)) ? bound_height_tiles : bound_width_tiles

/**
 * Checks whether this vehicle's edge facing `diretction` is a full row of matching multiz stairs,
 * sized to its own footprint width.
 *
 * Returns UP, DOWN, or null if there's no full match.
 */
/obj/vehicle/multitile/proc/get_stairs_edge_direction(direction)
	var/bound_width_tiles = bound_width / world.icon_size
	var/bound_height_tiles = bound_height / world.icon_size
	var/expected_edge_width = (direction & (NORTH|SOUTH)) ? bound_width_tiles : bound_height_tiles

	var/list/turf/edge_turfs = list()
	for(var/turf/T in locs)
		var/turf/next = get_step(T, direction)
		if(!(next in locs))
			edge_turfs += T

	if(length(edge_turfs) != expected_edge_width)
		// Geometrically shouldn't happen for an intact footprint, but bail safely if it does.
		return

	var/up_match = TRUE
	var/down_match = TRUE
	for(var/turf/T in edge_turfs)
		var/obj/structure/stairs/multiz/up/up_stairs = locate() in T
		var/obj/structure/stairs/multiz/down/down_stairs = locate() in T
		if(!up_stairs || up_stairs.dir != direction)
			up_match = FALSE
		if(!down_stairs || down_stairs.dir != REVERSE_DIR(direction))
			down_match = FALSE

	if(up_match)
		return UP
	if(down_match)
		return DOWN

/**
 * Moves this vehicle up or down a validated stairs edge, its own footprint depth forward so it
 * clears the support wall. Returns TRUE on success, FALSE on a crash.
 */
/obj/vehicle/multitile/proc/attempt_stairs_transition(direction, travel)
	var/list/old_center_xy = _current_center()
	var/turf/old_center = locate(old_center_xy[1], old_center_xy[2], z)
	var/travel_distance = get_stairs_travel_distance(direction)
	var/turf/same_z_target = old_center
	for(var/i in 1 to travel_distance)
		same_z_target = get_step(same_z_target, direction)
	if(!same_z_target)
		return crash_stairs_transition()

	var/turf/actual_center = (travel == UP) ? SSmapping.get_turf_above(same_z_target) : SSmapping.get_turf_below(same_z_target)
	if(!actual_center)
		return crash_stairs_transition()

	var/bound_x_tiles = bound_x / world.icon_size
	var/bound_y_tiles = bound_y / world.icon_size
	var/bound_width_tiles = bound_width / world.icon_size
	var/bound_height_tiles = bound_height / world.icon_size
	var/turf/dest_min_turf = locate(actual_center.x + bound_x_tiles, actual_center.y + bound_y_tiles, actual_center.z)
	var/list/dest_turfs = CORNER_BLOCK(dest_min_turf, bound_width_tiles, bound_height_tiles)

	if(length(dest_turfs) != bound_width_tiles * bound_height_tiles)
		return crash_stairs_transition()

	// validate
	for(var/turf/T as anything in dest_turfs)
		if(!T || T.density)
			return crash_stairs_transition()
		for(var/atom/A in T)
			if(!A.density)
				continue // harmless clutter, including stairs anti build markers
			if(istype(A, /obj/vehicle))
				return crash_stairs_transition()
			if(isliving(A))
				var/mob/living/blocker = A
				if(blocker.would_block_tank_stairs(src))
					return crash_stairs_transition()
				continue
			if(istype(A, /obj/structure/platform))
				// Platform railings block head on but let the vehicle pass from behind.
				if(A.dir == direction)
					continue
				if(REVERSE_DIR(A.dir) == direction)
					return crash_stairs_transition()
				continue
			if(is_blocking_structure(A))
				return crash_stairs_transition()

	// commit
	for(var/turf/T as anything in dest_turfs)
		for(var/atom/A in T)
			if(QDELETED(A) || !A.density)
				continue
			if(istype(A, /obj/structure/platform))
				continue // never touched, Pass 1 already crashed if this one was facing us
			if(isliving(A))
				var/mob/living/mover = A
				// Push the mob forward, forceMove so platform railings don't block it.
				var/turf/farthest_clear = get_turf(mover)
				for(var/i in 1 to travel_distance)
					var/turf/next_step = get_step(farthest_clear, direction)
					if(!next_step || next_step.density)
						break
					farthest_clear = next_step
				if(farthest_clear != get_turf(mover))
					shake_camera(mover, steps = 10, strength = 1)
					mover.forceMove(farthest_clear)
					playsound(mover, "punch", 25, 1) // same cue as a normal ram shove
			else
				A.handle_vehicle_bump(src)

	var/turf/old_turf = get_turf(src)
	var/list/old_locs = locs.Copy()
	forceMove(actual_center)
	var/turf/current_loc = get_turf(src)

	update_covered_barricades(old_locs)
	for(var/obj/item/hardpoint/H in hardpoints)
		H.on_move(old_turf, current_loc, direction)

	if(movement_sound && world.time > move_next_sound_play)
		playsound(src, movement_sound, vol = 20, sound_range = 30)
		move_next_sound_play = world.time + 10

	last_move_dir = direction

	return TRUE

/// Feedback for a failed stairs climb, mirrors a normal blocked move.
/obj/vehicle/multitile/proc/crash_stairs_transition()
	var/already_resolved = skip_generic_crash_response
	skip_generic_crash_response = FALSE
	if(world.time >= next_crash_effect)
		next_crash_effect = world.time + 5
		if(!already_resolved)
			on_crash()
		interior_crash_effect()
	if(!already_resolved)
		halve_speed()
	return FALSE
