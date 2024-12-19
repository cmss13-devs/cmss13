/obj/effect/rappel_rope
	name = "rope"
	icon = 'icons/obj/structures/props/dropship/dropship_equipment.dmi'
	icon_state = "rope"
	layer = ABOVE_LYING_MOB_LAYER
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	anchored = TRUE
	unacidable = TRUE

/obj/effect/rappel_rope/Initialize(mapload, ...)
	. = ..()
	handle_animation()

/obj/effect/rappel_rope/proc/handle_animation()
	flick("rope_deploy", src)
	addtimer(CALLBACK(src, PROC_REF(handle_animation_end)), 2 SECONDS)

/obj/effect/rappel_rope/proc/handle_animation_end()
	flick("rope_up", src)
	QDEL_IN(src, 5)
