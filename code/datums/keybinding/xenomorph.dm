/datum/keybinding/xenomorph
	category = CATEGORY_XENO
	weight = WEIGHT_XENO

/datum/keybinding/xenomorph/can_use(client/user)
	return isXeno(user.mob)

/datum/keybinding/xenomorph/primary_attack_one
	hotkey_keys = list("Shift+C")
	name = "primary_attack_one"
	full_name = "Primary Attack One"
	keybind_signal = COMSIG_KB_XENO_PRIMARY_ATTACK_ONE

/datum/keybinding/xenomorph/primary_attack_one/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/Xenomorph/X = user.mob
	X.xeno_primary_action_one()
	return TRUE

/datum/keybinding/xenomorph/primary_attack_two
	hotkey_keys = list("Shift+F")
	name = "primary_attack_two"
	full_name = "Primary Attack Two"
	keybind_signal = COMSIG_KB_XENO_PRIMARY_ATTACK_TWO

/datum/keybinding/xenomorph/primary_attack_two/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/Xenomorph/X = user.mob
	X.xeno_primary_action_two()
	return TRUE

/datum/keybinding/xenomorph/primary_attack_three
	hotkey_keys = list("Shift+R")
	name = "primary_attack_three"
	full_name = "Primary Attack Three"
	keybind_signal = COMSIG_KB_XENO_PRIMARY_ATTACK_THREE

/datum/keybinding/xenomorph/primary_attack_three/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/Xenomorph/X = user.mob
	X.xeno_primary_action_three()
	return TRUE

/datum/keybinding/xenomorph/primary_attack_four
	hotkey_keys = list("Shift+T")
	name = "primary_attack_four"
	full_name = "Primary Attack Four"
	keybind_signal = COMSIG_KB_XENO_PRIMARY_ATTACK_FOUR

/datum/keybinding/xenomorph/primary_attack_four/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/Xenomorph/X = user.mob
	X.xeno_primary_action_four()
	return TRUE
