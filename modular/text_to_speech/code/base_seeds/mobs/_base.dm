//Fallback values for TTS voices

/mob/living/add_tts_component()
	AddComponent(/datum/component/tts_component)

/mob/living/simple_animal/add_tts_component()
	AddComponent(/datum/component/tts_component, /datum/tts_seed/silero/angel)

/mob/living/silicon/add_tts_component()
	AddComponent(/datum/component/tts_component, null, TTS_TRAIT_ROBOTIZE)

/mob/living/remove_tts_component()
	var/datum/component/tts_component/tts_component = GetComponent(/datum/component/tts_component)
	if(tts_component)
		tts_component.RemoveComponent()

/mob/living/carbon/Initialize()
	. = ..()
	tts_seed = get_tts_seed()
