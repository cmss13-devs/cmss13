/*
	Original movement code was done by Atebite, however due to problems vehicle handling problems I had to simplify it a bit.
	It had actual momentum, rolling thanks to momentum and so on. We had to cut out any rolling, cause it made vehicle controls
	pretty inconvenient even without lags. The reason why it wasn't removed entirely is because I want vehicles to keep the ability
	to achieve top speed, to be able to move actually FAST in long-range travel on big maps, but not have sonic speed during engagements.
	- Jeser

	original description:
		Vehicles have momentum, which makes the movement code a bit complex.
		To avoid race conditions between user inputs and timers for rolling movement,
		the movement logic is split into 3 parts:

		- Pre-movement, which determines what movement inputs will be considered
		- Movement, which executes the movement input chosen by the pre-movement proc
		- Post-movement, which determines if the movement cycle should automatically be repeated

		If the vehicle isn't moving (<= 1 momentum, either direction), the user input is buffered and immediately
		chosen and executed. This means that users can move single tiles without having the vehicle begin rolling.

		When the vehicle gains more than 1 momentum, rolling kicks in via a timer that calls the movement procs immediately
		when the movement delay ends. User inputs are still buffered, but the input itself won't cause any movement to occur.
		If no user input was buffered before this next movement, the vehicle is moved according to its momentum. If there IS
		buffered user input, the movement code will use the buffered input. Inputs can only be buffered 1ds ahead of the next move.

		Any questions? Ask Atebite
*/

// Called when someone tries to move the vehicle
/obj/vehicle/multitile/relaymove(mob/user, direction)
	if(user != seats[VEHICLE_DRIVER])
		return

	// Won't even consider moves when the vehicle is broken
	if(health <= 0)
		return FALSE

	last_input_time = world.time

	return pre_movement(direction)

// This determines what type of movement to execute
/obj/vehicle/multitile/proc/pre_movement(direction)
	if(world.time < next_move)
		return FALSE

	if(uses_gear_transmission)
		return gear_pre_movement(direction)

	var/success = FALSE

	if(dir == turn(direction, 180) || dir == direction)
		var/old_dir = dir
		success = try_move(direction)
		// Keep dir when driving backwards
		setDir(old_dir)
	// Rotation/turning
	else
		success = try_rotate(turning_angle(dir, direction))
		if(move_on_turn)
			try_move(direction)

	if(success)
		start_momentum_decay_if_needed()

	return success

/**
 * Attempts to execute the given movement input, then carries any on-hull riders along with it.
 *
 * Arguments:
 * * direction = Direction to move in.
 * * force = Bypasses the normal momentum/gas gate. Used by knockback/ram shoves.
 */
/obj/vehicle/multitile/proc/try_move(direction, force=FALSE)
	var/list/old_center = _current_center()
	var/old_z = z
	var/old_dir = dir

	var/success
	var/stairs_travel = get_stairs_edge_direction(direction)
	if(stairs_travel)
		success = attempt_stairs_transition(direction, stairs_travel)
	else
		if(!can_move(direction))
			return FALSE

		if(!force)
			var/should_move = update_momentum(direction)
			update_next_move()

			if(!should_move)
				return FALSE

		var/turf/old_turf = get_turf(src)
		var/list/old_locs = locs.Copy()
		forceMove(get_step(src, direction))

		var/turf/current_loc = get_turf(src)
		update_covered_barricades(old_locs)
		for(var/obj/item/hardpoint/H in hardpoints)
			H.on_move(old_turf, current_loc, direction)

		if(movement_sound && world.time > move_next_sound_play)
			playsound(src, movement_sound, vol = 20, sound_range = 30)
			move_next_sound_play = world.time + 10

		last_move_dir = direction

		if(force && (health <= 0)) // Broken and forced movement (currently only xenos)
			interior.drop_human_bodies(old_turf)

		success = TRUE

	if(!success)
		return FALSE

	var/list/new_center = _current_center()
	if(new_center[1] != old_center[1] || new_center[2] != old_center[2] || z != old_z || dir != old_dir)
		_update_riders_after_motion(old_center[1], old_center[2], old_z, old_dir, new_center[1], new_center[2], dir, direction)

	return TRUE

// Overridden by tanks to elevate barricades they're crossing above their own/riders' layers.
/obj/vehicle/multitile/proc/update_covered_barricades(list/old_locs)
	return

/**
 * Whether the vehicle is still coasting in the opposite direction from what dir/current_gear now call for.
 * True right after a U-turn or a Reverse/Drive shift while still moving the old way.
 */
/obj/vehicle/multitile/proc/is_momentum_reversed()
	var/new_direction = (current_gear == "R") ? turn(dir, 180) : dir
	return current_speed > 0 && current_move_direction && new_direction == REVERSE_DIR(current_move_direction)

/**
 * Recomputes current_move_direction from dir/current_gear (opposite the hull's facing while in Reverse).
 *
 * Called from every place dir or current_gear can change, not just the physics tick, so a turn or gear
 * shift is picked up immediately instead of waiting on the next tick.
 *
 * While is_momentum_reversed() is TRUE, this leaves current_move_direction untouched so the vehicle keeps
 * coasting the old way until that residual speed decays or gets braked down to 0.
 */
/obj/vehicle/multitile/proc/update_move_direction()
	if(is_momentum_reversed())
		return
	current_move_direction = (current_gear == "R") ? turn(dir, 180) : dir

/**
 * Rotates the vehicle by deg degrees if possible.
 *
 * Complex acceleration's drift mechanic lives here. A 180-degree turn keeps dir on the same axis, so
 * current_speed just carries over under the turn-scrub penalty instead of becoming drift. Only a 90-degree
 * turn moves onto the other axis:
 * - The old facing axis's speed becomes drift, unless it's below DRIFT_MIN_SPEED_FRACTION of top_speed, in
 *   which case it's too slow to skid and no drift is created.
 * - Whatever was already drifting on the new axis is reclaimed as the new current_speed. If nothing was
 *   drifting there, current_speed starts fresh at 0 when the old speed became drift, or gets the same
 *   turn-scrub penalty as a same-axis turn when it was too slow to drift in the first place.
 *
 * Known simplification: if the driver shifted into/out of Reverse mid-drift, the gear-derived direction
 * wins over the reclaimed one. Accepted as a rare edge case.
 */
/obj/vehicle/multitile/proc/try_rotate(deg)
	var/list/old_center = _current_center()
	var/old_z = z

	if(!can_rotate(deg))
		return FALSE

	var/old_dir = dir
	var/pre_turn_speed = current_speed
	var/pre_turn_move_direction = current_move_direction
	// Cruise control holds a fixed target speed, so a sideways drift would fight that speed-holding logic
	// instead of coasting freely. Drifting is only ever available with cruise control off.
	var/drift_eligible = uses_gear_transmission && !(get_driver_vehicle_prefs() & VEHICLE_SIMPLE_ACCELERATION) && !cruise_control_enabled

	if(!uses_gear_transmission)
		move_momentum = move_momentum * move_turn_momentum_loss_factor
		if(abs(move_momentum) < 0.5)
			if(move_momentum < 0)
				move_momentum = -0.5
			else
				move_momentum = 0.5
		update_next_move()
	else
		next_move = world.time + gear_turn_delay

	rotate_hardpoints(deg)
	rotate_entrances(deg)
	rotate_bounds(deg)
	update_langchat_height()
	setDir(turn(dir, deg), TRUE)

	if(uses_gear_transmission)
		var/axis_changed = ((old_dir & (EAST|WEST)) != 0) != ((dir & (EAST|WEST)) != 0)
		if(drift_eligible && axis_changed)
			var/old_drift_speed = drift_speed
			var/old_drift_direction = drift_direction
			var/fast_enough_to_drift = pre_turn_speed >= top_speed * DRIFT_MIN_SPEED_FRACTION

			if(fast_enough_to_drift)
				drift_speed = pre_turn_speed
				drift_direction = pre_turn_move_direction
				drift_braking = FALSE // fresh drift coasts under plain drag until the driver presses gas/brake again
				ensure_drift_movement_loop()
			else
				drift_speed = 0
				drift_direction = 0

			if(old_drift_speed > 0)
				current_speed = old_drift_speed
				current_move_direction = old_drift_direction
			else if(fast_enough_to_drift)
				current_speed = 0
			else
				// Too slow to skid, but that shouldn't mean a hard stop either - scrub it the same as a
				// same-axis (180-degree) turn instead of zeroing outright, matching the else branch below.
				current_speed = pre_turn_speed * move_turn_momentum_loss_factor
			move_momentum = current_speed
		else
			// 180-degree turn, or Simple acceleration (no drift at all): unchanged existing behavior.
			current_speed *= move_turn_momentum_loss_factor
			move_momentum = current_speed
			// speed_notch needs the same turn-scrub penalty or it silently snaps current_speed back up.
			speed_notch = round(speed_notch * move_turn_momentum_loss_factor)
			// Reset so this scrub doesn't leave a stale timestamp blocking the next notch climb.
			next_notch_climb_time = 0

		// Refreshes current_move_direction immediately instead of waiting for the next physics tick,
		// which would otherwise let the vehicle take one more step on the old facing after turning.
		update_move_direction()

	last_move_dir = dir

	if(movement_sound && world.time > move_next_sound_play)
		playsound(src, movement_sound, vol = 20, sound_range = 30)
		move_next_sound_play = world.time + 10

	update_icon()

	var/list/new_center = _current_center()
	if(new_center[1] != old_center[1] || new_center[2] != old_center[2] || z != old_z || dir != old_dir)
		_update_riders_after_motion(old_center[1], old_center[2], old_z, old_dir, new_center[1], new_center[2], dir)

	return TRUE

/obj/vehicle/multitile/setDir(newdir, real_rotate = FALSE)
	if(!real_rotate)
		return
	. = ..()

// Increases/decreases the vehicle's momentum according to whether or not the user is steppin' on the gas or not
/obj/vehicle/multitile/proc/update_momentum(direction)
	if(direction == dir)
		move_momentum = min(move_momentum + 1, move_max_momentum)
	else
		move_momentum = max(move_momentum - 1, -move_max_momentum)

	// Attempt to move in the opposite direction to our momentum
	if(direction == dir && move_momentum < 0 || direction != dir && move_momentum > 0)
		// Brakes or something
		move_momentum = 0
		return FALSE

	return TRUE

/obj/vehicle/multitile/proc/update_next_move()
	// 1/((m/M)*b) where m is momentum, M is max momentum and b is the build factor
	//// move_momentum_build_factor seems to cancel itself out here. It's worth to revisit this section and maybe refactor it.
	var/anti_build_factor = 1/((max(abs(move_momentum), 1)/move_max_momentum) * move_momentum_build_factor)

	next_move = world.time + move_delay * move_momentum_build_factor * anti_build_factor * misc_multipliers["move"]
	l_move_time = world.time

