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

GLOBAL_VAR_INIT(create_and_destroy_ignore_paths2, generate_ignore_paths2())
/proc/generate_ignore_paths2()
	. = list(
		//Never meant to be created, errors out the ass for mobcode reasons
		/mob/living/carbon,
		/obj/effect/node,
		/obj/item/seeds/cutting,
		//lighting singleton
		/mob/dview,
		// These use walk_away() after initialization, which causes false positives
		/obj/item/explosive/grenade/flashbang/cluster/segment,
		/obj/item/explosive/grenade/flashbang/cluster_piece,
		/mob/living/simple_animal/hostile/retaliate/giant_lizard,
		/obj/effect/landmark/lizard_spawn,
		/obj/effect/fake_attacker,
		/atom/movable/lighting_mask, //leave it alone
		//This is meant to fail extremely loud every single time it occurs in any environment in any context, and it falsely alarms when this unit test iterates it. Let's not spawn it in.
		/obj/merge_conflict_marker,
		/obj/effect/projector_anchor, // Needs a link ID set to work as intended
		/obj/effect/projector/linked, // Needs a link ID set to work as intended
	)
	//This turf existing is an error in and of itself
	. += typesof(/turf/baseturf_skipover)
	. += typesof(/turf/baseturf_bottom)
	//Our system doesn't support it without warning spam from unregister calls on things that never registered
	. += typesof(/obj/docking_port)
	. += typesof(/obj/item/storage/internal)
	// fuck interiors
	. += typesof(/obj/vehicle)
	. += typesof(/obj/effect/vehicle_spawner)
	// Always ought to have an associated escape menu. Any references it could possibly hold would need one regardless.
	. += subtypesof(/atom/movable/screen/escape_menu)
	. += typesof(/obj/effect/timed_event)
	// Need a defined ID, mapping-only, will and should fail loudly if spawned without one
	. += typesof(/obj/effect/landmark/dispersal_initiator)

/mob/verb/explosion_test()
	set name = "Explosion Test"
	set category = "Debug"

	var/turf/location = get_turf(usr)
	var/mob/living/carbon/human/body = new(location)
	body.death()
	cell_explosion(location, 60, 20, EXPLOSION_FALLOFF_SHAPE_LINEAR, SOUTH, create_cause_data("testing"))
	cell_explosion(location, 60, 20, EXPLOSION_FALLOFF_SHAPE_LINEAR, SOUTH, create_cause_data("testing"))
	for(var/turf/turf_path as anything in subtypesof(/turf) - GLOB.create_and_destroy_ignore_paths2)
		location = location.ChangeTurf(turf_path)

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

	if(power0 <= 1)
		return
	power = power0
	epicenter = get_turf(epicenter)
	if(!epicenter)
		return

	falloff = max(falloff0, power/100) //prevent explosions with a range larger than 100 tiles
	minimum_spread_power = -power * reflection_amplification_limit

	var/obj/causing_obj = explosion_cause_data?.resolve_cause()
	var/mob/causing_mob = explosion_cause_data?.resolve_mob()
	msg_admin_attack("Explosion with Power: [power], Falloff: [falloff],[causing_obj ? " from [causing_obj]" : ""][causing_mob ? " by [key_name(causing_mob)]" : ""] in area [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z]).", loc.x, loc.y, loc.z)

	playsound(epicenter, 'sound/effects/explosionfar.ogg', 100, 1, round(power^2,1))
	playsound(epicenter, "explosion", 90, 1, max(round(power,1),7) )

	explosion_in_progress = 1
	explosion_turfs = list()
	explosion_turf_directions = list()

	epicenter.explosion_spread(src, power, null)

	if(power >= 100) // powerful explosions send out some special effects
		epicenter = get_turf(epicenter) // the ex_acts might have changed the epicenter
		new /obj/shrapnel_effect(epicenter)

	spawn(2) //just in case something goes wrong
		if(explosion_in_progress)
			explosion_damage()
			QDEL_IN(src, 20)



