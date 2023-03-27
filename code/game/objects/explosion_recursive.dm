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

/proc/explosion_rec(turf/epicenter, power, falloff = 20, datum/cause_data/explosion_cause_data)
	var/obj/effect/explosion/Controller = new /obj/effect/explosion(epicenter)
	Controller.initiate_explosion(epicenter, power, falloff, explosion_cause_data)


/obj/effect/explosion
	var/list/explosion_turfs = list()
	var/list/explosion_turf_directions = list()
	var/explosion_in_progress = 0
	var/active_spread_num = 0
	var/power = 0
	var/falloff = 20
	/// used to amplify explosions in confined areas
	var/reflected_power = 0
	var/reflection_multiplier = 1.5
	/// 1 = 100% increase
	var/reflection_amplification_limit = 1
	var/minimum_spread_power = 0
	var/datum/cause_data/explosion_cause_data
	//var/overlap_number = 0


/obj/effect/explosion/ex_act()
		return


//the start of the explosion
/obj/effect/explosion/proc/initiate_explosion(turf/epicenter, power0, falloff0 = 20, datum/cause_data/new_explosion_cause_data)
	if(!istype(new_explosion_cause_data))
		if(new_explosion_cause_data)
			stack_trace("initiate_explosion called with string cause ([new_explosion_cause_data]) instead of datum")
			new_explosion_cause_data = create_cause_data(new_explosion_cause_data)
		else
			stack_trace("initiate_explosion called without cause_data.")
			new_explosion_cause_data = create_cause_data("Explosion")
	explosion_cause_data = new_explosion_cause_data

	if(power0 <= 1) return
	power = power0
	epicenter = get_turf(epicenter)
	if(!epicenter) return

	falloff = max(falloff0, power/100) //prevent explosions with a range larger than 100 tiles
	minimum_spread_power = -power * reflection_amplification_limit

	msg_admin_attack("Explosion with Power: [power], Falloff: [falloff] in area [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z]).", src.loc.x, src.loc.y, src.loc.z)

	playsound(epicenter, 'sound/effects/explosionfar.ogg', 100, 1, round(power^2,1))
	playsound(epicenter, "explosion", 90, 1, max(round(power,1),7) )

	explosion_in_progress = 1
	explosion_turfs = list()
	explosion_turf_directions = list()

	epicenter.explosion_spread(src, power, null)

	if(power >= 100) // powerful explosions send out some special effects
		epicenter = get_turf(epicenter) // the ex_acts might have changed the epicenter
		create_shrapnel(epicenter, rand(5,9), , ,/datum/ammo/bullet/shrapnel/light/effect/ver1, explosion_cause_data)
		sleep(1)
		create_shrapnel(epicenter, rand(5,9), , ,/datum/ammo/bullet/shrapnel/light/effect/ver2, explosion_cause_data)

	spawn(2) //just in case something goes wrong
		if(explosion_in_progress)
			explosion_damage()
			QDEL_IN(src, 20)



//direction is the direction that the spread took to come to this tile. So it is pointing in the main blast direction - meaning where this tile should spread most of it's force.
/turf/proc/explosion_spread(obj/effect/explosion/Controller, power, direction)

	if(Controller.explosion_turfs[src] && Controller.explosion_turfs[src] + 1 >= power)
		return

	Controller.active_spread_num++

	var/resistance = 0
	var/obj/structure/ladder/L

	for(var/atom/current_area in src)  //add resistance
		resistance += max(0, current_area.get_explosion_resistance(direction) )

		//check for stair-teleporters. If there is a stair teleporter, switch to the teleported-to tile instead
		if(istype(current_area, /obj/effect/step_trigger/teleporter_vector))
			var/obj/effect/step_trigger/teleporter_vector/vector = current_area
			var/turf/current_turf = locate(vector.x + vector.vector_x, vector.y + vector.vector_y, vector.z)
			if(current_turf)
				spawn(0)
					current_turf.explosion_spread(Controller, power, direction)
					Controller.active_spread_num--
					if(Controller.active_spread_num <= 0 && Controller.explosion_in_progress)
						Controller.explosion_damage()
				return

		else if (istype(current_area, /obj/structure/ladder)) //check for ladders
			L = current_area

	Controller.explosion_turfs[src] = power  //recording the power applied
	Controller.explosion_turf_directions[src] = direction

	//at the epicenter of an explosion, resistance doesn't subtract from power. This prevents stuff like explosions directly on reinforced walls being completely neutralized
	if(direction)
		resistance += max(0, src.get_explosion_resistance(direction) )
		Controller.reflected_power += max(0, min(resistance, power))
		power -= resistance


	//spawn(0) is important because it paces the explosion in an expanding circle, rather than a series of squiggly lines constantly checking overlap. Reduces lag by a lot. Note that INVOKE_ASYNC doesn't have the same effect as spawn(0) for this purpose.
	spawn(0)

		//spread in each ordinal direction
		var/direction_angle = dir2angle(direction)
		for(var/spread_direction in alldirs)
			var/spread_power = power

			if(direction) //false if, for example, this turf was the explosion source
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
					spread_power -= Controller.falloff
				else
					spread_power -= Controller.falloff * 1.414 //diagonal spreading

			if (spread_power <= Controller.minimum_spread_power)
				continue

			var/turf/current_turf = get_step(src, spread_direction)

			if(!current_turf) //prevents trying to spread into "null" (edge of the map?)
				continue

			current_turf.explosion_spread(Controller, spread_power, spread_direction)


		//spreading up/down ladders
		if(L)

			var/ladder_spread_power
			if(direction)
				if(power >= 0)
					ladder_spread_power = power*0.75 - Controller.falloff
				else
					ladder_spread_power = power*1.25 - Controller.falloff
			else
				if(power >= 0)
					ladder_spread_power = power*0.5 - Controller.falloff
				else
					ladder_spread_power = power*1.5 - Controller.falloff

			if (ladder_spread_power > Controller.minimum_spread_power)
				if(L.up)
					var/turf/T_up = get_turf(L.up)
					if(T_up)
						T_up.explosion_spread(Controller, ladder_spread_power, null)
				if(L.down)
					var/turf/T_down = get_turf(L.down)
					if(T_down)
						T_down.explosion_spread(Controller, ladder_spread_power, null)


		//if this is the last explosion spread, initiate explosion damage
		Controller.active_spread_num--
		if(Controller.active_spread_num <= 0 && Controller.explosion_in_progress)
			Controller.explosion_damage()


