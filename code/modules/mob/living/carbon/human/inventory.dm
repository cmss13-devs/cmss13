/mob/living/carbon/human/verb/quick_equip()
	set name = "quick-equip"
	set hidden = 1

	if(ishuman(src))
		var/mob/living/carbon/human/H = src
		var/obj/item/I = H.get_active_hand()
		if(!I)
			to_chat(H, SPAN_NOTICE("You are not holding anything to equip."))
			return
		if(!H.equip_to_appropriate_slot(I, 0))
			to_chat(H, SPAN_DANGER("You are unable to equip that."))

/mob/living/carbon/human/proc/equip_in_one_of_slots(obj/item/W, list/slots, del_on_fail = 1)
	for (var/slot in slots)
		if (equip_to_slot_if_possible(W, slots[slot], 1, del_on_fail = 0))
			return slot
	if (del_on_fail)
		qdel(W)
	return null


/mob/living/carbon/human/proc/has_limb(org_name)
	for(var/X in limbs)
		var/obj/limb/E = X
		if(E.name == org_name)
			return !(E.status & LIMB_DESTROYED)

/mob/living/carbon/human/proc/has_limb_for_slot(slot)
	switch(slot)
		if(WEAR_BACK)
			return has_limb("chest")
		if(WEAR_FACE)
			return has_limb("head")
		if(WEAR_HANDCUFFS)
			return has_limb("l_hand") && has_limb("r_hand")
		if(WEAR_LEGCUFFS)
			return has_limb("l_leg") && has_limb("r_leg")
		if(WEAR_L_HAND)
			return has_limb("l_hand")
		if(WEAR_R_HAND)
			return has_limb("r_hand")
		if(WEAR_WAIST)
			return has_limb("chest")
		if(WEAR_ID)
			return 1
		if(WEAR_L_EAR)
			return has_limb("head")
		if(WEAR_R_EAR)
			return has_limb("head")
		if(WEAR_EYES)
			return has_limb("head")
		if(WEAR_HANDS)
			return has_limb("l_hand") && has_limb("r_hand")
		if(WEAR_HEAD)
			return has_limb("head")
		if(WEAR_IN_HELMET)
			return has_limb("head")
		if(WEAR_FEET)
			return has_limb("r_foot") && has_limb("l_foot")
		if(WEAR_JACKET)
			return has_limb("chest")
		if(WEAR_BODY)
			return has_limb("chest")
		if(WEAR_L_STORE)
			return has_limb("chest")
		if(WEAR_R_STORE)
			return has_limb("chest")
		if(WEAR_J_STORE)
			return has_limb("chest")
		if(WEAR_ACCESSORY)
			return has_limb("chest")
		if(WEAR_IN_BACK)
			return 1
		if(WEAR_IN_SHOES)
			return 1
		if(WEAR_IN_JACKET)
			return 1
		if(WEAR_IN_ACCESSORY)
			return 1
		if(WEAR_IN_BELT)
			return 1
		if(WEAR_IN_SCABBARD)
			return 1
		if(WEAR_IN_J_STORE)
			return 1
		if(WEAR_IN_L_STORE)
			return 1
		if(WEAR_IN_R_STORE)
			return 1

/mob/living/carbon/human/put_in_l_hand(obj/item/W)
	var/obj/limb/O = get_limb("l_hand")
	if(!O || !O.is_usable())
		return FALSE
	. = ..()

/mob/living/carbon/human/put_in_r_hand(obj/item/W)
	var/obj/limb/O = get_limb("r_hand")
	if(!O || !O.is_usable())
		return FALSE
	. = ..()