// This just checks if the vehicle can physically move in the given direction
/obj/vehicle/multitile/proc/can_move(direction)
	var/can_move = TRUE

	var/bound_x_tiles = bound_x / world.icon_size
	var/bound_y_tiles = bound_y / world.icon_size
	var/turf/min_turf = locate(x + bound_x_tiles, y + bound_y_tiles, z)

	var/bound_width_tiles = bound_width / world.icon_size
	var/bound_height_tiles = bound_height / world.icon_size
	var/list/old_turfs = CORNER_BLOCK(min_turf, bound_width_tiles, bound_height_tiles)

	for(var/turf/T as anything in old_turfs)
		for(var/atom/A in T)
			if(!QDELETED(A) && A.last_bumped != world.time && is_directional_obstacle(A) && (A.dir & direction))
				Collide(A)

	var/turf/new_loc = get_step(src, direction)
	min_turf = locate(new_loc.x + bound_x_tiles, new_loc.y + bound_y_tiles, z)

	var/list/new_turfs = CORNER_BLOCK(min_turf, bound_width_tiles, bound_height_tiles)
	for(var/turf/T as anything in new_turfs)
		// only check the turfs we're moving to
		if(T in old_turfs)
			continue

		if(can_enter_open_space && istype(T, /turf/open_space))
			// early return so we skip crash behavior.
			halve_speed()
			return FALSE

		if(!T.Enter(src))
			can_move = FALSE

		for(var/atom/A in T)
			if(QDELETED(A) || A.last_bumped == world.time || !is_directional_obstacle(A))
				continue
			if(REVERSE_DIR(A.dir) & direction)
				// Head-on: its own facing points straight back at us. Ram it.
				Collide(A)
			else if(!(A.dir & direction))
				// Perpendicular to our travel direction. Only crush it if its facing edge points into
				// another tile of our own footprint, meaning it bisects our body and gets hit either way.
				var/turf/inward_turf = get_step(T, A.dir)
				if(inward_turf && (inward_turf in new_turfs))
					Collide(A)

		// Non-dense structures the tank should still crush even though T.Enter() never sees them.
		// The last_bumped check avoids double-handling anything already bumped via T.Enter() this tick.
		for(var/atom/A in T)
			if(QDELETED(A) || A.last_bumped == world.time)
				continue
			if(istype(A, /obj/structure/machinery/constructable_frame) || istype(A, /obj/structure/bed/chair) || istype(A, /obj/structure/bed/stool))
				Collide(A)

		// A framed window's deconstruct() spawns a new window_frame into T's contents mid-iteration, so
		// T.Enter() isn't guaranteed to have bumped it. Rescan explicitly to catch it.
		for(var/obj/structure/window_frame/WF in T)
			if(!QDELETED(WF) && WF.last_bumped != world.time)
				Collide(WF)

		// any other tile-blocking items that weren't caught by !T.Enter
		for(var/atom/A in T)
			if(is_blocking_structure(A))
				can_move = FALSE
				break

	// Crashed with something that stopped us
	if(!can_move)
		// A bump-opening door isn't a real obstacle. It blocks this attempt while it animates open, then
		// lets the vehicle through next retry, so skip every crash side effect entirely.
		if(skip_crash_response_entirely)
			skip_crash_response_entirely = FALSE
			return can_move

		// If the driver's seat is empty, nobody can turn cruise control off, and repeated crashes can
		// stun-lock anyone trying to get back in. Turn it off automatically to break that lock.
		if(cruise_control_enabled && !get_seat_mob(VEHICLE_DRIVER))
			cruise_control_enabled = FALSE
		// A vehicle-vs-vehicle collision already resolved momentum loss and rider jousting itself, so
		// skip re-running on_crash()/halve_speed(), but still let the camera-shake/fling juice play.
		var/already_resolved = skip_generic_crash_response
		skip_generic_crash_response = FALSE

		// Cooldown the crash juice so repeated blocked-move retries don't spam camera-shake/rider-fling
		// faster than the animation can finish. Must run before halve_speed() mutates move_momentum.
		if(world.time >= next_crash_effect)
			next_crash_effect = world.time + 5
			if(!already_resolved)
				on_crash()
			interior_crash_effect()
		if(!already_resolved)
			halve_speed()

	return can_move

/**
 * Halves whichever speed model this vehicle uses, on crash/blocked-move.
 *
 * Also halves speed_notch so it doesn't silently snap current_speed back up on the next accelerate press,
 * and resets next_notch_climb_time so a stale timestamp doesn't block the next notch climb.
 */
/obj/vehicle/multitile/proc/halve_speed()
	if(uses_gear_transmission)
		current_speed = current_speed / 2
		move_momentum = current_speed
		speed_notch = floor(speed_notch / 2)
		next_notch_climb_time = 0
		return
	move_momentum = floor(move_momentum/2)
	update_next_move()

/**
 * How hard this vehicle is currently hitting things, relative to its own top speed. Scales collision
 * damage instead of using a flat constant regardless of speed.
 *
 * Non-gear vehicles return 1 unconditionally. Only gear-transmission vehicles scale by current_speed.
 *
 * Arguments:
 * * floor_scale = Minimum multiplier returned, so even a near-standstill bump still does a little damage.
 *
 * Returns:
 * * A multiplier from floor_scale to 1, proportional to current_speed / move_max_momentum.
 */
/obj/vehicle/multitile/proc/get_collision_speed_scale(floor_scale = COLLISION_SPEED_SCALE_FLOOR)
	if(!uses_gear_transmission || !move_max_momentum)
		return 1
	return clamp(current_speed / move_max_momentum, floor_scale, 1)

/**
 * Applies a proportional speed penalty after crashing through a fragile obstacle (fence, grille, foamed
 * metal, etc.). Reduces speed by a fraction of its current value.
 *
 * Gear-transmission vehicles track real speed as current_speed, so the penalty applies there instead of
 * to move_momentum (which just mirrors it and would get overwritten next tick). speed_notch gets the
 * same proportional reduction so it doesn't snap current_speed back up on the next accelerate press.
 *
 * Arguments:
 * * fraction = Fraction of current speed to remove (0.5 = halve it).
 * * reschedule = Whether to also push back next_move via update_next_move(). Only meaningful for
 *   non-gear vehicles, since gear vehicles schedule their own ticks independently.
 */
/obj/vehicle/multitile/proc/apply_collision_speed_penalty(fraction, reschedule = FALSE)
	if(uses_gear_transmission)
		current_speed -= current_speed * fraction
		move_momentum = current_speed
		speed_notch = round(speed_notch * (1 - fraction))
		// Reset so a stale timestamp from before the crash doesn't block the next notch climb.
		next_notch_climb_time = 0
		return
	move_momentum -= move_momentum * fraction
	if(reschedule)
		update_next_move()

/**
 * Shoves this vehicle a number of tiles for ram and charge abilities. Steps one tile at a time so it
 * reads as a knockback, not a teleport. Locks out driver input for the duration.
 *
 * Uses try_move(direction, force=TRUE), so a target wedged against a wall or another vehicle just stops
 * early the moment a step is blocked.
 *
 * Arguments:
 * * direction = Direction to shove the vehicle in.
 * * tiles = How many tiles to attempt to move.
 * * scatter_momentum = Momentum value passed to _scatter_riders_on_crash() to scatter riders.
 * * jostle_riders = Whether to also scatter/stun riders once the shove ends.
 * * is_crusher_source = Whether this shove came from a Crusher ability.
 */
/obj/vehicle/multitile/proc/knockback(direction, tiles, scatter_momentum = 2, jostle_riders = TRUE, is_crusher_source = FALSE)
	movement_locked = TRUE
	knockback_crusher_source = is_crusher_source
	for(var/i in 1 to tiles)
		if(QDELETED(src))
			break
		if(!try_move(direction, force = TRUE)) // rider tracking lives in try_move() itself
			break
		if(i < tiles)
			sleep(KNOCKBACK_STEP_DELAY)
	if(QDELETED(src))
		return
	movement_locked = FALSE
	knockback_crusher_source = FALSE
	if(jostle_riders)
		_scatter_riders_on_crash(scatter_momentum)

/// Damage/knockback scale for resolve_crusher_charge_hit(), keyed off this vehicle's weight class. Tank-tuned baseline values pass through unscaled.
/obj/vehicle/multitile/proc/get_crusher_ram_scale()
	if(vehicle_flags & (VEHICLE_CLASS_MEDIUM|VEHICLE_CLASS_HEAVY))
		return 1
	if(vehicle_flags & VEHICLE_CLASS_LIGHT)
		return 0.85
	return 0.65 // VEHICLE_CLASS_WEAK

/**
 * Handles a Crusher Charge or Charger ram hitting this vehicle: crash sound, damage, knockback.
 * Damage and knockback distance both scale with get_crusher_ram_scale(), so a lighter vehicle takes
 * less structural damage but gets shoved further.
 *
 * Debounced via last_crusher_charge_hit, a diagonal Charge can register more than one hit at once.
 *
 * Arguments:
 * * attacker = The charging/ramming Crusher.
 * * direction = Direction to knock this vehicle back in, at the tank-tuned baseline distance.
 * * tiles = How many tiles to attempt to knock this vehicle back, at the tank-tuned baseline distance.
 * * damage = Damage to deal, at the tank-tuned baseline value.
 */
/obj/vehicle/multitile/proc/resolve_crusher_charge_hit(mob/living/carbon/xenomorph/attacker, direction, tiles, damage)
	if(world.time < last_crusher_charge_hit + 10)
		return
	last_crusher_charge_hit = world.time

	var/ram_scale = get_crusher_ram_scale()
	playsound(src, 'sound/effects/metal_crash.ogg', 35)
	play_wound_gain_effects(src, WOUND_DAMTYPE_BRUTE, attacker)
	take_damage_type(damage * ram_scale, "blunt", attacker)

	// Deferred a tick so we don't pull the vehicle out from under a still-in-flight throw.
	addtimer(CALLBACK(src, PROC_REF(knockback), direction, round(tiles / ram_scale), 2, TRUE, TRUE), 0)

/obj/vehicle/multitile/proc/can_rotate(deg)
	if(bound_width == bound_height)
		return TRUE
	//VHCLTODO: Add non-square checks here
	return FALSE

/obj/vehicle/multitile/proc/rotate_entrances(deg)
	entrances = rotate_origins(deg, entrances)

/obj/vehicle/multitile/proc/rotate_hardpoints(deg, update_icons = TRUE, list/specific_hardpoints = null)
	if(specific_hardpoints)
		for(var/obj/item/hardpoint/H in specific_hardpoints)
			H.rotate(deg)
		return

	for(var/obj/item/hardpoint/H in hardpoints)
		H.rotate(deg)

	if(update_icons)
		update_icon()

// Rotates a list of relative coordinates around the center of the vehicle
/obj/vehicle/multitile/proc/rotate_origins(deg, list/origins, list/specific_indexes)
	//apply entry coord rotations
	for(var/origin in origins)
		//Don't rotate restricted origin points, unless we're doing a restricted only rotation
		if(specific_indexes)
			var/restricted = TRUE
			for(var/specific_index in specific_indexes)
				if(specific_index == origin)
					restricted = FALSE
					break
			if(restricted)
				continue

		var/origin_coord = origins[origin]
		/*
		   The root of the vehicle isn't always in the true center of the vehicle,
		   so simply rotating around the root doesn't work.
		   Instead, we do a bit of a detour that ultimately makes our life much simpler.

		   The idea is to find the true center of the vehicle, given in coordinates with the lower left
		   corner of the vehicle as the origin. Then we find the coordinates of the origin in the same
		   coordinate system and rotate the origin around the true center.
		*/

		// Note that these coordinates aren't world coordinates.
		// They're coordinates in the coordinate system with the minimum (lower left) corner of the vehicle as its origin

		// Find the root of the vehicle relative to the lower left corner of the vehicle
		var/list/root_coords = list(-bound_x / world.icon_size, -bound_y / world.icon_size)
		// Find the true center of the vehicle relative to the lower left corner of the vehicle
		var/list/center_coords = list(bound_width / (2*world.icon_size), bound_height / (2*world.icon_size))
		// Find the coordinates of the origin relative to the lower left corner of the vehicle
		var/list/origin_coords_abs = list(origin_coord[1] + root_coords[1], origin_coord[2] + root_coords[2])

		// Apply an offset of 0.5 so the origin coordinates are given as the center of the origin tile
		// instead of the lower left vertex of the origin tile. This makes the rotation play nice.
		origin_coords_abs[1] = origin_coords_abs[1] + 0.5
		origin_coords_abs[2] = origin_coords_abs[2] + 0.5

		// Rotate the origin around the center
		var/list/new_origin = RotateAroundAxis(origin_coords_abs, center_coords, deg)

		// And make the origin relative to the root again
		new_origin[1] = round(new_origin[1] - root_coords[1] - 0.5, 1)
		new_origin[2] = round(new_origin[2] - root_coords[2] - 0.5, 1)

		origins[origin] = new_origin
	return origins

/obj/vehicle/multitile/proc/rotate_bounds(deg)
	//If the vehicle isn't a perfect square, rotate the bounds around
	if(bound_width != bound_height && (dir != turn(dir, (deg + 180)) && dir != turn(dir, deg)))
		var/bound_swapped = bound_width
		var/pixel_swapped = bound_x
		bound_width = bound_height
		bound_height = bound_swapped
		bound_x = bound_y
		bound_y = pixel_swapped

