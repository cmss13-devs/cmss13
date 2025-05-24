#define FIRE_CANPASS_SPREAD 1
#define FIRE_CANPASS_SET_AFLAME 2
#define FIRE_CANPASS_STOP_BORDER 3
#define FIRE_CANPASS_STOP 4


/proc/_fire_spread_check(obj/flamer_fire/F, obj/flamer_fire/mover, turf/prev_T, turf/T, burn_dam)
	if(istype(T, /turf/open/space))
		return FIRE_CANPASS_STOP

	if(T.density)
		T.flamer_fire_act(burn_dam, F.weapon_cause_data)
		return FIRE_CANPASS_SET_AFLAME

	var/atom/A = LinkBlocked(mover, prev_T, T)

	if(A)
		A.flamer_fire_act(burn_dam, F.weapon_cause_data)
		if (A.flags_atom & ON_BORDER)
			return FIRE_CANPASS_STOP_BORDER
		return FIRE_CANPASS_SET_AFLAME

	return FIRE_CANPASS_SPREAD

/proc/_generate_fire(turf/T, obj/flamer_fire/F2, skip_flame = FALSE, fuel_pressure = 1)
	var/obj/flamer_fire/foundflame = locate() in T
	if(foundflame && foundflame.tied_reagents == F2.tied_reagents && !skip_flame) // From the same flames
		return

	if(foundflame)
		qdel(foundflame)

	new /obj/flamer_fire(T, F2.weapon_cause_data, F2.tied_reagent, 0, F2.tied_reagents, FLAMESHAPE_DEFAULT, F2.target_clicked, null, fuel_pressure, F2.fire_variant)
	return TRUE

/datum/flameshape
	var/name = ""
	var/id = FLAMESHAPE_NONE

/datum/flameshape/proc/handle_fire_spread(obj/flamer_fire/F, fire_spread_amount, burn_dam, fuel_pressure = 1)
	return

/datum/flameshape/proc/generate_fire(turf/T, obj/flamer_fire/F2, skip_flame = FALSE, fuel_pressure = 1)
	return _generate_fire(T, F2, skip_flame, fuel_pressure)

/datum/flameshape/proc/generate_fire_list(list/turf/turfs, obj/flamer_fire/F2, skip_flame = FALSE, fuel_pressure = 1)
	for(var/turf/T in turfs)
		_generate_fire(T, F2, skip_flame, fuel_pressure)

/datum/flameshape/default
	name = "Default"
	id = FLAMESHAPE_DEFAULT

/datum/flameshape/default/handle_fire_spread(obj/flamer_fire/F, fire_spread_amount, burn_dam, fuel_pressure = 1)
	var/turf/source_turf = get_turf(F.loc)

	var/list/tiles_to_spread = list(source_turf)
	var/list/tiles_to_set_aflame = list()
	var/list/checked_tiles = list(source_turf)
	var/obj/flamer_fire/temp = new()

	for(var/spread_amount in 1 to fire_spread_amount)
		var/list/next_tiles_to_spread = list()

		if(tiles_to_spread.len == 0)
			break

		for(var/turf/prev_T in tiles_to_spread)
			for(var/dirn in GLOB.cardinals)
				var/turf/T = get_step(prev_T, dirn)

				if(checked_tiles[T])
					continue

				var/result = _fire_spread_check(F, temp, prev_T, T, burn_dam)
				switch(result)
					if(FIRE_CANPASS_SPREAD)
						next_tiles_to_spread.Add(T)
						tiles_to_set_aflame.Add(T)
						checked_tiles[T] = TRUE
					if(FIRE_CANPASS_SET_AFLAME)
						tiles_to_set_aflame.Add(T)
						checked_tiles[T] = TRUE
					if(FIRE_CANPASS_STOP)
						checked_tiles[T] = TRUE

		tiles_to_spread = next_tiles_to_spread

	qdel(temp)
	addtimer(CALLBACK(src, PROC_REF(generate_fire_list), tiles_to_set_aflame, F, FALSE, fuel_pressure), 0)


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
	var/list/tiles_to_set_aflame = list()
	var/obj/flamer_fire/temp = new()

	for(var/dirn in dirs)
		var/endturf = get_ranged_target_turf(F, dirn, fire_spread_amount)
		var/list/turfs = get_line(source_turf, endturf, FALSE)

		var/turf/prev_T = source_turf
		for(var/turf/T in turfs)
			var/result = _fire_spread_check(F, temp, prev_T, T, burn_dam)
			if(result == FIRE_CANPASS_STOP)
				break

			tiles_to_set_aflame.Add(T)
			prev_T = T

	qdel(temp)
	addtimer(CALLBACK(src, PROC_REF(generate_fire_list), tiles_to_set_aflame, F, FALSE, fuel_pressure), 0)

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
	set waitfor = 0

	var/turf/source_turf = get_turf(F.loc)

	var/turf/prev_T = source_turf
	var/list/turfs = get_line(source_turf, F.target_clicked, FALSE)

	if(fire_spread_amount > turfs.len)
		fire_spread_amount = turfs.len

	for(var/distance in 1 to fire_spread_amount)
		var/obj/flamer_fire/temp = new()
		var/turf/T = turfs[distance]
		var/result = _fire_spread_check(F, temp, prev_T, T, burn_dam)
		switch(result)
			if(FIRE_CANPASS_SPREAD)
				addtimer(CALLBACK(src, PROC_REF(generate_fire), T, F, TRUE, fuel_pressure), 1)
			if(FIRE_CANPASS_SET_AFLAME)
				addtimer(CALLBACK(src, PROC_REF(generate_fire), T, F, TRUE, fuel_pressure), 1)
				break
			if(FIRE_CANPASS_STOP, FIRE_CANPASS_STOP_BORDER)
				break

		prev_T = T
		QDEL_NULL(temp)
		sleep(1) // sleep to properly check next tile spread

	if(F.to_call)
		addtimer(F.to_call, fire_spread_amount)

