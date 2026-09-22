/mob/living/silicon/say_quote(text)
	var/ending = copytext(text, length(text))

	if (ending == "?")
		return speak_query
	else if (ending == "!")
		return speak_exclamation

	return speak_statement

/mob/living/silicon/say_understands(mob/other, datum/language/speaking = null)
	//These only pertain to common. Languages are handled by mob/say_understands()
	if (!speaking)
		if (istype(other, /mob/living/carbon))
			return 1
		if (isSilicon(other))
			return 1
		if (istype(other, /mob/living/brain))
			return 1
	return ..()

/mob/living/silicon/say(message)
	if (!message)
		return

	if (src.client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, SPAN_DANGER("You cannot send IC messages (muted)."))
			return
		if (src.client.handle_spam_prevention(message,MUTE_IC))
			return

	message = trim(strip_html(message))

	if (stat == 2)
		return say_dead(message)

	if(copytext(message,1,2) == "*")
		if(!findtext(message, "*", 2)) //Second asterisk means it is markup for *bold*, not an *emote.
			return emote(lowertext(copytext(message,2)))

	//Must be conscious to speak
	if (stat)
		return

	var/verb = say_quote(message)

	//parse radio key and consume it
	var/message_mode = parse_message_mode(message, "general")
	if (message_mode)
		if (message_mode == "general")
			message = trim(copytext(message,2))
		else
			message = trim(copytext(message,3))

	//parse language key and consume it
	var/datum/language/speaking = parse_language(message)
	if (speaking)
		verb = speaking.speech_verb
		message = copytext(message,3)

		if(speaking.flags & HIVEMIND)
			speaking.broadcast(src,trim(message))
			return
	else
		message = strip_language(message)

	// Currently used by drones.
	if(local_transmit)
		var/list/listeners = hearers(5,src)
		listeners |= src

		for(var/mob/living/silicon/possible_listening_silicon in listeners)
			if(possible_listening_silicon.client && istype(possible_listening_silicon,src.type))
				to_chat(possible_listening_silicon, "<b>[src]</b> transmits, \"[message]\"")

		for(var/mob/possible_listening_mob in GLOB.player_list)
			if (istype(possible_listening_mob, /mob/new_player))
				continue
			else if((possible_listening_mob.stat == DEAD || isobserver(possible_listening_mob)) && (possible_listening_mob.client?.prefs?.toggles_chat & CHAT_GHOSTEARS))
				if(possible_listening_mob.client)
					to_chat(possible_listening_mob, "<b>[src]</b> transmits, \")[message]\"")
		return

	switch(message_mode)
		if("department")
			return 1
		if("general")
			return 1
		else
			if(message_mode)
				return 1

	return ..(message,speaking,verb)
