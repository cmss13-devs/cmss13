/datum/flameshape
	var/name = ""
	var/id = FLAMESHAPE_NONE

/datum/flameshape/proc/handle_fire_spread(obj/flamer_fire/F, fire_spread_amount, burn_dam, fuel_pressure = 1)
	return

/datum/flameshape/proc/is_tank_obstacle(atom/obstacle)
	return istype(obstacle, /obj/vehicle/multitile/tank)

/**
 * Decides which tank (if any) a newly-created flame at turf T should mount atop.
 * Mounts if continuing from something already mounted, or arriving from outside the tank's footprint.
 *
 * Arguments:
 * * turf/T = The turf a new flame is about to be created on.
 * * turf/prev_T = The immediately preceding turf in this fire's propagation chain.
 * * prev_mount_tank = Whichever tank the thing at prev_T was already mounted atop.
 *
 * Returns:
 * * The tank to mount atop, or FALSE to stay grounded.
 */
/proc/resolve_flame_mount(turf/T, turf/prev_T, obj/vehicle/multitile/tank/prev_mount_tank)
	var/obj/vehicle/multitile/tank/here_tank = get_multitile_vehicle_at(T)
	if(!here_tank)
		return FALSE
	if(prev_mount_tank == here_tank)
		return here_tank
	if(!prev_T || get_multitile_vehicle_at(prev_T) != here_tank)
		return here_tank
	return FALSE

/datum/flameshape/proc/generate_fire(turf/T, obj/flamer_fire/F2, new_spread_amt, fs, should_call, skip_flame = FALSE, fuel_pressure = 1, mount_override = FLAME_MOUNT_AUTO)
	var/obj/flamer_fire/foundflame = locate() in T
	if(foundflame && foundflame.tied_reagents == F2.tied_reagents && !skip_flame) // From the same flames
		return

	if(foundflame)
		qdel(foundflame)

	var/to_call = F2.to_call

	if(!should_call)
		to_call = null

	new /obj/flamer_fire(T, F2.weapon_cause_data, F2.tied_reagent, new_spread_amt, F2.tied_reagents, fs, F2.target_clicked, to_call, fuel_pressure, F2.fire_variant, mount_override)
	return TRUE

/datum/flameshape/default
	name = "Default"
	id = FLAMESHAPE_DEFAULT

/datum/flameshape/default/handle_fire_spread(obj/flamer_fire/F, fire_spread_amount, burn_dam, fuel_pressure = 1)
	var/turf/T
	var/turf/source_turf = get_turf(F.loc)
	for(var/dirn in GLOB.cardinals)
		T = get_step(source_turf, dirn)
		if(istype(T, /turf/open/space))
			continue

		var/obj/flamer_fire/foundflame = locate() in T
		if(foundflame && foundflame.tied_reagent == F.tied_reagent)
			continue

		var/new_spread_amt = fire_spread_amount - 1
		if(T.density)
			T.flamer_fire_act(burn_dam, F.weapon_cause_data)
			new_spread_amt = 0

		else
			var/obj/flamer_fire/temp = new()
			var/atom/A = LinkBlocked(temp, source_turf, T)

			if(A)
				A.flamer_fire_act(burn_dam, F.weapon_cause_data)
				if (A.flags_atom & ON_BORDER)
					break
				if(!is_tank_obstacle(A))
					new_spread_amt = 0

		var/mount_override = resolve_flame_mount(T, source_turf, F.get_tank_on_top_of())
		addtimer(CALLBACK(src, PROC_REF(generate_fire), T, F, new_spread_amt, F.flameshape, null, FALSE, fuel_pressure, mount_override), 0)


/datum/flameshape/default/irregular
	name = "Irregular"
	id = FLAMESHAPE_IRREGULAR

/datum/flameshape/star
	name = "Star"
	id = FLAMESHAPE_STAR

/datum/flameshape/star/proc/dirs_to_use()
	return GLOB.alldirs

