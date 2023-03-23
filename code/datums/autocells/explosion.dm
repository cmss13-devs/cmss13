/*
	Cellular automaton explosions!

	Often in life, you can't have what you wish for. This is one massive, huge,
	gigantic, gaping exception. With this, you get EVERYTHING you wish for.

	This thing is AWESOME. It's made with super simple rules, and it still produces
	highly complex explosions because it's simply emergent behavior from the rules.
	If that didn't amaze you (it should), this also means the code is SUPER short,
	and because cellular automata is handled by a subsystem, this doesn't cause
	lagspikes at all.

	Enough nerd enthusiasm about this. Here's how it actually works:

		1. You start the explosion off with a given power

		2. The explosion begins to propagate outwards in all 8 directions

		3. Each time the explosion propagates, it loses power_falloff power

		4. Each time the explosion propagates, atoms in the tile the explosion is in
		may reduce the power of the explosion by their explosive resistance

	That's it. There are some special rules, though, namely:

		* If the explosion occured in a wall, the wave is strengthened
		with power *= reflection_multiplier and reflected back in the
		direction it came from

		* If two explosions meet, they will either merge into an amplified
		or weakened explosion
*/

/datum/automata_cell/explosion
	// Explosions only spread outwards and don't need to know their neighbors to propagate properly
	neighbor_type = NEIGHBORS_NONE

	// Power of the explosion at this cell
	var/power = 0
	// How much will the power drop off when the explosion propagates?
	var/power_falloff = 20
	// Falloff shape is used to determines whether or not the falloff will change during the explosion traveling.
	var/falloff_shape = EXPLOSION_FALLOFF_SHAPE_LINEAR
	// How much power does the explosion gain (or lose) by bouncing off walls?
	var/reflection_power_multiplier = 0.4

	//Diagonal cells have a small delay when branching off from a non-diagonal cell. This helps the explosion look circular
	var/delay = 0

	// Which direction is the explosion traveling?
	// Note that this will be null for the epicenter
	var/direction = null

	// Whether or not the explosion should merge with other explosions
	var/should_merge = TRUE

	// For stat tracking and logging purposes
	var/datum/cause_data/explosion_cause_data

	// Workaround to account for the fact that this is subsystemized
	// See on_turf_entered
	var/list/atom/exploded_atoms = list()

	var/obj/effect/particle_effect/shockwave/shockwave = null

// If we're on a fake z teleport, teleport over
/datum/automata_cell/explosion/birth()
	shockwave = new(in_turf)

	var/obj/effect/step_trigger/teleporter_vector/vector = locate() in in_turf
	if(!vector)
		return

	var/turf/new_turf = locate(in_turf.x + vector.vector_x, in_turf.y + vector.vector_y, in_turf.z)
	transfer_turf(new_turf)

/datum/automata_cell/explosion/death()
	if(shockwave)
		qdel(shockwave)

// Compare directions. If the other explosion is traveling in the same direction,
// the explosion is amplified. If not, it's weakened
/datum/automata_cell/explosion/merge(datum/automata_cell/explosion/cell)
	// Non-merging explosions take priority
	if(!should_merge)
		return TRUE

	// The strongest of the two explosions should survive the merge
	// This prevents a weaker explosion merging with a strong one,
	// the strong one removing all the weaker one's power and just killing the explosion
	var/is_stronger = (power >= cell.power)
	var/datum/automata_cell/explosion/survivor = is_stronger ? src : cell
	var/datum/automata_cell/explosion/dying = is_stronger ? cell : src

	// Two epicenters merging, or a new epicenter merging with a traveling wave
	if((!survivor.direction && !dying.direction) || (survivor.direction && !dying.direction))
		survivor.power += dying.power

	// A traveling wave hitting the epicenter weakens it
	if(!survivor.direction && dying.direction)
		survivor.power -= dying.power

	// Two traveling waves meeting each other
	// Note that we don't care about waves traveling perpendicularly to us
	// I.e. they do nothing

	// Two waves traveling the same direction amplifies the explosion
	if(survivor.direction == dying.direction)
		survivor.power += dying.power

	// Two waves travling towards each other weakens the explosion
	if(survivor.direction == reverse_dir[dying.direction])
		survivor.power -= dying.power

	return is_stronger

// Get a list of all directions the explosion should propagate to before dying
/datum/automata_cell/explosion/proc/get_propagation_dirs(reflected)
	var/list/propagation_dirs = list()

	// If the cell is the epicenter, propagate in all directions
	if(isnull(direction))
		return alldirs

	var/dir = reflected ? reverse_dir[direction] : direction

	if(dir in cardinal)
		propagation_dirs += list(dir, turn(dir, 45), turn(dir, -45))
	else
		propagation_dirs += dir

	return propagation_dirs

// If you need to set vars on the new cell other than the basic ones
/datum/automata_cell/explosion/proc/setup_new_cell(datum/automata_cell/explosion/cell)
	if(cell.shockwave)
		cell.shockwave.alpha = cell.power
	return

