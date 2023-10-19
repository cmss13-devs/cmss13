/datum/keybinding/human/inventory
	category = CATEGORY_HUMAN_INVENTORY

#define QUICK_EQUIP_PRIMARY 1
#define QUICK_EQUIP_SECONDARY 2
#define QUICK_EQUIP_TERTIARY 3
#define QUICK_EQUIP_QUATERNARY 4

/datum/keybinding/human/inventory/quick_equip
	hotkey_keys = list("E")
	classic_keys = list("E")
	name = "quick_equip"
	full_name = "Unholster"
	description = "Take out an available weapon"
	keybind_signal = COMSIG_KB_HUMAN_INTERACT_QUICKEQUIP_DOWN

/datum/keybinding/human/inventory/quick_equip/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/human_mob = user.mob
	human_mob.holster_verb(QUICK_EQUIP_PRIMARY)
	return TRUE

/datum/keybinding/human/inventory/quick_equip_secondary
	hotkey_keys = list("Shift+E")
	classic_keys = list("Shift+E")
	name = "quick_equip_secondary"
	full_name = "Unholster secondary"
	description = "Take out your secondary weapon"
	keybind_signal = COMSIG_KB_HUMAN_INTERACT_SECONDARY_DOWN

/datum/keybinding/human/inventory/quick_equip_secondary/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/human_mob = user.mob
	human_mob.holster_verb(QUICK_EQUIP_SECONDARY)
	return TRUE

/datum/keybinding/human/inventory/quick_equip_tertiary
	hotkey_keys = list("Ctrl+E", "Alt+E")
	classic_keys = list("Ctrl+E", "Alt+E")
	name = "quick_equip_tertiary"
	full_name = "Unholster tertiary"
	description = "Take out your tertiary item."
	keybind_signal = COMSIG_KB_HUMAN_INTERACT_TERTIARY_DOWN

/datum/keybinding/human/inventory/quick_equip_tertiary/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/human_mob = user.mob
	human_mob.holster_verb(QUICK_EQUIP_TERTIARY)
	return TRUE

/datum/keybinding/human/inventory/quick_equip_quaternary
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "quick_equip_quaternary"
	full_name = "Unholster quaternary"
	description = "Take out your quaternary item."
	keybind_signal = COMSIG_KB_HUMAN_INTERACT_QUATERNARY_DOWN

/datum/keybinding/human/inventory/quick_equip_quaternary/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/human_mob = user.mob
	human_mob.holster_verb(QUICK_EQUIP_QUATERNARY)
	return TRUE

#undef QUICK_EQUIP_PRIMARY
#undef QUICK_EQUIP_SECONDARY
#undef QUICK_EQUIP_TERTIARY
#undef QUICK_EQUIP_QUATERNARY

/datum/keybinding/human/inventory/quick_equip_inventory
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "quick_equip_inventory"
	full_name = "Quick equip inventory"
	description = "Quickly puts an item in the best slot available"
	keybind_signal = COMSIG_KB_HUMAN_INTERACT_QUICK_EQUIP_DOWN

/datum/keybinding/human/inventory/quick_equip_inventory/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/human_mob = user.mob
	human_mob.quick_equip()
	return TRUE

/datum/keybinding/human/inventory/pick_up
	hotkey_keys = list("F")
	classic_keys = list("Unbound")
	name = "pick_up"
	full_name = "Pick Up Dropped Items"
	keybind_signal = COMSIG_KB_HUMAN_INTERACT_PICK_UP

/datum/keybinding/human/inventory/pick_up/down(client/user)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/human/human_user = user.mob
	human_user.pickup_recent()
	return TRUE

/datum/keybinding/human/inventory/interact_other_hand
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "interact_other_hand"
	full_name = "Interact With Other Hand"
	keybind_signal = COMSIG_KB_HUMAN_INTERACT_OTHER_HAND

/datum/keybinding/human/inventory/interact_other_hand/down(client/user)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/human/human_user = user.mob

	var/active_hand = human_user.get_active_hand()
	var/inactive_hand = human_user.get_inactive_hand()

	if(!inactive_hand)
		return
	human_user.click_adjacent(inactive_hand, active_hand)
	return TRUE

#define INTERACT_KEYBIND_COOLDOWN_TIME (0.2 SECONDS)
#define COOLDOWN_SLOT_INTERACT_KEYBIND "slot_interact_keybind_cooldown"

/datum/keybinding/human/inventory/interact_slot
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	var/storage_slot

/datum/keybinding/human/inventory/interact_slot/proc/check_slot(mob/living/carbon/human/user)
	return

