/datum/event_handler
	var/handler_src
	var/single_fire
	var/list/events = list()

	New(_handler_src, _single_fire = 0)
		handler_src = _handler_src
		single_fire = _single_fire

	proc/handle(sender, datum/event_args/event_args)
		return 0