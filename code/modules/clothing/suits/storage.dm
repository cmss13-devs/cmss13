/obj/item/clothing/suit/storage
	var/obj/item/storage/internal/pockets
	var/storage_slots = 2

/obj/item/clothing/suit/storage/Initialize()
	. = ..()
	pockets = new/obj/item/storage/internal(src)
	pockets.storage_slots = storage_slots
	pockets.max_w_class = SIZE_SMALL		//fit only small items
	pockets.max_storage_space = 4

/obj/item/clothing/suit/storage/attack_hand(mob/user)
	if(loc != user)
		..(user) // If it's in a box (e.g. SG or spec gear), don't click the pockets pls
		return

	if(pockets.handle_attack_hand(user))
		..(user)

/obj/item/clothing/suit/storage/MouseDrop(obj/over_object)
	if (pockets.handle_mousedrop(usr, over_object))
		..(over_object)

/obj/item/clothing/suit/storage/attackby(obj/item/W, mob/user)
	..()
	return pockets.attackby(W, user)

/obj/item/clothing/suit/storage/emp_act(severity)
	pockets.emp_act(severity)
	..()

/obj/item/clothing/suit/storage/hear_talk(mob/M, msg)
	pockets.hear_talk(M, msg)
	..()

/obj/item/clothing/suit/storage/verb/toggle_draw_mode()
	set name = "Switch Storage Drawing Method"
	set category = "Object"
	set src in usr
	var/toggled = FALSE // Only for the message

	if(!istype(src, /obj/item/clothing/suit/storage)) // This will trigger on uniforms, for webbings etc
		for(var/obj/item/clothing/accessory/storage/A in accessories)
			A.hold.storage_flags ^= STORAGE_USING_DRAWING_METHOD

			if(A.hold.storage_flags & STORAGE_USING_DRAWING_METHOD) // Just for the message
				toggled = TRUE
	else
		pockets.storage_flags ^= STORAGE_USING_DRAWING_METHOD

		if(pockets.storage_flags & STORAGE_USING_DRAWING_METHOD)
			toggled = TRUE

	if(toggled)
		to_chat(usr, "Clicking [src] with an empty hand now puts the last stored item in your hand.")
	else
		to_chat(usr, "Clicking [src] with an empty hand now opens the storage menu.")