//direction is the direction that the spread took to come to this tile. So it is pointing in the main blast direction - meaning where this tile should spread most of its force.
/turf/proc/explosion_spread(obj/effect/explosion/Controller, power, direction)

	if(Controller.explosion_turfs[src] && Controller.explosion_turfs[src] + 1 >= power)
		return

	Controller.active_spread_num++

	var/resistance = 0
	var/obj/structure/ladder/L

	for(var/atom/A in src)  //add resistance
		resistance += max(0, A.get_explosion_resistance(direction) )

		//check for stair-teleporters. If there is a stair teleporter, switch to the teleported-to tile instead
		if(istype(A, /obj/effect/step_trigger/teleporter_vector))
			var/obj/effect/step_trigger/teleporter_vector/V = A
			var/turf/T = locate(V.x + V.vector_x, V.y + V.vector_y, V.z)
			if(T)
				spawn(0)
					T.explosion_spread(Controller, power, direction)
					Controller.active_spread_num--
					if(Controller.active_spread_num <= 0 && Controller.explosion_in_progress)
						Controller.explosion_damage()
				return

		else if (istype(A, /obj/structure/ladder)) //check for ladders
			L = A

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
		for(var/spread_direction in GLOB.alldirs)
			var/spread_power = power

			if(direction) //false if, for example, this turf was the explosion source
				var/spread_direction_angle = dir2angle(spread_direction)

				var/angle = 180 - abs( abs( direction_angle - spread_direction_angle ) - 180 ) // the angle difference between the spread direction and initial direction

				switch(angle) //this reduces power when the explosion is going around corners
					if (0)
						pass()
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

			var/turf/T = get_step(src, spread_direction)

			if(!T) //prevents trying to spread into "null" (edge of the map?)
				continue

			T.explosion_spread(Controller, spread_power, spread_direction)


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

	for(var/turf/turf_exploding in explosion_turfs)
		if(!turf_exploding)
			continue
		if(explosion_turfs[turf_exploding] >= 0)
			num_tiles_affected++

	reflected_power *= reflection_multiplier

	var/damage_addon = min(power * reflection_amplification_limit, reflected_power/num_tiles_affected)

	var/tiles_processed = 0
	var/increment = min(50, sqrt(num_tiles_affected)*3 )//how many tiles we damage per tick

	for(var/turf/turf_exploding in explosion_turfs)
		if(!turf_exploding)
			continue

		var/severity = explosion_turfs[turf_exploding] + damage_addon
		if (severity <= 0)
			continue
		var/direction = explosion_turf_directions[turf_exploding]

		var/x = turf_exploding.x
		var/y = turf_exploding.y
		var/z = turf_exploding.z
		turf_exploding.ex_act(severity, direction)
		if(!turf_exploding)
			turf_exploding = locate(x,y,z)

		for(var/atom/exploding_atom in turf_exploding)
			spawn(0)
				if(isliving(exploding_atom))
					var/mob/exploding_mob = exploding_atom
					var/explosion_source
					if(explosion_cause_data)
						explosion_source = explosion_cause_data.resolve_mob()
					if(!explosion_source) // Gotta call them something
						explosion_source = "unknown"
					exploding_mob.last_damage_data = explosion_cause_data
					log_attack("Mob [exploding_mob.name] ([exploding_mob.ckey]) was harmed by explosion in [turf_exploding.loc.name] caused by [explosion_source] at ([exploding_mob.loc.x],[exploding_mob.loc.y],[exploding_mob.loc.z])")
					var/mob/explosion_source_mob = explosion_source
					if(ismob(explosion_source_mob))
						var/mob/firingMob = explosion_source_mob
						var/turf/location_of_mob = get_turf(firingMob)
						var/area/thearea = get_area(exploding_mob)
						if(exploding_mob == firingMob)
							exploding_mob.attack_log += "\[[time_stamp()]\] <b>[exploding_mob]/[exploding_mob.ckey]</b> blew himself up with \a <b>[explosion_source]</b> in [thearea]."
						else if(ishuman(firingMob) && ishuman(exploding_mob) && exploding_mob.faction == firingMob.faction && !thearea?.statistic_exempt) //One human blew up another, be worried about it but do everything basically the same //special_role should be null or an empty string if done correctly
							exploding_mob.attack_log += "\[[time_stamp()]\] <b>[firingMob]/[firingMob.ckey]</b> blew up <b>[exploding_mob]/[exploding_mob.ckey]</b> with \a <b>[explosion_source]</b> in [get_area(firingMob)]."
							firingMob:attack_log += "\[[time_stamp()]\] <b>[firingMob]/[firingMob.ckey]</b> blew up <b>[exploding_mob]/[exploding_mob.ckey]</b> with \a <b>[explosion_source]</b> in [get_area(firingMob)]."
							var/ff_msg = "[firingMob] ([firingMob.ckey]) blew up [exploding_mob] ([exploding_mob.ckey]) with \a [explosion_source] in [get_area(firingMob)] [ADMIN_JMP(location_of_mob)] [ADMIN_PM(firingMob)])"
							var/ff_living = TRUE
							if(exploding_mob.stat == DEAD)
								ff_living = FALSE
							msg_admin_ff(ff_msg, ff_living, exploding_mob.loc.z)
							if(ishuman(firingMob))
								var/mob/living/carbon/human/H = firingMob
								H.track_friendly_fire(explosion_source)
						else
							exploding_mob.attack_log += "\[[time_stamp()]\] <b>[firingMob]/[firingMob.ckey]</b> blew up <b>[exploding_mob]/[exploding_mob.ckey]</b> with \a <b>[explosion_source]</b> in [get_area(firingMob)]."
							firingMob:attack_log += "\[[time_stamp()]\] <b>[firingMob]/[firingMob.ckey]</b> blew up <b>[exploding_mob]/[exploding_mob.ckey]</b> with \a <b>[explosion_source]</b> in [get_area(firingMob)]."
							msg_admin_attack("[firingMob] ([firingMob.ckey]) blew up [exploding_mob] ([exploding_mob.ckey]) with \a [explosion_source] in [get_area(firingMob)] ([location_of_mob.z],[location_of_mob.y],[location_of_mob.z])", location_of_mob.x, location_of_mob.y, location_of_mob.z)
					else if(explosion_source_mob)
						var/mob/firingMob = explosion_source_mob
						var/turf/location_of_mob = get_turf(firingMob)
						if(ishuman(firingMob))
							var/mob/living/carbon/human/H = firingMob
							H.track_shot_hit(initial(name), exploding_mob)
						exploding_mob.attack_log += "\[[time_stamp()]\] <b>[firingMob]</b> blew up <b>[exploding_mob]/[exploding_mob.ckey]</b> with a <b>[explosion_source]</b> in [get_area(firingMob)]."
						msg_admin_attack("[firingMob] ([firingMob.ckey]) blew up [exploding_mob] ([exploding_mob.ckey]) with \a [explosion_source] in [get_area(firingMob)] ([location_of_mob.z],[location_of_mob.y],[location_of_mob.z])", location_of_mob.x, location_of_mob.y, location_of_mob.z)
					else if(explosion_source)
						exploding_mob.attack_log += "\[[time_stamp()]\] <b>[exploding_mob]/[exploding_mob.ckey]</b> was blown up with a <b>[explosion_source]</b> in [get_area(exploding_mob)].</b>"
					else
						exploding_mob.attack_log += "\[[time_stamp()]\] <b>[exploding_mob]/[exploding_mob.ckey]</b> was blown up in [get_area(exploding_mob)]."
				exploding_atom.ex_act(severity, direction, explosion_cause_data)

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

	if(!isturf(loc))
		return

	if(direction < 0)
		return // Don't do anything if explicitly directionless

	var/range = min(round(severity/w_class * 0.2, 1), 14)

	if(!direction)
		direction = pick(GLOB.alldirs)
		range = round(range/2, 1)

	if(range < 1)
		return

	var/speed = max(range*2.5, SPEED_SLOW)
	var/atom/target = get_ranged_target_turf(src, direction, range)

	if(range >= 2)
		var/scatter = range/4 * scatter_multiplier
		var/scatter_x = rand(-scatter,scatter)
		var/scatter_y = rand(-scatter,scatter)
		target = locate(target.x + round(scatter_x , 1), target.y + round(scatter_y , 1), target.z) //Locate an adjacent turf.

	//time for the explosion to destroy windows, walls, etc which might be in the way
	INVOKE_ASYNC(src, TYPE_PROC_REF(/atom/movable, throw_atom), target, range, speed, null, TRUE)

/mob/proc/explosion_throw(severity, direction)
	if(anchored)
		return

	if(!isturf(loc))
		return

	if(direction < 0)
		return // Don't do anything if explicitly directionless

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
