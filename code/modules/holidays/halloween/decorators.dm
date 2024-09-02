/datum/game_decorator/halloween

/datum/game_decorator/halloween/is_active_decor()
	return (get_days_remaining() != -1)

/// Get the number of days remaining to event, or -1 if not applicable
/datum/game_decorator/halloween/proc/get_days_remaining()
	. = -1
	var/cur_day = text2num(time2text(world.timeofday, "DD"))
	var/cur_mon = text2num(time2text(world.timeofday, "MM"))
	if(cur_mon == 10)
		return max(0, 31 - cur_day)
	if(cur_mon == 11 && cur_day < 4)
		return 0

/// Pumpkins decorator: adds patches of carvable/wearable pumpkins around the ground level
/datum/game_decorator/halloween/pumpkins
	var/pumpkin_count = 60 //! Amount of pumpkins to place
	var/pumpkin_count_decrease = 1 //! Amount of pumpkins to remove per day to halloween
	var/pumpkin_prob_corruption = 20
	var/pumpkin_prob_decrease = 0.5 //! Chance reduction per day before halloween
	var/exclusion_range = 10

/datum/game_decorator/halloween/pumpkins/decorate()
	var/list/turf/valid_turfs = list()
	var/list/ground_levels = SSmapping.levels_by_trait(ZTRAIT_GROUND)
	for(var/ground_z in ground_levels)
		for(var/turf/open/turf in Z_TURFS(ground_z))
			if(turf.is_groundmap_turf)
				var/valid = TRUE
				for(var/atom/movable/movable as anything in turf.contents)
					if(movable.density && movable.can_block_movement)
						valid = FALSE
						break
				if(valid)
					valid_turfs += turf
				CHECK_TICK

	var/list/turf/picked_turfs = list()
	for(var/step in 1 to (pumpkin_count - pumpkin_count_decrease * get_days_remaining()))
		if(!length(valid_turfs))
			break
		var/turf/considered_turf = pick(valid_turfs)
		var/list/turf/denied_turfs = RANGE_TURFS(exclusion_range, considered_turf)
		valid_turfs -= denied_turfs
		picked_turfs += considered_turf

	var/corruption_chance = pumpkin_prob_corruption - (get_days_remaining() * pumpkin_prob_decrease)
	for(var/turf/target in picked_turfs)
		if(prob(corruption_chance))
			new /obj/structure/pumpkin_patch/corrupted(target)
		else
			new /obj/structure/pumpkin_patch(target)

/// Cobweb decorator: adds more and more cobwebs as you go through the month
/datum/game_decorator/halloween/cobwebs
	/// How much prob() chance to put a cobweb during halloween proper
	var/base_chance = 25
	/// How much to remove per day before date
	var/ramp_chance = 0.5
	/// How much to scale cobwebs alpha down per day (1 - ramp_scale * days, affects alpha & size)
	var/ramp_scale = 0.01
	/// Extra randomness removed onto scale before full blown halloween
	var/scale_rand = 0.3

/datum/game_decorator/halloween/cobwebs/decorate()
	for(var/turf/closed/wall/almayer/turf in world)
		if(is_mainship_level(turf.z))
			decorate_turf(turf)
			CHECK_TICK

/datum/game_decorator/halloween/cobwebs/proc/decorate_turf(turf/closed/wall/almayer/turf)
	var/static/list/order = list(NORTHWEST, SOUTHEAST, NORTHEAST, SOUTHWEST) // Ordering of wall_connections
	if(length(turf.wall_connections) < 4)
		return

	var/event_progress = get_days_remaining()
	var/placement_chance = base_chance - (event_progress * ramp_chance)
	for(var/i = 1 to 4)
		var/diag = order[i]
		if(turf.wall_connections[i] != "5") // CORNER_CLOCKWISE | CORNER_COUNTERCLOCKWISE as string - don't ask me
			continue
		if(!prob(placement_chance))
			continue

		// Skip this if this corner is result of a door connection (mostly for Almayer shutters)
		var/valid = TRUE
		for(var/a_cardinal in GLOB.cardinals)
			var/cardinal_dir = diag & a_cardinal
			if(!a_cardinal) // We check cardinals contributing to that diagonal
				continue
			var/turf/target = get_step(turf, cardinal_dir)
			if(locate(/obj/structure/machinery/door) in target)
				valid = FALSE
				break

		if(valid) // Actually place cobweb
			var/turf/target = get_step(turf, diag)
			if(istype(target, /turf/open))
				var/scale = 1 - ramp_scale * event_progress
				scale -= scale_rand * rand()
				new /obj/effect/decal/cleanable/cobweb2/dynamic(target, diag, scale)

