/datum/keybinding/xenomorph
	category = CATEGORY_XENO
	weight = WEIGHT_XENO

/datum/keybinding/xenomorph/can_use(client/user)
	return isxeno(user.mob)

/datum/keybinding/xenomorph/primary_attack_one
	hotkey_keys = list("C")
	classic_keys = list("Unbound")
	name = "primary_attack_one"
	full_name = "Primary Attack One"
	keybind_signal = COMSIG_KB_XENO_PRIMARY_ATTACK_ONE

/datum/keybinding/xenomorph/primary_attack_one/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/X = user.mob
	X.xeno_primary_action_one()
	return TRUE

/datum/keybinding/xenomorph/primary_attack_two
	hotkey_keys = list("V")
	classic_keys = list("Unbound")
	name = "primary_attack_two"
	full_name = "Primary Attack Two"
	keybind_signal = COMSIG_KB_XENO_PRIMARY_ATTACK_TWO

/datum/keybinding/xenomorph/primary_attack_two/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/X = user.mob
	X.xeno_primary_action_two()
	return TRUE

/datum/keybinding/xenomorph/primary_attack_three
	hotkey_keys = list("G")
	classic_keys = list("Unbound")
	name = "primary_attack_three"
	full_name = "Primary Attack Three"
	keybind_signal = COMSIG_KB_XENO_PRIMARY_ATTACK_THREE

/datum/keybinding/xenomorph/primary_attack_three/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/X = user.mob
	X.xeno_primary_action_three()
	return TRUE

/datum/keybinding/xenomorph/primary_attack_four
	hotkey_keys = list("B")
	classic_keys = list("Unbound")
	name = "primary_attack_four"
	full_name = "Primary Attack Four"
	keybind_signal = COMSIG_KB_XENO_PRIMARY_ATTACK_FOUR

/datum/keybinding/xenomorph/primary_attack_four/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/X = user.mob
	X.xeno_primary_action_four()
	return TRUE

/datum/keybinding/xenomorph/primary_attack_five
	hotkey_keys = list("N")
	classic_keys = list("Unbound")
	name = "primary_attack_five"
	full_name = "Primary Attack Five"
	keybind_signal = COMSIG_KB_XENO_PRIMARY_ATTACK_FIVE

/datum/keybinding/xenomorph/primary_attack_five/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/X = user.mob
	X.xeno_primary_action_five()
	return TRUE

/datum/keybinding/xenomorph/emit_pheromones
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "emit_pheromones"
	full_name = "Emit Pheromones"
	description = "Select a pheromone to emit or cease emitting pheromones."
	keybind_signal = COMSIG_KB_XENO_EMIT_PHEROMONES
	var/pheromone

/datum/keybinding/xenomorph/emit_pheromones/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/X = user.mob
	X.emit_pheromones(pheromone)
	return TRUE

/datum/keybinding/xenomorph/emit_pheromones/frenzy
	name = "emit_pheromones_fernzy"
	full_name = "Emit Frenzy pheromone"
	description = "Increased run speed, damage and chance to knock off headhunter masks."
	keybind_signal = COMSIG_KB_XENO_EMIT_PHEROMONES_FRENZY
	pheromone = "frenzy"

/datum/keybinding/xenomorph/emit_pheromones/warding
	name = "emit_pheromones_warding"
	full_name = "Emit Warding pheromone"
	description = "Increased maximum negative health, and while in critical state, slower off weed bleedout."
	keybind_signal = COMSIG_KB_XENO_EMIT_PHEROMONES_WARDING
	pheromone = "warding"

/datum/keybinding/xenomorph/emit_pheromones/recovery
	name = "emit_pheromones_recovery"
	full_name = "Emit Recovery pheromone"
	description = "Increased plasma and health regeneration."
	keybind_signal = COMSIG_KB_XENO_EMIT_PHEROMONES_RECOVERY
	pheromone = "recovery"

/datum/keybinding/xenomorph/corrosive_acid
	hotkey_keys = list("Shift+C")
	classic_keys = list("Unbound")
	name = "corrosive_acid"
	full_name = "Corrosive Acid"
	keybind_signal = COMSIG_KB_XENO_CORROSIVE_ACID

/datum/keybinding/xenomorph/corrosive_acid/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	xeno.m_corrosive_acid()
	return TRUE

/datum/keybinding/xenomorph/tech_secrete_resin
	hotkey_keys = list("Shift+B")
	classic_keys = list("Unbound")
	name = "tech_secrete_resin"
	full_name = "Secrete Resin (Tech)"
	keybind_signal = COMSIG_KB_XENO_TECH_SECRETE_RESIN

/datum/keybinding/xenomorph/tech_secrete_resin/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	xeno.tech_secrete_resin()
	return TRUE

/datum/keybinding/xenomorph/screech
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "screech"
	full_name = "Screech"
	keybind_signal = COMSIG_KB_XENO_SCREECH

/datum/keybinding/xenomorph/screech/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	xeno.xeno_screech_action()
	return TRUE

/datum/keybinding/xenomorph/tail_stab
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "tail_stab"
	full_name = "Tail Stab"
	keybind_signal = COMSIG_KB_TAIL_STAB

/datum/keybinding/xenomorph/tail_stab/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	xeno.xeno_tail_stab_action()
	return TRUE

/datum/keybinding/xenomorph/hive_status
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "hive_status"
	full_name = "View Hive Status"
	keybind_signal = COMSIG_KB_XENO_HIVE_STATUS

/datum/keybinding/xenomorph/hive_status/down(client/user)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/xenomorph/xeno = user.mob
	xeno.hive_status()
	return TRUE

/datum/keybinding/xenomorph/hide
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "hide"
	full_name = "Hide"
	keybind_signal = COMSIG_KB_XENO_HIDE

/datum/keybinding/xenomorph/evolve
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "evolve"
	full_name = "Evolve"
	keybind_signal = COMSIG_KB_XENO_EVOLVE

/datum/keybinding/xenomorph/purchase_strain
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "purchase_strain"
	full_name = "Purchase Strain"
	keybind_signal = COMSIG_KB_XENO_PURCHASE_STRAIN

/datum/keybinding/xenomorph/purchase_strain/down(client/user)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/xenomorph/current_xeno = user?.mob
	current_xeno.purchase_strain()
