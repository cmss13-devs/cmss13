
// Due to our blatant lack of events, there is no real better solution that isn't worse shitcode.
// Lower this value by like, 10 or maybe your new event's value when a new event is added.

/datum/round_event_control/nothing_happens
	name = "Nothing Happens!"
	typepath = null
	weight = 150
	earliest_start = 0 MINUTES
	min_players = 1
	max_occurrences = INFINITE_EVENT_OCURRENCES
	alert_observers = FALSE
