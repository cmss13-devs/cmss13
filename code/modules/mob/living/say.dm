GLOBAL_LIST_INIT(department_radio_keys, list(
	":i" = RADIO_CHANNEL_INTERCOM, ".i" = RADIO_CHANNEL_INTERCOM, "#i" = RADIO_CHANNEL_INTERCOM,
	":h" = RADIO_CHANNEL_DEPARTMENT, ".h" = RADIO_CHANNEL_DEPARTMENT, "#h" = RADIO_CHANNEL_DEPARTMENT,
	":w" = RADIO_MODE_WHISPER, ".w" = RADIO_MODE_WHISPER, "#w" = RADIO_MODE_WHISPER,
	":+" = RADIO_CHANNEL_SPECIAL, ".+" = RADIO_CHANNEL_SPECIAL, "#+" = RADIO_CHANNEL_SPECIAL, //activate radio-specific special functions

	":m" = RADIO_CHANNEL_MEDSCI, ".m" = RADIO_CHANNEL_MEDSCI, "#m" = RADIO_CHANNEL_UPP_MED,
	":n" = RADIO_CHANNEL_ENGI, ".n" = RADIO_CHANNEL_ENGI, "#n" = RADIO_CHANNEL_UPP_ENGI,
	":g" = RADIO_CHANNEL_ALMAYER, ".g" = RADIO_CHANNEL_ALMAYER, "#g" = RADIO_CHANNEL_CLF_GEN,
	":v" = RADIO_CHANNEL_COMMAND , ".v" = RADIO_CHANNEL_COMMAND , "#v" = RADIO_CHANNEL_UPP_CMD,
	":a" = SQUAD_MARINE_1, ".a" = SQUAD_MARINE_1, "#a" = RADIO_CHANNEL_CLF_MED,
	":b" = SQUAD_MARINE_2, ".b" = SQUAD_MARINE_2, "#b" = RADIO_CHANNEL_CLF_ENGI,
	":c" = SQUAD_MARINE_3, ".c" = SQUAD_MARINE_3, "#c" = RADIO_CHANNEL_CLF_CMD,
	":d" = SQUAD_MARINE_4, ".d" = SQUAD_MARINE_4, "#d" = RADIO_CHANNEL_CLF_CCT,
	":e" = SQUAD_MARINE_5, ".e" = SQUAD_MARINE_5, "#e" = RADIO_CHANNEL_PMC_ENGI,
	":f" = SQUAD_MARINE_CRYO, ".f" = SQUAD_MARINE_CRYO, "#f" = RADIO_CHANNEL_PMC_MED,
	":p" = RADIO_CHANNEL_MP , ".p" = RADIO_CHANNEL_MP , "#p" = RADIO_CHANNEL_PMC_GEN,
	":u" = RADIO_CHANNEL_REQ, ".u" = RADIO_CHANNEL_REQ, "#u" = RADIO_CHANNEL_UPP_GEN,
	":j" = RADIO_CHANNEL_JTAC, ".j" = RADIO_CHANNEL_JTAC, "#j" = RADIO_CHANNEL_UPP_CCT,
	":t" = RADIO_CHANNEL_INTEL, ".t" = RADIO_CHANNEL_INTEL, "#t" = RADIO_CHANNEL_UPP_KDO,
	":y" = RADIO_CHANNEL_WY, ".y" = RADIO_CHANNEL_WY, "#y" = RADIO_CHANNEL_WY,
	":o" = RADIO_CHANNEL_COLONY, ".o" = RADIO_CHANNEL_COLONY, "#o" = RADIO_CHANNEL_PMC_CCT,
	":z" = RADIO_CHANNEL_HIGHCOM, ".z" = RADIO_CHANNEL_HIGHCOM, "#z" = RADIO_CHANNEL_PMC_CMD,
	":k" = SQUAD_SOF, ".k" = SQUAD_SOF, "#k" = RADIO_CHANNEL_WY_WO,
	":q" = RADIO_CHANNEL_ROYAL_MARINE, ".q" = RADIO_CHANNEL_ROYAL_MARINE,
	":r" = RADIO_CHANNEL_PROVOST, ".r" = RADIO_CHANNEL_PROVOST, "#r" = RADIO_CHANNEL_PROVOST,

	":I" = RADIO_CHANNEL_INTERCOM, ".I" = RADIO_CHANNEL_INTERCOM, "#I" = RADIO_CHANNEL_INTERCOM,
	":H" = RADIO_CHANNEL_DEPARTMENT, ".H" = RADIO_CHANNEL_DEPARTMENT, "#H" = RADIO_CHANNEL_DEPARTMENT,
	":W" = RADIO_MODE_WHISPER, ".W" = RADIO_MODE_WHISPER, "#W" = RADIO_MODE_WHISPER,

	":M" = RADIO_CHANNEL_MEDSCI, ".M" = RADIO_CHANNEL_MEDSCI, "#M" = RADIO_CHANNEL_UPP_MED,
	":N" = RADIO_CHANNEL_ENGI, ".N" = RADIO_CHANNEL_ENGI, "#N" = RADIO_CHANNEL_UPP_ENGI,
	":G" = RADIO_CHANNEL_ALMAYER, ".G" = RADIO_CHANNEL_ALMAYER, "#G" = RADIO_CHANNEL_CLF_GEN,
	":V" = RADIO_CHANNEL_COMMAND, ".V" = RADIO_CHANNEL_COMMAND, "#V" = RADIO_CHANNEL_UPP_CMD,
	":A" = SQUAD_MARINE_1, ".A" = SQUAD_MARINE_1, "#A" = RADIO_CHANNEL_CLF_MED,
	":B" = SQUAD_MARINE_2, ".B" = SQUAD_MARINE_2, "#B" = RADIO_CHANNEL_CLF_ENGI,
	":C" = SQUAD_MARINE_3, ".C" = SQUAD_MARINE_3, "#C" = RADIO_CHANNEL_CLF_CMD,
	":D" = SQUAD_MARINE_4, ".D" = SQUAD_MARINE_4, "#D" = RADIO_CHANNEL_CLF_CCT,
	":E" = SQUAD_MARINE_5, ".E" = SQUAD_MARINE_5, "#E" = RADIO_CHANNEL_PMC_ENGI,
	":F" = SQUAD_MARINE_CRYO, ".F" = SQUAD_MARINE_CRYO, "#F" = RADIO_CHANNEL_PMC_MED,
	":P" = RADIO_CHANNEL_MP, ".P" = RADIO_CHANNEL_MP, "#P" = RADIO_CHANNEL_PMC_GEN,
	":U" = RADIO_CHANNEL_REQ, ".U" = RADIO_CHANNEL_REQ, "#U" = RADIO_CHANNEL_UPP_GEN,
	":J" = RADIO_CHANNEL_JTAC, ".J" = RADIO_CHANNEL_JTAC, "#J" = RADIO_CHANNEL_UPP_CCT,
	":T" = RADIO_CHANNEL_INTEL, ".T" = RADIO_CHANNEL_INTEL, "#T" = RADIO_CHANNEL_UPP_KDO,
	":Y" = RADIO_CHANNEL_WY, ".Y" = RADIO_CHANNEL_WY, "#Y" = RADIO_CHANNEL_WY,
	":O" = RADIO_CHANNEL_COLONY, ".O" = RADIO_CHANNEL_COLONY, "#O" = RADIO_CHANNEL_PMC_CCT,
	":Z" = RADIO_CHANNEL_HIGHCOM, ".Z" = RADIO_CHANNEL_HIGHCOM, "#Z" = RADIO_CHANNEL_PMC_CMD,
	":K" = SQUAD_SOF, ".K" = SQUAD_SOF, "#K" = RADIO_CHANNEL_WY_WO,
	":Q" = RADIO_CHANNEL_ROYAL_MARINE, ".Q" = RADIO_CHANNEL_ROYAL_MARINE,
	":R" = RADIO_CHANNEL_PROVOST, ".R" = RADIO_CHANNEL_PROVOST, "#R" = RADIO_CHANNEL_PROVOST,
//RUCM START
	":ш" = RADIO_CHANNEL_INTERCOM, ".ш" = RADIO_CHANNEL_INTERCOM, "#ш" = RADIO_CHANNEL_INTERCOM,
	":р" = RADIO_CHANNEL_DEPARTMENT, ".р" = RADIO_CHANNEL_DEPARTMENT, "#р" = RADIO_CHANNEL_DEPARTMENT,
	":ц" = RADIO_MODE_WHISPER, ".ц" = RADIO_MODE_WHISPER, "#ц" = RADIO_MODE_WHISPER,
	":=" = RADIO_CHANNEL_SPECIAL, ".=" = RADIO_CHANNEL_SPECIAL, "#=" = RADIO_CHANNEL_SPECIAL, //activate radio-specific special functions

	":ь" = RADIO_CHANNEL_MEDSCI, ".ь" = RADIO_CHANNEL_MEDSCI, "#ь" = RADIO_CHANNEL_UPP_MED,
	":т" = RADIO_CHANNEL_ENGI, ".т" = RADIO_CHANNEL_ENGI, "#т" = RADIO_CHANNEL_UPP_ENGI,
	":п" = RADIO_CHANNEL_ALMAYER, ".п" = RADIO_CHANNEL_ALMAYER, "#п" = RADIO_CHANNEL_CLF_GEN,
	":м" = RADIO_CHANNEL_COMMAND , ".м" = RADIO_CHANNEL_COMMAND , "#м" = RADIO_CHANNEL_UPP_CMD,
	":ф" = SQUAD_MARINE_1, ".ф" = SQUAD_MARINE_1, "#ф" = RADIO_CHANNEL_CLF_MED,
	":и" = SQUAD_MARINE_2, ".и" = SQUAD_MARINE_2, "#и" = RADIO_CHANNEL_CLF_ENGI,
	":с" = SQUAD_MARINE_3, ".с" = SQUAD_MARINE_3, "#с" = RADIO_CHANNEL_CLF_CMD,
	":в" = SQUAD_MARINE_4, ".в" = SQUAD_MARINE_4, "#в" = RADIO_CHANNEL_CLF_CCT,
	":у" = SQUAD_MARINE_5, ".у" = SQUAD_MARINE_5, "#у" = RADIO_CHANNEL_PMC_ENGI,
	":а" = SQUAD_MARINE_CRYO, ".а" = SQUAD_MARINE_CRYO, "#а" = RADIO_CHANNEL_PMC_MED,
	":з" = RADIO_CHANNEL_MP , ".з" = RADIO_CHANNEL_MP , "#з" = RADIO_CHANNEL_PMC_GEN,
	":г" = RADIO_CHANNEL_REQ, ".г" = RADIO_CHANNEL_REQ, "#г" = RADIO_CHANNEL_UPP_GEN,
	":о" = RADIO_CHANNEL_JTAC, ".о" = RADIO_CHANNEL_JTAC, "#о" = RADIO_CHANNEL_UPP_CCT,
	":е" = RADIO_CHANNEL_INTEL, ".е" = RADIO_CHANNEL_INTEL, "#е" = RADIO_CHANNEL_UPP_KDO,
	":н" = RADIO_CHANNEL_WY, ".н" = RADIO_CHANNEL_WY, "#н" = RADIO_CHANNEL_WY,
	":щ" = RADIO_CHANNEL_COLONY, ".щ" = RADIO_CHANNEL_COLONY, "#щ" = RADIO_CHANNEL_PMC_CCT,
	":я" = RADIO_CHANNEL_HIGHCOM, ".я" = RADIO_CHANNEL_HIGHCOM, "#я" = RADIO_CHANNEL_PMC_CMD,
	":л" = SQUAD_SOF, ".л" = SQUAD_SOF, "#л" = RADIO_CHANNEL_WY_WO,

	":Ш" = RADIO_CHANNEL_INTERCOM, ".Ш" = RADIO_CHANNEL_INTERCOM, "#Ш" = RADIO_CHANNEL_INTERCOM,
	":Р" = RADIO_CHANNEL_DEPARTMENT, ".Р" = RADIO_CHANNEL_DEPARTMENT, "#Р" = RADIO_CHANNEL_DEPARTMENT,
	":Ц" = RADIO_MODE_WHISPER, ".Ц" = RADIO_MODE_WHISPER, "#Ц" = RADIO_MODE_WHISPER,

	":Ь" = RADIO_CHANNEL_MEDSCI, ".Ь" = RADIO_CHANNEL_MEDSCI, "#Ь" = RADIO_CHANNEL_UPP_MED,
	":Т" = RADIO_CHANNEL_ENGI, ".Т" = RADIO_CHANNEL_ENGI, "#Т" = RADIO_CHANNEL_UPP_ENGI,
	":П" = RADIO_CHANNEL_ALMAYER, ".П" = RADIO_CHANNEL_ALMAYER, "#П" = RADIO_CHANNEL_CLF_GEN,
	":М" = RADIO_CHANNEL_COMMAND, ".М" = RADIO_CHANNEL_COMMAND, "#М" = RADIO_CHANNEL_UPP_CMD,
	":Ф" = SQUAD_MARINE_1, ".Ф" = SQUAD_MARINE_1, "#Ф" = RADIO_CHANNEL_CLF_MED,
	":И" = SQUAD_MARINE_2, ".И" = SQUAD_MARINE_2, "#И" = RADIO_CHANNEL_CLF_ENGI,
	":С" = SQUAD_MARINE_3, ".С" = SQUAD_MARINE_3, "#С" = RADIO_CHANNEL_CLF_CMD,
	":В" = SQUAD_MARINE_4, ".В" = SQUAD_MARINE_4, "#В" = RADIO_CHANNEL_CLF_CCT,
	":У" = SQUAD_MARINE_5, ".У" = SQUAD_MARINE_5, "#У" = RADIO_CHANNEL_PMC_ENGI,
	":А" = SQUAD_MARINE_CRYO, ".А" = SQUAD_MARINE_CRYO, "#А" = RADIO_CHANNEL_PMC_MED,
	":З" = RADIO_CHANNEL_MP, ".З" = RADIO_CHANNEL_MP, "#З" = RADIO_CHANNEL_PMC_GEN,
	":Г" = RADIO_CHANNEL_REQ, ".Г" = RADIO_CHANNEL_REQ, "#Г" = RADIO_CHANNEL_UPP_GEN,
	":О" = RADIO_CHANNEL_JTAC, ".О" = RADIO_CHANNEL_JTAC, "#О" = RADIO_CHANNEL_UPP_CCT,
	":Е" = RADIO_CHANNEL_INTEL, ".Е" = RADIO_CHANNEL_INTEL, "#Е" = RADIO_CHANNEL_UPP_KDO,
	":Н" = RADIO_CHANNEL_WY, ".Н" = RADIO_CHANNEL_WY, "#Н" = RADIO_CHANNEL_WY,
	":Щ" = RADIO_CHANNEL_COLONY, ".Щ" = RADIO_CHANNEL_COLONY, "#Щ" = RADIO_CHANNEL_PMC_CCT,
	":Я" = RADIO_CHANNEL_HIGHCOM, ".Я" = RADIO_CHANNEL_HIGHCOM, "#Я" = RADIO_CHANNEL_PMC_CMD,
	":Л" = SQUAD_SOF, ".Л" = SQUAD_SOF, "#Л" = RADIO_CHANNEL_WY_WO,
//RUCM END
))