/obj/effect/explosion/proc/explosion_damage() //This step applies the ex_act effects for the explosion

	explosion_in_progress = 0

	var/num_tiles_affected = 0

	for(var/turf/current_turf in explosion_turfs)
		if(!current_turf) continue
		if(explosion_turfs[current_turf] >= 0)
			num_tiles_affected++

	reflected_power *= reflection_multiplier

	var/damage_addon = min(power * reflection_amplification_limit, reflected_power/num_tiles_affected)

	var/tiles_processed = 0
	var/increment = min(50, sqrt(num_tiles_affected)*3 )//how many tiles we damage per tick

	for(var/turf/current_turf in explosion_turfs)
		if(!current_turf) continue

		var/severity = explosion_turfs[current_turf] + damage_addon
		if (severity <= 0)
			continue
		var/direction = explosion_turf_directions[current_turf]

		var/x = current_turf.x
		var/y = current_turf.y
		var/z = current_turf.z
		current_turf.ex_act(severity, direction)
		if(!current_turf)
			current_turf = locate(x,y,z)

		for(var/atom/current_area in current_turf)
			spawn(0)
				if(isliving(current_area))
					var/mob/current_mob = current_area
					var/explosion_source
					if(explosion_cause_data)
						explosion_source = explosion_cause_data.resolve_mob()
					if(!explosion_source) // Gotta call them something
						explosion_source = "unknown"
					current_mob.last_damage_data = explosion_cause_data
					log_attack("Mob [current_mob.name] ([current_mob.ckey]) was harmed by explosion in [current_turf.loc.name] caused by [explosion_source] at ([current_mob.loc.x],[current_mob.loc.y],[current_mob.loc.z])")
					var/mob/explosion_source_mob = explosion_source
					if(ismob(explosion_source_mob))
						var/mob/firingMob = explosion_source_mob
						var/turf/location_of_mob = get_turf(firingMob)
						var/area/thearea = get_area(current_mob)
						if(current_mob == firingMob)
							current_mob.attack_log += "\[[time_stamp()]\] <b>[current_mob]/[current_mob.ckey]</b> blew himself up with \a <b>[explosion_source]</b> in [thearea]."
						else if(ishuman(firingMob) && ishuman(current_mob) && current_mob.faction == firingMob.faction && !thearea?.statistic_exempt) //One human blew up another, be worried about it but do everything basically the same //special_role should be null or an empty string if done correctly
							current_mob.attack_log += "\[[time_stamp()]\] <b>[firingMob]/[firingMob.ckey]</b> blew up <b>[current_mob]/[current_mob.ckey]</b> with \a <b>[explosion_source]</b> in [get_area(firingMob)]."
							firingMob:attack_log += "\[[time_stamp()]\] <b>[firingMob]/[firingMob.ckey]</b> blew up <b>[current_mob]/[current_mob.ckey]</b> with \a <b>[explosion_source]</b> in [get_area(firingMob)]."
							var/ff_msg = "[firingMob] ([firingMob.ckey]) blew up [current_mob] ([current_mob.ckey]) with \a [explosion_source] in [get_area(firingMob)] (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[location_of_mob.x];Y=[location_of_mob.y];Z=[location_of_mob.z]'>JMP</a>) ([firingMob.client ? "<a href='?priv_msg=[firingMob.client.ckey]'>PM</a>" : "NO CLIENT"])"
							var/ff_living = TRUE
							if(current_mob.stat == DEAD)
								ff_living = FALSE
							msg_admin_ff(ff_msg, ff_living)
							if(ishuman(firingMob))
								var/mob/living/carbon/human/human = firingMob
								human.track_friendly_fire(explosion_source)
						else
							current_mob.attack_log += "\[[time_stamp()]\] <b>[firingMob]/[firingMob.ckey]</b> blew up <b>[current_mob]/[current_mob.ckey]</b> with \a <b>[explosion_source]</b> in [get_area(firingMob)]."
							firingMob:attack_log += "\[[time_stamp()]\] <b>[firingMob]/[firingMob.ckey]</b> blew up <b>[current_mob]/[current_mob.ckey]</b> with \a <b>[explosion_source]</b> in [get_area(firingMob)]."
							msg_admin_attack("[firingMob] ([firingMob.ckey]) blew up [current_mob] ([current_mob.ckey]) with \a [explosion_source] in [get_area(firingMob)] ([location_of_mob.z],[location_of_mob.y],[location_of_mob.z])", location_of_mob.x, location_of_mob.y, location_of_mob.z)
					else if(explosion_source_mob)
						var/mob/firingMob = explosion_source_mob
						var/turf/location_of_mob = get_turf(firingMob)
						if(ishuman(firingMob))
							var/mob/living/carbon/human/human = firingMob
							human.track_shot_hit(initial(name), current_mob)
						current_mob.attack_log += "\[[time_stamp()]\] <b>[firingMob]</b> blew up <b>[current_mob]/[current_mob.ckey]</b> with a <b>[explosion_source]</b> in [get_area(firingMob)]."
						msg_admin_attack("[firingMob] ([firingMob.ckey]) blew up [current_mob] ([current_mob.ckey]) with \a [explosion_source] in [get_area(firingMob)] ([location_of_mob.z],[location_of_mob.y],[location_of_mob.z])", location_of_mob.x, location_of_mob.y, location_of_mob.z)
					else if(explosion_source)
						current_mob.attack_log += "\[[time_stamp()]\] <b>[current_mob]/[current_mob.ckey]</b> was blown up with a <b>[explosion_source]</b> in [get_area(current_mob)].</b>"
					else
						current_mob.attack_log += "\[[time_stamp()]\] <b>[current_mob]/[current_mob.ckey]</b> was blown up in [get_area(current_mob)]."
				current_area.ex_act(severity, direction, explosion_cause_data)

		tiles_processed++
		if(tiles_processed >= increment)
			tiles_processed = 0
			sleep(1)

	spawn(8)
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
			if(MOB_SIZE_XENO, MOB_SIZE_XENO_SMALL)
				return 20
			if(MOB_SIZE_BIG, MOB_SIZE_IMMOBILE)
				return 40
	return 0

