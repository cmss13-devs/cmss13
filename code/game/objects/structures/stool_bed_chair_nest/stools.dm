/obj/structure/bed/stool
	name = "stool"
	desc = "Apply butt."
	icon_state = "stool"
	anchored = 1
	can_buckle = FALSE
	foldabletype = /obj/item/stool



/obj/item/stool
	name = "stool"
	desc = "Uh-hoh, the bar is heating up."
	icon = 'icons/obj/objects.dmi'
	icon_state = "stool"
	force = 15
	throwforce = 12
	w_class = SIZE_HUGE

/obj/item/stool/proc/deploy_stool(mob/user)
	new /obj/structure/bed/stool(get_turf(user))
	user.temp_drop_inv_item(src)
	user.visible_message(SPAN_NOTICE("[user] puts [src] down."), SPAN_NOTICE("You put [src] down."))
	qdel(src)

/obj/item/stool/attack_self(mob/user)
	..()
	deploy_stool(user)


