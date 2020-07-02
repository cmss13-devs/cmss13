/*
	Vehicles have momentum, which makes the movement code a bit complex.
	To avoid race conditions between user inputs and timers for rolling movement,
	the movement logic is split into 3 parts:

	- Pre-movement, which determines what movement inputs will be considered (the user's or the momentum code's?)
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

// The window before the vehicle can move again in which the user can buffer their movement inputs
#define VEHICLE_INPUT_BUFFER_WINDOW 1

// Called when someone tries to move the vehicle
/obj/vehicle/multitile/relaymove(var/mob/user, var/direction)
	if(user != seats[VEHICLE_DRIVER])
		return

	// Won't even consider moves when the vehicle is broken
	if(health <= 0)
		return FALSE

	// The driver can start buffering movement inputs VEHICLE_INPUT_BUFFER_WINDOW ds before the next move
	if(world.time > next_move - VEHICLE_INPUT_BUFFER_WINDOW)
		buffered_move = direction

	// If we have momentum, the movement procs will loop themselves until it falls below 1
	if(abs(momentum) >= 1)
		return FALSE

	return pre_movement()

// This determines what type of movement to execute and which input to pass to it
/obj/vehicle/multitile/proc/pre_movement()
	if(world.time < next_move)
		return FALSE

	var/success = FALSE

	// User buffered a movement input, use that
	if(buffered_move)
		var/direction = buffered_move
		buffered_move = null

		// Forwards/backwards
		if(dir == turn(direction, 180) || dir == direction)
			var/old_dir = dir
			success = try_move(direction)
			// Keep dir when driving backwards
			dir = old_dir
		// Rotation/turning
		else
			success = try_rotate(turning_angle(dir, direction))

		post_movement()
		return success

	// Keep rolling from sufficient momentum. Only roll when momentum is >1 so we can do small adjustments without rolling away
	// Decided to do this with timers instead of processing because the processing tickrate
	// usually doesn't match up that well with the movement delays
	/*
		Rolling is disabled because it feels really bad with lag
		Momentum is still lost
	*/
	//success = try_move((momentum > 0) ? dir : turn(dir, 180), TRUE)
	update_momentum((momentum > 0) ? dir : turn(dir, 180), TRUE)

	post_movement()
	return success

// This determines if the movement cycle should be automatically repeated due to momentum/inertia
/obj/vehicle/multitile/proc/post_movement()
	if(abs(momentum) < 1)
		return
	add_timer(CALLBACK(src, .proc/pre_movement), next_move - world.time)

// Attempts to execute the given movement input
/obj/vehicle/multitile/proc/try_move(var/direction, var/rolling=FALSE, var/force=FALSE)
	if(!can_move(direction))
		return FALSE

	if(!force)
		var/should_move = update_momentum(direction, rolling)
		update_next_move()

		if(!should_move)
			return FALSE

	var/turf/old_turf = get_turf(src)
	forceMove(get_step(src, direction))

	for(var/obj/item/hardpoint/H in hardpoints)
		H.on_move(old_turf, get_turf(src), direction)

	if(movement_sound && !force)
		playsound(src, movement_sound, vol = 20, sound_range = 30)

	return TRUE

// Rotates the vehicle by deg degrees if possible
/obj/vehicle/multitile/proc/try_rotate(var/deg)
	if(!can_rotate(deg))
		return FALSE

	momentum *= turn_momentum_loss_factor
	update_next_move()

	rotate_hardpoints(deg)
	rotate_entrances(deg)
	rotate_bounds(deg)
	dir = turn(dir, deg)

	update_icon()

	return TRUE

// Increases/decreases the vehicle's momentum according to whether or not the user is steppin' on the gas or not
/obj/vehicle/multitile/proc/update_momentum(var/direction, var/rolling=FALSE)
	// If we've stood still for long enough we go back to 0 momentum
	if(abs(momentum) <= 1 && world.time > next_move + move_delay*momentum_build_factor)
		momentum = 0

	// If we're rolling we lose momentum instead of gaining it
	if(rolling)
		if(direction == dir)
			momentum = max(momentum - 1, 0)
		else
			momentum = min(momentum + 1, 0)
	else
		if(direction == dir)
			momentum = min(momentum + 1, max_momentum)
		else
			momentum = max(momentum - 1, -max_momentum)

	// Attempt to move in the opposite direction to our momentum
	if(direction == dir && momentum < 0 || direction != dir && momentum > 0)
		// Brakes or something
		momentum = Floor(momentum/2)
		return FALSE

	return TRUE

