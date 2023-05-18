#define HIT_CHANCE_CHEAT 100
#define HIT_CHANCE_STANDARD 70
/**
 * Proc called to hit the ship with weapons
 *
 * Hits the ship with the weapon of choice
 * Calling Shakeship acoording to the weapon used
 * All sounds that should happen when they hit are in here already.
 * Probably doesn't work in other shipmaps.
 * Arguments:
 * * weaponused - chooses the weapon through a switchcase. 1 for missiles, 2 for railguns, 3 for particle cannons.
 * * location - location in the ship where the explosion will be created.
 * * point_defense - If you want the Almayer to attempt taking down the incoming fire
 * * salvo - identifies it as a salvo or not.
 */
/proc/weaponhits(weaponused, location, point_defense = FALSE)
	var/hitchance = HIT_CHANCE_CHEAT
	if(point_defense)
		hitchance = HIT_CHANCE_STANDARD

	var/datum/cause_data/cause_data = create_cause_data(weaponused ? "Railgun shot" : "Anti-Ship missile")
	var/list/echo_list = new(18)
	if(weaponused)
		for(var/turf/picked_atom in location)
			if(prob(hitchance))
				echo_list[ECHO_OBSTRUCTION] = -500
				cell_explosion(picked_atom, 1000, 200, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, null, cause_data)
				shakeship(5, 5, FALSE, FALSE)
				playsound(picked_atom, "bigboom", 50, 1, 200, echo = echo_list)
				playsound(picked_atom, 'sound/effects/railgunhit.ogg', 50, 1, 200, echo = echo_list)
				addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), picked_atom, 'sound/effects/double_klaxon.ogg', 25, 1, 200, VOLUME_SFX, 0, null, 1, echo_list), 2 SECONDS)
			else
				echo_list[ECHO_OBSTRUCTION] = -5000
				addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), picked_atom, 'sound/effects/railgun_miss.ogg', 5, 1, 100, VOLUME_SFX, 0, null, 1, echo_list), 2 SECONDS)
				addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), picked_atom, 'sound/effects/laser_point_defence_success.ogg', 15, 1, 100, VOLUME_SFX, 0, null, 1, echo_list), 2 SECONDS)
			sleep(1 SECONDS)
	else
		for(var/turf/picked_atom in location)
			if(prob(hitchance))
				echo_list[ECHO_OBSTRUCTION] = -500
				addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(cell_explosion), picked_atom, 500, 10, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, null, cause_data))
				shakeship(10, 10, TRUE, FALSE)
				playsound(picked_atom, "bigboom", 100, 1, 200, echo_list)
				playsound(picked_atom, 'sound/effects/metal_crash.ogg', 100, 1, 200, echo_list)
				addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), picked_atom, "pry", 25, 1, 200, VOLUME_SFX, 0, null, 1, echo_list), 1 SECONDS)
				addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), picked_atom, 'sound/effects/double_klaxon.ogg', 25, 1, 200, VOLUME_SFX, 0, null, 1, echo_list), 2 SECONDS)
			else
				echo_list[ECHO_OBSTRUCTION] = -5000
				addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), picked_atom, 'sound/effects/metal_shatter.ogg', 5, 1, 100, VOLUME_SFX, 0, null, 1, echo_list), 2 SECONDS)
				addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound), picked_atom, 'sound/effects/laser_point_defence_success.ogg', 15, 1, 100, VOLUME_SFX, 0, null, 1, echo_list), 2 SECONDS)
			sleep(1 SECONDS)

#undef HIT_CHANCE_CHEAT
#undef HIT_CHANCE_STANDARD
