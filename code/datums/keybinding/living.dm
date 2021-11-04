/datum/keybinding/living
	category = CATEGORY_HUMAN
	weight = WEIGHT_MOB

/datum/keybinding/living/can_use(client/user)
	return isliving(user.mob)

/datum/keybinding/living/resist
	hotkey_keys = list("B")
	classic_keys = list()
	name = "resist"
	full_name = "Resist"
	description = "Break free of your current state. Handcuffed? on fire? Resist!"
	keybind_signal = COMSIG_KB_LIVING_RESIST_DOWN

/datum/keybinding/living/resist/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/L = user.mob
	L.resist()
	return TRUE

/datum/keybinding/living/rest
	hotkey_keys = list("Shift+R")
	classic_keys = list()
	name = "rest"
	full_name = "Rest"
	description = "Lay down, or get up."
	keybind_signal = COMSIG_KB_LIVING_REST_DOWN

/datum/keybinding/living/rest/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/living_mob = user.mob
	living_mob.lay_down()
	return TRUE

/datum/keybinding/living/toggle_surgery
	name = "toggle_surgery"
	full_name = "Toggle Surgery Mode"
	description = "Ready yourself to perform surgery, or not. Also activates or disables Help Intent Safety, if you didn't have that set originally."
	keybind_signal = COMSIG_KB_SURGERY_INTENT_DOWN

/datum/keybinding/living/toggle_surgery/down(client/user)
	. = ..()
	if(.)
		return
	var/datum/action/surgery_toggle/surgery_action = locate() in user.mob.actions
	if(surgery_action)
		surgery_action.action_activate()
		return TRUE
