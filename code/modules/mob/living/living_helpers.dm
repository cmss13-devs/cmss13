
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

/mob/living/proc/fling_mob(var/atom/throwing_atom, direction, distance)
	if (!istype(src) || !istype(throwing_atom) ||  !direction || !distance)
		return

	var/turf/T = get_turf(src)
	var/turf/temp = get_turf(src)
	for (var/x in 0 to distance)
		temp = get_step(T, direction)
		if (!temp)
			break
		T = temp

	src.throw_atom(T, distance, SPEED_VERY_FAST, throwing_atom, TRUE)
	shake_camera(src, 10, 1)
