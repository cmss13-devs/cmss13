// Memey automata that spawns an outwards propagating wave of vomit. Stopped by dense turfs
// This is intended to be an example of how the cellauto system can be used, it isn't for any serious purpose

/datum/automata_cell/vomit_wave
	neighbor_type = NEIGHBORS_CARDINAL

	var/age = 0
	var/max_age = 1

	// Strength of the cell
	var/strength = 1
	// How much strength the cell loses every propagation
	var/strength_dropoff = 0.1

	var/obj/effect/decal/cleanable/vomit/vomit = null

/datum/automata_cell/vomit_wave/birth()
	vomit = new(in_turf)
	vomit.layer = 3

/datum/automata_cell/vomit_wave/death()
	if(vomit)
		qdel(vomit)

/datum/automata_cell/vomit_wave/proc/should_die()
	if(age >= max_age)
		return TRUE

	if(strength <= 0)
		return TRUE

	return FALSE

/datum/automata_cell/vomit_wave/update_state(var/list/turf/neighbors)
	if(should_die())
		qdel(src)
		return

	// Propagate to cardinal directions
	var/list/to_spread = cardinal.Copy()
	for(var/datum/automata_cell/vomit_wave/C in neighbors)
		to_spread -= get_dir(in_turf, C.in_turf)

	for(var/dir in to_spread)
		var/turf/T = get_step(in_turf, dir)

		if(!T)
			continue

		if(is_blocked_turf(T))
			continue

		var/datum/automata_cell/vomit_wave/C = propagate(dir)
		// Make it weaker
		C.strength = strength - strength_dropoff
		if(C.vomit)
			C.vomit.alpha = 255 * C.strength

	age++

/client/proc/spawn_wave()
	set name = "Spawn Cellauto Wave"
	set desc = "suck some ass ok"
	set category = "Debug"

	var/turf/T = get_turf(mob)
	new /datum/automata_cell/vomit_wave(T)
