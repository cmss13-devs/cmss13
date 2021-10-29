/// Adds an item to the cleanup queue
#define QUEUE_CLEANUP(item) (SSitem_cleanup.standby_queue |= WEAKREF(item))

SUBSYSTEM_DEF(item_cleanup)
	name = "Item Cleanup"
	flags = SS_NO_INIT | SS_POST_FIRE_TIMING
	wait = 4 MINUTES
	priority = SS_PRIORITY_CLEANUP

	/// After how long to start cleaning stuff up, to preserve scenery
	var/start_processing_time = 26 MINUTES
	/// How much of the items marked for garbaging should be actually cleaned up
	var/garbage_ratio = 0.25
	/// Active deletion queue: list of items that can be deleted during next iterations
	var/list/list/datum/weakref/active_queue = list()
	/// Standby deletion queue: items will be shifted only after a full iteration so they're not instantly deleted
	var/list/datum/weakref/standby_queue = list()
	/// Current deletion queue: immediate sub list of items to be deleted ASAP
	var/list/datum/weakref/current_queue = list()
	/// Objects left to process during this iteration
	var/remaining = 0
	/// Objects deleted during this iteration
	var/deleted = 0
	/// Objects presents at start of iteration
	var/starting = 0

/datum/controller/subsystem/item_cleanup/fire(resumed = FALSE)
	// This should maybe be based on round start time ?
	if(world.time < start_processing_time)
		return

	if(!resumed)
		deleted = 0
		remaining = 0
		starting = length(current_queue)
		for(var/list/sublist in active_queue)
			starting += length(sublist)
		remaining = round(starting * garbage_ratio)

	while(remaining > 0 && (current_queue || active_queue.len))
		remaining--
		if(!current_queue)
			current_queue = popleft(active_queue)
		if(length(current_queue))
			var/datum/weakref/WR = current_queue[current_queue.len]
			current_queue.len--
			// Note that we don't qdel the WR directly to avoid potential
			// qdel(null)+del(null) calls due to its Destroy() implem
			var/atom/movable/AM = WR?.resolve()
			if(AM)
				qdel(AM)
				deleted++
		if(!length(current_queue))
			current_queue = null
		if(MC_TICK_CHECK)
			return

	if(length(standby_queue))
		active_queue.len++
		active_queue[active_queue.len] = standby_queue
		standby_queue = list()
	log_debug("SSitem_cleanup deleted [deleted] garbage items out of [starting]")

