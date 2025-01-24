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
/proc/xeno_announcement(message, datum/faction/faction_to_display = GLOB.faction_datums[FACTION_XENOMORPH_NORMAL], title = QUEEN_ANNOUNCE)
	var/list/targets = GLOB.dead_mob_list.Copy()
	if(faction_to_display == "Everyone")
		for(var/faction_to_get in FACTION_LIST_XENOMORPH)
			for(var/mob/mob as anything in GLOB.faction_datums[faction_to_get].total_mobs)
				if(!mob.stat || !mob.client)
					continue
				targets.Add(mob)
	else
		for(var/mob/mob as anything in faction_to_display.total_mobs)
			if(!mob.stat || !mob.client)
				continue
			targets.Add(mob)

	announcement_helper(message, title, targets, sound(get_sfx("queen"), wait = 0, volume = 50))


//general marine announcement
/proc/faction_announcement(message, title = COMMAND_ANNOUNCE, sound_to_play = sound('sound/misc/notice2.ogg'), datum/faction/faction_to_display = GLOB.faction_datums[FACTION_MARINE], signature, logging = ARES_LOG_MAIN)
	var/list/targets = GLOB.dead_mob_list.Copy()
	if(faction_to_display == GLOB.faction_datums[FACTION_MARINE])
		switch(logging)
			if(ARES_LOG_MAIN)
				log_ares_announcement(title, message, signature)
			if(ARES_LOG_SECURITY)
				log_ares_security(title, message, signature)

	else if(faction_to_display == "Everyone (-Yautja)")
		for(var/faction_to_get in FACTION_LIST_HUMANOID - FACTION_YAUTJA)
			var/datum/faction/faction = GLOB.faction_datums[faction_to_get]
			for(var/mob/mob as anything in faction.total_mobs)
				if(!mob.stat || !mob.client)
					continue
				targets.Add(mob)

	else
		for(var/mob/mob as anything in faction_to_display.total_mobs)
			if(!mob.stat || !mob.client)
				continue
			targets.Add(mob)

	if(!isnull(signature))
		message += "<br><br><i> Signed by, <br> [signature]</i>"

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
/proc/shipwide_ai_announcement(message, title = MAIN_AI_SYSTEM, sound_to_play = sound('sound/misc/interference.ogg'), signature, ares_logging = ARES_LOG_MAIN)
	var/list/targets = GLOB.human_mob_list + GLOB.dead_mob_list
	for(var/mob/T in targets)
		if(isobserver(T))
			continue
		if(!ishuman(T) || isyautja(T) || !is_mainship_level(T.z))
			targets.Remove(T)

	if(!isnull(signature))
		message += "<br><br><i> Signed by, <br> [signature]</i>"
	switch(ares_logging)
		if(ARES_LOG_MAIN)
			log_ares_announcement(title, message, signature)
		if(ARES_LOG_SECURITY)
			log_ares_security(title, message, signature)

	announcement_helper(message, title, targets, sound_to_play)

//Subtype of AI shipside announcement for "All Hands On Deck" alerts (COs and SEAs joining the game)
/proc/all_hands_on_deck(message, title = MAIN_AI_SYSTEM, sound_to_play = sound('sound/misc/sound_misc_boatswain.ogg'))
	var/list/targets = GLOB.human_mob_list + GLOB.dead_mob_list
	for(var/mob/T in targets)
		if(isobserver(T))
			continue
		if(!ishuman(T) || isyautja(T) || !is_mainship_level((get_turf(T))?.z))
			targets.Remove(T)

	log_ares_announcement("Shipwide Update", message, title)

	announcement_helper(message, title, targets, sound_to_play)

//the announcement proc that handles announcing for each mob in targets list
/proc/announcement_helper(message, title, list/targets, sound_to_play)
	if(!message || !title || !sound_to_play || !targets) //Shouldn't happen
		return
	for(var/mob/T in targets)
		if(istype(T, /mob/new_player))
			continue

		to_chat_spaced(T, html = "[SPAN_ANNOUNCEMENT_HEADER(title)]<br><br>[SPAN_ANNOUNCEMENT_BODY(message)]", type = MESSAGE_TYPE_RADIO)
		if(isobserver(T) && !(T.client?.prefs?.toggles_sound & SOUND_OBSERVER_ANNOUNCEMENTS))
			continue
		playsound_client(T.client, sound_to_play, T, vol = 45)
