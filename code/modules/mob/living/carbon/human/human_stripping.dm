GLOBAL_LIST_INIT(strippable_human_items, create_strippable_list(list(
	/datum/strippable_item/mob_item_slot/head,
	/datum/strippable_item/mob_item_slot/back,
	/datum/strippable_item/mob_item_slot/mask,
	/datum/strippable_item/mob_item_slot/eyes,
	/datum/strippable_item/mob_item_slot/r_ear,
	/datum/strippable_item/mob_item_slot/l_ear,
	/datum/strippable_item/mob_item_slot/jumpsuit,
	/datum/strippable_item/mob_item_slot/suit,
	/datum/strippable_item/mob_item_slot/gloves,
	/datum/strippable_item/mob_item_slot/feet,
	/datum/strippable_item/mob_item_slot/suit_storage,
	/datum/strippable_item/mob_item_slot/id,
	/datum/strippable_item/mob_item_slot/belt,
	/datum/strippable_item/mob_item_slot/pocket/left,
	/datum/strippable_item/mob_item_slot/pocket/right,
	/datum/strippable_item/mob_item_slot/hand/left,
	/datum/strippable_item/mob_item_slot/hand/right,
	/datum/strippable_item/mob_item_slot/handcuffs,
	/datum/strippable_item/mob_item_slot/legcuffs,
)))

/mob/living/carbon/human/proc/should_strip(mob/user)
	// if (user.pulling != src || user.grab_state != GRAB_AGGRESSIVE)
	// 	return TRUE

	// if (ishuman(user))
	// 	var/mob/living/carbon/human/human_user = user
	// 	//return !human_user.can_be_firemanned(src)

	return TRUE

/datum/strippable_item/mob_item_slot/head
	key = STRIPPABLE_ITEM_HEAD
	item_slot = SLOT_HEAD

/datum/strippable_item/mob_item_slot/back
	key = STRIPPABLE_ITEM_BACK
	item_slot = SLOT_BACK

/datum/strippable_item/mob_item_slot/mask
	key = STRIPPABLE_ITEM_MASK
	item_slot = SLOT_FACE

/datum/strippable_item/mob_item_slot/eyes
	key = STRIPPABLE_ITEM_EYES
	item_slot = SLOT_EYES

/datum/strippable_item/mob_item_slot/r_ear
	key = STRIPPABLE_ITEM_R_EAR
	item_slot = SLOT_EAR

/datum/strippable_item/mob_item_slot/l_ear
	key = STRIPPABLE_ITEM_L_EAR
	item_slot = SLOT_EAR

/datum/strippable_item/mob_item_slot/jumpsuit
	key = STRIPPABLE_ITEM_JUMPSUIT
	item_slot = SLOT_ICLOTHING

/datum/strippable_item/mob_item_slot/jumpsuit/get_alternate_action(atom/source, mob/user)
	var/obj/item/clothing/under/uniform = get_item(source)
	if (!istype(uniform))
		return null
	return uniform?.accessories ? "remove_accessory" : null

/datum/strippable_item/mob_item_slot/jumpsuit/alternate_action(atom/source, mob/user)
	if(!ishuman(source))
		return
	var/mob/living/carbon/human/sourcemob = source
	if(!user.action_busy && !user.is_mob_incapacitated() && source.Adjacent(user))
		if(MODE_HAS_TOGGLEABLE_FLAG(MODE_NO_STRIPDRAG_ENEMY) && (sourcemob.stat == DEAD || sourcemob.health < HEALTH_THRESHOLD_CRIT) && !sourcemob.get_target_lock(user.faction_group))
			to_chat(user, SPAN_WARNING("You can't strip a crit or dead member of another faction!"))
			return
		if(sourcemob.w_uniform && istype(sourcemob.w_uniform, /obj/item/clothing))
			var/obj/item/clothing/under/U = sourcemob.w_uniform
			if(!LAZYLEN(U.accessories))
				return FALSE
			var/obj/item/clothing/accessory/A = LAZYACCESS(U.accessories, 1)
			if(LAZYLEN(U.accessories) > 1)
				A = tgui_input_list(user, "Select an accessory to remove from [U]", "Remove accessory", U.accessories)
			if(!istype(A))
				return
			sourcemob.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their accessory ([A]) removed by [key_name(user)]</font>")
			user.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to remove [key_name(sourcemob)]'s' accessory ([A])</font>")
			if(istype(A, /obj/item/clothing/accessory/holobadge) || istype(A, /obj/item/clothing/accessory/medal))
				sourcemob.visible_message(SPAN_DANGER("<B>[user] tears off \the [A] from [sourcemob]'s [U]!</B>"), null, null, 5)
				if(U == sourcemob.w_uniform)
					U.remove_accessory(user, A)
			else
				if(HAS_TRAIT(sourcemob, TRAIT_UNSTRIPPABLE) && !sourcemob.is_mob_incapacitated()) //Can't strip the unstrippable!
					to_chat(user, SPAN_DANGER("[sourcemob] has an unbreakable grip on their equipment!"))
					return
				sourcemob.visible_message(SPAN_DANGER("<B>[user] is trying to take off \a [A] from [source]'s [U]!</B>"), null, null, 5)
				if(do_after(user, sourcemob.get_strip_delay(user, sourcemob), INTERRUPT_ALL, BUSY_ICON_GENERIC, sourcemob, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
					if(U == sourcemob.w_uniform)
						U.remove_accessory(user, A)

/datum/strippable_item/mob_item_slot/suit
	key = STRIPPABLE_ITEM_SUIT
	item_slot = SLOT_OCLOTHING

/datum/strippable_item/mob_item_slot/gloves
	key = STRIPPABLE_ITEM_GLOVES
	item_slot = SLOT_HANDS

/datum/strippable_item/mob_item_slot/feet
	key = STRIPPABLE_ITEM_FEET
	item_slot = SLOT_FEET


/datum/strippable_item/mob_item_slot/suit_storage
	key = STRIPPABLE_ITEM_SUIT_STORAGE
	item_slot = SLOT_SUIT_STORE

/datum/strippable_item/mob_item_slot/id
	key = STRIPPABLE_ITEM_ID
	item_slot = SLOT_ID

/datum/strippable_item/mob_item_slot/belt
	key = STRIPPABLE_ITEM_BELT
	item_slot = SLOT_WAIST

/datum/strippable_item/mob_item_slot/pocket/left
	key = STRIPPABLE_ITEM_LPOCKET
	item_slot = SLOT_STORE

/datum/strippable_item/mob_item_slot/pocket/right
	key = STRIPPABLE_ITEM_RPOCKET
	item_slot = SLOT_STORE

/datum/strippable_item/mob_item_slot/hand/left
	key = STRIPPABLE_ITEM_LHAND

/datum/strippable_item/mob_item_slot/hand/right
	key = STRIPPABLE_ITEM_RHAND

/datum/strippable_item/mob_item_slot/handcuffs
 	key = STRIPPABLE_ITEM_HANDCUFFS

/datum/strippable_item/mob_item_slot/legcuffs
 	key = STRIPPABLE_ITEM_LEGCUFFS
