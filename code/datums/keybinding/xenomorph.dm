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

/datum/keybinding/xenomorph/reset_strain
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "reset_strain"
	full_name = "Reset Strain"
	keybind_signal = COMSIG_KB_XENO_RESET_STRAIN

/datum/keybinding/xenomorph/reset_strain/down(client/user)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/xenomorph/current_xeno = user?.mob
	current_xeno.reset_strain()


/datum/keybinding/xenomorph/plant_weeds
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "plant_weeds"
	full_name = "Plant Weeds"
	keybind_signal = COMSIG_KB_XENO_PLANT_WEEDS

/datum/keybinding/xenomorph/plant_weeds/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/plant_weeds/plant = get_action(xeno, /datum/action/xeno_action/onclick/plant_weeds)
	if(plant)
		if(plant && !plant.hidden)
			handle_xeno_macro_datum(xeno, plant)
			return TRUE
	var/datum/action/xeno_action/activable/expand_weeds/expand = get_action(xeno, /datum/action/xeno_action/activable/expand_weeds)
	if(expand && !expand.hidden)
		handle_xeno_macro_datum(xeno, expand)
		return TRUE

/datum/keybinding/xenomorph/choose_resin
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "choose_resin"
	full_name = "Choose Resin Structure"
	keybind_signal = COMSIG_KB_XENO_CHOOSE_RESIN

/datum/keybinding/xenomorph/choose_resin/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/choose_resin/choose_resin_check = get_action(xeno, /datum/action/xeno_action/onclick/choose_resin)
	if(choose_resin_check)
		if(choose_resin_check && !choose_resin_check.hidden)
			handle_xeno_macro_datum(xeno, choose_resin_check)
			return TRUE

/datum/keybinding/xenomorph/toggle_seethrough
	hotkey_keys = list("Shift+Z")
	classic_keys = list("Unbound")
	name = "become_seethrough"
	full_name = "Become Seethrough"
	keybind_signal = COMSIG_KB_XENO_BECOME_SEETHROUGH

/datum/keybinding/xenomorph/toggle_seethrough/down(client/user)
	. = ..()
	if(.)
		return

	var/mob/living/carbon/xenomorph/current_xeno = user?.mob
	current_xeno.toggle_seethrough()
	return TRUE

/datum/keybinding/xenomorph/secrete_resin
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "secrete_resin"
	full_name = "Secrete Resin"
	keybind_signal = COMSIG_KB_XENO_SECRETE_RESIN

/datum/keybinding/xenomorph/secrete_resin/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/secrete_resin/secrete_resin_check = get_action(xeno, /datum/action/xeno_action/activable/secrete_resin)
	if(secrete_resin_check)
		if(secrete_resin_check && !secrete_resin_check.hidden)
			handle_xeno_macro_datum(xeno, secrete_resin_check)
			return TRUE

/datum/keybinding/xenomorph/place_construction
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "place_construction"
	full_name = "Order Construction"
	keybind_signal = COMSIG_KB_XENO_PLACE_CONSTRUCTION

/datum/keybinding/xenomorph/place_construction/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/place_construction/place_construction_check = get_action(xeno, /datum/action/xeno_action/activable/place_construction)
	if(place_construction_check)
		if(place_construction_check && !place_construction_check.hidden)
			handle_xeno_macro_datum(xeno, place_construction_check)
			return TRUE

/datum/keybinding/xenomorph/transfer_plasma
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "transfer_plasma"
	full_name = "Transfer Plasma"
	keybind_signal = COMSIG_KB_XENO_TRANSFER_PLASMA

/datum/keybinding/xenomorph/transfer_plasma/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/transfer_plasma/transfer_plasma_check = get_action(xeno, /datum/action/xeno_action/activable/transfer_plasma)
	if(transfer_plasma_check)
		if(transfer_plasma_check && !transfer_plasma_check.hidden)
			handle_xeno_macro_datum(xeno, transfer_plasma_check)
			return TRUE

