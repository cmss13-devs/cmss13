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
	 * Another option is to use a shared list for all waves so the target will only
	 * eat blast from one of the waves. That's what we're doing for now.
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
	/// Is this environemental damage?
	var/enviro = FALSE
	/// Informations on the action that caused the explosion
	var/datum/cause_data/cause_data

	/// List of turfs comprising the wave currently
	/// Note that in this house we order everything in ascending X/Y order
	/// This means it doesn't matter if the explosion goes North or South, the first item is always leftmost cell
	var/list/turf/wave_turfs
	/// Explosive intensities in order of the turfs above
	var/list/intensities
	/// Store falloff values per cell, to be used with compounding falloff
	var/list/wave_falloff
	/// List of movables that already ate the blast wave, so they don't eat it again if they get pushed out of the way
	/// Typically this will be a shared list between all 4 cardinal blast waves, so don't .Cut it
	var/list/atom/movable/exploded

/datum/explosion_wave/New(turf/epicenter, dir = NONE, power = 0, falloff = 0, falloff_shape = EXPLOSION_FALLOFF_SHAPE_LINEAR, datum/cause_data/cause_data, enviro, list/exploded_list)
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
	src.exploded = exploded_list || list()
	if(!isnull(enviro))
		src.enviro = enviro

	// Bootstrap internal state
	wave_turfs = list(epicenter)
	wave_falloff = list(falloff)
	intensities = list(power)

	START_PROCESSING(SSexplosion_waves, src)

/datum/explosion_wave/Destroy(force, ...)
	. = ..()
	cause_data = null
	exploded = null // DON'T Cut it, other waves might depend on it
	STOP_PROCESSING(SSexplosion_waves, src)

/datum/explosion_wave/process(delta_time)
	pre_travel_effects(delta_time)

	. = propagate(delta_time) // Not delta_time enabled, it's hard to do fractionals of 1 tick
	if(!.)
		qdel(src)
		return

	. = post_travel_effects(delta_time)
	if(!.)
		qdel(src)
		return

/// What happens before moving the explosion wave
/datum/explosion_wave/proc/pre_travel_effects(delta_time)
	remove_overlays()
	tear_signals_down()

/// Actually step forward and move the explosion wave
/datum/explosion_wave/proc/propagate(delta_time)
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

	// Get the middle of the wave
	var/turf/wave_center_turf = locate(epicenter.x + prop_x * order, epicenter.y + prop_y * order, epicenter.z)
	if(!wave_center_turf)
		return FALSE // Done here.

	// Consider the entire wave as it is in game world
	// It doesn't matter if these turfs don't exist, we'll check that later
	var/list/turf/new_wave_turfs = new /list(order * 2 + 1)
	for(var/i in 1 to (order * 2 + 1))
		new_wave_turfs[i] = locate(wave_center_turf.x + (!!prop_y)*(i-order-1), wave_center_turf.y + (!!prop_x)*(i-order-1), wave_center_turf.z)

	// Now we have to calculate the new intensities. There are three main factors:
	//  * The wave expands as shown above when it travels, so we have to compute new edge values
	//  * When the wave moves forward, it loses intensity through falloff
	//  * As the wave propagates, atoms in the way can dampen the explosion for rest of the travel
	// We'll do the first step now. The dampening can happen as we scan for explosion damage later.
	// This is a bit weird, but note that the splitting of the wave as it expand doesnt reduce the explosion intensity.
	// We also give same treatment to stored falloff value. They'll be modified to account for the travel later.
	var/list/new_intensities = new /list(order * 2 + 1)
	var/list/new_falloff = new /list(order * 2 + 1)
	for(var/i in 1 to length(intensities))
		new_intensities[i+1] = intensities[i]
		new_falloff[i+1] = wave_falloff[i]
	new_intensities[1] = intensities[min(2, length(intensities))] // clamping needed for the order=1 case
	new_intensities[length(new_intensities)] = intensities[length(intensities)]
	new_falloff[1] = wave_falloff[min(2, length(wave_falloff))]
	new_falloff[length(new_falloff)] = wave_falloff[length(wave_falloff)]

	// We store the new values
	intensities = new_intensities
	wave_turfs = new_wave_turfs
	wave_falloff = new_falloff
	return TRUE

/// Effects that take place after the explosion wave travels:
/// - falloff, explosion dampening, and exploding actual contents of the turfs
/datum/explosion_wave/proc/post_travel_effects(delta_time)
	apply_falloff()
	set_signals_up()
	. = explode_turfs()
	if(.)
		apply_overlays()

