/datum/status_effect/time_stop_freeze
	id = "time_stop_freeze"
	duration = 5 SECONDS
	status_type = STATUS_EFFECT_REPLACE

	var/mob/living/carbon/xenomorph/warrior/caster
	var/list/saved_turf_colors

/datum/status_effect/time_stop_freeze/on_apply()
	. = ..()
	if(!.)
		return

	if(!istype(owner, /mob/living))
		return

	var/mob/living/affected_mob = owner

	affected_mob.anchored = TRUE
	affected_mob.Stun(duration)

	_apply_inversion_filter(affected_mob)

	affected_mob.balloon_alert(affected_mob, "time stops around you!")
	if(affected_mob.client)
		to_chat(affected_mob, SPAN_WARNING("Reality freezes. You cannot move!"))

/datum/status_effect/time_stop_freeze/on_remove()
	..()

	if(!istype(owner, /mob/living))
		return

	var/mob/living/affected_mob = owner

	affected_mob.anchored = FALSE
	affected_mob.Stun(0)

	_remove_inversion_filter(affected_mob)

	if(saved_turf_colors && length(saved_turf_colors))
		for(var/turf/T in saved_turf_colors)
			T.color = saved_turf_colors[T]
		saved_turf_colors.Cut()

	if(affected_mob.client)
		to_chat(affected_mob, SPAN_NOTICE("Time resumes. You can move again."))

/datum/status_effect/time_stop_freeze/proc/_apply_inversion_filter(mob/living/target)
	if(!target.client)
		return

	var/r_shift = rand(-15, 15) / 255
	var/g_shift = rand(-15, 15) / 255
	var/b_shift = rand(-15, 15) / 255

	target.client.color = list(
		-1,  0,  0, 0,
		0, -1,  0, 0,
		0,  0, -1, 0,
		0,  0,  0, 1,
		1 + r_shift, 1 + g_shift, 1 + b_shift, 0
	)

/datum/status_effect/time_stop_freeze/proc/_remove_inversion_filter(mob/living/target)
	if(!target.client)
		return
	target.client.color = null
