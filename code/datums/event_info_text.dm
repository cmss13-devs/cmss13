/datum/custom_event_info
	var/name = "default"
	var/code_identificator
	var/datum/faction/faction
	var/msg = ""

/datum/custom_event_info/New(datum/faction/_faction, _name, _code_identificator)
	if(_faction)
		name = _faction.name
		faction = _faction

	if(_name)
		name = _name

	code_identificator = _code_identificator

/datum/custom_event_info/Destroy(force, ...)
	if(code_identificator)
		GLOB.custom_event_info_list[code_identificator] = null

	if(faction)
		faction = null

	. = ..()

//this shows event info to player. can pass clients and mobs
/datum/custom_event_info/proc/show_player_event_info(client/user)
	if(!istype(user))
		return

	if(msg == "")
		to_chat(user, SPAN_WARNING("For [name] not found special event message."))
		return

	var/dat
	dat = "<h1 class='alert'>[name] Event Message</h1>"
	dat += "<h2 class='alert'>A custom event is in process. OOC Info:</h2>"
	dat += SPAN_ALERT("[msg]<br>")
	to_chat(user, dat)
	return

//this shows changed event info to everyone in the category
/datum/custom_event_info/proc/handle_event_info_update()
	if(!msg)
		return

	if(!faction)
		var/dat = "<h1 class='alert'>Global Event Message</h1>"
		dat += "<h2 class='alert'>A custom event is in process. OOC Info:</h2>"
		dat += SPAN_ALERT("[msg]<br>")
		to_world(dat)
	else
		for(var/mob/creature in faction.total_mobs)
			show_player_event_info(creature.client)

/proc/check_event_info(category = "glob", client/user)
	if(GLOB.custom_event_info_list[category])
		var/datum/custom_event_info/event_info = GLOB.custom_event_info_list[category]
		if(event_info.msg)
			event_info.show_player_event_info(user)
