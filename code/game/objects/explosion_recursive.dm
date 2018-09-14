/*

===========
D.O.R.E.C
===========

--------------
Damage-based
Ordinal
Recursive
Explosion
Code
--------------


NOTE: This explosion system has two main variables: Power and Falloff. Power is the amount of damage done at the center of the explosion,
and falloff is the amount by which power is decreased with each tile

For example, a 200 power, 50 falloff explosion will do 200 damage to an unarmored mob at the center, and 150 damage to an adjacent
mob, and will peter out after 4 tiles

Compared to the old explosion code, ex_act(3) should be equivalent to 0-100 power on a tile, ex_act(2) should be equivalent to 100-200,
and ex_act(1) should be equivalent to 200+

For explosion resistance, an explosion should never go through a wall or window it cannot destroy. Walls, windows and airlocks should give an
explosion resistance exactly as much as their health
*/

/client/proc/drop_custom_bomb()
	set category = "Fun"
	set name = "Drop Custom Bomb"

	if(alert("Are you sure? This drops a recursive explosion with a given power and falloff. The power of the explosion is the strength at the center, and the falloff is the amount by which the strength decreases with each tile of distance.\n200 power and above will gib.",, "Yes", "No") == "No") return
	var/power = input(src, "Power?", "Power?") as num
	var/falloff = input(src, "Falloff?", "Falloff?") as num
	var/turf/T = get_turf(src.mob)
	explosion_rec(T, power, falloff)

proc/explosion_rec(turf/epicenter, power, falloff = 20)
	var/obj/effect/explosion/Controller = new /obj/effect/explosion(epicenter)
	Controller.initiate_explosion(epicenter, power, falloff)


/obj/effect/explosion
	var/list/explosion_turfs = list()
	var/list/explosion_turf_directions = list()
	var/explosion_in_progress = 0
	var/active_spread_num = 0
	//var/overlap_number = 0


/obj/effect/explosion/ex_act()
		return


//the start of the explosion
/obj/effect/explosion/proc/initiate_explosion(turf/epicenter, power, falloff = 20)

	if(power <= 1) return
	epicenter = get_turf(epicenter)
	if(!epicenter) return

	falloff = max(falloff, power/100) //prevent explosions with a range larger than 100 tiles

	message_admins("Explosion with Power: [power], Falloff: [falloff] in area [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z])")
	log_game("Explosion with Power: [power], Falloff: [falloff] in area [epicenter.loc.name] ")

	playsound(epicenter, 'sound/effects/explosionfar.ogg', 75, 1, max(round(2*power,1),14) ) //haven't rweaked these values yet
	playsound(epicenter, "explosion", 75, 1, max(round(power,1),7) )

	explosion_in_progress = 1
	explosion_turfs = list()
	explosion_turf_directions = list()
	active_spread_num = 0

	//overlap_number = 0


	explosion_turfs[epicenter] = power //recording the power applied
	explosion_turf_directions[epicenter] = 0

	var/effective_falloff = falloff
	var/area/Ar = get_area(epicenter)
	if(!Ar.ceiling) //open ceiling -> faster falloff
		effective_falloff *= 1.5

	//spread to adjacent tiles
	for(var/direction in alldirs)

		var/spread_power = power

		switch(direction)
			if(NORTH,SOUTH,EAST,WEST)
				spread_power -= effective_falloff
			else
				spread_power -= effective_falloff * 1.414 //diagonal spreading

		if (spread_power <= 1)
			continue

		var/turf/T = get_step(epicenter, direction)

		if(!T) //prevents trying to spread into "null" (edge of the map?)
			continue

		var/resistance = 0
		for(var/atom/A in T)  //add resistance
			resistance += max(0, A.get_explosion_resistance(direction) )
		resistance += max(0, T.get_explosion_resistance(direction) )

		explosion_turfs[T] = spread_power  //recording the power applied
		explosion_turf_directions[T] = direction


		active_spread_num++
		spawn(0) //spawn(0) is important because it paces the explosion in an expanding circle, rather than a series of squiggly lines constantly checking overlap. Reduces lag by a lot
			T.explosion_spread(src, epicenter, spread_power - resistance, direction, falloff)

	spawn(2) //just in case something goes wrong
		if(explosion_in_progress)
			explosion_damage()
			spawn(20)
				cdel(src)