/datum/flameshape/triangle
	name = "Triangle"
	id = FLAMESHAPE_TRIANGLE

/datum/flameshape/triangle/handle_fire_spread(obj/flamer_fire/F, fire_spread_amount, burn_dam, fuel_pressure = 1)
	set waitfor = 0

	var/unleash_dir = get_cardinal_dir(F, F.target_clicked)
	var/list/turf/turfs = get_line(F, F.target_clicked, FALSE)
	var/distance = 1
	var/hit_dense_atom_mid = FALSE
	var/turf/prev_T = get_turf(F.loc)

	if(fire_spread_amount > turfs.len)
		fire_spread_amount = turfs.len

	for(var/distance in 1 to fire_spread_amount)
		var/obj/flamer_fire/temp = new()
		var/turf/T = turfs[distance]
		var/list/tiles_to_set_aflame = list()

		var/result = _fire_spread_check(F, temp, prev_T, T, burn_dam)
		switch(result)
			if(FIRE_CANPASS_SPREAD)
				tiles_to_set_aflame.Add(T)
			if(FIRE_CANPASS_SET_AFLAME)
				tiles_to_set_aflame.Add(T)
			if(FIRE_CANPASS_STOP, FIRE_CANPASS_STOP_BORDER)
				break

		prev_T = T

		for(var/side_turn in list(90, -90))
			var/turf/side_prev_T = T
			var/side_dir = turn(unleash_dir, side_turn)

			for(var/i in 1 to 1)
				var/side_T = get_step(side_prev_T, side_dir)
				var/side_result = _fire_spread_check(F, temp, side_prev_T, side_T, burn_dam)
				switch(side_result)
					if(FIRE_CANPASS_SPREAD)
						tiles_to_set_aflame.Add(side_T)
					if(FIRE_CANPASS_SET_AFLAME)
						tiles_to_set_aflame.Add(side_T)
						break
					if(FIRE_CANPASS_STOP, FIRE_CANPASS_STOP_BORDER)
						break

		addtimer(CALLBACK(src, PROC_REF(generate_fire_list), tiles_to_set_aflame, F, FALSE, fuel_pressure), 0)

		if(result == FIRE_CANPASS_SET_AFLAME)
			break

		QDEL_NULL(temp)
		sleep(3) // 1 from step forward, 1 for each step in each side

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


#undef FIRE_CANPASS_SPREAD
#undef FIRE_CANPASS_SET_AFLAME
#undef FIRE_CANPASS_STOP_BORDER
#undef FIRE_CANPASS_STOP