/datum/keybinding/xenomorph/plant_resin_fruit
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "plant_resin_fruit"
	full_name = "Plant Resin Fruit"
	keybind_signal = COMSIG_KB_XENO_PLANT_RESIN_FRUIT

/datum/keybinding/xenomorph/plant_resin_fruit/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/plant_resin_fruit/plant_resin_fruit_check = get_action(xeno, /datum/action/xeno_action/onclick/plant_resin_fruit)
	if(plant_resin_fruit_check)
		if(plant_resin_fruit_check && !plant_resin_fruit_check.hidden)
			handle_xeno_macro_datum(xeno, plant_resin_fruit_check)
			return TRUE

/datum/keybinding/xenomorph/change_fruit
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "change_fruit"
	full_name = "Change Fruit"
	keybind_signal = COMSIG_KB_XENO_CHANGE_FRUIT

/datum/keybinding/xenomorph/change_fruit/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/change_fruit/change_fruit_check = get_action(xeno, /datum/action/xeno_action/onclick/change_fruit)
	if(change_fruit_check)
		if(change_fruit_check && !change_fruit_check.hidden)
			handle_xeno_macro_datum(xeno, change_fruit_check)
			return TRUE

/datum/keybinding/xenomorph/facehugger_pounce
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "facehugger_pounce"
	full_name = "Facehugger: Pounce"
	keybind_signal = COMSIG_KB_XENO_FACEHUGGER_POUNCE

/datum/keybinding/xenomorph/facehugger_pounce/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/pounce/facehugger/facehugger_pounce_check = get_action(xeno, /datum/action/xeno_action/activable/pounce/facehugger)
	if(facehugger_pounce_check)
		if(facehugger_pounce_check && !facehugger_pounce_check.hidden)
			handle_xeno_macro_datum(xeno, facehugger_pounce_check)
			return TRUE

/datum/keybinding/xenomorph/runner_pounce
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "runner_pounce"
	full_name = "Runner: Pounce"
	keybind_signal = COMSIG_KB_XENO_RUNNER_POUNCE

/datum/keybinding/xenomorph/runner_pounce/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/pounce/runner/runner_pounce_check = get_action(xeno, /datum/action/xeno_action/activable/pounce/runner)
	if(runner_pounce_check)
		if(runner_pounce_check && !runner_pounce_check.hidden)
			handle_xeno_macro_datum(xeno, runner_pounce_check)
			return TRUE

/datum/keybinding/xenomorph/runner_bonespur
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "runner_bonespur"
	full_name = "Runner: Bone Spur"
	keybind_signal = COMSIG_KB_XENO_RUNNER_BONE_SPUR

/datum/keybinding/xenomorph/runner_bonespur/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/runner_skillshot/runner_bonespur_check = get_action(xeno, /datum/action/xeno_action/activable/runner_skillshot)
	if(runner_bonespur_check)
		if(runner_bonespur_check && !runner_bonespur_check.hidden)
			handle_xeno_macro_datum(xeno, runner_bonespur_check)
			return TRUE

/datum/keybinding/xenomorph/toggle_long_range
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "toggle_long_range"
	full_name = "Toggle Long Range Sight"
	keybind_signal = COMSIG_KB_XENO_TOGGLE_LONG_RANGE_SIGHT

/datum/keybinding/xenomorph/toggle_long_range/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/toggle_long_range/toggle_long_range_check = get_action(xeno, /datum/action/xeno_action/onclick/toggle_long_range)
	if(toggle_long_range_check)
		if(toggle_long_range_check && !toggle_long_range_check.hidden)
			handle_xeno_macro_datum(xeno, toggle_long_range_check)
			return TRUE

/datum/keybinding/xenomorph/acider_for_the_hive
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "acider_for_the_hive"
	full_name = "Acider: For The Hive"
	keybind_signal = COMSIG_KB_XENO_ACIDER_FOR_THE_HIVE

/datum/keybinding/xenomorph/acider_for_the_hive/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/acider_for_the_hive/acider_for_the_hive_check = get_action(xeno, /datum/action/xeno_action/activable/acider_for_the_hive)
	if(acider_for_the_hive_check)
		if(acider_for_the_hive_check && !acider_for_the_hive_check.hidden)
			handle_xeno_macro_datum(xeno, acider_for_the_hive_check)
			return TRUE

