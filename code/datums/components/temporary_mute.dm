/datum/component/temporary_mute
	dupe_mode = COMPONENT_DUPE_UNIQUE
	/// A message to tell the user when they attempt to speak, if any
	var/on_speak_message = ""
	/// A message to tell the user when they become no longer mute, if any
	var/on_unmute_message = ""
	/// How long after the component's initialization it should be deleted. -1 means it will never delete
	var/time_until_unmute = 5 MINUTES

/datum/component/temporary_mute/Initialize(on_speak_message = "", on_unmute_message = "", time_until_unmute = 5 MINUTES)
	. = ..()
	if(!ismob(parent))
		return COMPONENT_INCOMPATIBLE

	src.on_speak_message = on_speak_message
	src.on_unmute_message = on_unmute_message
	src.time_until_unmute = time_until_unmute
	if(time_until_unmute != -1)
		QDEL_IN(src, time_until_unmute)


/datum/component/temporary_mute/RegisterWithParent()
	..()
	RegisterSignal(parent, COMSIG_LIVING_SPEAK, PROC_REF(on_speak))
	RegisterSignal(parent, COMSIG_XENO_TRY_HIVEMIND_TALK, PROC_REF(on_speak))

/datum/component/temporary_mute/UnregisterFromParent()
	..()
	if(parent)
		to_chat(parent, SPAN_NOTICE(on_unmute_message))
		UnregisterSignal(parent, COMSIG_LIVING_SPEAK)
		UnregisterFromParent(parent, COMSIG_XENO_TRY_HIVEMIND_TALK)

/datum/component/temporary_mute/proc/on_speak(
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
	var/mob/mob_parent = parent

	log_say("[mob_parent.name != "Unknown" ? mob_parent.name : "([mob_parent.real_name])"] attempted to say the following before their xenomorph spawn mute ended: [message] (CKEY: [mob_parent.key]) (JOB: [mob_parent.job])")
	to_chat(parent, SPAN_BOLDNOTICE(on_speak_message))
	return COMPONENT_OVERRIDE_SPEAK
