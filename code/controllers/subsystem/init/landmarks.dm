GLOBAL_LIST_EMPTY(item_pool_landmarks)

SUBSYSTEM_DEF(landmark_init)
	name    = "Landmark Init"
	init_order = SS_INIT_LANDMARK
	flags   = SS_NO_FIRE

/datum/controller/subsystem/landmark_init/Initialize()
	// List of all the datums we need to loop through
	var/list/datum/item_pool_holder/pools = list()

	for (var/obj/effect/landmark/item_pool_spawner/marker in GLOB.item_pool_landmarks)

		var/curr_pool_name = marker.pool_name

		if (!curr_pool_name)
			log_debug("Item pool spawner [marker] has a no pool name populated. Code: ITEM_POOL_1")
			message_admins("Item pool spawner [marker] has a no pool name populated. Tell the devs. Code: ITEM_POOL_1")
			continue

		if (marker.mode_flags && !MODE_HAS_FLAG(marker.mode_flags))
			continue

		if (!pools[curr_pool_name])
			pools[curr_pool_name] = new /datum/item_pool_holder(marker.pool_name)

		var/datum/item_pool_holder/item_pool_holder = pools[marker.pool_name]

		item_pool_holder.turfs += get_turf(marker)

		if (marker.type_to_spawn)
			item_pool_holder.type_to_spawn = marker.type_to_spawn

		if (marker.quota)
			item_pool_holder.quota = marker.quota

		qdel(marker)

	for (var/pool_key in pools)

		var/datum/item_pool_holder/pool = pools[pool_key]

		if (!istype(pool))
			message_admins("Item pool incorrectly initialized by pool spawner landmarks. Tell the devs. Code: ITEM_POOL_2")
			continue

		if (!pool.quota || !pool.type_to_spawn)
			message_admins("Item pool [pool.pool_name] has no master landmark, aborting item spawns. Tell the devs. Code: ITEM_POOL_3")
			continue

		if (pool.quota > length(pool.turfs))
			message_admins("Item pool [pool.pool_name] wants to spawn more items than it has landmarks for. Spawning [length(pool.turfs)] instances of [pool.type_to_spawn] instead. Tell the devs. Code: ITEM_POOL_4")
			pool.quota = length(pool.turfs)

		// Quota times, pick a random turf, spawn an item there, then remove that turf from the list.
		for (var/i in 1 to pool.quota)
			var/turf/spawn_point = pool.turfs[rand(1, length(pool.turfs))]
			new pool.type_to_spawn(spawn_point)
			pool.turfs -= spawn_point

	return SS_INIT_SUCCESS

// Java bean thingy to hold what I need to populate these
/datum/item_pool_holder
	// Exact copies of landmark vars
	var/pool_name
	var/quota
	var/type_to_spawn

	// List of turfs to consider as candidates
	var/list/turfs

/datum/item_pool_holder/New(pool_name)
	src.pool_name = pool_name
	turfs = list()

/datum/item_pool_holder/Destroy()
	turfs = null
	. = ..()
