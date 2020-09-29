/*
	heyo fuckio its a me interior manager here

	is be in fuckin charge o the vehicle interiors round here capische?
	interior z level's aaall mine and you ain't touchin it bud
	you want a new vehicle interior, who you come to? yeah, bud, you come to me
*/

var/global/datum/interior_manager/interior_manager = new

/datum/interior_manager
	// The z level to use for storing interiors in
	var/interior_z = null

	// The z will be divided into chunks of this size.
	// Chunk size 25x25 lets us divide a 300x300 z into 144 chunks
	// which is way more than enough
	var/chunk_size = INTERIOR_BOUND_SIZE

	// A list of which chunks are available
	var/list/chunk_availability = null

	// A list of all interior datums
	var/list/interiors

/datum/interior_manager/New()
	// Create the z level for interiors
	world.maxz += 1
	interior_z = world.maxz

	// Create the illusion of the black "void"
	var/turf/z_min = locate(1, 1, interior_z)
	var/turf/z_max = locate(world.maxx, world.maxy, interior_z)

	for(var/turf/T in block(z_min, z_max))
		T.ChangeTurf(/turf/open/void, TRUE)
		T.baseturfs = /turf/open/void

	var/total_chunk_ids = (world.maxx / chunk_size) ** 2

	chunk_availability = new /list(total_chunk_ids)
	// Set all chunks as available
	for(var/chunk_id = 1 to length(chunk_availability))
		chunk_availability[chunk_id] = TRUE

	interiors = new /list(total_chunk_ids)

/datum/interior_manager/Destroy()
	for(var/datum/interior/I in interiors)
		if(!QDELETED(I))
			qdel(I)
			interiors -= I
	interiors = null
	chunk_availability = null
	return ..()

/datum/interior_manager/proc/get_chunk_coords(var/chunk_id)
	var/base_load_pos = (chunk_id-1) * chunk_size
	var/start_x = (base_load_pos % world.maxx)
	var/start_y = (Floor(base_load_pos / world.maxx) * chunk_size)

	// +1 because the above calculations assume origin at (0, 0). BYOND uses (1, 1)
	return list(start_x+1, start_y+1)

/datum/interior_manager/proc/load_interior(var/datum/interior/interior)
	// Find a suitable chunk
	var/chunk_id = 0
	for(var/id = 1 to length(chunk_availability))
		if(chunk_availability[id])
			chunk_id = id
			break

	// Failed to find a chunk
	if(!chunk_id)
		return null

	var/list/chunk_coords = get_chunk_coords(chunk_id)
	var/spawn_x = chunk_coords[1]
	var/spawn_y = chunk_coords[2]

	var/datum/map_load_metadata/M = maploader.load_map(file("maps/interiors/[interior.name].dmm"), spawn_x, spawn_y, interior_z, FALSE, FALSE, FALSE, TRUE)

	// Failed to load the interior
	if(!M)
		return null

	chunk_availability[chunk_id] = FALSE
	interiors[chunk_id] = interior

	return list(M, chunk_id)

// Deletes the interior and frees the interior chunk
/datum/interior_manager/proc/unload_chunk(var/chunk_id)
	set background = 1

	var/list/chunk_coords = get_chunk_coords(chunk_id)
	var/turf/min = locate(chunk_coords[1], chunk_coords[2], interior_z)
	if(!min)
		return

	var/turf/max = locate(chunk_coords[1] + chunk_size - 1, chunk_coords[2] + chunk_size - 1, interior_z)
	if(!max)
		return

	// Delete everything in the chunk
	for(var/turf/T in block(min, max))
		for(var/atom/A in T)
			qdel(A)
		qdel(T)

	chunk_availability[chunk_id] = TRUE
	interiors[chunk_id] = null

// Finds which interior is at (x,y) and returns its interior datum
/datum/interior_manager/proc/get_interior_by_coords(var/x, var/y)
	for(var/datum/interior/I in interiors)
		var/list/turf/bounds = I.get_bound_turfs()
		if(!bounds)
			continue

		if(x >= bounds[1].x && x <= bounds[2].x && y >= bounds[1].y && y <= bounds[2].y)
			return I

	return null
