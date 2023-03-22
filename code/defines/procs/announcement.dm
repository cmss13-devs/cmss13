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
		for(var/mob/mob in targets)
			var/mob/living/carbon/xenomorph/xenomorph = mob
			if(!isobserver(xenomorph) && !istype(xenomorph)) //filter out any potential non-xenomorphs/observers mobs
				targets.Remove(xenomorph)

		announcement_helper(message, title, targets, sound(get_sfx("queen"),wait = 0,volume = 50))
	else
		for(var/mob/mob in targets)
			if(isobserver(mob))
				continue
			var/mob/living/carbon/xenomorph = mob
			if(!istype(xenomorph) || !xenomorph.ally_of_hivenumber(hivenumber)) //additionally filter out those of wrong hive
				targets.Remove(xenomorph)

		announcement_helper(message, title, targets, sound(get_sfx("queen"),wait = 0,volume = 50))


//general marine announcement
/proc/marine_announcement(message, title = COMMAND_ANNOUNCE, sound_to_play = sound('sound/misc/notice2.ogg'), faction_to_display = FACTION_MARINE, add_PMCs = TRUE, signature)
	var/list/targets = GLOB.human_mob_list + GLOB.dead_mob_list
	if(faction_to_display == FACTION_MARINE)
		for(var/mob/mob in targets)
			if(isobserver(mob)) //observers see everything
				continue
			var/mob/living/carbon/human/human = mob
			if(!istype(human) || human.stat != CONSCIOUS || isyautja(human)) //base human checks
				targets.Remove(human)
				continue
			if(is_mainship_level(human.z)) // People on ship see everything
				continue
			if((human.faction != faction_to_display && !add_PMCs) || (human.faction != faction_to_display && add_PMCs && !(human.faction in FACTION_LIST_WY)) && !(faction_to_display in human.faction_group)) //faction checks
				targets.Remove(human)

	else if(faction_to_display == "Everyone (-Yautja)")
		for(var/mob/mob in targets)
			if(isobserver(mob)) //observers see everything
				continue
			var/mob/living/carbon/human/human = mob
			if(!istype(human) || human.stat != CONSCIOUS || isyautja(human))
				targets.Remove(human)

	else
		for(var/mob/mob in targets)
			if(isobserver(mob)) //observers see everything
				continue
			var/mob/living/carbon/human/human = mob
			if(!istype(human) || human.stat != CONSCIOUS || isyautja(human))
				targets.Remove(human)
				continue
			if(human.faction != faction_to_display)
				targets.Remove(human)

	if(!isnull(signature))
		message += "<br><br><i> Signed by, <br> [signature]</i>"

	announcement_helper(message, title, targets, sound_to_play)

//yautja ship AI announcement
/proc/yautja_announcement(message, title = YAUTJA_ANNOUNCE, sound_to_play = sound('sound/misc/notice1.ogg'))
	var/list/targets = GLOB.human_mob_list + GLOB.dead_mob_list
	for(var/mob/mob in targets)
		if(isobserver(mob)) //observers see everything
			continue
		var/mob/living/carbon/human/human = mob
		if(!isyautja(human) || human.stat != CONSCIOUS)
			targets.Remove(human)

	announcement_helper(message, title, targets, sound_to_play)

//AI announcement that uses talking into comms
/proc/ai_announcement(message, sound_to_play = sound('sound/misc/interference.ogg'))
	for(var/mob/mob in (GLOB.human_mob_list + GLOB.dead_mob_list))
		if(isobserver(mob) || ishuman(mob) && is_mainship_level(mob.z))
			playsound_client(mob.client, sound_to_play, mob, vol = 45)

	for(var/mob/living/silicon/decoy/ship_ai/AI in ai_mob_list)
		INVOKE_ASYNC(AI, TYPE_PROC_REF(/mob/living/silicon/decoy/ship_ai, say), message)

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
	for(var/mob/current_turf in targets)
		if(isobserver(current_turf))
			continue
		if(!ishuman(current_turf) || isyautja(current_turf) || !is_mainship_level(current_turf.z))
			targets.Remove(current_turf)

	if(!isnull(signature))
		message += "<br><br><i> Signed by, <br> [signature]</i>"

	announcement_helper(message, title, targets, sound_to_play)
//Subtype of AI shipside announcement for "All Hands On Deck" alerts (COs and SEAs joining the game)
/proc/all_hands_on_deck(message, title = MAIN_AI_SYSTEM, sound_to_play = sound('sound/misc/sound_misc_boatswain.ogg'), signature)
	var/list/targets = GLOB.human_mob_list + GLOB.dead_mob_list
	for(var/mob/target in targets)
		if(isobserver(target))
			continue
		if(!ishuman(target) || isyautja(target) || !is_mainship_level(target.z))
			targets.Remove(target)

	announcement_helper(message, title, targets, sound_to_play)

//the announcement proc that handles announcing for each mob in targets list
/proc/announcement_helper(message, title, list/targets, sound_to_play)
	if(!message || !title || !sound_to_play || !targets) //Shouldn't happen
		return
	for(var/mob/target in targets)
		if(istype(target, /mob/new_player))
			continue

		to_chat_spaced(target, html = "[SPAN_ANNOUNCEMENT_HEADER(title)]<br><br>[SPAN_ANNOUNCEMENT_BODY(message)]")
		playsound_client(target.client, sound_to_play, target, vol = 45)
