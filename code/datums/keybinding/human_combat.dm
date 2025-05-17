/datum/keybinding/human/combat
	category = CATEGORY_HUMAN_COMBAT

/datum/keybinding/human/combat/can_use(client/user)
	. = ..()
	if(!.)
		return
	var/mob/user_mob = user.mob
	return isgun(user_mob.get_held_item())

/datum/keybinding/human/combat/field_strip_weapon
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "field_strip_weapon"
	full_name = "Field Strip Weapon"
	keybind_signal = COMSIG_KB_HUMAN_WEAPON_FIELDSTRIP

/datum/keybinding/human/combat/field_strip_weapon/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/human = user.mob
	var/obj/item/weapon/gun/held_item = human.get_held_item()

	held_item.field_strip()
	return TRUE

/datum/keybinding/human/combat/toggle_burst_fire
	hotkey_keys = list("Ctrl+Space")
	classic_keys = list("Unbound")
	name = "toggle_burst_fire"
	full_name = "Toggle Burst Fire"
	keybind_signal = COMSIG_KB_HUMAN_WEAPON_BURSTFIRE

/datum/keybinding/human/combat/toggle_burst_fire/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/human = user.mob
	var/obj/item/weapon/gun/held_item = human.get_held_item()
	held_item.use_toggle_burst()
	return TRUE

/datum/keybinding/human/combat/stock_attachment
	hotkey_keys = list("Shift+X")
	classic_keys = list("Unbound")
	name = "toggle_stock_attachment"
	full_name = "Toggle Stock Attachment"
	keybind_signal = COMSIG_KB_HUMAN_WEAPON_STOCKATTACHMENT

/datum/keybinding/human/combat/stock_attachment/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/human = user.mob
	var/obj/item/weapon/gun/held_item = human.get_held_item()
	held_item.toggle_stock_attachment_verb()
	return TRUE

/datum/keybinding/human/combat/auto_eject
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "toggle_auto_eject"
	full_name = "Toggle Auto Eject"
	keybind_signal = COMSIG_KB_HUMAN_WEAPON_AUTOEJECT

/datum/keybinding/human/combat/auto_eject/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/human = user.mob
	var/obj/item/weapon/gun/held_item = human.get_held_item()
	held_item.toggle_auto_eject_verb()
	return TRUE

/datum/keybinding/human/combat/underbarrel
	hotkey_keys = list("Shift+Space")
	classic_keys = list("Unbound")
	name = "toggle_underbarrel_attachment"
	full_name = "Toggle Underbarrel Attachment"
	keybind_signal = COMSIG_KB_HUMAN_WEAPON_UNDERBARREL

/datum/keybinding/human/combat/underbarrel/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/human = user.mob
	var/obj/item/weapon/gun/held_item = human.get_held_item()
	held_item.toggle_underbarrel_attachment_verb()
	return TRUE

/datum/keybinding/human/combat/unique_action
	hotkey_keys = list("Space")
	classic_keys = list("Unbound")
	name = "unique_action"
	full_name = "Unique Action"
	keybind_signal = COMSIG_KB_HUMAN_WEAPON_UNIQUEACTION

/datum/keybinding/human/combat/unique_action/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/human = user.mob
	var/obj/item/weapon/gun/held_item = human.get_held_item()
	held_item.use_unique_action()
	return TRUE

/datum/keybinding/human/combat/unload_gun
	hotkey_keys = list("Shift+Z")
	classic_keys = list("Unbound")
	name = "unload_weapon"
	full_name = "Unload Weapon"
	keybind_signal = COMSIG_KB_HUMAN_WEAPON_UNLOAD

/datum/keybinding/human/combat/unload_gun/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/human = user.mob
	var/obj/item/weapon/gun/held_item = human.get_held_item()
	held_item.empty_mag()
	return TRUE

/datum/keybinding/human/combat/safety
	hotkey_keys = list("Shift+V")
	classic_keys = list("Unbound")
	name = "toggle_weapon_safety"
	full_name = "Toggle Weapon Safety"
	keybind_signal = COMSIG_KB_HUMAN_WEAPON_SAFETY

/datum/keybinding/human/combat/safety/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/human = user.mob
	var/obj/item/weapon/gun/held_item = human.get_held_item()
	held_item.toggle_gun_safety()
	return TRUE

/datum/keybinding/human/combat/attachment
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "toggle_attachment"
	full_name = "Toggle Attachment"
	keybind_signal = COMSIG_KB_HUMAN_WEAPON_ATTACHMENT

/datum/keybinding/human/combat/attachment/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/human = user.mob
	var/obj/item/weapon/gun/held_item = human.get_held_item()
	held_item.activate_attachment_verb()
	return TRUE

/datum/keybinding/human/combat/attachment_rail
	hotkey_keys = list("Shift+G")
	classic_keys = list("Unbound")
	name = "toggle_rail_attachment"
	full_name = "Toggle Rail Attachment"
	keybind_signal = COMSIG_KB_HUMAN_WEAPON_ATTACHMENT_RAIL

/datum/keybinding/human/combat/attachment_rail/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/human = user.mob
	var/obj/item/weapon/gun/held_item = human.get_held_item()
	held_item.activate_rail_attachment_verb()
	return TRUE

/datum/keybinding/human/combat/toggle_frontline_mode
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "toggle_frontline_mode"
	full_name = "Toggle Smartgun Frontline Mode"
	keybind_signal = COMSIG_KB_HUMAN_WEAPON_TOGGLE_FRONTLINE_MODE

/datum/keybinding/human/combat/toggle_aim_assist
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "toggle_aim_assist"
	full_name = "Toggle Smartgun Aim Assist"
	keybind_signal = COMSIG_KB_HUMAN_WEAPON_TOGGLE_AIM_ASSIST

/datum/keybinding/human/combat/toggle_iff
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "toggle_iff"
	full_name = "Toggle IFF"
	keybind_signal = COMSIG_KB_HUMAN_WEAPON_TOGGLE_IFF

/datum/keybinding/human/combat/toggle_iff/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/human = user.mob
	var/obj/item/weapon/gun/held_item = human.get_held_item()
	if(istype(held_item, /obj/item/weapon/gun/smartgun))
		var/obj/item/weapon/gun/smartgun/clevergun = held_item
		clevergun.toggle_lethal_mode(human)
		return TRUE
	else if(istype(held_item, /obj/item/weapon/gun/rifle/m46c))
		var/obj/item/weapon/gun/rifle/m46c/COgun = held_item
		COgun.toggle_iff(human)
		return TRUE

/datum/keybinding/human/combat/toggle_shotgun_tube
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "toggle_shotgun_tube"
	full_name = "Toggle Shotgun Tube"
	keybind_signal = COMSIG_KB_HUMAN_WEAPON_SHOTGUN_TUBE

/datum/keybinding/human/combat/toggle_shotgun_tube/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/human/human = user.mob
	var/obj/item/weapon/gun/shotgun/pump/dual_tube/held_item = human.get_held_item()
	if(istype(held_item))
		held_item.toggle_tube()
		return TRUE
