// At minimum every mob has a hear_say proc.
/mob/proc/hear_apollo()
	return FALSE

/mob/proc/hear_say(message, verb = "says", datum/language/language = null, alt_name = "", italics = 0, mob/speaker = null, sound/speech_sound, sound_vol)

	if(!client && !(mind && mind.current != src))
		return

	var/style = "body"
	var/comm_paygrade = ""

	//non-verbal languages are garbled if you can't see the speaker. Yes, this includes if they are inside a closet.
	if (language && (language.flags & NONVERBAL))
		if (!speaker || (src.sdisabilities & DISABILITY_BLIND || src.blinded) || !(speaker.z == z && get_dist(speaker, src) <= GLOB.world_view_size))
			message = language.scramble(message)

	if(!say_understands(speaker,language))
		if(istype(speaker,/mob/living/simple_animal))
			var/mob/living/simple_animal/S = speaker
			if(length(S.speak))
				message = pick(S.speak)
			else
				message = stars(message)
		else if(language)
			message = language.scramble(message)
		else
			message = stars(message)

	if(language)
		style = language.color

	var/speaker_name = speaker.name
	if(ishuman(speaker) && ishuman(src))
		var/mob/living/carbon/human/H = speaker
		speaker_name = H.GetVoice()
		comm_paygrade = H.get_paygrade()

	if(italics)
		message = "<i>[message]</i>"


	if(sdisabilities & DISABILITY_DEAF || ear_deaf)
		if(speaker == src)
			to_chat(src, SPAN_WARNING("You cannot hear yourself speak!"))
		else
			to_chat(src, SPAN_LOCALSAY("<span class='prefix'>[comm_paygrade][speaker_name]</span>[alt_name] talks but you cannot hear them."))
	else
		to_chat(src, SPAN_LOCALSAY("<span class='prefix'>[comm_paygrade][speaker_name]</span>[alt_name] [verb], <span class='[style]'>\"[message]\"</span>"))
		if (speech_sound && (get_dist(speaker, src) <= GLOB.world_view_size && src.z == speaker.z))
			var/turf/source = speaker? get_turf(speaker) : get_turf(src)
			playsound_client(src.client, speech_sound, source, sound_vol, GET_RANDOM_FREQ)


