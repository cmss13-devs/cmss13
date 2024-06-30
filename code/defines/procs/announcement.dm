//xenomorph hive announcement
/proc/xeno_announcement(message, datum/faction/faction_to_display = GLOB.faction_datum[FACTION_XENOMORPH_NORMAL], title = QUEEN_ANNOUNCE)
	var/list/targets = GLOB.dead_mob_list.Copy()
	if(faction_to_display == "Everyone")
		for(var/faction_to_get in FACTION_LIST_XENOMORPH)
			var/datum/faction/faction = GLOB.faction_datum[faction_to_get]
			for(var/mob/mob as anything in faction.totalMobs)
				if(mob.stat != CONSCIOUS)
					continue
				targets.Add(mob)
	else
		for(var/mob/mob as anything in faction_to_display.totalMobs)
			if(mob.stat != CONSCIOUS)
				continue
			targets.Add(mob)

	announcement_helper(message, title, targets, sound(get_sfx("queen"), wait = 0, volume = 50))


//general faction announcement
/proc/faction_announcement(message, title = COMMAND_ANNOUNCE, sound_to_play = sound('sound/misc/notice2.ogg'), datum/faction/faction_to_display = GLOB.faction_datum[FACTION_MARINE], signature, logging = ARES_LOG_MAIN)
	var/list/targets = GLOB.dead_mob_list.Copy()
	if(faction_to_display == GLOB.faction_datum[FACTION_MARINE])
		var/datum/ares_link/link = GLOB.ares_link
		if(ares_can_log())
			switch(logging)
				if(ARES_LOG_MAIN)
					link.log_ares_announcement(title, message)
				if(ARES_LOG_SECURITY)
					link.log_ares_security(title, message)

	if(faction_to_display == "Everyone (-Yautja)")
		for(var/faction_to_get in FACTION_LIST_HUMANOID - FACTION_YAUTJA)
			var/datum/faction/faction = GLOB.faction_datum[faction_to_get]
			for(var/mob/mob as anything in faction.totalMobs)
				if(mob.stat != CONSCIOUS)
					continue
				targets.Add(mob)

	else
		for(var/mob/mob as anything in faction_to_display.totalMobs)
			if(mob.stat != CONSCIOUS)
				continue
			targets.Add(mob)

	if(!isnull(signature))
		message += "<br><br><i> Signed by, <br> [signature]</i>"

	announcement_helper(message, title, targets, sound_to_play)

//AI announcement that uses talking into comms
/proc/ai_announcement(message, sound_to_play = sound('sound/misc/interference.ogg'), logging = ARES_LOG_MAIN)
	for(var/mob/M as anything in (GLOB.human_mob_list + GLOB.dead_mob_list))
		if(isobserver(M) || ishuman(M) && is_mainship_level(M.z))
			playsound_client(M.client, sound_to_play, M, vol = 45)

	for(var/mob/living/silicon/decoy/ship_ai/AI in ai_mob_list)
		INVOKE_ASYNC(AI, TYPE_PROC_REF(/mob/living/silicon/decoy/ship_ai, say), message)

	var/datum/ares_link/link = GLOB.ares_link
	if(ares_can_log())
		switch(logging)
			if(ARES_LOG_MAIN)
				link.log_ares_announcement("[MAIN_AI_SYSTEM] Comms Update", message)
			if(ARES_LOG_SECURITY)
				link.log_ares_security("[MAIN_AI_SYSTEM] Security Update", message)

/proc/ai_silent_announcement(message, channel_prefix, bypass_cooldown = FALSE)
	if(!message)
		return

	for(var/mob/living/silicon/decoy/ship_ai/AI in ai_mob_list)
		if(channel_prefix)
			message = "[channel_prefix][message]"
		INVOKE_ASYNC(AI, TYPE_PROC_REF(/mob/living/silicon/decoy/ship_ai, say), message)

/mob/proc/detectable_by_ai()
	return TRUE

/mob/living/carbon/human/detectable_by_ai()
	if(gloves && gloves.hide_prints)
		return FALSE
	. = ..()

//AI shipside announcement, that uses announcement mechanic instead of talking into comms
//to ensure that all humans on ship hear it regardless of comms and power
/proc/shipwide_ai_announcement(message, title = MAIN_AI_SYSTEM, sound_to_play = sound('sound/misc/interference.ogg'), signature)
	var/list/targets = GLOB.human_mob_list + GLOB.dead_mob_list
	for(var/mob/mob in targets)
		if(isobserver(mob))
			continue
		if(!ishuman(mob) || isyautja(mob) || !is_mainship_level(mob.z))
			targets.Remove(mob)

	if(!isnull(signature))
		message += "<br><br><i> Signed by, <br> [signature]</i>"
	var/datum/ares_link/link = GLOB.ares_link
	if(link.interface && !(link.interface.inoperable()))
		link.log_ares_announcement(title, message)

	announcement_helper(message, title, targets, sound_to_play)

//Subtype of AI shipside announcement for "All Hands On Deck" alerts (COs and SEAs joining the game)
/proc/all_hands_on_deck(message, title = MAIN_AI_SYSTEM, sound_to_play = sound('sound/misc/sound_misc_boatswain.ogg'))
	var/list/targets = GLOB.human_mob_list + GLOB.dead_mob_list
	for(var/mob/mob in targets)
		if(isobserver(mob))
			continue
		if(!ishuman(mob) || isyautja(mob) || !is_mainship_level(mob.z))
			targets.Remove(mob)

	var/datum/ares_link/link = GLOB.ares_link
	if(ares_can_log())
		link.log_ares_announcement("[title] Shipwide Update", message)

	announcement_helper(message, title, targets, sound_to_play)

//the announcement proc that handles announcing for each mob in targets list
/proc/announcement_helper(message, title, list/targets, sound_to_play)
	if(!message || !title || !sound_to_play || !targets) //Shouldn't happen
		return
	for(var/mob/mob in targets)
		if(istype(mob, /mob/new_player))
			continue

		to_chat_spaced(mob, html = "[SPAN_ANNOUNCEMENT_HEADER(title)]<br><br>[SPAN_ANNOUNCEMENT_BODY(message)]", type = MESSAGE_TYPE_RADIO)
		playsound_client(mob.client, sound_to_play, mob, vol = 45)