/datum/keybinding/xenomorph/acider_acid
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "acider_acid"
	full_name = "Acider: Corrosive Acid"
	keybind_signal = COMSIG_KB_XENO_ACIDER_ACID

/datum/keybinding/xenomorph/acider_acid/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/acider_acid/acider_acid_check = get_action(xeno, /datum/action/xeno_action/activable/acider_acid)
	if(acider_acid_check)
		if(acider_acid_check && !acider_acid_check.hidden)
			handle_xeno_macro_datum(xeno, acider_acid_check)
			return TRUE

// Xenomorph Drone

/datum/keybinding/xenomorph/apply_salve
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "apply_salve"
	full_name = "Healer: Apply Salve"
	keybind_signal = COMSIG_KB_XENO_HEALER_APPLY_SALVE

/datum/keybinding/xenomorph/apply_salve/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/apply_salve/apply_salve_check = get_action(xeno, /datum/action/xeno_action/activable/apply_salve)
	if(apply_salve_check)
		if(apply_salve_check && !apply_salve_check.hidden)
			handle_xeno_macro_datum(xeno, apply_salve_check)
			return TRUE

/datum/keybinding/xenomorph/healer_sacrifice
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "healer_sacrifice"
	full_name = "Healer: Sacrifice"
	keybind_signal = COMSIG_KB_XENO_HEALER_SACRIFICE

/datum/keybinding/xenomorph/healer_sacrifice/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/healer_sacrifice/healer_sacrifice_check = get_action(xeno, /datum/action/xeno_action/activable/healer_sacrifice)
	if(healer_sacrifice_check)
		if(healer_sacrifice_check && !healer_sacrifice_check.hidden)
			handle_xeno_macro_datum(xeno, healer_sacrifice_check)
			return TRUE

/datum/keybinding/xenomorph/gardener_plant_weeds
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "gardener_plant_weeds"
	full_name = "Gardener: Plant Hardy Weeds"
	keybind_signal = COMSIG_KB_XENO_GARDENER_PLANT_WEEDS

/datum/keybinding/xenomorph/gardener_plant_weeds/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/plant_weeds/gardener/gardener_plant_weeds_check = get_action(xeno, /datum/action/xeno_action/onclick/plant_weeds/gardener)
	if(gardener_plant_weeds_check)
		if(gardener_plant_weeds_check && !gardener_plant_weeds_check.hidden)
			handle_xeno_macro_datum(xeno, gardener_plant_weeds_check)
			return TRUE

/datum/keybinding/xenomorph/gardener_resin_surge
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "gardener_resin_surge"
	full_name = "Gardener: Resin Surge"
	keybind_signal = COMSIG_KB_XENO_GARDENER_RESING_SURGE

/datum/keybinding/xenomorph/gardener_resin_surge/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/resin_surge/gardener_resin_surge_check = get_action(xeno, /datum/action/xeno_action/activable/resin_surge)
	if(gardener_resin_surge_check)
		if(gardener_resin_surge_check && !gardener_resin_surge_check.hidden)
			handle_xeno_macro_datum(xeno, gardener_resin_surge_check)
			return TRUE

// Xenomorph Sentinel

/datum/keybinding/xenomorph/slowing_spit
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "slowing_spit"
	full_name = "Sentinel: Slowing Spit"
	keybind_signal = COMSIG_KB_XENO_SENTINEL_SLOWING_SPIT

/datum/keybinding/xenomorph/slowing_spit/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/slowing_spit/slowing_spit_check = get_action(xeno, /datum/action/xeno_action/activable/slowing_spit)
	if(slowing_spit_check)
		if(slowing_spit_check && !slowing_spit_check.hidden)
			handle_xeno_macro_datum(xeno, slowing_spit_check)
			return TRUE

/datum/keybinding/xenomorph/scattered_spit
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "scattered_spit"
	full_name = "Sentinel: Scattered Spit"
	keybind_signal = COMSIG_KB_XENO_SENTINEL_SLOWING_SPIT

