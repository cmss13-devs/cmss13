/datum/keybinding/mob
	category = CATEGORY_HUMAN
	weight = WEIGHT_MOB

/datum/keybinding/mob/stop_pulling
	hotkey_keys = list("H", "Delete")
	classic_keys = list("Delete")
	name = "stop_pulling"
	full_name = "Stop pulling"
	description = ""
	keybind_signal = COMSIG_KB_MOB_STOPPULLING_DOWN

/datum/keybinding/mob/stop_pulling/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/M = user.mob
	if(!M.pulling)
		to_chat(user, SPAN_NOTICE("You are not pulling anything."))
	else
		M.stop_pulling()
	return TRUE

/datum/keybinding/mob/swap_hands
	hotkey_keys = list("X", "Northeast") // PAGEUP
	classic_keys = list("X", "Northeast")
	name = "swap_hands"
	full_name = "Swap hands"
	description = ""
	keybind_signal = COMSIG_KB_MOB_SWAPHANDS_DOWN

/datum/keybinding/mob/swap_hands/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/M = user.mob
	M.swap_hand()
	return TRUE

/datum/keybinding/mob/activate_inhand
	hotkey_keys = list("Z", "Southeast") // Southeast = PAGEDOWN
	classic_keys = list("Y", "Z", "Ctrl+Y", "Ctrl+Z")
	name = "activate_inhand"
	full_name = "Activate in-hand"
	description = "Uses whatever item you have inhand"
	keybind_signal = COMSIG_KB_MOB_ACTIVATEINHAND_DOWN

/datum/keybinding/mob/activate_inhand/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/M = user.mob
	M.mode()
	return TRUE

/datum/keybinding/mob/drop_item
	hotkey_keys = list("Q")
	classic_keys = list("Unbound")
	name = "drop_item"
	full_name = "Drop Item"
	description = ""
	keybind_signal = COMSIG_KB_MOB_DROPITEM_DOWN

/datum/keybinding/mob/drop_item/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/M = user.mob
	var/obj/item/I = M.get_held_item()
	if(!I)
		to_chat(user, SPAN_WARNING("You have nothing to drop in your hand!"))
	else
		user.mob.drop_held_item(I)
	return TRUE

/datum/keybinding/mob/target_head_cycle
	hotkey_keys = list("Numpad8")
	classic_keys = list("Numpad8")
	name = "target_head_cycle"
	full_name = "Target: Cycle Head"
	description = "Pressing this key targets the head, and continued presses will cycle to the eyes and mouth. This will impact where you hit people, and can be used for surgery."
	keybind_signal = COMSIG_KB_MOB_TARGETCYCLEHEAD_DOWN

/datum/keybinding/mob/target_head_cycle/down(client/user)
	. = ..()
	if(.)
		return
	user.mob.a_select_zone("head", user)
	return TRUE

/datum/keybinding/mob/target_r_arm
	hotkey_keys = list("Numpad4")
	classic_keys = list("Numpad4")
	name = "target_r_arm"
	full_name = "Target: right arm"
	description = "Pressing this key targets the right arm. This will impact where you hit people, and can be used for surgery."
	keybind_signal = COMSIG_KB_MOB_TARGETRIGHTARM_DOWN

/datum/keybinding/mob/target_r_arm/down(client/user)
	. = ..()
	if(.)
		return
	user.mob.a_select_zone("rarm", user)
	return TRUE

/datum/keybinding/mob/target_body_chest
	hotkey_keys = list("Numpad5")
	classic_keys = list("Numpad5")
	name = "target_body_chest"
	full_name = "Target: Body"
	description = "Pressing this key targets the body. This will impact where you hit people, and can be used for surgery."
	keybind_signal = COMSIG_KB_MOB_TARGETBODYCHEST_DOWN

/datum/keybinding/mob/target_body_chest/down(client/user)
	. = ..()
	if(.)
		return
	user.mob.a_select_zone("chest", user)
	return TRUE

