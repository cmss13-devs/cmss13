/datum/language/common
	name = "English"
	desc = "Common earth English."
	speech_verb = "says"
	key = "0"
	flags = RESTRICTED

	syllables = list("al", "an", "ar", "as", "at", "ea", "ed", "en", "er", "es", "ha", "he", "hi", "in", "is", "it", "le", "me", "nd", "ne", "ng", "nt", "on", "or", "ou", "re", "se", "st", "te", "th", "ti", "to", "ve", "wa", "all", "and", "are", "but", "ent", "era", "ere", "eve", "for", "had", "hat", "hen", "her", "hin", "his", "ing", "ion", "ith", "not", "ome", "oul", "our", "sho", "ted", "ter", "tha", "the", "thi", "tio", "uld", "ver", "was", "wit", "you")

/datum/language/common/get_spoken_verb(var/msg_end)
	switch(msg_end)
		if("!")
			return pick("exclaims","shouts","yells") //TODO: make the basic proc handle lists of verbs.
		if("?")
			return ask_verb
	return speech_verb

// Galactic common languages (systemwide accepted standards).
/datum/language/japanese
	name = "Japanese"
	desc = "A language boasting an extensive grammatical system, three writing systems, and a new smattering of English loanwords. This gained popularity due to high cultural contact in the RESS, and finds use outside due to immigration."
	speech_verb = "vocalizes"
	colour = "japanese"
	key = "2"

	syllables = list("ka", "ki", "ku", "ke", "ko", "ta", "chi", "tsu", "te", "to", "sa", "shi", "su", "se", "so", "na", "ni", "nu", "ne", "no", "n", "ha", "hi", "fu", "he", "ho", "ma", "mi", "mu", "me", "mo", "ya", "yu", "yo", "ra", "ri", "ru", "re", "ro", "wa", "wo")

/datum/language/russian
	name = "Russian"
	desc = "An East Slavic language from Earth."
	speech_verb = "says"
	colour = "soghun"
	key = "3"

	syllables = list("al", "an", "bi", "vye", "vo", "go", "dye", "yel", "?n", "yer", "yet", "ka", "ko", "la", "ly", "lo", "l", "na", "nye", "ny", "no", "ov", "ol", "on", "or", "slog", "ot", "po", "pr", "ra", "rye", "ro", "st", "ta", "tye", "to", "t", "at", "bil", "vyer", "yego", "yeny", "yenn", "yest", "kak", "ln", "ova", "ogo", "oro", "ost", "oto", "pry", "pro", "sta", "stv", "tor", "chto", "eto")

/datum/language/german
	name = "Spacendeutchen"
	desc = "A common dialect consisting of a hybrid between American English and German developed due to the high immigration and subsequent enlistment of German-Americans into the USCM."
	speech_verb = "proclaims"
	ask_verb = "inquires"
	exclaim_verb = "bellows loudly"
	colour = "german"
	key = "4"

	syllables = list("die", "das", "wein", "mir", "und", "wier", "ein", "nein", "gen", "en", "sauen", "bien", "nien", "rien", "rhein", "deut", "der", "lieb", "en", "stein", "nein", "ja", "wolle", "sil", "be")

/datum/language/spanish
	name = "Spanish"
	desc = "The second most common language spoken in the UA, mostly concentrated and brought from marines from the Latin American territories and in the former southern USA."
	speech_verb = "dice"
	ask_verb = "cuestiona"
	exclaim_verb = "grita"
	colour = "spanish"
	key = "5"

	syllables = list("ha", "pana", "ja", "blo", "que", "spa", "di", "ga", "na", "ces", "si", "mo", "so", "de", "el", "to", "ro", "mi", "ca", "la", "di", "ah", "mio", "tar", "ion", "gran", "van", "jo", "cie", "qie", "las", "locho", "mas")

/datum/language/commando
	name = "Tactical Sign Language"
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
	name = "Sainja"
	desc = "The deep, rumbling, gutteral sounds of the Yautja predators. It is difficult to speak for those without facial mandibles."
	speech_verb = "rumbles"
	ask_verb = "rumbles"
	exclaim_verb = "roars"
	colour = "tajaran"
	key = "s"
	flags = WHITELISTED

	syllables = list("!", "?", ".", "@", "$", "%", "^", "&", "*", "-", "=", "+", "e", "b", "y", "p", "|", "z", "~", ">")
	space_chance = 20

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
	colour = "xenotalk"
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

		if(!(C.hivenumber in GLOB.hive_datum))
			return

		C.hivemind_broadcast(message, GLOB.hive_datum[C.hivenumber])

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
	name = "Drone Talk"
	desc = "A heavily encoded damage control coordination stream."
	speech_verb = "transmits"
	ask_verb = "transmits"
	exclaim_verb = "transmits"
	colour = "say_quote"
	key = "d"
	flags = RESTRICTED|HIVEMIND
	drone_only = 1
