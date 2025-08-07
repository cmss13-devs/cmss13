//A storage item intended to be used by other items to provide storage functionality.
//Types that use this should consider overriding emp_act() and hear_talk(), unless they shield their contents somehow.
/obj/item/storage/internal
	var/obj/master_object

/obj/item/storage/internal/Initialize(mapload)
	. = ..()
	if(!isobj(loc))
		CRASH("Internal storage was created without a valid master object! ([loc], [usr])")
	master_object = loc
	name = master_object.name

/obj/item/storage/internal/attack_hand()
	return //make sure this is never picked up

/obj/item/storage/internal/mob_can_equip()
	return FALSE //make sure this is never picked up

//Helper procs to cleanly implement internal storages - storage items that provide inventory slots for other items.
//These procs are completely optional, it is up to the master item to decide when it's storage get's opened by calling open()
//However they are helpful for allowing the master item to pretend it is a storage item itself.
//If you are using these you will probably want to override attackby() as well.
//See /obj/item/clothing/suit/storage for an example.

//Items that use internal storage have the option of calling this to emulate default storage MouseDrop behaviour.
//Returns 1 if the master item's parent's MouseDrop() should be called, 0 otherwise. It's strange, but no other way of
//Doing it without the ability to call another proc's parent, really.
/obj/item/storage/internal/proc/handle_mousedrop(mob/living/carbon/human/user, obj/over_object as obj)
	if(ishuman(user))

		if(user.body_position == LYING_DOWN) //Can't use your inventory when lying //what about stuns? don't argue
			return

		if(QDELETED(master_object))
			return

		if(over_object == user && Adjacent(user)) //This must come before the screen objects only block
			open(user)
			return FALSE

		if(!isitem(master_object)) //Everything after this point is for doffing worn items with internal storage pockets.
			return FALSE //If we are not in an item, do nothing more.

		var/obj/item/master_item = master_object
		if(master_item.flags_item & NODROP)
			return

		if(!istype(over_object, /atom/movable/screen))
			return TRUE

		//Makes sure master_item is equipped before putting it in hand, so that we can't drag it into our hand from miles away.
		if(!user.contains(master_item))
			return FALSE

		if(!user.is_mob_restrained() && !user.stat)
			switch(over_object.name)
				if("r_hand")
					if(master_item.time_to_unequip)
						user.visible_message(SPAN_NOTICE("[user] starts taking off \the [master_item]."))
						if(!do_after(user, master_item.time_to_unequip, INTERRUPT_ALL, BUSY_ICON_GENERIC))
							to_chat(user, SPAN_WARNING("You stop taking off \the [master_item]!"))
						else
							user.drop_inv_item_on_ground(master_item)
							user.put_in_r_hand(master_item)
					else
						user.drop_inv_item_on_ground(master_item)
						user.put_in_r_hand(master_item)

					if(master_item.light_on)
						master_item.turn_light(toggle_on = FALSE)
					return
				if("l_hand")
					if(master_item.time_to_unequip)
						user.visible_message(SPAN_NOTICE("[user] starts taking off \the [master_item]."))
						if(!do_after(user, master_item.time_to_unequip, INTERRUPT_ALL, BUSY_ICON_GENERIC))
							to_chat(user, SPAN_WARNING("You stop taking off \the [master_item]!"))
						else
							user.drop_inv_item_on_ground(master_item)
							user.put_in_l_hand(master_item)
					else
						user.drop_inv_item_on_ground(master_item)
						user.put_in_l_hand(master_item)

					if(master_item.light_on)
						master_item.turn_light(toggle_on = FALSE)
					return
			master_item.add_fingerprint(user)
			return FALSE
	return FALSE

