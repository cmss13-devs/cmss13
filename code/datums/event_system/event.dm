/datum/event
	var/list/handlers = list()
	var/flags_event = NO_FLAGS

/datum/event/proc/fire_event(sender, datum/event_args/event_args)
	var/end_result_tracking = FALSE

	for (var/handle in handlers)
		if (!istype(handle, /datum/event_handler))
			continue
		var/datum/event_handler/h = handle
		var/result = h.handle(sender, event_args)
		if (!end_result_tracking)
			. = result
		if (h.flags_handler & HNDLR_FLAG_SINGLE_FIRE)
			remove_handler(handle)
		if (result)
			if (h.flags_handler & HNDLR_FLAG_END_ON_TRUE && result == TRUE)
				return result
			if (h.flags_handler & HNDLR_FLAG_END_ON_RESULT)
				return result
			if (flags_event & EV_FLAG_PRIORITIZE_TRUE)
				end_result_tracking = TRUE
		else
			if (h.flags_handler & HNDLR_FLAG_END_ON_FALSE)
				return FALSE
			if (flags_event & EV_FLAG_PRIORITIZE_FALSE)
				end_result_tracking = TRUE

/datum/event/proc/add_handler(datum/event_handler/handle)
	if(handle in handlers)
		return
	handlers += handle
	handle.events += src

/datum/event/proc/remove_handler(datum/event_handler/handle)
	if(QDELETED(handle) || !(handle in handlers))
		return

	handlers -= handle // This reference is sometimes keeping it alive, so it gets disposed after it.

	if(!handle)
		return

	handle.events -= src
	for(var/datum/event/ev in handle.events)
		ev.handlers -= src
	qdel(handle)

/datum/event/proc/clean()
	for(var/datum/event_handler/hdl in handlers)
		remove_handler(hdl)

/datum/event/Destroy()
	clean()
	. = ..()

/datum/event/prioritize_false
	flags_event = EV_FLAG_PRIORITIZE_FALSE