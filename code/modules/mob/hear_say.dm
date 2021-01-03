// At minimum every mob has a hear_say proc.

/mob/proc/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null, var/sound/speech_sound, var/sound_vol)
	if(!client)
		return

	if(sleeping || stat == 1)
		hear_sleep(message)
		return

	var/style = "body"
	var/comm_paygrade = ""

	//non-verbal languages are garbled if you can't see the speaker. Yes, this includes if they are inside a closet.
	if (language && (language.flags & NONVERBAL))
		if (!speaker || (src.sdisabilities & BLIND || src.blinded) || !(speaker.z == z && get_dist(speaker, src) <= world_view_size))
			message = language.scramble(message)

	if(!say_understands(speaker,language))
		if(istype(speaker,/mob/living/simple_animal))
			var/mob/living/simple_animal/S = speaker
			if(S.speak.len)
				message = pick(S.speak)
			else
				message = stars(message)
		else if(language)
			message = language.scramble(message)
		else
			message = stars(message)

	if(language)
		style = language.colour

	var/speaker_name = speaker.name
	if(ishuman(speaker) && ishuman(src))
		var/mob/living/carbon/human/H = speaker
		speaker_name = H.GetVoice()
		comm_paygrade = H.get_paygrade()

	if(italics)
		message = "<i>[message]</i>"

	if(sdisabilities & DEAF || ear_deaf)
		if(speaker == src)
			to_chat(src, SPAN_WARNING("You cannot hear yourself speak!"))
		else
			to_chat(src, SPAN_LOCALSAY("<span class='prefix'>[comm_paygrade][speaker_name]</span>[alt_name] talks but you cannot hear them."))
	else
		to_chat(src, SPAN_LOCALSAY("<span class='prefix'>[comm_paygrade][speaker_name]</span>[alt_name] [verb], <span class='[style]'>\"[message]\"</span>"))
		if (speech_sound && (get_dist(speaker, src) <= world_view_size && src.z == speaker.z))
			var/turf/source = speaker? get_turf(speaker) : get_turf(src)
			playsound_client(src.client, speech_sound, source, sound_vol, GET_RANDOM_FREQ)


