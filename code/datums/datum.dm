/datum
	var/list/active_timers //Timer subsystem

// For the Timer subsystem.
/datum/proc/Destroy(force = FALSE)
	var/list/timers = active_timers
	active_timers = null
	for(var/selected_timer in timers)
		var/datum/timed_event/timer = selected_timer
		if (timer.spent)
			continue
		qdel(timer)