/obj/vehicle/multitile/proc/interior_crash_effect()
	if(!interior)
		return

	// Not enough momentum for anything serious
	if(abs(move_momentum) <= 1)
		return

	var/fling_distance = ceil(move_momentum/move_max_momentum) * 2
	var/turf/target = interior.get_middle_turf()

	for (var/x in 0 to fling_distance-1)
		// NOTE: We fling east/west because all interiors are front-facing east
		target = get_step(target, move_momentum > 0 ? EAST : WEST)
		if (!target)
			break

	var/list/bounds = interior.get_bound_turfs()
	for(var/turf/T as anything in block(bounds[1], bounds[2]))
		for(var/atom/movable/A in T)
			if(A.anchored)
				continue

			if(isliving(A))
				var/mob/living/M = A
				if(M.buckled)
					continue

				shake_camera(M, 2, ceil(move_momentum/move_max_momentum) * 1)
				M.apply_effect(1, STUN)
				M.apply_effect(2, WEAKEN)

			// YOU'RE LIKE A CAR CRASH IN SLOW MOTION!
			// IT'S LIKE I'M WATCHIN' YA FLY THROUGH A WINDSHIELD!
			INVOKE_ASYNC(A, TYPE_PROC_REF(/atom/movable, throw_atom), target, fling_distance, SPEED_VERY_FAST, src, TRUE)

/obj/vehicle/multitile/proc/at_munition_interior_explosion_effect(explosion_strength = 75, explosion_falloff = 50, shrapnel = TRUE, shrapnel_count = 48, datum/cause_data/cause_data)
	if(!interior)
		return

	var/turf/centre = interior.get_middle_turf()

	var/turf/target = get_random_turf_in_range(centre, 2, 0)

	if(shrapnel)
		create_shrapnel(target, shrapnel_count, , ,/datum/ammo/bullet/shrapnel, cause_data)
		cell_explosion(target, explosion_strength, explosion_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data)
		return
	else
		cell_explosion(target, explosion_strength, explosion_falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, cause_data)

/**
 * Base proc for defining special behavior when crashing
 *
 * on_crash is a proc meant to be overridable by child classes
 * That way, all of the effects that happen when crashing are in the same spot.
 */
/obj/vehicle/multitile/proc/on_crash()
	return


/**
 * Starts the momentum decay loop if not already running and momentum exists.
 * This should be called after any movement to ensure decay starts when player stops.
 */
/obj/vehicle/multitile/proc/start_momentum_decay_if_needed()
	if(uses_gear_transmission)
		if((engine_on || current_speed > 0 || throttle_held_until > world.time || cruise_control_enabled) && !momentum_decay_active)
			momentum_decay_active = TRUE
			spawn(0)
				gear_cruise_loop()
		return
	if(abs(move_momentum) > 0 && !momentum_decay_active)
		momentum_decay_active = TRUE
		spawn(0)
			momentum_decay_loop()

/**
 * The main momentum decay loop - runs continuously while vehicle has momentum.
 * Checks every second if the player has stopped giving input, and decays momentum accordingly.
 *
 * 	decay_interval controls how fast mometum will decay. By default, it decays every second.
 *
 * idle_time_required is how long you have to go without pressing a movement key.
 *
 * So, for example, if idle time is 20 and decay interval is 5, you will start losing momentum twice per second after you spend 2 seconds without moving.
 *
 */
/obj/vehicle/multitile/proc/momentum_decay_loop()
	var/decay_interval = 10      // Decay every 1 second

	while(abs(move_momentum) > 0)
		sleep(decay_interval)

		var/time_since_input = world.time - last_input_time
		if(time_since_input < idle_time_required)
			continue

		var/momentum_abs = abs(move_momentum)
		momentum_abs -= move_momentum_loss_factor
		if(momentum_abs <= 0)
			move_momentum = 0
			momentum_decay_active = FALSE
			return

		if(move_momentum > 0)
			move_momentum = momentum_abs

		else
			move_momentum = -momentum_abs

	momentum_decay_active = FALSE

/**
 * The gear-transmission's whole physics tick. Drag decay, acceleration, braking, fuel burn, heat, and
 * tile movement all happen here on a fixed GEAR_TICK_INTERVAL cadence instead of off key-repeat timing.
 *
 * Drag decay only applies once current_speed has already reached whatever it's chasing. While still
 * climbing toward that target, the whole acceleration budget goes to net speed gain instead of partly
 * fighting decay, so Complex mode doesn't burn extra fuel/heat during the climb that Simple mode's decay-
 * free notch climb never pays either.
 *
 * Gas/cruise control torque-building is gated on the engine's spinup window, but drag-decay and movement
 * stay ungated by it, so existing current_speed keeps coasting through that window same as engine-off.
 *
 * Runs continuously while the engine is on, or as long as there's residual speed/input/cruise control
 * left to resolve after the engine turns off.
 *
 * Actual tile movement does not happen on this fixed tick. It's handed off to a separately-paced loop
 * (gear_movement_loop()) that reschedules itself off the real time-per-tile implied by current_speed,
 * since a fixed 5Hz tick doesn't divide evenly into whole tiles and would make movement choppy.
 *
 * Exception: under VEHICLE_SIMPLE_ACCELERATION, none of the chase-and-move logic runs here. See
 * handle_simple_accel_idle_tick() and attempt_simple_accel_move() instead.
 */
/obj/vehicle/multitile/proc/gear_cruise_loop()
	var/tick_dt = GEAR_TICK_INTERVAL / 10

	// Keeps running with the engine off and the vehicle stopped until drift, engine temperature, and
	// mounted/underneath fire have all settled, so a parked vehicle still cools down and decays properly.
	while(engine_on || current_speed > 0 || throttle_held_until > world.time || cruise_control_enabled || drift_speed > 0 || !is_engine_temperature_settled() || get_mounted_flame_tile_count() > 0 || get_underneath_flame_tile_count() > 0)
		sleep(GEAR_TICK_INTERVAL)

		if(drift_speed > 0)
			apply_drift_decay(tick_dt)
			ensure_drift_movement_loop()
		update_drift_sound()

		// Recomputed every tick, not just on gear/dir change, so switching gears while cruise control is
		// engaged doesn't leave the vehicle driving in a stale direction.
		update_move_direction()

		// Purely cosmetic. Placed before the Simple Acceleration early-continue so revving reads the
		// same under either acceleration preference.
		var/revving = engine_on && world.time < throttle_held_until && (current_gear == "P" || current_gear == "N")
		engine_rev_level = clamp(engine_rev_level + (revving ? ENGINE_REV_RISE_RATE : -ENGINE_REV_DECAY_RATE) * tick_dt, 0, 1)

		// Movement is entirely input-driven under Simple Acceleration. This tick only handles idle
		// fuel/heat and passive notch decay for it. See handle_simple_accel_idle_tick().
		if(get_driver_vehicle_prefs() & VEHICLE_SIMPLE_ACCELERATION)
			handle_simple_accel_idle_tick(tick_dt)
			continue

		var/list/stats = get_current_gear_stats()
		var/old_speed = current_speed
		var/consumed_fraction = 0

		var/spinup_done = world.time >= engine_spinup_until

		if(!engine_on)
			// Mechanical brakes don't need the engine running, only building new speed does.
			if(world.time < brake_held_until)
				current_speed = max(current_speed - VEHICLE_BRAKE_DECELERATION * tick_dt, 0)
			else
				apply_speed_decay(tick_dt)
			consume_fuel(tick_dt, 0, 0)
		else if(cruise_control_enabled)
			if(is_momentum_reversed())
				// A held-back direction reversal has to be fought down first, not chased toward a
				// cruise target as if current_speed were already valid motion the new way.
				current_speed = max(current_speed - VEHICLE_BRAKE_DECELERATION * tick_dt, 0)
				consume_fuel(tick_dt, 0, 0)
			else if(spinup_done && stats["torque"] > 0 && has_fuel())
				var/traction_scale = get_effective_traction()
				var/part_scale = get_part_condition_scale()
				var/computed_torque = get_gear_computed_torque(stats, traction_scale, part_scale)
				var/gear_max_speed = get_gear_max_speed(stats, traction_scale, part_scale)
				var/effective_target = min(cruise_control_target_speed, gear_max_speed)

				if(current_speed > effective_target)
					// Target was lowered while cruising: active torque-based deceleration, not drag.
					current_speed = max(current_speed - computed_torque * tick_dt, effective_target)
				else
					// At or below target. Decay only bites once genuinely at it, a tick still climbing
					// below it puts its whole budget into net gain instead.
					if(current_speed >= effective_target)
						apply_speed_decay(tick_dt)
					var/budget = computed_torque * tick_dt
					var/actual_delta = min(max(effective_target - current_speed, 0), budget)
					current_speed += actual_delta
					consumed_fraction = budget > 0 ? (actual_delta / budget) : 0
			else
				apply_speed_decay(tick_dt)
			consume_fuel(tick_dt, abs(current_speed - old_speed), consumed_fraction)
		else
			// Requires an actual seated driver, not just a live throttle_held_until timestamp, or a
			// leftover timestamp from a driver who just got up mid-input would keep autonomously
			// building and spending real current_speed with nobody in the seat.
			var/gas_held = world.time < throttle_held_until && get_seat_mob(VEHICLE_DRIVER)
			var/brake_held = world.time < brake_held_until
			// A direction reversal that update_move_direction() just held back can't just take fresh
			// torque. Holding gas in that state has to fight the stale speed down instead, like a
			// brake press would, or the vehicle would just get faster the wrong way forever.
			var/fighting_reversal = gas_held && is_momentum_reversed()

			if(brake_held || fighting_reversal)
				current_speed = max(current_speed - VEHICLE_BRAKE_DECELERATION * tick_dt, 0)
				consume_fuel(tick_dt, 0, 0)
			else if(gas_held && has_fuel() && spinup_done)
				if(stats["torque"] > 0)
					var/traction_scale = get_effective_traction()
					var/part_scale = get_part_condition_scale()
					var/computed_torque = get_gear_computed_torque(stats, traction_scale, part_scale)
					var/target_speed = get_gear_max_speed(stats, traction_scale, part_scale)

					// Decay only bites once at/above the ceiling. A tick still climbing toward it puts
					// its whole budget into net gain instead, matching Simple mode's decay-free climb.
					if(current_speed >= target_speed)
						apply_speed_decay(tick_dt)

					var/budget = computed_torque * tick_dt
					var/actual_delta = min(max(target_speed - current_speed, 0), budget)
					current_speed += actual_delta
					consumed_fraction = budget > 0 ? (actual_delta / budget) : 0
				else
					// Park/Neutral revving. No torque to apply, but fully "on" for this tick since
					// there's no drivetrain resistance to work against.
					consumed_fraction = 1

				consume_fuel(tick_dt, abs(current_speed - old_speed), consumed_fraction)
			else
				apply_speed_decay(tick_dt)
				consume_fuel(tick_dt, 0, 0)

		update_engine_temperature(tick_dt, consumed_fraction)

		move_momentum = current_speed
		apply_mounted_acid_damage(tick_dt)

		if(current_speed > VEHICLE_MIN_CRAWL_SPEED)
			ensure_gear_movement_loop()

	current_speed = 0
	move_momentum = 0
	speed_notch = 0
	next_notch_climb_time = 0 // reset to avoid a stale timestamp blocking the next notch climb
	momentum_decay_active = FALSE

/// Starts gear_movement_loop() if it isn't already running. Cheap enough to call unconditionally.
/obj/vehicle/multitile/proc/ensure_gear_movement_loop()
	if(movement_loop_active)
		return
	movement_loop_active = TRUE
	spawn(0)
		gear_movement_loop()

/**
 * Advances the vehicle one tile at a time under Complex acceleration, paced independently from
 * gear_cruise_loop()'s fixed 5Hz physics tick.
 *
 * Accumulates fractional tile-progress every GEAR_MOVEMENT_POLL_INTERVAL, re-reading current_speed fresh
 * on every poll rather than computing one sleep duration from a single snapshot, which could otherwise
 * leave the vehicle stuck sleeping on a stale near-zero speed while current_speed had already climbed.
 *
 * Exits once current_speed decays/brakes to a stop, or the driver switches to Simple Acceleration
 * mid-drive, which hands current_speed off to that preference's own reconciliation instead.
 */
/obj/vehicle/multitile/proc/gear_movement_loop()
	var/progress = 0
	while(current_speed > VEHICLE_MIN_CRAWL_SPEED && !(get_driver_vehicle_prefs() & VEHICLE_SIMPLE_ACCELERATION))
		sleep(GEAR_MOVEMENT_POLL_INTERVAL)
		progress += current_speed * (GEAR_MOVEMENT_POLL_INTERVAL / 10)
		if(progress < 1)
			continue
		progress -= 1
		if(!try_move(current_move_direction, force = TRUE))
			halve_speed()
			progress = 0
	movement_loop_active = FALSE

/// Starts drift_movement_loop() if it isn't already running.
/obj/vehicle/multitile/proc/ensure_drift_movement_loop()
	if(drift_loop_active)
		return
	drift_loop_active = TRUE
	spawn(0)
		drift_movement_loop()

