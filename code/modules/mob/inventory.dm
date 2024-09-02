//These procs handle putting s tuff in your hand. It's probably best to use these rather than setting l_hand = ...etc
//as they handle all relevant stuff like adding it to the player's screen and updating their overlays.

//Returns the thing in our active hand
/mob/proc/get_active_hand()
	RETURN_TYPE(/obj/item)
	if(hand) return l_hand
	else return r_hand

//Returns the thing in our inactive hand
/mob/proc/get_inactive_hand()
	if(hand) return r_hand
	else return l_hand

/mob/proc/get_hands()
	if(hand)
		return list(l_hand, r_hand)
	else
		return list(r_hand, l_hand)

//Sad that this will cause some overhead, but the alias seems necessary
//*I* may be happy with a million and one references to "indexes" but others won't be
/mob/proc/is_holding(obj/item/I)
	return get_held_index_of_item(I)

/mob/proc/get_held_index_of_item(obj/item/I)
	var/list/handen = get_hands()
	return handen.Find(I)

//Puts the item into your l_hand if possible and calls all necessary triggers/updates. returns 1 on success.
/mob/proc/put_in_l_hand(obj/item/W)
	if(!istype(W))
		return FALSE
	if(!l_hand)
		if(W.loc == src && !(W.flags_item & DELONDROP))
			W.dropped(src)
		W.pickup(src)
		W.forceMove(src)
		l_hand = W
		W.layer = ABOVE_HUD_LAYER
		W.plane = ABOVE_HUD_PLANE
		W.equipped(src,WEAR_L_HAND)
		update_inv_l_hand()
		return TRUE
	return FALSE

//Puts the item into your r_hand if possible and calls all necessary triggers/updates. returns 1 on success.
/mob/proc/put_in_r_hand(obj/item/W)
	if(!istype(W))
		return FALSE
	if(!r_hand)
		if(W.loc == src && !(W.flags_item & DELONDROP))
			W.dropped(src)
		W.pickup(src)
		W.forceMove(src)
		r_hand = W
		W.layer = ABOVE_HUD_LAYER
		W.plane = ABOVE_HUD_PLANE
		W.equipped(src,WEAR_R_HAND)
		update_inv_r_hand()
		return TRUE
	return FALSE

//Puts the item into our active hand if possible. returns 1 on success.
/mob/proc/put_in_active_hand(obj/item/W)
	if(hand) return put_in_l_hand(W)
	else return put_in_r_hand(W)

//Puts the item into our inactive hand if possible. returns 1 on success.
/mob/proc/put_in_inactive_hand(obj/item/W)
	if(hand) return put_in_r_hand(W)
	else return put_in_l_hand(W)

//Puts the item into our active hand if possible. Failing that it tries our inactive hand. Returns 1 on success.
//If both fail it drops it on the floor and returns 0.
//This is probably the main one you need to know :)
/mob/proc/put_in_hands(obj/item/W, drop_on_fail = TRUE)
	if(!W)
		return FALSE
	if(put_in_active_hand(W))
		return TRUE
	else if(put_in_inactive_hand(W))
		return TRUE
	else
		if(drop_on_fail)
			W.forceMove(get_turf(src))
			W.layer = initial(W.layer)
			W.dropped(src)
		return FALSE

//Puts the item into our back if possible. Returns 1 on success.
/mob/proc/put_in_back(obj/item/item)
	if(!item)
		return FALSE
	if(!istype(item))
		return FALSE
	if(back)
		return FALSE
	if(item.loc == src && !(item.flags_item & DELONDROP))
		item.dropped(src)
	item.pickup(src)
	item.forceMove(src)
	back = item
	item.layer = ABOVE_HUD_LAYER
	item.plane = ABOVE_HUD_PLANE
	item.equipped(src, WEAR_BACK)
	update_inv_back()
	return TRUE

/mob/proc/drop_item_v() //this is dumb.
	if(stat == CONSCIOUS && isturf(loc))
		return drop_held_item()
	return FALSE


