/// ExplosionWave: An explosion backend made for speed and simplicity
/// An explosion is modelled as a serie of independant explosive "waves",
/// typically one per cardinal direction, that move in sync together,
/// to form a full blast wave that is easy to compute.
/datum/explosion_wave

	/*
	 * I know the above description wasn't enough for you, so let me help!
	 * Watch this expertly made ASCII diagram:
	 *
	 *
	 *                          x   <--- epicenter
	 *
	 * A wave propagating toward north would go like this:
	 *
	 *                                                   ^^^^^^^
	 *                        ^^^^^
	 *    ^^^
	 *     x         =>         x           =>              x
	 *
	 * And once you put everything together with one independent wave per
	 * cardinal direction, you get an expanding donut:
	 *
	 *
	 *                         *NNN*
	 *                         W   E
	 *                         W x E
	 *                         W   E
	 *                         *SSS*
	 *
	 * At the diagonals, we have two overlapping waves each time. This may require us
	 * to divide the explosive power by two to match, or to merge it between waves.
	 */

	/// Origin point of the wave
	var/turf/epicenter
	/// Direction this is propagating in, and also perpendicular to the wave direction
	var/dir
	/// Propagation order. At order 3 for example, the wave has traveled 3 turfs.
	/// At that point, if coming from a single turf, the wave will be 7 wide (1+2*order)
	var/order = 0
	/// How fast this must be scheduled to propagate the explosion - as a delay in deciseconds
	var/delay = 0.5 DECISECONDS

	/// Initial power of the blast wave
	var/power = 0
	/// Falloff of the blast wave, meaning how much it loses from traveling forward
	var/falloff = 0
	/// Type of Falloff calculation to use
	var/falloff_shape = EXPLOSION_FALLOFF_SHAPE_LINEAR

	/// List of turfs comprising the wave currently
	/// Note that in this house we order everything in ascending X/Y order
	/// This means it doesn't matter if the explosion goes North or South, the first item is always leftmost cell
	var/list/turf/wave_turfs
	/// Explosive intensities in order of the turfs above
	var/list/turf/intensities

	/// Informations on the action that caused the explosion
	var/datum/cause_data/cause_data

/datum/explosion_wave/New(turf/epicenter, dir = NONE, power = 0, falloff = 0, falloff_shape = EXPLOSION_FALLOFF_SHAPE_LINEAR, datum/cause_data/cause_data)
	. = ..()
	if(!dir || !power)
		qdel(src)
		return
	src.epicenter = epicenter
	src.dir = dir
	src.power = min(power, EXPLOSION_MAX_POWER)
	src.falloff = max(falloff, power/100)
	src.falloff_shape = falloff_shape
	src.cause_data = cause_data
	wave_turfs = list(epicenter)
	intensities = list(power)
	START_PROCESSING(SSexplosion_waves, src)

/datum/explosion_wave/Destroy(force, ...)
	. = ..()
	cause_data = null
	STOP_PROCESSING(SSexplosion_waves, src)

/datum/explosion_wave/process(delta_time)
	propagate()

/datum/explosion_wave/proc/propagate()
	. = FALSE
	order++

	// Consider the new list of affected turfs, let's project it

	var/prop_x = 0 // Coordinate multipliers for the propagation of the wave
	var/prop_y = 0
	switch(dir)
		if(NORTH)
			prop_x = 0; prop_y = 1;
		if(SOUTH)
			prop_x = 0; prop_y = -1;
		if(EAST)
			prop_x = 1; prop_y = 0;
		if(WEST)
			prop_x = -1; prop_y = 0;

	// Get the middle of the waveEXPLOSION_MIN_FALLOFF
	var/turf/wave_center_turf = locate(epicenter.x + prop_x * order, epicenter.y + prop_y * order, epicenter.z)
	if(!wave_center_turf)
		qdel(src)
		return FALSE // Done here.

	// Consider the entire wave as it is in game world
	var/list/turf/new_wave_turfs = new /list(order * 2 + 1)
	for(var/i in 1 to (order * 2 + 1))
		new_wave_turfs[i] = locate(wave_center_turf.x + (!!prop_y)*(i-order-1), wave_center_turf.y + (!!prop_x)*(i-order-1), wave_center_turf.z)

	// Now we have to calculate the new intensities. There are three main factors:
	//  * The wave expands as shown above when it travels, so we have to compute new edge values
	//  * When the wave moves forward, it loses intensity through falloff
	//  * As the wave propagates, atoms in the way can dampen the explosion for rest of the travel
	// We'll do the first and third step now. The dampening can happen as we scan for explosion damage later.
	// This is a bit weird, but note that the splitting of the wave as it expand doesnt reduce the explosion intensity.
	var/list/new_intensities = new /list(order * 2 + 1)
	for(var/i in 1 to length(intensities))
		new_intensities[i+1] = intensities[i]
	new_intensities[1] = intensities[min(2, length(intensities))]
	new_intensities[order*2+1] = intensities[length(intensities)]

	// Now run everything through Falloff!
	apply_falloff(new_wave_turfs, new_intensities)

	// We store the new values
	intensities = new_intensities
	wave_turfs = new_wave_turfs

	var/exploded_something = FALSE
	for(var/i in 1 to length(wave_turfs))
		if(intensities[i] > 0)
			if(wave_turfs[i])
				var/color
				switch(dir)
					if(NORTH)
						color = "#e61919"
					if(SOUTH)
						color = "#ffc32d"
					if(EAST)
						color = "#c864c8"
					if(WEST)
						color = "#4148c8"
				explode_turf(wave_turfs[i], intensities[i], color)
				exploded_something = TRUE

	if(!exploded_something)
		qdel(src) // It's over

