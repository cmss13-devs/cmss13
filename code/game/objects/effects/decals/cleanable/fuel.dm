/obj/effect/decal/cleanable/liquid_fuel
	//Liquid fuel is used for things that used to rely on volatile fuels or phoron being contained to a couple tiles.
	name = "fuel residue"
	icon = 'icons/effects/effects.dmi'
	icon_state = "fuel"
	layer = ABOVE_WEED_LAYER
	anchored = TRUE
	cleanable_type = CLEANABLE_IGNITABLE
	overlay_on_initialize = FALSE
	/// The amount required to spread
	var/min_spread_amount = 7.5 // This means 30 can spread once
	/// The amount to decrease by every process (30s)
	var/evaporate_amount = 2.5
	/// The current amount of fuel
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
		if(evaporate_amount > 0)
			START_PROCESSING(SSslowobj, src)
		return INITIALIZE_HINT_LATELOAD

/obj/effect/decal/cleanable/liquid_fuel/LateInitialize()
	// Ignition because fire already exists
	if(locate(/obj/flamer_fire) in cleanable_turf)
		INVOKE_NEXT_TICK(src, PROC_REF(ignite))
		return
	for(var/obj/item/thing in cleanable_turf)
		if(thing.heat_source)
			INVOKE_NEXT_TICK(src, PROC_REF(ignite))
			return
	RegisterSignal(cleanable_turf, COMSIG_TURF_ENTERED, PROC_REF(on_turf_entered))

/obj/effect/decal/cleanable/liquid_fuel/Destroy()
	if(datum_flags & DF_ISPROCESSING)
		STOP_PROCESSING(SSslowobj, src)
	return ..()

/obj/effect/decal/cleanable/liquid_fuel/initialize_pass_flags(datum/pass_flags_container/pass_flags)
	if(pass_flags)
		pass_flags.flags_can_pass_all = PASS_AROUND|PASS_UNDER|PASS_MOB_THRU|PASS_THROUGH

/obj/effect/decal/cleanable/liquid_fuel/process()
	amount -= evaporate_amount
	if(amount < evaporate_amount)
		fade_and_disappear()

/obj/effect/decal/cleanable/liquid_fuel/proc/on_turf_entered(turf/source, atom/movable/enterer)
	if(!istype(enterer, /obj/item))
		return

	var/obj/item/entered_thing = enterer
	if(entered_thing.heat_source)
		INVOKE_NEXT_TICK(src, PROC_REF(ignite))
		UnregisterSignal(source, COMSIG_MOVABLE_MOVED)

/obj/effect/decal/cleanable/liquid_fuel/proc/spread()
	//Allows liquid fuels to sometimes flow into other tiles.
	var/turf/my_turf = loc
	if(!istype(my_turf))
		return

	for(var/direction in GLOB.cardinals)
		if(amount * 0.25 < min_spread_amount)
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
	if(amount <= 0)
		return

	// -10 to 0 based on ratio between amount and min_spread_amount
	// An amount >= min_spread_amount results in 0 pressure
	// An amount near zero results in almost -10 pressure (so near 0 duration assuming durationmod is 2 for BURN_TIME_TIER_2)
	var/pressure = clamp((amount / min_spread_amount - 1) * 10, -10, 0)

	if(!locate(/obj/flamer_fire) in my_turf)
		var/datum/reagent/napalm/weak/reagent = new
		new /obj/flamer_fire(my_turf, null, reagent, 0, null, FLAMESHAPE_DEFAULT, null, null, pressure)

	for(var/direction in GLOB.cardinals)
		var/turf/target = get_step(my_turf, direction)
		var/obj/effect/decal/cleanable/liquid_fuel/adjacent_fuel = LAZYACCESS(target?.cleanables, CLEANABLE_IGNITABLE)
		if(QDELETED(adjacent_fuel) || !istype(adjacent_fuel))
			continue
		if(locate(/obj/flamer_fire) in target)
			continue
		var/datum/reagent/napalm/weak/reagent = new
		new /obj/flamer_fire(target, null, reagent, 0, null, FLAMESHAPE_DEFAULT, null, null, pressure) // This will invoke an ignite

/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel
	icon_state = "mustard"
	anchored = FALSE

/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel/spread()
	//The spread for flamethrower fuel is much more precise, to create a wide fire pattern.
	var/turf/my_turf = loc
	if(!istype(my_turf))
		return

	for(var/direction in list(turn(dir,90), turn(dir,-90), dir))
		if(amount * 0.33 < min_spread_amount)
			return
		var/turf/current_turf = get_step(my_turf, direction)
		if(locate(/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel) in current_turf)
			continue
		if(current_turf.BlockedPassDirs(src, direction) || my_turf.BlockedExitDirs(src, direction))
			continue
		new /obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel(current_turf, amount * 0.33)
		amount *= 0.67