/mob/living/carbon/human/u_equip(obj/item/I, atom/newloc, nomoveupdate, force)
	. = ..()
	if(!. || !I)
		return FALSE

	if(I == wear_suit)
		if(s_store && !(s_store.flags_equip_slot & SLOT_SUIT_STORE))
			drop_inv_item_on_ground(s_store)
		wear_suit = null
		if(I.flags_inv_hide & HIDESHOES)
			update_inv_shoes()
		if(I.flags_inv_hide & (HIDEALLHAIR|HIDETOPHAIR|HIDELOWHAIR) )
			update_hair()
		if(I.flags_inv_hide & HIDEJUMPSUIT)
			update_inv_w_uniform()
		update_inv_wear_suit()
	else if(I == w_uniform)
		if(r_store)
			drop_inv_item_on_ground(r_store)
		if(l_store)
			drop_inv_item_on_ground(l_store)
		if(belt)
			drop_inv_item_on_ground(belt)
		w_uniform = null
		update_suit_sensors()
		update_inv_w_uniform()
	else if(I == head)
		var/updatename = 0
		if(head.flags_inv_hide & HIDEFACE)
			updatename = 1
		head = null
		if(updatename)
			name = get_visible_name()
		if(I.flags_inv_hide & (HIDEALLHAIR|HIDETOPHAIR|HIDELOWHAIR))
			update_hair()	//rebuild hair
		if(I.flags_inv_hide & HIDEEARS)
			update_inv_ears()
		if(I.flags_inv_hide & HIDEMASK)
			update_inv_wear_mask()
		if(I.flags_inv_hide & HIDEEYES)
			update_inv_glasses()
		update_tint()
		update_inv_head()
	else if (I == gloves)
		gloves = null
		update_inv_gloves()
	else if (I == glasses)
		glasses = null
		update_tint()
		update_glass_vision(I)
		update_inv_glasses()
	else if (I == wear_l_ear)
		wear_l_ear = null
		update_inv_ears()
	else if (I == wear_r_ear)
		wear_r_ear = null
		update_inv_ears()
	else if (I == shoes)
		shoes = null
		update_inv_shoes()
	else if (I == belt)
		belt = null
		update_inv_belt()
	else if (I == wear_id)
		wear_id = null
		sec_hud_set_ID()
		hud_set_squad()
		update_inv_wear_id()
		name = get_visible_name()
	else if (I == r_store)
		r_store = null
		update_inv_pockets()
	else if (I == l_store)
		l_store = null
		update_inv_pockets()
	else if (I == s_store)
		s_store = null
		update_inv_s_store()




/mob/living/carbon/human/wear_mask_update(obj/item/I, equipping)
	//equipping arg to differentiate when we equip/unequip a mask
	if(!equipping && istype(I,/obj/item/clothing/mask/facehugger))
		var/obj/item/clothing/mask/facehugger/F = I
		if(F.stat != DEAD && !F.sterile && !(status_flags & XENO_HOST)) //Huggered but not impregnated, deal damage.
			visible_message(SPAN_DANGER("[F] frantically claws at [src]'s face!"),SPAN_DANGER("[F] frantically claws at your face! Auugh!"))
			apply_damage(25, BRUTE, "head")
	name = get_visible_name() // doing this without a check, still cheaper than doing it every Life() tick -spookydonut
	if(I.flags_inv_hide & (HIDEALLHAIR|HIDETOPHAIR|HIDELOWHAIR))
		update_hair()	//rebuild hair
	if(I.flags_inv_hide & HIDEEARS)
		update_inv_ears()
	if(I.flags_inv_hide & HIDEEYES)
		update_inv_glasses()
	if(!equipping && internal)
		internal = null
	update_tint()
	update_inv_wear_mask()


