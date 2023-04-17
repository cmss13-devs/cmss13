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
 * * pd - If you want the Almayer to attempt taking down the incoming fire
 * * salvo - identifies it as a salvo or not.
 */
/proc/weaponhits(weaponused, location, pd, salvo = "Single")

	var/datum/cause_data/ashm_cause_data = create_cause_data("Anti-Ship missile")

	switch(weaponused)

		if(1)
			if(pd == "No")
				if(salvo == "Salvo")
					for(var/picked_atom in location)
						cell_explosion(picked_atom, 200, 10, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, null, ashm_cause_data)
						shakeship(10, 10, TRUE, FALSE)
					for(var/mob/living/carbon/current_mob in GLOB.living_mob_list)
						if(!is_mainship_level(current_mob.z))
							continue
						playsound_client(current_mob.client, 'sound/effects/metal_crash.ogg', 100 )
						playsound_client(current_mob.client, 'sound/effects/bigboom3.ogg', 100)
						addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), current_mob.client, 'sound/effects/pry2.ogg', 20), 1 SECONDS)
						addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), current_mob.client, 'sound/effects/double_klaxon.ogg'), 2 SECONDS)
				else
					cell_explosion(location, 200, 10, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, null, ashm_cause_data)
					shakeship(10, 10, TRUE, FALSE)
					playsound_client(current_mob.client, 'sound/effects/metal_crash.ogg', 100 )
					playsound_client(current_mob.client, 'sound/effects/bigboom3.ogg', 100)
					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), current_mob.client, 'sound/effects/pry2.ogg', 20), 1 SECONDS)
					addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), current_mob.client, 'sound/effects/double_klaxon.ogg'), 2 SECONDS)
			if(pd == "Yes")
				if(salvo == "Salvo")
					var/confirmedhit
					for(var/picked_atom in location)
						if(prob(70))
							cell_explosion(picked_atom, 200, 10, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, null, ashm_cause_data)
							shakeship(10, 10, TRUE, FALSE)
							confirmedhit += 1
					if(confirmedhit > 0)
						for(var/mob/living/carbon/current_mob in GLOB.living_mob_list)
							if(!is_mainship_level(current_mob.z))
								continue
							playsound_client(current_mob.client, 'sound/effects/metal_crash.ogg', 100 )
							playsound_client(current_mob.client, 'sound/effects/bigboom3.ogg', 100)
							addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), current_mob.client, 'sound/effects/pry2.ogg', 20), 1 SECONDS)
							addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(playsound_client), current_mob.client, 'sound/effects/double_klaxon.ogg'), 2 SECONDS)

				else
					cell_explosion(location, 200, 10, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, null, ashm_cause_data)
					shakeship(10, 10, TRUE, FALSE)

		if(2)

		if(3)
