var/list/department_radio_keys = list(
	  ":i" = RADIO_CHANNEL_INTERCOM,	"#i" = RADIO_CHANNEL_INTERCOM,		".i" = RADIO_CHANNEL_INTERCOM,
	  ":h" = RADIO_CHANNEL_DEPARTMENT,	"#h" = RADIO_CHANNEL_DEPARTMENT,	".h" = RADIO_CHANNEL_DEPARTMENT,
	  ":+" = RADIO_CHANNEL_SPECIAL,		"#+" = RADIO_CHANNEL_SPECIAL,		".+" = RADIO_CHANNEL_SPECIAL, //activate radio-specific special functions
	  ":w" = RADIO_MODE_WHISPER,		"#w" = RADIO_MODE_WHISPER,			".w" = RADIO_MODE_WHISPER,

	  ":m" = RADIO_CHANNEL_MEDSCI,		"#m" = RADIO_CHANNEL_MEDSCI,		".m" = RADIO_CHANNEL_MEDSCI,
	  ":n" = RADIO_CHANNEL_ENGI, 		"#n" = RADIO_CHANNEL_ENGI,			".n" = RADIO_CHANNEL_ENGI,
	  ":g" = RADIO_CHANNEL_ALMAYER,		"#g" = RADIO_CHANNEL_ALMAYER,		".g" = RADIO_CHANNEL_ALMAYER,
	  ":v" = RADIO_CHANNEL_COMMAND ,	"#v" = RADIO_CHANNEL_COMMAND ,		".v" = RADIO_CHANNEL_COMMAND ,
	  ":a" = SQUAD_MARINE_1,			"#a" = SQUAD_MARINE_1,				".a" = SQUAD_MARINE_1,
	  ":b" = SQUAD_MARINE_2,			"#b" = SQUAD_MARINE_2,				".b" = SQUAD_MARINE_2,
	  ":c" = SQUAD_MARINE_3,			"#c" = SQUAD_MARINE_3,				".c" = SQUAD_MARINE_3,
	  ":d" = SQUAD_MARINE_4,			"#d" = SQUAD_MARINE_4,				".d" = SQUAD_MARINE_4,
	  ":e" = SQUAD_MARINE_5,			"#e" = SQUAD_MARINE_5,				".e" = SQUAD_MARINE_5,
	  ":f" = SQUAD_MARINE_CRYO,			"#f" = SQUAD_MARINE_CRYO,			".f" = SQUAD_MARINE_CRYO,
	  ":p" = RADIO_CHANNEL_MP ,			"#p" = RADIO_CHANNEL_MP ,			".p" = RADIO_CHANNEL_MP ,
	  ":u" = RADIO_CHANNEL_REQ,			"#u" = RADIO_CHANNEL_REQ,			".u" = RADIO_CHANNEL_REQ,
	  ":j" = RADIO_CHANNEL_JTAC,		"#j" = RADIO_CHANNEL_JTAC,			".j" = RADIO_CHANNEL_JTAC,
	  ":t" = RADIO_CHANNEL_INTEL,		"#t" = RADIO_CHANNEL_INTEL,			".t" = RADIO_CHANNEL_INTEL,
	  ":y" = RADIO_CHANNEL_WY,			"#y" = RADIO_CHANNEL_WY,			".y" = RADIO_CHANNEL_WY,
	  ":o" = RADIO_CHANNEL_CCT,			"#o" = RADIO_CHANNEL_CCT,			".o" = RADIO_CHANNEL_CCT,
	  ":z" = RADIO_CHANNEL_HIGHCOM,		"#z" = RADIO_CHANNEL_HIGHCOM,		".z" = RADIO_CHANNEL_HIGHCOM,
	  ":k" = SQUAD_SOF,				"#k" = SQUAD_SOF,				".k" = SQUAD_SOF,

	  ":R" = RADIO_EAR_RIGHT,			"#R" = RADIO_EAR_RIGHT,				".R" = RADIO_EAR_RIGHT,
	  ":L" = RADIO_EAR_LEFT ,			"#L" = RADIO_EAR_LEFT ,				".L" = RADIO_EAR_LEFT ,
	  ":I" = RADIO_CHANNEL_INTERCOM,	"#I" = RADIO_CHANNEL_INTERCOM,		".I" = RADIO_CHANNEL_INTERCOM,
	  ":H" = RADIO_CHANNEL_DEPARTMENT,	"#H" = RADIO_CHANNEL_DEPARTMENT,	".H" = RADIO_CHANNEL_DEPARTMENT,
	  ":W" = RADIO_MODE_WHISPER,		"#W" = RADIO_MODE_WHISPER,			".W" = RADIO_MODE_WHISPER,

	  ":M" = RADIO_CHANNEL_MEDSCI,		"#M" = RADIO_CHANNEL_MEDSCI,		".M" = RADIO_CHANNEL_MEDSCI,
	  ":N" = RADIO_CHANNEL_ENGI, 		"#N" = RADIO_CHANNEL_ENGI,			".N" = RADIO_CHANNEL_ENGI,
	  ":G" = RADIO_CHANNEL_ALMAYER,		"#G" = RADIO_CHANNEL_ALMAYER,		".G" = RADIO_CHANNEL_ALMAYER,
	  ":V" = RADIO_CHANNEL_COMMAND,		"#V" = RADIO_CHANNEL_COMMAND,		".V" = RADIO_CHANNEL_COMMAND,
	  ":A" = SQUAD_MARINE_1,			"#A" = SQUAD_MARINE_1,				".A" = SQUAD_MARINE_1,
	  ":B" = SQUAD_MARINE_2,			"#B" = SQUAD_MARINE_2,				".B" = SQUAD_MARINE_2,
	  ":C" = SQUAD_MARINE_3,			"#C" = SQUAD_MARINE_3,				".C" = SQUAD_MARINE_3,
	  ":D" = SQUAD_MARINE_4,			"#D" = SQUAD_MARINE_4,				".D" = SQUAD_MARINE_4,
	  ":E" = SQUAD_MARINE_5,			"#E" = SQUAD_MARINE_5,				".E" = SQUAD_MARINE_5,
	  ":F" = SQUAD_MARINE_CRYO,			"#F" = SQUAD_MARINE_CRYO,			".F" = SQUAD_MARINE_CRYO,
	  ":P" = RADIO_CHANNEL_MP,			"#P" = RADIO_CHANNEL_MP,			".P" = RADIO_CHANNEL_MP,
	  ":U" = RADIO_CHANNEL_REQ,			"#U" = RADIO_CHANNEL_REQ,			".U" = RADIO_CHANNEL_REQ,
	  ":J" = RADIO_CHANNEL_JTAC,		"#J" = RADIO_CHANNEL_JTAC,			".J" = RADIO_CHANNEL_JTAC,
	  ":T" = RADIO_CHANNEL_INTEL,		"#T" = RADIO_CHANNEL_INTEL,			".T" = RADIO_CHANNEL_INTEL,
	  ":Y" = RADIO_CHANNEL_WY,			"#Y" = RADIO_CHANNEL_WY,			".Y" = RADIO_CHANNEL_WY,
	  ":O" = RADIO_CHANNEL_CCT,			"#O" = RADIO_CHANNEL_CCT,			".O" = RADIO_CHANNEL_CCT,
	  ":Z" = RADIO_CHANNEL_HIGHCOM,		"#Z" = RADIO_CHANNEL_HIGHCOM,		".Z" = RADIO_CHANNEL_HIGHCOM,
	  ":K" = SQUAD_SOF,				"#K" = SQUAD_SOF,				".K" = SQUAD_SOF,

	  //kinda localization -- rastaf0
	  //same keys as above, but on russian keyboard layout. This file uses cp1251 as encoding.
	  ":�" = RADIO_EAR_RIGHT,	"#�" = RADIO_EAR_RIGHT,		".�" = RADIO_EAR_RIGHT,
	  ":�" = RADIO_EAR_LEFT ,	"#�" = RADIO_EAR_LEFT ,		".�" = RADIO_EAR_LEFT ,
	  ":�" = RADIO_CHANNEL_INTERCOM,	"#�" = RADIO_CHANNEL_INTERCOM,		".�" = RADIO_CHANNEL_INTERCOM,
	  ":�" = RADIO_CHANNEL_DEPARTMENT,	"#�" = RADIO_CHANNEL_DEPARTMENT,	".�" = RADIO_CHANNEL_DEPARTMENT,
	  ":�" = RADIO_CHANNEL_COMMAND,		"#�" = RADIO_CHANNEL_COMMAND,		".�" = RADIO_CHANNEL_COMMAND,
	  ":�" = RADIO_CHANNEL_MEDSCI,		"#�" = RADIO_CHANNEL_MEDSCI,		".�" = RADIO_CHANNEL_MEDSCI,
	  ":�" = RADIO_CHANNEL_ENGI,	"#�" = RADIO_CHANNEL_ENGI,	".�" = RADIO_CHANNEL_ENGI,
	  ":�" = RADIO_MODE_WHISPER,		"#�" = RADIO_MODE_WHISPER,		".�" = RADIO_MODE_WHISPER,
	  ":�" = RADIO_CHANNEL_SYNDICATE,	"#�" = RADIO_CHANNEL_SYNDICATE,		".�" = RADIO_CHANNEL_SYNDICATE,
)

