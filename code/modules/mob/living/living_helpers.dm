
/mob/living/proc/has_brain()
	return 1

/mob/living/proc/has_eyes()
	return 1

/mob/living/proc/can_inject()
	return 1

/mob/living/proc/start_audio_emote_cooldown()
	recent_audio_emote = TRUE
	addtimer(CALLBACK(src, .proc/clear_audio_emote_cooldown), 20 SECONDS)

/mob/living/proc/clear_audio_emote_cooldown()
	recent_audio_emote = FALSE

/mob/living/proc/check_fire_intensity_resistance()
	return 0