/**
 * Advances the vehicle one tile at a time along drift_direction, independent of gear_movement_loop()'s
 * facing-axis stepping. The two run concurrently, so the vehicle's path naturally interleaves cardinal
 * steps from both axes, a "staircase" approximation of diagonal movement.
 *
 * Unlike gear_movement_loop(), a blocked drift step doesn't halve_speed(). Drift is unpowered momentum,
 * so hitting something just ends the slide instead of bouncing back at reduced speed.
 *
 * The skid sound isn't tied to individual steps here. See update_drift_sound() instead, which plays as
 * one continuous scrape for the duration of the skid.
 */
/obj/vehicle/multitile/proc/drift_movement_loop()
	var/progress = 0
	while(drift_speed > VEHICLE_MIN_CRAWL_SPEED)
		sleep(GEAR_MOVEMENT_POLL_INTERVAL)
		progress += drift_speed * (GEAR_MOVEMENT_POLL_INTERVAL / 10)
		if(progress < 1)
			continue
		progress -= 1
		if(!try_move(drift_direction, force = TRUE))
			drift_speed = 0
			break
	drift_speed = 0
	drift_direction = 0
	drift_loop_active = FALSE

/**
 * Per-tick idle bookkeeping for VEHICLE_SIMPLE_ACCELERATION, called from gear_cruise_loop() instead of
 * that loop's usual drag-decay-and-chase logic. Movement is entirely input-driven under this preference,
 * so nothing here moves the vehicle, only current_speed/speed_notch change from a press or decay.
 *
 * Also the sole place fuel/heat get charged for this preference, mirroring Complex mode's fuel-cost
 * regimes as closely as this input-driven model allows:
 * - A press landed this tick and changed current_speed: same "reaching a speed" formula Complex mode uses.
 * - Still short of the max notch with gas held recently, but the climb gate hasn't allowed the next notch
 *   yet: full load, matching Complex mode spending its entire budget on net gain while below target.
 * - Already at the cap (or a redundant press), still within the re-engagement window: this is the
 *   "holding" cost, computed from what decay would be rather than applying it directly.
 * - Park/Neutral with gas pressed recently: mirrors Complex mode's own P/N revving, unconditionally
 *   "fully on" since there's no drivetrain resistance to meter against.
 * - Genuinely idle: zero extra cost, same as Complex mode's idle/brake branches.
 *
 * The idle grace is measured from next_move rather than throttle_held_until, since gear_accelerate()
 * refreshes next_move to a small fixed interval on every press, so it reads as "time since last press."
 *
 * Arguments:
 * * tick_dt = Seconds elapsed this physics tick.
 */
/obj/vehicle/multitile/proc/handle_simple_accel_idle_tick(tick_dt)
	var/old_speed = current_speed
	var/pressed_this_tick = simple_accel_pressed
	simple_accel_pressed = FALSE

	if(current_speed > 0 && speed_notch == 0)
		// Orphaned current_speed, inherited from a driver switching to Simple acceleration mid-drive.
		// This preference's decay logic is gated on speed_notch, so reverse-derive the closest matching
		// notch here to let the existing decay/holding machinery take over normally.
		var/list/orphan_stats = get_current_gear_stats()
		var/orphan_gear_max_speed = get_gear_max_speed(orphan_stats, get_effective_traction(), get_part_condition_scale())
		if(orphan_gear_max_speed > 0)
			speed_notch = clamp(round(current_speed / orphan_gear_max_speed * SIMPLE_ACCEL_STEP_COUNT), 1, SIMPLE_ACCEL_STEP_COUNT)

	var/decay_eligible = world.time > next_move + SIMPLE_ACCEL_IDLE_GRACE

	if(speed_notch > 0 && world.time >= next_notch_decay && decay_eligible)
		speed_notch -= 1
		next_notch_decay = world.time + SIMPLE_ACCEL_DECAY_INTERVAL

		var/list/decay_stats = get_current_gear_stats()
		var/decay_traction_scale = get_effective_traction()
		var/decay_part_scale = get_part_condition_scale()
		current_speed = get_gear_max_speed(decay_stats, decay_traction_scale, decay_part_scale) * (speed_notch / SIMPLE_ACCEL_STEP_COUNT)
		move_momentum = current_speed

	var/list/stats = get_current_gear_stats()
	var/traction_scale = get_effective_traction()
	var/part_scale = get_part_condition_scale()
	var/computed_torque = get_gear_computed_torque(stats, traction_scale, part_scale)
	var/budget = computed_torque * tick_dt

	var/speed_delta = 0
	var/consumed_fraction = 0

	if(pressed_this_tick && current_speed != old_speed)
		// A press this tick changed current_speed. Same "reaching a speed" formula Complex mode uses.
		speed_delta = abs(current_speed - old_speed)
		consumed_fraction = budget > 0 ? min(speed_delta / budget, 1) : 0
	else if(speed_notch < SIMPLE_ACCEL_STEP_COUNT && stats["torque"] > 0 && !decay_eligible)
		// Still short of the max notch with gas held recently, but the climb gate hasn't allowed the
		// next notch yet. Charges full load, matching Complex mode's climb behavior.
		speed_delta = budget
		consumed_fraction = 1
	else if(stats["torque"] > 0 && current_speed > 0 && !decay_eligible)
		// At the max notch (or a redundant press), still within the re-engagement window. This is
		// Complex mode's "holding" cost, computed from what decay would be rather than applying it.
		var/would_be_decay = get_speed_decay_amount(tick_dt)
		speed_delta = would_be_decay
		consumed_fraction = budget > 0 ? min(would_be_decay / budget, 1) : 0
	else if(stats["torque"] <= 0 && world.time < throttle_held_until)
		// Park/Neutral revving, mirroring Complex mode's own gas_held-in-P/N branch. No torque-budget
		// ratio, since there's no drivetrain resistance to meter against.
		consumed_fraction = 1

	consume_fuel(tick_dt, speed_delta, consumed_fraction)
	update_engine_temperature(tick_dt, consumed_fraction)
	apply_mounted_acid_damage(tick_dt)

/**
 * Performs one discrete movement update for VEHICLE_SIMPLE_ACCELERATION. Called synchronously from
 * gear_accelerate() on every accelerate press, and also drives simple_accel_movement_loop()'s
 * self-paced stepping between presses (see there for why that's needed).
 *
 * Recomputes current_speed fresh from speed_notch every call, since Simple acceleration has no ramp and
 * each notch directly is a speed. Marks simple_accel_pressed so the next tick's
 * handle_simple_accel_idle_tick() charges fuel/heat, and attempts at most one tile move, paced by
 * next_simple_accel_move rather than gear_accelerate()'s own next_move, so a low gear's punchy torque
 * advantage can actually show up instead of being blocked by a shared gate.
 *
 * Deliberately does not use a fractional-tile accumulator for movement pacing, since movement is
 * triggered by however often gear_accelerate() calls this rather than a fixed tick interval. Carrying
 * leftover fractional progress into a later call at a higher speed could overcount distance and fire
 * try_move() twice back to back with no animation between them, visible as the vehicle "teleporting."
 */
/obj/vehicle/multitile/proc/attempt_simple_accel_move()
	// A direction reversal that update_move_direction() is holding back can't just be overwritten with a
	// fresh notch-derived speed, so this presses the same decisive stop gear_brake() already uses for a
	// mismatched-direction press instead of getting faster the wrong way forever.
	if(is_momentum_reversed())
		current_speed = 0
		move_momentum = 0
		speed_notch = 0
		next_notch_climb_time = 0
		return

	var/list/stats = get_current_gear_stats()
	var/traction_scale = get_effective_traction()
	var/part_scale = get_part_condition_scale()
	var/gear_max_speed = get_gear_max_speed(stats, traction_scale, part_scale)

	current_speed = gear_max_speed * (speed_notch / SIMPLE_ACCEL_STEP_COUNT)
	move_momentum = current_speed
	simple_accel_pressed = TRUE

	simple_accel_move_step()
	ensure_simple_accel_movement_loop()

/// The actual try_move() attempt behind attempt_simple_accel_move(), split out so
/// simple_accel_movement_loop() can keep pacing tile steps off next_simple_accel_move without also
/// re-deriving current_speed or re-marking simple_accel_pressed on every poll.
/obj/vehicle/multitile/proc/simple_accel_move_step()
	if(current_speed > VEHICLE_MIN_CRAWL_SPEED && world.time >= next_simple_accel_move)
		if(!try_move(current_move_direction, force = TRUE))
			halve_speed()
		next_simple_accel_move = world.time + 10 / max(current_speed, VEHICLE_MIN_CRAWL_SPEED)

/// Starts simple_accel_movement_loop() if it isn't already running. Cheap enough to call unconditionally.
/obj/vehicle/multitile/proc/ensure_simple_accel_movement_loop()
	if(movement_loop_active)
		return
	movement_loop_active = TRUE
	spawn(0)
		simple_accel_movement_loop()

/**
 * Keeps simple_accel_move_step() advancing on its own pace once the driver has pressed gas, instead of
 * requiring a fresh gear_accelerate() call (and therefore a fresh held-key repeat event from the client)
 * for every single tile.
 *
 * Without this, Simple Acceleration's top speed was silently capped by however often BYOND re-fires
 * relaymove() for a held movement key, which at higher speed notches is slower than the tile rate
 * current_speed actually implies - Complex acceleration never has this problem since gear_movement_loop()
 * already paces tile steps off its own fixed poll, decoupled from input cadence, as long as
 * throttle_held_until stays within its grace window. This mirrors that: current_speed/speed_notch only
 * ever change from an actual press (attempt_simple_accel_move()), this loop just keeps spending the
 * already-decided speed at the correct real-time rate.
 *
 * Exits once current_speed decays to a stop or the driver switches to Complex acceleration mid-drive.
 */
/obj/vehicle/multitile/proc/simple_accel_movement_loop()
	while(current_speed > VEHICLE_MIN_CRAWL_SPEED && (get_driver_vehicle_prefs() & VEHICLE_SIMPLE_ACCELERATION))
		sleep(GEAR_MOVEMENT_POLL_INTERVAL)
		if(world.time >= throttle_held_until)
			break
		simple_accel_move_step()
	movement_loop_active = FALSE

//-----------------------------
//------GEAR TRANSMISSION------
//-----------------------------

/**
 * Gear-transmission dispatch for pre_movement(), used when uses_gear_transmission is TRUE.
 *
 * direction is the fixed screen-absolute compass value BYOND sends for whichever movement key was
 * pressed. It does not rotate with the vehicle's facing, so the four keys have fixed roles here: gas
 * always drives whatever direction the current gear implies, brake only decelerates, and the side
 * keys always turn the hull left/right relative to its own facing.
 *
 * Arguments:
 * * direction = Compass direction of the key pressed, same meaning as pre_movement()'s argument.
 *
 * Returns:
 * * TRUE if the vehicle moved or turned this call, FALSE otherwise.
 */
/obj/vehicle/multitile/proc/gear_pre_movement(direction)
	var/success = FALSE

	if(get_driver_vehicle_prefs() & VEHICLE_SIMPLE_CONTROLS)
		success = gear_pre_movement_simple(direction)
	else
		switch(direction)
			if(NORTH) // gas
				success = gear_accelerate()
			if(SOUTH) // brake
				var/driver_prefs = get_driver_vehicle_prefs()
				// Under Simple Transmission, brake doubles as reverse throttle once already stopped and
				// in R, since there's no manual gear shifter to fall back on. Under Complex Transmission,
				// R is a deliberate driver choice, so brake there only ever decelerates.
				if((driver_prefs & VEHICLE_SIMPLE_TRANSMISSION) && current_gear == "R")
					success = gear_accelerate(TRUE)
				else
					success = gear_brake()
			if(EAST) // turn right relative to current facing (positive deg is counterclockwise, so "right" is -90)
				success = engine_on && world.time >= engine_spinup_until && try_rotate(-90) // turning needs the drivetrain actively powering it, no coasting on existing momentum
			if(WEST) // turn left relative to current facing
				success = engine_on && world.time >= engine_spinup_until && try_rotate(90)

	start_momentum_decay_if_needed()

	return success

