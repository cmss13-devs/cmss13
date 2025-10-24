/obj/effect/decal/cleanable/liquid_fuel
	//Liquid fuel is used for things that used to rely on volatile fuels or phoron being contained to a couple tiles.
	icon = 'icons/effects/effects.dmi'
	icon_state = "fuel"
	layer = ABOVE_TURF_LAYER
	anchored = TRUE
	cleanable_type = CLEANABLE_IGNITABLE
	var/amount = 1 //Basically moles.

/obj/effect/decal/cleanable/liquid_fuel/Initialize(mapload, amt = 1)
	amount = amt

	//Be absorbed by any other liquid fuel in the tile.
	for(var/obj/effect/decal/cleanable/liquid_fuel/other in loc)
		if(other != src)
			other.amount += amount
			INVOKE_ASYNC(other, PROC_REF(spread))
			return INITIALIZE_HINT_QDEL

	spread()

	if(..() != INITIALIZE_HINT_QDEL)
		return INITIALIZE_HINT_LATELOAD

/obj/effect/decal/cleanable/liquid_fuel/LateInitialize()
	// Ignition because fire already exists
	if(locate(/obj/flamer_fire) in cleanable_turf)
		INVOKE_NEXT_TICK(src, PROC_REF(ignite))

/obj/effect/decal/cleanable/liquid_fuel/proc/spread()
	//Allows liquid fuels to sometimes flow into other tiles.
	var/turf/my_turf = loc
	if(!istype(my_turf))
		return

	for(var/direction in GLOB.cardinals)
		if(amount < 5.0)
			return
		if(prob(50))
			var/turf/target = get_step(my_turf, direction)
			var/obj/effect/decal/cleanable/liquid_fuel/adjacent_fuel = LAZYACCESS(target?.cleanables, CLEANABLE_IGNITABLE)
			if(adjacent_fuel && istype(adjacent_fuel))
				continue
			if(locate(/obj/effect/decal/cleanable/liquid_fuel) in target)
				continue
			if(LinkBlocked(src, my_turf, target))
				continue
			new /obj/effect/decal/cleanable/liquid_fuel(target, amount * 0.25)
			amount *= 0.75

/obj/effect/decal/cleanable/liquid_fuel/proc/ignite()
	if(QDELETED(src))
		return

	var/turf/my_turf = cleanable_turf
	qdel(src)
	if(!my_turf)
		return

	for(var/direction in GLOB.cardinals)
		var/turf/target = get_step(my_turf, direction)
		if(locate(/obj/flamer_fire) in target)
			continue
		var/obj/effect/decal/cleanable/liquid_fuel/adjacent_fuel = LAZYACCESS(target?.cleanables, CLEANABLE_IGNITABLE)
		if(QDELETED(adjacent_fuel) || !istype(adjacent_fuel))
			continue
		new /obj/flamer_fire(target) // This will invoke an ignite

/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel
	icon_state = "mustard"
	anchored = FALSE

/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel/spread()
	//The spread for flamethrower fuel is much more precise, to create a wide fire pattern.
	if(amount < 0.1)
		return
	var/turf/my_turf = loc
	if(!istype(my_turf))
		return

	for(var/direction in list(turn(dir,90), turn(dir,-90), dir))
		var/turf/current_turf = get_step(my_turf, direction)
		if(locate(/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel) in current_turf)
			continue
		if(current_turf.BlockedPassDirs(src, direction) || my_turf.BlockedExitDirs(src, direction))
			continue
		new /obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel(current_turf, amount * 0.25)

	amount *= 0.25
