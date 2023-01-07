// All mobs should have custom emote, really..
/mob/proc/custom_emote(var/m_type = SHOW_MESSAGE_VISIBLE, var/message = null, player_caused, var/nolog = 0)
	var/comm_paygrade = ""
	if(stat || (!use_me && player_caused))
		if(player_caused)
			to_chat(src, "You are unable to emote.")
		return
	if(istype(src, /mob/living/carbon/human))
		var/mob/living/carbon/human/H = src
		comm_paygrade = H.get_paygrade()
	var/muzzled = istype(src.wear_mask, /obj/item/clothing/mask/muzzle)
	if(m_type == 2 && muzzled) return

	var/input
	if(!message)
		input = strip_html(input(src,"Choose an emote to display.") as text|null)
	else
		input = message
	if(input)
		message = "<B>[comm_paygrade][src]</B> [input]"
		message = process_chat_markup(message, list("~", "_"))
	else
		return


	if(message)
		if(!nolog)
			log_emote("[name]/[key] : [message]")

//Hearing gasp and such every five seconds is not good emotes were not global for a reason.
// Maybe some people are okay with that.
		for(var/mob/M in GLOB.player_list)
			if(!M.client)
				continue //skip monkeys and leavers
			if(istype(M, /mob/new_player))
				continue
			if(findtext(message," snores.")) //Because we have so many sleeping people.
				break
			if((M.stat == DEAD || isobserver(M)) && (M.client.prefs && M.client.prefs.toggles_chat & CHAT_GHOSTSIGHT) && !(M in viewers(src,null)))
				M.show_message(message)


		// Type 1 (Visual) emotes are sent to anyone in view of the item
		if(m_type & SHOW_MESSAGE_VISIBLE)
			var/list/viewers = get_mobs_in_view(7, src)
			for (var/mob/O in viewers(src, null))
				if(O.status_flags & PASSEMOTES)
					for(var/obj/item/holder/H in O.contents)
						H.show_message(message, m_type)
						viewers.Add(H)
					for(var/mob/living/M in O.contents)
						M.show_message(message, m_type)
						viewers.Add(M)
				O.show_message(message, m_type)
				var/toggles_langchat = O.client?.prefs.toggles_langchat
				if(toggles_langchat)
					if(!(toggles_langchat & LANGCHAT_SEE_EMOTES))
						viewers.Remove(O)
			langchat_speech(input, viewers, GLOB.all_languages, skip_language_check = TRUE, additional_styles = list("emote", "langchat_small"))



		// Type 2 (Audible) emotes are sent to anyone in hear range
		// of the *LOCATION* -- this is important for pAIs to be heard
		else if(m_type & SHOW_MESSAGE_AUDIBLE)
			var/list/hearers = get_mobs_in_view(7, src)
			hearers.Add(src)
			for (var/mob/O in hearers(get_turf(src), null))
				if(O.z != z) //cases like interior vehicles, for example
					continue
				if(O.status_flags & PASSEMOTES)
					for(var/obj/item/holder/H in O.contents)
						H.show_message(message, m_type)
						hearers.Add(H)
					for(var/mob/living/M in O.contents)
						M.show_message(message, m_type)
						hearers.Add(M)
				O.show_message(message, m_type)
				var/toggles_langchat = O.client?.prefs.toggles_langchat
				if(toggles_langchat)
					if(!(toggles_langchat & LANGCHAT_SEE_EMOTES))
						hearers.Remove(O)
			langchat_speech(input, hearers, GLOB.all_languages, skip_language_check = TRUE, additional_styles = list("emote", "langchat_small"))

/mob/proc/emote_dead(var/message)
	if(client.prefs.muted & MUTE_DEADCHAT)
		to_chat(src, SPAN_DANGER("You cannot send deadchat emotes (muted)."))
		return

	if(!(client.prefs.toggles_chat & CHAT_DEAD))
		to_chat(src, SPAN_DANGER("You have deadchat muted."))
		return

	if(!AHOLD_IS_MOD(client.admin_holder) && !dsay_allowed)
		to_chat(src, SPAN_DANGER("Deadchat is globally muted"))
		return

	var/input
	if(!message)
		input = strip_html(input(src, "Choose an emote to display.") as text|null)
	else
		input = message

	if(input)
		message = "<span class='game deadsay'><span class='prefix'>DEAD:</span> <b>[src]</b> [message]</span>"
	else
		return

	var/turf/my_turf = get_turf(src)
	var/list/mob/langchat_listeners = list()
	if(message)
		log_emote("DEAD/[key_name(src)] : [message]")
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
				M.show_message(message, SHOW_MESSAGE_AUDIBLE)

			else if(M.client.admin_holder && AHOLD_IS_MOD(M.client.admin_holder)) // Show the emote to admins/mods
				to_chat(M, message)

		if(length(langchat_listeners))
			langchat_speech(input, langchat_listeners, GLOB.all_languages, skip_language_check = TRUE, additional_styles = list("emote", "langchat_small"))

/mob/living/carbon/verb/show_emotes()
	set name = "Emotes"
	set desc = "Displays a list of usable emotes."
	set category = "IC"

	usr.say("*help")