/datum/keybinding/xenomorph/scattered_spit/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/scattered_spit/scattered_spit_check = get_action(xeno, /datum/action/xeno_action/activable/scattered_spit)
	if(scattered_spit_check)
		if(scattered_spit_check && !scattered_spit_check.hidden)
			handle_xeno_macro_datum(xeno, scattered_spit_check)
			return TRUE

/datum/keybinding/xenomorph/paralyzing_slash
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "paralyzing_slash"
	full_name = "Sentinel: Paralyzing Slash"
	keybind_signal = COMSIG_KB_XENO_SENTINEL_PARALYZING_SLASH

/datum/keybinding/xenomorph/paralyzing_slash/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/paralyzing_slash/paralyzing_slash_check = get_action(xeno, /datum/action/xeno_action/onclick/paralyzing_slash)
	if(paralyzing_slash_check)
		if(paralyzing_slash_check && !paralyzing_slash_check.hidden)
			handle_xeno_macro_datum(xeno, paralyzing_slash_check)
			return TRUE

// Xenomorph Defender

/datum/keybinding/xenomorph/toggle_crest
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "toggle_crest"
	full_name = "Defender: Toggle Crest Defence"
	keybind_signal = COMSIG_KB_XENO_DEFENDER_TOGGLE_CREST_DEFENCE

/datum/keybinding/xenomorph/toggle_crest/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/toggle_crest/toggle_crest_check = get_action(xeno, /datum/action/xeno_action/onclick/toggle_crest)
	if(toggle_crest_check)
		if(toggle_crest_check && !toggle_crest_check.hidden)
			handle_xeno_macro_datum(xeno, toggle_crest_check)
			return TRUE

/datum/keybinding/xenomorph/defender_headbutt
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "defender_headbutt"
	full_name = "Defender: Headbutt"
	keybind_signal = COMSIG_KB_XENO_DEFENDER_HEADBUTT

/datum/keybinding/xenomorph/defender_headbutt/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/headbutt/defender_headbutt_check = get_action(xeno, /datum/action/xeno_action/activable/headbutt)
	if(defender_headbutt_check)
		if(defender_headbutt_check && !defender_headbutt_check.hidden)
			handle_xeno_macro_datum(xeno, defender_headbutt_check)
			return TRUE

/datum/keybinding/xenomorph/defender_tail_sweep
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "defender_tail_sweep"
	full_name = "Defender: Tail Sweep"
	keybind_signal = COMSIG_KB_XENO_DEFENDER_TAIL_SWEEP

/datum/keybinding/xenomorph/defender_tail_sweep/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/tail_sweep/defender_tail_sweep_check = get_action(xeno, /datum/action/xeno_action/onclick/tail_sweep)
	if(defender_tail_sweep_check)
		if(defender_tail_sweep_check && !defender_tail_sweep_check.hidden)
			handle_xeno_macro_datum(xeno, defender_tail_sweep_check)
			return TRUE

/datum/keybinding/xenomorph/fortify
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "fortify"
	full_name = "Defender: Fortify"
	keybind_signal = COMSIG_KB_XENO_DEFENDER_FORTIFY

/datum/keybinding/xenomorph/fortify/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/fortify/fortify_check = get_action(xeno, /datum/action/xeno_action/activable/fortify)
	if(fortify_check)
		if(fortify_check && !fortify_check.hidden)
			handle_xeno_macro_datum(xeno, fortify_check)
			return TRUE

/datum/keybinding/xenomorph/steal_crest_soak
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "steal_crest_soak"
	full_name = "Steal Crest: Soak"
	keybind_signal = COMSIG_KB_XENO_STEEL_CREST_SOAK

/datum/keybinding/xenomorph/steal_crest_soak/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/soak/soak_check = get_action(xeno, /datum/action/xeno_action/onclick/soak)
	if(soak_check)
		if(soak_check && !soak_check.hidden)
			handle_xeno_macro_datum(xeno, soak_check)
			return TRUE

// Spitter

