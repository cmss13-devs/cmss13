
//Now that this has been replaced entirely by D.O.R.E.C, we just need something that translates old explosion calls into a D.O.R.E.C approximation

/proc/explosion(turf/epicenter, devastation_range, heavy_impact_range, light_impact_range, flash_range, adminlog = 1, z_transfer = 0, flame_range = 0, datum/cause_data/explosion_cause_data)
	var/power = 0

	if(devastation_range > 0)
		power = 300
	else if (heavy_impact_range > 0)
		power = 220
	else if (light_impact_range > 0)
		power = 120
	else
		return

	var/falloff = power/(light_impact_range+2) // +1 would give the same range. +2 gives a bit of extra range now that explosions are blocked by walls
	if(!explosion_cause_data)
		stack_trace("explosion() called without cause_data.")
		explosion_cause_data = create_cause_data("Explosion")
	cell_explosion(epicenter, power, falloff, EXPLOSION_FALLOFF_SHAPE_LINEAR, null, explosion_cause_data)



//A very crude linear approximatiaon of pythagoras theorem. (this is still used by chemsmoke)

/proc/cheap_pythag(dx, dy)
	dx = abs(dx); dy = abs(dy);
	if(dx>=dy)
		return dx + (0.5*dy) //The longest side add half the shortest side approximates the hypotenuse
	else
		return dy + (0.5*dx)