/mob/proc/hear_radio(var/message, var/verb="says", var/datum/language/language=null, var/part_a, var/part_b, var/mob/speaker = null, var/hard_to_hear = 0, var/vname ="", var/command = 0)

	if(!client)
		return

	if(sleeping || stat==1) //If unconscious or sleeping
		hear_sleep(message)
		return
	var/comm_paygrade = ""

	var/track = null

	var/style = "body"

	//non-verbal languages are garbled if you can't see the speaker. Yes, this includes if they are inside a closet.
	if (language && (language.flags & NONVERBAL))
		if (!speaker || (src.sdisabilities & BLIND || src.blinded) || !(speaker in view(src)))
			message = stars(message)

	if(!say_understands(speaker,language))
		if(istype(speaker,/mob/living/simple_animal))
			var/mob/living/simple_animal/S = speaker
			message = pick(S.speak)
		else
			message = stars(message)

	if(language)
		style = language.colour

	if(hard_to_hear)
		message = stars(message)

	var/speaker_name = speaker.name

	if(vname)
		speaker_name = vname

	if(istype(speaker, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = speaker
		comm_paygrade = H.get_paygrade()
		if(H.voice)
			speaker_name = H.voice

	if(hard_to_hear)
		speaker_name = "unknown"

	var/changed_voice

	if(isAI(src) && !hard_to_hear)
		var/jobname // the mob's "job"
		var/mob/living/carbon/human/impersonating //The crewmember being impersonated, if any.

		if (ishuman(speaker))
			var/mob/living/carbon/human/H = speaker

			if((H.wear_id && istype(H.wear_id,/obj/item/card/id/syndicate)) && (H.wear_mask && istype(H.wear_mask,/obj/item/clothing/mask/gas/voice)))

				changed_voice = 1
				var/mob/living/carbon/human/I = locate(speaker_name)

				if(I)
					impersonating = I
					jobname = impersonating.get_assignment()
					comm_paygrade = impersonating.get_paygrade()
				else
					jobname = "Unknown"
					comm_paygrade = ""
			else
				jobname = H.get_assignment()
				comm_paygrade = H.get_paygrade()

		else if (iscarbon(speaker)) // Nonhuman carbon mob
			jobname = "No id"
			comm_paygrade = ""
		else if (isAI(speaker))
			jobname = "AI"
			comm_paygrade = ""
		else if (isrobot(speaker))
			jobname = "Cyborg"
			comm_paygrade = ""
		else
			jobname = "Unknown"
			comm_paygrade = ""

		if(changed_voice)
			if(impersonating)
				track = "<a href='byond://?src=\ref[src];trackname=[html_encode(speaker_name)];track=\ref[impersonating]'>[speaker_name] ([jobname])</a>"
			else
				track = "[speaker_name] ([jobname])"
		else
			track = "<a href='byond://?src=\ref[src];trackname=[html_encode(speaker_name)];track=\ref[speaker]'>[speaker_name] ([jobname])</a>"

	if(istype(src, /mob/dead/observer))
		if(speaker_name != speaker.real_name && !isAI(speaker)) //Announce computer and various stuff that broadcasts doesn't use it's real name but AI's can't pretend to be other mobs.
			speaker_name = "[speaker.real_name] ([speaker_name])"
		track = "[speaker_name] (<a href='byond://?src=\ref[src];track=\ref[speaker]'>follow</a>)"

	var/fontsize_style
	switch(command)
		if(1)
			fontsize_style = "medium"
		if(2)
			fontsize_style = "big"
		if(3)
			fontsize_style = "large"

	if(sdisabilities & DEAF || ear_deaf)
		if(prob(20))
			to_chat(src, SPAN_WARNING("You feel your headset vibrate but can hear nothing from it!"))
	else if(track)
		if(!command)
			to_chat(src, "[part_a][comm_paygrade][track][part_b][verb], <span class=\"[style]\">\"[message]\"</span></span></span>")
		else
			to_chat(src, "<span class=\"[fontsize_style]\">[part_a][comm_paygrade][track][part_b][verb], <span class=\"[style]\">\"[message]\"</span></span></span></span>")
	else
		if(!command)
			to_chat(src, "[part_a][comm_paygrade][speaker_name][part_b][verb], <span class=\"[style]\">\"[message]\"</span></span></span>")
		else
			to_chat(src, "<span class=\"[fontsize_style]\">[part_a][comm_paygrade][speaker_name][part_b][verb], <span class=\"[style]\">\"[message]\"</span></span></span></span>")

/mob/proc/hear_signlang(var/message, var/verb = "gestures", var/datum/language/language, var/mob/speaker = null)
	var/comm_paygrade = ""
	if(!client)
		return
	if(ishuman(speaker))
		var/mob/living/carbon/human/H = speaker
		comm_paygrade = H.get_paygrade()

	if(say_understands(speaker, language))
		message = SPAN_EMOTE("<B>[comm_paygrade][src]</B> [verb], \"[message]\"")
	else
		message = SPAN_EMOTE("<B>[comm_paygrade][src]</B> [verb].")

	if(src.status_flags & PASSEMOTES)
		for(var/obj/item/holder/H in src.contents)
			H.show_message(message)
		for(var/mob/living/M in src.contents)
			M.show_message(message)
	src.show_message(message)

/mob/proc/hear_sleep(var/message)
	var/heard = ""
	if(prob(15))
		var/list/punctuation = list(",", "!", ".", ";", "?")
		var/list/messages = splittext(message, " ")
		var/R = rand(1, messages.len)
		var/heardword = messages[R]
		if(copytext(heardword,1, 1) in punctuation)
			heardword = copytext(heardword,2)
		if(copytext(heardword,-1) in punctuation)
			heardword = copytext(heardword,1,length(heardword))
		heard = SPAN_LOCALSAY("<span class = 'game_say'>...You hear something about...[heardword]</span>")

	else
		heard = SPAN_LOCALSAY("<span class = 'game_say'>...<i>You almost hear someone talking</i>...</span>")

	to_chat(src, heard)