/**
 * Gear-transmission dispatch for pre_movement() under the VEHICLE_SIMPLE_CONTROLS preference. Legacy
 * absolute-compass WASD movement instead of tank-relative gas/brake/turn, but drives the gear-
 * transmission's throttle/gear state through gear_accelerate()/try_rotate() rather than move_momentum.
 *
 * Still fully respects gear/transmission state, this only changes how a key press is interpreted.
 * Pressing the key opposite of current travel direction always brakes first while still moving that
 * way. Only once stopped does transmission mode matter: under Simple Transmission the same key
 * auto-shifts gear and starts moving the other way; under Complex transmission, the driver must have
 * already manually shifted into (or out of) R, or the attempt is refused with a hint.
 *
 * Arguments:
 * * direction = Compass direction of the key pressed, same meaning as pre_movement()'s argument.
 *
 * Returns:
 * * TRUE if the vehicle moved, turned, or braked this call, FALSE otherwise.
 */
/obj/vehicle/multitile/proc/gear_pre_movement_simple(direction)
	if(direction == dir || direction == turn(dir, 180))
		var/reverse_intent = (direction == turn(dir, 180))
		var/driver_prefs = get_driver_vehicle_prefs()
		var/mismatched_direction = reverse_intent != (current_gear == "R")

		// Requesting the opposite of current travel direction while still moving that way brakes first
		// instead of immediately flipping gear/reversing underneath us. Once current_speed reaches 0,
		// the next press of the same key falls through below instead.
		//
		// Gated on mismatched_direction, not raw reverse_intent, so holding the same reverse key while
		// already in R keeps falling through to gear_accelerate() instead of braking every press.
		//
		// Deliberately current_speed > 0, not > VEHICLE_MIN_CRAWL_SPEED, matching is_momentum_reversed()'s
		// own threshold. A looser threshold let a small residual speed slip past this guard with
		// current_gear already flipped but current_move_direction still stale, silently eating every
		// other rapid direction-flip press until current_speed happened to hit a true 0.
		if(mismatched_direction && current_speed > 0)
			return gear_brake()

		if(!(driver_prefs & VEHICLE_SIMPLE_TRANSMISSION))
			if(mismatched_direction)
				var/mob/driver = get_seat_mob(VEHICLE_DRIVER)
				if(driver)
					to_chat(driver, SPAN_WARNING("[reverse_intent ? "Shift into Reverse" : "Shift out of Reverse"] first."))
				return FALSE

		return gear_accelerate(reverse_intent)

	// Turning the hull needs the drivetrain actively powering it, same as the turn branches above.
	return engine_on && world.time >= engine_spinup_until && try_rotate(turning_angle(dir, direction))

/**
 * Handles the gas key in gear-transmission mode.
 *
 * Under VEHICLE_SIMPLE_TRANSMISSION, this repicks the gear via get_best_auto_gear(reverse_intent) fresh
 * on every call, driven by the argument rather than the existing current_gear, so forward presses can
 * always shift back out of R.
 *
 * While cruise control is engaged, this raises the target speed instead of driving current_speed
 * directly. Otherwise, under Simple Acceleration, it steps speed_notch up by one and immediately performs
 * one discrete movement update via attempt_simple_accel_move(). When torque can't be built (engine off,
 * spinning up, out of fuel, or in P/N), existing momentum still lets the driver coast on it without
 * stepping speed_notch any higher. Under Complex acceleration, this just marks the gas key as "held" for
 * GEAR_INPUT_GRACE_PERIOD, and the actual acceleration math happens on gear_cruise_loop()'s fixed tick.
 *
 * next_notch_climb_time paces how fast speed_notch can step up, based on how long that speed increment
 * would take to build under Complex mode's constant-torque ramp, so a gear tuned to be punchy under
 * Complex acceleration doesn't climb slower (and cost more fuel/heat) under Simple acceleration.
 *
 * Arguments:
 * * reverse_intent = TRUE if this call means "go backward" (only passed by Simple-controls' backward
 *   key or gear_brake()'s stopped-and-braking convenience). FALSE for the ordinary gas key.
 *
 * Returns:
 * * TRUE if the current gear actually has torque to give, FALSE otherwise (P/N, or no gear set up).
 */
/obj/vehicle/multitile/proc/gear_accelerate(reverse_intent = FALSE)
	// Exiting a skid, the first accelerate press since the turn that created this drift. Transfers the
	// portion of drift_speed a driftless turn-scrub would have discarded entirely onto current_speed as
	// a head start, instead of starting the new axis from 0. The remainder stays on drift_speed, still
	// decaying as normal.
	if(!drift_braking && drift_speed > 0)
		var/transfer_amount = drift_speed * (1 - move_turn_momentum_loss_factor)
		drift_speed -= transfer_amount
		current_speed += transfer_amount
		move_momentum = current_speed

	drift_braking = TRUE // a real gas press is what starts braking off any active drift, not the turn itself
	var/driver_prefs = get_driver_vehicle_prefs()

	if(driver_prefs & VEHICLE_SIMPLE_TRANSMISSION)
		current_gear = get_best_auto_gear(reverse_intent)

	update_move_direction()

	var/list/stats = get_current_gear_stats()

	if(cruise_control_enabled)
		adjust_cruise_control_target(cruise_control_granularity)
		return stats["torque"] > 0

	throttle_held_until = world.time + GEAR_INPUT_GRACE_PERIOD
	update_next_move() // some vehicles (e.g. the tank) hook side effects into this; Simple Acceleration overrides it below

	if(driver_prefs & VEHICLE_SIMPLE_ACCELERATION)
		// Small fixed interval, just pre_movement()'s outer "don't spam-call this proc" gate. Actual
		// tile-movement pacing lives in next_simple_accel_move, and notch-climb pacing in
		// next_notch_climb_time below.
		next_move = world.time + 1
		var/can_build_torque = engine_on && world.time >= engine_spinup_until && stats["torque"] > 0 && has_fuel()
		if(!can_build_torque)
			// No new torque available, but existing momentum should still let the driver coast and steer.
			// Only building more speed is gated, not spending what's already there.
			if(speed_notch <= 0)
				return FALSE
			attempt_simple_accel_move()
			return TRUE
		if(speed_notch < SIMPLE_ACCEL_STEP_COUNT && world.time >= next_notch_climb_time)
			speed_notch += 1
			var/traction_scale = get_effective_traction()
			var/part_scale = get_part_condition_scale()
			var/computed_torque = get_gear_computed_torque(stats, traction_scale, part_scale)
			var/gear_max_speed = get_gear_max_speed(stats, traction_scale, part_scale)
			var/notch_speed_increment = gear_max_speed / SIMPLE_ACCEL_STEP_COUNT
			next_notch_climb_time = world.time + 10 * (notch_speed_increment / max(computed_torque, 0.01))
		attempt_simple_accel_move()
		return TRUE

	next_move = world.time + 1 // just rate-limits key-repeat; gear_cruise_loop() paces the actual physics/movement
	return stats["torque"] > 0

/**
 * Handles the brake key in gear-transmission mode. Under VEHICLE_SIMPLE_TRANSMISSION with Complex
 * controls, there's no manual R to shift into, so holding brake once stopped is treated as reverse
 * intent instead, shifting into R and handing off to gear_accelerate(). Checked before cruise control,
 * so a lingering cruise_control_enabled state never swallows this.
 *
 * Otherwise, while cruise control is engaged, this lowers the target speed instead of braking directly.
 *
 * Otherwise, under Simple Acceleration, zeroes speed_notch and current_speed immediately since braking
 * is a decisive stop, not a gradual taper, and movement is input-driven so nothing else would zero it.
 * Under Complex acceleration, this just marks the brake key as "held"; gear_cruise_loop() decelerates
 * current_speed on its own fixed tick.
 *
 * Returns:
 * * TRUE if this handed off to gear_accelerate() to start reversing, FALSE otherwise.
 */
/obj/vehicle/multitile/proc/gear_brake()
	drift_braking = TRUE // a real brake press is what starts braking off any active drift, not the turn itself
	var/driver_prefs = get_driver_vehicle_prefs()

	// Checked before the cruise control branch below, so a lingering cruise_control_enabled state can't
	// swallow the only way to reverse under Simple Transmission.
	//
	// Deliberately only the "stopped" case, not "already in R", since this proc is also reached from
	// gear_pre_movement_simple()'s mismatched-direction safety net to kill a stale opposing speed down
	// to a clean 0 before flipping direction. Unconditionally reasserting Reverse here would fight that
	// safety net's forward-intent case.
	//
	// Deliberately current_speed <= 0, not <= VEHICLE_MIN_CRAWL_SPEED, matching
	// gear_pre_movement_simple()'s identical tightening: is_momentum_reversed() treats any current_speed
	// > 0 as real opposing motion, so a looser threshold let a residual speed slip through before ever
	// reaching the decisive-zero branch below.
	if((driver_prefs & VEHICLE_SIMPLE_TRANSMISSION) && current_speed <= 0)
		return gear_accelerate(TRUE)

	if(cruise_control_enabled)
		adjust_cruise_control_target(-cruise_control_granularity)
		return FALSE

	if(driver_prefs & VEHICLE_SIMPLE_ACCELERATION)
		speed_notch = 0
		current_speed = 0
		move_momentum = 0
		next_notch_climb_time = 0 // otherwise a stale timestamp could delay the first notch after accelerating again
		brake_held_until = world.time + GEAR_INPUT_GRACE_PERIOD
		next_move = world.time + 1
		return FALSE

	brake_held_until = world.time + GEAR_INPUT_GRACE_PERIOD
	next_move = world.time + 1
	return FALSE

/**
 * Nudges cruise_control_target_speed by delta, clamped between 0 and the current gear's effective max
 * speed. Uses get_gear_max_speed() rather than the raw stats["max_speed"], so Overdrive/fuel performance
 * multipliers can actually be requested instead of just capping at the vehicle's stock top speed.
 *
 * Arguments:
 * * delta = Tiles/sec to change the target by. Positive to raise it, negative to lower it.
 */
/obj/vehicle/multitile/proc/adjust_cruise_control_target(delta)
	var/list/stats = get_current_gear_stats()
	var/traction_scale = get_effective_traction()
	var/part_scale = get_part_condition_scale()
	var/gear_max_speed = get_gear_max_speed(stats, traction_scale, part_scale)
	cruise_control_target_speed = clamp(cruise_control_target_speed + delta, 0, gear_max_speed)
	next_move = world.time + 1
	start_momentum_decay_if_needed()

/**
 * Looks up the currently selected gear's stats.
 *
 * Returns:
 * * An assoc list with "max_speed", "torque" and "fuel_use" keys, or all-zero if gear_stats isn't set up.
 */
/obj/vehicle/multitile/proc/get_current_gear_stats()
	if(!gear_stats || !gear_stats[current_gear])
		return list("max_speed" = 0, "torque" = 0, "fuel_use" = 0)
	return gear_stats[current_gear]

/**
 * Builds this vehicle's full gear_stats table (P/R/N/D/1/2) from top_speed/base_acceleration/
 * base_fuel_use, so every gear's feel stays anchored to a single pair of balance stats. R and D share
 * top_speed/base_acceleration. Gear 1 is tuned to reach half of top_speed in one physics tick at 100%
 * condition, very punchy with a low ceiling. Gear 2 reaches 3/4 of top_speed within a third of D's own
 * stopping distance, moderately punchy with a mid ceiling. fuel_use scales with each gear's own torque.
 *
 * Returns:
 * * The full gear_stats assoc list, ready to assign directly to the gear_stats var.
 */
/obj/vehicle/multitile/proc/build_gear_stats()
	var/tick_seconds = GEAR_TICK_INTERVAL / 10

	var/gear_1_speed = top_speed * GEAR_1_SPEED_FRACTION
	var/gear_1_torque = gear_1_speed / tick_seconds

	var/drive_stop_distance = (top_speed ** 2) / (2 * base_acceleration)
	var/gear_2_speed = top_speed * GEAR_2_SPEED_FRACTION
	var/gear_2_distance = drive_stop_distance * GEAR_2_DISTANCE_FRACTION
	var/gear_2_torque = (gear_2_speed ** 2) / (2 * gear_2_distance)

	return list(
		"P" = list("max_speed" = 0, "torque" = 0, "fuel_use" = 0.05 * idle_fuel_use_mult, "min_power_fraction" = GEAR_MIN_TORQUE_FRACTION),
		"R" = list("max_speed" = gear_2_speed, "torque" = gear_2_torque, "fuel_use" = base_fuel_use * (gear_2_torque / base_acceleration), "min_power_fraction" = GEAR_REVERSE_MIN_POWER_FRACTION),
		"N" = list("max_speed" = 0, "torque" = 0, "fuel_use" = 0.08 * idle_fuel_use_mult, "min_power_fraction" = GEAR_MIN_TORQUE_FRACTION),
		"D" = list("max_speed" = top_speed, "torque" = base_acceleration, "fuel_use" = base_fuel_use, "min_power_fraction" = GEAR_MIN_TORQUE_FRACTION),
		"1" = list("max_speed" = gear_1_speed, "torque" = gear_1_torque, "fuel_use" = base_fuel_use * (gear_1_torque / base_acceleration), "min_power_fraction" = GEAR_1_MIN_POWER_FRACTION),
		"2" = list("max_speed" = gear_2_speed, "torque" = gear_2_torque, "fuel_use" = base_fuel_use * (gear_2_torque / base_acceleration), "min_power_fraction" = GEAR_2_MIN_POWER_FRACTION),
	)