/// Applies falloff to a set of turfs and explosion intensities, in-place
/datum/explosion_wave/proc/apply_falloff(list/turf/turfs, list/intensities)
	for(var/i in 1 to length(turfs))
		var/turf/turf = turfs[i]
		var/new_intensit = intensities[i]
		// TODO? We don't respect legacy behavior in two ways:
		//  * Falloff is not tracked but calc'd in one go - so EXPONENTIAL_(HALF_)IN_PYLON behaves as if it was in pylon the whole time when there
		//  * Legacy behavior is to *sqrt(2) diagonals falloff, but i don't see how it makes sense here if we don't also spread the explosive power
		switch(falloff_shape)
			if(EXPLOSION_FALLOFF_SHAPE_LINEAR)
				intensities[i] -= falloff
			if(EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL)
				intensities[i] -= (falloff * (2**(order-1)))
			if(EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL_HALF)
				intensities[i] -= (falloff * (1.5**(order-1)))
			if(EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL_IN_PYLON)
				if(turf.get_pylon_protection_level() < TURF_PROTECTION_OB)
					intensities[i] -= falloff
				else
					intensities[i] -= (falloff * (2**(order-1)))
			if(EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL_HALF_IN_PYLON)
				intensities[i] -= (falloff * (1.5**(order-1)))
				if(turf.get_pylon_protection_level() < TURF_PROTECTION_OB)
					intensities[i] -= falloff
				else
					intensities[i] -= (falloff * (1.5**(order-1)))

// Spawns a cellular automaton of an explosion
/proc/cell_explosion(turf/epicenter, power, falloff, falloff_shape = EXPLOSION_FALLOFF_SHAPE_LINEAR, direction, datum/cause_data/explosion_cause_data, enviro=FALSE)
	if(!istype(explosion_cause_data))
		if(explosion_cause_data)
			stack_trace("cell_explosion called with string cause ([explosion_cause_data]) instead of datum")
			explosion_cause_data = create_cause_data(explosion_cause_data)
		else
			stack_trace("cell_explosion called without cause_data.")
			explosion_cause_data = create_cause_data("Explosion")

	falloff = max(falloff, power/100)

	var/obj/causing_obj = explosion_cause_data?.resolve_cause()
	var/mob/causing_mob = explosion_cause_data?.resolve_mob()
	msg_admin_attack("Explosion with Power: [power], Falloff: [falloff], Shape: [falloff_shape],[causing_obj ? " from [causing_obj]" : ""][causing_mob ? " by [key_name(causing_mob)]" : ""] in [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z]).", epicenter.x, epicenter.y, epicenter.z)

	playsound(epicenter, 'sound/effects/explosionfar.ogg', 100, 1, round(power^2,1))

	if(power >= 300) //Make BIG BOOMS
		playsound(epicenter, "bigboom", 80, 1, max(round(power,1),7))
	else
		playsound(epicenter, "explosion", 90, 1, max(round(power,1),7))

	var/datum/automata_cell/explosion/E = new /datum/automata_cell/explosion(epicenter)

	if(direction)
		var/datum/explosion_wave/wave = new(epicenter, dir = direction, power = power, falloff = falloff, falloff_shape = falloff_shape, cause_data = explosion_cause_data)
	else
		for(var/dir in GLOB.cardinals)
			var/datum/explosion_wave/wave = new(epicenter, dir = dir, power = power, falloff = falloff, falloff_shape = falloff_shape, cause_data = explosion_cause_data)

	if(power >= 150) //shockwave for anything over 150 power
		new /obj/effect/shockwave(epicenter, power/60)

	if(power >= 100) // powerful explosions send out some special effects
		epicenter = get_turf(epicenter) // the ex_acts might have changed the epicenter
		new /obj/shrapnel_effect(epicenter)


/// Explodes a turf. Don't actually use a proc for this, this is just for testing. Doesn't explode, either, it just paints.
/datum/explosion_wave/proc/explode_turf(turf/turf, power, color)
	// TESTING for now. COLOR THE TURF. YEP.
	var/list/factors = rgb2num(color)
	var/gradient = power / src.power
	turf.color = rgb(factors[1], factors[2], factors[3], gradient * 255 + 100)
	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(uncolor_turf), turf), 0.5 SECONDS)

/proc/uncolor_turf(turf/turf)
	turf.color = null
	turf.alpha = 255
