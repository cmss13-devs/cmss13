/mob/living/carbon/Xenomorph/emote(var/act, var/m_type = 1, var/message = null, player_caused)
	if(findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		act = copytext(act, 1, t1)

	if(stat && act != "help")
		return

	switch(act)
		if("me")
			if(silent)
				return
			if(player_caused)
				if(client)
					if (client.prefs.muted & MUTE_IC)
						to_chat(src, SPAN_WARNING("You cannot send IC messages (muted)"))
						return
					if(client.handle_spam_prevention(message, MUTE_IC))
						return
			if(stat)
				return
			if(!message)
				return
			return custom_emote(m_type, message, player_caused)

		if("custom")
			return custom_emote(m_type, message, player_caused)

		if("growl")
			if(isXenoPredalien(src))
				emote_audio_helper("<B>The [name]</B> growls.", 'sound/voice/predalien_growl.ogg', 25, player_caused)
				return

			emote_audio_helper("<B>The [name]</B> growls.", "alien_growl", player_caused = player_caused)
			return

		if("hiss")
			if(isXenoPredalien(src))
				emote_audio_helper("<B>The [name]</B> hisses.", 'sound/voice/predalien_hiss.ogg', 25, player_caused)
				return

			emote_audio_helper("<B>The [name]</B> hisses.", "alien_hiss", player_caused = player_caused)
			return

		if("needhelp")
			emote_audio_helper("<B>The [name]</B> needs help!", "alien_help", 25, player_caused)
			return		

		if("roar")
			if(isXenoPredalien(src))
				emote_audio_helper("<B>The [name]</B> roars!", 'sound/voice/predalien_roar.ogg', 40, player_caused)
				return

			emote_audio_helper("<B>The [name]</B> roars!", "alien_roar", 40, player_caused)
			return	

		if("tail")
			emote_audio_helper("<B>The [name]</B> swipes its tail.", "alien_tail_swipe", 40, player_caused)
			return

		if("dance")
			if(!is_mob_restrained())
			//	message = "<B>The [name]</B> dances around!"
				m_type = 1
				spawn(0)
					for(var/i in list(1,2,4,8,4,2,1,2,4,8,4,2,1,2,4,8,4,2,1,2,4,8,4,2,1,2,4,8,4,2,1,2,4,8,4,2,1,2,4,8,4,2,1,2))
						canmove = 0
						dir = i
						sleep(1)
				canmove = 1

		if("help")
			to_chat(src, "<br><br><b>To use an emote, type an asterix (*) before a following word. Emotes with a sound are <span style='color: green;'>green</span>. Spamming emotes with sound will likely get you banned. Don't do it.<br><br>\
			dance, \
			<span style='color: green;'>growl</span>, \
			<span style='color: green;'>hiss</span>, \
			me, \
			<span style='color: green;'>needhelp</span>, \
			<span style='color: green;'>roar</span>, \
			<span style='color: green;'>tail</span>, \
			</b><br>")
		else
			to_chat(src, text("Invalid Emote: []", act))

	if(message)
		log_emote("[name]/[key] : [message]")
		if(m_type & 1)
			for(var/mob/O in viewers(src, null))
				O.show_message(message, m_type)
		else
			for(var/mob/O in hearers(src, null))
				O.show_message(message, m_type)

/mob/living/carbon/Xenomorph/proc/emote_audio_helper(var/message, var/sound_to_play, var/volume = 15, var/player_caused)
	if(recent_audio_emote && player_caused)
		to_chat(src, "You just did an audible emote. Wait a while.")
		return
	
	playsound(loc, sound_to_play, volume)

	if(player_caused)
		start_audio_emote_cooldown()

	log_emote("[name]/[key] : [message]")
	for(var/mob/O in hearers(src, null))
		O.show_message(message, 2)


/mob/living/carbon/Xenomorph/Larva/emote(var/act, var/m_type = 1, var/message = null, player_caused)
	if(findtext(act, "-", 1, null))
		var/t1 = findtext(act, "-", 1, null)
		act = copytext(act, 1, t1)

	if(stat && act != "help")
		return

	playsound(loc, "alien_roar_larva", 15)
	return