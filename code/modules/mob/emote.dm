//The code execution of the emote datum is located at code/datums/emotes.dm
/mob/proc/emote(act, m_type = null, message = null, intentional = FALSE, force_silence = FALSE)
	var/param = message
	var/custom_param = findchar(act, " ")
	if(custom_param)
		param = copytext(act, custom_param + length(act[custom_param]))
		act = copytext(act, 1, custom_param)

	act = lowertext(act)
	var/list/key_emotes = GLOB.emote_list[act]

	if(!length(key_emotes))
		if(intentional && !force_silence)
			to_chat(src, SPAN_NOTICE("'[act]' emote does not exist. Say *help for a list."))
		return FALSE
	var/silenced = FALSE
	for(var/datum/emote/current_emote in key_emotes)
		if(!current_emote.check_cooldown(src, intentional))
			silenced = TRUE
			continue
		if(SEND_SIGNAL(src, COMSIG_MOB_TRY_EMOTE, current_emote, act, m_type, param, intentional) & COMPONENT_OVERRIDE_EMOTE)
			silenced = TRUE
			continue
		if(current_emote.run_emote(src, param, m_type, intentional))
			SEND_SIGNAL(src, COMSIG_MOB_EMOTE, current_emote, act, m_type, message, intentional)
			return TRUE
	if(intentional && !silenced && !force_silence)
		to_chat(src, SPAN_NOTICE("Unusable emote '[act]'. Say *help for a list."))
	return FALSE

/datum/emote/help
	key = "help"
	mob_type_ignore_stat_typecache = list(/mob/dead/observer)
	keybind = FALSE

/datum/emote/help/run_emote(mob/user, params, type_override, intentional)
	. = ..()
	var/list/keys = list()
	var/list/message = list("Available emotes, you can use them with say \"*emote\": ")

	for(var/key in GLOB.emote_list)
		for(var/datum/emote/P in GLOB.emote_list[key])
			if(P.key in keys)
				continue
			if(P.can_run_emote(user, status_check = FALSE , intentional = TRUE))
				keys += P.key

	keys = sort_list(keys)
	message += keys.Join(", ")
	message += "."
	message = message.Join("")
	to_chat(user, message)

/datum/emote/custom
	key = "me"
	key_third_person = "custom"
	keybind = FALSE

/datum/emote/custom/run_emote(mob/user, params, type_override, intentional = FALSE, prefix)
	if(user.client && user.client.prefs.muted & MUTE_IC)
		to_chat(user, SPAN_DANGER("You cannot emote (muted)."))
		return
	message = params
	return ..()