/datum/flameshape/star/handle_fire_spread(obj/flamer_fire/F, fire_spread_amount, burn_dam, fuel_pressure = 1)
	fire_spread_amount = floor(fire_spread_amount * 1.5) // branch 'length'
	var/turf/source_turf = get_turf(F.loc)

	var/list/dirs = dirs_to_use()

	for(var/dirn in dirs)
		var/endturf = get_ranged_target_turf(F, dirn, fire_spread_amount)
		var/list/turfs = get_line(source_turf, endturf)

		var/turf/prev_T = source_turf
		for(var/turf/T in turfs)
			if(istype(T,/turf/open/space))
				continue
			if(T == F.loc)
				prev_T = T
				continue

			if(T.density && !T.throwpass) // unpassable turfs stop the spread
				T.flamer_fire_act(burn_dam, F.weapon_cause_data)

			var/obj/flamer_fire/temp = new()
			var/atom/A = LinkBlocked(temp, prev_T, T)
			if(A)
				A.flamer_fire_act(burn_dam, , F.weapon_cause_data)
				if (A.flags_atom & ON_BORDER)
					break

			addtimer(CALLBACK(src, PROC_REF(generate_fire), T, F, 0, FLAMESHAPE_MINORSTAR, null, FALSE, fuel_pressure), 0)
			prev_T = T

/datum/flameshape/star/minor
	name = "Minor Star"
	id = FLAMESHAPE_MINORSTAR

/datum/flameshape/star/minor/dirs_to_use()
	if(prob(50))
		return GLOB.cardinals
	else
		return GLOB.diagonals

/datum/flameshape/line
	name = "Line"
	id = FLAMESHAPE_LINE

/datum/flameshape/line/handle_fire_spread(obj/flamer_fire/F, fire_spread_amount, burn_dam, fuel_pressure = 1)
	var/turf/source_turf = get_turf(F.loc)

	var/turf/prev_T
	var/obj/vehicle/multitile/tank/prev_mount_tank = F.get_tank_on_top_of()

	var/distance = 1
	var/stop_at_turf = FALSE

	var/list/turfs = get_line(source_turf, F.target_clicked)
	for(var/turf/T in turfs)
		if(istype(T, /turf/open/space))
			break

		if(distance > (fire_spread_amount - 1))
			break

		if(T.density)
			T.flamer_fire_act(burn_dam, F.weapon_cause_data)
			stop_at_turf = TRUE
		else if(prev_T)
			var/obj/flamer_fire/temp = new()
			var/atom/A = LinkBlocked(temp, prev_T, T)

			if(A)
				A.flamer_fire_act(burn_dam, F.weapon_cause_data)
				if (A.flags_atom & ON_BORDER)
					break
				if(!is_tank_obstacle(A))
					stop_at_turf = TRUE

		if(T == F.loc)
			if(stop_at_turf)
				break
			prev_T = T
			continue

		var/mount_override = FALSE
		if(!stop_at_turf)
			mount_override = resolve_flame_mount(T, prev_T, prev_mount_tank)
		addtimer(CALLBACK(src, PROC_REF(generate_fire), T, F, 0, F.flameshape, null, TRUE, fuel_pressure, mount_override), distance)
		if(stop_at_turf)
			break

		distance++
		prev_T = T
		prev_mount_tank = mount_override

	if(F.to_call)
		addtimer(F.to_call, distance + 1)

/datum/flameshape/triangle
	name = "Triangle"
	id = FLAMESHAPE_TRIANGLE

