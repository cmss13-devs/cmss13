/mob/proc/say()
	return

/mob/verb/whisper()
	set name = "Whisper"
	set category = "IC"
	return

/mob
	var/picksay_cooldown = 0

/mob/verb/picksay_verb(message as text)
	set name = "Pick-Say"
	set category = "IC"

	if(picksay_cooldown > world.time)
		return

	var/list/possible_phrases = splittext(message, ";")
	if(length(possible_phrases))
		say_verb(pick(possible_phrases))
		picksay_cooldown = world.time + 1.5 SECONDS

/mob/verb/say_verb(message as text)
	set name = "Say"
	set category = "IC"

	if(usr.talked == 2)
		to_chat(usr, SPAN_DANGER("Your spam has been consumed for its nutritional value."))
		return
	if((usr.talked == 1) && (usr.chatWarn >= 5))
		usr.talked = 2
		to_chat(usr, SPAN_DANGER("You have been flagged for spam.  You may not speak for at least [usr.chatWarn] seconds (if you spammed alot this might break and never unmute you).  This number will increase each time you are flagged for spamming"))
		if(usr.chatWarn >= 5)
			message_staff("[key_name(usr, usr.client)] is spamming like crazy. Their current chatwarn is [usr.chatWarn]. ")
		addtimer(CALLBACK(usr, .proc/clear_chat_spam_mute, usr.talked, TRUE, TRUE), usr.chatWarn * CHAT_SAY_DELAY_SPAM, TIMER_UNIQUE)
		return
	else if(usr.talked == 1)
		to_chat(usr, SPAN_NOTICE("You just said something, take a breath."))
		usr.chatWarn++
		return

	set_typing_indicator(0)
	usr.say(message)
	usr.talked = 1
	addtimer(CALLBACK(usr, .proc/clear_chat_spam_mute, usr.talked), CHAT_SAY_DELAY, TIMER_UNIQUE)

/mob/verb/me_verb(message as text)
	set name = "Me"
	set category = "IC"

	if(usr.talked == 2)
		to_chat(usr, SPAN_DANGER("Your spam has been consumed for it's nutritional value."))
		return
	if(((usr.talked == 1) && (usr.chatWarn >= 5)) || length(message) > MAX_EMOTE_LEN)
		usr.talked = 2
		to_chat(usr, SPAN_DANGER("You have been flagged for spam.  You may not speak for at least [usr.chatWarn] seconds (if you spammed alot this might break and never unmute you).  This number will increase each time you are flagged for spamming"))
		if(usr.chatWarn >= 5)
			message_staff("[key_name(usr, usr.client)] is spamming like crazy. Their current chatwarn is [usr.chatWarn]. ")
		addtimer(CALLBACK(usr, .proc/clear_chat_spam_mute, usr.talked, TRUE, TRUE), usr.chatWarn * CHAT_SAY_DELAY_SPAM, TIMER_UNIQUE)
		return
	else if(usr.talked == 1)
		to_chat(usr, SPAN_NOTICE(" You just said something, take a breath."))
		usr.chatWarn++
		return

	message = trim(strip_html(message, MAX_EMOTE_LEN))

	set_typing_indicator(0)
	if(use_me)
		usr.emote("me",usr.emote_type,message, TRUE)
	else
		usr.emote(message, 1, null, TRUE)
	usr.talked = 1
	addtimer(CALLBACK(usr, .proc/clear_chat_spam_mute, usr.talked), CHAT_SAY_DELAY, TIMER_UNIQUE)

