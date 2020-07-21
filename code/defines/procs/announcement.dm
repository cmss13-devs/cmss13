#define COMMAND_ANNOUNCE		"Command Announcement"
#define QUEEN_ANNOUNCE			"The words of the Queen reverberate in your head..."
#define QUEEN_MOTHER_ANNOUNCE	"Queen Mother Psychic Directive"
#define XENO_GENERAL_ANNOUNCE	"You sense something unusual..."	//general xeno announcement that don't involve Queen, for nuke for example
#define YAUTJA_ANNOUNCE			"You receive a message from your ship AI..."	//preds announcement
#define HIGHER_FORCE_ANNOUNCE 	SPAN_ANNOUNCEMENT_HEADER_BLUE("Unknown Higher Force")

//xenomorph hive announcement
/proc/xeno_announcement(var/message, var/hivenumber, var/title = QUEEN_ANNOUNCE)
	var/list/targets = living_xeno_list + dead_mob_list
	if(hivenumber == "everything")
		for(var/mob/M in targets)
			var/mob/living/carbon/Xenomorph/X = M
			if(!isobserver(X) && !istype(X))	//filter out any potential non-xenomorphs/observers mobs
				targets.Remove(X)

		announcement_helper(message, title, targets, sound(get_sfx("queen"),wait = 0,volume = 50))
	else
		for(var/mob/M in targets)
			if(isobserver(M))
				continue
			var/mob/living/carbon/Xenomorph/X = M
			if(!istype(X) || X.hivenumber != hivenumber)	//additionally filter out those of wrong hive
				targets.Remove(X)

		announcement_helper(message, title, targets, sound(get_sfx("queen"),wait = 0,volume = 50))

//general marine announcement
/proc/marine_announcement(var/message, var/title = COMMAND_ANNOUNCE, var/sound_to_play = sound('sound/misc/notice2.ogg'), var/faction_to_display = FACTION_MARINE, var/add_PMCs = TRUE)
	var/list/targets = human_mob_list + dead_mob_list
	if(faction_to_display == FACTION_MARINE)
		for(var/mob/M in targets)
			if(isobserver(M))		//observers see everything
				continue
			var/mob/living/carbon/human/H = M
			if(!istype(H) || H.stat != CONSCIOUS || isYautja(H))	//base human checks
				targets.Remove(H)
				continue
			if(H.z == MAIN_SHIP_Z_LEVEL) // People on ship see everything
				continue
			if(H.faction != faction_to_display && !add_PMCs || H.faction != faction_to_display && add_PMCs && H.faction != FACTION_PMC)	//faction checks
				targets.Remove(H)

	else if(faction_to_display == "Everyone (-Yautja)")
		for(var/mob/M in targets)
			if(isobserver(M))		//observers see everything
				continue
			var/mob/living/carbon/human/H = M
			if(!istype(H) || H.stat != CONSCIOUS || isYautja(H))
				targets.Remove(H)

	else
		for(var/mob/M in targets)
			if(isobserver(M))		//observers see everything
				continue
			var/mob/living/carbon/human/H = M
			if(!istype(H) || H.stat != CONSCIOUS || isYautja(H))
				targets.Remove(H)
				continue
			if(H.faction != faction_to_display)
				targets.Remove(H)

	announcement_helper(message, title, targets, sound_to_play)

//yautja ship AI announcement
/proc/yautja_announcement(var/message, var/title = YAUTJA_ANNOUNCE, var/sound_to_play = sound('sound/misc/notice1.ogg'))
	var/list/targets = human_mob_list + dead_mob_list
	for(var/mob/M in targets)
		if(isobserver(M))		//observers see everything
			continue
		var/mob/living/carbon/human/H = M
		if(!isYautja(H) || H.stat != CONSCIOUS)
			targets.Remove(H)

	announcement_helper(message, title, targets, sound_to_play)

//AI announcement that uses talking into comms
/proc/ai_announcement(var/message, var/sound_to_play = sound('sound/misc/interference.ogg'))
	for(var/mob/M in (human_mob_list + dead_mob_list))
		if(isobserver(M) || ishuman(M) && M.z == MAIN_SHIP_Z_LEVEL)
			playsound_client(M.client, sound_to_play, M, vol = 45)

	for(var/mob/living/silicon/decoy/ship_ai/AI in ai_mob_list)
		return AI.say(message)

/proc/ai_silent_announcement(var/message, var/channel_prefix)
	if(!message)
		return

	for(var/mob/living/silicon/decoy/ship_ai/AI in ai_mob_list)
		if(AI.silent_announcement_cooldown >= world.time)
			continue

		AI.silent_announcement_cooldown = world.time + SECONDS_10
		if(channel_prefix)
			return AI.say(channel_prefix + " " +message)
		return AI.say(message)

//AI shipside announcement, that uses announcement mechanic instead of talking into comms
//to ensure that all humans on ship hear it regardless of comms and power
/proc/shipwide_ai_announcement(var/message, var/title = MAIN_AI_SYSTEM, var/sound_to_play = sound('sound/misc/interference.ogg'))
	var/list/targets = human_mob_list + dead_mob_list
	for(var/mob/T in targets)
		if(isobserver(T))
			continue
		if(!ishuman(T) || isYautja(T) || T.z != MAIN_SHIP_Z_LEVEL)
			targets.Remove(T)

	announcement_helper(message, title, targets, sound_to_play)

//the announcement proc that handles announcing for each mob in targets list
/proc/announcement_helper(var/message, var/title, var/list/targets, var/sound_to_play)
	if(!message || !title || !sound_to_play || !targets)	//Shouldn't happen
		return
	for(var/mob/T in targets)
		if(istype(T, /mob/new_player))
			continue

		to_chat(T, "<br>[SPAN_ANNOUNCEMENT_HEADER(title)]<br><br>[SPAN_ANNOUNCEMENT_BODY(message)]<br>")
		playsound_client(T.client, sound_to_play, T, vol = 45)