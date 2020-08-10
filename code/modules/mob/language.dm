/*
	Datum based languages. Easily editable and modular.
*/

/datum/language
	var/name = "an unknown language" // Fluff name of language if any.
	var/desc = "A language."         // Short description for 'Check Languages'.
	var/speech_verb = "says"         // 'says', 'hisses', 'farts'.
	var/ask_verb = "asks"            // Used when sentence ends in a ?
	var/exclaim_verb = "exclaims"    // Used when sentence ends in a !
	var/signlang_verb = list()       // list of emotes that might be displayed if this language has NONVERBAL or SIGNLANG flags
	var/colour = "body"         	 // CSS style to use for strings in this language.
	var/key = "x"                    // Character used to speak in language eg. :o for Unathi.
	var/flags = 0                    // Various language flags.
	var/native                       // If set, non-native speakers will have trouble speaking.

/datum/language/proc/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)

	log_say("[key_name(speaker)] : ([name]) [message]")

	for(var/mob/player in player_list)

		var/understood = 0

		if(istype(player,/mob/dead))
			understood = 1
		else if((src in player.languages) && check_special_condition(player))
			understood = 1

		if(understood)
			if(!speaker_mask) speaker_mask = speaker.name
			var/msg = "<i><span class='game say'>[name], <span class='name'>[speaker_mask]</span> <span class='message'>[speech_verb], \"<span class='[colour]'>[message]</span><span class='message'>\"</span></span></span></i>"
			to_chat(player, "[msg]")

/datum/language/proc/check_special_condition(var/mob/other)
	return 1

/datum/language/proc/get_spoken_verb(var/msg_end)
	switch(msg_end)
		if("!")
			return exclaim_verb
		if("?")
			return ask_verb
	return speech_verb


/datum/language/common
	name = "English"
	desc = "Common earth English."
	speech_verb = "says"
	key = "0"
	flags = RESTRICTED

/datum/language/common/get_spoken_verb(var/msg_end)
	switch(msg_end)
		if("!")
			return pick("exclaims","shouts","yells") //TODO: make the basic proc handle lists of verbs.
		if("?")
			return ask_verb
	return speech_verb

/*
/datum/language/human
	name = "Sol Common"
	desc = "A bastardized hybrid of informal English and elements of Mandarin Chinese; the common language of the Sol system."
	colour = "rough"
	key = "1"
	flags = RESTRICTED
*/

// Galactic common languages (systemwide accepted standards).
/datum/language/trader
	name = "Tradeband"
	desc = "Maintained by the various trading cartels in major systems, this elegant, structured language is used for bartering and bargaining."
	speech_verb = "enunciates"
	colour = "say_quote"
	key = "2"

/datum/language/russian
	name = "Russian"
	desc = "An East Slavic language from Earth."
	speech_verb = "says"
	colour = "soghun"
	key = "3"

/datum/language/sainja //Yautja tongue
	name = "Sainja"
	desc = "The deep, rumbling, gutteral sounds of the Yautja predators. It is difficult to speak for those without facial mandibles."
	speech_verb = "rumbles"
	ask_verb = "rumbles"
	exclaim_verb = "roars"
	colour = "tajaran"
	key = "s"
	flags = WHITELISTED

/datum/language/monkey
	name = "Primitive"
	desc = "Ook ook ook."
	speech_verb = "chimpers"
	ask_verb = "chimpers"
	exclaim_verb = "screeches"
	colour = "monkey"
	key = "m"

/datum/language/xenocommon
	name = "Xenomorph"
	colour = "xeno"
	desc = "The common tongue of the xenomorphs."
	speech_verb = "hisses"
	ask_verb = "hisses"
	exclaim_verb = "hisses"
	key = "x"
	flags = RESTRICTED

/datum/language/xenos
	name = "Hivemind"
	desc = "Xenomorphs have the strange ability to commune over a psychic hivemind."
	speech_verb = "hiveminds"
	ask_verb = "hiveminds"
	exclaim_verb = "hiveminds"
	colour = "xeno"
	key = "q"
	flags = RESTRICTED|HIVEMIND