//This is an UNSAFE proc. Use mob_can_equip() before calling this one! Or rather use equip_to_slot_if_possible() or advanced_equip_to_slot_if_possible()
//set redraw_mob to 0 if you don't wish the hud to be updated - if you're doing it manually in your own proc.
/mob/living/carbon/human/equip_to_slot(obj/item/W as obj, slot, disable_warning)
	if(!slot) return
	if(!istype(W)) return
	if(!has_limb_for_slot(slot)) return

	if(W == l_hand)
		if(W.flags_item & NODROP)
			return
		l_hand = null
		update_inv_l_hand()
		//removes item's actions, may be readded once re-equipped to the new slot
		for(var/X in W.actions)
			var/datum/action/A = X
			A.remove_from(src)

	else if(W == r_hand)
		if(W.flags_item & NODROP)
			return
		r_hand = null
		update_inv_r_hand()
		//removes item's actions, may be readded once re-equipped to the new slot
		for(var/X in W.actions)
			var/datum/action/A = X
			A.remove_from(src)

	W.screen_loc = null
	if(W.loc != src)
		W.pickup(src, disable_warning)
	W.forceMove(src)
	W.layer = ABOVE_HUD_LAYER
	W.plane = ABOVE_HUD_PLANE

	switch(slot)
		if(WEAR_BACK)
			back = W
			W.equipped(src, slot, disable_warning)
			update_inv_back()
		if(WEAR_FACE)
			wear_mask = W
			W.equipped(src, slot, disable_warning)
			sec_hud_set_ID()
			wear_mask_update(W, TRUE)
			update_inv_wear_mask()
		if(WEAR_HANDCUFFS)
			handcuffed = W
			handcuff_update()
		if(WEAR_LEGCUFFS)
			legcuffed = W
			W.equipped(src, slot, disable_warning)
			legcuff_update()
		if(WEAR_L_HAND)
			l_hand = W
			W.equipped(src, slot, disable_warning)
			update_inv_l_hand()
		if(WEAR_R_HAND)
			r_hand = W
			W.equipped(src, slot, disable_warning)
			update_inv_r_hand()
		if(WEAR_WAIST)
			belt = W
			W.equipped(src, slot, disable_warning)
			update_inv_belt()
		if(WEAR_ID)
			wear_id = W
			W.equipped(src, slot, disable_warning)
			sec_hud_set_ID()
			hud_set_squad()
			update_inv_wear_id()
			name = get_visible_name()
		if(WEAR_L_EAR)
			wear_l_ear = W
			W.equipped(src, slot, disable_warning)
			update_inv_ears()
		if(WEAR_R_EAR)
			wear_r_ear = W
			W.equipped(src, slot, disable_warning)
			update_inv_ears()
		if(WEAR_EYES)
			glasses = W
			W.equipped(src, slot, disable_warning)
			update_tint()
			update_glass_vision(W)
			update_inv_glasses()
		if(WEAR_HANDS)
			gloves = W
			W.equipped(src, slot, disable_warning)
			update_inv_gloves()
		if(WEAR_HEAD)
			head = W
			if(head.flags_inv_hide & HIDEFACE)
				name = get_visible_name()
			if(head.flags_inv_hide & (HIDEALLHAIR|HIDETOPHAIR|HIDELOWHAIR))
				update_hair()	//rebuild hair
			if(head.flags_inv_hide & HIDEEARS)
				update_inv_ears()
			if(head.flags_inv_hide & HIDEMASK)
				update_inv_wear_mask()
			if(head.flags_inv_hide & HIDEEYES)
				update_inv_glasses()
			W.equipped(src, slot, disable_warning)
			update_tint()
			update_inv_head()
		if(WEAR_FEET)
			shoes = W
			W.equipped(src, slot, disable_warning)
			update_inv_shoes()
		if(WEAR_JACKET)
			wear_suit = W
			if(wear_suit.flags_inv_hide & HIDESHOES)
				update_inv_shoes()
			if(wear_suit.flags_inv_hide & HIDEJUMPSUIT)
				update_inv_w_uniform()
			if( wear_suit.flags_inv_hide & (HIDEALLHAIR|HIDETOPHAIR|HIDELOWHAIR) )
				update_hair()
			W.equipped(src, slot, disable_warning)
			update_inv_wear_suit()
		if(WEAR_BODY)
			w_uniform = W
			W.equipped(src, slot, disable_warning)
			update_suit_sensors()
			update_inv_w_uniform()
		if(WEAR_L_STORE)
			l_store = W
			W.equipped(src, slot, disable_warning)
			update_inv_pockets()
		if(WEAR_R_STORE)
			r_store = W
			W.equipped(src, slot, disable_warning)
			update_inv_pockets()
		if(WEAR_ACCESSORY)
			var/obj/item/clothing/accessory/A = W
			for(var/obj/item/clothing/C in contents)
				if(C.can_attach_accessory(A))
					C.attach_accessory(src, A)
					break
			update_inv_w_uniform()
			update_inv_wear_suit()
		if(WEAR_J_STORE)
			s_store = W
			W.equipped(src, slot, disable_warning)
			update_inv_s_store()
		if(WEAR_IN_BACK)
			var/obj/item/storage/S = back
			S.attempt_item_insertion(W, disable_warning, src)
			back.update_icon()
		if(WEAR_IN_SHOES)
			shoes.attackby(W,src)
			shoes.update_icon()
		if(WEAR_IN_SCABBARD)
			var/obj/item/storage/S = back
			S.attempt_item_insertion(W, disable_warning, src)
			back.update_icon()
		if(WEAR_IN_JACKET)
			var/obj/item/clothing/suit/storage/S = wear_suit
			if(istype(S) && S.pockets.storage_slots)
				S.pockets.attempt_item_insertion(W, disable_warning, src)
				wear_suit.update_icon()

		if(WEAR_IN_HELMET)
			var/obj/item/clothing/head/helmet/marine/HM = src.head
			if(istype(HM) && HM.pockets.storage_slots)
				HM.pockets.attempt_item_insertion(W, disable_warning, src)
				HM.update_icon()

		if(WEAR_IN_ACCESSORY)
			var/obj/item/clothing/accessory/A = W
			if(istype(A))
				for(var/obj/item/clothing/C in contents)
					if(C.can_attach_accessory(A))
						C.attach_accessory(src, A)
						break
			else
				w_uniform.attackby(W,src)
			update_inv_w_uniform()

		if(WEAR_IN_BELT)
			var/obj/item/storage/S = belt
			S.attempt_item_insertion(W, disable_warning, src)
			belt.update_icon()
		if(WEAR_IN_J_STORE)
			var/obj/item/storage/S = s_store
			S.attempt_item_insertion(W, disable_warning, src)
			s_store.update_icon()
		if(WEAR_IN_L_STORE)
			var/obj/item/storage/S = l_store
			S.attempt_item_insertion(W, disable_warning, src)
			l_store.update_icon()
		if(WEAR_IN_R_STORE)
			var/obj/item/storage/S = r_store
			S.attempt_item_insertion(W, disable_warning, src)
			r_store.update_icon()

		else
			to_chat(src, SPAN_DANGER("You are trying to eqip this item to an unsupported inventory slot. How the heck did you manage that? Stop it..."))
			return

	SEND_SIGNAL(src, COMSIG_HUMAN_EQUIPPED_ITEM, W, slot)
	recalculate_move_delay = TRUE
	return 1




