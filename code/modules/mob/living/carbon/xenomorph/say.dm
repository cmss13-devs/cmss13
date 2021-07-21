/mob/living/carbon/Xenomorph/say(var/message)
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

	if(dazed > 0)
		to_chat(src, SPAN_WARNING("You are too dazed to talk."))
		return

	if(copytext(message, 1, 2) == "*")
		return emote(copytext(message, 2), player_caused = TRUE)

	var/datum/language/speaking = null
	if(length(message) >= 2)
		if(copytext(message,1,2) == ";" && languages.len)
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
		if(isnull(speaking) || speaking.key != "q") //Not hivemind? Then default to xenocommon. BRUTE FORCE YO
			for(var/datum/language/L in languages)
				if(L.key == "x")
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

	if(speaking && !forced)
		if (copytext(message,1,2) == ";")
			message = trim(copytext(message,2))
		else if (copytext(message,1,3) == ":q" || copytext(message,1,3) == ":Q")
			message = trim(copytext(message,3))

	message = capitalize(trim_left(message))

	if(!message || stat)
		return

	if(forced)
		if(isXenoPredalien(src))
			playsound(loc, 'sound/voice/predalien_click.ogg', 25, 1)
		else
			playsound(loc, "alien_talk", 25, 1)
		..(message, speaking, verb, null, null, message_range, null)
	else
		hivemind_talk(message)

/mob/living/carbon/Xenomorph/say_understands(var/mob/other,var/datum/language/speaking = null)

	if(isXeno(other))
		return 1
	return ..()


//General proc for hivemind. Lame, but effective.
/mob/living/carbon/Xenomorph/proc/hivemind_talk(var/message)
	if(interference)
		to_chat(src, SPAN_WARNING("A headhunter temporarily cut off your psychic connection!"))
		return

	hivemind_broadcast(message, hive)

/mob/living/carbon/proc/hivemind_broadcast(var/message, var/datum/hive_status/hive)
	if(!message || stat || !hive)
		return

	if(!hive.living_xeno_queen && !SSticker?.mode?.hardcore && !hive.allow_no_queen_actions)
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

		if(!QDELETED(S) && (isXeno(S) || S.stat == DEAD || hear_hivemind) && !istype(S,/mob/new_player))
			var/mob/living/carbon/Xenomorph/X = src
			if(istype(S,/mob/dead/observer))
				if(S.client.prefs && S.client.prefs.toggles_chat & CHAT_GHOSTHIVEMIND)
					track = "(<a href='byond://?src=\ref[S];track=\ref[src]'>follow</a>)"
					if(isXenoQueen(src) || hive.leading_cult_sl == src)
						ghostrend = SPAN_XENOQUEEN("Hivemind, [src.name] [track] hisses, <span class='normal'>'[message]'</span>")
					else if(istype(X) && IS_XENO_LEADER(X))
						ghostrend = SPAN_XENOLEADER("Hivemind, Leader [src.name] [track] hisses, <span class='normal'>'[message]'</span>")
					else
						ghostrend = SPAN_XENO("Hivemind, [src.name] [track] hisses, <span class='normal'>'[message]'</span>")
					S.show_message(ghostrend, 2)

			else if(hive.hivenumber == xeno_hivenumber(S) || hive.hivenumber == hear_hivemind)
				if(isXeno(src) && isXeno(S))
					overwatch_insert = "(<a href='byond://?src=\ref[S];[overwatch_target]=\ref[src];[overwatch_src]=\ref[S]'>watch</a>)"

				if(isXenoQueen(src) || hive.leading_cult_sl == src)
					rendered = SPAN_XENOQUEEN("Hivemind, [src.name] [overwatch_insert] hisses, <span class='normal'>'[message]'</span>")
				else if(istype(X) && IS_XENO_LEADER(X))
					rendered = SPAN_XENOLEADER("Hivemind, Leader [src.name] [overwatch_insert] hisses, <span class='normal'>'[message]'</span>")
				else
					rendered = SPAN_XENO("Hivemind, [src.name] [overwatch_insert] hisses, <span class='normal'>'[message]'</span>")

				S.show_message(rendered, 2)