/datum/keybinding/human/inventory/interact_slot/down(client/user)
	. = ..()
	if(.)
		return
	if(!storage_slot)
		return
	if(TIMER_COOLDOWN_CHECK(src, COOLDOWN_SLOT_INTERACT_KEYBIND))
		return

	TIMER_COOLDOWN_START(src, COOLDOWN_SLOT_INTERACT_KEYBIND, INTERACT_KEYBIND_COOLDOWN_TIME)
	var/mob/living/carbon/human/human_user = user.mob
	var/obj/item/current_item = check_slot(human_user)
	var/obj/item/in_hand_item = human_user.get_active_hand()

	if(in_hand_item)
		if(!current_item)
			if(!human_user.equip_to_slot_if_possible(in_hand_item, storage_slot, FALSE, FALSE))
				return
			return TRUE

		current_item.attackby(in_hand_item, human_user)
		return TRUE

	if(!current_item)
		return
	current_item.attack_hand(human_user)
	return TRUE

/datum/keybinding/human/inventory/interact_slot/back
	name = "interact_storage_back"
	full_name = "Interact With Back Slot"
	keybind_signal = COMSIG_KB_HUMAN_INTERACT_SLOT_BACK
	storage_slot = WEAR_BACK

/datum/keybinding/human/inventory/interact_slot/back/check_slot(mob/living/carbon/human/user)
	return user.back

/datum/keybinding/human/inventory/interact_slot/belt
	name = "interact_storage_belt"
	full_name = "Interact With Belt Slot"
	keybind_signal = COMSIG_KB_HUMAN_INTERACT_SLOT_BELT
	storage_slot = WEAR_WAIST

/datum/keybinding/human/inventory/interact_slot/belt/check_slot(mob/living/carbon/human/user)
	return user.belt

/datum/keybinding/human/inventory/interact_slot/pouch_left
	name = "interact_storage_pouch_left"
	full_name = "Interact With Left Pouch Slot"
	keybind_signal = COMSIG_KB_HUMAN_INTERACT_SLOT_LEFT_POUCH
	storage_slot = WEAR_L_STORE

/datum/keybinding/human/inventory/interact_slot/pouch_left/check_slot(mob/living/carbon/human/user)
	return user.l_store

/datum/keybinding/human/inventory/interact_slot/pouch_right
	name = "interact_storage_pouch_right"
	full_name = "Interact With Right Pouch Slot"
	keybind_signal = COMSIG_KB_HUMAN_INTERACT_SLOT_RIGHT_POUCH
	storage_slot = WEAR_R_STORE

/datum/keybinding/human/inventory/interact_slot/pouch_right/check_slot(mob/living/carbon/human/user)
	return user.r_store

/datum/keybinding/human/inventory/interact_slot/uniform
	name = "interact_storage_uniform"
	full_name = "Interact With Uniform Slot"
	keybind_signal = COMSIG_KB_HUMAN_INTERACT_SLOT_UNIFORM
	storage_slot = WEAR_BODY

/datum/keybinding/human/inventory/interact_slot/uniform/check_slot(mob/living/carbon/human/user)
	return user.w_uniform

/datum/keybinding/human/inventory/interact_slot/suit
	name = "interact_storage_suit"
	full_name = "Interact With Suit Slot"
	keybind_signal = COMSIG_KB_HUMAN_INTERACT_SLOT_SUIT
	storage_slot = WEAR_JACKET

/datum/keybinding/human/inventory/interact_slot/suit/check_slot(mob/living/carbon/human/user)
	return user.wear_suit

/datum/keybinding/human/inventory/interact_slot/helmet
	name = "interact_storage_helmet"
	full_name = "Interact With Head Slot"
	keybind_signal = COMSIG_KB_HUMAN_INTERACT_SLOT_HELMET
	storage_slot = WEAR_HEAD

/datum/keybinding/human/inventory/interact_slot/helmet/check_slot(mob/living/carbon/human/user)
	return user.head

/datum/keybinding/human/inventory/interact_slot/suit_storage
	name = "interact_storage_suit_store"
	full_name = "Interact With Suit Storage Slot"
	keybind_signal = COMSIG_KB_HUMAN_INTERACT_SUIT_S_STORE
	storage_slot = WEAR_J_STORE

/datum/keybinding/human/inventory/interact_slot/suit_storage/check_slot(mob/living/carbon/human/user)
	return user.s_store

#undef INTERACT_KEYBIND_COOLDOWN_TIME
#undef COOLDOWN_SLOT_INTERACT_KEYBIND
