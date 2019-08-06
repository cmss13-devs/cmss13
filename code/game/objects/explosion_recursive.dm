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
	var/power = 0
	var/reflected_power = 0 //used to amplify explosions in confined areas
	var/reflection_multiplier = 1.5
	var/reflection_amplification_limit = 1 //1 = 100% increase
	var/minimum_spread_power = 0
	//var/overlap_number = 0


/obj/effect/explosion/ex_act()
		return


//the start of the explosion
/obj/effect/explosion/proc/initiate_explosion(turf/epicenter, power0, falloff = 20)

	if(power0 <= 1) return
	power = power0
	epicenter = get_turf(epicenter)
	if(!epicenter) return

	falloff = max(falloff, power/100) //prevent explosions with a range larger than 100 tiles
	minimum_spread_power = -power * reflection_amplification_limit

	msg_admin_attack("Explosion with Power: [power], Falloff: [falloff] in area [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z]) (<A HREF='?_src_=admin_holder;adminplayerobservecoodjump=1;X=[src.loc.x];Y=[src.loc.y];Z=[src.loc.z]'>JMP</a>)")

	playsound(epicenter, 'sound/effects/explosionfar.ogg', 100, 1, round(power^2,1), 1000)
	playsound(epicenter, "explosion", 75, 1, max(round(power,1),7) )

	explosion_in_progress = 1
	explosion_turfs = list()
	explosion_turf_directions = list()
	active_spread_num = 0

	explosion_turfs[epicenter] = power //recording the power applied
	explosion_turf_directions[epicenter] = 0

	var/effective_falloff = falloff
	/*
	var/area/Ar = get_area(epicenter)
	if(!Ar.ceiling) //open ceiling -> faster falloff
		effective_falloff *= 1.5
	*/

	//spread to adjacent tiles
	for(var/direction in alldirs)

		var/spread_power = power

		switch(direction)
			if(NORTH,SOUTH,EAST,WEST)
				spread_power -= effective_falloff
			else
				spread_power -= effective_falloff * 1.414 //diagonal spreading

		if (spread_power <= minimum_spread_power)
			continue

		var/turf/T = get_step(epicenter, direction)

		if(!T) //prevents trying to spread into "null" (edge of the map?)
			continue

		var/resistance = 0
		for(var/atom/A in T)  //add resistance
			resistance += max(0, A.get_explosion_resistance(direction) )
		resistance += max(0, T.get_explosion_resistance(direction) )
		reflected_power += max(0, min(resistance, spread_power))

		explosion_turfs[T] = spread_power  //recording the power applied
		explosion_turf_directions[T] = direction


		active_spread_num++
		spawn(0) //spawn(0) is important because it paces the explosion in an expanding circle, rather than a series of squiggly lines constantly checking overlap. Reduces lag by a lot
			T.explosion_spread(src, epicenter, spread_power - resistance, direction, falloff)

	if(power >= 100) // powerful explosions send out some special effects
		epicenter = get_turf(epicenter) // the ex_acts might have changed the epicenter
		create_shrapnel(epicenter, rand(5,9), , ,/datum/ammo/bullet/shrapnel/light/effect/ver1)
		sleep(1)
		create_shrapnel(epicenter, rand(5,9), , ,/datum/ammo/bullet/shrapnel/light/effect/ver2)

	spawn(2) //just in case something goes wrong
		if(explosion_in_progress)
			explosion_damage()
			spawn(20)
				qdel(src)



