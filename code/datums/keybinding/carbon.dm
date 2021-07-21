/datum/keybinding/carbon
	category = CATEGORY_CARBON
	weight = WEIGHT_MOB

/datum/keybinding/carbon/can_use(client/user)
	return iscarbon(user.mob)

/datum/keybinding/carbon/toggle_throw_mode
	hotkey_keys = list("R", "Southwest") // END
	classic_keys =list("R", "Southwest")
	name = "toggle_throw_mode"
	full_name = "Toggle throw mode"
	description = "Toggle throwing the current item or not."
	category = CATEGORY_CARBON
	keybind_signal = COMSIG_KB_CARBON_TOGGLETHROWMODE_DOWN
	var/throw_mode = THROW_MODE_NORMAL

/datum/keybinding/carbon/toggle_throw_mode/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/C = user.mob
	C.toggle_throw_mode(throw_mode)
	return TRUE

/datum/keybinding/carbon/toggle_throw_mode/high
	hotkey_keys = list("Ctrl+R", "Ctrl+Southwest") // END
	classic_keys = list("Ctrl+R", "Ctrl+Southwest")
	name = "toggle_high_throw_mode"
	full_name = "Toggle high throw mode"
	description = "Toggle throwing the current item or not. This one does a high throw."
	category = CATEGORY_CARBON
	keybind_signal = COMSIG_KB_CARBON_TOGGLETHROWMODE_HIGH_DOWN
	throw_mode = THROW_MODE_HIGH

/datum/keybinding/carbon/cycle_intent
	hotkey_keys = list()
	classic_keys = list("Insert")
	name = "cycle_intent"
	full_name = "Cycle Intent"
	description = "Cycle currently selected intent"
	category = CATEGORY_CARBON
	keybind_signal = COMSIG_KB_CARBON_CYCLEINTENT_DOWN

/datum/keybinding/carbon/cycle_intent/down(client/user)
	. = ..()
	if(.)
		return
	user.mob?.a_intent_change(NONE)
	return TRUE

/datum/keybinding/carbon/select_help_intent
	hotkey_keys = list("1")
	classic_keys = list("1")
	name = "select_help_intent"
	full_name = "Select help intent"
	description = ""
	category = CATEGORY_CARBON
	keybind_signal = COMSIG_KB_CARBON_SELECTHELPINTENT_DOWN

/datum/keybinding/carbon/select_help_intent/down(client/user)
	. = ..()
	if(.)
		return
	user.mob?.a_intent_change(INTENT_HELP)
	return TRUE


/datum/keybinding/carbon/select_disarm_intent
	hotkey_keys = list("2")
	classic_keys = list("2")
	name = "select_disarm_intent"
	full_name = "Select disarm intent"
	description = ""
	category = CATEGORY_CARBON
	keybind_signal = COMSIG_KB_CARBON_SELECTDISARMINTENT_DOWN

/datum/keybinding/carbon/select_disarm_intent/down(client/user)
	. = ..()
	if(.)
		return
	user.mob?.a_intent_change(INTENT_DISARM)
	return TRUE


/datum/keybinding/carbon/select_grab_intent
	hotkey_keys = list("3")
	classic_keys = list("3")
	name = "select_grab_intent"
	full_name = "Select grab intent"
	description = ""
	category = CATEGORY_CARBON
	keybind_signal = COMSIG_KB_CARBON_SELECTGRABINTENT_DOWN

/datum/keybinding/carbon/select_grab_intent/down(client/user)
	. = ..()
	if(.)
		return
	user.mob?.a_intent_change(INTENT_GRAB)
	return TRUE


/datum/keybinding/carbon/select_harm_intent
	hotkey_keys = list("4")
	classic_keys = list("4")
	name = "select_harm_intent"
	full_name = "Select harm intent"
	description = ""
	category = CATEGORY_CARBON
	keybind_signal = COMSIG_KB_CARBON_SELECTHARMINTENT_DOWN

/datum/keybinding/carbon/select_harm_intent/down(client/user)
	. = ..()
	if(.)
		return
	user.mob?.a_intent_change(INTENT_HARM)
	return TRUE

/datum/keybinding/carbon/give
	hotkey_keys = list("G")
	classic_keys = list()
	name = "Give_Item"
	full_name = "Give item"
	description = "Give the item you're currently holding"
	keybind_signal = COMSIG_KB_CARBON_GIVEITEM_DOWN

/datum/keybinding/carbon/give/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/C = user.mob
	C.give()
	return TRUE