/mob/living/carbon/human/get_item_by_slot(slot_id)
	switch(slot_id)
		if(WEAR_BACK)
			return back
		if(WEAR_FACE)
			return wear_mask
		if(WEAR_WAIST)
			return belt
		if(WEAR_ID)
			return wear_id
		if(WEAR_L_EAR)
			return wear_l_ear
		if(WEAR_R_EAR)
			return wear_r_ear
		if(WEAR_EYES)
			return glasses
		if(WEAR_HANDS)
			return gloves
		if(WEAR_L_HAND)
			return l_hand
		if(WEAR_R_HAND)
			return r_hand
		if(WEAR_HEAD)
			return head
		if(WEAR_FEET)
			return shoes
		if(WEAR_JACKET)
			return wear_suit
		if(WEAR_BODY)
			return w_uniform
		if(WEAR_L_STORE)
			return l_store
		if(WEAR_R_STORE)
			return r_store
		if(WEAR_J_STORE)
			return s_store
		if(WEAR_HANDCUFFS)
			return handcuffed
		if(WEAR_LEGCUFFS)
			return legcuffed

/mob/living/carbon/human/get_slot_by_item(obj/item/I)
	if(I == back)
		return WEAR_BACK
	if(I == wear_mask)
		return WEAR_FACE
	if(I == belt)
		return WEAR_WAIST
	if(I == wear_id)
		return WEAR_ID
	if(I == wear_l_ear)
		return WEAR_L_EAR
	if(I == wear_r_ear)
		return WEAR_R_EAR
	if(I == glasses)
		return WEAR_EYES
	if(I == gloves)
		return WEAR_HANDS
	if(I == head)
		return WEAR_HEAD
	if(I == shoes)
		return WEAR_FEET
	if(I == wear_suit)
		return WEAR_JACKET
	if(I == w_uniform)
		return WEAR_BODY
	if(I == l_store)
		return WEAR_L_STORE
	if(I == r_store)
		return WEAR_R_STORE
	if(I == s_store)
		return WEAR_J_STORE
	if(I == handcuffed)
		return WEAR_HANDCUFFS
	if(I == legcuffed)
		return WEAR_LEGCUFFS
	return ..()