/mob/living/proc/binarycheck()
	return FALSE

///Shows custom speech bubbles for screaming, *warcry etc.
/mob/living/proc/show_speech_bubble(var/bubble_name)
	var/list/hear = hearers()

	var/image/speech_bubble = image('icons/mob/hud/talk.dmi',src,"[bubble_name]")

	speech_bubble.appearance_flags = NO_CLIENT_COLOR|KEEP_APART|RESET_COLOR

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


/mob/living/say(var/message, var/datum/language/speaking = null, var/verb="says", var/alt_name="", var/italics=0, var/message_range = world_view_size, var/sound/speech_sound, var/sound_vol, var/nolog = 0, var/message_mode = null)
	var/turf/T

	if(SEND_SIGNAL(src, COMSIG_LIVING_SPEAK, message, speaking, verb, alt_name, italics, message_range, speech_sound, sound_vol, nolog, message_mode) & COMPONENT_OVERRIDE_SPEAK) return

	message = process_chat_markup(message, list("~", "_"))

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
			var/list/hearturfs = list()

			for(var/I in hear(message_range, T))
				if(istype(I, /mob/))
					var/mob/M = I
					listening += M
					hearturfs += M.locs[1]
					for(var/obj/O in M.contents)
						if(O.flags_atom & USES_HEARING)
							listening_obj |= O
				else if(istype(I, /obj/))
					var/obj/O = I
					hearturfs += O.locs[1]
					if(O.flags_atom & USES_HEARING)
						listening_obj |= O

			for(var/mob/M as anything in GLOB.player_list)
				if((M.stat == DEAD || isobserver(M)) && M.client && M.client.prefs && (M.client.prefs.toggles_chat & CHAT_GHOSTEARS))
					listening |= M
					continue
				if(M.loc && (M.locs[1] in hearturfs))
					listening |= M

		var/speech_bubble_test = say_test(message)
		var/image/speech_bubble = image('icons/mob/hud/talk.dmi',src,"h[speech_bubble_test]")
		speech_bubble.appearance_flags = NO_CLIENT_COLOR|KEEP_APART|RESET_COLOR

		var/not_dead_speaker = (stat != DEAD)
		if(not_dead_speaker)
			langchat_speech(message, listening, speaking)
		for(var/mob/M as anything in listening)
			if(not_dead_speaker)
				M << speech_bubble
			M.hear_say(message, verb, speaking, alt_name, italics, src, speech_sound, sound_vol)

		addtimer(CALLBACK(src, .proc/remove_speech_bubble, speech_bubble, listening), 30)

		for(var/obj/O as anything in listening_obj)
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
			log_say("[name != "Unknown" ? name : "([real_name])"] \[[message_mode]\]: [message] (CKEY: [key]) (JOB: [job])")
		else				// we talk normally
			log_say("[name != "Unknown" ? name : "([real_name])"]: [message] (CKEY: [key]) (JOB: [job])")
	else
		log_say("[name != "Unknown" ? name : "([real_name])"]: [message] (CKEY: [key])")

	return 1

/mob/living/proc/say_signlang(var/message, var/verb="gestures", var/datum/language/language)
	for (var/mob/O in viewers(src, null))
		O.hear_signlang(message, verb, language, src)

/obj/effect/speech_bubble
	var/mob/parent

/mob/living/proc/GetVoice()
	return name
