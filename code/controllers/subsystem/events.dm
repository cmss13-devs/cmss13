#define PREPTIME_BEFORE_EVENTS	MINUTES_20
#define MAXIMUM_EXTRA_DELAY	MINUTES_10
#define MAXIMUM_POP_FOR_EXTRA_DELAY 140
#define MINIMUM_POP_FOR_EXTRA_DELAY 80

SUBSYSTEM_DEF(events)
	name     = "Events"
	wait     = MINUTES_1
	flags	 = SS_NO_INIT
	priority = SS_PRIORITY_EVENT

	var/list/events_list
	var/list/lottery
	var/events_run = 0

	var/ready_to_run = FALSE

	var/forced = FALSE

	var/start_time = 0
	var/delay_between_each_event = MINUTES_10
	var/extra_delay_based_on_pop = 0
	var/last_event_time = 0

/datum/controller/subsystem/events/stat_entry(msg)
	msg = "C:[events_run]"
	return ..()

/datum/controller/subsystem/events/Initialize()
	LAZYINITLIST(events_list)

	var/count = 1
	for(var/E in subtypesof(/datum/round_event))
		var/datum/round_event/Ev = new E
		Ev.number = count
		events_list += Ev
		count++

	if(length(events_list))
		ready_to_run = TRUE

	start_time = world.time

	return ..()

/datum/controller/subsystem/events/fire(resumed = FALSE)
	if(((start_time + PREPTIME_BEFORE_EVENTS) > world.time || (last_event_time + delay_between_each_event + extra_delay_based_on_pop) > world.time) && !forced)
		return

	LAZYCLEARLIST(lottery)

	for(var/datum/round_event/E in events_list)
		if(!E.check_prerequisite())
			continue

		for(var/i = 0 to E.tickets)
			if(E.number == 0)
				continue

			LAZYADD(lottery, E.number)

	if(!length(lottery))
		return

	var/lucky_number = pick(lottery)

	last_event_time = world.time
	var/pop_percentage = 1 - Clamp(((length(GLOB.player_list) - MINIMUM_POP_FOR_EXTRA_DELAY) / (MAXIMUM_POP_FOR_EXTRA_DELAY - MINIMUM_POP_FOR_EXTRA_DELAY)), 0, 1)
	extra_delay_based_on_pop = MAXIMUM_EXTRA_DELAY * pop_percentage

	for(var/datum/round_event/E in events_list)
		if(E.number == lucky_number)
			E.activate()
			break

