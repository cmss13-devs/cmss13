/datum/event_handler
	var/list/events = list()
	var/flags_handler = NO_FLAGS

/datum/event_handler/proc/handle(sender, datum/event_args/event_args)
	return FALSE

/datum/event_handler/Dispose()
	for(var/datum/event/E in events)
		E.handlers -= src
	. = ..()