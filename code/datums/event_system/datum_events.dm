/datum/var/list/event_handler = list()

// default_event is a path to a datum of type /datum/event that will set the value of event_handler[category] if it is not initialized
/atom/proc/add_event_handler(var/category, var/datum/event_handler/EH, var/default_event = /datum/event)
	if (isnull(event_handler[category]))
		event_handler[category] = new default_event
	var/datum/event/E = event_handler[category]
	E.add_handler(EH)

/atom/proc/remove_event_handler(var/category, var/datum/event_handler/EH)
	if (isnull(event_handler[category]))
		return
	var/datum/event/E = event_handler[category]
	E.remove_handler(EH)

/atom/proc/event_triggered(var/category, var/datum/event_args/event_args)
	if (isnull(event_handler[category]))
		return
	var/datum/event/E = event_handler[category]
	return E.fire_event(src, event_args)