/obj/structure/extinguisher_cabinet
	name = "extinguisher cabinet"
	desc = "A small wall mounted cabinet designed to hold a fire extinguisher."
	icon = 'icons/obj/structures/closet.dmi'
	icon_state = "extinguisher"
	anchored = TRUE
	density = FALSE
	var/obj/item/tool/extinguisher/has_extinguisher
	var/opened = 0
	var/base_icon

/obj/structure/extinguisher_cabinet/Initialize()
	. = ..()
	base_icon = initial(icon_state)
	has_extinguisher = new /obj/item/tool/extinguisher()
	has_extinguisher.forceMove(src)

/obj/structure/extinguisher_cabinet/lifeboat
	name = "extinguisher cabinet"
	icon = 'icons/obj/structures/machinery/lifeboat.dmi'
	icon_state = "extinguisher"

/obj/structure/extinguisher_cabinet/blackfoot
	name = "integrated fire cabinet"
	desc = "A compact on-board fire suppression system specially designed for implementation aboard the aircraft. In grunt terms, it's a fancy-pants fire extinguisher cabinet. Good if the Chimera launchers misfire, or if some chucklehead forgets to put the pilot light out on their flamer."
	icon = 'icons/obj/vehicles/interiors/blackfoot.dmi'
	icon_state = "fire-cab"

/obj/structure/extinguisher_cabinet/alt
	icon_state = "extinguisher_alt"

/obj/structure/extinguisher_cabinet/attackby(obj/item/item, mob/user)
	if(istype(item, /obj/item/tool/extinguisher))
		if(!has_extinguisher && opened)
			user.drop_held_item()
			item.forceMove(src)
			has_extinguisher = item
			to_chat(user, SPAN_NOTICE("You place [item] in [src]."))
		else
			opened = !opened
	else
		opened = !opened
	update_icon()


/obj/structure/extinguisher_cabinet/attack_hand(mob/user)
	if(has_extinguisher)
		user.put_in_hands(has_extinguisher)
		to_chat(user, SPAN_NOTICE("You take [has_extinguisher] from [src]."))
		has_extinguisher = null
		opened = TRUE
	else
		opened = !opened
	update_icon()

/obj/structure/extinguisher_cabinet/update_icon()
	if(!opened)
		icon_state = base_icon + "_closed"
		return
	if(has_extinguisher)
		if(istype(has_extinguisher, /obj/item/tool/extinguisher/mini))
			icon_state = base_icon + "_mini"
		else
			icon_state = base_icon + "_full"
	else
		icon_state = base_icon + "_empty"
