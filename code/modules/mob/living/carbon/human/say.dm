/mob/living/carbon/human/proc/parse_say_modes(var/message)
	. = list("message_and_language", "modes" = list())
	if(length(message) >= 1 && message[1] == ";")
		.["message_and_language"] = copytext(message, 2)
		.["modes"] += "headset"
		return

	if(length(message) >= 2 && message[1] == ",")
		// Radio multibroadcast functionality.
		// If a message starts with , we assume that up to MULTIBROADCAST_MAX_CHANNELS
		// next symbols are channel names. If we run into a space we stop looking for more channels.
		var/i
		for(i in 2 to 1 + MULTIBROADCAST_MAX_CHANNELS)
			var/current_channel = message[i]
			if(current_channel == " " || current_channel == ":" || current_channel == ".")
				i--
				break
			.["modes"] += department_radio_keys[":[current_channel]"]
		.["message_and_language"] = copytext(message, i+1)
		var/multibroadcast_cooldown = 0
		for(var/obj/item/device/radio/headset/headset in list(wear_l_ear, wear_r_ear))
			if(world.time - headset.last_multi_broadcast < headset.multibroadcast_cooldown)
				var/cooldown_remaining = (headset.last_multi_broadcast + headset.multibroadcast_cooldown) - world.time
				if(cooldown_remaining > multibroadcast_cooldown)
					multibroadcast_cooldown = cooldown_remaining
			else
				headset.last_multi_broadcast = world.time
		if(multibroadcast_cooldown)
			.["fail_with"] = "You've used the multi-broadcast system too recently, wait [round(multibroadcast_cooldown / 10)] more seconds."
		return

	if(length(message) >= 2 && (message[1] == "." || message[1] == ":"))
		var/channel_prefix = copytext(message, 1, 3)
		if(channel_prefix in department_radio_keys)
			.["message_and_language"] = copytext(message, 3)
			.["modes"] += department_radio_keys[channel_prefix]
			return

	.["message_and_language"] = message
	.["modes"] += MESSAGE_MODE_LOCAL
	return

/mob/living/carbon/human/proc/parse_say(var/message)
	. = list("message", "language", "modes")
	var/list/ml_and_modes = parse_say_modes(message)
	.["modes"] = ml_and_modes["modes"]
	.["fail_with"] = ml_and_modes["fail_with"]
	var/message_and_language = ml_and_modes["message_and_language"]
	var/parsed_language = parse_language(message_and_language)
	if(parsed_language)
		.["language"] = parsed_language
		.["message"] = copytext(message_and_language, 3)
	else
		.["message"] = message_and_language

/mob/living/carbon/human/say(var/message)

	var/verb = "says"
	var/alt_name = ""
	var/message_range = world_view_size
	var/italics = 0

	if(!able_to_speak)
		to_chat(src, SPAN_DANGER("You try to speak, but nothing comes out!"))
		return

	if(client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, SPAN_DANGER("You cannot speak in IC (Muted)."))
			return

	message =  trim(strip_html(message))

	if(stat == 2)
		return say_dead(message)

	if(copytext(message,1,2) == "*")
		return emote(copytext(message,2), 1, null, TRUE) //TRUE arg means emote was caused by player (e.g. no an auto scream when hurt).

	if(name != GetVoice())
		alt_name = "(as [get_id_name("Unknown")])"

	var/list/parsed = parse_say(message)
	var/fail_message = parsed["fail_with"]
	if(fail_message)
		to_chat(src, SPAN_WARNING(fail_message))
		return
	message = parsed["message"]
	var/datum/language/speaking = parsed["language"]
	if(!speaking)
		speaking = get_default_language()

	var/ending = copytext(message, length(message))
	if (speaking)
		// This is broadcast to all mobs with the language,
		// irrespective of distance or anything else.
		if(speaking.flags & HIVEMIND)
			var/hive_prefix = (speaking.name == LANGUAGE_HIVEMIND) ? "XENO" : "WRYN"
			GLOB.STUI.game.Add("\[[time_stamp()]]<font color='#0099FF'>[hive_prefix]: [key_name(src)] : [message]</font><br>")
			GLOB.STUI.processing |= STUI_LOG_GAME_CHAT
			speaking.broadcast(src, trim(message))
			return
		//If we've gotten this far, keep going!
		verb = speaking.get_spoken_verb(ending)
	else
		if(ending=="!")
			verb=pick("exclaims","shouts","yells")
		if(ending=="?")
			verb="asks"

	if (istype(wear_mask, /obj/item/clothing/mask/muzzle))
		return

	message = capitalize(trim(message))
	message = process_chat_markup(message, list("~", "_"))

	if(speech_problem_flag)
		var/list/handle_r = handle_speech_problems(message)
		message = handle_r[1]
		verb = handle_r[2]
		speech_problem_flag = handle_r[3]

	if(!message || stat)
		return

	// Automatic punctuation
	if(client && client.prefs && client.prefs.toggle_prefs & TOGGLE_AUTOMATIC_PUNCTUATION)
		if(!(copytext(message, -1) in ENDING_PUNCT))
			message += "."

	for(var/message_mode in parsed["modes"])
		var/list/obj/item/used_radios = list()
		switch(message_mode)
			if(MESSAGE_MODE_LOCAL)
			if("whisper")
				whisper_say(message, speaking, alt_name)
				return
			if("intercom")
				message_mode = null
				for(var/obj/item/device/radio/intercom/I in view(1))
					used_radios += I
					break // remove this if we EVER have two different intercomms with DIFFERENT frequencies IN ONE ROOM
			else
				var/earpiece = get_type_in_ears(/obj/item/device/radio)
				if(earpiece)
					used_radios += earpiece

		var/sound/speech_sound
		var/sound_vol
		if(species?.speech_sounds && prob(species.speech_chance))
			speech_sound = sound(pick(species.speech_sounds))
			sound_vol = 70

		//speaking into radios
		if(length(used_radios))
			GLOB.STUI.game.Add("\[[time_stamp()]]<font color='#FF0000'>RADIO: [key_name(src)] : [message]</font><br>")
			GLOB.STUI.processing |= STUI_LOG_GAME_CHAT
			if (speech_sound)
				sound_vol *= 0.5

			for(var/mob/living/M in hearers(message_range, src))
				if(M != src)
					M.show_message(SPAN_NOTICE("[src] talks into [used_radios.len ? used_radios[1] : "the radio."]"))
			if(isHumanSynthStrict(src))
				playsound(src.loc, 'sound/effects/radiostatic.ogg', 15, 1)

			italics = 1
			message_range = 2

		..(message, speaking, verb, alt_name, italics, message_range, speech_sound, sound_vol, 0, message_mode)	//ohgod we should really be passing a datum here.

		INVOKE_ASYNC(src, /mob/living/carbon/human.proc/say_to_radios, used_radios, message, message_mode, verb, speaking)