/datum/keybinding/xenomorph/spitter_spray_acid
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "spitter_spray_acid"
	full_name = "Spitter: spray acid"
	keybind_signal = COMSIG_KB_XENO_SPITTER_SPRAY_ACID

/datum/keybinding/xenomorph/spitter_spray_acid/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/spray_acid/spitter/spitter_spray_acid_check = get_action(xeno, /datum/action/xeno_action/activable/spray_acid/spitter)
	if(spitter_spray_acid_check)
		if(spitter_spray_acid_check && !spitter_spray_acid_check.hidden)
			handle_xeno_macro_datum(xeno, spitter_spray_acid_check)
			return TRUE

/datum/keybinding/xenomorph/spitter_charge_spit
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "spitter_charge_spit"
	full_name = "Spitter: Charge spit"
	keybind_signal = COMSIG_KB_XENO_SPITTER_CHARGE_SPIT

/datum/keybinding/xenomorph/spitter_charge_spit/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/charge_spit/spitter_charge_spit_check = get_action(xeno, /datum/action/xeno_action/onclick/charge_spit)
	if(spitter_charge_spit_check)
		if(spitter_charge_spit_check && !spitter_charge_spit_check.hidden)
			handle_xeno_macro_datum(xeno, spitter_charge_spit_check)
			return TRUE

/datum/keybinding/xenomorph/spitter_spit
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "spitter_spit"
	full_name = "Spitter: Spit"
	keybind_signal = COMSIG_KB_XENO_SPITTER_SPIT

/datum/keybinding/xenomorph/spitter_spit/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/xeno_spit/spitter/spitter_spit_check = get_action(xeno, /datum/action/xeno_action/activable/xeno_spit/spitter)
	if(spitter_spit_check)
		if(spitter_spit_check && !spitter_spit_check.hidden)
			handle_xeno_macro_datum(xeno, spitter_spit_check)
			return TRUE

/datum/keybinding/xenomorph/spitter_tail_stab
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "spitter_tail_stab"
	full_name = "Spitter: Corrosive acid"
	keybind_signal = COMSIG_KB_XENO_SPITTER_TAIL_STAB

/datum/keybinding/xenomorph/spitter_tail_stab/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/tail_stab/spitter/spitter_tail_stab_check = get_action(xeno, /datum/action/xeno_action/activable/tail_stab/spitter)
	if(spitter_tail_stab_check)
		if(spitter_tail_stab_check && !spitter_tail_stab_check.hidden)
			handle_xeno_macro_datum(xeno, spitter_tail_stab_check)
			return TRUE
// Warrior

/datum/keybinding/xenomorph/warrior_punch
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "warrior_punch"
	full_name = "Warrior: Punch"
	keybind_signal = COMSIG_KB_XENO_WARRIOR_PUNCH

/datum/keybinding/xenomorph/warrior_punch/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/warrior_punch/warrior_punch_check = get_action(xeno, /datum/action/xeno_action/activable/warrior_punch)
	if(warrior_punch_check)
		if(warrior_punch_check && !warrior_punch_check.hidden)
			handle_xeno_macro_datum(xeno, warrior_punch_check)
			return TRUE

/datum/keybinding/xenomorph/warrior_lunch
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "warrior_lunch"
	full_name = "Warrior: Lunch"
	keybind_signal = COMSIG_KB_XENO_WARRIOR_LUNCH

/datum/keybinding/xenomorph/warrior_lunch/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/lunge/warrior_lunch_check = get_action(xeno, /datum/action/xeno_action/activable/lunge)
	if(warrior_lunch_check)
		if(warrior_lunch_check && !warrior_lunch_check.hidden)
			handle_xeno_macro_datum(xeno, warrior_lunch_check)
			return TRUE

/datum/keybinding/xenomorph/warrior_fling
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "warrior_fling"
	full_name = "Warrior: Fling"
	keybind_signal = COMSIG_KB_XENO_WARRIOR_FLING

