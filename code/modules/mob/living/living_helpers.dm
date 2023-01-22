
/mob/living/proc/has_brain()
	return 1

/mob/living/proc/has_eyes()
	return 1

/mob/living/proc/can_inject()
	return 1

/mob/living/proc/start_audio_emote_cooldown(var/cooldown_time = 20 SECONDS)
	recent_audio_emote = TRUE
	addtimer(CALLBACK(src, .proc/clear_audio_emote_cooldown), cooldown_time)

/mob/living/proc/clear_audio_emote_cooldown()
	recent_audio_emote = FALSE

/mob/living/proc/check_fire_intensity_resistance()
	return 0

/mob/living/proc/splat(mob/killer)
	death(create_cause_data("splatting", killer), FALSE, "splatting")