/datum/flameshape/triangle/handle_fire_spread(obj/flamer_fire/F, fire_spread_amount, burn_dam, fuel_pressure = 1)
	set waitfor = 0

	var/unleash_dir = get_cardinal_dir(F, F.target_clicked)
	var/list/turf/turfs = get_line(F, F.target_clicked)
	var/distance = 1
	var/hit_dense_atom_mid = FALSE
	var/turf/prev_T
	var/obj/vehicle/multitile/tank/prev_mount_tank_mid = F.get_tank_on_top_of()

	for(var/turf/T in turfs)
		if(distance > fire_spread_amount)
			break

		if(T.density)
			T.flamer_fire_act(burn_dam, F.weapon_cause_data)
			hit_dense_atom_mid = TRUE
		else if(prev_T)
			var/atom/movable/temp = new/obj/flamer_fire()
			var/atom/movable/AM = LinkBlocked(temp, prev_T, T)
			qdel(temp)
			if(AM)
				AM.flamer_fire_act(burn_dam, F.weapon_cause_data)
				if (AM.flags_atom & ON_BORDER)
					break
				if(!is_tank_obstacle(AM))
					hit_dense_atom_mid = TRUE

		if(T == F.loc)
			if (hit_dense_atom_mid)
				break

			prev_T = T
			continue

		var/mid_mount_override = FALSE
		if(!hit_dense_atom_mid)
			mid_mount_override = resolve_flame_mount(T, prev_T, prev_mount_tank_mid)
		addtimer(CALLBACK(src, PROC_REF(generate_fire), T, F, 0, FLAMESHAPE_TRIANGLE, null, FALSE, fuel_pressure, mid_mount_override), 0)
		prev_T = T
		prev_mount_tank_mid = mid_mount_override
		sleep(1)

		var/list/turf/right = list()
		var/list/turf/left = list()
		var/turf/right_turf = T
		var/turf/left_turf = T
		var/right_dir = turn(unleash_dir, 90)
		var/left_dir = turn(unleash_dir, -90)
		for (var/i = 0, i < 1, i++)
			right_turf = get_step(right_turf, right_dir)
			right += right_turf
			left_turf = get_step(left_turf, left_dir)
			left += left_turf

		var/hit_dense_atom_side = FALSE

		var/turf/prev_R = T
		var/obj/vehicle/multitile/tank/prev_mount_tank_right = mid_mount_override
		for (var/turf/R in right)
			if(prev_R)
				var/atom/movable/temp = new/obj/flamer_fire()
				var/atom/movable/AM = LinkBlocked(temp, prev_R, R)
				qdel(temp)
				if(AM)
					AM.flamer_fire_act(burn_dam, F.weapon_cause_data)
					if (AM.flags_atom & ON_BORDER)
						break
					if(!is_tank_obstacle(AM))
						hit_dense_atom_side = TRUE
				else if (hit_dense_atom_mid)
					break
			var/right_mount_override = resolve_flame_mount(R, prev_R, prev_mount_tank_right)
			generate_fire(R, F, 0, FLAMESHAPE_TRIANGLE, FALSE, FALSE, fuel_pressure, right_mount_override)
			if (!hit_dense_atom_mid && hit_dense_atom_side)
				break
			prev_R = R
			prev_mount_tank_right = right_mount_override
			sleep(1)

		var/turf/prev_L = T
		var/obj/vehicle/multitile/tank/prev_mount_tank_left = mid_mount_override
		for (var/turf/L in left)
			if(prev_L)
				var/atom/movable/temp = new/obj/flamer_fire()
				var/atom/movable/AM = LinkBlocked(temp, prev_L, L)
				qdel(temp)
				if(AM)
					AM.flamer_fire_act(burn_dam, F.weapon_cause_data)
					if (AM.flags_atom & ON_BORDER)
						break
					if(!is_tank_obstacle(AM))
						hit_dense_atom_side = TRUE
				else if (hit_dense_atom_mid)
					break
			var/left_mount_override = resolve_flame_mount(L, prev_L, prev_mount_tank_left)
			generate_fire(L, F, 0, FLAMESHAPE_TRIANGLE, FALSE, FALSE, fuel_pressure, left_mount_override)
			if (!hit_dense_atom_mid && hit_dense_atom_side)
				break
			prev_L = L
			prev_mount_tank_left = left_mount_override
			sleep(1)

		if (hit_dense_atom_mid)
			break

		distance++

	if(F.to_call)
		F.to_call.Invoke()


GLOBAL_LIST_INIT(flameshapes, list(
	FLAMESHAPE_DEFAULT = new /datum/flameshape/default(),
	FLAMESHAPE_IRREGULAR = new /datum/flameshape/default/irregular(),
	FLAMESHAPE_STAR = new /datum/flameshape/star(),
	FLAMESHAPE_MINORSTAR = new /datum/flameshape/star/minor(),
	FLAMESHAPE_TRIANGLE = new /datum/flameshape/triangle(),
	FLAMESHAPE_LINE = new /datum/flameshape/line(),
))
