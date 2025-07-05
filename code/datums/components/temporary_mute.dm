/datum/component/temporary_mute
	dupe_mode = COMPONENT_DUPE_UNIQUE
	/// A message to tell the user when they attempt to speak, if any
	var/on_speak_message = ""
	/// A message to tell the user when they attempt to emote, if any
	var/on_emote_message = ""
	/// A message to tell the user when they become no longer mute, if any
	var/on_unmute_message = ""
	/// How long after the component's initialization it should be deleted. -1 means it will never delete
	var/time_until_unmute = 3 MINUTES

/datum/component/temporary_mute/Initialize(on_speak_message = "", on_emote_message = "", on_unmute_message = "", time_until_unmute = 3 MINUTES)
	. = ..()
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE

	src.on_speak_message = on_speak_message
	src.on_emote_message = on_emote_message
	src.on_unmute_message = on_unmute_message
	src.time_until_unmute = time_until_unmute
	if(time_until_unmute != -1)
		QDEL_IN(src, time_until_unmute)

/datum/component/temporary_mute/RegisterWithParent()
	..()
	RegisterSignal(parent, COMSIG_LIVING_SPEAK, PROC_REF(on_speak))
	RegisterSignal(parent, COMSIG_XENO_TRY_HIVEMIND_TALK, PROC_REF(on_hivemind))
	RegisterSignal(parent, COMSIG_MOB_TRY_EMOTE, PROC_REF(on_emote))
	RegisterSignal(parent, COMSIG_MOB_TRY_POINT, PROC_REF(on_point))
	ADD_TRAIT(parent, TRAIT_TEMPORARILY_MUTED, TRAIT_SOURCE_TEMPORARY_MUTE)

/datum/component/temporary_mute/UnregisterFromParent()
	..()
	if(parent)
		UnregisterSignal(parent, COMSIG_LIVING_SPEAK)
		UnregisterSignal(parent, COMSIG_XENO_TRY_HIVEMIND_TALK)
		UnregisterSignal(parent, COMSIG_MOB_TRY_EMOTE)
		UnregisterSignal(parent, COMSIG_MOB_TRY_POINT)
		if(on_unmute_message)
			to_chat(parent, SPAN_NOTICE(on_unmute_message))
		REMOVE_TRAIT(parent, TRAIT_TEMPORARILY_MUTED, TRAIT_SOURCE_TEMPORARY_MUTE)

/datum/component/temporary_mute/proc/on_speak(
	mob/user,
	message,
	datum/language/speaking = null,
	verb = "says",
	alt_name = "",
	italics = FALSE,
	message_range = GLOB.world_view_size,
	sound/speech_sound,
	sound_vol,
	nolog = FALSE,
	message_mode = null
)
	SIGNAL_HANDLER

	if(!nolog)
		msg_admin_niche("[user.name != "Unknown" ? user.name : "([user.real_name])"] attempted to say the following before their spawn mute ended: [message] (CKEY: [user.key]) (JOB: [user.job]) (AREA: [get_area_name(user)])")
	if(on_speak_message)
		to_chat(parent, SPAN_BOLDNOTICE(on_speak_message))
	return COMPONENT_OVERRIDE_SPEAK

/datum/component/temporary_mute/proc/on_hivemind(mob/user, message)
	SIGNAL_HANDLER

	msg_admin_niche("[user.name != "Unknown" ? user.name : "([user.real_name])"] attempted to hivemind the following before their spawn mute ended: [message] (CKEY: [user.key]) (JOB: [user.job]) (AREA: [get_area_name(user)])")
	if(on_speak_message)
		to_chat(parent, SPAN_BOLDNOTICE(on_speak_message))
	return COMPONENT_OVERRIDE_HIVEMIND_TALK

/datum/component/temporary_mute/proc/on_emote(mob/user, datum/emote/current_emote, act, m_type, param, intentional)
	SIGNAL_HANDLER

	// Allow involuntary emotes or non-custom emotes
	if(!intentional)
		return
	if(!param && !istype(current_emote, /datum/emote/custom))
		return

	msg_admin_niche("[user.name != "Unknown" ? user.name : "([user.real_name])"] attempted to emote the following before their spawn mute ended: [param] (CKEY: [user.key]) (JOB: [user.job]) (AREA: [get_area_name(user)])")
	if(on_emote_message)
		to_chat(parent, SPAN_BOLDNOTICE(on_emote_message))
	return COMPONENT_OVERRIDE_EMOTE

/datum/component/temporary_mute/proc/on_point(mob/user, atom/target)
	SIGNAL_HANDLER

	msg_admin_niche("[user.name != "Unknown" ? user.name : "([user.real_name])"] attempted to point at the following before their spawn mute ended: [target] (CKEY: [user.key]) (JOB: [user.job]) (AREA: [get_area_name(user)])")
	if(on_emote_message)
		to_chat(parent, SPAN_BOLDNOTICE(on_emote_message))
	return COMPONENT_OVERRIDE_POINT
