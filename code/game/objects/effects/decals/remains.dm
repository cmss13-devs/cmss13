/obj/effect/decal/remains
	gender = PLURAL
	appearance_flags = PIXEL_SCALE
	anchored = TRUE
	layer = BELOW_OBJ_LAYER //Puts them under most objects.
	appearance_flags = PIXEL_SCALE

/obj/effect/decal/remains/human
	name = "remains"
	desc = "They look like human remains. Eerie..."
	icon = 'icons/effects/blood.dmi'
	icon_state = "remains"

/obj/effect/decal/remains/Initialize()
	. = ..()
	pixel_x = rand(-16, 16)
	pixel_y = rand(-16, 16)
	var/matrix/rotate = matrix()
	rotate.Turn(rand(0, 359))
	transform = rotate

/obj/effect/decal/remains/xeno
	name = "remains"
	desc = "They look like the remains of some horrible creature. They are not pleasant to look at..."
	icon = 'icons/effects/blood.dmi'
	icon_state = "remainsxeno"


/obj/effect/decal/remains/xeno/Initialize(mapload, icon, icon_state, pixel_x)
	. = ..()

	src.icon = icon
	src.icon_state = icon_state
	src.pixel_x = pixel_x


/obj/effect/decal/remains/robot
	name = "remains"
	desc = "They look like the remains of something mechanical. They have a strange aura about them."
	icon = 'icons/mob/robots.dmi'
	icon_state = "remainsrobot"

