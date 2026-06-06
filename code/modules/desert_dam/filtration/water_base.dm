/obj/effect/blocker/water
	anchored = TRUE
	density = FALSE
	opacity = FALSE
	unacidable = TRUE

	icon = 'icons/turf/floors/desert_water.dmi'
	icon_state = "seadeep"

	alpha = 0
	layer = TURF_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

	var/flooded_alpha = 180
	var/dispersing = FALSE
	var/disperse_group = 1
	var/spread_delay = 0.5 SECONDS
	var/list/water_sounds = list('sound/effects/slosh.ogg')

/obj/effect/blocker/water/proc/drain_spread(from_dir = 0)
	if(!dispersing)
		return
	for(var/obj/effect/blocker/water/neighboring_water in orange(1, src)) // this won't check directions that don't even have water
		var/direction = get_dir(src, neighboring_water)
		if(direction == from_dir)
			continue // doesn't check backwards to avoid recursion
		if(neighboring_water.disperse_group != src.disperse_group)
			continue // only spread to our same group. do this before calculating delay

		var/effective_spread_delay = spread_delay
		if(direction & (direction - 1)) // diagonal direction
			effective_spread_delay *= sqrt(2) // this const-folds, there is no runtime cost to sqrt as opposed to a constant

		spawn(effective_spread_delay) // this could use a timer, but in 516.1676 and later i believe spawn is actually more performant
			neighboring_water.drain_spread(turn(direction,180), from_dir)
	drain()

/obj/effect/blocker/water/proc/disperse_spread(from_dir = 0)
	if(dispersing)
		return

	for(var/obj/effect/blocker/water/neighboring_water in orange(1, src)) // this won't check directions that don't even have water to begin with
		var/direction = get_dir(src, neighboring_water)
		if(direction == from_dir)
			continue // doesn't check backwards
		if(neighboring_water.disperse_group != src.disperse_group)
			continue // only spread to our same group. do this before calculating delay

		var/effective_spread_delay = spread_delay
		if(direction & (direction - 1)) // diagonal direction
			effective_spread_delay *= sqrt(2) // this const-folds, there is no runtime cost to sqrt as opposed to a constant

		spawn(effective_spread_delay) // this could use a timer, but in 516.1676 and later i believe spawn is actually more performant
			neighboring_water.disperse_spread(turn(direction,180))
	disperse(from_dir)

/obj/effect/blocker/water/proc/drain()
	dispersing = FALSE
	animate(src, alpha = initial(alpha), time = 6 SECONDS)
	var/turf/location = loc
	location.is_weedable = initial(location.is_weedable)

/obj/effect/blocker/water/proc/disperse(from_dir)
	dispersing = TRUE
	if(prob(30))
		var/sound = pick(water_sounds)
		playsound(loc, sound, 10, 1)
	for(var/obj/effect/alien/weeds/weeds_to_clean in loc)
		qdel(weeds_to_clean)

	for(var/obj/effect/alien/resin/resin in loc)
		qdel(resin)

	for(var/obj/flamer_fire/fire in loc)
		qdel(fire)

	for(var/obj/item/item in loc)
		if(item.anchored)
			continue
		if(prob(70))
			item.throw_atom((get_step(loc,turn(from_dir,180))),1)

	animate(src, alpha = flooded_alpha, easing = BACK_EASING | EASE_OUT, time = 4 SECONDS)
	update_icon()
	var/turf/location = loc
	location.is_weedable = NOT_WEEDABLE
