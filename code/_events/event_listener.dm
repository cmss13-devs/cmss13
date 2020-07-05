/*
	Event listeners are a more general version of hooks. While hooks can only run procs defined on the hook level,
	event listeners allow you to register arbitrary listener callbacks on any datum.

	If you want to register a listener for an event, use registerListener.
	If you want to raise an event, use raiseEvent. Note that event callbacks are invoked asynchronously.
	If you need to raise events synchronously, e.g. because call order is important or it's important that only
	one hook runs at a time, you can use raiseEventSync.

	When raising events synchronously, event listeners can return true to stop execution of the event,
	meaning none of the remaining event listener procs in queue will execute.
	Useful if you
*/

/datum
	var/list/event_listeners

// Dummy datum for handling global events
/datum/global_event_handler
var/global/datum/global_event_handler/GLOBAL_EVENT = new()

// Registers a proc to call when the given event occurs on the given speaker.
/*
	speaker  : The datum to listen for events on. For global events, use GLOBAL_EVENT.
	event    : The name of the event for which you're registering a listener. See #events.dm.
	id       : A unique identifier for the listener. Should be unique for the event-speaker combination you're registering for.
	callback : The callback to execute when the event is raised.
*/
/proc/registerListener(var/datum/speaker, var/event, var/id, var/datum/callback/callback)
	if(!speaker || !istype(speaker))
		CRASH("attempt to register listener for event \"[event]\" but no speaker was given")
		return FALSE

	var/list/event_listeners = LAZYACCESS(speaker.event_listeners, event)
	LAZYINITLIST(event_listeners)

	// No duplicate listener procs
	for(var/datum/callback/C in event_listeners)
		if(C.object == callback.object && C.delegate == callback.delegate)
			return FALSE

	event_listeners[id] = callback
	LAZYSET(speaker.event_listeners, event, event_listeners)
	return TRUE

// Unregisters the listener proc with the given ID on the given speaker for the given event.
/*
	speaker : The datum which the listener is registered on. For global events, use GLOBAL_EVENT
	event   : The name of the event for which you're unregistering the listener. See #events.dm
	id      : The unique identifier of the listener to unregister.
*/
/proc/unregisterListener(var/datum/speaker, var/event, var/id)
	if(!speaker || !istype(speaker))
		CRASH("attempt to unregister listener for event \"[event]\" but no speaker was given")
		return FALSE

	var/list/event_listeners = LAZYACCESS(speaker.event_listeners, event)
	if(!event_listeners)
		return TRUE

	if(LAZYACCESS(event_listeners, id))
		event_listeners[id] = null
		listclearnulls(event_listeners)

	LAZYSET(speaker.event_listeners, event, event_listeners)
	return TRUE

// Raises the event and invokes all the callbacks using the given args.
/*
	speaker : The datum to raise an event on. For global events, use GLOBAL_EVENT.
	event   : The name of the event to raise.
	...     : Arguments to be passed to every invoked listener.
*/
/proc/raiseEvent(var/datum/speaker, var/event, ...)
	if(!speaker || !istype(speaker))
		CRASH("attempt to raise event \"[event]\" but no speaker was given")
		return FALSE

	if(!LAZYLEN(LAZYACCESS(speaker.event_listeners, event)))
		return FALSE

	var/has_arguments = (length(args) > 2)
	for(var/id in speaker.event_listeners[event])
		var/datum/callback/C = speaker.event_listeners[event][id]
		if(isnull(C))
			continue

		if(has_arguments)
			C.InvokeAsync(arglist(args.Copy(3)))
		else
			C.InvokeAsync()
	return TRUE

// Raises the event and invokes all the callbacks SYNCHRONOUSLY using the given args.
// Events that are raised synchronously can return true to stop remaining listeners from executing.
/*
	speaker : The datum to raise an event on. For global events, use GLOBAL_EVENT.
	event   : The name of the event to raise.
	...     : Arguments to be passed to every invoked listener.
*/
/proc/raiseEventSync(var/datum/speaker, var/event, ...)
	if(!speaker || !istype(speaker))
		CRASH("attempt to raise event \"[event]\" but no speaker was given")
		return FALSE

	if(!LAZYLEN(LAZYACCESS(speaker.event_listeners, event)))
		return FALSE

	var/has_arguments = (length(args) > 2)
	for(var/id in speaker.event_listeners[event])
		var/datum/callback/C = speaker.event_listeners[event][id]
		if(isnull(C))
			continue

		var/halt_event = FALSE
		if(has_arguments)
			halt_event = C.Invoke(arglist(args.Copy(3)))
		else
			halt_event = C.Invoke()

		if(halt_event)
			break
	return TRUE