/obj/effect/afterimage
	as_image = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT

/**
 * Params:
 * - mapload: Whether effect is maploaded
 * - to_copy: The atom that has an afterimage
 * - fading_duration: How long it takes for afterimage to fade
 * - fading_to_shift_ratio: How quickly afterimage will reach its target atom before fading (relative to the fading time)
 */
	

/obj/effect/afterimage/Initialize(mapload, atom/to_copy, fading_duration, fading_to_shift_ratio = 0.5)
	. = ..()
	if (!to_copy)
		log_debug("Created a [type] without `to_copy`")
		qdel(src)
		return
	AddElement(/datum/element/temporary, fading_duration)
	AddElement(/datum/element/copy_appearance, to_copy)
	AddElement(/datum/element/fading, fading_duration)
	AddElement(/datum/element/pixel_shifting, to_copy, 1, floor(fading_duration * fading_to_shift_ratio))