/datum/keybinding/xenomorph/warrior_fling/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/fling/warrior_fling_check = get_action(xeno, /datum/action/xeno_action/activable/fling)
	if(warrior_fling_check)
		if(warrior_fling_check && !warrior_fling_check.hidden)
			handle_xeno_macro_datum(xeno, warrior_fling_check)
			return TRUE
// Burrower

/datum/keybinding/xenomorph/burrower_build_tunnel
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "burrower_build_tunnel"
	full_name = "Burrower: Build Tunnel"
	keybind_signal = COMSIG_KB_XENO_BURROWER_BUILD_TUNNEL

/datum/keybinding/xenomorph/burrower_build_tunnel/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/build_tunnel/burrower_build_tunnel_check = get_action(xeno, /datum/action/xeno_action/onclick/build_tunnel)
	if(burrower_build_tunnel_check)
		if(burrower_build_tunnel_check && !burrower_build_tunnel_check.hidden)
			handle_xeno_macro_datum(xeno, burrower_build_tunnel_check)
			return TRUE

/datum/keybinding/xenomorph/burrower_place_trap
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "burrower_place_trap"
	full_name = "Burrower: Place Trap"
	keybind_signal = COMSIG_KB_XENO_BURROWER_PLACE_TRAP

/datum/keybinding/xenomorph/burrower_place_trap/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/place_trap/burrower_place_trap_check = get_action(xeno, /datum/action/xeno_action/onclick/place_trap)
	if(burrower_place_trap_check)
		if(burrower_place_trap_check && !burrower_place_trap_check.hidden)
			handle_xeno_macro_datum(xeno, burrower_place_trap_check)
			return TRUE

/datum/keybinding/xenomorph/burrower_burrow
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "burrower_burrow"
	full_name = "Burrower: Burrow"
	keybind_signal = COMSIG_KB_XENO_BURROWER_BURROW

/datum/keybinding/xenomorph/burrower_burrow/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/burrow/burrower_burrow_check = get_action(xeno, /datum/action/xeno_action/activable/burrow)
	if(burrower_burrow_check)
		if(burrower_burrow_check && !burrower_burrow_check.hidden)
			handle_xeno_macro_datum(xeno, burrower_burrow_check)
			return TRUE

/datum/keybinding/xenomorph/burrower_tremor
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "burrower_tremor"
	full_name = "Burrower: Tremor"
	keybind_signal = COMSIG_KB_XENO_BURROWER_TREMOR

/datum/keybinding/xenomorph/burrower_tremor/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/tremor/burrower_tremor_check = get_action(xeno, /datum/action/xeno_action/onclick/tremor)
	if(burrower_tremor_check)
		if(burrower_tremor_check && !burrower_tremor_check.hidden)
			handle_xeno_macro_datum(xeno, burrower_tremor_check)
			return TRUE

/datum/keybinding/xenomorph/burrower_toggle_meson_vision
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "burrower_toggle_meson_vision"
	full_name = "Burrower: Togggle meson vision"
	keybind_signal = COMSIG_KB_XENO_BURROWER_TOGGLE_MESON_VISION

/datum/keybinding/xenomorph/burrower_toggle_meson_vision/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/active_toggle/toggle_meson_vision/burrower_toggle_meson_vision_check = get_action(xeno, /datum/action/xeno_action/active_toggle/toggle_meson_vision)
	if(burrower_toggle_meson_vision_check)
		if(burrower_toggle_meson_vision_check && !burrower_toggle_meson_vision_check.hidden)
			handle_xeno_macro_datum(xeno, burrower_toggle_meson_vision_check)
			return TRUE
// Hivelord

/datum/keybinding/xenomorph/hivelord_resin_whisperer_toggle_speed
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "hivelord_resin_whisperer_toggle_speed"
	full_name = "Resin Whisperer: Toggle speed"
	keybind_signal = COMSIG_KB_XENO_RESIN_WHISPERER_TOGGLE_SPEED