/// Applies falloff to a set of turfs and explosion intensities, in-place
/datum/explosion_wave/proc/apply_falloff()
	if(order == 1) // Don't apply falloff first propagation to replicate legacy CellAuto behavior
		return

	for(var/i in 1 to length(wave_turfs))
		var/turf/turf = wave_turfs[i]
		if(!turf) // This went out of bounds. Reset strength to zero. Move on.
			intensities[i] = 0
			continue

		// First we apply the falloff to explosion strength
		intensities[i] -= wave_falloff[i]
		if(intensities[i] <= 0)
			intensities[i] = 0
			continue

		// Then we modify the falloff for subsequent propagations
		// There is one difference with legacy CellAuto behavior, which is that CellAuto would
		// multiply by sqrt(2) diagnoals falloff. I can't see how this makes sense unless we
		// also spread out the explosion strength around the wave.
		switch(falloff_shape)
			if(EXPLOSION_FALLOFF_SHAPE_LINEAR)
				wave_falloff[i] = falloff
			if(EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL)
				wave_falloff[i] += falloff
			if(EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL_HALF)
				wave_falloff[i] += falloff * 0.5
			if(EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL_IN_PYLON)
				if(turf.get_pylon_protection_level() >= TURF_PROTECTION_OB)
					wave_falloff[i] += falloff
			if(EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL_HALF_IN_PYLON)
				if(turf.get_pylon_protection_level() >= TURF_PROTECTION_OB)
					wave_falloff[i] += falloff * 0.5

/// Apply effects to the turfs as we travel
/datum/explosion_wave/proc/explode_turfs()
	SHOULD_NOT_SLEEP(TRUE)

	var/still_exploding = FALSE
	for(var/i in 1 to length(wave_turfs))
		var/turf/turf = wave_turfs[i]
		if(!turf)
			continue // Make sure this turf exists in the world too
		if(intensities[i] <= 0)
			continue // Not really exploding

		// First we calculate explosion dampening, but we don't apply it just yet
		var/dampening = 0
		// Step 1: We dampen the explosion with the turf itself
		dampening += turf.get_explosion_resistance(dir)
		// Step 2: We dampen with the turf contents
		for(var/atom/movable/thing as anything in turf)
			dampening += thing.get_explosion_resistance(dir)

		// Step 3: We blow up the turf
		if(!(turf in exploded))
			exploded += turf
			INVOKE_ASYNC(turf, TYPE_PROC_REF(/atom, ex_act), intensities[i], dir, cause_data, 0, enviro)

		// Step 4: We blow up the turf contents
		for(var/atom/movable/thing as anything in turf)
			if(thing in exploded)
				continue
			exploded += thing

			// Mob explosions are expensive due to limbs and throws. We defer these entirely.
			// During Hijack, we also defer everything so explosions can keep running even if their effects are awkwardly delayed.
			if(SSdelayed_ex_act.defer_everything || isliving(thing))
				SSdelayed_ex_act.queue(thing, intensities[i], dir, cause_data, 0, enviro)
			else
				INVOKE_ASYNC(thing, TYPE_PROC_REF(/atom, ex_act), intensities[i], dir, cause_data, 0, enviro)

		// Now we apply dampening to the blast wave
		intensities[i] -= dampening
		if(intensities[i] <= 0)
			intensities[i] = 0
		else
			still_exploding = TRUE

	return still_exploding

/// Apply blast wave overlay to all the current turfs
/datum/explosion_wave/proc/apply_overlays()
	var/image/image = image('icons/effects/effects.dmi', "smoke", layer = FLY_LAYER)
	for(var/i in 1 to (order * 2 + 1))
		var/turf/turf = wave_turfs[i]
		var/intensity = intensities[i]
		if(intensity > 0)
			turf.overlays += image

/// Remove blast wave overlay from all the current turfs
/datum/explosion_wave/proc/remove_overlays()
	var/image/image = image('icons/effects/effects.dmi', "smoke", layer = FLY_LAYER)
	for(var/i in 1 to (order * 2 + 1))
		var/turf/turf = wave_turfs[i]
		var/intensity = intensities[i]
		if(intensity > 0) // Yes, we need to check even while removing, so that a dead explosion doens't clip overlays from a living explosion
			turf.overlays -= image

/// Set signals on all of our wave present turfs so we can explode things that come into them
/datum/explosion_wave/proc/set_signals_up()
	for(var/i in 1 to (order * 2 + 1))
		if(intensities[i] <= 0)
			continue
		var/turf/turf = wave_turfs[i]
		if(turf)
			RegisterSignal(turf, COMSIG_TURF_ENTERED, PROC_REF(turf_entered))

/datum/explosion_wave/proc/tear_signals_down()
	for(var/i in 1 to (order * 2 + 1))
		var/turf/turf = wave_turfs[i]
		if(turf)
			UnregisterSignal(turf, COMSIG_TURF_ENTERED)

/datum/explosion_wave/proc/turf_entered(turf/source, atom/movable/mover)
	SIGNAL_HANDLER
	if(mover in exploded)
		return
	var/i = wave_turfs.Find(source)
	exploded += mover
	// Contrary to explode_turfs above, here we defer everything to SSdelayed_ex_act
	// This is because since this came from a movement operation, we might not be on SS time at all
	// right now, and we may cause overtime if we start throwing humans around
	SSdelayed_ex_act.queue(mover, intensities[i], dir, cause_data, 0, enviro)

