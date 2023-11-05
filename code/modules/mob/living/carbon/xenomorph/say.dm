/mob/living/carbon/xenomorph/say(message)
	var/verb = "says"
	var/forced = 0
	var/message_range = world_view_size

	if(client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, SPAN_WARNING("You cannot speak in IC (Muted)."))
			return

	message =  trim(strip_html(message))

	if(stat == DEAD)
		return say_dead(message)

	if(stat == UNCONSCIOUS)
		return //Unconscious? Nope.

	if(HAS_TRAIT(src, TRAIT_DAZED))
		to_chat(src, SPAN_WARNING("You are too dazed to talk."))
		return

	if(copytext(message, 1, 2) == "*")
		if(!findtext(message, "*", 2)) //Second asterisk means it is markup for *bold*, not an *emote.
			return emote(lowertext(copytext(message, 2)), intentional = TRUE)

	var/datum/language/speaking = null
	if(length(message) >= 2)
		if(can_hivemind_speak && copytext(message,1,2) == ";" && languages.len)
			for(var/datum/language/L in languages)
				if(L.flags & HIVEMIND)
					verb = L.speech_verb
					speaking = L
					break
		var/channel_prefix = copytext(message, 1, 3)
		if(languages.len)
			for(var/datum/language/L in languages)
				if(lowertext(channel_prefix) == ":[L.key]" || lowertext(channel_prefix) == ".[L.key]")
					verb = L.speech_verb
					speaking = L
					break

	if(caste)
		if(isnull(speaking) || (!can_hivemind_speak && (speaking.flags & HIVEMIND)) || speaking.key != "q") //Not hivemind? Then default to xenocommon. BRUTE FORCE YO
			for(var/datum/language/L in languages)
				if(L.key == speaking_key)
					verb = L.speech_verb
					speaking = L
					forced = 1
					break
	else
		if(!speaking || isnull(speaking))
			for(var/datum/language/L in languages)
				if(L.key == "0")
					verb = L.speech_verb
					speaking = L
					forced = 1
					break

	if(!(speaking.flags & HIVEMIND) && HAS_TRAIT(src, TRAIT_LISPING)) // Xenomorphs can lisp too. :) Only if they're not speaking in hivemind.
		var/old_message = message
		message = lisp_replace(message)
		if(old_message != message)
			verb = "lisps"

	if(copytext(message,1,2) == ";")
		message = trim(copytext(message,2))
	else if (copytext(message,1,3) == ":q" || copytext(message,1,3) == ":Q")
		message = trim(copytext(message,3))

	message = capitalize(trim_left(message))

	if(!message || stat)
		return

	// Automatic punctuation
	if(client && client.prefs && client.prefs.toggle_prefs & TOGGLE_AUTOMATIC_PUNCTUATION)
		if(!(copytext(message, -1) in ENDING_PUNCT))
			message += "."

	if(forced)
		if(speaking_noise)
			playsound(loc, speaking_noise, 25, 1)
		..(message, speaking, verb, null, null, message_range, null)
	else
		hivemind_talk(message)

/mob/living/carbon/xenomorph/say_understands(mob/other, datum/language/speaking = null)

	if(isxeno(other))
		return 1
	return ..()


//General proc for hivemind. Lame, but effective.
/mob/living/carbon/xenomorph/proc/hivemind_talk(message)
	if(interference)
		to_chat(src, SPAN_WARNING("A headhunter temporarily cut off your psychic connection!"))
		return

	hivemind_broadcast(message, hive)

/mob/living/carbon/proc/hivemind_broadcast(message, datum/hive_status/hive)
	if(!message || stat || !hive)
		return

	if(!hive.living_xeno_queen && !SSticker?.mode?.hardcore && !hive.allow_no_queen_actions && ROUND_TIME > SSticker.mode.round_time_evolution_ovipositor)
		to_chat(src, SPAN_WARNING("There is no Queen. You are alone."))
		return

	log_hivemind("[key_name(src)] : [message]")

	var/track = ""
	var/overwatch_target = XENO_OVERWATCH_TARGET_HREF
	var/overwatch_src = XENO_OVERWATCH_SRC_HREF
	var/overwatch_insert = ""
	var/ghostrend
	var/rendered

	for (var/mob/S in GLOB.player_list)
		var/hear_hivemind = 0
		if(ishuman(S))
			var/mob/living/carbon/human/Hu = S
			if(Hu.hivenumber)
				hear_hivemind = Hu.hivenumber

		if(!QDELETED(S) && (isxeno(S) || S.stat == DEAD || hear_hivemind) && !istype(S,/mob/new_player))
			var/mob/living/carbon/xenomorph/X = src
			if(istype(S,/mob/dead/observer))
				if(S.client.prefs && S.client.prefs.toggles_chat & CHAT_GHOSTHIVEMIND)
					track = "(<a href='byond://?src=\ref[S];track=\ref[src]'>F</a>)"
					if(isqueen(src))
						var/mob/hologram/queen/queen_eye = client?.eye
						if(istype(queen_eye))
							track += " (<a href='byond://?src=\ref[S];track=\ref[queen_eye]'>E</a>)"
						ghostrend = SPAN_XENOQUEEN("Hivemind, [src.name][track] hisses, <span class='normal'>'[message]'</span>")
					else if(hive.leading_cult_sl == src)
						ghostrend = SPAN_XENOQUEEN("Hivemind, [src.name][track] hisses, <span class='normal'>'[message]'</span>")
					else if(istype(X) && IS_XENO_LEADER(X))
						ghostrend = SPAN_XENOLEADER("Hivemind, Leader [src.name][track] hisses, <span class='normal'>'[message]'</span>")
					else
						ghostrend = SPAN_XENO("Hivemind, [src.name][track] hisses, <span class='normal'>'[message]'</span>")
					S.show_message(ghostrend, SHOW_MESSAGE_AUDIBLE)

			else if(hive.hivenumber == xeno_hivenumber(S) || hive.hivenumber == hear_hivemind)
				if(isxeno(src) && isxeno(S))
					overwatch_insert = " (<a href='byond://?src=\ref[S];[overwatch_target]=\ref[src];[overwatch_src]=\ref[S]'>watch</a>)"

				if(isqueen(src) || hive.leading_cult_sl == src)
					rendered = SPAN_XENOQUEEN("Hivemind, [src.name][overwatch_insert] hisses, <span class='normal'>'[message]'</span>")
				else if(istype(X) && IS_XENO_LEADER(X))
					rendered = SPAN_XENOLEADER("Hivemind, Leader [src.name][overwatch_insert] hisses, <span class='normal'>'[message]'</span>")
				else
					rendered = SPAN_XENO("Hivemind, [src.name][overwatch_insert] hisses, <span class='normal'>'[message]'</span>")

				S.show_message(rendered, SHOW_MESSAGE_AUDIBLE)