/obj/item/proc/explosion_throw(severity, direction, scatter_multiplier = 1)
	if(anchored)
		return

	if(!istype(src.loc, /turf))
		return

	if(!direction)
		direction = pick(alldirs)
	var/range = min(round(severity/src.w_class * 0.2, 1), 14)
	if(!direction)
		range = round( range/2 ,1)

	if(range < 1)
		return


	var/speed = max(range*2.5, SPEED_SLOW)
	var/atom/target = get_ranged_target_turf(src, direction, range)

	if(range >= 2)
		var/scatter = range/4 * scatter_multiplier
		var/scatter_x = rand(-scatter,scatter)
		var/scatter_y = rand(-scatter,scatter)
		target = locate(target.x + round( scatter_x , 1),target.y + round( scatter_y , 1),target.z) //Locate an adjacent turf.

	//time for the explosion to destroy windows, walls, etc which might be in the way
	INVOKE_ASYNC(src, TYPE_PROC_REF(/atom/movable, throw_atom), target, range, speed, null, TRUE)

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
		if(MOB_SIZE_XENO, MOB_SIZE_XENO_SMALL)
			weight = 1
		if(MOB_SIZE_BIG, MOB_SIZE_IMMOBILE)
			weight = 4
	var/range = round( severity/weight * 0.02 ,1)
	if(!direction)
		range = round( 2*range/3 ,1)
		direction = pick(NORTH,SOUTH,EAST,WEST,NORTHEAST,NORTHWEST,SOUTHEAST,SOUTHWEST)

	if(range <= 0)
		return

	var/speed = max(range*1.5, SPEED_SLOW)
	var/atom/target = get_ranged_target_turf(src, direction, range)

	var/spin = 0

	if(range > 1)
		spin = 1

	if(range >= 2)
		var/scatter = range/4
		var/scatter_x = rand(-scatter,scatter)
		var/scatter_y = rand(-scatter,scatter)
		target = locate(target.x + round( scatter_x , 1),target.y + round( scatter_y , 1),target.z) //Locate an adjacent turf.

	//time for the explosion to destroy windows, walls, etc which might be in the way
	INVOKE_ASYNC(src, TYPE_PROC_REF(/atom/movable, throw_atom), target, range, speed, null, spin)

	return