//direction is the direction that the spread took to come to this tile. So it is pointing in the main blast direction - meaning where this tile should spread most of it's force.
/turf/proc/explosion_spread(var/obj/effect/explosion/Controller, var/turf/epicenter, power, direction, falloff)

	var/effective_falloff = falloff
	/*
	var/area/Ar = get_area(src)
	if(!Ar.ceiling) //open ceiling -> faster falloff
		effective_falloff *= 1.5
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
				if(spread_power >= 0)
					spread_power *= 0.75
				else
					spread_power *= 1.25
			if (90)
				if(spread_power >= 0)
					spread_power *= 0.50
				else
					spread_power *= 1.5
			else //turns out angles greater than 90 degrees almost never happen. This bit also prevents trying to spread backwards
				continue

		switch(spread_direction)
			if(NORTH,SOUTH,EAST,WEST)
				spread_power -= effective_falloff
			else
				spread_power -= effective_falloff * 1.414 //diagonal spreading

		if (spread_power <= Controller.minimum_spread_power)
			continue

		var/turf/T = get_step(src, spread_direction)

		if(!T) //prevents trying to spread into "null" (edge of the map?)
			continue

		if(Controller.explosion_turfs[T] && Controller.explosion_turfs[T] + 1 >= spread_power) //This turf is already slated for more damage, so no point spreading here. +1 to reduce lag from borderline overlaps
			continue

		var/resistance = 0
		for(var/atom/A in T)  //add resistance
			resistance += max(0, A.get_explosion_resistance(spread_direction) )
		resistance += max(0, T.get_explosion_resistance(spread_direction) )
		Controller.reflected_power += max(0, min(resistance, spread_power))

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

	var/num_tiles_affected = 0

	for(var/turf/T in explosion_turfs)
		if(!T) continue
		if(explosion_turfs[T] >= 0)
			num_tiles_affected++

	if(num_tiles_affected > 25) //pause lighting and powernet processing until explosion damage is finished
		lighting_controller.processing = 0

	reflected_power *= reflection_multiplier

	var/damage_addon = min(power * reflection_amplification_limit, reflected_power/num_tiles_affected)

	var/tiles_processed = 0
	var/increment = min(50, sqrt(num_tiles_affected)*3 )//how many tiles we damage per tick

	for(var/turf/T in explosion_turfs)
		if(!T) continue

		var/severity = explosion_turfs[T] + damage_addon
		if (severity <= 0)
			continue
		var/direction = explosion_turf_directions[T]

		var/x = T.x
		var/y = T.y
		var/z = T.z
		T.ex_act(severity, direction)
		if(!T)
			T = locate(x,y,z)
		for(var/atom/A in T)
			spawn(0)
				if(ismob(A))
					var/mob/M = A
					log_attack("Mob [M.name] ([M.ckey]) harmed by explosion in [T.loc.name] at ([M.loc.x],[M.loc.y],[M.loc.z])")
				A.ex_act(severity, direction)

		tiles_processed++
		if(tiles_processed >= increment)
			tiles_processed = 0
			sleep(1)

	spawn(8)  //resume lighting and powernet processing
		if(!lighting_controller.processing)
			lighting_controller.processing = 1
			lighting_controller.process() //Restart the lighting controller

		qdel(src)


/atom/proc/get_explosion_resistance()
	return 0

/mob/living/get_explosion_resistance()
	if(density)
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

/obj/item/proc/explosion_throw(severity, direction, var/scatter_multiplier = 1)

	if(anchored)
		return

	if(!istype(src.loc, /turf))
		return

	if(!direction)
		direction = pick(alldirs)
	var/range = min( round(   severity/src.w_class * 0.2   ,1) ,14)
	if(!direction)
		range = round( range/2 ,1)

	if(range < 1)
		return


	var/speed = min( round(   range/5  ,1) ,5)
	var/atom/target = get_ranged_target_turf(src, direction, range)

	if(range >= 2)
		var/scatter = range/4 * scatter_multiplier
		var/scatter_x = rand(-scatter,scatter)
		var/scatter_y = rand(-scatter,scatter)
		target = locate(target.x + round( scatter_x , 1),target.y + round( scatter_y , 1),target.z) //Locate an adjacent turf.

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
	var/range = round( severity/weight * 0.02 ,1)
	if(!direction)
		range = round( 2*range/3 ,1)
		direction = pick(NORTH,SOUTH,EAST,WEST,NORTHEAST,NORTHWEST,SOUTHEAST,SOUTHWEST)

	if(range <= 0)
		return

	var/speed = min( round(   range/5  ,1) ,5)
	var/atom/target = get_ranged_target_turf(src, direction, range)

	var/spin = 0

	if(range > 1)
		spin = 1

	if(range >= 2)
		var/scatter = range/4
		var/scatter_x = rand(-scatter,scatter)
		var/scatter_y = rand(-scatter,scatter)
		target = locate(target.x + round( scatter_x , 1),target.y + round( scatter_y , 1),target.z) //Locate an adjacent turf.

	spawn(1) //time for the explosion to destroy windows, walls, etc which might be in the way
		if(!buckled)
			throw_at(target, range, speed, , spin)

	return