/**
 * How much current_speed decays this tick from rolling/aerodynamic drag. Scales with current speed, so
 * holding a high cruising speed costs more of the acceleration budget to counteract than a low one.
 * Applies continuously whenever there's any momentum, not gated behind a grace period, so the driver
 * has to keep feeding the engine to counteract it.
 *
 * Arguments:
 * * tick_dt = Seconds elapsed this tick.
 *
 * Returns:
 * * Tiles/sec of speed to remove this tick.
 */
/obj/vehicle/multitile/proc/get_speed_decay_amount(tick_dt)
	return current_speed * SPEED_DECAY_COEFFICIENT * tick_dt

/**
 * Applies one tick's worth of drag decay directly to current_speed, flooring it at 0 below
 * VEHICLE_MIN_CRAWL_SPEED. Shared by every gear_cruise_loop() branch that needs plain decay. Deliberately
 * not called while a tick is still genuinely climbing toward its target.
 *
 * Arguments:
 * * tick_dt = Seconds elapsed this tick.
 */
/obj/vehicle/multitile/proc/apply_speed_decay(tick_dt)
	if(current_speed <= 0)
		return
	current_speed = max(current_speed - get_speed_decay_amount(tick_dt), 0)
	if(current_speed < VEHICLE_MIN_CRAWL_SPEED)
		current_speed = 0

/**
 * Decays drift_speed at plain SPEED_DECAY_COEFFICIENT until the driver gives a fresh gas/brake input
 * after the turn that created this drift, then switches to the steeper DRIFT_DECAY_COEFFICIENT.
 * Turning the wheel alone doesn't scrub off sideways momentum, only pressing the pedals again does.
 * drift_braking resets to FALSE on every fresh drift so each turn gets its own coasting window.
 *
 * Called unconditionally from gear_cruise_loop() every tick, including under Simple Acceleration and
 * with the engine off, since drift is just unpowered momentum bleeding off via rolling friction.
 *
 * Arguments:
 * * tick_dt = Seconds elapsed this tick.
 */
/obj/vehicle/multitile/proc/apply_drift_decay(tick_dt)
	if(drift_speed <= 0)
		return
	var/coefficient = drift_braking ? DRIFT_DECAY_COEFFICIENT : SPEED_DECAY_COEFFICIENT
	drift_speed = max(drift_speed - drift_speed * coefficient * tick_dt, 0)
	if(drift_speed < VEHICLE_MIN_CRAWL_SPEED)
		drift_speed = 0
		drift_direction = 0

/**
 * Steps the current gear forward or backward through GLOB.vehicle_gear_order, clamped at both ends
 * (no wraparound, jumping straight from Park to a driving gear or vice versa isn't allowed). Shifting
 * into Park kills all momentum instantly; Neutral leaves current_speed alone and lets the vehicle keep
 * rolling (and decaying) on its own.
 *
 * Also zeroes speed_notch when parking, even for drivers not using Simple Acceleration, since a stale
 * nonzero notch would otherwise make the vehicle start moving on its own once the driver goes idle.
 *
 * Arguments:
 * * delta = +1 to shift up, -1 to shift down.
 *
 * Returns:
 * * The new current_gear.
 */
/obj/vehicle/multitile/proc/cycle_gear(delta)
	var/current_index = GLOB.vehicle_gear_order.Find(current_gear)
	var/new_index = clamp(current_index + delta, 1, length(GLOB.vehicle_gear_order))
	current_gear = GLOB.vehicle_gear_order[new_index]
	update_move_direction() // manually shifting into/out of R needs this to stick immediately too

	if(current_gear == "P")
		current_speed = 0
		move_momentum = 0
		speed_notch = 0
		next_notch_climb_time = 0

	return current_gear

/**
 * Looks up the toggles_vehicle preference bitfield of whichever mob is currently in the driver's seat.
 *
 * Every preference-gated branch in this file calls this fresh at the point of use, never caches it, so
 * a driver swap mid-drive picks up the new driver's preferences on the very next tick/input.
 *
 * Returns:
 * * The driver's toggles_vehicle bitfield, or 0 (today's Complex/Complex/Complex behavior) if there's no
 *   driver or no client.
 */
/obj/vehicle/multitile/proc/get_driver_vehicle_prefs()
	var/mob/driver = get_seat_mob(VEHICLE_DRIVER)
	if(!driver?.client?.prefs)
		return 0
	return driver.client.prefs.toggles_vehicle

/**
 * Picks the gear this vehicle should be in under the VEHICLE_SIMPLE_TRANSMISSION preference. Gear stays
 * fully hidden from the player in this mode.
 *
 * Reversing always selects R. Otherwise walks the forward gears highest-top-speed-first and returns the
 * first one that isn't underpowered, so a healthy vehicle drives in D but a damaged or traction-starved
 * one drops to a lower, punchier gear. Falls back to "1" if every forward gear is underpowered.
 *
 * Arguments:
 * * reverse_intent = TRUE if the driver's current input means "go backward".
 *
 * Returns:
 * * The gear name to shift into.
 */
/obj/vehicle/multitile/proc/get_best_auto_gear(reverse_intent)
	if(reverse_intent)
		return "R"

	var/traction_scale = get_effective_traction()
	var/part_scale = get_part_condition_scale()

	for(var/gear in list("D", "2", "1"))
		var/list/stats = gear_stats?[gear]
		if(!stats)
			continue
		var/computed_torque = get_gear_computed_torque(stats, traction_scale, part_scale)
		if(computed_torque >= stats["torque"] * GEAR_UNDERPOWERED_FRACTION)
			return gear

	return "1"

/// How many flamer_fire are mounted atop this vehicle's hull. 0 by default, only the tank tracks on-hull riders.
/obj/vehicle/multitile/proc/get_mounted_flame_tile_count()
	return 0

/// How many flamer_fire are burning on this vehicle's turfs without being mounted. 0 by default, only the tank tracks its footprint.
/obj/vehicle/multitile/proc/get_underneath_flame_tile_count()
	return 0

/**
 * Applies continuous acid damage from any lingering_acid mounted atop this vehicle's hull.
 *
 * A no-op on the base class, only the tank tracks on-hull riders. Called every tick from both
 * gear_cruise_loop() and handle_simple_accel_idle_tick().
 *
 * Arguments:
 * * tick_dt = Delta time for this physics tick.
 */
/obj/vehicle/multitile/proc/apply_mounted_acid_damage(tick_dt)
	return

/// Finds this vehicle's installed engine hardpoint, if any.
/obj/vehicle/multitile/proc/get_engine_hardpoint()
	return locate(/obj/item/hardpoint/engine) in hardpoints

/// Finds this vehicle's installed treads/wheels hardpoint, if any.
/obj/vehicle/multitile/proc/get_locomotion_hardpoint()
	return locate(/obj/item/hardpoint/locomotion) in hardpoints

/// Finds this vehicle's installed battery hardpoint, if any. Must be present and health > 0 to start the engine.
/obj/vehicle/multitile/proc/get_battery_hardpoint()
	return locate(/obj/item/hardpoint/battery) in hardpoints

/// Finds this vehicle's installed fuel tank hardpoint, if any.
/obj/vehicle/multitile/proc/get_fuel_tank_hardpoint()
	return locate(/obj/item/hardpoint/fuel_tank) in hardpoints

/// Finds this vehicle's installed radiator hardpoint, if any.
/obj/vehicle/multitile/proc/get_radiator_hardpoint()
	return locate(/obj/item/hardpoint/radiator) in hardpoints

/// Current fuel blend's top speed/acceleration multiplier. 1 (no effect) if no fuel tank is installed.
/obj/vehicle/multitile/proc/get_fuel_performance_mult()
	var/obj/item/hardpoint/fuel_tank/tank = get_fuel_tank_hardpoint()
	return tank ? tank.get_fuel_performance_mult() : 1

/**
 * Whether this vehicle currently has power for onboard systems beyond raw mechanical operation. True if
 * the engine is running, or a battery hardpoint has any charge left. Used to fall the turret's rotation
 * back to a slow manual-crank rate when neither is true.
 *
 * Arguments:
 * * ignore_battery = TRUE to skip the battery check entirely, used while a battery hardpoint is on its
 *   way out but hasn't been removed from `hardpoints` yet.
 */
/obj/vehicle/multitile/proc/has_vehicle_power(ignore_battery = FALSE)
	if(engine_on)
		return TRUE
	if(ignore_battery)
		return FALSE
	var/obj/item/hardpoint/battery/battery = get_battery_hardpoint()
	// health > 0 matters separately from current_charge > 0: a destroyed battery keeps its stored charge
	// but can't actually deliver it anymore.
	return battery && battery.health > 0 && battery.current_charge > 0

/**
 * Re-evaluates the installed IFF module's (if any) online/offline state. Call this whenever
 * has_vehicle_power()'s result could change (engine on/off, battery install/uninstall/depletion), so a
 * power loss shuts IFF down as promptly as a wound or destruction would. No-op if no IFF module.
 *
 * Arguments:
 * * ignore_battery = Passed through to has_vehicle_power(). TRUE while a battery is on its way out.
 */
/obj/vehicle/multitile/proc/recheck_iff_module(ignore_battery = FALSE)
	var/obj/item/hardpoint/iff_module/module = locate() in get_hardpoints_copy()
	module?.check_functional_transition(ignore_battery = ignore_battery)

/**
 * Re-evaluates the installed support module's (if any) functional state. Same triggers as
 * recheck_iff_module() above, so a power loss silences a passive buff as promptly as a wound would.
 * No-op if no support module is installed.
 *
 * Arguments:
 * * ignore_battery = Passed through to is_functional()/has_vehicle_power().
 */
/obj/vehicle/multitile/proc/recheck_support_modules(ignore_battery = FALSE)
	var/obj/item/hardpoint/support/module = locate() in get_hardpoints_copy()
	module?.refresh_functional_state(ignore_battery = ignore_battery)

/**
 * Re-evaluates the installed Visual Sensors module's (if any) seated vision-impair overlay. Unlike Air
 * Filter, this is a standing effect that needs an explicit refresh whenever has_vehicle_power() could
 * change, same as recheck_iff_module()/recheck_support_modules() above. No-op if no module or no one seated.
 *
 * Arguments:
 * * ignore_battery = Unused here, kept only to match the recheck_*() family's shared call signature.
 */
/obj/vehicle/multitile/proc/recheck_visual_sensors(ignore_battery = FALSE)
	var/obj/item/hardpoint/visual_sensors/sensors = locate() in get_hardpoints_copy()
	sensors?.refresh_seated_overlays()

/**
 * Total power (units/sec) currently being drawn by this vehicle's onboard systems, summed from every
 * installed, undamaged hardpoint's power_draw. A destroyed hardpoint draws nothing.
 *
 * Returns:
 * * Units/sec.
 */
/obj/vehicle/multitile/proc/get_module_power_draw()
	var/total_draw = 0
	for(var/obj/item/hardpoint/installed_hardpoint in get_hardpoints_copy())
		if(installed_hardpoint.health <= 0)
			continue
		total_draw += installed_hardpoint.power_draw
	return total_draw

/**
 * Continuous background loop managing this vehicle's battery charge. Recharges while the engine is on,
 * drains while it's off. Runs for the vehicle's entire lifetime once started, independent of
 * movement/input, since modules keep drawing power whether or not anyone's touching the controls.
 *
 * Once charge reaches 0 while parked: the turret falls back to manual-crank turn rate, the IFF module
 * shuts down, any Support module's buff drops, and Visual Sensors' overlay jumps to fully obscured. Air
 * Filter isn't recalculated here since it's only ever read live when gas/smoke touches the vehicle.
 */