//Items that use internal storage have the option of calling this to emulate default storage attack_hand behaviour.
//Returns 1 if the master item's parent's attack_hand() should be called, 0 otherwise.
//It's strange, but no other way of doing it without the ability to call another proc's parent, really.
/obj/item/storage/internal/proc/handle_attack_hand(mob/living/user as mob, mods)
	if(user.body_position == LYING_DOWN) // what about stuns? huh?
		return FALSE

	if(ishuman(user))
		var/mob/living/carbon/human/H = user
		if(H.l_store == master_object && !H.get_active_hand()) //Prevents opening if it's in a pocket.
			H.put_in_hands(master_object)
			H.l_store = null
			return FALSE
		if(H.r_store == master_object && !H.get_active_hand())
			H.put_in_hands(master_object)
			H.r_store = null
			return FALSE

	master_object.add_fingerprint(user)
	//Checks that it's in the user's inventory somewhere - not safe with items inside storage without additional checks on master_object's end.
	if(user.contains(master_object))
		if((mods && mods["alt"] || storage_flags & STORAGE_USING_DRAWING_METHOD) && ishuman(user) && length(contents))
			var/obj/item/I
			if(storage_flags & STORAGE_USING_FIFO_DRAWING)
				I = contents[1]
			else
				I = contents[length(contents)]
			I.attack_hand(user)
		else
			open(user)
		return FALSE

	for(var/mob/M in content_watchers)
		storage_close(M)
	return TRUE

/obj/item/storage/internal/attackby(obj/item/W as obj, mob/user as mob)
	if(master_object.on_pocket_attackby(W,user))
		. = ..()

/obj/item/storage/internal/Adjacent(atom/neighbor)
	return master_object.Adjacent(neighbor)

/obj/item/storage/internal/open(mob/user)
	var/first_open
	if(!content_watchers)
		first_open = TRUE
	..()
	master_object.on_pocket_open(first_open)

/obj/item/storage/internal/storage_close(mob/user)
	..()
	master_object.on_pocket_close(content_watchers)

/obj/item/storage/internal/_item_insertion(obj/item/W as obj, prevent_warning = 0)
	..()
	master_object.on_pocket_insertion()

/obj/item/storage/internal/_item_removal(obj/item/W as obj, atom/new_location)
	..()
	master_object.on_pocket_removal()

//things to do when the obj's internal pocket is accessed. Passes content_watchers for easier checks.
/obj/proc/on_pocket_open(first_open)
	return

//things to do when the obj's internal pocket's UI window is closed. Passes content_watchers for easier checks.
/obj/proc/on_pocket_close(watchers)
	return

//things to do when a user attempts to insert an item in the obj's internal pocket. Return TRUE if all good, to permit the obj to move along.
/obj/proc/on_pocket_attackby()
	return TRUE

//things to do when an item is inserted in the obj's internal pocket
/obj/proc/on_pocket_insertion()
	return

//things to do when an item is removed in the obj's internal pocket
/obj/proc/on_pocket_removal()
	return

/obj/item/storage/internal/Destroy()
	. = ..()
	master_object = null


// Marine Helmet Storage
/obj/item/storage/internal/headgear
	var/list/garb_items
	var/slots_reserved_for_garb

/obj/item/storage/internal/headgear/can_be_inserted(obj/item/item, mob/user, stop_messages = FALSE) //We don't need to stop messages, but it can be left in.
	. = ..()
	if(!.)
		return

	if(!HAS_FLAG(item.flags_obj, OBJ_IS_HELMET_GARB) && length(contents) - length(garb_items) >= storage_slots - slots_reserved_for_garb)
		if(!stop_messages)
			to_chat(usr, SPAN_WARNING("This slot is reserved for headgear accessories!"))
		return FALSE

/obj/item/storage/internal/headgear/_item_insertion(obj/item/item, prevent_warning = FALSE)
	if(HAS_FLAG(item.flags_obj, OBJ_IS_HELMET_GARB))
		LAZYADD(garb_items, item)
	return ..()

/obj/item/storage/internal/headgear/_item_removal(obj/item/item, atom/new_location)
	if(HAS_FLAG(item.flags_obj, OBJ_IS_HELMET_GARB))
		LAZYREMOVE(garb_items, item)
	return ..()
