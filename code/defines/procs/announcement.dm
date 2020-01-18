#define COMMAND_ANNOUNCE		"Command Announcement"
#define QUEEN_ANNOUNCE			"The words of the Queen reverberate in your head..."
#define QUEEN_MOTHER_ANNOUNCE	SPAN_ANNOUNCEMENT_HEADER_BLUE("Queen Mother Psychic Directive")
#define XENO_GENERAL_ANNOUNCE	"You sense something unusual..."	//general xeno announcement that don't involve Queen, for nuke for example
#define YAUTJA_ANNOUNCE			"You receive a message from your ship AI..."	//preds announcement

//xenomorph hive announcement
/proc/xeno_announcement(var/message, var/hivenumber, var/title = QUEEN_ANNOUNCE)
	var/list/targets = living_xeno_list + dead_mob_list

	if(hivenumber == 6)
		announcement_helper(message, SPAN_ANNOUNCEMENT_HEADER_BLUE("Unknown Higher Force"), targets, sound(get_sfx("queen"),wait = 0,volume = 50))
	else
		for(var/mob/living/carbon/Xenomorph/X in targets)
			if(istype(X) && X.hivenumber != hivenumber)	//If from the wrong hive, don't announce for them
				targets -= X
		announcement_helper(message, title, targets, sound(get_sfx("queen"),wait = 0,volume = 50))


//general marine announcement
/proc/marine_announcement(var/message, var/title = COMMAND_ANNOUNCE, var/sound_to_play = sound('sound/misc/notice2.ogg'), var/faction_to_display = FACTION_MARINE, var/add_PMCs = TRUE)

	var/list/targets = human_mob_list + dead_mob_list
	if(faction_to_display == FACTION_MARINE)
		for(var/mob/living/carbon/human/H in targets)
			if(!istype(H) && !isobserver(H) || H.stat != CONSCIOUS || isYautja(H) || H.faction != faction_to_display && !add_PMCs || H.faction != faction_to_display && add_PMCs && H.faction != FACTION_PMC)
				targets.Remove(H)
	else if(faction_to_display == "Everyone (-Yautja)")
		for(var/mob/living/carbon/human/H in targets)
			if(!istype(H) && !isobserver(H) || H.stat != CONSCIOUS || isYautja(H))
				targets.Remove(H)
	else
		for(var/mob/living/carbon/human/H in targets)
			if(!istype(H) && !isobserver(H) || H.stat != CONSCIOUS || isYautja(H) || H.faction != faction_to_display)
				targets.Remove(H)

	announcement_helper(message, title, targets, sound_to_play)

//yautja ship AI announcement
/proc/yautja_announcement(var/message, var/title = YAUTJA_ANNOUNCE, var/sound_to_play = sound('sound/misc/notice1.ogg'))
	var/list/targets = human_mob_list + dead_mob_list
	for(var/mob/living/carbon/human/H in targets)
		if(!isYautja(H) && !isobserver(H) || H.stat != CONSCIOUS)
			targets.Remove(H)

	announcement_helper(message, title, targets, sound_to_play)

//AI announcement that uses talking into comms
/proc/ai_announcement(var/message, var/sound_to_play = sound('sound/misc/interference.ogg'))
	for(var/mob/M in (human_mob_list + dead_mob_list))
		if(isobserver(M) || (ishuman(M) && M.z == MAIN_SHIP_Z_LEVEL))
			playsound(M, sound_to_play, 50, FALSE, 0)

	for(var/mob/living/silicon/decoy/ship_ai/AI in ai_mob_list)
		return AI.say(message, sound_to_play)

//AI shipside announcement, that uses announcement mechanic instead of talking into comms
//to ensure that all humans on ship hear it regardless of comms and power
/proc/shipwide_ai_announcement(var/message, var/title = MAIN_AI_SYSTEM, var/sound_to_play = sound('sound/misc/interference.ogg'))
	var/list/targets = human_mob_list + dead_mob_list
	for(var/mob/T in targets)
		if(isYautja(T) || !ishuman(T) && !isobserver(T) || ishuman(T) && T.z != MAIN_SHIP_Z_LEVEL)
			targets.Remove(T)

	announcement_helper(message, title, targets, sound_to_play)

//the announcement proc that handles announcing for each mob in targets list
/proc/announcement_helper(var/message, var/title, var/list/targets, var/sound_to_play)
	if(!message || !title || !sound_to_play || !targets) //Shouldn't happen
		return

	for(var/T in targets)
		if(istype(T, /mob/new_player))
			continue

		to_chat(T, "<br>[SPAN_ANNOUNCEMENT_HEADER(title)]<br><br>[SPAN_ANNOUNCEMENT_BODY(message)]<br>")
		playsound(T, sound_to_play, 50, FALSE, 0)