/datum/automata_cell/explosion/update_state(list/turf/neighbors)
	if(delay > 0)
		delay--
		return
	// The resistance here will affect the damage taken and the falloff in the propagated explosion
	var/resistance = max(0, in_turf.get_explosion_resistance(direction))
	for(var/atom/current_turf in in_turf)
		resistance += max(0, current_turf.get_explosion_resistance())

	// Blow stuff up
	INVOKE_ASYNC(in_turf, TYPE_PROC_REF(/atom, ex_act), power, direction, explosion_cause_data)
	for(var/atom/current_turf in in_turf)
		if(current_turf in exploded_atoms)
			continue
		if(current_turf.gc_destroyed)
			continue
		INVOKE_ASYNC(current_turf, TYPE_PROC_REF(/atom, ex_act), power, direction, explosion_cause_data)
		exploded_atoms += current_turf
		log_explosion(current_turf, src)

	var/reflected = FALSE

	// Epicenter is inside a wall if direction is null.
	// Prevent it from slurping the entire explosion
	if(!isnull(direction))
		// Bounce off the wall in the opposite direction, don't keep phasing through it
		// Notice that since we do this after the ex_act()s,
		// explosions will not bounce if they destroy a wall!
		if(power < resistance)
			reflected = TRUE
			power *= reflection_power_multiplier
		else
			power -= resistance

	if(power <= 0)
		qdel(src)
		return

	// Propagate the explosion
	var/list/to_spread = get_propagation_dirs(reflected)
	for(var/dir in to_spread)
		// Diagonals are longer, that should be reflected in the power falloff
		var/dir_falloff = 1
		if(dir in diagonals)
			dir_falloff = 1.414

		if(isnull(direction))
			dir_falloff = 0

		var/new_power = power - (power_falloff * dir_falloff)

		// Explosion is too weak to continue
		if(new_power <= 0)
			continue

		var/new_falloff = power_falloff
		// Handle our falloff function.
		switch(falloff_shape)
			if(EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL)
				new_falloff += new_falloff * dir_falloff
			if(EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL_HALF)
				new_falloff += (new_falloff*0.5) * dir_falloff

		var/datum/automata_cell/explosion/cell = propagate(dir)
		if(cell)
			cell.power = new_power
			cell.power_falloff = new_falloff
			cell.falloff_shape = falloff_shape
			cell.explosion_cause_data = explosion_cause_data

			// Set the direction the explosion is traveling in
			cell.direction = dir
			//Diagonal cells have a small delay when branching off the center. This helps the explosion look circular
			if(!direction && (dir in diagonals))
				cell.delay = 1

			setup_new_cell(cell)

	// We've done our duty, now die pls
	qdel(src)

/*
The issue is that between the cell being birthed and the cell processing,
someone could potentially move through the cell unharmed.

To prevent that, we track all atoms that enter the explosion cell's turf
and blow them up immediately once they do.

When the cell processes, we simply don't blow up atoms that were tracked
as having entered the turf.
*/

/datum/automata_cell/explosion/proc/on_turf_entered(atom/movable/current_atom)
	// Once is enough
	if(current_atom in exploded_atoms)
		return

	exploded_atoms += current_atom

	// Note that we don't want to make it a directed ex_act because
	// it could toss them back and make them get hit by the explosion again
	if(current_atom.gc_destroyed)
		return

	INVOKE_ASYNC(current_atom, TYPE_PROC_REF(/atom, ex_act), power, null, explosion_cause_data)
	log_explosion(current_atom, src)

// I'll admit most of the code from here on out is basically just copypasta from DOREC

// Spawns a cellular automaton of an explosion
/proc/cell_explosion(turf/epicenter, power, falloff, falloff_shape = EXPLOSION_FALLOFF_SHAPE_LINEAR, direction, datum/cause_data/explosion_cause_data)
	if(!istype(epicenter))
		epicenter = get_turf(epicenter)

	if(!epicenter)
		return

	if(!istype(explosion_cause_data))
		if(explosion_cause_data)
			stack_trace("cell_explosion called with string cause ([explosion_cause_data]) instead of datum")
			explosion_cause_data = create_cause_data(explosion_cause_data)
		else
			stack_trace("cell_explosion called without cause_data.")
			explosion_cause_data = create_cause_data("Explosion")

	falloff = max(falloff, power/100)

	msg_admin_attack("Explosion with Power: [power], Falloff: [falloff], Shape: [falloff_shape] in [epicenter.loc.name] ([epicenter.x],[epicenter.y],[epicenter.z]).", epicenter.x, epicenter.y, epicenter.z)

	playsound(epicenter, 'sound/effects/explosionfar.ogg', 100, 1, round(power^2,1))

	if(power >= 300) //Make BIG BOOMS
		playsound(epicenter, "bigboom", 80, 1, max(round(power,1),7))
	else
		playsound(epicenter, "explosion", 90, 1, max(round(power,1),7))

	var/datum/automata_cell/explosion/cell = new /datum/automata_cell/explosion(epicenter)
	if(power > EXPLOSION_MAX_POWER)
		log_debug("[explosion_cause_data.cause_name] exploded with force of [power]. Overriding to capacity of [EXPLOSION_MAX_POWER].")
		power = EXPLOSION_MAX_POWER

	// something went wrong :(
	if(QDELETED(cell))
		return

	cell.power = power
	cell.power_falloff = falloff
	cell.falloff_shape = falloff_shape
	cell.direction = direction
	cell.explosion_cause_data = explosion_cause_data

	if(power >= 100) // powerful explosions send out some special effects
		epicenter = get_turf(epicenter) // the ex_acts might have changed the epicenter
		create_shrapnel(epicenter, rand(5,9), , ,/datum/ammo/bullet/shrapnel/light/effect/ver1, explosion_cause_data)
		create_shrapnel(epicenter, rand(5,9), , ,/datum/ammo/bullet/shrapnel/light/effect/ver2, explosion_cause_data)