/datum/keybinding/mob/target_left_arm
	hotkey_keys = list("Numpad6")
	classic_keys = list("Numpad6")
	name = "target_left_arm"
	full_name = "Target: left arm"
	description = "Pressing this key targets the body. This will impact where you hit people, and can be used for surgery."
	keybind_signal = COMSIG_KB_MOB_TARGETLEFTARM_DOWN

/datum/keybinding/mob/target_left_arm/down(client/user)
	. = ..()
	if(.)
		return
	user.mob.a_select_zone("larm", user)
	return TRUE

/datum/keybinding/mob/target_right_leg
	hotkey_keys = list("Numpad1")
	classic_keys = list("Numpad1")
	name = "target_right_leg"
	full_name = "Target: Right leg"
	description = "Pressing this key targets the right leg. This will impact where you hit people, and can be used for surgery."
	keybind_signal = COMSIG_KB_MOB_TARGETRIGHTLEG_DOWN

/datum/keybinding/mob/target_right_leg/down(client/user)
	. = ..()
	if(.)
		return
	user.mob.a_select_zone("rleg", user)
	return TRUE

/datum/keybinding/mob/target_body_groin
	hotkey_keys = list("Numpad2")
	classic_keys = list("Numpad2")
	name = "target_body_groin"
	full_name = "Target: Groin"
	description = "Pressing this key targets the groin. This will impact where you hit people, and can be used for surgery."
	keybind_signal = COMSIG_KB_MOB_TARGETBODYGROIN_DOWN

/datum/keybinding/mob/target_body_groin/down(client/user)
	. = ..()
	if(.)
		return
	user.mob.a_select_zone("groin", user)
	return TRUE

/datum/keybinding/mob/target_left_leg
	hotkey_keys = list("Numpad3")
	classic_keys = list("Numpad3")
	name = "target_left_leg"
	full_name = "Target: left leg"
	description = "Pressing this key targets the left leg. This will impact where you hit people, and can be used for surgery."
	keybind_signal = COMSIG_KB_MOB_TARGETLEFTLEG_DOWN

/datum/keybinding/mob/target_left_leg/down(client/user)
	. = ..()
	if(.)
		return
	user.mob.a_select_zone("lleg", user)
	return TRUE

/datum/keybinding/mob/target_next
	hotkey_keys = list("Numpad7")
	classic_keys = list("Numpad7")
	name = "target_next"
	full_name = "Target: next"
	description = "Pressing this key targets the next body part, cycling forward through all of them. This will impact where you hit people, and can be used for surgery."
	keybind_signal = COMSIG_KB_MOB_TARGETNEXT_DOWN

/datum/keybinding/mob/target_next/down(client/user)
	. = ..()
	if(.)
		return
	user.mob.a_select_zone("next", user)
	return TRUE

/datum/keybinding/mob/target_prev
	hotkey_keys = list("Numpad9")
	classic_keys = list("Numpad9")
	name = "target_prev"
	full_name = "Target: previous"
	description = "Pressing this key targets the previous body part, cycling backward through all of them. This will impact where you hit people, and can be used for surgery."
	keybind_signal = COMSIG_KB_MOB_TARGETPREV_DOWN

/datum/keybinding/mob/target_prev/down(client/user)
	. = ..()
	if(.)
		return
	user.mob.a_select_zone("prev", user)
	return TRUE

/datum/keybinding/mob/prevent_movement
	hotkey_keys = list("Ctrl", "Alt")
	classic_keys = list("Ctrl", "Alt")
	name = "block_movement"
	full_name = "Face / Block movement"
	description = "Prevents you from moving"
	keybind_signal = COMSIG_KB_MOB_BLOCKMOVEMENT_DOWN

/datum/keybinding/mob/prevent_movement/down(client/user)
	. = ..()
	if(.)
		return
	user.movement_locked = TRUE

/datum/keybinding/mob/prevent_movement/up(client/user)
	. = ..()
	if(.)
		return
	user.movement_locked = FALSE