/mob/living/carbon/human/stripPanelUnequip(obj/item/I, mob/M, slot_to_process)
	if(I.flags_item & ITEM_ABSTRACT)
		return
	if(I.flags_item & NODROP)
		to_chat(src, SPAN_WARNING("You can't remove \the [I.name], it appears to be stuck!"))
		return
	if(I.flags_inventory & CANTSTRIP)
		to_chat(src, SPAN_WARNING("You're having difficulty removing \the [I.name]."))
		return
	M.attack_log += "\[[time_stamp()]\] <font color='orange'>Has had their [I.name] ([slot_to_process]) attempted to be removed by [key_name(src)]</font>"
	attack_log += "\[[time_stamp()]\] <font color='red'>Attempted to remove [key_name(M)]'s [I.name] ([slot_to_process])</font>"
	log_interact(src, M, "[key_name(src)] tried to remove [key_name(M)]'s [I.name] ([slot_to_process]).")

	src.visible_message(SPAN_DANGER("[src] tries to remove [M]'s [I.name]."), \
					SPAN_DANGER("You are trying to remove [M]'s [I.name]."), null, 5)
	I.add_fingerprint(src)
	if(do_after(src, HUMAN_STRIP_DELAY * src.get_skill_duration_multiplier(), INTERRUPT_ALL, BUSY_ICON_GENERIC, M, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
		if(I && Adjacent(M) && I == M.get_item_by_slot(slot_to_process))
			M.drop_inv_item_on_ground(I)
			log_interact(src, M, "[key_name(src)] removed [key_name(M)]'s [I.name] ([slot_to_process]) successfully.")

	if(M)
		if(interactee == M && Adjacent(M))
			M.show_inv(src)


/mob/living/carbon/human/stripPanelEquip(obj/item/I, mob/M, slot_to_process)
	if(I && !(I.flags_item & ITEM_ABSTRACT))
		if(I.flags_item & NODROP)
			to_chat(src, SPAN_WARNING("You can't put \the [I.name] on [M], it's stuck to your hand!"))
			return
		if(I.flags_inventory & CANTSTRIP)
			to_chat(src, SPAN_WARNING("You're having difficulty putting \the [I.name] on [M]."))
			return
		if(I.flags_item & WIELDED)
			I.unwield(src)
		if(!I.mob_can_equip(M, slot_to_process, TRUE))
			to_chat(src, SPAN_WARNING("You can't put \the [I.name] on [M]!"))
			return
		visible_message(SPAN_NOTICE("[src] tries to put \the [I.name] on [M]."), null, null, 5)
		if(do_after(src, HUMAN_STRIP_DELAY * src.get_skill_duration_multiplier(), INTERRUPT_ALL, BUSY_ICON_GENERIC, M, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
			if(I == get_active_hand() && !M.get_item_by_slot(slot_to_process) && Adjacent(M))
				if(I.flags_item & WIELDED) //to prevent re-wielding it during the do_after
					I.unwield(src)
				if(I.mob_can_equip(M, slot_to_process, TRUE))//Placing an item on the mob
					drop_inv_item_on_ground(I)
					if(I && !QDELETED(I)) //Might be self-deleted?
						M.equip_to_slot_if_possible(I, slot_to_process, 1, 0, 1, 1)
						if(ishuman(M) && M.stat == DEAD)
							var/mob/living/carbon/human/H = M
							H.disable_lights() // take that powergamers -spookydonut

	if(M)
		if(interactee == M && Adjacent(M))
			M.show_inv(src)
