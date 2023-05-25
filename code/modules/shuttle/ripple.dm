/obj/effect/abstract/ripple
	name = "hyperspace ripple"
	desc = "Something is coming through hyperspace, you can see the \
		visual disturbances. It's probably best not to be on top of these \
		when whatever is tunneling comes through."
	icon = 'icons/effects/effects.dmi'
	icon_state = "shadow_square"
	anchored = TRUE
	density = FALSE
	layer = RIPPLE_LAYER
	mouse_opacity = MOUSE_OPACITY_ICON
	alpha = 0

/obj/effect/abstract/ripple/Initialize(mapload, time_left)
	. = ..()
	animate(src, alpha=255, time=time_left) // I wish the loop argument would override the sprite's setting
