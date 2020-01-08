#define COMMAND_ANNOUNCE	"Command Announcement"
#define QUEEN_ANNOUNCE		"The words of the Queen reverberate in your head..."
#define XENO_GENERAL_ANNOUNCE	"You sense something unusual..."	//general xeno announcement that don't involve Queen, for nuke for example
#define YAUTJA_ANNOUNCE		"You receive a message from your ship AI..."	//preds announcement

/proc/xeno_announcement(message, hivenumber, title = QUEEN_ANNOUNCE)
	var/list/targets = living_xeno_list + dead_mob_list

	for(var/T in targets)
		var/mob/living/carbon/Xenomorph/X = T
		if(istype(X) && !(hivenumber == X.hivenumber))	//If from the wrong hive, don't announce for them
			targets -= X

	announcement_helper(message, title, targets, sound(get_sfx("queen"),wait = 0,volume = 50))

/proc/marine_announcement(message, title = COMMAND_ANNOUNCE, sound = sound('sound/misc/notice2.ogg'))
	var/list/targets = human_mob_list + dead_mob_list

	announcement_helper(message, title, targets, sound)

/proc/yautja_announcement(message, title = YAUTJA_ANNOUNCE, sound = sound('sound/misc/notice1.ogg'))
	var/list/targets = human_mob_list

	for(var/mob/living/carbon/human/H in targets)
		if(!isYautja(H) || H.stat != CONSCIOUS)
			targets.Remove(H)

	announcement_helper(message, title, targets, sound, TRUE)

/proc/announcement_helper(message, title, list/targets, sound, yautja = FALSE)
	if(!message || !title || !sound || !targets) //Shouldn't happen
		return

	for(var/T in targets)
		if(!yautja && isYautja(T))
			continue

		to_chat(T, "<br>[SPAN_ANNOUNCEMENT_HEADER(title)]<br><br>[SPAN_ANNOUNCEMENT_BODY(message)]<br>")
		T << sound

/proc/ai_announcement(var/message, var/sound = sound('sound/misc/notice2.ogg'))
	for(var/mob/M in (living_human_list + dead_mob_list))
		if(ishuman(M) || isobserver(M) && M.z == MAIN_SHIP_Z_LEVEL)
			M << sound

	for(var/mob/living/silicon/decoy/ship_ai/AI in ai_mob_list)
		return AI.say(message, sound)