/mob/living/carbon/human/proc/say_to_radios(used_radios, message, message_mode, verb, speaking)
	for(var/obj/item/device/radio/R in used_radios)
		R.talk_into(src, message, message_mode, verb, speaking)

/mob/living/carbon/human/proc/forcesay(var/forcesay_type = SUDDEN)
	if (!client || stat != CONSCIOUS)
		return

	var/say_text = winget(client, "input", "text")
	if (length(say_text) < 8)
		return

	var/regex/say_regex = regex("say \"(;|:)*", "i")
	say_text = say_regex.Replace(say_text, "")

	switch (forcesay_type)
		if (SUDDEN)
			say_text += "-"
		if (GRADUAL)
			say_text += "..."
		if (PAINFUL)
			say_text += pick("-OW!", "-UGH!", "-ACK!")
		if (EXTREMELY_PAINFUL)
			say_text += pick("-AAAGH!", "-AAARGH!", "-AAAHH!")

	say(say_text)
	winset(client, "input", "text=[null]")

/mob/living/carbon/human/say_understands(var/mob/other,var/datum/language/speaking = null)

	if(species.can_understand(other))
		return 1

	//These only pertain to common. Languages are handled by mob/say_understands()
	if (!speaking)
		if (isSilicon(other))
			return 1
		if (istype(other, /mob/living/brain))
			return 1

	//This is already covered by mob/say_understands()
	//if (istype(other, /mob/living/simple_animal))
	//	if((other.universal_speak && !speaking) || src.universal_speak || src.universal_understand)
	//		return 1
	//	return 0

	return ..()

/mob/living/carbon/human/GetVoice()
	return real_name

/mob/living/carbon/human/proc/SetSpecialVoice(var/new_voice)
	if(new_voice)
		special_voice = new_voice
	return

/mob/living/carbon/human/proc/UnsetSpecialVoice()
	special_voice = ""
	return

/mob/living/carbon/human/proc/GetSpecialVoice()
	return special_voice


/*
   ***Deprecated***
   let this be handled at the hear_say or hear_radio proc
   This is left in for robot speaking when humans gain binary channel access until I get around to rewriting
   robot_talk() proc.
   There is no language handling build into it however there is at the /mob level so we accept the call
   for it but just ignore it.
*/

/mob/living/carbon/human/say_quote(var/message, var/datum/language/speaking = null)
	var/verb = "says"
	var/ending = copytext(message, length(message))

	if(speaking)
		verb = speaking.get_spoken_verb(ending)
	else
		if(ending == "!")
			verb=pick("exclaims","shouts","yells")
		else if(ending == "?")
			verb="asks"

	return verb

/mob/living/carbon/human/proc/handle_speech_problems(var/message)
	var/list/returns[3]
	var/verb = "says"
	var/handled = 0
	if(silent)
		message = ""
		handled = 1
	if(sdisabilities & DISABILITY_MUTE)
		message = ""
		handled = 1
	if(wear_mask)
		if(istype(wear_mask, /obj/item/clothing/mask/horsehead))
			var/obj/item/clothing/mask/horsehead/hoers = wear_mask
			if(hoers.voicechange)
				message = pick("NEEIIGGGHHHH!", "NEEEIIIIGHH!", "NEIIIGGHH!", "HAAWWWWW!", "HAAAWWW!")
				verb = pick("whinnies","neighs", "says")
				handled = 1

	if(slurring)
		message = slur(message)
		verb = pick("stammers","stutters")
		handled = 1
	if(stuttering)
		message = NewStutter(message)
		verb = pick("stammers", "stutters")
		handled = 1
	if(dazed)
		message = DazedText(message)
		verb = pick("mumbles", "babbles")
		handled = 1
	var/braindam = getBrainLoss()
	if(braindam >= 60)
		handled = 1
		if(prob(braindam/4))
			message = stutter(message)
			verb = pick("stammers", "stutters")
		if(prob(braindam))
			message = uppertext(message)
			verb = pick("yells like an idiot","says rather loudly")

	returns[1] = message
	returns[2] = verb
	returns[3] = handled

	return returns

/mob/living/carbon/human/binarycheck()
	var/obj/item/device/radio/headset/dongle = get_type_in_ears(/obj/item/device/radio/headset)
	if (dongle && dongle.translate_binary)
		return TRUE
	return FALSE