/datum/keybinding/xenomorph/hivelord_resin_whisperer_toggle_speed/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/active_toggle/toggle_speed/hivelord_resin_whisperer_toggle_speed_check = get_action(xeno, /datum/action/xeno_action/active_toggle/toggle_speed)
	if(hivelord_resin_whisperer_toggle_speed_check)
		if(hivelord_resin_whisperer_toggle_speed_check && !hivelord_resin_whisperer_toggle_speed_check.hidden)
			handle_xeno_macro_datum(xeno, hivelord_resin_whisperer_toggle_speed_check)
			return TRUE
// Lurker

/datum/keybinding/xenomorph/lurker_invisibility
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "lurker_invisibility"
	full_name = "Lurker: Invisibility"
	keybind_signal = COMSIG_KB_XENO_LURKER_INVISIBILITY

/datum/keybinding/xenomorph/lurker_invisibility/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/lurker_invisibility/lurker_invisibility_check = get_action(xeno, /datum/action/xeno_action/onclick/lurker_invisibility)
	if(lurker_invisibility_check)
		if(lurker_invisibility_check && !lurker_invisibility_check.hidden)
			handle_xeno_macro_datum(xeno, lurker_invisibility_check)
			return TRUE

/datum/keybinding/xenomorph/lurker_pounce
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "lurker_pounce"
	full_name = "Lurker: Pounce"
	keybind_signal = COMSIG_KB_XENO_LURKER_POUNCE

/datum/keybinding/xenomorph/lurker_pounce/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/pounce/lurker/lurker_pounce_check = get_action(xeno, /datum/action/xeno_action/activable/pounce/lurker)
	if(lurker_pounce_check)
		if(lurker_pounce_check && !lurker_pounce_check.hidden)
			handle_xeno_macro_datum(xeno, lurker_pounce_check)
			return TRUE

/datum/keybinding/xenomorph/lurker_assasinate
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "lurker_assasinate"
	full_name = "Lurker: Assasinate"
	keybind_signal = COMSIG_KB_XENO_LURKER_ASSASINATE

/datum/keybinding/xenomorph/lurker_assasinate/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/lurker_assassinate/lurker_assasinate_check = get_action(xeno, /datum/action/xeno_action/onclick/lurker_assassinate)
	if(lurker_assasinate_check)
		if(lurker_assasinate_check && !lurker_assasinate_check.hidden)
			handle_xeno_macro_datum(xeno, lurker_assasinate_check)
			return TRUE
// Lurker Vampire

/datum/keybinding/xenomorph/vampire_rush
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "vampire_rush"
	full_name = "Vampire: Rush"
	keybind_signal = COMSIG_KB_XENO_VAMPIRE_RUSH

/datum/keybinding/xenomorph/vampire_rush/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/pounce/rush/vampire_rush_check = get_action(xeno, /datum/action/xeno_action/activable/pounce/rush)
	if(vampire_rush_check)
		if(vampire_rush_check && !vampire_rush_check.hidden)
			handle_xeno_macro_datum(xeno, vampire_rush_check)
			return TRUE

/datum/keybinding/xenomorph/vampire_flurry
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "vampire_flurry"
	full_name = "Vampire: Flurry"
	keybind_signal = COMSIG_KB_XENO_VAMPIRE_FLURRY

/datum/keybinding/xenomorph/vampire_flurry/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/flurry/vampire_flurry_check = get_action(xeno, /datum/action/xeno_action/activable/flurry)
	if(vampire_flurry_check)
		if(vampire_flurry_check && !vampire_flurry_check.hidden)
			handle_xeno_macro_datum(xeno, vampire_flurry_check)
			return TRUE

/datum/keybinding/xenomorph/vampire_tail_jab
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "vampire_tail_jab"
	full_name = "Vampire: Tail Jab"
	keybind_signal = COMSIG_KB_XENO_VAMPIRE_TAIL_JAB

/datum/keybinding/xenomorph/vampire_tail_jab/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/tail_jab/vampire_tail_jab_check = get_action(xeno, /datum/action/xeno_action/activable/tail_jab)
	if(vampire_tail_jab_check)
		if(vampire_tail_jab_check && !vampire_tail_jab_check.hidden)
			handle_xeno_macro_datum(xeno, vampire_tail_jab_check)
			return TRUE

