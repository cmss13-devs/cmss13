/obj/structure/extinguisher_cabinet
	name = "extinguisher cabinet"
	desc = "A small wall mounted cabinet designed to hold a fire extinguisher."
	icon = 'icons/obj/structures/closet.dmi'
	icon_state = "extinguisher_closed"
	anchored = 1
	density = 0
	var/obj/item/tool/extinguisher/has_extinguisher = new/obj/item/tool/extinguisher
	var/opened = 0

/obj/structure/extinguisher_cabinet/lifeboat
	name = "extinguisher cabinet"
	icon = 'icons/obj/structures/machinery/lifeboat.dmi'
	icon_state = "extinguisher_closed"

/obj/structure/extinguisher_cabinet/attackby(obj/item/O, mob/user)
	if(isrobot(user))
		return
	if(istype(O, /obj/item/tool/extinguisher))
		if(!has_extinguisher && opened)
			user.drop_held_item()
			contents += O
			has_extinguisher = O
			to_chat(user, SPAN_NOTICE("You place [O] in [src]."))
		else
			opened = !opened
	else
		opened = !opened
	update_icon()


/obj/structure/extinguisher_cabinet/attack_hand(mob/user)
	if(isrobot(user))
		return

	if(has_extinguisher)
		user.put_in_hands(has_extinguisher)
		to_chat(user, SPAN_NOTICE("You take [has_extinguisher] from [src]."))
		has_extinguisher = null
		opened = 1
	else
		opened = !opened
	update_icon()

/obj/structure/extinguisher_cabinet/update_icon()
	if(!opened)
		icon_state = "extinguisher_closed"
		return
	if(has_extinguisher)
		if(istype(has_extinguisher, /obj/item/tool/extinguisher/mini))
			icon_state = "extinguisher_mini"
		else
			icon_state = "extinguisher_full"
	else
		icon_state = "extinguisher_empty"
