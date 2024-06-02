
/mob/living/proc/has_brain()
	return 1

/mob/living/proc/has_eyes()
	return 1

/mob/living/proc/can_inject()
	return 1

/mob/living/proc/start_audio_emote_cooldown(cooldown_time = 20 SECONDS)
	recent_audio_emote = TRUE
	addtimer(CALLBACK(src, PROC_REF(clear_audio_emote_cooldown)), cooldown_time)

/mob/living/proc/clear_audio_emote_cooldown()
	recent_audio_emote = FALSE

/mob/living/proc/check_fire_intensity_resistance()
	return 0

/mob/living/proc/fling_mob(atom/cause_atom, direction, distance)
	if(!distance)
		return

	if(!direction)
		direction = pick(GLOB.alldirs)

	var/turf/target_turf = get_turf(src)
	var/turf/temporary_turf = get_turf(src)
	for (var/x in 0 to distance)
		temporary_turf = get_step(target_turf, direction)
		if (!temporary_turf)
			break
		target_turf = temporary_turf

	shake_camera(src, steps = 10, strength = 1)
	INVOKE_ASYNC(src, TYPE_PROC_REF(/atom/movable, throw_atom), target_turf, distance, SPEED_VERY_FAST, cause_atom, TRUE)

/**
 * 'Splats' src, killing them. Mouses override this proc with their own unique splat.
 */
/mob/living/proc/splat(mob/killer)
	death(create_cause_data("splatting", killer), FALSE, "splatting")
