/*
	Each datum represents a single cellular automataton

	Cell death is just the cell being deleted.
	So if you want a cell to die, just qdel it.
*/

// No neighbors
#define NEIGHBORS_NONE     0
// Cardinal neighborhood
#define NEIGHBORS_CARDINAL 1
// Ordinal neighborhood
#define NEIGHBORS_ORDINAL  2
// Note that NEIGHBORS_CARDINAL | NEIGHBORS_ORDINALS gives you all 8 surrounding neighbors

/datum/automata_cell
	// Which turf is the cell contained in
	var/turf/in_turf = null

	// What type of neighborhood do we use?
	// This affects what neighbors you'll get passed in update_state()
	var/neighbor_type = NEIGHBORS_CARDINAL

/datum/automata_cell/New(var/turf/T)
	..()

	if(!istype(T))
		qdel(src)
		return

	// Attempt to merge the two cells if they end up in the same turf
	var/datum/automata_cell/C = T.get_cell(type)
	if(C && merge(C))
		qdel(src)
		return

	in_turf = T
	in_turf.autocells += src

	cellauto_cells += src

	birth()

/datum/automata_cell/Destroy()
	. = ..()

	if(!QDELETED(in_turf))
		in_turf.autocells -= src
		in_turf = null

	cellauto_cells -= src

	death()

// Called when the cell is created
/datum/automata_cell/proc/birth()
	return

// Called when the cell is deleted/when it dies
/datum/automata_cell/proc/death()
	return

// Transfer this automata cell to another turf
/datum/automata_cell/proc/transfer_turf(var/turf/new_turf)
	if(QDELETED(new_turf))
		return

	if(!QDELETED(in_turf))
		in_turf.autocells -= src
		in_turf = null

	in_turf = new_turf
	in_turf.autocells += src

// Use this proc to merge this cell with another one if the other cell enters the same turf
// Return TRUE if this cell should survive the merge (the other one will die/be qdeleted)
// Return FALSE if this cell should die and be replaced by the other cell
/datum/automata_cell/proc/merge(var/datum/automata_cell/other_cell)
	return TRUE

// Returns a list of neighboring cells
// This is called by and results are passed to update_state by the cellauto subsystem
/datum/automata_cell/proc/get_neighbors()
	if(QDELETED(in_turf))
		return

	var/list/neighbors = list()

	// Get cardinal neighbors
	if(neighbor_type & NEIGHBORS_CARDINAL)
		for(var/dir in cardinal)
			var/turf/T = get_step(in_turf, dir)
			if(QDELETED(T))
				continue

			// Only add neighboring cells of the same type
			for(var/datum/automata_cell/C in T.autocells)
				if(istype(C, type))
					neighbors += C

	// Get ordinal/diagonal neighbors
	if(neighbor_type & NEIGHBORS_ORDINAL)
		for(var/dir in diagonals)
			var/turf/T = get_step(in_turf, dir)
			if(QDELETED(T))
				continue

			for(var/datum/automata_cell/C in T.autocells)
				if(istype(C, type))
					neighbors += C

	return neighbors

// Create a new cell in the given direction
// Obviously override this if you want custom propagation,
// but I figured this is pretty useful as a basic propagation function
/datum/automata_cell/proc/propagate(var/dir)
	if(!dir)
		return

	var/turf/T = get_step(in_turf, dir)
	if(QDELETED(T))
		return

	// Create the new cell
	var/datum/automata_cell/C = new type(T)
	return C

// Update the state of this cell
/datum/automata_cell/proc/update_state(var/list/turf/neighbors)
	// just fucking DIE
	qdel(src)