/proc/log_explosion(atom/current_atom, datum/automata_cell/explosion/cell)
	if(isliving(current_atom))
		var/mob/living/current_mob = current_atom
		var/turf/current_turf = get_turf(current_atom)

		if(QDELETED(current_mob) || QDELETED(current_turf))
			return

		current_mob.last_damage_data = cell.explosion_cause_data
		var/explosion_source = cell.explosion_cause_data?.cause_name
		var/mob/explosion_source_mob = cell.explosion_cause_data?.resolve_mob()

		if(explosion_source_mob)
			log_attack("[key_name(current_mob)] was harmed by explosion in [current_turf.loc.name] caused by [explosion_source] at ([current_turf.x],[current_turf.y],[current_turf.z])")
			if(!ismob(explosion_source_mob))
				CRASH("Statistics attempted to track a source mob incorrectly: [explosion_source_mob] ([explosion_source])")
			var/mob/firing_mob = explosion_source_mob
			var/turf/location_of_mob = get_turf(firing_mob)
			// who cares about the explosion if it happened nowhere
			if(!location_of_mob)
				return
			var/area/thearea = get_area(current_mob)
			if(current_mob == firing_mob)
				current_mob.attack_log += "\[[time_stamp()]\] <b>[key_name(current_mob)]</b> blew himself up with \a <b>[explosion_source]</b> in [get_area(current_turf)]."
			// One human blew up another, be worried about it but do everything basically the same
			else if(ishuman(firing_mob) && ishuman(current_mob) && current_mob.faction == firing_mob.faction && !thearea?.statistic_exempt)
				current_mob.attack_log += "\[[time_stamp()]\] <b>[key_name(firing_mob)]</b> blew up <b>[key_name(current_mob)]</b> with \a <b>[explosion_source]</b> in [get_area(current_turf)]."

				firing_mob.attack_log += "\[[time_stamp()]\] <b>[key_name(firing_mob)]</b> blew up <b>[key_name(current_mob)]</b> with \a <b>[explosion_source]</b> in [get_area(current_turf)]."
				var/ff_msg = "[key_name(firing_mob)] blew up [key_name(current_mob)] with \a [explosion_source] in [get_area(current_turf)] (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[current_turf.x];Y=[current_turf.y];Z=[current_turf.z]'>JMP LOC</a>) (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[location_of_mob.x];Y=[location_of_mob.y];Z=[location_of_mob.z]'>JMP SRC</a>) ([firing_mob.client ? "<a href='?priv_msg=[firing_mob.client.ckey]'>PM</a>" : "NO CLIENT"])"
				var/ff_living = TRUE
				if(current_mob.stat == DEAD)
					ff_living = FALSE
				msg_admin_ff(ff_msg, ff_living)

				if(ishuman(firing_mob))
					var/mob/living/carbon/human/human = firing_mob
					human.track_friendly_fire(explosion_source)
			else
				current_mob.attack_log += "\[[time_stamp()]\] <b>[key_name(firing_mob)]</b> blew up <b>[key_name(current_mob)]</b> with \a <b>[explosion_source]</b> in [get_area(current_turf)]."

				firing_mob.attack_log += "\[[time_stamp()]\] <b>[key_name(firing_mob)]</b> blew up <b>[key_name(current_mob)]</b> with \a <b>[explosion_source]</b> in [get_area(current_turf)]."

				msg_admin_attack("[key_name(firing_mob)] blew up [key_name(current_mob)] with \a [explosion_source] in [get_area(current_turf)] ([current_turf.x],[current_turf.y],[current_turf.z]).", current_turf.x, current_turf.y, current_turf.z)
		else
			log_attack("[key_name(current_mob)] was harmed by unknown explosion in [current_turf.loc.name] at ([current_turf.x],[current_turf.y],[current_turf.z])")

/obj/effect/particle_effect/shockwave
	name = "shockwave"
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = FLY_LAYER
