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
 */
/proc/weaponhits(weaponused, location, pd)

	var/datum/cause_data/ashm_cause_data = create_cause_data("Anti-Ship missile")

	switch(weaponused)

		if(1)
			if(pd == "No")
				cell_explosion(location, 200, 10, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, null, ashm_cause_data)
				shakeship(10, 10, TRUE, FALSE)
			if(pd == "Yes")
				if(prob(70))
					cell_explosion(location, 200, 10, EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL, null, ashm_cause_data)
					shakeship(10, 10, TRUE, FALSE)

		if(2)

		if(3)