//Make queens BOLD text
/datum/language/xenos/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)
	if(iscarbon(speaker))
		var/mob/living/carbon/C = speaker

		if(!C.hivenumber in hive_datum)
			return

		C.hivemind_broadcast(message, hive_datum[C.hivenumber])

/datum/language/binary
	name = "Robot Talk"
	desc = "Most human stations support free-use communications protocols and routing hubs for synthetic use."
	colour = "say_quote"
	speech_verb = "states"
	ask_verb = "queries"
	exclaim_verb = "declares"
	key = "6"
	flags = RESTRICTED|HIVEMIND
	var/drone_only

/datum/language/binary/broadcast(var/mob/living/speaker,var/message,var/speaker_mask)

	if(!speaker.binarycheck())
		return

	if (!message)
		return

	var/message_start = "<i><span class='game say'>[name], <span class='name'>[speaker.name]</span>"
	var/message_body = "<span class='message'>[speaker.say_quote(message)], \"[message]\"</span></span></i>"
	STUI.game.Add("\[[time_stamp()]]<font color='#FFFF00'>BINARY: [key_name(speaker)] : [message]</font><br>")
	STUI.processing |= STUI_LOG_GAME_CHAT
	for (var/mob/M in dead_mob_list)
		if(!istype(M,/mob/new_player) && !istype(M,/mob/living/brain)) //No meta-evesdropping
			M.show_message("[message_start] [message_body]", 2)

	for (var/mob/living/S in living_mob_list)

		if(drone_only && !ismaintdrone(S))
			continue
		else if(isAI(S))
			message_start = "<i><span class='game say'>[name], <a href='byond://?src=\ref[S];track2=\ref[S];track=\ref[speaker];trackname=[html_encode(speaker.name)]'><span class='name'>[speaker.name]</span></a>"
		else if (!S.binarycheck())
			continue

		S.show_message("[message_start] [message_body]", 2)

	var/list/listening = hearers(1, src)
	listening -= src

	for (var/mob/living/M in listening)
		if(isSilicon(M) || M.binarycheck())
			continue
		M.show_message("<i><span class='game say'><span class='name'>synthesised voice</span> <span class='message'>beeps, \"beep beep beep\"</span></span></i>",2)

	//robot binary xmitter component power usage
	if (isrobot(speaker))
		var/mob/living/silicon/robot/R = speaker
		var/datum/robot_component/C = R.components["comms"]
		R.cell_use_power(C.active_usage)

/datum/language/binary/drone
	name = "Drone Talk"
	desc = "A heavily encoded damage control coordination stream."
	speech_verb = "transmits"
	ask_verb = "transmits"
	exclaim_verb = "transmits"
	colour = "say_quote"
	key = "d"
	flags = RESTRICTED|HIVEMIND
	drone_only = 1

// Language handling.
/mob/proc/add_language(var/language)
	var/datum/language/new_language = all_languages[language]

	if(!istype(new_language) || new_language in languages)
		return 0

	languages.Add(new_language)
	return 1

/mob/proc/set_languages(var/list/new_languages)
	languages = list()
	for(var/language in new_languages)
		add_language(language)


/mob/proc/remove_language(var/rem_language)
	languages.Remove(all_languages[rem_language])
	return 0

/mob/proc/get_default_language()
	if (languages.len > 0)
		return languages[1]
	return null

// Can we speak this language, as opposed to just understanding it?
/mob/proc/can_speak(datum/language/speaking)
	return (universal_speak || speaking in src.languages)

//TBD
/mob/verb/check_languages()
	set name = "Check Known Languages"
	set category = "IC"
	set src = usr

	var/dat

	for(var/datum/language/L in languages)
		dat += "<b>[L.name] (:[L.key])</b><br/>[L.desc]<br/><br/>"

	show_browser(src, dat, "Known Languages", "checklanguage")
	return
