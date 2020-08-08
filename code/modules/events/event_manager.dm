var/list/allEvents = typesof(/datum/event) - /datum/event

var/eventTimeLower = MINUTES_20	//20 minutes
var/eventTimeUpper = MINUTES_40	//40 minutes
var/scheduledEvent = null

/proc/checkEvent()
	if(!scheduledEvent)
		//more players = more time between events, less players = less time between events
		var/playercount_modifier = 1
		switch(player_list.len)
			if(0 to 10)
				playercount_modifier = 1.2
			if(11 to 15)
				playercount_modifier = 1.1
			if(16 to 25)
				playercount_modifier = 1
			if(26 to 35)
				playercount_modifier = 0.9
			if(36 to 100000)
				playercount_modifier = 0.8

		var/next_event_delay = rand(eventTimeLower, eventTimeUpper) * playercount_modifier
		scheduledEvent = world.timeofday + next_event_delay
		log_debug("Next event in [next_event_delay/MINUTES_1] minutes.")

	else if(world.timeofday > scheduledEvent)
		spawn_dynamic_event()

		scheduledEvent = null
		checkEvent()

/client/proc/forceEvent(var/type in allEvents)
	set name = "Trigger Event (Debug Only)"
	set category = "Debug"
	if(alert("Are you sure you want to do this?",, "Yes", "No") == "No") return
	if(!admin_holder)
		return

	if(ispath(type))
		new type
		message_staff("[key_name_admin(usr)] has triggered an event. ([type])", 1)
