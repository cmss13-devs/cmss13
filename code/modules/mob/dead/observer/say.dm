/mob/dead/observer/say(message)
	message = strip_html(message)

	if(!message)
		return

	if(client)
		if(client.prefs?.muted & MUTE_DEADCHAT)
			to_chat(src, SPAN_DANGER("You cannot talk in deadchat (muted)."))
			return

		if(client.handle_spam_prevention(message, MUTE_DEADCHAT))
			return

	if(!filter_message(client, message))
		return

	. = say_dead(message)

/mob/dead/observer/hear_say(message, verb = "says", datum/language/language = null, alt_name = "", italics = 0, mob/speaker = null, sound/speech_sound, sound_vol, message_mode)
	if(!client)
		return

	if(!speaker)
		return

	if(italics && (client.prefs?.toggles_chat & CHAT_GHOSTRADIO) && message_mode)
		return

	if(!speaker.client && (speaker.z != z || get_dist(speaker, src) > GLOB.world_view_size))
		//Does the speaker have a client?  It's either random stuff that observers won't care about (Experiment 97B says, 'EHEHEHEHEHEHEHE')
		//Or someone snoring.  So we make it where they won't hear it.
		return

	var/style = "body"
	var/comm_paygrade = ""

	if(language)
		style = language.color

	var/speaker_name = speaker.name
	if(istype(speaker, /mob/living/carbon/human))
		var/mob/living/carbon/human/human_speaker = speaker
		speaker_name = human_speaker.GetVoice()
		comm_paygrade = human_speaker.get_paygrade()

	if(italics)
		message = "<i>[message]</i>"

	var/track = ""

	if(speaker_name != speaker.real_name && speaker.real_name)
		speaker_name = "[speaker.real_name] ([speaker_name])"
	track = "(<a href='byond://?src=\ref[src];track=\ref[speaker]'>F</a>) "
	if(istype(speaker, /mob/living/carbon/xenomorph/queen))
		var/mob/hologram/queen/queen_eye = speaker.client?.get_eye()
		if(istype(queen_eye))
			track += "(<a href='byond://?src=\ref[src];track=\ref[queen_eye]'>E</a>) "
	if(client.prefs?.toggles_chat & CHAT_GHOSTEARS && speaker.z == z && get_dist(speaker, src) <= GLOB.world_view_size)
		message = "<b>[message]</b>"

	to_chat(src, "<span class='game say'><span class='name'>[comm_paygrade][speaker_name]</span>[alt_name] [track][verb], <span class='message'><span class='[style]'>\"[message]\"</span></span></span>")
	if(speech_sound && speaker.z == z && get_dist(speaker, src) <= GLOB.world_view_size)
		var/turf/source = get_turf(speaker)
		playsound_client(client, speech_sound, source, sound_vol)
