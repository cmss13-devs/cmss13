
// Due to our blatant lack of events, there is no real better solution that isn't worse shitcode.

/datum/round_event_control/nothing_happens
	name = "Nothing Happens!"
	typepath = null
	weight = 150
	earliest_start = 0 MINUTES
	min_players = 1
	max_occurrences = INFINITE_EVENT_OCURRENCES
	alert_observers = FALSE

/datum/round_event_control/nothing_happens/New()
	. = ..()
	for(var/datum/round_event_control/possible_event in subtypesof(/datum/round_event_control))
		if(possible_event.type == src.type)
			break
		src.weight -= possible_event.weight
		// The value of this event is lowered by every other existing event in the game. Remove when we have enough!