//Drops the item in our left hand
/mob/proc/drop_l_hand()
	if(l_hand)
		return drop_inv_item_on_ground(l_hand)
	return FALSE

//Drops the item in our right hand
/mob/proc/drop_r_hand()
	if(r_hand)
		return drop_inv_item_on_ground(r_hand)
	return FALSE

//Drops the item in our active hand. If passed with an item, it will check each hand for the item and drop the right one.
/mob/proc/drop_held_item(obj/item/I)
	if(I)
		if(I == r_hand)
			return drop_r_hand()
		else if (I == l_hand)
			return drop_l_hand()
	else if(hand)
		return drop_l_hand()
	else
		return drop_r_hand()

//Drops the items in our hands.
/mob/proc/drop_held_items()
	drop_r_hand()
	drop_l_hand()

//drop the inventory item on a specific location
/mob/proc/drop_inv_item_to_loc(obj/item/I, atom/newloc, nomoveupdate, force)
	return u_equip(I, newloc, nomoveupdate, force)

//drop the inventory item on the ground
/mob/proc/drop_inv_item_on_ground(obj/item/I, nomoveupdate, force)
	return u_equip(I, get_step(src, 0), nomoveupdate, force) // Drops on turf instead of loc

/mob/living/carbon/human/proc/pickup_recent()
	if(!remembered_dropped_objects)
		return

	var/turf/user_turf = get_turf(src)
	if(!user_turf)
		return

	if(is_mob_incapacitated())
		return

	if(pickup_recent_item_on_turf(user_turf))
		return

	for(var/turf/nearby_turf in orange(1, src))
		if(pickup_recent_item_on_turf(nearby_turf))
			return

/mob/living/carbon/human/proc/pickup_recent_item_on_turf(turf/check_turf)
	for(var/datum/weakref/weak_ref as anything in remembered_dropped_objects)
		var/obj/previously_held_object = weak_ref.resolve()
		if(!previously_held_object)
			remembered_dropped_objects -= weak_ref
			break
		if(previously_held_object in check_turf)
			if(previously_held_object.throwing)
				return FALSE
			if(previously_held_object.anchored)
				return FALSE
			put_in_hands(previously_held_object, drop_on_fail = FALSE)
			return TRUE
	return FALSE

/mob/living/carbon/human/proc/remember_dropped_object(obj/dropped_object)
	var/weak_ref = WEAKREF(dropped_object)

	if(!(weak_ref in remembered_dropped_objects))
		if(length(remembered_dropped_objects) >= MAXIMUM_DROPPED_OBJECTS_REMEMBERED)
			popleft(remembered_dropped_objects)
		remembered_dropped_objects += weak_ref

//Never use this proc directly. nomoveupdate is used when we don't want the item to react to
// its new loc (e.g.triggering mousetraps)
/mob/proc/u_equip(obj/item/I, atom/newloc, nomoveupdate, force)

	if(!I) return TRUE

	if((I.flags_item & NODROP) && !force)
		return FALSE //u_equip() only fails if item has NODROP
	var/slot = get_slot_by_item(I)
	if (I == r_hand)
		r_hand = null
		update_inv_r_hand()
	else if (I == l_hand)
		l_hand = null
		update_inv_l_hand()

	if (client)
		client.remove_from_screen(I)

	I.layer = initial(I.layer)
	I.plane = initial(I.plane)
	if(newloc)
		if(!nomoveupdate)
			I.forceMove(newloc)
		else
			I.forceMove(newloc)
	I.unequipped(src, slot)
	I.dropped(src)
	if(LAZYLEN(I.unequip_sounds))
		playsound_client(client, pick(I.unequip_sounds), null, ITEM_EQUIP_VOLUME)

	return TRUE

//Remove an item on a mob's inventory.  It does not change the item's loc, just unequips it from the mob.
//Used just before you want to delete the item, or moving it afterwards.
/mob/proc/temp_drop_inv_item(obj/item/I, force)
	return u_equip(I, null, TRUE, force)


