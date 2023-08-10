
// Due to our blatant lack of events, there is no real better solution that isn't worse shitcode.

/datum/round_event_control/nothing_happens
	name = "Nothing Happens!"
	typepath = /datum/round_event/nothing_happens
	weight = 160
	earliest_start = 0 MINUTES
	min_players = 1
	max_occurrences = INFINITE_EVENT_OCURRENCES
	alert_observers = FALSE

/datum/round_event_control/nothing_happens/New()
	. = ..()
	for(var/datum/round_event_control/possible_event_type as anything in typesof(/datum/round_event_control))
		if(possible_event_type == src.type)
			break
		src.weight -= initial(possible_event_type.weight)
		// The value of this event is lowered by every other existing event in the game. Remove when we have enough!

/datum/round_event/nothing_happens
