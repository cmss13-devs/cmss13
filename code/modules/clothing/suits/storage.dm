/obj/item/clothing/suit/storage
	var/obj/item/storage/internal/pockets
	var/storage_slots = 2

/obj/item/clothing/suit/storage/Initialize()
	. = ..()
	pockets = new/obj/item/storage/internal(src)
	pockets.storage_slots = storage_slots
	pockets.max_w_class = SIZE_SMALL //fit only small items
	pockets.max_storage_space = 4
	flags_atom |= USES_HEARING

/obj/item/clothing/suit/storage/Destroy()
	QDEL_NULL(pockets)
	return ..()

/obj/item/clothing/suit/storage/get_pockets()
	if(pockets)
		return pockets
	return ..()

/obj/item/clothing/suit/storage/attack_hand(mob/user, mods)
	if(loc != user)
		..(user) // If it's in a box (e.g. SG or spec gear), don't click the pockets pls
		return

	if(pockets.handle_attack_hand(user, mods))
		..(user)

/obj/item/clothing/suit/storage/MouseDrop(obj/over_object)
	if (pockets.handle_mousedrop(usr, over_object))
		..(over_object)

/obj/item/clothing/suit/storage/attackby(obj/item/W, mob/user)
	. = ..()
	if(!.) //To prevent bugs with accessories being moved into storage slots after being attached.
		return pockets.attackby(W, user)

/obj/item/clothing/suit/storage/emp_act(severity)
	. = ..()
	pockets.emp_act(severity)

/obj/item/clothing/suit/storage/hear_talk(mob/living/M, msg, verb, datum/language/speaking, italics)
	pockets.hear_talk(M, msg, verb, speaking, italics)
	..()

/obj/item/clothing/suit/storage/verb/toggle_draw_mode()
	set name = "Switch Storage Drawing Method"
	set category = "Object"
	set src in usr

	if(!istype(src, /obj/item/clothing/suit/storage)) // This will trigger on uniforms, for webbings etc
		for(var/obj/item/clothing/accessory/storage/A in accessories)
			if(A.hold.storage_flags)
				A.hold.storage_draw_logic(A.name)
				break
	else
		pockets.storage_draw_logic(src.name)

// Decides the storage flags when Switch Storage Draw Method gets called
/obj/item/storage/proc/storage_draw_logic(name)
	if (!(storage_flags & STORAGE_USING_DRAWING_METHOD))
		storage_flags |= STORAGE_USING_DRAWING_METHOD
		to_chat(usr, "Clicking [name] with an empty hand now puts the last stored item in your hand.")
	else if(!(storage_flags & STORAGE_USING_FIFO_DRAWING))
		storage_flags |= STORAGE_USING_FIFO_DRAWING
		to_chat(usr, "Clicking [name] with an empty hand now puts the first stored item in your hand.")
	else
		storage_flags &= ~(STORAGE_USING_DRAWING_METHOD|STORAGE_USING_FIFO_DRAWING)
		to_chat(usr, "Clicking [name] with an empty hand now opens the storage menu. Holding Alt will draw the last stored item instead.")
