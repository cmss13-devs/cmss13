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
	/datum/strippable_item/mob_item_slot/cuffs/handcuffs,
	/datum/strippable_item/mob_item_slot/cuffs/legcuffs,
)))

/mob/living/carbon/human/proc/should_strip(mob/user)
	if (user.pulling == src && user.grab_level == GRAB_AGGRESSIVE && (user.a_intent & INTENT_GRAB))
		return FALSE //to not interfere with fireman carry
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

/datum/strippable_item/mob_item_slot/mask/get_alternate_action(atom/source, mob/user)
	var/obj/item/clothing/mask = get_item(source)
	if (!istype(mask))
		return
	if (!ishuman(source))
		return
	var/mob/living/carbon/human/sourcehuman = source
	if (istype(sourcehuman.s_store, /obj/item/tank))
		return "toggle_internals"
	if (istype(sourcehuman.back, /obj/item/tank))
		return "toggle_internals"
	if (istype(sourcehuman.belt, /obj/item/tank))
		return "toggle_internals"
	return

/datum/strippable_item/mob_item_slot/mask/alternate_action(atom/source, mob/user)
	if(!ishuman(source))
		return
	var/mob/living/carbon/human/sourcehuman = source
	if(user.action_busy || user.is_mob_incapacitated() || !source.Adjacent(user))
		return
	if(MODE_HAS_TOGGLEABLE_FLAG(MODE_NO_STRIPDRAG_ENEMY) && (sourcehuman.stat == DEAD || sourcehuman.health < HEALTH_THRESHOLD_CRIT) && !sourcehuman.get_target_lock(user.faction_group))
		to_chat(user, SPAN_WARNING("You can't toggle internals of a crit or dead member of another faction!"))
		return

	sourcehuman.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their internals toggled by [key_name(user)]</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to toggle [key_name(src)]'s' internals</font>")
	if(sourcehuman.internal)
		user.visible_message(SPAN_DANGER("<B>[user] is trying to disable [sourcehuman]'s internals</B>"), null, null, 3)
	else
		user.visible_message(SPAN_DANGER("<B>[user] is trying to enable [sourcehuman]'s internals.</B>"), null, null, 3)

	if(!do_after(user, POCKET_STRIP_DELAY, INTERRUPT_ALL, BUSY_ICON_GENERIC, sourcehuman, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
		return

	if(sourcehuman.internal)
		sourcehuman.internal.add_fingerprint(user)
		sourcehuman.internal = null
		sourcehuman.visible_message("[sourcehuman] is no longer running on internals.", max_distance = 1)
		return

	if(!istype(sourcehuman.wear_mask, /obj/item/clothing/mask))
		return

	if(istype(sourcehuman.back, /obj/item/tank))
		sourcehuman.internal = sourcehuman.back
	else if(istype(sourcehuman.s_store, /obj/item/tank))
		sourcehuman.internal = sourcehuman.s_store
	else if(istype(sourcehuman.belt, /obj/item/tank))
		sourcehuman.internal = sourcehuman.belt

	if(!sourcehuman.internal)
		return

	sourcehuman.visible_message(SPAN_NOTICE("[sourcehuman] is now running on internals."), max_distance = 1)
	sourcehuman.internal.add_fingerprint(user)

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
	if(user.action_busy || user.is_mob_incapacitated() || !source.Adjacent(user))
		return
	if(MODE_HAS_TOGGLEABLE_FLAG(MODE_NO_STRIPDRAG_ENEMY) && (sourcemob.stat == DEAD || sourcemob.health < HEALTH_THRESHOLD_CRIT) && !sourcemob.get_target_lock(user.faction_group))
		to_chat(user, SPAN_WARNING("You can't strip a crit or dead member of another faction!"))
		return
	if(!sourcemob.w_uniform || !istype(sourcemob.w_uniform, /obj/item/clothing))
		return

	var/obj/item/clothing/under/uniform = sourcemob.w_uniform

	var/obj/item/clothing/accessory/accessory = uniform.pick_accessory_to_remove(user, sourcemob)

	if(!accessory)
		return

	sourcemob.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their accessory ([accessory]) removed by [key_name(user)]</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to remove [key_name(sourcemob)]'s' accessory ([accessory])</font>")
	if(istype(accessory, /obj/item/clothing/accessory/holobadge) || istype(accessory, /obj/item/clothing/accessory/medal))
		sourcemob.visible_message(SPAN_DANGER("<B>[user] tears off [accessory] from [sourcemob]'s [uniform]!</B>"), null, null, 5)
		if(uniform == sourcemob.w_uniform)
			uniform.remove_accessory(user, accessory)
		return

	if(HAS_TRAIT(sourcemob, TRAIT_UNSTRIPPABLE) && !sourcemob.is_mob_incapacitated()) //Can't strip the unstrippable!
		to_chat(user, SPAN_DANGER("[sourcemob] has an unbreakable grip on their equipment!"))
		return
	sourcemob.visible_message(SPAN_DANGER("<B>[user] is trying to take off \a [accessory] from [source]'s [uniform]!</B>"), null, null, 5)

	if(!do_after(user, sourcemob.get_strip_delay(user, sourcemob), INTERRUPT_ALL, BUSY_ICON_GENERIC, sourcemob, INTERRUPT_MOVED, BUSY_ICON_GENERIC))
		return

	if(uniform != sourcemob.w_uniform)
		return

	uniform.remove_accessory(user, accessory)

/datum/strippable_item/mob_item_slot/suit
	key = STRIPPABLE_ITEM_SUIT
	item_slot = SLOT_OCLOTHING

/datum/strippable_item/mob_item_slot/suit/has_no_item_alt_action()
	return TRUE

/datum/strippable_item/mob_item_slot/suit/get_alternate_action(atom/source, mob/user)
	if(!ishuman(source))
		return
	var/mob/living/carbon/human/sourcemob = source
	for(var/bodypart in list("l_leg","r_leg","l_arm","r_arm","r_hand","l_hand","r_foot","l_foot","chest","head","groin"))
		var/obj/limb/limb = sourcemob.get_limb(bodypart)
		if(limb && (limb.status & LIMB_SPLINTED))
			return "remove_splints"
	return

/datum/strippable_item/mob_item_slot/suit/alternate_action(atom/source, mob/user)
	if(!ishuman(source))
		return
	var/mob/living/carbon/human/sourcemob = source
	if(user.action_busy || user.is_mob_incapacitated() || !source.Adjacent(user))
		return
	if(MODE_HAS_TOGGLEABLE_FLAG(MODE_NO_STRIPDRAG_ENEMY) && (sourcemob.stat == DEAD || sourcemob.health < HEALTH_THRESHOLD_CRIT) && !sourcemob.get_target_lock(user.faction_group))
		to_chat(user, SPAN_WARNING("You can't remove splints of a crit or dead member of another faction!"))
		return
	sourcemob.attack_log += text("\[[time_stamp()]\] <font color='orange'>Has had their splints removed by [key_name(user)]</font>")
	user.attack_log += text("\[[time_stamp()]\] <font color='red'>Attempted to remove [key_name(sourcemob)]'s' splints </font>")
	sourcemob.remove_splints(user)

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

/datum/strippable_item/mob_item_slot/id/get_alternate_action(atom/source, mob/user)
	var/obj/item/card/id/dogtag/tag = get_item(source)
	if(!ishuman(source))
		return
	var/mob/living/carbon/human/sourcemob = source
	if (!istype(tag))
		return
	if (!sourcemob.undefibbable && (!skillcheck(user, SKILL_POLICE, SKILL_POLICE_SKILLED) || sourcemob.stat != DEAD))
		return
	return tag.dogtag_taken ? null : "retrieve_tag"

/datum/strippable_item/mob_item_slot/id/alternate_action(atom/source, mob/user)
	if(!ishuman(source))
		return
	var/mob/living/carbon/human/sourcemob = source
	if(user.action_busy || user.is_mob_incapacitated() || !source.Adjacent(user))
		return
	if(MODE_HAS_TOGGLEABLE_FLAG(MODE_NO_STRIPDRAG_ENEMY) && (sourcemob.stat == DEAD || sourcemob.health < HEALTH_THRESHOLD_CRIT) && !sourcemob.get_target_lock(user.faction_group))
		to_chat(user, SPAN_WARNING("You can't strip a crit or dead member of another faction!"))
		return
	if(!istype(sourcemob.wear_id, /obj/item/card/id/dogtag))
		return
	if (!sourcemob.undefibbable && !skillcheck(user, SKILL_POLICE, SKILL_POLICE_SKILLED))
		return
	var/obj/item/card/id/dogtag/tag = sourcemob.wear_id
	if(tag.dogtag_taken)
		to_chat(user, SPAN_WARNING("Someone's already taken [sourcemob]'s information tag."))
		return

	if(sourcemob.stat != DEAD)
		to_chat(user, SPAN_WARNING("You can't take a dogtag's information tag while its owner is alive."))
		return

	to_chat(user, SPAN_NOTICE("You take [sourcemob]'s information tag, leaving the ID tag"))
	tag.dogtag_taken = TRUE
	tag.icon_state = "dogtag_taken"
	var/obj/item/dogtag/newtag = new(sourcemob.loc)
	newtag.fallen_names = list(tag.registered_name)
	newtag.fallen_assgns = list(tag.assignment)
	newtag.fallen_blood_types = list(tag.blood_type)
	user.put_in_hands(newtag)



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

/datum/strippable_item/mob_item_slot/cuffs/handcuffs
	key = STRIPPABLE_ITEM_HANDCUFFS

/datum/strippable_item/mob_item_slot/cuffs/legcuffs
	key = STRIPPABLE_ITEM_LEGCUFFS
