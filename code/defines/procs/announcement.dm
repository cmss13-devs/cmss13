#define COMMAND_ANNOUNCE "Command Announcement"
#define UPP_COMMAND_ANNOUNCE "UPP Command Announcement"
#define CLF_COMMAND_ANNOUNCE "CLF Command Announcement"
#define PMC_COMMAND_ANNOUNCE "PMC Command Announcement"
#define QUEEN_ANNOUNCE "The words of the Queen reverberate in your head..."
#define QUEEN_MOTHER_ANNOUNCE "Queen Mother Psychic Directive"
#define XENO_GENERAL_ANNOUNCE "You sense something unusual..." //general xeno announcement that don't involve Queen, for nuke for example
#define YAUTJA_ANNOUNCE "You receive a message from your ship AI..." //preds announcement
#define HIGHER_FORCE_ANNOUNCE SPAN_ANNOUNCEMENT_HEADER_BLUE("Unknown Higher Force")

//xenomorph hive announcement
/proc/xeno_announcement(message, hivenumber, title = QUEEN_ANNOUNCE)
	var/list/targets = GLOB.living_xeno_list + GLOB.dead_mob_list
	if(hivenumber == "everything")
		for(var/mob/M in targets)
			var/mob/living/carbon/xenomorph/X = M
			if(!isobserver(X) && !istype(X)) //filter out any potential non-xenomorphs/observers mobs
				targets.Remove(X)

		announcement_helper(message, title, targets, sound(get_sfx("queen"),wait = 0,volume = 50))
	else
		for(var/mob/M in targets)
			if(isobserver(M))
				continue
			var/mob/living/carbon/X = M
			if(!istype(X) || !X.ally_of_hivenumber(hivenumber)) //additionally filter out those of wrong hive
				targets.Remove(X)

		announcement_helper(message, title, targets, sound(get_sfx("queen"),wait = 0,volume = 50))


//general marine announcement
/proc/marine_announcement(message, title = COMMAND_ANNOUNCE, sound_to_play = sound('sound/misc/notice2.ogg'), faction_to_display = FACTION_MARINE, add_PMCs = FALSE, signature, logging = ARES_LOG_MAIN)
	var/list/targets = GLOB.human_mob_list + GLOB.dead_mob_list
	if(faction_to_display == FACTION_MARINE)
		for(var/mob/M in targets)
			if(isobserver(M)) //observers see everything
				continue
			var/mob/living/carbon/human/H = M
			if(!istype(H) || H.stat != CONSCIOUS || isyautja(H)) //base human checks
				targets.Remove(H)
				continue
			if(is_mainship_level(H.z)) // People on ship see everything
				continue

			// If they have iff AND a marine headset they will recieve announcements
			var/obj/item/card/id/card = H.get_idcard()
			if ((FACTION_MARINE in card?.faction_group) && (istype(H.wear_l_ear, /obj/item/device/radio/headset/almayer) || istype(H.wear_r_ear, /obj/item/device/radio/headset/almayer)))
				continue

			if((H.faction != faction_to_display && !add_PMCs) || (H.faction != faction_to_display && add_PMCs && !(H.faction in FACTION_LIST_WY)) && !(faction_to_display in H.faction_group)) //faction checks
				targets.Remove(H)

		switch(logging)
			if(ARES_LOG_MAIN)
				log_ares_announcement(title, message, signature)
			if(ARES_LOG_SECURITY)
				log_ares_security(title, message, signature)

	else if(faction_to_display == "Everyone (-Yautja)")
		for(var/mob/M in targets)
			if(isobserver(M)) //observers see everything
				continue
			var/mob/living/carbon/human/H = M
			if(!istype(H) || H.stat != CONSCIOUS || isyautja(H))
				targets.Remove(H)

	else
		for(var/mob/M in targets)
			if(isobserver(M)) //observers see everything
				continue
			var/mob/living/carbon/human/H = M
			if(!istype(H) || H.stat != CONSCIOUS || isyautja(H))
				targets.Remove(H)
				continue
			if(H.faction != faction_to_display)
				targets.Remove(H)

	if(!isnull(signature))
		message += "<br><br><i> Signed by, <br> [signature]</i>"

	announcement_helper(message, title, targets, sound_to_play)

