
/client/proc/attempt_talking(text)
	// Cooldown and budget handling
	var/elapsed = world.time - src.talked_at
	var/cpm_budget = elapsed / (60 SECONDS) * CHAT_CPM_ALLOWED
	src.talked_sum = max(0, src.talked_sum - cpm_budget)
	// Figure out how much we can say
	var/max_budget = CHAT_CPM_PERIOD / (60 SECONDS) * CHAT_CPM_ALLOWED
	var/cost = max(CHAT_CPM_MINIMUM, length(text))
	src.talked_at = world.time
	if(src.talked_sum + cost > max_budget)
		to_chat(src, SPAN_NOTICE("Вы слишком много болтаете."))
		return FALSE
	src.talked_sum += cost
	return TRUE

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

/* //CM Old
/mob/verb/say_verb(message as text)
	set name = "Say"
	set category = "IC"

	if(!client?.attempt_talking(message))
		return

	usr.say(message)

/mob/verb/me_verb(message as text)
	set name = "Me"
	set category = "IC"

	message = trim(strip_html(message, MAX_EMOTE_LEN))
	if(!client?.attempt_talking(message))
		return

	if(use_me)
		usr.emote("me",usr.emote_type,message, TRUE)
	else
		usr.emote(message, 1, null, TRUE)
*/
/mob/verb/say_verb(message as text)
	set name = "Say"
	set category = "IC"

	if(!client?.attempt_talking(message))
		return

	if(message)	//RUCM START
		if(stat != DEAD)
			if(GLOB.ic_autoemote[message])
				message = "*[GLOB.ic_autoemote[message]]" // возврат автокоррекции эмоутов params2list
			message = check_for_brainrot(message)	//RUCM END
		usr.say(message)

/mob/verb/me_verb(message as text)
	set name = "Me"
	set category = "IC"

	message = trim(strip_html(message, MAX_EMOTE_LEN))
	if(!client?.attempt_talking(message))
		return

	if(message)	//RUCM START
		message = check_for_brainrot(message)	//RUCM END
		if(use_me)
			usr.emote("me",usr.emote_type,message, TRUE)
		else
			usr.emote(message, 1, null, TRUE)

/mob/proc/say_dead(message)
	var/name = src.real_name

	if(!src.client) //Somehow
		return

	if(!src.client.admin_holder || !(client.admin_holder.rights & R_MOD))
		if(!GLOB.dsay_allowed)
			to_chat(src, SPAN_DANGER("Deadchat is globally muted"))
			return

	if(client && client.prefs && !(client.prefs.toggles_chat & CHAT_DEAD))
		to_chat(usr, SPAN_DANGER("You have deadchat muted."))
		return

	if(!client?.attempt_talking(message))
		return

	log_say("DEAD/[key_name(src)] : [message]")

	var/turf/my_turf = get_turf(src)
	var/list/mob/langchat_listeners = list()

	for(var/mob/M in GLOB.player_list)
		if(istype(M, /mob/new_player))
			continue
		if(!(M?.client?.prefs?.toggles_chat & CHAT_DEAD))
			continue

		if(isobserver(M) && !orbiting)
			var/mob/dead/observer/observer = M
			var/turf/their_turf = get_turf(M)
			if(alpha && observer.ghostvision && my_turf.z == their_turf.z && get_dist(my_turf, their_turf) <= observer.client.view)
				langchat_listeners += observer

		if(M.stat == DEAD)
			to_chat(M, "<span class='game deadsay'><span class='prefix'>МЕРТВЕЦ:</span> <span class='name'>[name] (<a href='byond://?src=\ref[M];track=\ref[src]'>F</a>)</span> сообщает, <span class='message'>\"[message]\"</span></span>")

		else if(M.client && M.client.admin_holder && (M.client.admin_holder.rights & R_MOD) && M.client.prefs && (M.client.prefs.toggles_chat & CHAT_DEAD) ) // Show the message to admins/mods with deadchat toggled on
			to_chat(M, "<span class='game deadsay'><span class='prefix'>МЕРТВЕЦ:</span> <span class='name'>[name]</span> сообщает, <span class='message'>\"[message]\"</span></span>") //Admins can hear deadchat, if they choose to, no matter if they're blind/deaf or not.

	if(length(langchat_listeners))
		langchat_speech(message, langchat_listeners, GLOB.all_languages, skip_language_check = TRUE)

/mob/proc/say_understands(mob/other, datum/language/speaking = null)
	if (src.stat == 2) //Dead
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

/mob/proc/say_quote(message, datum/language/speaking = null)
		var/verb = "говорит"
		var/ending = copytext_char(message, length(message))
		if(ending=="!")
				verb=pick("восклицает","кричит","вопит")
		else if(ending=="?")
				verb="спрашивает"

		return verb

/mob/proc/get_ear()
	// returns an atom representing a location on the map from which this
	// mob can hear things

	// should be overloaded for all mobs whose "ear" is separate from their "mob"

	return get_turf(src)

/mob/proc/say_test(text)
	var/ending = copytext(text, length(text))
	if (ending == "?")
		return "1"
	else if (ending == "!")
		return "2"
	return "0"

//parses the message mode code (e.g. :h, :w) from text, such as that supplied to say.
//returns the message mode string or null for no message mode.
//standard mode is the mode returned for the special ';' radio code.
/mob/proc/parse_message_mode(message, standard_mode="headset")
	if(length(message) >= 1 && copytext_char(message,1,2) == ";")
		return standard_mode

	if(length(message) >= 2)
		var/channel_prefix = copytext_char(message, 1 ,3)
		return GLOB.department_radio_keys[channel_prefix]

	return null

//parses the language code (e.g. :j) from text, such as that supplied to say.
//returns the language object only if the code corresponds to a language that src can speak, otherwise null.
/mob/proc/parse_language(message)
	if(length(message) >= 2)
		var/language_prefix = lowertext(copytext(message, 1 ,3))
		var/datum/language/L = GLOB.all_languages[GLOB.language_keys[language_prefix]]
		if (can_speak(L))
			return L

	return null

/mob/var/hud_typing = 0 //set when typing in an input window instead of chatline

/mob/verb/say_wrapper()
	set name = ".Say"
	set hidden = TRUE

	if(client.typing_indicators)
		create_typing_indicator(TRUE)
		hud_typing = -1
	var/message = input("","say (text)") as text
	if(client.typing_indicators)
		hud_typing = NONE
		remove_typing_indicator()
	if(message)
		say_verb(message)

/mob/verb/me_wrapper()
	set name = ".Me"
	set hidden = TRUE

	if(client.typing_indicators)
		create_typing_indicator(TRUE)
		hud_typing = -1
	var/message = input("","me (text)") as text
	if(client.typing_indicators)
		hud_typing = NONE
		remove_typing_indicator()
	if(message)
		me_verb(message)

/// Sets typing indicator for a couple seconds, for use with client-side comm verbs
/mob/verb/timed_typing()
	set name = ".typing"
	set hidden = TRUE
	set instant = TRUE

	if(client.typing_indicators)
		// Don't override wrapper's indicators
		if(hud_typing == -1)
			return
		create_typing_indicator(TRUE)
		hud_typing = addtimer(CALLBACK(src, PROC_REF(timed_typing_clear)), 5 SECONDS, TIMER_OVERRIDE|TIMER_UNIQUE|TIMER_STOPPABLE)

/// Clears timed typing indicators
/mob/proc/timed_typing_clear()
	if(client.typing_indicators)
		// Check it's one of ours
		if(hud_typing == -1)
			return
		hud_typing = NONE
		remove_typing_indicator()

