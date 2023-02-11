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

/obj/structure/cargo_container/watatsumi
	name = "Watatsumi Cargo Container"
	desc = "A huge industrial shipping container.\nThis one is from Watatsumi, a manufacturer of a variety of electronical and mechanical products."

/obj/structure/cargo_container/watatsumi/left
	icon_state = "watatsumi_l"

/obj/structure/cargo_container/watatsumi/leftmid
	icon_state = "watatsumi_lm"

/obj/structure/cargo_container/watatsumi/mid
	icon_state = "watatsumi_m"

/obj/structure/cargo_container/watatsumi/rightmid
	icon_state = "watatsumi_rm"

/obj/structure/cargo_container/watatsumi/right
	icon_state = "watatsumi_r"

/obj/structure/cargo_container/grant
	name = "Grant Corporation Cargo Container"
	desc = "A huge industrial shipping container.\nThis one is from The Grant Corporation, a medical and biotech company."

/obj/structure/cargo_container/grant/left
	icon_state = "grant_l"

/obj/structure/cargo_container/grant/leftmid
	icon_state = "grant_lm"

/obj/structure/cargo_container/grant/rightmid
	icon_state = "grant_rm"

/obj/structure/cargo_container/grant/right
	icon_state = "grant_r"

/obj/structure/cargo_container/arious
	name = "Arious Cargo Container"
	desc = "A huge industrial shipping container.\nThis one is from Arious, a computer and motion tracker manufacturer."

/obj/structure/cargo_container/arious/left
	icon_state = "arious_l"

/obj/structure/cargo_container/arious/leftmid
	icon_state = "arious_lm"

/obj/structure/cargo_container/arious/mid
	icon_state = "arious_m"

/obj/structure/cargo_container/arious/rightmid
	icon_state = "arious_rm"

/obj/structure/cargo_container/arious/right
	icon_state = "arious_r"

/obj/structure/cargo_container/wy
	name = "Weyland-Yutani Cargo Container"
	desc = "A huge industrial shipping container.\nThis one is from Weyland-Yutani, you have probably heard of them before."

/obj/structure/cargo_container/wy/left
	icon_state = "wy_l"

/obj/structure/cargo_container/wy/mid
	icon_state = "wy_m"

/obj/structure/cargo_container/wy/right
	icon_state = "wy_r"

/obj/structure/cargo_container/

/obj/structure/cargo_container/

/obj/structure/cargo_container/

/obj/structure/cargo_container/

/obj/structure/cargo_container/

/obj/structure/cargo_container/

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



