/obj/effect/decal/remains/human
	name = "remains"
	desc = "They look like human remains. Eerie..."
	gender = PLURAL
	icon = 'icons/effects/blood.dmi'
	icon_state = "remains"
	anchored = TRUE
	layer = BELOW_OBJ_LAYER //Puts them under most objects.

/obj/effect/decal/remains/xeno
	name = "remains"
	desc = "They look like the remains of some horrible creature. They are not pleasant to look at..."
	gender = PLURAL
	icon = 'icons/effects/blood.dmi'
	icon_state = "remainsxeno"
	anchored = TRUE
	layer = BELOW_OBJ_LAYER

/obj/effect/decal/remains/xeno/Initialize(mapload, icon, icon_state, pixel_x)
	. = ..()

	src.icon = icon
	src.icon_state = icon_state
	src.pixel_x = pixel_x


/obj/effect/decal/remains/robot
	name = "remains"
	desc = "They look like the remains of something mechanical. They have a strange aura about them."
	gender = PLURAL
	icon = 'icons/mob/robots.dmi'
	icon_state = "remainsrobot"
	anchored = TRUE
	layer = BELOW_OBJ_LAYER
