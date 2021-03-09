var/list/department_radio_keys = list(
	  ":i" = "intercom",	"#i" = "intercom",		".i" = "intercom",
	  ":h" = "department",	"#h" = "department",	".h" = "department",
	  ":+" = "special",		"#+" = "special",		".+" = "special", //activate radio-specific special functions
	  ":w" = "whisper",		"#w" = "whisper",		".w" = "whisper",
	  ":t" = "HighCom",		"#t" = "HighCom",		".t" = "HighCom",

	  ":m" = "MedSci",		"#m" = "MedSci",		".m" = "MedSci",
	  ":e" = "Engi", 		"#e" = "Engi",			".e" = "Engi",
	  ":g" = "Almayer",		"#g" = "Almayer",		".g" = "Almayer",
	  ":v" = "Command",		"#v" = "Command",		".v" = "Command",
	  ":a" = SQUAD_NAME_1,	"#a" = SQUAD_NAME_1,	".a" = SQUAD_NAME_1,
	  ":b" = SQUAD_NAME_2,	"#b" = SQUAD_NAME_2,	".b" = SQUAD_NAME_2,
	  ":c" = SQUAD_NAME_3,	"#c" = SQUAD_NAME_3,	".c" = SQUAD_NAME_3,
	  ":d" = SQUAD_NAME_4,	"#d" = SQUAD_NAME_4,	".d" = SQUAD_NAME_4,
	  ":p" = "MP",			"#p" = "MP",			".p" = "MP",
	  ":u" = "Req",			"#u" = "Req",			".u" = "Req",
	  ":j" = "JTAC",		"#j" = "JTAC",			".j" = "JTAC",
	  ":z" = "Intel",		"#z" = "Intel",			".z" = "Intel",
	  ":y" = "WY",			"#y" = "WY",			".y" = "WY",

	  ":R" = "right ear",	"#R" = "right ear",		".R" = "right ear",
	  ":L" = "left ear",	"#L" = "left ear",		".L" = "left ear",
	  ":I" = "intercom",	"#I" = "intercom",		".I" = "intercom",
	  ":H" = "department",	"#H" = "department",	".H" = "department",
	  ":W" = "whisper",		"#W" = "whisper",		".W" = "whisper",
	  ":T" = "HighCom",		"#T" = "HighCom",		".T" = "HighCom",

	  ":M" = "MedSci",		"#M" = "MedSci",		".M" = "MedSci",
	  ":E" = "Engi", 		"#E" = "Engi",			".E" = "Engi",
	  ":G" = "Almayer",		"#G" = "Almayer",		".G" = "Almayer",
	  ":V" = "Command",		"#V" = "Command",		".V" = "Command",
	  ":A" = SQUAD_NAME_1,	"#A" = SQUAD_NAME_1,	".A" = SQUAD_NAME_1,
	  ":B" = SQUAD_NAME_2,	"#B" = SQUAD_NAME_2,	".B" = SQUAD_NAME_2,
	  ":C" = SQUAD_NAME_3,	"#C" = SQUAD_NAME_3,	".C" = SQUAD_NAME_3,
	  ":D" = SQUAD_NAME_4,	"#D" = SQUAD_NAME_4,	".D" = SQUAD_NAME_4,
	  ":P" = "MP",			"#P" = "MP",			".P" = "MP",
	  ":U" = "Req",			"#U" = "Req",			".U" = "Req",
	  ":J" = "JTAC",		"#J" = "JTAC",			".J" = "JTAC",
	  ":Z" = "Intel",		"#Z" = "Intel",			".Z" = "Intel",
	  ":Y" = "WY",			"#Y" = "WY",			".Y" = "WY",

	  //kinda localization -- rastaf0
	  //same keys as above, but on russian keyboard layout. This file uses cp1251 as encoding.
	  ":�" = "right ear",	"#�" = "right ear",		".�" = "right ear",
	  ":�" = "left ear",	"#�" = "left ear",		".�" = "left ear",
	  ":�" = "intercom",	"#�" = "intercom",		".�" = "intercom",
	  ":�" = "department",	"#�" = "department",	".�" = "department",
	  ":�" = "Command",		"#�" = "Command",		".�" = "Command",
	  ":�" = "Medical",		"#�" = "Medical",		".�" = "Medical",
	  ":�" = "Engineering",	"#�" = "Engineering",	".�" = "Engineering",
	  ":�" = "whisper",		"#�" = "whisper",		".�" = "whisper",
	  ":�" = "Syndicate",	"#�" = "Syndicate",		".�" = "Syndicate",
)

/mob/living/proc/binarycheck()
	if (!ishuman(src))
		return

	var/mob/living/carbon/human/H = src
	if (H.wear_ear)
		var/obj/item/device/radio/headset/dongle
		if(istype(H.wear_ear,/obj/item/device/radio/headset))
			dongle = H.wear_ear
		if(!istype(dongle)) return
		if(dongle.translate_binary) return 1

