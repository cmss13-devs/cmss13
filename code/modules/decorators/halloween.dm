/datum/decorator/halloween
	priority = DECORATOR_MONTH_SPECIFIC

/datum/decorator/halloween/is_active_decor()
	return (get_event_progress() != -1)

/datum/decorator/halloween/proc/get_event_progress()
	. = -1
	var/cur_day = text2num(time2text(world.timeofday, "DD"))
	var/cur_mon = text2num(time2text(world.timeofday, "MM"))
	if(cur_mon == 10)
		return min(0, 31 - cur_day)
	if(cur_mon == 11 && cur_day < 4)
		return 0

/// Cobweb decorator: adds more and more cobwebs as you go through the month
/datum/decorator/halloween/cobwebs
	/// How much prob() chance to put a cobweb during halloween proper
	var/base_chance = 25
	/// How much to remove per day before date
	var/ramp_chance = 0.3
	/// How much to scale cobwebs alpha down per day (1 - ramp_scale * days, affects alpha & size)
	var/ramp_scale = 0.01
	/// Extra randomness removed onto scale before full blown halloween
	var/scale_rand = 0.3

/datum/decorator/halloween/cobwebs/decorate(turf/closed/wall/almayer/T)
	var/static/list/order = list(NORTHWEST, SOUTHEAST, NORTHEAST, SOUTHWEST) // Ordering of wall_connections
	if(length(T.wall_connections) < 4)
		return

	var/event_progress = get_event_progress()
	var/placement_chance = base_chance - (event_progress * ramp_chance)
	for(var/i = 1 to 4)
		var/diag = order[i]
		if(T.wall_connections[i] != "5") // CORNER_CLOCKWISE | CORNER_COUNTERCLOCKWISE as string - don't ask me
			continue
		if(!prob(placement_chance))
			continue

		// Skip this if this corner is result of a door connection (mostly for Almayer shutters)
		var/valid = TRUE
		for(var/a_cardinal in cardinal)
			var/cardinal_dir = diag & a_cardinal
			if(!a_cardinal) // We check cardinals contributing to that diagonal
				continue
			var/turf/target = get_step(T, cardinal_dir)
			if(locate(/obj/structure/machinery/door) in target)
				valid = FALSE
				break

		if(valid) // Actually place cobweb
			var/turf/target = get_step(T, diag)
			if(istype(target, /turf/open))
				var/scale = 1 - ramp_scale * event_progress
				scale -= scale_rand * rand()
				new /obj/effect/decal/cleanable/cobweb2/dynamic(target, diag, scale)

/// Ship specific cobweb decorator
/datum/decorator/halloween/cobwebs/ship

/datum/decorator/halloween/cobwebs/ship/get_decor_types()
	return typesof(/turf/closed/wall/almayer)
