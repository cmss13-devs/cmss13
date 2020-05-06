/mob/dead/observer/say(var/message)
	message = strip_html(message)

	if (!message)
		return

	log_say("Ghost/[src.key] : [message]")

	if (src.client)
		if(src.client.prefs.muted & MUTE_DEADCHAT)
			to_chat(src, SPAN_DANGER("You cannot talk in deadchat (muted)."))
			return

		if (src.client.handle_spam_prevention(message, MUTE_DEADCHAT))
			return

	. = src.say_dead(message)




/mob/dead/observer/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	if(!client)
		return

	if(speaker && !speaker.client && client.prefs.toggles_chat & CHAT_GHOSTEARS && speaker.z == z && get_dist(speaker, src) <= world.view)
			//Does the speaker have a client?  It's either random stuff that observers won't care about (Experiment 97B says, 'EHEHEHEHEHEHEHE')
			//Or someone snoring.  So we make it where they won't hear it.
		return

	var/style = "body"
	var/comm_paygrade = ""

	if(language)
		style = language.colour

	var/speaker_name = speaker.name
	if(istype(speaker, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = speaker
		speaker_name = H.GetVoice()
		comm_paygrade = H.get_paygrade()

	if(italics)
		message = "<i>[message]</i>"

	var/track = null

	if(italics && client.prefs.toggles_chat & CHAT_GHOSTRADIO)
		return
	if(speaker_name != speaker.real_name && speaker.real_name)
		speaker_name = "[speaker.real_name] ([speaker_name])"
	track = "(<a href='byond://?src=\ref[src];track=\ref[speaker]'>follow</a>) "
	if(client && client.prefs && client.prefs.toggles_chat & CHAT_GHOSTEARS && speaker.z == z && get_dist(speaker, src) <= world.view)
		message = "<b>[message]</b>"

	to_chat(src, "<span class='game say'><span class='name'>[comm_paygrade][speaker_name]</span>[alt_name] [track][verb], <span class='message'><span class='[style]'>\"[message]\"</span></span></span>")
	if (speech_sound && (get_dist(speaker, src) <= world.view && src.z == speaker.z))
		var/turf/source = speaker? get_turf(speaker) : get_turf(src)
		playsound_client(client, speech_sound, source, sound_vol)







/mob/dead/observer/emote(var/act, var/type, var/message)
	message = strip_html(message)

	if(!message)
		return

	if(act != "me")
		return

	log_emote("Ghost/[src.key] : [message]")

	if(src.client)
		if(src.client.prefs.muted & MUTE_DEADCHAT)
			to_chat(src, SPAN_DANGER("You cannot emote in deadchat (muted)."))
			return

		if(src.client.handle_spam_prevention(message, MUTE_DEADCHAT))
			return

	. = src.emote_dead(message)