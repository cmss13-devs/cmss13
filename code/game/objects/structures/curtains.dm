/obj/structure/curtain
	icon = 'icons/obj/structures/props/curtain.dmi'
	name = "curtain"
	icon_state = "green"
	layer = ABOVE_MOB_LAYER
	opacity = TRUE
	density = FALSE

/obj/structure/curtain/open/New()
	..()
	toggle()

/obj/structure/curtain/bullet_act(obj/projectile/P, def_zone)
	if(P.damage)
		visible_message(SPAN_WARNING("[P] tears [src] down!"))
		qdel(src)
	return 0

/obj/structure/curtain/attack_hand(mob/user)
	playsound(get_turf(loc), "rustle", 15, 1, 6)
	toggle()
	..()

/obj/structure/curtain/attack_alien(mob/living/carbon/xenomorph/M)
	M.animation_attack_on(src)
	M.visible_message(SPAN_DANGER("\The [M] slices [src] apart!"),
	SPAN_DANGER("You slice [src] apart!"), null, 5)
	qdel(src)
	return XENO_ATTACK_ACTION

/obj/structure/curtain/proc/toggle()
	opacity = !opacity
	if(opacity)
		icon_state = "[initial(icon_state)]"
		layer = ABOVE_MOB_LAYER
	else
		icon_state = "[initial(icon_state)]-o"
		layer = OBJ_LAYER

/obj/structure/curtain/shower
	name = "shower curtain"
	color = "#ACD1E9"
	alpha = 200

/obj/structure/curtain/black
	name = "black curtain"
	color = "#222222"

/obj/structure/curtain/medical
	name = "plastic curtain"
	color = "#B8F5E3"
	alpha = 200

/obj/structure/curtain/open/shower
	name = "shower curtain"
	icon_state = "shower"
	alpha = 200

/obj/structure/curtain/open/black
	name = "black curtain"
	color = "#222222"

/obj/structure/curtain/open/medical
	name = "plastic curtain"
	color = "#B8F5E3"
	alpha = 200

/obj/structure/curtain/red
	name = "red curtain"
	icon_state = "red"

/obj/structure/curtain/leather
	name = "leather curtain"
	icon_state = "leather_curtain"
	alpha = 200

/obj/structure/curtain/leather/alt
	name = "leather curtain"
	icon_state = "leather_curtain_2"

/obj/structure/curtain/leather/alt_1
	name = "leather curtain"
	icon_state = "leather_curtain_3"

/obj/structure/curtain/leather/alt_2
	name = "leather curtain"
	icon_state = "leather_curtain_4"

// Colorable

/obj/structure/curtain/colorable
	name = "curtain"
	icon_state = "colorable"

/obj/structure/curtain/colorable_transparent
	name = "blinds"
	icon_state = "colorable_transparent"
	alpha = 200

// Open

/obj/structure/curtain/open/colorable
	name = "curtain"
	icon_state = "colorable"

/obj/structure/curtain/open/colorable_transparent
	name = "blinds"
	icon_state = "colorable_transparent"
	alpha = 200

/obj/structure/curtain/open/red
	name = "red curtain"
	icon_state = "red"

/obj/structure/curtain/open/leather
	name = "leather curtain"
	icon_state = "leather_curtain"
	alpha = 200

/obj/structure/curtain/open/leather/alt
	name = "leather curtain"
	icon_state = "leather_curtain_2"

/obj/structure/curtain/open/leather/alt_1
	name = "leather curtain"
	icon_state = "leather_curtain_3"

/obj/structure/curtain/open/leather/alt_2
	name = "leather curtain"
	icon_state = "leather_curtain_4"

/obj/structure/curtain/Initialize()
	. = ..()
	if(alpha)
		set_opacity(0)