//Outdated but still in use apparently. This should at least be a human proc.
/mob/proc/get_equipped_items()
	var/list/items = new/list()

	if(hasvar(src,"back")) if(src:back) items += src:back
	if(hasvar(src,"belt")) if(src:belt) items += src:belt
	if(hasvar(src,"wear_l_ear")) if(src:wear_l_ear) items += src:wear_l_ear
	if(hasvar(src,"wear_r_ear")) if(src:wear_r_ear) items += src:wear_r_ear
	if(hasvar(src,"glasses")) if(src:glasses) items += src:glasses
	if(hasvar(src,"gloves")) if(src:gloves) items += src:gloves
	if(hasvar(src,"head")) if(src:head) items += src:head
	if(hasvar(src,"shoes")) if(src:shoes) items += src:shoes
	if(hasvar(src,"wear_id")) if(src:wear_id) items += src:wear_id
	if(hasvar(src,"wear_mask")) if(src:wear_mask) items += src:wear_mask
	if(hasvar(src,"wear_suit")) if(src:wear_suit) items += src:wear_suit
// if(hasvar(src,"w_radio")) if(src:w_radio) items += src:w_radio  commenting this out since headsets go on your ears now PLEASE DON'T BE MAD KEELIN
	if(hasvar(src,"w_uniform")) if(src:w_uniform) items += src:w_uniform

	//if(hasvar(src,"l_hand")) if(src:l_hand) items += src:l_hand
	//if(hasvar(src,"r_hand")) if(src:r_hand) items += src:r_hand

	return items

//proc to get the item in the active hand.
/mob/proc/get_held_item()
	if (hand)
		return l_hand
	else
		return r_hand

