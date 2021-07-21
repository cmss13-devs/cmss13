/datum/keybinding/xenomorph
	category = CATEGORY_XENO
	weight = WEIGHT_XENO

/datum/keybinding/xenomorph/can_use(client/user)
	return isXeno(user.mob)

/datum/keybinding/xenomorph/primary_attack_one
	hotkey_keys = list("C")
	classic_keys = list()
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
	hotkey_keys = list("V")
	classic_keys = list()
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
	hotkey_keys = list("G")
	classic_keys = list()
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
	hotkey_keys = list("B")
	classic_keys = list()
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

/datum/keybinding/xenomorph/corrosive_acid
	hotkey_keys = list("Shift+C")
	classic_keys = list()
	name = "corrosive_acid"
	full_name = "Corrosive Acid"
	keybind_signal = COMSIG_KB_XENO_CORROSIVE_ACID

/datum/keybinding/xenomorph/corrosive_acid/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/Xenomorph/X = user.mob
	X.m_corrosive_acid()
	return TRUE

/datum/keybinding/xenomorph/tech_secrete_resin
	hotkey_keys = list("Shift+B")
	classic_keys = list()
	name = "tech_secrete_resin"
	full_name = "Secrete Resin (Tech)"
	keybind_signal = COMSIG_KB_XENO_TECH_SECRETE_RESIN

/datum/keybinding/xenomorph/tech_secrete_resin/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/Xenomorph/X = user.mob
	X.tech_secrete_resin()
	return TRUE
