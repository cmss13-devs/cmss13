
/obj/effect/abstract/time_stop_wave
	name = "time stop wave"
	icon = 'icons/effects/effects.dmi'
	icon_state = "explosion1"
	layer = ABOVE_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE

	var/mob/living/source_mob

/obj/effect/abstract/time_stop_wave/proc/set_up(mob/living/source, radius)
	source_mob = source
	var/scale_target = (radius * 2) + 1
	animate(
		src,
		transform = matrix(scale_target, MATRIX_SCALE),
		alpha = 0,
		time = 0.8 SECONDS,
		easing = SINE_EASING
	)
	QDEL_IN(src, 0.9 SECONDS)

/obj/effect/abstract/time_stop_wave/Destroy()
	source_mob = null
	return ..()