/datum/keybinding/xenomorph/vampire_headbite
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "vampire_headbite"
	full_name = "Vampire: Headbite"
	keybind_signal = COMSIG_KB_XENO_VAMPIRE_HEADBITE

/datum/keybinding/xenomorph/vampire_headbite/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/headbite/vampire_headbite_check = get_action(xeno, /datum/action/xeno_action/activable/headbite)
	if(vampire_headbite_check)
		if(vampire_headbite_check && !vampire_headbite_check.hidden)
			handle_xeno_macro_datum(xeno, vampire_headbite_check)
			return TRUE
//Carrier

/datum/keybinding/xenomorph/carrier_throw_hugger
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "carrier_throw_hugger"
	full_name = "Carrier: Throw hugger"
	keybind_signal = COMSIG_KB_XENO_CARRIER_THROW_HUGGER

/datum/keybinding/xenomorph/carrier_throw_hugger/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/throw_hugger/carrier_throw_hugger_check = get_action(xeno, /datum/action/xeno_action/activable/throw_hugger)
	if(carrier_throw_hugger_check)
		if(carrier_throw_hugger_check && !carrier_throw_hugger_check.hidden)
			handle_xeno_macro_datum(xeno, carrier_throw_hugger_check)
			return TRUE

/datum/keybinding/xenomorph/carrier_retrieve_egg
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "carrier_retrieve_egg"
	full_name = "Carrier: Retrieve egg"
	keybind_signal = COMSIG_KB_XENO_CARRIER_RETRIEVE_EGG

/datum/keybinding/xenomorph/carrier_retrieve_egg/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/retrieve_egg/carrier_retrieve_egg_check = get_action(xeno, /datum/action/xeno_action/activable/retrieve_egg)
	if(carrier_retrieve_egg_check)
		if(carrier_retrieve_egg_check && !carrier_retrieve_egg_check.hidden)
			handle_xeno_macro_datum(xeno, carrier_retrieve_egg_check)
			return TRUE

/datum/keybinding/xenomorph/set_hugger_reserve
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "set_hugger_reserve"
	full_name = "Carrier: Set hugger reserve"
	keybind_signal = COMSIG_KB_XENO_CARRIER_SET_HUGGER_RESERVE

/datum/keybinding/xenomorph/set_hugger_reserve/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/set_hugger_reserve/set_hugger_reserve_check = get_action(xeno, /datum/action/xeno_action/onclick/set_hugger_reserve)
	if(set_hugger_reserve_check)
		if(set_hugger_reserve_check && !set_hugger_reserve_check.hidden)
			handle_xeno_macro_datum(xeno, set_hugger_reserve_check)
			return TRUE
// Eggsac

/datum/keybinding/xenomorph/eggsac_generate_egg
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "eggsac_generate_egg"
	full_name = "Eggsac: Toggle generate egg"
	keybind_signal = COMSIG_KB_XENO_CARRIER_SET_HUGGER_RESERVE

/datum/keybinding/xenomorph/eggsac_generate_egg/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/active_toggle/generate_egg/eggsac_generate_egg_check = get_action(xeno, /datum/action/xeno_action/active_toggle/generate_egg)
	if(eggsac_generate_egg_check)
		if(eggsac_generate_egg_check && !eggsac_generate_egg_check.hidden)
			handle_xeno_macro_datum(xeno, eggsac_generate_egg_check)
			return TRUE

/datum/keybinding/xenomorph/eggsac_retrieve_egg
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "eggsac_retrieve_egg"
	full_name = "Eggsac: Retrieve egg"
	keybind_signal = COMSIG_KB_XENO_EGGSAC_RETRIEVE_EGG

/datum/keybinding/xenomorph/eggsac_retrieve_egg/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/retrieve_egg/eggsac_retrieve_egg_check = get_action(xeno, /datum/action/xeno_action/activable/retrieve_egg)
	if(eggsac_retrieve_egg_check)
		if(eggsac_retrieve_egg_check && !eggsac_retrieve_egg_check.hidden)
			handle_xeno_macro_datum(xeno, eggsac_retrieve_egg_check)
			return TRUE

