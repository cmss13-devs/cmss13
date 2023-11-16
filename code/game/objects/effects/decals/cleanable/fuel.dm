/obj/effect/decal/cleanable/liquid_fuel
	//Liquid fuel is used for things that used to rely on volatile fuels or phoron being contained to a couple tiles.
	icon = 'icons/effects/effects.dmi'
	icon_state = "fuel"
	layer = ABOVE_TURF_LAYER
	anchored = TRUE
	var/amount = 1 //Basically moles.

/obj/effect/decal/cleanable/liquid_fuel/Initialize(mapload, amt = 1)
	amount = amt

	//Be absorbed by any other liquid fuel in the tile.
	for(var/obj/effect/decal/cleanable/liquid_fuel/other in loc)
		if(other != src)
			other.amount += src.amount
			spawn other.Spread()
			return INITIALIZE_HINT_QDEL

	Spread()
	return ..()

/obj/effect/decal/cleanable/liquid_fuel/proc/Spread()
	//Allows liquid fuels to sometimes flow into other tiles.
	if(amount < 5.0) return
	var/turf/S = loc
	if(!istype(S)) return
	for(var/d in GLOB.cardinals)
		if(rand(25))
			var/turf/target = get_step(src, d)
			var/turf/origin = get_turf(src)
			if(locate(/obj/effect/decal/cleanable/liquid_fuel) in target)
				continue
			if(LinkBlocked(src, origin, target))
				continue
			new/obj/effect/decal/cleanable/liquid_fuel(target, amount * 0.25)
			amount *= 0.75

/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel
	icon_state = "mustard"
	anchored = FALSE

/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel/New(newLoc, amt = 1)
	. = ..()

/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel/Spread()
	//The spread for flamethrower fuel is much more precise, to create a wide fire pattern.
	if(amount < 0.1) return
	var/turf/S = loc
	if(!istype(S)) return

	for(var/d in list(turn(dir,90),turn(dir,-90), dir))
		var/turf/O = get_step(S,d)
		if(locate(/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel) in O)
			continue
		if(O.BlockedPassDirs(src, d) || S.BlockedExitDirs(src, d))
			continue
		new/obj/effect/decal/cleanable/liquid_fuel/flamethrower_fuel(O, amount * 0.25)

	amount *= 0.25
