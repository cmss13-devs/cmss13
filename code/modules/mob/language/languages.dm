/datum/language/common
	name = LANGUAGE_ENGLISH
	desc = "Common Earth English. The standard language of the United Americas."
	speech_verb = "says"
	key = "1"
	flags = RESTRICTED

	syllables = list("al", "an", "ar", "as", "at", "ea", "ed", "en", "er", "es", "ha", "he", "hi", "in", "is", "it", "le", "me", "nd", "ne", "ng", "nt", "on", "or", "ou", "re", "se", "st", "te", "th", "ti", "to", "ve", "wa", "all", "and", "are", "but", "ent", "era", "ere", "eve", "for", "had", "hat", "hen", "her", "hin", "his", "ing", "ion", "ith", "not", "ome", "oul", "our", "sho", "ted", "ter", "tha", "the", "thi", "tio", "uld", "ver", "was", "wit", "you")

/datum/language/common/get_spoken_verb(var/msg_end)
	switch(msg_end)
		if("!")
			return pick("exclaims","shouts","yells") //TODO: make the basic proc handle lists of verbs.
		if("?")
			return ask_verb
	return speech_verb


/datum/language/generated //parent type for languages with custom sound generation methods like chinese and japanese
	space_chance = 100 //uses a unique system

// Galactic common languages (systemwide accepted standards).
/datum/language/generated/japanese
	name = LANGUAGE_JAPANESE
	desc = "A notoriously complex language boasting an extensive grammatical system, three writing systems, and a new smattering of English loanwords. It has gained popularity due to high cultural contact in the 3WE, and finds use outside due to emigration."
	speech_verb = "vocalizes"
	colour = "japanese"
	key = "2"


/datum/language/generated/chinese
	name = LANGUAGE_CHINESE
	desc = "The secondary language of the UPP, widespread around Asia and with a notable immigrant population in other parts of the world. The most spoken language in charted space."
	speech_verb = "shuo"
	ask_verb = "wen"
	exclaim_verb = "han"
	colour = "chinese"
	key = "8"

/datum/language/russian
	name = LANGUAGE_RUSSIAN
	desc = "An East Slavic language from Earth. The dominant tongue of the UPP and frequently used by Slavic minorities in the United Americas."
	speech_verb = "enunciates"
	colour = "soghun"
	key = "3"

	syllables = list("al", "an", "bi", "vye", "vo", "go", "dye", "yel", "en", "yer", "yet", "ka", "ko", "la", "ly", "lo", "l", "na", "nye", "ny", "no", "ov", "ol", "on", "or", "slog", "ot", "po", "pr", "ra", "rye", "ro", "st", "ta", "tye", "to", "t", "at", "bil", "vyer", "yego", "yeny", "yenn", "yest", "kak", "ln", "ova", "ogo", "oro", "ost", "oto", "pry", "pro", "sta", "stv", "tor", "chto", "eto", "rus", "nar", "arya", "mol")

/datum/language/german
	name = LANGUAGE_WELTRAUMDEUTSCH
	desc = "A common dialect consisting of a hybrid between American English and Hochdeutsch developed due to the high immigration and subsequent enlistment of German-Americans into the USCM."
	speech_verb = "proclaims"
	ask_verb = "inquires"
	exclaim_verb = "bellows"
	colour = "german"
	key = "4"

	syllables = list("die", "das", "wein", "mir", "und", "wir", "ein", "nein", "gen", "en", "sauen", "bin", "nein", "rhein", "deut", "der", "lieb", "en", "stein", "nein", "ja", "wolle", "sil", "bei", "der", "sie", "sch", "kein", "nur", "ach", "kann", "volk", "vau", "gelb", "grun", "macht", "zwei", "vier", "nacht", "tag")

