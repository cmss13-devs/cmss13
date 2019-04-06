/datum/event
	var/list/handlers = list()

/datum/event/proc/fire_event(sender, datum/event_args/event_args)
	for(var/handle in handlers)
		if(!istype(handle, /datum/event_handler))
			continue
		var/datum/event_handler/h = handle
		var/result = h.handle(sender, event_args)
		if(h.single_fire)
			remove_handler(handle)
		if(result)
			return result

/datum/event/proc/add_handler(datum/event_handler/handle)
	if(!handle in handlers)
		return
	handlers += handle
	handle.events += src

/datum/event/proc/remove_handler(datum/event_handler/handle)
	if(!handle || !handle in handlers)
		return
	
	handlers -= handle
	
	handle.events -= src
	for(var/datum/event/ev in handle.events)
		ev.handlers -= src
	qdel(handle)

/datum/event/proc/clean()
	for(var/datum/event_handler/hdl in handlers)
		remove_handler(hdl)