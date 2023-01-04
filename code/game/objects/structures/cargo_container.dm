/obj/structure/cargo_container
	name = "Cargo Container"
	desc = "A huge industrial shipping container."
	icon = 'icons/obj/structures/props/contain.dmi'
	icon_state = "blue"
	bound_width = 32
	bound_height = 64
	density = TRUE
	health = 200
	opacity = TRUE
	anchored = TRUE

/obj/structure/cargo_container/attack_hand(mob/user as mob)

	playsound(loc, 'sound/effects/clang.ogg', 25, 1)

	var/damage_dealt
	if(istype(user,/mob/living/carbon/human))
		var/mob/living/carbon/human/H = user
		if(H.species.can_shred(H))

			user.visible_message(SPAN_WARNING("[user] smashes [src] to no avail."), \
					SPAN_WARNING("You beat against [src] to no effect"), \
					"You hear twisting metal.")

	if(!damage_dealt)
		user.visible_message(SPAN_WARNING("[user] beats against the [src] to no avail."), \
					SPAN_WARNING("[user] beats against the [src]."), \
					"You hear twisting metal.")

/obj/structure/cargo_container/horizontal
	name = "Cargo Container"
	desc = "A huge industrial shipping container,"
	icon = 'icons/obj/structures/props/containHorizont.dmi'
	icon_state = "blue"
	bound_width = 64
	bound_height = 32
	density = TRUE
	health = 200
	opacity = TRUE