/mob/proc/say_dead(var/message)
	var/name = src.real_name

	if(usr.talked == 2)
		to_chat(usr, SPAN_DANGER("Your spam has been consumed for it's nutritional value."))
		return
	if((usr.talked == 1) && (usr.chatWarn >= 5))
		usr.talked = 2
		to_chat(usr, SPAN_DANGER("You have been flagged for spam.  You may not speak for at least [usr.chatWarn] seconds (if you spammed alot this might break and never unmute you).  This number will increase each time you are flagged for spamming"))
		if(usr.chatWarn >10)
			message_staff("[key_name(usr, usr.client)] is spamming like a dirty bitch, their current chatwarn is [usr.chatWarn]. ")
		addtimer(CALLBACK(usr, .proc/clear_chat_spam_mute, usr.talked, TRUE, TRUE), usr.chatWarn * CHAT_SAY_DELAY_SPAM, TIMER_UNIQUE)
		return
	else if(usr.talked == 1)
		to_chat(usr, SPAN_NOTICE(" You just said something, take a breath."))
		usr.chatWarn++
		return

	if(!src.client) //Somehow
		return

	if(!src.client.admin_holder || !(client.admin_holder.rights & R_MOD))
		if(!dsay_allowed)
			to_chat(src, SPAN_DANGER("Deadchat is globally muted"))
			return

	if(client && client.prefs && !(client.prefs.toggles_chat & CHAT_DEAD))
		to_chat(usr, SPAN_DANGER("You have deadchat muted."))
		return

	for(var/mob/M in GLOB.player_list)
		if(istype(M, /mob/new_player))
			continue
		if(M.client && (M.stat == DEAD || isobserver(M)) && M.client.prefs && (M.client.prefs.toggles_chat & CHAT_DEAD))
			to_chat(M, "<span class='game deadsay'><span class='prefix'>DEAD:</span> <span class='name'>[name] (<a href='byond://?src=\ref[M];track=\ref[src]'>F</a>)</span> says, <span class='message'>\"[message]\"</span></span>")
			continue

		if(M.client && M.client.admin_holder && (M.client.admin_holder.rights & R_MOD) && M.client.prefs && (M.client.prefs.toggles_chat & CHAT_DEAD) ) // Show the message to admins/mods with deadchat toggled on
			to_chat(M, "<span class='game deadsay'><span class='prefix'>DEAD:</span> <span class='name'>[name]</span> says, <span class='message'>\"[message]\"</span></span>")	//Admins can hear deadchat, if they choose to, no matter if they're blind/deaf or not.

	usr.talked = 1
	addtimer(CALLBACK(usr, .proc/clear_chat_spam_mute, usr.talked), CHAT_SAY_DELAY, TIMER_UNIQUE)

/mob/proc/say_understands(var/mob/other,var/datum/language/speaking = null)
	if (src.stat == 2)		//Dead
		return 1

	//Universal speak makes everything understandable, for obvious reasons.
	else if(src.universal_speak || src.universal_understand)
		return 1

	//Languages are handled after.
	if (!speaking)
		if(!other)
			return 1
		if(other.universal_speak)
			return 1
		if(isAI(src))
			return 1
		if (istype(other, src.type) || istype(src, other.type))
			return 1
		return 0

	//Language check.
	for(var/datum/language/L in src.languages)
		if(speaking.name == L.name)
			return 1

	return 0

/*
   ***Deprecated***
   let this be handled at the hear_say or hear_radio proc
   This is left in for robot speaking when humans gain binary channel access until I get around to rewriting
   robot_talk() proc.
   There is no language handling build into it however there is at the /mob level so we accept the call
   for it but just ignore it.
*/

/mob/proc/say_quote(var/message, var/datum/language/speaking = null)
        var/verb = "says"
        var/ending = copytext(message, length(message))
        if(ending=="!")
                verb=pick("exclaims","shouts","yells")
        else if(ending=="?")
                verb="asks"

        return verb


/mob/proc/emote(var/act, var/type, var/message, player_caused)
	if(act == "me")
		return custom_emote(type, message, player_caused)

/mob/proc/get_ear()
	// returns an atom representing a location on the map from which this
	// mob can hear things

	// should be overloaded for all mobs whose "ear" is separate from their "mob"

	return get_turf(src)

/mob/proc/say_test(var/text)
	var/ending = copytext(text, length(text))
	if (ending == "?")
		return "1"
	else if (ending == "!")
		return "2"
	return "0"

//parses the message mode code (e.g. :h, :w) from text, such as that supplied to say.
//returns the message mode string or null for no message mode.
//standard mode is the mode returned for the special ';' radio code.
/mob/proc/parse_message_mode(var/message, var/standard_mode="headset")
	if(length(message) >= 1 && copytext(message,1,2) == ";")
		return standard_mode

	if(length(message) >= 2)
		var/channel_prefix = copytext(message, 1 ,3)
		return department_radio_keys[channel_prefix]

	return null

//parses the language code (e.g. :j) from text, such as that supplied to say.
//returns the language object only if the code corresponds to a language that src can speak, otherwise null.
/mob/proc/parse_language(var/message)
	if(length(message) >= 2)
		var/language_prefix = lowertext(copytext(message, 1 ,3))
		var/datum/language/L = GLOB.all_languages[GLOB.language_keys[language_prefix]]
		if (can_speak(L))
			return L

	return null