/mob/living/carbon/human/proc/equip_if_possible(obj/item/W, slot, del_on_fail = 1) // since byond doesn't seem to have pointers, this seems like the best way to do this :/
	//warning: icky code
	var/equipped = 0
	switch(slot)
		if(WEAR_BACK)
			if(!src.back)
				src.back = W
				equipped = 1
		if(WEAR_FACE)
			if(!src.wear_mask)
				src.wear_mask = W
				equipped = 1
		if(WEAR_HANDCUFFS)
			if(!src.handcuffed)
				src.handcuffed = W
				equipped = 1
		if(WEAR_L_HAND)
			if(!src.l_hand)
				src.l_hand = W
				equipped = 1
		if(WEAR_R_HAND)
			if(!src.r_hand)
				src.r_hand = W
				equipped = 1
		if(WEAR_WAIST)
			if(!src.belt && src.w_uniform)
				src.belt = W
				equipped = 1
		if(WEAR_ID)
			if(!src.wear_id)
				src.wear_id = W
				equipped = 1
		if(WEAR_L_EAR)
			if(!wear_l_ear)
				wear_l_ear = W
				equipped = 1
		if(WEAR_R_EAR)
			if(!wear_r_ear)
				wear_r_ear = W
				equipped = 1
		if(WEAR_EYES)
			if(!src.glasses)
				src.glasses = W
				equipped = 1
		if(WEAR_HANDS)
			if(!src.gloves)
				src.gloves = W
				equipped = 1
		if(WEAR_HEAD)
			if(!src.head)
				src.head = W
				equipped = 1
		if(WEAR_FEET)
			if(!src.shoes)
				src.shoes = W
				equipped = 1
		if(WEAR_JACKET)
			if(!src.wear_suit)
				src.wear_suit = W
				equipped = 1
		if(WEAR_BODY)
			if(!src.w_uniform)
				src.w_uniform = W
				equipped = 1
		if(WEAR_L_STORE)
			if(!src.l_store && src.w_uniform)
				src.l_store = W
				equipped = 1
		if(WEAR_R_STORE)
			if(!src.r_store && src.w_uniform)
				src.r_store = W
				equipped = 1
		if(WEAR_J_STORE)
			if(!src.s_store && src.wear_suit)
				src.s_store = W
				equipped = 1
		if(WEAR_IN_BACK)
			if (src.back && isstorage(src.back))
				var/obj/item/storage/B = src.back
				if(length(B.contents) < B.storage_slots && W.w_class <= B.max_w_class)
					W.forceMove(B)
					equipped = 1
		if(WEAR_IN_SHOES)
			// If the player isn't wearing shoes, or the shoes somehow aren't shoes.
			if(!istype(shoes, /obj/item/clothing/shoes))
				return
			// If the item was successfully inserted.
			if(shoes.attempt_insert_item(src, W))
				equipped = 1 // what is this proc
		if(WEAR_IN_SCABBARD)
			if(src.back && istype(src.back, /obj/item/storage/large_holster))
				var/obj/item/storage/large_holster/B = src.back
				if(length(B.contents) < B.storage_slots && W.w_class <= B.max_w_class)
					W.forceMove(B)
					equipped = 1
		if(WEAR_IN_ACCESSORY)
			var/obj/item/clothing/under/U = w_uniform
			if(U && U.accessories)
				for(var/obj/item/clothing/accessory/storage/A in U.accessories)
					if(istype(A) && A.hold.storage_slots)
						W.forceMove(A.hold)
						equipped = 1
						break
		if(WEAR_IN_JACKET)
			var/obj/item/clothing/suit/storage/S = wear_suit
			if(istype(S) && S.pockets.storage_slots)
				W.forceMove(S.pockets)
				equipped = 1
		if(WEAR_IN_HELMET)
			var/obj/item/clothing/head/helmet/marine/HM = src.head
			if(istype(HM) && HM.pockets.storage_slots)
				W.forceMove(HM.pockets)
				equipped = TRUE
		if(WEAR_IN_BELT)
			if(src.belt && isstorage(src.belt))
				var/obj/item/storage/B = src.belt
				if(length(B.contents) < B.storage_slots && W.w_class <= B.max_w_class)
					W.forceMove(B)
					equipped = 1
		if(WEAR_IN_J_STORE)
			if(src.s_store && isstorage(src.s_store))
				var/obj/item/storage/B = src.s_store
				if(length(B.contents) < B.storage_slots && W.w_class <= B.max_w_class)
					W.forceMove(B)
					equipped = 1
		if(WEAR_IN_L_STORE)
			if(src.l_store && istype(src.l_store, /obj/item/storage/pouch))
				var/obj/item/storage/pouch/P = src.l_store
				if(length(P.contents) < P.storage_slots && W.w_class <= P.max_w_class)
					W.forceMove(P)
					equipped = 1
		if(WEAR_IN_R_STORE)
			if(src.r_store && istype(src.r_store, /obj/item/storage/pouch))
				var/obj/item/storage/pouch/P = src.r_store
				if(length(P.contents) < P.storage_slots && W.w_class <= P.max_w_class)
					W.forceMove(P)
					equipped = 1


	if(equipped)
		recalculate_move_delay = TRUE
		W.layer = ABOVE_HUD_LAYER
		W.plane = ABOVE_HUD_PLANE
		if(src.back && W.loc != src.back)
			W.forceMove(src)
	else
		if (del_on_fail)
			qdel(W)
	return equipped





// The mob is trying to strip an item from someone
/mob/proc/stripPanelUnequip(obj/item/I, mob/M)
	return

// The mob is trying to place an item on someone
/mob/proc/stripPanelEquip(obj/item/I, mob/M)
	return

//returns the item in a given slot
/mob/proc/get_item_by_slot(slot_id)
	return

//Returns the slot occupied by a given item.
/mob/proc/get_slot_by_item(obj/item/I)
	if(I == l_hand)
		return WEAR_L_HAND
	if(I == r_hand)
		return WEAR_R_HAND
	if(I == back)
		return WEAR_BACK
