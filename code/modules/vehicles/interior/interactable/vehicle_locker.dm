//WALL MOUNTED LOCKER USED TO STORE SPECIFIC ITEMS IN IT ITEMS

/obj/structure/closet/vehicle
	name = "wall-mounted storage compartment"
	desc = "Small storage unit allowing Vehicle Crewmen to store their personal possessions or weaponry ammunition. Only Vehicle Crewmen can access these."
	icon = 'icons/obj/vehicles/interiors/general.dmi'
	icon_state = "locker"
	icon_closed = "locker"
	icon_opened = "locker_open"
	anchored = TRUE
	density = FALSE
	wall_mounted = TRUE
	store_mobs = FALSE
	storage_capacity = 15
	layer = 3.2

	unacidable = TRUE
	unslashable = TRUE
	indestructible = TRUE

//can't weld this one
/obj/structure/closet/attackby(obj/item/W, mob/living/user)
	if(opened)
		if(istype(W, /obj/item/grab))
			if(isXeno(user))
				return
			var/obj/item/grab/G = W
			if(G.grabbed_thing)
				MouseDrop_T(G.grabbed_thing, user)      //act like they were dragged onto the closet
			return
		if(W.flags_item & ITEM_ABSTRACT)
			return 0
		if(isrobot(user))
			return
		user.drop_inv_item_to_loc(W,loc)

	else if(istype(W, /obj/item/packageWrap))
		return

	else
		attack_hand(user)
	return

//requires VC job to open/close
/obj/structure/closet/vehicle/toggle(mob/living/user)
	user.next_move = world.time + 5
	var/mob/living/carbon/human/H = user
	if(!istype(H) || H.job != JOB_CREWMAN)
		to_chat(user, SPAN_WARNING("Access denied."))
		return

	if(!(opened ? close() : open()))
		to_chat(user, SPAN_WARNING("It won't budge!"))
	return

/obj/structure/closet/vehicle/open()
	if(opened)
		return FALSE

	if(!can_open())
		return FALSE

	dump_contents()

	opened = TRUE
	update_icon()
	playsound(src.loc, open_sound, 15, 1)
	density = FALSE
	return TRUE


/obj/structure/closet/vehicle/store_items(var/stored_units)
	for(var/obj/item/I in loc)
		if(I.anchored || istype(I, /obj/item/hardpoint))	//hiding LTB into a wall locker is an amazing feat, not available to VCs
			continue
		var/item_size = Ceiling(I.w_class / 2)
		if(stored_units + item_size > storage_capacity)
			continue
		if(!I.anchored)
			I.loc = src
			stored_units += item_size
	return stored_units

/obj/structure/closet/vehicle/dump_contents()

	for(var/obj/I in src)
		I.forceMove(loc)