//direction is the direction that the spread took to come to this tile. So it is pointing in the main blast direction - meaning where this tile should spread most of it's force.
/turf/proc/explosion_spread(var/obj/effect/explosion/Controller, var/turf/epicenter, power, direction, falloff)

	/*
	sleep(2)
	new/obj/effect/debugging/marker(src)
	*/

	var/effective_falloff = falloff
	var/area/Ar = get_area(src)
	if(!Ar.ceiling) //open ceiling -> faster falloff
		effective_falloff *= 1.5

	/*
	var/spread_power = power //This is the amount of power that will be spread to the tile in the direction of the blast
	if(spread_power <= 0)
		return
	*/

	//var/distance_from_epicenter = cheap_hypotenuse(src.x, src.y, epicenter.x, epicenter.y)

	/*
	var/45_degrees = turn(direction,45)
	var/45_degrees1 = turn(direction,-45)
	var/90_degrees = turn(direction,90)
	var/90_degrees1 = turn(direction,180)
	var/135_degrees = turn(direction,180)
	var/135_degrees1 = turn(direction,180)=
	*/

	var/direction_angle = dir2angle(direction)


	for(var/spread_direction in alldirs)

		var/spread_power = power

		var/spread_direction_angle = dir2angle(spread_direction)

		var/angle = 180 - abs( abs( direction_angle - spread_direction_angle ) - 180 ) // the angle difference between the spread direction and initial direction

		switch(angle) //this reduces power when the explosion is going around corners
			if (0)
				//no change
			if (45)
				spread_power *= 0.67
			if (90)
				spread_power *= 0.33
			else //turns out angles greater than 90 degrees almost never happen. This bit also prevents trying to spread backwards
				continue

		switch(spread_direction)
			if(NORTH,SOUTH,EAST,WEST)
				spread_power -= effective_falloff
			else
				spread_power -= effective_falloff * 1.414 //diagonal spreading

		if (spread_power <= 1)
			continue

		/*
		if(spread_direction == turn(direction,180)) //do not spread backwards
			continue
		else if (spread_direction == direction)
			effective_spread_power -= effective_falloff * 2
			if (effective_spread_power <= 0)
				continue
		*/

		var/turf/T = get_step(src, spread_direction)

		if(!T) //prevents trying to spread into "null" (edge of the map?)
			continue

		if(Controller.explosion_turfs[T] * 1.1 >= spread_power) //This turf is already slated for more damage, so no point spreading here. 1.1 multiplier to reduce lag from borderline overlaps
			continue

		/*
		if(explosion_turfs[T])
			world << "overlap! [explosion_turfs[T]] < [spread_power]"
			overlap_number++
		*/

		//var/effective_spread_power = spread_power
		//if(cheap_hypotenuse(T.x, T.y, epicenter.x, epicenter.y) <= distance_from_epicenter) //spread more weakly towards epicenter
		//	effective_spread_power *= 0.5

		var/resistance = 0
		for(var/atom/A in T)  //add resistance
			resistance += max(0, A.get_explosion_resistance(spread_direction) )
		resistance += max(0, T.get_explosion_resistance(spread_direction) )

		Controller.explosion_turfs[T] = spread_power  //recording the power applied
		Controller.explosion_turf_directions[T] = spread_direction


		Controller.active_spread_num++
		spawn(0) //spawn(0) is important because it paces the explosion in an expanding circle, rather than a series of squiggly lines constantly checking overlap. Reduces lag by a lot
			T.explosion_spread(Controller, epicenter, spread_power - resistance, spread_direction, falloff) //spread further

	Controller.active_spread_num--
	if(Controller.active_spread_num <= 0)
		Controller.explosion_damage()



