/mob/living/carbon/xenomorph/say(message)
	var/verb = "says"
	var/forced = 0
	var/message_range = GLOB.world_view_size

	if(client)
		if(client.prefs.muted & MUTE_IC)
			to_chat(src, SPAN_WARNING("You cannot speak in IC (Muted)."))
			return

	message =  trim(strip_html(message))

	if(stat == DEAD)
		return say_dead(message)

	if(stat == UNCONSCIOUS)
		return //Unconscious? Nope.

	if(copytext(message, 1, 2) == "*")
		if(!findtext(message, "*", 2)) //Second asterisk means it is markup for *bold*, not an *emote.
			return emote(lowertext(copytext(message, 2)), intentional = TRUE)

	var/datum/language/speaking = null
	if(length(message) >= 2)
		if(can_hivemind_speak && copytext(message,1,2) == ";" && length(languages))
			for(var/datum/language/L in languages)
				if(L.flags & HIVEMIND)
					verb = L.speech_verb
					speaking = L
					break
		var/channel_prefix = copytext(message, 1, 3)
		if(length(languages))
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
	if(HAS_TRAIT(src, TRAIT_HIVEMIND_INTERFERENCE))
		to_chat(src, SPAN_WARNING("Our psychic connection has been temporarily disabled!"))
		return

	if(SEND_SIGNAL(src, COMSIG_XENO_TRY_HIVEMIND_TALK, message) & COMPONENT_OVERRIDE_HIVEMIND_TALK)
		return

	hivemind_broadcast(message, hive)

/mob/living/carbon/proc/hivemind_broadcast(message, datum/faction_module/hive_mind/faction_module)
	if(!message || stat)
		return

	if(!faction_module.living_xeno_queen && !SSticker?.mode?.hardcore && !faction_module.allow_no_queen_actions && ROUND_TIME > SSticker.mode.round_time_evolution_ovipositor)
		to_chat(src, SPAN_WARNING("There is no Queen. You are alone."))
		return

	if(!filter_message(src, message))
		return

	log_hivemind("[key_name(src)] : [message]")

	for(var/mob/creature in GLOB.dead_mob_list)
		if(!creature.client)
			continue
		if(!creature.client.prefs || !(creature.client.prefs.toggles_chat & CHAT_GHOSTHIVEMIND))
			continue

		var/mob/living/carbon/xenomorph/zenomorph = creature
		var/track = "(<a href='byond://?src=\ref[creature];track=\ref[src]'>F</a>)"
		var/final_message
		if(isqueen(src))
			var/mob/hologram/queen/queen_eye = client?.eye
			if(istype(queen_eye))
				track += " (<a href='byond://?src=\ref[creature];track=\ref[queen_eye]'>E</a>)"
			final_message = SPAN_XENOQUEEN("Hivemind, [name][track] hisses, <span class='normal'>'[message]'</span>")
		else if(faction_module.leading_cult_sl == src)
			final_message = SPAN_XENOQUEEN("Hivemind, [name][track] hisses, <span class='normal'>'[message]'</span>")
		else if(istype(zenomorph) && IS_XENO_LEADER(zenomorph))
			final_message = SPAN_XENOLEADER("Hivemind, Leader [name][track] hisses, <span class='normal'>'[message]'</span>")
		else
			final_message = SPAN_XENO("Hivemind, [name][track] hisses, <span class='normal'>'[message]'</span>")
		creature.show_message(final_message, SHOW_MESSAGE_AUDIBLE)

	for(var/mob/creature in faction.total_mobs)
		if(!creature.client)
			continue

		var/mob/living/carbon/xenomorph/zenomorph = creature
		var/overwatch_insert = ""
		var/final_message
		if(isxeno(src) && isxeno(creature))
			overwatch_insert = " (<a href='byond://?src=\ref[creature];[XENO_OVERWATCH_TARGET_HREF]=\ref[src];[XENO_OVERWATCH_SRC_HREF]=\ref[creature]'>watch</a>)"

		if(isqueen(src) || faction.leading_cult_sl == src)
			final_message = SPAN_XENOQUEEN("Hivemind, [name][overwatch_insert] hisses, <span class='normal'>'[message]'</span>")
		else if(istype(zenomorph) && IS_XENO_LEADER(zenomorph))
			final_message = SPAN_XENOLEADER("Hivemind, Leader [name][overwatch_insert] hisses, <span class='normal'>'[message]'</span>")
		else
			final_message = SPAN_XENO("Hivemind, [name][overwatch_insert] hisses, <span class='normal'>'[message]'</span>")
		creature.show_message(final_message, SHOW_MESSAGE_AUDIBLE)

