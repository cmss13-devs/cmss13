/obj/effect/explosion_blastwave
	name = "blast wave"
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke-still"
	anchored = TRUE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = FLY_LAYER

/obj/effect/explosion_blastwave/Initialize(mapload, alpha = 255)
	. = ..()
	src.alpha = alpha