/obj/effect/explosion/proc/explosion_damage() //This step applies the ex_act effects for the explosion

	explosion_in_progress = 0

	var/num_tiles_affected = explosion_turfs.len
	var/powernet_rebuild_was_deferred_already = defer_powernet_rebuild

	if(num_tiles_affected > 25) //pause lighting and powernet processing until explosion damage is finished
		lighting_controller.processing = 0
		if(!defer_powernet_rebuild)
			defer_powernet_rebuild = 1

	for(var/turf/T in explosion_turfs)
		if(explosion_turfs[T] <= 0) continue
		if(!T) continue

		var/severity = explosion_turfs[T]
		var/direction = explosion_turf_directions[T]

		var/x = T.x
		var/y = T.y
		var/z = T.z
		T.ex_act(severity)
		if(!T)
			T = locate(x,y,z)
		for(var/atom/A in T)
			spawn(0)
				A.ex_act(severity, direction)

	spawn(8)  //resume lighting and powernet processing
		if(!lighting_controller.processing)
			lighting_controller.processing = 1
			lighting_controller.process() //Restart the lighting controller

		if(!powernet_rebuild_was_deferred_already && defer_powernet_rebuild)
			makepowernets()
			defer_powernet_rebuild = 0

		cdel(src)

	//message_admins("Overlaps: [overlap_number]")

	/*
	for(var/i in 1 to spread_turfs.len)
		var/list/Listy = spread_turfs[i]

		var/modifier
		if(Listy[3] <= 0)
			modifier = total_resistance/num_directions_without_resistance
		else
			modifier = Listy[3] * -1

		var/turf/T = Listy[1]
		var/effective_spread_power = Listy[2] + modifier
		explosion_turfs[T] = effective_spread_power
		T.explosion_spread(epicenter, effective_spread_power, Listy[4], falloff)
		world << "[epicenter], [effective_spread_power], [Listy[4]], [falloff]"
	*/


/atom/proc/get_explosion_resistance()
	return 0

/mob/living/get_explosion_resistance()
	switch(mob_size)
		if(MOB_SIZE_SMALL)
			return 0
		if(MOB_SIZE_HUMAN)
			return 20
		if(MOB_SIZE_XENO)
			return 20
		if(MOB_SIZE_BIG)
			return 40
	return 0

/obj/item/proc/explosion_throw(severity, direction)

	if(anchored)
		return

	if(!istype(src.loc, /turf))
		return

	if(!direction)
		direction = pick(alldirs)
	var/range = min( round(   severity/src.w_class * 0.1   ,1) ,14)
	if(!direction)
		range = round( range/2 ,1)

	if(range <= 0)
		return


	var/speed = round(   range/5  ,1)
	var/atom/target = get_ranged_target_turf(src, direction, range)

	if(range >= 3)
		if(prob(range*10)) //scatter
			var/scatter_x = rand(-1,1)
			var/scatter_y = rand(-1,1)
			target = locate(target.x + round(scatter_x),target.y + round(scatter_y),target.z) //Locate an adjacent turf.

	spawn(1) //time for the explosion to destroy windows, walls, etc which might be in the way
		throw_at(target, range, speed, , 1)

	return

/mob/proc/explosion_throw(severity, direction)

	if(anchored)
		return

	if(!istype(src.loc, /turf))
		return

	var/weight = 1
	switch(mob_size)
		if(MOB_SIZE_SMALL)
			weight = 0.25
		if(MOB_SIZE_HUMAN)
			weight = 1
		if(MOB_SIZE_XENO)
			weight = 1
		if(MOB_SIZE_BIG)
			weight = 4
	var/range = min( round( severity/weight * 0.02 ,1) ,14)
	if(!direction)
		range = round( range/2 ,1)

	if(range <= 0)
		return

	var/speed = round(   range/5  ,1)
	var/atom/target = get_ranged_target_turf(src, direction, range)

	var/spin = 0

	if(range > 1)
		spin = 1

	spawn(1) //time for the explosion to destroy windows, walls, etc which might be in the way
		if(!buckled)
			throw_at(target, range, speed, , spin)

	return