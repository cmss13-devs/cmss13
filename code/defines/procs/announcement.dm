#define COMMAND_ANNOUNCE "Command Announcement"
#define UPP_COMMAND_ANNOUNCE "UPP Command Announcement"
#define CLF_COMMAND_ANNOUNCE "CLF Command Announcement"
#define PMC_COMMAND_ANNOUNCE "PMC Command Announcement"
#define QUEEN_ANNOUNCE "The words of the Queen reverberate in your head..."
#define QUEEN_MOTHER_ANNOUNCE "Queen Mother Psychic Directive"
#define XENO_GENERAL_ANNOUNCE "You sense something unusual..." //general xeno announcement that don't involve Queen, for nuke for example
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
	var/list/targets_to_garble = list()
	var/list/coms_zs = SSradio.get_available_tcomm_zs(COMM_FREQ)

	if(faction_to_display == FACTION_MARINE)
		for(var/mob/current_mob in targets)
			var/turf/current_turf = get_turf(current_mob)
			var/is_shipside = is_mainship_level(current_turf?.z)

			if(isobserver(current_mob)) //observers see everything
				if(current_mob.client?.prefs?.toggles_chat & CHAT_GHOSTANNOUNCECLARITY)
					continue // Valid target w/o garble
				if(!is_shipside && !(current_turf?.z in coms_zs))
					targets_to_garble += current_mob
				continue // Valid target

			var/mob/living/carbon/human/current_human = current_mob
			if(!istype(current_human) || current_human.stat != CONSCIOUS || isyautja(current_human)) //base human checks
				targets -= current_human
				continue // Invalid target

			if(is_shipside && !(istype(GLOB.master_mode, /datum/game_mode/extended/faction_clash))) // People on ship see everything, unless it is faction clash
				continue // Valid target w/o garble

			if(!is_shipside && !(current_turf?.z in coms_zs))
				targets_to_garble += current_human

			// If they have iff AND a marine headset they will recieve announcements
			var/obj/item/card/id/card = current_human.get_idcard()
			if((FACTION_MARINE in card?.faction_group) && (istype(current_human.wear_l_ear, /obj/item/device/radio/headset/almayer) || istype(current_human.wear_r_ear, /obj/item/device/radio/headset/almayer)))
				continue // Valid target

			/// If they're in a joint-USCM job they'll get announcements regardless.
			if((current_human.job in USCM_SHARED_JOBS) && (istype(current_human.wear_l_ear, /obj/item/device/radio/headset) || istype(current_human.wear_r_ear, /obj/item/device/radio/headset)))
				continue // Valid target

			if((current_human.faction != faction_to_display && !add_PMCs) || (current_human.faction != faction_to_display && add_PMCs && !(current_human.faction in FACTION_LIST_WY)) && !(faction_to_display in current_human.faction_group)) //faction checks
				targets -= current_human
				targets_to_garble -= current_human
				continue // Invalid target

		switch(logging)
			if(ARES_LOG_MAIN)
				log_ares_announcement(title, message, signature)
			if(ARES_LOG_SECURITY)
				log_ares_security(title, message, signature)

	else if(faction_to_display == "Everyone (-Yautja)")
		for(var/mob/current_mob in targets)
			var/turf/current_turf = get_turf(current_mob)
			var/is_shipside = is_mainship_level(current_turf?.z)

			if(isobserver(current_mob)) //observers see everything
				if(current_mob.client?.prefs?.toggles_chat & CHAT_GHOSTANNOUNCECLARITY)
					continue // Valid target w/o garble
				if(!is_shipside && !(current_turf?.z in coms_zs))
					targets_to_garble += current_mob
				continue // Valid target

			var/mob/living/carbon/human/current_human = current_mob
			if(!istype(current_human) || current_human.stat != CONSCIOUS || isyautja(current_human))
				targets -= current_human
				continue // Invalid target

			if(!is_shipside && !(current_turf?.z in coms_zs))
				targets_to_garble += current_human

	else
		for(var/mob/current_mob in targets)
			var/turf/current_turf = get_turf(current_mob)
			var/is_shipside = is_mainship_level(current_turf?.z)

			if(isobserver(current_mob)) //observers see everything
				if(current_mob.client?.prefs?.toggles_chat & CHAT_GHOSTANNOUNCECLARITY)
					continue // Valid target w/o garble
				if(!is_shipside && !(current_turf?.z in coms_zs))
					targets_to_garble += current_mob
				continue // Valid target

			var/mob/living/carbon/human/current_human = current_mob
			if(!istype(current_human) || current_human.stat != CONSCIOUS || isyautja(current_human))
				targets -= current_human
				continue // Invalid target

			if(current_human.faction != faction_to_display)
				targets -= current_human
				continue // Invalid target

			if(!is_shipside && !(current_turf?.z in coms_zs))
				targets_to_garble += current_human

	var/postfix = ""
	if(!isnull(signature))
		postfix = "<br><br><i> Signed by, <br> [signature]</i>"

	announcement_helper(message, title, targets, sound_to_play, FALSE, postfix, targets_to_garble, FACTION_MARINE)

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
	for(var/mob/target as anything in targets)
		if(isobserver(target))
			continue
		var/turf/target_turf = get_turf(target)
		if(!ishuman(target) || isyautja(target) || !is_mainship_level(target_turf?.z))
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

/proc/announcement_helper(message, title, list/targets, sound_to_play, quiet, postfix, list/targets_to_garble, faction_to_garble)
	if(!message || !title || !targets) //Shouldn't happen
		return

	message += postfix
	var/garbled_message
	var/garbled_count = length(targets_to_garble)
	if(garbled_count)
		garbled_message = get_garbled_announcement(message, length(postfix), faction_to_garble)
		log_garble("[garbled_count] received '[garbled_message]' for faction [faction_to_garble].")

	for(var/mob/target in targets)
		if(istype(target, /mob/new_player))
			continue

		if(target in targets_to_garble)
			to_chat_spaced(target, html = "[SPAN_ANNOUNCEMENT_HEADER(title)]<br><br>[SPAN_ANNOUNCEMENT_BODY(garbled_message)]", type = MESSAGE_TYPE_RADIO)
		else
			to_chat_spaced(target, html = "[SPAN_ANNOUNCEMENT_HEADER(title)]<br><br>[SPAN_ANNOUNCEMENT_BODY(message)]", type = MESSAGE_TYPE_RADIO)

		if(!quiet && sound_to_play)
			if(isobserver(target) && !(target.client?.prefs?.toggles_sound & SOUND_OBSERVER_ANNOUNCEMENTS))
				continue
			playsound_client(target.client, sound_to_play, target, vol = 45)
