/datum/keybinding/human/combat
	category = CATEGORY_HUMAN_COMBAT
	weight = WEIGHT_MOB

/datum/keybinding/human/combat/can_use(client/user)
	. = ..()
	if(!.)
		return
	var/mob/M = user.mob
	return isgun(M.get_held_item())

/datum/keybinding/human/combat/field_strip_weapon
	hotkey_keys = list()
	classic_keys = list()
	name = "field_strip_weapon"
	full_name = "Field Strip Weapon"
	keybind_signal = COMSIG_KB_HUMAN_WEAPON_FIELDSTRIP

/datum/keybinding/human/combat/field_strip_weapon/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob
	var/obj/item/weapon/gun/G = H.get_held_item()

	G.field_strip()
	return TRUE

/datum/keybinding/human/combat/toggle_burst_fire
	hotkey_keys = list()
	classic_keys = list()
	name = "toggle_burst_fire"
	full_name = "Toggle Burst Fire"
	keybind_signal = COMSIG_KB_HUMAN_WEAPON_BURSTFIRE

/datum/keybinding/human/combat/toggle_burst_fire/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob
	var/obj/item/weapon/gun/G = H.get_held_item()
	G.toggle_burst()
	return TRUE

/datum/keybinding/human/combat/stock_attachment
	hotkey_keys = list("Shift+X")
	classic_keys = list()
	name = "toggle_stock_attachment"
	full_name = "Toggle Stock Attachment"
	keybind_signal = COMSIG_KB_HUMAN_WEAPON_STOCKATTACHMENT

/datum/keybinding/human/combat/stock_attachment/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob
	var/obj/item/weapon/gun/G = H.get_held_item()
	G.toggle_stock_attachment_verb()
	return TRUE

/datum/keybinding/human/combat/auto_eject
	hotkey_keys = list()
	classic_keys = list()
	name = "toggle_auto_eject"
	full_name = "Toggle Auto Eject"
	keybind_signal = COMSIG_KB_HUMAN_WEAPON_AUTOEJECT

/datum/keybinding/human/combat/auto_eject/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob
	var/obj/item/weapon/gun/G = H.get_held_item()
	G.toggle_auto_eject_verb()
	return TRUE

/datum/keybinding/human/combat/underbarrel
	hotkey_keys = list("Shift+C")
	classic_keys = list()
	name = "toggle_underbarrel_attachment"
	full_name = "Toggle Underbarrel Attachment"
	keybind_signal = COMSIG_KB_HUMAN_WEAPON_UNDERBARREL

/datum/keybinding/human/combat/underbarrel/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob
	var/obj/item/weapon/gun/G = H.get_held_item()
	G.toggle_underbarrel_attachment_verb()
	return TRUE

/datum/keybinding/human/combat/unique_action
	hotkey_keys = list("Shift+F")
	classic_keys = list()
	name = "unique_action"
	full_name = "Unique Action"
	keybind_signal = COMSIG_KB_HUMAN_WEAPON_UNIQUEACTION

/datum/keybinding/human/combat/unique_action/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob
	var/obj/item/weapon/gun/G = H.get_held_item()
	G.use_unique_action()
	return TRUE

/datum/keybinding/human/combat/unload_gun
	hotkey_keys = list("Shift+Z")
	classic_keys = list()
	name = "unload_weapon"
	full_name = "Unload Weapon"
	keybind_signal = COMSIG_KB_HUMAN_WEAPON_UNLOAD

/datum/keybinding/human/combat/unload_gun/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob
	var/obj/item/weapon/gun/G = H.get_held_item()
	G.empty_mag()
	return TRUE

/datum/keybinding/human/combat/safety
	hotkey_keys = list("Shift+V")
	classic_keys = list()
	name = "toggle_weapon_safety"
	full_name = "Toggle Weapon Safety"
	keybind_signal = COMSIG_KB_HUMAN_WEAPON_SAFETY

/datum/keybinding/human/combat/safety/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob
	var/obj/item/weapon/gun/G = H.get_held_item()
	G.toggle_gun_safety()
	return TRUE

/datum/keybinding/human/combat/attachment
	hotkey_keys = list()
	classic_keys = list()
	name = "toggle_attachment"
	full_name = "Toggle Attachment"
	keybind_signal = COMSIG_KB_HUMAN_WEAPON_ATTACHMENT

/datum/keybinding/human/combat/attachment/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob
	var/obj/item/weapon/gun/G = H.get_held_item()
	G.activate_attachment_verb()
	return TRUE

/datum/keybinding/human/combat/attachment_rail
	hotkey_keys = list()
	classic_keys = list()
	name = "toggle_rail_attachment"
	full_name = "Toggle Rail Attachment"
	keybind_signal = COMSIG_KB_HUMAN_WEAPON_ATTACHMENT_RAIL

/datum/keybinding/human/combat/attachment_rail/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/H = user.mob
	var/obj/item/weapon/gun/G = H.get_held_item()
	G.activate_rail_attachment_verb()
	return TRUE