/obj/vehicle/multitile/proc/update_next_move()
	// 1/((m/M)*b) where m is momentum, M is max momentum and b is the build factor
	var/anti_build_factor = momentum != 0 ? 1/((abs(momentum)/max_momentum)*momentum_build_factor) : 1/((1/max_momentum)*momentum_build_factor)
	next_move = world.time + move_delay * momentum_build_factor * anti_build_factor * misc_multipliers["move"]
	l_move_time = world.time

// This just checks if the vehicle can physically move in the given direction
/obj/vehicle/multitile/proc/can_move(var/direction)
	var/can_move = TRUE

	var/turf/min_turf = locate(x + bound_x / world.icon_size, y + bound_y / world.icon_size, z)
	var/turf/max_turf = locate(min_turf.x + (bound_width / world.icon_size) - 1, min_turf.y + (bound_height / world.icon_size) - 1, z)
	var/list/old_turfs = block(min_turf, max_turf)

	var/turf/new_loc = get_step(src, direction)
	min_turf = locate(new_loc.x + bound_x / world.icon_size, new_loc.y + bound_y / world.icon_size, z)
	max_turf = locate(min_turf.x + (bound_width / world.icon_size) - 1, min_turf.y + (bound_height / world.icon_size) - 1, z)

	for(var/turf/T in block(min_turf, max_turf))
		// only check the turfs we're moving to
		if(T in old_turfs)
			continue

		if(!T.Enter(src))
			can_move = FALSE

	// Crashed with something that stopped us
	if(!can_move)
		momentum = Floor(momentum/2)
		update_next_move()
		interior_crash_effect()

	return can_move

/obj/vehicle/multitile/proc/can_rotate(var/deg)
	if(bound_width == bound_height)
		return TRUE
	//VHCLTODO: Add non-square checks here
	return FALSE

/obj/vehicle/multitile/proc/rotate_entrances(var/deg)
	entrances = rotate_origins(deg, entrances)

/obj/vehicle/multitile/proc/rotate_hardpoints(var/deg, var/update_icons = TRUE, var/list/specific_hardpoints = null)
	if(specific_hardpoints)
		for(var/obj/item/hardpoint/H in specific_hardpoints)
			H.rotate(deg)
		return

	for(var/obj/item/hardpoint/H in hardpoints)
		H.rotate(deg)

	if(update_icons)
		update_icon()

// Rotates a list of relative coordinates around the center of the vehicle
/obj/vehicle/multitile/proc/rotate_origins(var/deg, var/list/origins, var/list/specific_indexes)
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

/obj/vehicle/multitile/proc/rotate_bounds(var/deg)
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
	if(abs(momentum) <= 1)
		return

	var/fling_distance = Ceiling(momentum/max_momentum) * 2
	var/turf/target = interior.get_middle_turf()

	for (var/x in 0 to fling_distance-1)
		// NOTE: We fling east/west because all interiors are front-facing east
		target = get_step(target, momentum > 0 ? EAST : WEST)
		if (!target)
			break

	var/list/bounds = interior.get_bound_turfs()
	for(var/turf/T in block(bounds[1], bounds[2]))
		for(var/atom/movable/A in T)
			if(A.anchored)
				continue

			if(isliving(A))
				var/mob/living/M = A

				shake_camera(M, 2, Ceiling(momentum/max_momentum) * 1)
				if(!M.buckled)
					M.apply_effect(1, STUN)
					M.apply_effect(2, WEAKEN)

			// YOU'RE LIKE A CAR CRASH IN SLOW MOTION!
			// IT'S LIKE I'M WATCHIN' YA FLY THROUGH A WINDSHIELD!		
			A.throw_atom(target, fling_distance, SPEED_VERY_FAST, src, TRUE)
