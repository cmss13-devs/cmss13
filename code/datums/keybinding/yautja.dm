/datum/keybinding/yautja
	category = CATEGORY_YAUTJA
	weight = WEIGHT_MOB

/datum/keybinding/yautja/can_use(client/user)
	if(!ishuman(user.mob))
		return

/datum/keybinding/yautja/bracer/can_use(client/user)
	. = ..()
	if(!.)
		return
	var/mob/living/carbon/human/H = user.mob
	if(istype(H.get_held_item(), /obj/item/clothing/gloves/yautja))
		return TRUE
	if(istype(H.gloves, /obj/item/clothing/gloves/yautja))
		return TRUE
