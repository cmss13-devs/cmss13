/datum/flameshape
	var/name = ""
	var/id = FLAMESHAPE_NONE

/datum/flameshape/proc/handle_fire_spread(obj/flamer_fire/F, fire_spread_amount, burn_dam, fuel_pressure = 1)
	return

/datum/flameshape/proc/generate_fire(turf/T, obj/flamer_fire/F2, new_spread_amt, fs, should_call, skip_flame = FALSE, fuel_pressure = 1)
	var/obj/flamer_fire/foundflame = locate() in T
	if(foundflame && foundflame.tied_reagents == F2.tied_reagents && !skip_flame) // From the same flames
		return

	if(foundflame)
		qdel(foundflame)

	var/to_call = F2.to_call

	if(!should_call)
		to_call = null

	new /obj/flamer_fire(T, F2.weapon_cause_data, F2.tied_reagent, new_spread_amt, F2.tied_reagents, fs, F2.target_clicked, to_call, fuel_pressure, F2.fire_variant)
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
				new_spread_amt = 0

		addtimer(CALLBACK(src, PROC_REF(generate_fire), T, F, new_spread_amt, F.flameshape, null, FALSE, fuel_pressure), 0)


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
				stop_at_turf = TRUE

		if(T == F.loc)
			if(stop_at_turf)
				break
			prev_T = T
			continue

		addtimer(CALLBACK(src, PROC_REF(generate_fire), T, F, 0, F.flameshape, null, TRUE, fuel_pressure), distance)
		if(stop_at_turf)
			break

		distance++
		prev_T = T

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
				hit_dense_atom_mid = TRUE

		if(T == F.loc)
			if (hit_dense_atom_mid)
				break

			prev_T = T
			continue

		addtimer(CALLBACK(src, PROC_REF(generate_fire), T, F, 0, FLAMESHAPE_TRIANGLE, null, FALSE, fuel_pressure), 0)
		prev_T = T
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
		for (var/turf/R in right)
			if(prev_R)
				var/atom/movable/temp = new/obj/flamer_fire()
				var/atom/movable/AM = LinkBlocked(temp, prev_R, R)
				qdel(temp)
				if(AM)
					AM.flamer_fire_act(burn_dam, F.weapon_cause_data)
					if (AM.flags_atom & ON_BORDER)
						break
					hit_dense_atom_side = TRUE
				else if (hit_dense_atom_mid)
					break
			generate_fire(R, F, 0, FLAMESHAPE_TRIANGLE, FALSE, FALSE, fuel_pressure)
			if (!hit_dense_atom_mid && hit_dense_atom_side)
				break
			prev_R = R
			sleep(1)

		var/turf/prev_L = T
		for (var/turf/L in left)
			if(prev_L)
				var/atom/movable/temp = new/obj/flamer_fire()
				var/atom/movable/AM = LinkBlocked(temp, prev_L, L)
				qdel(temp)
				if(AM)
					AM.flamer_fire_act(burn_dam, F.weapon_cause_data)
					if (AM.flags_atom & ON_BORDER)
						break
					hit_dense_atom_side = TRUE
				else if (hit_dense_atom_mid)
					break
			generate_fire(L, F, 0, FLAMESHAPE_TRIANGLE, FALSE, FALSE, fuel_pressure)
			if (!hit_dense_atom_mid && hit_dense_atom_side)
				break
			prev_L = L
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