/mob/living/proc/show_speech_bubble(var/bubble_name)
	var/list/hear = hearers()

	var/image/speech_bubble = image('icons/mob/hud/talk.dmi',src,"[bubble_name]")

	if(appearance_flags & PIXEL_SCALE)
		speech_bubble.appearance_flags |= PIXEL_SCALE

	for(var/mob/M in hear)
		M << speech_bubble

	addtimer(CALLBACK(src, .proc/remove_speech_bubble, speech_bubble, hear), 30)


/mob/living/proc/remove_speech_bubble(var/image/speech_bubble, var/list_of_mobs)
	if(client)
		client.images -= speech_bubble

	for(var/mob/M in list_of_mobs)
		if(M.client)
			M.client.images -= speech_bubble

	speech_bubble = null

#define ENDING_PUNCT list(".", "-", "?", "!")

/mob/living/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/italics=0, var/message_range = world_view_size, var/sound/speech_sound, var/sound_vol, var/nolog = 0, var/message_mode = null)
	var/turf/T

	// Automatic punctuation
	if (client && client.prefs && client.prefs.toggle_prefs & TOGGLE_AUTOMATIC_PUNCTUATION)
		if (!(copytext(message, -1) in ENDING_PUNCT))
			message += "."

	if(SEND_SIGNAL(src, COMSIG_LIVING_SPEAK, message, speaking, verb, alt_name, italics, message_range, speech_sound, sound_vol, nolog, message_mode) & COMPONENT_OVERRIDE_SPEAK) return

	for(var/dst=0; dst<=1; dst++) //Will run twice if src has a clone
		if(!dst && src.clone) //Will speak in src's location and the clone's
			T = locate(src.loc.x + src.clone.proj_x, src.loc.y + src.clone.proj_y, src.loc.z)
		else
			T = get_turf(src)
			dst++ //Only speak once

		//handle nonverbal and sign languages here
		if (speaking)
			if (speaking.flags & NONVERBAL)
				if (prob(30))
					src.custom_emote(1, "[pick(speaking.signlang_verb)].")

			if (speaking.flags & SIGNLANG)
				say_signlang(message, pick(speaking.signlang_verb), speaking)
				return 1

		var/list/listening = list()
		var/list/listening_obj = list()

		if(T)
			var/list/hear = hear(message_range, T)
			var/list/hearturfs = list()

			for(var/I in hear)
				if(istype(I, /mob/))
					var/mob/M = I
					listening += M
					hearturfs += M.locs[1]
					for(var/obj/O in M.contents)
						listening_obj |= O
				else if(istype(I, /obj/))
					var/obj/O = I
					hearturfs += O.locs[1]
					listening_obj |= O


			for(var/mob/M in GLOB.player_list)
				if((M.stat == DEAD || isobserver(M)) && M.client && M.client.prefs && (M.client.prefs.toggles_chat & CHAT_GHOSTEARS))
					listening |= M
					continue
				if(M.loc && (M.locs[1] in hearturfs))
					listening |= M

		var/speech_bubble_test = say_test(message)
		var/image/speech_bubble = image('icons/mob/hud/talk.dmi',src,"h[speech_bubble_test]")

		var/not_dead_speaker = (stat != DEAD)
		if(not_dead_speaker)
			langchat_make_image(message, listening, speaking)
		for(var/mob/M in listening)
			if(not_dead_speaker)
				M << speech_bubble
			M.hear_say(message, verb, speaking, alt_name, italics, src, speech_sound, sound_vol)

		addtimer(CALLBACK(src, .proc/remove_speech_bubble, speech_bubble, listening), 30)

		for(var/obj/O in listening_obj)
			if(O) //It's possible that it could be deleted in the meantime.
				O.hear_talk(src, message, verb, speaking, italics)

	//used for STUI to stop logging of animal messages and radio
	//if(!nolog)
	//Rather see stuff twice then not at all.

	// Log people differently, first, check if they are human
	if(ishuman(src))
		if(message_mode)	// we are talking into a radio
			if(message_mode == "headset")	// default value, means general
				message_mode = "General"
			log_say("[name] \[[message_mode]\]: [message] (CKEY: [key]) (JOB: [job])")
		else				// we talk normally
			log_say("[name]: [message] (CKEY: [key]) (JOB: [job])")
	else
		log_say("[name]: [message] (CKEY: [key])")

	return 1

#undef ENDING_PUNCT

/mob/living/proc/say_signlang(var/message, var/verb="gestures", var/datum/language/language)
	for (var/mob/O in viewers(src, null))
		O.hear_signlang(message, verb, language, src)

/obj/effect/speech_bubble
	var/mob/parent

/mob/living/proc/GetVoice()
	return name
