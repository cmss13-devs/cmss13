/mob/living/carbon/xenomorph/say(message)
	var/verb = "says"
	var/message_range = GLOB.world_view_size

	if(client?.prefs?.muted & MUTE_IC)
		to_chat(src, SPAN_WARNING("You cannot speak in IC (Muted)."))
		return

	message = trim(strip_html(message))

	if(stat == DEAD)
		return say_dead(message)

	if(stat == UNCONSCIOUS)
		return //Unconscious? Nope.

	var/prefix = copytext(message, 1, 2)
	if(prefix == "*")
		if(!findtext(message, "*", 2)) //Second asterisk means it is markup for *bold*, not an *emote.
			return emote(lowertext(copytext(message, 2)), intentional = TRUE)

	var/hivemind_speak = FALSE

	if(prefix == ";")
		message = capitalize(trim_left(copytext(message, 2)))
		hivemind_speak = TRUE
	else if(prefix == "." || prefix == "#" || prefix == ":" || prefix == ",")
		message = capitalize(trim_left(copytext(message, 3)))
		hivemind_speak = TRUE

	if(!message)
		return

	if(hivemind_speak && can_hivemind_speak)
		// Automatic punctuation
		if(client?.prefs?.toggle_prefs & TOGGLE_AUTOMATIC_PUNCTUATION)
			if(!(copytext(message, -1) in ENDING_PUNCT))
				message += "."

		hivemind_talk(message)
		return

	var/datum/language/speaking = parse_language(message)
	if(speaking)
		verb = speaking.speech_verb
		message = capitalize(trim_left(copytext(message, 3)))
	else
		speaking = get_default_language()
		verb = speaking.speech_verb
		message = capitalize(trim_left(strip_language(message)))

	// Xenomorphs can lisp too. :) Only if they're not speaking in hivemind.
	if((!(speaking.flags & HIVEMIND) || !can_hivemind_speak) && HAS_TRAIT(src, TRAIT_LISPING))
		var/old_message = message
		message = lisp_replace(message)
		if(old_message != message)
			verb = "lisps"

	if(!message)
		return

	// Automatic punctuation
	if(client?.prefs?.toggle_prefs & TOGGLE_AUTOMATIC_PUNCTUATION)
		if(!(copytext(message, -1) in ENDING_PUNCT))
			message += "."
	if((speaking.flags & HIVEMIND) && can_hivemind_speak)
		hivemind_talk(message)
		return

	if(speaking_noise)
		playsound(loc, speaking_noise, 25, 1)
	..(message, speaking, verb, null, null, message_range, null)

/mob/living/carbon/xenomorph/say_understands(mob/other, datum/language/speaking = null)
	if(isxeno(other))
		return TRUE
	return ..()


//General proc for hivemind. Lame, but effective.
/mob/living/carbon/xenomorph/proc/hivemind_talk(message)
	if(HAS_TRAIT(src, TRAIT_HIVEMIND_INTERFERENCE))
		to_chat(src, SPAN_WARNING("Our psychic connection has been temporarily disabled!"))
		return

	if(SEND_SIGNAL(src, COMSIG_XENO_TRY_HIVEMIND_TALK, message) & COMPONENT_OVERRIDE_HIVEMIND_TALK)
		return

	hivemind_broadcast(message, hive)

/mob/living/carbon/proc/hivemind_broadcast(message, datum/hive_status/hive)
	if(!message || stat || !hive)
		return

	if(!hive.living_xeno_queen && !SSticker?.mode?.hardcore && !hive.allow_no_queen_actions && SSticker.mode.evolution_ovipositor_threshold)
		to_chat(src, SPAN_WARNING("There is no Queen. You are alone."))
		return

	if(!filter_message(src, message))
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
						var/mob/hologram/queen/queen_eye = client?.get_eye()
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

