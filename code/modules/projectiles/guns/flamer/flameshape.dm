#define FIRE_CANPASS_SPREAD 1 // can spead further
#define FIRE_CANPASS_SET_AFLAME 2 // found dense atom
#define FIRE_CANPASS_STOP_BORDER 3 // found dense atom on border
#define FIRE_CANPASS_STOP 4 // found space

#define SET_AFLAME_LIST_SOFT_CAP 30 // prevent creating too big to be set aflame lists


// Same as LinkBlocked, but for fire as mover
/proc/FireLinkBlocked(turf/prev_T, turf/T)
	var/static/obj/flamer_fire/eternal
	if(QDELETED(eternal)) // initialization or in case someone was able to extinguish it in nullspace
		eternal = new()
		STOP_PROCESSING(SSobj, eternal) // prevent self deliting because of nullspace

	return LinkBlocked(eternal, prev_T, T)


/proc/_fire_spread_check(obj/flamer_fire/F, turf/prev_T, turf/T, burn_dam)
	if(istype(T, /turf/open/space))
		return FIRE_CANPASS_STOP

	if(T.density)
		T.flamer_fire_act(burn_dam, F.weapon_cause_data)
		return FIRE_CANPASS_SET_AFLAME

	var/atom/A = FireLinkBlocked(prev_T, T)

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
	for(var/turf/T as anything in turfs)
		_generate_fire(T, F2, skip_flame, fuel_pressure)

/datum/flameshape/default
	name = "Default"
	id = FLAMESHAPE_DEFAULT

/datum/flameshape/default/handle_fire_spread(obj/flamer_fire/F, fire_spread_amount, burn_dam, fuel_pressure = 1)
	var/turf/source_turf = get_turf(F.loc)

	var/list/tiles_to_spread = list(source_turf) // tiles to spread from on this iteration
	var/list/tiles_to_set_aflame = list()
	var/list/checked_tiles = list(source_turf)

	for(var/spread_amount in 1 to fire_spread_amount)
		var/list/next_tiles_to_spread = list() // tiles to spread from on next iteration

		for(var/turf/prev_T as anything in tiles_to_spread)
			for(var/dirn in GLOB.cardinals)
				var/turf/T = get_step(prev_T, dirn)

				if(checked_tiles[T])
					continue

				var/result = _fire_spread_check(F, prev_T, T, burn_dam)
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

		if(tiles_to_set_aflame.len >= SET_AFLAME_LIST_SOFT_CAP)
			addtimer(CALLBACK(src, PROC_REF(generate_fire_list), tiles_to_set_aflame, F, FALSE, fuel_pressure), 0)
			tiles_to_set_aflame = list()

		if(next_tiles_to_spread.len == 0)
			break

		tiles_to_spread = next_tiles_to_spread

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

	for(var/dirn in dirs)
		var/endturf = get_ranged_target_turf(F, dirn, fire_spread_amount)
		var/list/turfs = get_line(source_turf, endturf, FALSE) // first tile already set on fire

		var/turf/prev_T = source_turf
		for(var/turf/T as anything in turfs)
			var/result = _fire_spread_check(F, prev_T, T, burn_dam)
			switch(result)
				if(FIRE_CANPASS_STOP, FIRE_CANPASS_STOP_BORDER)
					break

			tiles_to_set_aflame.Add(T)
			prev_T = T

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
	var/list/turfs = get_line(source_turf, F.target_clicked)

	if(fire_spread_amount > turfs.len)
		fire_spread_amount = turfs.len

	var/distance = 1
	for(distance in 2 to fire_spread_amount) // first tile already set on fire
		var/turf/T = turfs[distance]
		sleep(1) // sleep to properly check next tile spread
		var/result = _fire_spread_check(F, prev_T, T, burn_dam)
		switch(result)
			if(FIRE_CANPASS_SPREAD)
				generate_fire(T, F, TRUE, fuel_pressure)
			if(FIRE_CANPASS_SET_AFLAME)
				generate_fire(T, F, TRUE, fuel_pressure)
				break
			if(FIRE_CANPASS_STOP, FIRE_CANPASS_STOP_BORDER)
				break

		prev_T = T

	if(F.to_call)
		addtimer(F.to_call, distance)

/datum/flameshape/triangle
	name = "Triangle"
	id = FLAMESHAPE_TRIANGLE

/datum/flameshape/triangle/handle_fire_spread(obj/flamer_fire/F, fire_spread_amount, burn_dam, fuel_pressure = 1)
	set waitfor = 0

	var/turf/source_turf = get_turf(F.loc)

	var/unleash_dir = get_cardinal_dir(source_turf, F.target_clicked)
	var/list/turf/turfs = get_line(source_turf, F.target_clicked)
	var/turf/prev_T = source_turf

	if(fire_spread_amount > turfs.len)
		fire_spread_amount = turfs.len

	for(var/distance in 1 to fire_spread_amount)
		var/turf/T = turfs[distance]
		var/list/tiles_to_set_aflame = list()

		var/result = FIRE_CANPASS_SPREAD
		if(prev_T != T) // first tile already set on fire
			sleep(1)
			result = _fire_spread_check(F, prev_T, T, burn_dam)
			switch(result)
				if(FIRE_CANPASS_SPREAD, FIRE_CANPASS_SET_AFLAME) // FIRE_CANPASS_SET_AFLAME will stop spread after handling sides
					generate_fire(T, F, TRUE, fuel_pressure)
				if(FIRE_CANPASS_STOP, FIRE_CANPASS_STOP_BORDER)
					break

		prev_T = T
		for(var/side_turn in list(90, -90))
			var/turf/side_prev_T = T
			var/side_dir = turn(unleash_dir, side_turn)
			var/side_T = get_step(side_prev_T, side_dir)

			sleep(1)
			var/side_result = _fire_spread_check(F, side_prev_T, side_T, burn_dam)
			switch(side_result)
				if(FIRE_CANPASS_SPREAD, FIRE_CANPASS_SET_AFLAME)
					generate_fire(T, F, TRUE, fuel_pressure)

		if(result == FIRE_CANPASS_SET_AFLAME)
			break

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

#undef SET_AFLAME_LIST_SOFT_CAP