/obj/vehicle/multitile/proc/battery_power_loop()
	var/tick_dt = BATTERY_TICK_INTERVAL / 10

	while(!QDELETED(src))
		sleep(BATTERY_TICK_INTERVAL)

		var/obj/item/hardpoint/battery/battery = get_battery_hardpoint()
		if(!battery)
			continue

		if(engine_on)
			battery.current_charge = min(battery.current_charge + BATTERY_RECHARGE_RATE * tick_dt, battery.max_charge)
		else
			var/was_charged = battery.current_charge > 0
			battery.current_charge = max(battery.current_charge - get_module_power_draw() * tick_dt, 0)
			if(was_charged && battery.current_charge <= 0)
				var/obj/item/hardpoint/holder/tank_turret/turret = locate() in hardpoints
				if(turret)
					turret.recalculate_turn_rate()
				recheck_iff_module()
				recheck_support_modules()
				recheck_turn_signals()
				recheck_visual_sensors()

/// Average traction of every turf this vehicle currently occupies. 1 if it occupies no turfs somehow.
/obj/vehicle/multitile/proc/get_avg_turf_traction()
	var/total = 0
	var/count = 0
	for(var/turf/occupied_turf as anything in locs)
		total += occupied_turf.get_traction()
		count++
	if(!count)
		return 1
	return total / count

/// Average occupied-turf traction, dampened by the locomotion hardpoint. 1 if no locomotion hardpoint installed.
/obj/vehicle/multitile/proc/get_effective_traction()
	var/obj/item/hardpoint/locomotion/loco = get_locomotion_hardpoint()
	if(!loco)
		return 1
	return loco.get_effective_traction(get_avg_turf_traction())

/**
 * Ramps a hardpoint's raw integrity% into a 0-1 performance scale. Performance only degrades below
 * `threshold_pct`, ramping linearly down to 0 at 0% integrity.
 *
 * Arguments:
 * * integrity_pct = get_integrity_percent() of the part being scaled.
 * * threshold_pct = Defaults to DEGRADE_GRACE_THRESHOLD_PCT. Weapon/turret-ring callers pass
 *   WEAPON_DEGRADE_GRACE_THRESHOLD_PCT instead, which starts biting a little sooner.
 */
/obj/vehicle/multitile/proc/get_health_scale_with_grace(integrity_pct, threshold_pct = DEGRADE_GRACE_THRESHOLD_PCT)
	if(integrity_pct >= threshold_pct)
		return 1
	return max(0, integrity_pct / threshold_pct)

/**
 * Combined engine/locomotion condition scale for the gear-transmission acceleration model.
 *
 * Two refinements over straight health%: each hardpoint's scale ramps in via
 * get_health_scale_with_grace(), and the two hardpoints combine via a geometric mean instead of a
 * straight product, since a product punishes having both parts damaged far harder than either alone
 * (50%/50% would multiply down to 25%). sqrt(a*b) keeps 50%/50% at 50%, only lopsided damage pulls the
 * combined scale below the healthier part's own value.
 *
 * Missing either part means 0 (can't drive without both an engine and treads installed).
 *
 * Returns:
 * * 0-1 scale.
 */
/obj/vehicle/multitile/proc/get_part_condition_scale()
	var/obj/item/hardpoint/engine/engine_hardpoint = get_engine_hardpoint()
	var/obj/item/hardpoint/locomotion/loco = get_locomotion_hardpoint()
	var/engine_scale = engine_hardpoint ? get_health_scale_with_grace(engine_hardpoint.get_integrity_percent()) * engine_hardpoint.get_wound_performance_multiplier() : 0
	var/loco_scale = loco ? get_health_scale_with_grace(loco.get_integrity_percent()) * loco.get_wound_performance_multiplier() : 0
	return sqrt(engine_scale * loco_scale)

/**
 * A gear's actual torque this tick, floored at `stats["min_power_fraction"]` of its own nominal torque
 * regardless of how low engine/tread damage drags the raw scaled value. Gear 1/2 get a much higher floor
 * than D/R/P/N, so they stay dependable low-range crawl gears under heavy damage. Traction isn't part of
 * the floor branch, bad terrain is a separate, legitimate reason to be slow.
 *
 * The floor only applies while part_scale is still positive, so a fully destroyed engine or treads leave
 * the vehicle completely unable to move rather than crawling at the floor.
 *
 * The scaled value, but not the floor, is also multiplied by the fuel blend's performance multiplier, so
 * a bad fuel blend never crushes a gear below the hard floor engine/tread damage already respects.
 *
 * The whole result is then scaled by gear_performance_mult and gear_torque_mult, so a general buff or a
 * torque-only malus both raise/lower the floor along with everything else.
 */
/obj/vehicle/multitile/proc/get_gear_computed_torque(list/stats, traction_scale, part_scale)
	if(part_scale <= 0)
		return 0
	return max(stats["torque"] * traction_scale * part_scale * get_fuel_performance_mult(), stats["torque"] * stats["min_power_fraction"]) * gear_performance_mult * gear_torque_mult

/**
 * A gear's actual reachable speed ceiling this tick. Same floor shape as get_gear_computed_torque(), just
 * applied to max_speed instead of torque, so the "time to reach ceiling" ratio stays consistent once the
 * floor is active.
 */
/obj/vehicle/multitile/proc/get_gear_max_speed(list/stats, traction_scale, part_scale)
	if(part_scale <= 0)
		return 0
	return max(stats["max_speed"] * traction_scale * part_scale * get_fuel_performance_mult(), stats["max_speed"] * stats["min_power_fraction"]) * gear_performance_mult

/**
 * Temporarily boosts gear_performance_mult by overdrive_speed_mult, then reverts after overdrive_duration.
 * No-ops if overdrive_speed_mult is 0 (vehicle doesn't have this ability) or still on cooldown.
 *
 * Arguments:
 * * user = Whoever triggered it, for cooldown/feedback messages.
 */
/obj/vehicle/multitile/proc/activate_overdrive(mob/user)
	if(!overdrive_speed_mult)
		return
	if(overdrive_next > world.time)
		to_chat(user, SPAN_WARNING("You can't activate overdrive yet! Wait [round((overdrive_next - world.time) / 10, 0.1)] seconds."))
		return

	gear_performance_mult *= (1 + overdrive_speed_mult)
	addtimer(CALLBACK(src, PROC_REF(reset_overdrive)), overdrive_duration)

	overdrive_next = world.time + overdrive_cooldown
	to_chat(user, SPAN_NOTICE("You activate overdrive."))
	playsound(src, overdrive_sound, 75, FALSE)

/// Reverts activate_overdrive()'s temporary gear_performance_mult boost.
/obj/vehicle/multitile/proc/reset_overdrive()
	gear_performance_mult /= (1 + overdrive_speed_mult)

/**
 * Whether the current gear is producing meaningfully less torque than its nominal value right now
 * (bad traction, damaged engine/treads). Exposed for the future HUD's red-flash indicator.
 *
 * Routed through get_gear_computed_torque() so it picks up both the per-gear min_power_fraction floor
 * and gear_performance_mult, since a gear resting on its floor guarantee isn't genuinely "underpowered."
 *
 * Returns:
 * * TRUE if computed torque is under GEAR_UNDERPOWERED_FRACTION of nominal, FALSE otherwise.
 */
/obj/vehicle/multitile/proc/is_underpowered()
	var/list/stats = get_current_gear_stats()
	if(!stats["torque"])
		return FALSE
	var/computed_torque = get_gear_computed_torque(stats, get_effective_traction(), get_part_condition_scale())
	return computed_torque < stats["torque"] * GEAR_UNDERPOWERED_FRACTION

/**
 * Advances this vehicle's engine temperature by one physics tick. Heat builds up under load and bleeds
 * off toward the current area's ambient temperature at a rate set by the Radiator hardpoint's condition
 * and remaining coolant. No radiator installed falls back to a much weaker passive cooling rate.
 *
 * Crossing the overheat threshold drips condition damage onto the engine itself.
 *
 * engine_temperature can never rise past ENGINE_OVERHEAT_SHUTDOWN_THRESHOLD. Once hit, the engine
 * force-shuts-off via set_engine_on() rather than climbing further.
 *
 * Also the single shared per-tick choke point for the engine's other auto-shutdown case (running out of
 * fuel), exhaust smoke, and the track-rattle sound loop.
 *
 * Arguments:
 * * tick_dt = Seconds elapsed this physics tick.
 * * consumed_fraction = How much of this tick's acceleration budget was spent, 0 (idle/coasting) to 1
 *   (full accel, or fully revving in Park/Neutral). Scales load heat on top of an idle baseline.
 */
/obj/vehicle/multitile/proc/update_engine_temperature(tick_dt, consumed_fraction)
	var/obj/item/hardpoint/engine/engine_hardpoint = get_engine_hardpoint()
	if(!engine_hardpoint)
		return

	var/obj/item/hardpoint/radiator/radiator = locate(/obj/item/hardpoint/radiator) in hardpoints
	var/cooling_effectiveness = radiator ? radiator.get_cooling_effectiveness() : 0
	var/cooling_coefficient = ENGINE_PASSIVE_COOLING_COEFFICIENT + cooling_effectiveness * (ENGINE_RADIATOR_COOLING_COEFFICIENT - ENGINE_PASSIVE_COOLING_COEFFICIENT)

	var/heat_generated = 0
	if(engine_on)
		var/list/stats = get_current_gear_stats()
		// Heat scales off base_acceleration (Drive's nominal torque), not this gear's own torque, since
		// low-range gears carry a much larger torque number that has nothing to do with actual engine
		// effort per tick. Falls back to ENGINE_REV_TORQUE_EQUIVALENT in Park/Neutral.
		var/load_torque = stats["torque"] ? base_acceleration : ENGINE_REV_TORQUE_EQUIVALENT
		heat_generated = ENGINE_HEAT_IDLE + consumed_fraction * ENGINE_HEAT_PER_LOAD * load_torque
	heat_generated *= tick_dt

	// External heat from fire mounted on the hull or burning ground applies regardless of engine_on,
	// since a burning hull heats the engine compartment either way. 0 for every non-tank vehicle.
	heat_generated += get_mounted_flame_tile_count() * ENGINE_HEAT_PER_MOUNTED_FLAME_TILE * tick_dt
	heat_generated += get_underneath_flame_tile_count() * ENGINE_HEAT_PER_UNDERNEATH_FLAME_TILE * tick_dt

	var/area/current_area = get_area(src)
	var/ambient_temperature = current_area ? current_area.return_temperature() : T20C
	var/heat_removed = (engine_hardpoint.engine_temperature - ambient_temperature) * cooling_coefficient * tick_dt

	engine_hardpoint.engine_temperature = min(engine_hardpoint.engine_temperature + heat_generated - heat_removed, ENGINE_OVERHEAT_SHUTDOWN_THRESHOLD)

	// Condition damage only applies while the engine is running. A shut-off engine can still be sitting
	// above the overheat threshold while it cools back down, and shouldn't keep taking damage for it.
	if(engine_on && engine_hardpoint.is_overheating())
		engine_hardpoint.take_damage(ENGINE_OVERHEAT_DAMAGE_PER_SEC * tick_dt)

	engine_hardpoint.check_overheat_wound_trigger(src)

	if(engine_on && engine_hardpoint.engine_temperature >= ENGINE_OVERHEAT_SHUTDOWN_THRESHOLD)
		set_engine_on(FALSE)
		var/mob/driver = get_seat_mob(VEHICLE_DRIVER)
		if(driver)
			to_chat(driver, SPAN_WARNING("The engine automatically shuts down as it redlines past the danger zone!"))

	// consume_fuel() already silently no-ops once the tank's dry. has_fuel() here is what actually stops
	// the engine from running on a removed/empty tank, mirroring the overheat auto-shutdown above.
	if(engine_on && !has_fuel())
		set_engine_on(FALSE)
		var/mob/driver_mob = get_seat_mob(VEHICLE_DRIVER)
		if(driver_mob)
			to_chat(driver_mob, SPAN_WARNING("The engine sputters and dies - it's out of fuel!"))

	check_engine_exhaust_smoke()
	update_track_sound()

/**
 * Whether the engine is already close enough to ambient that gear_cruise_loop() can stop keeping itself
 * alive just to cool it. The cooling formula is exponential decay, so it never reaches ambient exactly,
 * only within ENGINE_TEMPERATURE_SETTLE_THRESHOLD degrees.
 *
 * Returns:
 * * TRUE if there's no engine hardpoint, or its temperature is within the settle threshold.
 */
