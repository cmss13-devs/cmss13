/datum/custom_event_info
	var/faction = "default"		//here category/faction/hive name stored
	var/msg = ""			//here is the message itself


//this shows event info to player. can pass clients and mobs
/datum/custom_event_info/proc/show_player_event_info(var/user)

	if(!istype(user, /client))
		if(ismob(user))
			var/mob/M = user
			if(!M.client)
				return
		else
			return

	if(msg == "")
		to_chat(user, SPAN_WARNING("No [faction] custom event message has been found. Either no custom event is taking place, admin hasn't properly set this or deemed it unnecessary to be set."))
		return

	var/dat
	dat = "<h1 class='alert'>[faction] Event Message</h1>"
	dat += "<h2 class='alert'>A custom event is in process. OOC Info:</h2>"
	dat += SPAN_ALERT("[msg]<br>")
	to_chat(user, dat)
	return

//this shows changed event info to everyone in the category
/datum/custom_event_info/proc/handle_event_info_update()

	if(!msg)
		return

	if(faction == "Global")
		var/dat = "<h1 class='alert'>[faction] Event Message</h1>"
		dat += "<h2 class='alert'>A custom event is in process. OOC Info:</h2>"
		dat += SPAN_ALERT("[msg]<br>")
		to_world(dat)
		return

	else if(faction in FACTION_LIST_HUMANOID)
		for(var/mob/M in GLOB.human_mob_list)
			if(M && M.faction == faction)
				show_player_event_info(M)
		return

	else
		var/datum/hive_status/hive
		for(var/hivenumber in GLOB.hive_datum)
			hive = GLOB.hive_datum[hivenumber]
			if(hive.name == faction)
				for(var/mob/M in hive.totalXenos)
					show_player_event_info(M)
				return

	message_staff("ERROR, ([faction ? faction : "name lost"]) faction is not found for event info.")
	return

/mob/proc/check_event_info(var/category = "Global")
	if(GLOB.custom_event_info_list[category])
		var/datum/custom_event_info/CEI = GLOB.custom_event_info_list[category]
		if(CEI.msg)
			CEI.show_player_event_info(src)
