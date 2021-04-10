/datum/keybinding/human
	category = CATEGORY_HUMAN
	weight = WEIGHT_MOB

/datum/keybinding/human/can_use(client/user)
	return ishuman(user.mob)

/datum/keybinding/human/quick_equip
	hotkey_keys = list("E")
	classic_keys = list("E")
	name = "quick_equip"
	full_name = "Unholster"
	description = "Take out an available weapon"
	keybind_signal = COMSIG_KB_HUMAN_QUICKEQUIP_DOWN

/datum/keybinding/human/quick_equip/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob
	H.holster_verb("none")
	return TRUE

/datum/keybinding/human/quick_equip_secondary
	hotkey_keys = list("Shift+E")
	classic_keys = list("Shift+E")
	name = "quick_equip_secondary"
	full_name = "Unholster secondary"
	description = "Take out your secondary weapon"
	keybind_signal = COMSIG_KB_HUMAN_SECONDARY_DOWN

/datum/keybinding/human/quick_equip_secondary/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob
	H.holster_verb("shift")
	return TRUE

/datum/keybinding/human/quick_equip_tertiary
	hotkey_keys = list("Ctrl+E", "Alt+E")
	classic_keys = list("Ctrl+E", "Alt+E")
	name = "quick_equip_tertiary"
	full_name = "Unholster tertiary"
	description = "Take out your tertiary item."
	keybind_signal = COMSIG_KB_HUMAN_TERTIARY_DOWN

/datum/keybinding/human/quick_equip_tertiary/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob
	H.holster_verb("ctrl")
	return TRUE

/datum/keybinding/human/quick_equip_inventory
	hotkey_keys = list()
	classic_keys = list()
	name = "quick_equip_inventory"
	full_name = "Quick equip inventory"
	description = "Quickly puts an item in the best slot available"
	keybind_signal = COMSIG_KB_HUMAN_QUICK_EQUIP_DOWN

/datum/keybinding/human/quick_equip_inventory/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob
	H.quick_equip()
	return TRUE