/datum/language/spanish
	name = LANGUAGE_NEOSPANISH
	desc = "The second most common language spoken in the UA, mutated and brought from marines from the Latin American territories and in the former southern USA."
	speech_verb = "dice"
	ask_verb = "cuestiona"
	exclaim_verb = "grita"
	colour = "spanish"
	key = "5"

	syllables = list("ha", "pana", "ja", "blo", "que", "spa", "di", "ga", "na", "ces", "si", "mo", "so", "de", "el", "to", "ro", "mi", "ca", "la", "di", "ah", "mio", "tar", "ion", "gran", "van", "jo", "cie", "qie", "las", "locho", "mas", "no", "gui", "es", "mal")

/datum/language/commando
	name = LANGUAGE_TSL
	desc = "TSL is a modern technique with a combination of modified American sign language, tactical hand signals and discreet and esoteric code names for radios only known by elite commando groups."
	speech_verb = "discreetly communicates"
	ask_verb = "interrogates"
	exclaim_verb = "orders"
	colour = "commando"
	key = "l"

	syllables = list("A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z", "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0", "!", "?", "@", "#" ,"*")
	sentence_chance = 50
	space_chance = 50

/datum/language/sainja //Yautja tongue
	name = LANGUAGE_YAUTJA
	desc = "The deep, rumbling, guttural sounds of the Yautja predators. It is difficult to speak for those without facial mandibles."
	speech_verb = "rumbles"
	ask_verb = "rumbles"
	exclaim_verb = "roars"
	colour = "tajaran"
	key = "s"
	flags = WHITELISTED

	syllables = list("!", "?", ".", "@", "$", "%", "^", "&", "*", "-", "=", "+", "e", "b", "y", "p", "|", "z", "~", ">")
	space_chance = 20

/datum/language/hellhound
	name = LANGUAGE_HELLHOUND
	desc = "A growling, guttural method of communication, only Hellhounds seem to be capable of producing these sounds."
	speech_verb = "growls"
	ask_verb = "grumbles"
	exclaim_verb = "snarls"
	colour = "monkey"
	key = "h"

/datum/language/hellhound/scramble(input)
	return pick("Grrr...", "Grah!", "Gurrr..")

/datum/language/primitive
	name = LANGUAGE_MONKEY
	desc = "Ook ook ook."
	speech_verb = "chimpers"
	ask_verb = "chimpers"
	exclaim_verb = "screeches"
	colour = "monkey"
	key = "9"

/datum/language/xenomorph
	name = LANGUAGE_XENOMORPH
	colour = "xenotalk"
	desc = "The common tongue of the xenomorphs."
	speech_verb = "hisses"
	ask_verb = "hisses"
	exclaim_verb = "hisses"
	key = "x"
	flags = RESTRICTED

/datum/language/xenos
	name = LANGUAGE_HIVEMIND
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

		if(!(C.hivenumber in GLOB.hive_datum))
			return

		C.hivemind_broadcast(message, GLOB.hive_datum[C.hivenumber])

/datum/language/binary
	name = LANGUAGE_BINARY
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
	GLOB.STUI.game.Add("\[[time_stamp()]]<font color='#FFFF00'>BINARY: [key_name(speaker)] : [message]</font><br>")
	GLOB.STUI.processing |= STUI_LOG_GAME_CHAT
	for (var/mob/M in GLOB.dead_mob_list)
		if(!istype(M,/mob/new_player) && !istype(M,/mob/living/brain)) //No meta-evesdropping
			M.show_message("[message_start] [message_body]", 2)

	for (var/mob/living/S in GLOB.alive_mob_list)

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
	name = LANGUAGE_DRONE
	desc = "A heavily encoded damage control coordination stream."
	speech_verb = "transmits"
	ask_verb = "transmits"
	exclaim_verb = "transmits"
	colour = "say_quote"
	key = "d"
	flags = RESTRICTED|HIVEMIND
	drone_only = 1

/datum/language/event_hivemind
	name = LANGUAGE_TELEPATH
	desc = "An event only language that provides a hivemind for its users."
	speech_verb = "resonates"
	ask_verb = "resonates"
	exclaim_verb = "resonates"
	colour = "tajaran"
	key = "7"
	flags = RESTRICTED|HIVEMIND
