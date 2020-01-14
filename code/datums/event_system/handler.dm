/datum/event_handler
	var/single_fire
	var/list/events = list()

/datum/event_handler/New(_single_fire = 0)
	single_fire = _single_fire

/datum/event_handler/proc/handle(sender, datum/event_args/event_args)
	return 0

/datum/event_handler/Dispose()
	for(var/datum/event/E in events)
		E.handlers -= src
	. = ..()