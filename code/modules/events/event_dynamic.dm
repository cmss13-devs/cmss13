var/list/event_last_fired = list()

//Always triggers an event when called, dynamically chooses events based on job population
/proc/spawn_dynamic_event()
	if(!config.allow_random_events)
		return

	//var/minutes_passed = world.time/600

	var/list/active_with_role = number_active_with_role()

	//Maps event names to event chances
	//For each chance, 100 represents "normal likelihood", anything below 100 is "reduced likelihood", anything above 100 is "increased likelihood"
	//Events have to be manually added to this proc to happen
	var/list/possibleEvents = list()

	possibleEvents[/datum/event/carp_migration] = 20 + 10 * active_with_role["Engineer"]
	possibleEvents[/datum/event/brand_intelligence] = 20 + 25 * active_with_role["Janitor"]

	possibleEvents[/datum/event/rogue_drone] = 5 + 25 * active_with_role["Engineer"] + 25 * active_with_role["Security"]

	possibleEvents[/datum/event/communications_blackout] = 50 + 25 * active_with_role["AI"] + active_with_role["Scientist"] * 25
	possibleEvents[/datum/event/electrical_storm] = 15 * active_with_role["Janitor"] + 5 * active_with_role["Engineer"]

	for(var/event_type in event_last_fired) if(possibleEvents[event_type])
		var/time_passed = world.time - event_last_fired[event_type]
		var/full_recharge_after = 60 * 60 * 10 * 3 //3 hours
		var/weight_modifier = max(0, (full_recharge_after - time_passed) / 300)

		possibleEvents[event_type] = max(possibleEvents[event_type] - weight_modifier, 0)

	var/picked_event = pickweight(possibleEvents)
	event_last_fired[picked_event] = world.time

	//Debug code below here, very useful for testing so don't delete please.
	var/debug_message = "Firing random event. "
	for(var/V in active_with_role)
		debug_message += "#[V]:[active_with_role[V]] "
	debug_message += "||| "
	for(var/V in possibleEvents)
		debug_message += "[V]:[possibleEvents[V]]"
	debug_message += "|||Picked:[picked_event]"
	log_debug(debug_message)

	if(!picked_event)
		return

	//The event will add itself to the MC's event list and start working via the constructor.
	new picked_event

	return 1

//Returns how many characters are currently active (not logged out, not AFK for more than 10 minutes) with a specific role.
//Note that this isn't sorted by department, because e.g. having a roboticist shouldn't make meteors spawn.
/proc/number_active_with_role(role)
	var/list/active_with_role = list()
	active_with_role["Engineer"] = 0
	active_with_role["Medical"] = 0
	active_with_role["AI"] = 0
	active_with_role["Cyborg"] = 0

	for(var/mob/M in player_list)
		if(!M.mind || !M.client || M.client.inactivity > 10 * 10 * 60) //Longer than 10 minutes AFK counts them as inactive
			continue

		if(isrobot(M) && M:module && M:module.name == "engineering robot module")
			active_with_role["Engineer"]++

		if(M.job in list("Chief Engineer", "Maintenance Tech"))
			active_with_role["Engineer"]++

		if(isrobot(M) && M:module && M:module.name == "medical robot module")
			active_with_role["Medical"]++
		if(M.job in list("Chief Medical Officer", "Doctor", "Researcher", "Sulaco Chemist"))
			active_with_role["Medical"]++

		if(M.job == "AI")
			active_with_role["AI"]++

		if(M.job == "Cyborg")
			active_with_role["Cyborg"]++

	return active_with_role