/obj/vehicle/multitile/proc/is_engine_temperature_settled()
	var/obj/item/hardpoint/engine/engine_hardpoint = get_engine_hardpoint()
	if(!engine_hardpoint)
		return TRUE
	var/area/current_area = get_area(src)
	var/ambient_temperature = current_area ? current_area.return_temperature() : T20C
	return abs(engine_hardpoint.engine_temperature - ambient_temperature) < ENGINE_TEMPERATURE_SETTLE_THRESHOLD

/**
 * Starts/stops the track-rattle loop to match whether this vehicle is moving right now, distinct from
 * engine_soundloop which plays whenever the engine's on regardless of movement. start()/stop() are
 * already no-ops in the requested state, so this can just run unconditionally every tick.
 */
/obj/vehicle/multitile/proc/update_track_sound()
	if(current_speed > 0)
		track_soundloop?.start()
	else
		track_soundloop?.stop()

/**
 * Starts/stops the skid-loop sound to match whether the vehicle currently has any drift_speed. Same
 * reasoning as update_track_sound() above, runs unconditionally every gear_cruise_loop() tick. Replaces
 * what used to be a plain playsound() fired on every drift_movement_loop() step, which read as spammy.
 */
/obj/vehicle/multitile/proc/update_drift_sound()
	if(drift_speed > 0)
		drift_soundloop?.start()
	else
		drift_soundloop?.stop()

/**
 * Which tint, how often, and how much this vehicle's exhaust smoke should puff right now, or a null
 * color if nothing warrants any. Returns list(color, interval, amount) since wound-driven triggers puff
 * more often and thicker than off-label-fuel triggers.
 *
 * Every currently-relevant engine wound tint gets collected and blended together via BlendRGB(), so a
 * tank with both a cracked block and a fouled injector puffs a genuine mix of both.
 *
 * Returns a 4th list element, is_large_cloud, TRUE if either engine wound family is at its worst tier.
 */
/obj/vehicle/multitile/proc/get_engine_exhaust_smoke_state()
	var/obj/item/hardpoint/engine/engine_hardpoint = get_engine_hardpoint()
	if(engine_hardpoint)
		var/list/active_colors = list()
		var/is_large_cloud = FALSE

		// engine_cracked_block: either tier is white/clear smoke. Only tier 2 counts as large.
		var/block_tier = LAZYACCESS(engine_hardpoint.wound_tiers, /datum/hardpoint_wound_family/engine_cracked_block)
		if(block_tier)
			active_colors += ENGINE_SMOKE_COLOR_BRUTE_WOUND
			if(block_tier >= 2)
				is_large_cloud = TRUE

		// engine_fouled_injector: tier 1 is sooty black, tier 2 is the darkest of the bunch. Only tier 2
		// counts as large.
		var/injector_tier = LAZYACCESS(engine_hardpoint.wound_tiers, /datum/hardpoint_wound_family/engine_fouled_injector)
		if(injector_tier == 1)
			active_colors += ENGINE_SMOKE_COLOR_FOULED_CARBURATOR
		else if(injector_tier >= 2)
			active_colors += ENGINE_SMOKE_COLOR_ACID_WOUND
			is_large_cloud = TRUE

		if(length(active_colors))
			var/blended_color = active_colors[1]
			for(var/i in 2 to length(active_colors))
				blended_color = BlendRGB(blended_color, active_colors[i], 0.5)
			return list(blended_color, ENGINE_SMOKE_INTERVAL_WOUND, ENGINE_SMOKE_AMOUNT_WOUND, is_large_cloud)

	// Gated on how dominant a single off-label reagent is, not just whether the blend is off-label at
	// all, so a light splash of welding fuel topped off with mostly JP-8 shouldn't visibly smoke.
	var/obj/item/hardpoint/fuel_tank/tank = get_fuel_tank_hardpoint()
	if(tank)
		if(tank.get_reagent_fraction("fuel") > VEHICLE_FUEL_SMOKE_THRESHOLD_PCT / 100)
			return list(ENGINE_SMOKE_COLOR_OFF_LABEL_FUEL, ENGINE_SMOKE_INTERVAL_WELDING_FUEL, ENGINE_SMOKE_AMOUNT_DEFAULT, FALSE)
		if(tank.get_reagent_fraction("cornoil") > VEHICLE_FUEL_SMOKE_THRESHOLD_PCT / 100)
			return list(ENGINE_SMOKE_COLOR_OFF_LABEL_FUEL, ENGINE_SMOKE_INTERVAL_COOKING_OIL, ENGINE_SMOKE_AMOUNT_DEFAULT, FALSE)

	return list(null, ENGINE_SMOKE_INTERVAL_COOKING_OIL, ENGINE_SMOKE_AMOUNT_DEFAULT, FALSE)

/**
 * Puffs a smoke effect from behind the vehicle while the engine's running and either an exhaust-smoke-
 * worthy engine wound is active, or the tank's running on off-label fuel. Reuses the same smoke effect
 * the M40 HSDP grenade spawns, tinted per trigger via get_engine_exhaust_smoke_state(). Throttled to one
 * puff per that trigger's own interval. Also puffs a matching cloud inside the fighting compartment if
 * the air filter can't keep it out.
 *
 * A Tier 2 engine wound puffs a full cross (the exhaust turf plus all 4 cardinal-adjacent turfs) instead
 * of just the single exhaust tile every other trigger uses, so a wrecked engine billows out wider.
 */
/obj/vehicle/multitile/proc/check_engine_exhaust_smoke()
	if(!engine_on || world.time < next_exhaust_smoke_time)
		return

	var/list/smoke_state = get_engine_exhaust_smoke_state()
	var/smoke_color = smoke_state[1]
	if(!smoke_color)
		return

	next_exhaust_smoke_time = world.time + smoke_state[2]
	var/smoke_amount = smoke_state[3]
	var/is_large_cloud = smoke_state[4]

	var/turf/exhaust_turf = get_step(get_turf(src), turn(dir, 180))
	if(exhaust_turf)
		spawn_exhaust_smoke_puff(exhaust_turf, smoke_color, smoke_amount)
		if(is_large_cloud)
			for(var/cardinal_dir in GLOB.cardinals)
				var/turf/cross_turf = get_step(exhaust_turf, cardinal_dir)
				if(cross_turf)
					spawn_exhaust_smoke_puff(cross_turf, smoke_color, smoke_amount)

	puff_interior_exhaust_smoke(smoke_color, smoke_amount)

/// Spawns one exhaust-smoke puff at `puff_turf`, tinted `smoke_color`. Factored out for the Tier 2 cross spread.
/obj/vehicle/multitile/proc/spawn_exhaust_smoke_puff(turf/puff_turf, smoke_color, smoke_amount)
	var/obj/effect/particle_effect/smoke/bad/exhaust_smoke = new(puff_turf, smoke_amount)
	exhaust_smoke.color = smoke_color
	// Default smoke layer sits below a tank's own riders, hiding the exhaust puff entirely.
	exhaust_smoke.layer = TANK_ABOVE_RIDER_LAYER

/**
 * Puffs a matching smoke cloud inside the vehicle's fighting compartment, scaled by how compromised the
 * air filter is. Delegates to bridge_smoke_into_interior(), the same mechanic a Boiler glob or Acid
 * Runner cloud uses, so any smoke touching the tank gets identical containment behavior.
 *
 * Arguments:
 * * smoke_color = The tint to apply, matching the exterior puff.
 * * smoke_amount = The amount to spawn with, matching the exterior puff.
 */
/obj/vehicle/multitile/proc/puff_interior_exhaust_smoke(smoke_color, smoke_amount)
	bridge_smoke_into_interior(/obj/effect/particle_effect/smoke/bad, smoke_color, smoke_amount)

/**
 * Bridges a smoke_path cloud into this vehicle's fighting compartment, scaled by how compromised its air
 * filter currently is. Shared by every source of exterior smoke that touches the vehicle, so they all
 * get identical containment behavior. A healthy filter blocks it outright, a compromised one lets it in
 * with alpha/opacity scaled by leak_fraction.
 *
 * Loops the interior's actual room and reuses any existing smoke_path instance already on a given turf
 * instead of stacking duplicates, so a sustained leak visibly fills the whole compartment.
 *
 * Arguments:
 * * smoke_path = The exact smoke subtype to bridge in, reused turf-by-turf across calls.
 * * smoke_color = Tint to apply, or null to leave whatever color smoke_path's own type already sets.
 * * smoke_amount = The amount to construct a new instance with, or null to use smoke_path's own default.
 */
/obj/vehicle/multitile/proc/bridge_smoke_into_interior(smoke_path, smoke_color, smoke_amount)
	if(!interior)
		return
	var/obj/item/hardpoint/air_filter/filter = locate() in get_hardpoints_copy()
	var/leak_fraction = 1 // No filter installed at all - fully unfiltered, same as a destroyed one.
	if(filter)
		leak_fraction = filter.get_gas_leak_fraction()
		if(leak_fraction <= 0)
			return

	var/turf/center = interior.get_middle_turf()
	if(!center)
		return
	var/h_radius = max(0, round((interior.width - 1) / 2))
	var/v_radius = max(0, round((interior.height - 1) / 2))
	for(var/turf/car_turf as anything in RECT_TURFS(h_radius, v_radius, center))
		var/obj/effect/particle_effect/smoke/existing = locate(smoke_path) in car_turf
		if(!existing)
			existing = smoke_amount ? new smoke_path(car_turf, smoke_amount) : new smoke_path(car_turf)
			existing.bridged_vehicle = src
		if(smoke_color)
			existing.color = smoke_color
		existing.gas_leak_fraction = leak_fraction
		existing.alpha = max(20, round(255 * leak_fraction))
		existing.set_opacity(existing.alpha >= AIR_FILTER_LEAK_OPACITY_ALPHA_THRESHOLD) // a faint leak doesn't block sight, only a thick one does

/// Whether this vehicle has a fuel tank installed with any fuel left in it at all.
/obj/vehicle/multitile/proc/has_fuel()
	var/obj/item/hardpoint/fuel_tank/tank = locate(/obj/item/hardpoint/fuel_tank) in hardpoints
	return tank && tank.reagents && tank.reagents.total_volume > 0

/**
 * Burns fuel for one physics tick. For driving gears, the baseline cost scales with consumed_fraction,
 * so accelerating from a stop costs far more than holding an already-reached speed. For Park/Neutral, a
 * small idle burn always applies while the engine's on, plus a minimal extra cost while revving. On top
 * of either, an extra cost scales with how much the speed actually changed this tick. Blends in the
 * off-label fuel penalty. No-ops entirely while the engine is off.
 *
 * ENGINE_IDLE_FUEL_USE is added unconditionally whenever the engine's on, covering the case of sitting
 * still in a driving gear with no throttle input at all. Every idle-related term (ENGINE_IDLE_FUEL_USE,
 * ENGINE_REV_FUEL_USE, and Park/Neutral's own base fuel_use from build_gear_stats()) is scaled by this
 * vehicle's own idle_fuel_use_mult.
 *
 * Arguments:
 * * dt = Seconds elapsed this tick, for the baseline cruising/idle cost.
 * * speed_delta = Tiles/sec current_speed actually changed by this tick, for the extra accel cost.
 * * consumed_fraction = How much of this tick's acceleration budget was spent, 0 (idle/coasting) to 1
 *   (full accel, or fully revving in Park/Neutral).
 */
/obj/vehicle/multitile/proc/consume_fuel(dt, speed_delta = 0, consumed_fraction = 0)
	if(!engine_on)
		return
	var/obj/item/hardpoint/fuel_tank/tank = locate(/obj/item/hardpoint/fuel_tank) in hardpoints
	if(!tank || !tank.reagents || tank.reagents.total_volume <= 0)
		return

	var/list/stats = get_current_gear_stats()
	var/cruise_amount

	if(stats["max_speed"] > 0)
		cruise_amount = stats["fuel_use"] * consumed_fraction * dt
	else
		cruise_amount = (stats["fuel_use"] + consumed_fraction * ENGINE_REV_FUEL_USE * idle_fuel_use_mult) * dt

	var/accel_amount = ACCEL_FUEL_PER_SPEED_DELTA * speed_delta
	var/idle_amount = ENGINE_IDLE_FUEL_USE * idle_fuel_use_mult * dt
	tank.consume_fuel((cruise_amount + accel_amount + idle_amount) * tank.get_fuel_blend_penalty())