//yautja ship AI announcement
/proc/yautja_announcement(message, title = YAUTJA_ANNOUNCE, sound_to_play = sound('sound/misc/notice1.ogg'))
	var/list/targets = GLOB.human_mob_list + GLOB.dead_mob_list
	for(var/mob/M in targets)
		if(isobserver(M)) //observers see everything
			continue
		var/mob/living/carbon/human/H = M
		if(!isyautja(H) || H.stat != CONSCIOUS)
			targets.Remove(H)

	announcement_helper(message, title, targets, sound_to_play)

//AI announcement that uses talking into comms
/proc/ai_announcement(message, sound_to_play = sound('sound/misc/interference.ogg'), logging = ARES_LOG_MAIN)
	for(var/mob/M in (GLOB.human_mob_list + GLOB.dead_mob_list))
		if((isobserver(M) && M.client?.prefs?.toggles_sound & SOUND_OBSERVER_ANNOUNCEMENTS) || ishuman(M) && is_mainship_level(M.z))
			playsound_client(M.client, sound_to_play, M, vol = 45)

	for(var/mob/living/silicon/decoy/ship_ai/AI in GLOB.ai_mob_list)
		INVOKE_ASYNC(AI, TYPE_PROC_REF(/mob/living/silicon/decoy/ship_ai, say), message)

	switch(logging)
		if(ARES_LOG_MAIN)
			log_ares_announcement("Comms Update", message, MAIN_AI_SYSTEM)
		if(ARES_LOG_SECURITY)
			log_ares_security("Security Update", message, MAIN_AI_SYSTEM)

/proc/ai_silent_announcement(message, channel_prefix, bypass_cooldown = FALSE)
	if(!message)
		return

	for(var/mob/living/silicon/decoy/ship_ai/AI in GLOB.ai_mob_list)
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
/proc/shipwide_ai_announcement(message, title = MAIN_AI_SYSTEM, sound_to_play = sound('sound/misc/interference.ogg'), signature, ares_logging = ARES_LOG_MAIN, quiet = FALSE)
	var/list/targets = GLOB.human_mob_list + GLOB.dead_mob_list
	for(var/mob/target in targets)
		if(isobserver(target))
			continue
		if(!ishuman(target) || isyautja(target) || !is_mainship_level(target.z))
			targets.Remove(target)

	if(!isnull(signature))
		message += "<br><br><i> Signed by, <br> [signature]</i>"
	switch(ares_logging)
		if(ARES_LOG_MAIN)
			log_ares_announcement(title, message, signature)
		if(ARES_LOG_SECURITY)
			log_ares_security(title, message, signature)

	announcement_helper(message, title, targets, sound_to_play, quiet)

/proc/all_hands_on_deck(message, title = MAIN_AI_SYSTEM, sound_to_play = sound('sound/misc/sound_misc_boatswain.ogg'))
	shipwide_ai_announcement(message, title, sound_to_play, null, ARES_LOG_MAIN, FALSE)

/proc/announcement_helper(message, title, list/targets, sound_to_play, quiet)
	if(!message || !title || !targets) //Shouldn't happen
		return
	for(var/mob/target in targets)
		if(istype(target, /mob/new_player))
			continue

		to_chat_spaced(target, html = "[SPAN_ANNOUNCEMENT_HEADER(title)]<br><br>[SPAN_ANNOUNCEMENT_BODY(message)]", type = MESSAGE_TYPE_RADIO)
		if(!quiet)
			if(isobserver(target) && !(target.client?.prefs?.toggles_sound & SOUND_OBSERVER_ANNOUNCEMENTS))
				continue
			playsound_client(target.client, sound_to_play, target, vol = 45)
