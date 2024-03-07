#define INTERNALS_TOGGLE_DELAY (4 SECONDS)
#define POCKET_EQUIP_DELAY (1 SECONDS)

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
	/datum/strippable_item/hand/left,
	/datum/strippable_item/hand/right,
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

// /datum/strippable_item/mob_item_slot/handcuffs
// 	key = STRIPPABLE_ITEM_HANDCUFFS
// 	item_slot = SLOT_HANDCUFFED

/datum/strippable_item/hand/left
	key = STRIPPABLE_ITEM_LHAND

/datum/strippable_item/hand/right
	key = STRIPPABLE_ITEM_RHAND

#undef INTERNALS_TOGGLE_DELAY
#undef POCKET_EQUIP_DELAY