/proc/channel_to_prefix(channel)
	var/channel_key
	for(var/key in GLOB.department_radio_keys)
		if(GLOB.department_radio_keys[key] == channel)
			channel_key = key
			break
	return channel_key

/proc/prefix_to_channel(prefix)
	return GLOB.department_radio_keys[prefix]

/proc/filter_message(client/user, message)
	if(!config.word_filter_regex)
		return TRUE

	if(config.word_filter_regex.Find(message))
		to_chat(user,
			html = "\n<font color='red' size='4'><b>-- Word Filter Message --</b></font>",
			)
		to_chat(user,
			type = MESSAGE_TYPE_ADMINPM,
			html = "\n<font color='red' size='4'><b>Your message has been automatically filtered due to its contents. Trying to circumvent this filter will get you banned.</b></font>",
			)
		SEND_SOUND(user, sound('sound/effects/adminhelp_new.ogg'))
		log_admin("[user.ckey] triggered the chat filter with the following message: [message].")
		return FALSE

	return TRUE

///Shows custom speech bubbles for screaming, *warcry etc.
/mob/living/proc/show_speech_bubble(bubble_name, bubble_type = bubble_icon)

	var/mutable_appearance/speech_bubble = mutable_appearance('icons/mob/effects/talk.dmi', "[bubble_icon][bubble_name]", TYPING_LAYER)
	speech_bubble.pixel_x = bubble_icon_x_offset
	speech_bubble.pixel_y = bubble_icon_y_offset

	overlays += speech_bubble

	addtimer(CALLBACK(src, PROC_REF(remove_speech_bubble), speech_bubble), 3 SECONDS)