/mob/proc/hear_radio(
	message, verb="says",
	datum/language/language=null,
	part_a, part_b,
	mob/speaker = null,
	hard_to_hear = 0, vname ="",
	command = 0, no_paygrade = FALSE)

	if(!client && !(mind && mind.current != src))
		return

	var/comm_paygrade = ""

	var/track = null

	var/style = "body"

	//non-verbal languages are garbled if you can't see the speaker. Yes, this includes if they are inside a closet.
	if (language && (language.flags & NONVERBAL))
		if (!speaker || (src.sdisabilities & DISABILITY_BLIND || src.blinded) || !(speaker in view(src)))
			message = stars(message)

	if(!say_understands(speaker,language))
		if(istype(speaker,/mob/living/simple_animal))
			var/mob/living/simple_animal/S = speaker
			message = pick(S.speak)
		else if(language)
			message = language.scramble(message)
		else
			message = stars(message)

	if(language)
		style = language.color

	if(hard_to_hear)
		message = stars(message)

	var/speaker_name = speaker.name

	if(vname)
		speaker_name = vname
		comm_paygrade = ""

	if(!no_paygrade && istype(speaker, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = speaker
		comm_paygrade = H.get_paygrade()
		if(H.voice)
			speaker_name = H.voice


	if(hard_to_hear)
		speaker_name = "unknown"
		comm_paygrade = ""

	if(istype(src, /mob/dead/observer))
		if(speaker_name != speaker.real_name) //Announce computer and various stuff that broadcasts doesn't use it's real name but AI's can't pretend to be other mobs.
			speaker_name = "[speaker.real_name] ([speaker_name])"
		track = "[speaker_name] (<a href='byond://?src=\ref[src];track=\ref[speaker]'>F</a>)"

	var/fontsize_style
	switch(command)
		if(1)
			fontsize_style = "medium"
		if(2)
			fontsize_style = "big"
		if(3)
			fontsize_style = "large"

	if(sdisabilities & DISABILITY_DEAF || ear_deaf)
		if(prob(20))
			to_chat(src, SPAN_WARNING("You feel your headset vibrate but can hear nothing from it!"), type = MESSAGE_TYPE_RADIO)
	else if(track)
		if(!command)
			to_chat(src, "[part_a][comm_paygrade][track][part_b][verb], <span class=\"[style]\">\"[message]\"</span></span></span>", type = MESSAGE_TYPE_RADIO)
		else
			to_chat(src, "<span class=\"[fontsize_style]\">[part_a][comm_paygrade][track][part_b][verb], <span class=\"[style]\">\"[message]\"</span></span></span></span>", type = MESSAGE_TYPE_RADIO)
	else
		if(!command)
			to_chat(src, "[part_a][comm_paygrade][speaker_name][part_b][verb], <span class=\"[style]\">\"[message]\"</span></span></span>", type = MESSAGE_TYPE_RADIO)
		else
			to_chat(src, "<span class=\"[fontsize_style]\">[part_a][comm_paygrade][speaker_name][part_b][verb], <span class=\"[style]\">\"[message]\"</span></span></span></span>", type = MESSAGE_TYPE_RADIO)

/mob/proc/hear_signlang(message, verb = "gestures", datum/language/language, mob/speaker = null)
	var/comm_paygrade = ""
	if(!client)
		return
	if(ishuman(speaker))
		var/mob/living/carbon/human/H = speaker
		comm_paygrade = H.get_paygrade()

	if(say_understands(speaker, language))
		message = "<B>[comm_paygrade][src]</B> [verb], \"[message]\""
	else
		message = "<B>[comm_paygrade][src]</B> [verb]."

	if(src.status_flags & PASSEMOTES)
		for(var/obj/item/holder/H in src.contents)
			H.show_message(message)
		for(var/mob/living/M in src.contents)
			M.show_message(message)
	src.show_message(message)

/mob/living/hear_say(message, verb, datum/language/language, alt_name, italics, mob/speaker, sound/speech_sound, sound_vol)
	if(client && mind && stat == UNCONSCIOUS)
		hear_sleep(speaker, message, src == speaker, Adjacent(speaker), language)
		return
	return ..()

/mob/living/hear_radio(message, verb, datum/language/language, part_a, part_b, mob/speaker, hard_to_hear, vname, command, no_paygrade)
	if(client && mind && stat == UNCONSCIOUS)
		hear_sleep(speaker, message, FALSE, FALSE, language)
		return
	return ..()

/mob/living/proc/hear_sleep(mob/speaker = null, message, hearing_self = FALSE, proximity_flag = FALSE, datum/language/language = null)
	var/heard = ""
	var/clear_char_probability = 90
	if(!say_understands(speaker, language))
		clear_char_probability = 25

	if(sdisabilities & DISABILITY_DEAF || ear_deaf)
		if(speaker == src)
			to_chat(src, SPAN_WARNING("You cannot hear yourself speak!"))
		else
			to_chat(src, SPAN_LOCALSAY("Someone near talks but you cannot hear them."))
		return

	if(hearing_self)
		heard = SPAN_LOCALSAY("You mutter something about... [stars(message, clear_char_probability = 99)]")

	else if(!sleeping && proximity_flag)
		heard = SPAN_LOCALSAY("You hear someone near you say something... [stars(message, clear_char_probability)]")

	else if(prob(15))

		var/list/punctuation = list(",", "!", ".", ";", "?")
		var/list/messages = splittext(message, " ")
		var/R = rand(1, length(messages))
		var/heardword = messages[R]
		if(copytext(heardword,1, 1) in punctuation)
			heardword = copytext(heardword,2)
		if(copytext(heardword,-1) in punctuation)
			heardword = copytext(heardword,1,length(heardword))
		heard = SPAN_LOCALSAY("...You hear something about...[heardword]")

	else
		heard = SPAN_LOCALSAY("...<i>You almost hear someone talking</i>...")

	to_chat(src, heard)
