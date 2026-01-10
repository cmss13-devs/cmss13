/// Causes effect to fade over a specific duration
/datum/element/fading

/datum/element/fading/Attach(datum/target, duration)
	. = ..()
	if (. == ELEMENT_INCOMPATIBLE)
		return
	if (!istype(target, /obj/effect))
		return ELEMENT_INCOMPATIBLE
	animate(target, alpha = 0, time = duration)
