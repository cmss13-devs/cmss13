/datum
	var/disposed
	var/qdeled
	var/list/active_timers //Timer subsystem

/*
 * Like Del(), but for qdel.
 * Called BEFORE qdel moves shit.
 */
/datum/proc/Dispose()
	// For the Timer subsystem.
	var/list/timers = active_timers
	active_timers = null
	for(var/selected_timer in timers)
		var/datum/timed_event/timer = selected_timer
		if (timer.spent)
			continue
		qdel(timer)

	tag = null
	disposed = world.time
	return GC_HINT_QUEUE