/mob/living/proc/remove_speech_bubble(mutable_appearance/speech_bubble, list_of_mobs)
	overlays -= speech_bubble

/mob/living/say(message, datum/language/speaking = null, verb="says", alt_name="", italics=0, message_range = GLOB.world_view_size, sound/speech_sound, sound_vol, nolog = 0, message_mode = null, bubble_type = bubble_icon, tts_heard_list)
	var/turf/T

	if(SEND_SIGNAL(src, COMSIG_LIVING_SPEAK, message, speaking, verb, alt_name, italics, message_range, speech_sound, sound_vol, nolog, message_mode) & COMPONENT_OVERRIDE_SPEAK) return

	if(!filter_message(src, message))
		return

	message = process_chat_markup(message, list("~", "_"))

	//RUCM START
	if(!length(tts_heard_list))
		tts_heard_list = list(list(), list())
		INVOKE_ASYNC(SStts, TYPE_PROC_REF(/datum/controller/subsystem/tts, queue_tts_message), src, html_decode(message), tts_voice, tts_voice_filter, tts_heard_list, FALSE, 0, tts_voice_pitch, speaking_noise)
	//RUCM END

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
					manual_emote(pick(speaking.signlang_verb))

			if (speaking.flags & SIGNLANG)
				say_signlang(message, pick(speaking.signlang_verb), speaking)
				return 1

		var/list/listening = list()
		var/list/listening_obj = list()

		if(HAS_TRAIT(src, TRAIT_LISPING))
			var/old_message = message
			message = lisp_replace(message)
			if(old_message != message)
				verb = "lisps"

		if(T)
			var/list/hearturfs = list()

			for(var/I in hear(message_range, T))
				if(istype(I, /mob/))
					var/mob/M = I
					listening += M
					hearturfs += M.locs[1]
					for(var/obj/O in M.contents)
						var/obj/item/clothing/worn_item = O
						if((O.flags_atom & USES_HEARING) || ((istype(worn_item) && worn_item.accessories)))
							listening_obj |= O
				else if(istype(I, /obj/structure/surface))
					var/obj/structure/surface/table = I
					hearturfs += table.locs[1]
					for(var/obj/O in table.contents)
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
		var/image/speech_bubble = image('icons/mob/effects/talk.dmi', src, "[bubble_type][speech_bubble_test]", FLY_LAYER)

		var/not_dead_speaker = (stat != DEAD)
		if(not_dead_speaker)
			langchat_speech(message, listening, speaking)
		for(var/mob/M as anything in listening)
			M.hear_say(message, verb, speaking, alt_name, italics, src, speech_sound, sound_vol, tts_heard_list = tts_heard_list)
		overlays += speech_bubble

		addtimer(CALLBACK(src, PROC_REF(remove_speech_bubble), speech_bubble), 3 SECONDS)

		for(var/obj/O as anything in listening_obj)
			if(O) //It's possible that it could be deleted in the meantime.
				O.hear_talk(src, message, verb, speaking, italics, tts_heard_list = tts_heard_list)

	//used for STUI to stop logging of animal messages and radio
	//if(!nolog)
	//Rather see stuff twice then not at all.

	// Log people differently, first, check if they are human
	if(ishuman(src))
		if(message_mode) // we are talking into a radio
			if(message_mode == "headset") // default value, means general
				message_mode = "General"
			log_say("[name != "Unknown" ? name : "([real_name])"] \[[message_mode]\]: [message] (CKEY: [key]) (JOB: [job]) (AREA: [get_area_name(loc)])")
		else // we talk normally
			log_say("[name != "Unknown" ? name : "([real_name])"]: [message] (CKEY: [key]) (JOB: [job]) (AREA: [get_area_name(loc)])")
	else
		log_say("[name != "Unknown" ? name : "([real_name])"]: [message] (CKEY: [key]) (AREA: [get_area_name(loc)])")

	return tts_heard_list

/mob/living/proc/say_signlang(message, verb="gestures", datum/language/language)
	for (var/mob/O in viewers(src, null))
		O.hear_signlang(message, verb, language, src)

/obj/effect/speech_bubble
	var/mob/parent

/mob/living/proc/GetVoice()
	return name
