/datum/component/tackle_counter
	var/tackles = 0
	var/reset_timer

/datum/component/tackle_counter/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	reset_timer = addtimer(CALLBACK(src, PROC_REF(reset_tackle)), 4 SECONDS, TIMER_UNIQUE | TIMER_STOPPABLE)
	RegisterSignal(parent, COMSIG_LIVING_SET_BODY_POSITION, PROC_REF(tackle_handle_lying_changed))

/datum/component/tackle_counter/proc/tackle_handle_lying_changed(mob/living/target, body_position)
	SIGNAL_HANDLER
	if(body_position != LYING_DOWN)
		return

	// Infected mobs do not have their tackle counter reset if
	// they get knocked down or get up from a knockdown
	if(target.status_flags & XENO_HOST)
		return

	reset_tackle()

/datum/component/tackle_counter/proc/reset_tackle()
	UnregisterSignal(parent, COMSIG_LIVING_SET_BODY_POSITION)
	qdel(src)

/datum/component/tackle_counter/proc/tackle()
	tackles++
	deltimer(reset_timer)
	reset_timer = addtimer(CALLBACK(src, PROC_REF(reset_tackle)), 4 SECONDS, TIMER_UNIQUE | TIMER_STOPPABLE)
