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
	full_name = "Spitter: Corrosive Tail stab"
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
// Hivelord Designer

/datum/keybinding/xenomorph/hivelord_designer_change_design
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "hivelord_designer_change_design"
	full_name = "Designer: Change design"
	keybind_signal = COMSIG_KB_XENO_DESIGNER_CHANGE_DESIGN

/datum/keybinding/xenomorph/hivelord_designer_change_design/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/change_design/hivelord_designer_change_design_check = get_action(xeno, /datum/action/xeno_action/onclick/change_design)
	if(hivelord_designer_change_design_check)
		if(hivelord_designer_change_design_check && !hivelord_designer_change_design_check.hidden)
			handle_xeno_macro_datum(xeno, hivelord_designer_change_design_check)
			return TRUE

/datum/keybinding/xenomorph/hivelord_designer_place_design
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "hivelord_designer_place_design"
	full_name = "Designer: Place design"
	keybind_signal = COMSIG_KB_XENO_DESIGNER_PLACE_DESIGN

/datum/keybinding/xenomorph/hivelord_designer_place_design/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/place_design/hivelord_designer_place_design_check = get_action(xeno, /datum/action/xeno_action/activable/place_design)
	if(hivelord_designer_place_design_check)
		if(hivelord_designer_place_design_check && !hivelord_designer_place_design_check.hidden)
			handle_xeno_macro_datum(xeno, hivelord_designer_place_design_check)
			return TRUE

/datum/keybinding/xenomorph/hivelord_designer_toggle_design_icons
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "hivelord_designer_toggle_design_icons"
	full_name = "Designer: Toggle design icons"
	keybind_signal = COMSIG_KB_XENO_DESIGNER_TOGGLE_DESIGN_ICONS

/datum/keybinding/xenomorph/hivelord_designer_toggle_design_icons/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/toggle_design_icons/hivelord_designer_toggle_design_icons_check = get_action(xeno, /datum/action/xeno_action/onclick/toggle_design_icons)
	if(hivelord_designer_toggle_design_icons_check)
		if(hivelord_designer_toggle_design_icons_check && !hivelord_designer_toggle_design_icons_check.hidden)
			handle_xeno_macro_datum(xeno, hivelord_designer_toggle_design_icons_check)
			return TRUE

/datum/keybinding/xenomorph/hivelord_designer_greater_resin_surge
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "hivelord_designer_greater_resin_surge"
	full_name = "Designer: Greater resin surge"
	keybind_signal = COMSIG_KB_XENO_DESIGNER_GREATER_RESIN_SURGE

/datum/keybinding/xenomorph/hivelord_designer_greater_resin_surge/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/greater_resin_surge/hivelord_designer_greater_resin_surge_check = get_action(xeno, /datum/action/xeno_action/activable/greater_resin_surge)
	if(hivelord_designer_greater_resin_surge_check)
		if(hivelord_designer_greater_resin_surge_check && !hivelord_designer_greater_resin_surge_check.hidden)
			handle_xeno_macro_datum(xeno, hivelord_designer_greater_resin_surge_check)
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

// Ravager

/datum/keybinding/xenomorph/ravager_charge
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "ravager_charge"
	full_name = "Ravager: Charge"
	keybind_signal = COMSIG_KB_XENO_RAVAGER_CHARGE

/datum/keybinding/xenomorph/ravager_charge/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/pounce/charge/ravager_charge_check = get_action(xeno, /datum/action/xeno_action/activable/pounce/charge)
	if(ravager_charge_check)
		if(ravager_charge_check && !ravager_charge_check.hidden)
			handle_xeno_macro_datum(xeno, ravager_charge_check)
			return TRUE

/datum/keybinding/xenomorph/ravager_empower
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "ravager_empower"
	full_name = "Ravager: Empower"
	keybind_signal = COMSIG_KB_XENO_RAVAGER_EMPOWER

/datum/keybinding/xenomorph/ravager_empower/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/empower/ravager_empower_check = get_action(xeno, /datum/action/xeno_action/onclick/empower)
	if(ravager_empower_check)
		if(ravager_empower_check && !ravager_empower_check.hidden)
			handle_xeno_macro_datum(xeno, ravager_empower_check)
			return TRUE

/datum/keybinding/xenomorph/ravager_scissor_cut
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "ravager_scissor_cut"
	full_name = "Ravager: Scissor cut"
	keybind_signal = COMSIG_KB_XENO_RAVAGER_SCISSOR_CUT

/datum/keybinding/xenomorph/ravager_scissor_cut/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/scissor_cut/ravager_scissor_cut_check = get_action(xeno, /datum/action/xeno_action/activable/scissor_cut)
	if(ravager_scissor_cut_check)
		if(ravager_scissor_cut_check && !ravager_scissor_cut_check.hidden)
			handle_xeno_macro_datum(xeno, ravager_scissor_cut_check)
			return TRUE
// Ravager Berserker

/datum/keybinding/xenomorph/berserker_apprened
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "berserker_apprened"
	full_name = "Berserker: Scissor cut"
	keybind_signal = COMSIG_KB_XENO_BERSERKER_APPREHEND

/datum/keybinding/xenomorph/berserker_apprened/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/apprehend/berserker_apprened_check = get_action(xeno, /datum/action/xeno_action/onclick/apprehend)
	if(berserker_apprened_check)
		if(berserker_apprened_check && !berserker_apprened_check.hidden)
			handle_xeno_macro_datum(xeno, berserker_apprened_check)
			return TRUE

/datum/keybinding/xenomorph/berserker_clothesline
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "berserker_clothesline"
	full_name = "Berserker: Clothesline"
	keybind_signal = COMSIG_KB_XENO_BERSERKER_CLOTHESLINE

/datum/keybinding/xenomorph/berserker_clothesline/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/clothesline/berserker_clothesline_check = get_action(xeno, /datum/action/xeno_action/activable/clothesline)
	if(berserker_clothesline_check)
		if(berserker_clothesline_check && !berserker_clothesline_check.hidden)
			handle_xeno_macro_datum(xeno, berserker_clothesline_check)
			return TRUE

/datum/keybinding/xenomorph/berserker_eviscerate
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "berserker_eviscerate"
	full_name = "Berserker: Eviscerate"
	keybind_signal = COMSIG_KB_XENO_BERSERKER_EVISCERATE

/datum/keybinding/xenomorph/berserker_eviscerate/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/eviscerate/berserker_eviscerate_check = get_action(xeno, /datum/action/xeno_action/activable/eviscerate)
	if(berserker_eviscerate_check)
		if(berserker_eviscerate_check && !berserker_eviscerate_check.hidden)
			handle_xeno_macro_datum(xeno, berserker_eviscerate_check)
			return TRUE
// Ravager Hedgehog

/datum/keybinding/xenomorph/hedgehog_spike_shield
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "hedgehog_spike_shield"
	full_name = "Hedgehod: Spike Shield"
	keybind_signal = COMSIG_KB_XENO_BERSERKER_EVISCERATE

/datum/keybinding/xenomorph/hedgehog_spike_shield/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/spike_shield/hedgehog_spike_shield_check = get_action(xeno, /datum/action/xeno_action/onclick/spike_shield)
	if(hedgehog_spike_shield_check)
		if(hedgehog_spike_shield_check && !hedgehog_spike_shield_check.hidden)
			handle_xeno_macro_datum(xeno, hedgehog_spike_shield_check)
			return TRUE

/datum/keybinding/xenomorph/hedgehog_rav_spikes
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "hedgehog_rav_spikes"
	full_name = "Hedgehod: Rav Spikes"
	keybind_signal = COMSIG_KB_XENO_BERSERKER_EVISCERATE

/datum/keybinding/xenomorph/hedgehog_rav_spikes/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/rav_spikes/hedgehog_rav_spikes_check = get_action(xeno, /datum/action/xeno_action/activable/rav_spikes)
	if(hedgehog_rav_spikes_check)
		if(hedgehog_rav_spikes_check && !hedgehog_rav_spikes_check.hidden)
			handle_xeno_macro_datum(xeno, hedgehog_rav_spikes_check)
			return TRUE

/datum/keybinding/xenomorph/hedgehog_spike_shed
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "hedgehog_spike_shed"
	full_name = "Hedgehod: Spike Shed"
	keybind_signal = COMSIG_KB_XENO_HEDGEHOG_SPIKE_SHED

/datum/keybinding/xenomorph/hedgehog_spike_shed/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/spike_shed/hedgehog_spike_shed_check = get_action(xeno, /datum/action/xeno_action/onclick/spike_shed)
	if(hedgehog_spike_shed_check)
		if(hedgehog_spike_shed_check && !hedgehog_spike_shed_check.hidden)
			handle_xeno_macro_datum(xeno, hedgehog_spike_shed_check)
			return TRUE
// Praetorian

/datum/keybinding/xenomorph/praetorian_spit
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "praetorian_spit"
	full_name = "Praetorian: Spit"
	keybind_signal = COMSIG_KB_XENO_PRAETORIAN_SPIT

/datum/keybinding/xenomorph/praetorian_spit/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/xeno_spit/praetorian/praetorian_spit_check = get_action(xeno, /datum/action/xeno_action/activable/xeno_spit/praetorian)
	if(praetorian_spit_check)
		if(praetorian_spit_check && !praetorian_spit_check.hidden)
			handle_xeno_macro_datum(xeno, praetorian_spit_check)
			return TRUE

/datum/keybinding/xenomorph/praetorian_dash
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "praetorian_dash"
	full_name = "Praetorian: Dash"
	keybind_signal = COMSIG_KB_XENO_PRAETORIAN_DASH

/datum/keybinding/xenomorph/praetorian_dash/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/pounce/base_prae_dash/praetorian_dash_check = get_action(xeno, /datum/action/xeno_action/activable/pounce/base_prae_dash)
	if(praetorian_dash_check)
		if(praetorian_dash_check && !praetorian_dash_check.hidden)
			handle_xeno_macro_datum(xeno, praetorian_dash_check)
			return TRUE

/datum/keybinding/xenomorph/praetorian_acid_ball
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "praetorian_acid_ball"
	full_name = "Praetorian: Acid ball"
	keybind_signal = COMSIG_KB_XENO_PRAETORIAN_ACID_BALL

/datum/keybinding/xenomorph/praetorian_acid_ball/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/prae_acid_ball/praetorian_acid_ball_check = get_action(xeno, /datum/action/xeno_action/activable/prae_acid_ball)
	if(praetorian_acid_ball_check)
		if(praetorian_acid_ball_check && !praetorian_acid_ball_check.hidden)
			handle_xeno_macro_datum(xeno, praetorian_acid_ball_check)
			return TRUE

/datum/keybinding/xenomorph/praetorian_spray_acid
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "praetorian_spray_acid"
	full_name = "Praetorian: Spray acid"
	keybind_signal = COMSIG_KB_XENO_PRAETORIAN_SPRAY_ACID

/datum/keybinding/xenomorph/praetorian_spray_acid/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid/praetorian_spray_acid_check = get_action(xeno, /datum/action/xeno_action/activable/spray_acid/base_prae_spray_acid)
	if(praetorian_spray_acid_check)
		if(praetorian_spray_acid_check && !praetorian_spray_acid_check.hidden)
			handle_xeno_macro_datum(xeno, praetorian_spray_acid_check)
			return TRUE
// Dancer

/datum/keybinding/xenomorph/dancer_impale
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "dancer_impale"
	full_name = "Dancer: Impale"
	keybind_signal = COMSIG_KB_XENO_DANCER_IMPALE

/datum/keybinding/xenomorph/dancer_impale/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/prae_impale/dancer_impale_check = get_action(xeno, /datum/action/xeno_action/activable/prae_impale)
	if(dancer_impale_check)
		if(dancer_impale_check && !dancer_impale_check.hidden)
			handle_xeno_macro_datum(xeno, dancer_impale_check)
			return TRUE

/datum/keybinding/xenomorph/dancer_dodge
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "dancer_dodge"
	full_name = "Dancer: Dodge"
	keybind_signal = COMSIG_KB_XENO_DANCER_DODGE

/datum/keybinding/xenomorph/dancer_dodge/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/prae_dodge/dancer_dodge_check = get_action(xeno, /datum/action/xeno_action/onclick/prae_dodge)
	if(dancer_dodge_check)
		if(dancer_dodge_check && !dancer_dodge_check.hidden)
			handle_xeno_macro_datum(xeno, dancer_dodge_check)
			return TRUE

/datum/keybinding/xenomorph/dancer_tail_trip
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "dancer_tail_trip"
	full_name = "Dancer: Tail trip"
	keybind_signal = COMSIG_KB_XENO_DANCER_TAIL_TRIP

/datum/keybinding/xenomorph/dancer_tail_trip/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/prae_tail_trip/dancer_tail_trip_check = get_action(xeno, /datum/action/xeno_action/activable/prae_tail_trip)
	if(dancer_tail_trip_check)
		if(dancer_tail_trip_check && !dancer_tail_trip_check.hidden)
			handle_xeno_macro_datum(xeno, dancer_tail_trip_check)
			return TRUE
// Oppressor

/datum/keybinding/xenomorph/oppressor_adbuct
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "oppressor_adbuct"
	full_name = "Oppressor: Abduct"
	keybind_signal = COMSIG_KB_XENO_OPPRESSOR_ABDUCT

/datum/keybinding/xenomorph/oppressor_adbuct/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/prae_abduct/oppressor_adbuct_check = get_action(xeno, /datum/action/xeno_action/activable/prae_abduct)
	if(oppressor_adbuct_check)
		if(oppressor_adbuct_check && !oppressor_adbuct_check.hidden)
			handle_xeno_macro_datum(xeno, oppressor_adbuct_check)
			return TRUE

/datum/keybinding/xenomorph/oppressor_punch
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "oppressor_punch"
	full_name = "Oppressor: Punch"
	keybind_signal = COMSIG_KB_XENO_OPPRESSOR_PUNCH

/datum/keybinding/xenomorph/oppressor_punch/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/oppressor_punch/oppressor_punch_check = get_action(xeno, /datum/action/xeno_action/activable/oppressor_punch)
	if(oppressor_punch_check)
		if(oppressor_punch_check && !oppressor_punch_check.hidden)
			handle_xeno_macro_datum(xeno, oppressor_punch_check)
			return TRUE

/datum/keybinding/xenomorph/oppressor_tail_lash
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "oppressor_tail_lash"
	full_name = "Oppressor: Tail lash"
	keybind_signal = COMSIG_KB_XENO_OPPRESSOR_TAIL_LASH

/datum/keybinding/xenomorph/oppressor_tail_lash/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/tail_lash/oppressor_tail_lash_check = get_action(xeno, /datum/action/xeno_action/activable/tail_lash)
	if(oppressor_tail_lash_check)
		if(oppressor_tail_lash_check && !oppressor_tail_lash_check.hidden)
			handle_xeno_macro_datum(xeno, oppressor_tail_lash_check)
			return TRUE
// Vanguard

/datum/keybinding/xenomorph/vanguard_pierce
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "vanguard_pierce"
	full_name = "Vanguard: Pierce"
	keybind_signal = COMSIG_KB_XENO_VANGUARD_PIERCE

/datum/keybinding/xenomorph/vanguard_pierce/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/pierce/vanguard_pierce_check = get_action(xeno, /datum/action/xeno_action/activable/pierce)
	if(vanguard_pierce_check)
		if(vanguard_pierce_check && !vanguard_pierce_check.hidden)
			handle_xeno_macro_datum(xeno, vanguard_pierce_check)
			return TRUE

/datum/keybinding/xenomorph/vanguard_dash
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "vanguard_dash"
	full_name = "Vanguard: Dash"
	keybind_signal = COMSIG_KB_XENO_VANGUARD_DASH

/datum/keybinding/xenomorph/vanguard_dash/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/pounce/prae_dash/vanguard_dash_check = get_action(xeno, /datum/action/xeno_action/activable/pounce/prae_dash)
	if(vanguard_dash_check)
		if(vanguard_dash_check && !vanguard_dash_check.hidden)
			handle_xeno_macro_datum(xeno, vanguard_dash_check)
			return TRUE

/datum/keybinding/xenomorph/vanguard_cleave
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "vanguard_cleave"
	full_name = "Vanguard: Cleave"
	keybind_signal = COMSIG_KB_XENO_VANGUARD_CLEAVE

/datum/keybinding/xenomorph/vanguard_cleave/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/cleave/vanguard_cleave_check = get_action(xeno, /datum/action/xeno_action/activable/cleave)
	if(vanguard_cleave_check)
		if(vanguard_cleave_check && !vanguard_cleave_check.hidden)
			handle_xeno_macro_datum(xeno, vanguard_cleave_check)
			return TRUE

/datum/keybinding/xenomorph/vanguard_toggle_cleave
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "vanguard_toggle_cleave"
	full_name = "Vanguard: Toggle Cleave"
	keybind_signal = COMSIG_KB_XENO_VANGUARD_DASH

/datum/keybinding/xenomorph/vanguard_toggle_cleave/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/toggle_cleave/vanguard_toggle_cleave_check = get_action(xeno, /datum/action/xeno_action/onclick/toggle_cleave)
	if(vanguard_toggle_cleave_check)
		if(vanguard_toggle_cleave_check && !vanguard_toggle_cleave_check.hidden)
			handle_xeno_macro_datum(xeno, vanguard_toggle_cleave_check)
			return TRUE
// Valkyrie

/datum/keybinding/xenomorph/valkyrie_rage
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "valkyrie_rage"
	full_name = "Valkyrie: Rage"
	keybind_signal = COMSIG_KB_XENO_VALKYRIE_RAGE

/datum/keybinding/xenomorph/valkyrie_rage/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/valkyrie_rage/valkyrie_rage_check = get_action(xeno, /datum/action/xeno_action/activable/valkyrie_rage)
	if(valkyrie_rage_check)
		if(valkyrie_rage_check && !valkyrie_rage_check.hidden)
			handle_xeno_macro_datum(xeno, valkyrie_rage_check)
			return TRUE

/datum/keybinding/xenomorph/valkyrie_high_gallop
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "valkyrie_high_gallop"
	full_name = "Valkyrie: High gallop"
	keybind_signal = COMSIG_KB_XENO_VALKYRIE_HIGH_GALLOP

/datum/keybinding/xenomorph/valkyrie_high_gallop/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/high_gallop/valkyrie_high_gallop_check = get_action(xeno, /datum/action/xeno_action/activable/high_gallop)
	if(valkyrie_high_gallop_check)
		if(valkyrie_high_gallop_check && !valkyrie_high_gallop_check.hidden)
			handle_xeno_macro_datum(xeno, valkyrie_high_gallop_check)
			return TRUE

/datum/keybinding/xenomorph/valkyrie_fight_or_flight
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "valkyrie_fight_or_flight"
	full_name = "Valkyrie: Figth or flight"
	keybind_signal = COMSIG_KB_XENO_VALKYRIE_FIGHT_OR_FLIGHT

/datum/keybinding/xenomorph/valkyrie_fight_or_flight/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/fight_or_flight/valkyrie_fight_or_flight_check = get_action(xeno, /datum/action/xeno_action/onclick/fight_or_flight)
	if(valkyrie_fight_or_flight_check)
		if(valkyrie_fight_or_flight_check && !valkyrie_fight_or_flight_check.hidden)
			handle_xeno_macro_datum(xeno, valkyrie_fight_or_flight_check)
			return TRUE

/datum/keybinding/xenomorph/valkyrie_retrieve
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "valkyrie_retrieve"
	full_name = "Valkyrie: Retrieve"
	keybind_signal = COMSIG_KB_XENO_VALKYRIE_RETRIEVE

/datum/keybinding/xenomorph/valkyrie_retrieve/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/prae_retrieve/valkyrie_retrieve_check = get_action(xeno, /datum/action/xeno_action/activable/prae_retrieve)
	if(valkyrie_retrieve_check)
		if(valkyrie_retrieve_check && !valkyrie_retrieve_check.hidden)
			handle_xeno_macro_datum(xeno, valkyrie_retrieve_check)
			return TRUE
// Boiler

/datum/keybinding/xenomorph/boiler_bombard
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "boiler_bombard"
	full_name = "Boiler: Bombard"
	keybind_signal = COMSIG_KB_XENO_BOILER_BOMBARD

/datum/keybinding/xenomorph/boiler_bombard/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/xeno_spit/bombard/boiler_bombard_check = get_action(xeno, /datum/action/xeno_action/activable/xeno_spit/bombard)
	if(boiler_bombard_check)
		if(boiler_bombard_check && !boiler_bombard_check.hidden)
			handle_xeno_macro_datum(xeno, boiler_bombard_check)
			return TRUE

/datum/keybinding/xenomorph/boiler_shift_spits
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "boiler_shift_spits"
	full_name = "Boiler: Shift spits"
	keybind_signal = COMSIG_KB_XENO_BOILER_SHIFT_SPITS

/datum/keybinding/xenomorph/boiler_shift_spits/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/shift_spits/boiler/boiler_shift_spits_check = get_action(xeno, /datum/action/xeno_action/onclick/shift_spits/boiler)
	if(boiler_shift_spits_check)
		if(boiler_shift_spits_check && !boiler_shift_spits_check.hidden)
			handle_xeno_macro_datum(xeno, boiler_shift_spits_check)
			return TRUE
/datum/keybinding/xenomorph/boiler_spray_acid
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "boiler_spray_acid"
	full_name = "Boiler: Spray acid"
	keybind_signal = COMSIG_KB_XENO_BOILER_SPRAY_ACID

/datum/keybinding/xenomorph/boiler_spray_acid/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/spray_acid/boiler/boiler_spray_acid_check = get_action(xeno, /datum/action/xeno_action/activable/spray_acid/boiler)
	if(boiler_spray_acid_check)
		if(boiler_spray_acid_check && !boiler_spray_acid_check.hidden)
			handle_xeno_macro_datum(xeno, boiler_spray_acid_check)
			return TRUE

/datum/keybinding/xenomorph/boiler_acid_shroud
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "boiler_acid_shroud"
	full_name = "Boiler: Acid shroud"
	keybind_signal = COMSIG_KB_XENO_BOILER_ACID_SHROUD

/datum/keybinding/xenomorph/boiler_boiler_acid_shroudspray_acid/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/acid_shroud/boiler_acid_shroud_check = get_action(xeno, /datum/action/xeno_action/onclick/acid_shroud)
	if(boiler_acid_shroud_check)
		if(boiler_acid_shroud_check && !boiler_acid_shroud_check.hidden)
			handle_xeno_macro_datum(xeno, boiler_acid_shroud_check)
			return TRUE
// Trapper

/datum/keybinding/xenomorph/trapper_trap
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "trapper_trap"
	full_name = "Trapper: Trap"
	keybind_signal = COMSIG_KB_XENO_TRAPPER_TRAP

/datum/keybinding/xenomorph/trapper_trap/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/boiler_trap/trapper_trap_check = get_action(xeno, /datum/action/xeno_action/activable/boiler_trap)
	if(trapper_trap_check)
		if(trapper_trap_check && !trapper_trap_check.hidden)
			handle_xeno_macro_datum(xeno, trapper_trap_check)
			return TRUE

/datum/keybinding/xenomorph/trapper_acid_mine
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "trapper_acid_mine"
	full_name = "Trapper: Acid mine"
	keybind_signal = COMSIG_KB_XENO_TRAPPER_ACID_MINE

/datum/keybinding/xenomorph/trapper_acid_mine/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/acid_mine/trapper_acid_mine_check = get_action(xeno, /datum/action/xeno_action/activable/acid_mine)
	if(trapper_acid_mine_check)
		if(trapper_acid_mine_check && !trapper_acid_mine_check.hidden)
			handle_xeno_macro_datum(xeno, trapper_acid_mine_check)
			return TRUE

/datum/keybinding/xenomorph/trapper_acid_shotgun
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "trapper_acid_shotgun"
	full_name = "Trapper: Acid shotgun"
	keybind_signal = COMSIG_KB_XENO_TRAPPER_ACID_SHOTGUN

/datum/keybinding/xenomorph/trapper_acid_shotgun/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/acid_shotgun/trapper_acid_shotgun_check = get_action(xeno, /datum/action/xeno_action/activable/acid_shotgun)
	if(trapper_acid_shotgun_check)
		if(trapper_acid_shotgun_check && !trapper_acid_shotgun_check.hidden)
			handle_xeno_macro_datum(xeno, trapper_acid_shotgun_check)
			return TRUE
// Crusher

/datum/keybinding/xenomorph/crusher_charge
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "crusher_charge"
	full_name = "Crusher: Charge"
	keybind_signal = COMSIG_KB_XENO_CRUSHER_CHARGE

/datum/keybinding/xenomorph/crusher_charge/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/pounce/crusher_charge/crusher_charge_check = get_action(xeno, /datum/action/xeno_action/activable/pounce/crusher_charge)
	if(crusher_charge_check)
		if(crusher_charge_check && !crusher_charge_check.hidden)
			handle_xeno_macro_datum(xeno, crusher_charge_check)
			return TRUE

/datum/keybinding/xenomorph/crusher_stomp
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "crusher_stomp"
	full_name = "Crusher: Stomp"
	keybind_signal = COMSIG_KB_XENO_CRUSHER_STOMP

/datum/keybinding/xenomorph/crusher_stomp/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/crusher_stomp/crusher_stomp_check = get_action(xeno, /datum/action/xeno_action/onclick/crusher_stomp)
	if(crusher_stomp_check)
		if(crusher_stomp_check && !crusher_stomp_check.hidden)
			handle_xeno_macro_datum(xeno, crusher_stomp_check)
			return TRUE

/datum/keybinding/xenomorph/crusher_shield
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "crusher_shield"
	full_name = "Crusher: Shield"
	keybind_signal = COMSIG_KB_XENO_CRUSHER_SHIELD

/datum/keybinding/xenomorph/crusher_shield/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/crusher_shield/crusher_shield_check = get_action(xeno, /datum/action/xeno_action/onclick/crusher_shield)
	if(crusher_shield_check)
		if(crusher_shield_check && !crusher_shield_check.hidden)
			handle_xeno_macro_datum(xeno, crusher_shield_check)
			return TRUE
// Charger

/datum/keybinding/xenomorph/charger_charge
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "charger_charge"
	full_name = "Charger: Charge"
	keybind_signal = COMSIG_KB_XENO_CHARGER_CHARGE

/datum/keybinding/xenomorph/charger_charge/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/charger_charge/charger_charge_check = get_action(xeno, /datum/action/xeno_action/onclick/charger_charge)
	if(charger_charge_check)
		if(charger_charge_check && !charger_charge_check.hidden)
			handle_xeno_macro_datum(xeno, charger_charge_check)
			return TRUE

/datum/keybinding/xenomorph/charger_tumble
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "charger_tumble"
	full_name = "Charger: Tumble"
	keybind_signal = COMSIG_KB_XENO_CHARGER_CHARGE

/datum/keybinding/xenomorph/charger_tumble/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/tumble/charger_tumble_check = get_action(xeno, /datum/action/xeno_action/activable/tumble)
	if(charger_tumble_check)
		if(charger_tumble_check && !charger_tumble_check.hidden)
			handle_xeno_macro_datum(xeno, charger_tumble_check)
			return TRUE

/datum/keybinding/xenomorph/charger_stomp
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "charger_stomp"
	full_name = "Charger: Stomp"
	keybind_signal = COMSIG_KB_XENO_CHARGER_STOMP

/datum/keybinding/xenomorph/charger_stomp/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/crusher_stomp/charger/charger_stomp_check = get_action(xeno, /datum/action/xeno_action/onclick/crusher_stomp/charger)
	if(charger_stomp_check)
		if(charger_stomp_check && !charger_stomp_check.hidden)
			handle_xeno_macro_datum(xeno, charger_stomp_check)
			return TRUE

/datum/keybinding/xenomorph/charger_fling
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "charger_fling"
	full_name = "Charger: Fling"
	keybind_signal = COMSIG_KB_XENO_CHARGER_FLING

/datum/keybinding/xenomorph/charger_fling/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/fling/charger/charger_fling_check = get_action(xeno, /datum/action/xeno_action/activable/fling/charger)
	if(charger_fling_check)
		if(charger_fling_check && !charger_fling_check.hidden)
			handle_xeno_macro_datum(xeno, charger_fling_check)
			return TRUE
// Queen

/datum/keybinding/xenomorph/queen_gut
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "queen_gut"
	full_name = "Queen: Gut"
	keybind_signal = COMSIG_KB_XENO_QUEEN_GUT

/datum/keybinding/xenomorph/queen_gut/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/gut/queen_gut_check = get_action(xeno, /datum/action/xeno_action/activable/gut)
	if(queen_gut_check)
		if(queen_gut_check && !queen_gut_check.hidden)
			handle_xeno_macro_datum(xeno, queen_gut_check)
			return TRUE

/datum/keybinding/xenomorph/queen_spit
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "queen_spit"
	full_name = "Queen: Spit"
	keybind_signal = COMSIG_KB_XENO_QUEEN_SPIT

/datum/keybinding/xenomorph/queen_spit/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/xeno_spit/queen_macro/queen_spit_check = get_action(xeno, /datum/action/xeno_action/activable/xeno_spit/queen_macro)
	if(queen_spit_check)
		if(queen_spit_check && !queen_spit_check.hidden)
			handle_xeno_macro_datum(xeno, queen_spit_check)
			return TRUE

/datum/keybinding/xenomorph/queen_shift_spits
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "queen_shift_spits"
	full_name = "Queen: Shift spits"
	keybind_signal = COMSIG_KB_XENO_QUEEN_SHIFT_SPITS

/datum/keybinding/xenomorph/queen_shift_spits/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/shift_spits/queen_shift_spits_check = get_action(xeno, /datum/action/xeno_action/onclick/shift_spits)
	if(queen_shift_spits_check)
		if(queen_shift_spits_check && !queen_shift_spits_check.hidden)
			handle_xeno_macro_datum(xeno, queen_shift_spits_check)
			return TRUE

/datum/keybinding/xenomorph/queen_grow_ovipositor
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "queen_grow_ovipositor"
	full_name = "Queen: Grow Ovipositor"
	keybind_signal = COMSIG_KB_XENO_QUEEN_GROW_OVIPOSITOR

/datum/keybinding/xenomorph/queen_grow_ovipositor/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/grow_ovipositor/queen_grow_ovipositor_check = get_action(xeno, /datum/action/xeno_action/onclick/grow_ovipositor)
	if(queen_grow_ovipositor_check)
		if(queen_grow_ovipositor_check && !queen_grow_ovipositor_check.hidden)
			handle_xeno_macro_datum(xeno, queen_grow_ovipositor_check)
			return TRUE

/datum/keybinding/xenomorph/queen_manage_hive
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "queen_manage_hive"
	full_name = "Queen: Manage hive"
	keybind_signal = COMSIG_KB_XENO_QUEEN_MANAGE_HIVE

/datum/keybinding/xenomorph/queen_manage_hive/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/manage_hive/queen_manage_hive_check = get_action(xeno, /datum/action/xeno_action/onclick/manage_hive)
	if(queen_manage_hive_check)
		if(queen_manage_hive_check && !queen_manage_hive_check.hidden)
			handle_xeno_macro_datum(xeno, queen_manage_hive_check)
			return TRUE
// King

/datum/keybinding/xenomorph/king_rend
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "king_rend"
	full_name = "King: Rend"
	keybind_signal = COMSIG_KB_XENO_KING_REND

/datum/keybinding/xenomorph/king_rend/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/rend/king_rend_check = get_action(xeno, /datum/action/xeno_action/onclick/rend)
	if(king_rend_check)
		if(king_rend_check && !king_rend_check.hidden)
			handle_xeno_macro_datum(xeno, king_rend_check)
			return TRUE

/datum/keybinding/xenomorph/king_doom
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "king_doom"
	full_name = "King: Doom"
	keybind_signal = COMSIG_KB_XENO_KING_DOOM

/datum/keybinding/xenomorph/king_doom/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/doom/king_doom_check = get_action(xeno, /datum/action/xeno_action/activable/doom)
	if(king_doom_check)
		if(king_doom_check && !king_doom_check.hidden)
			handle_xeno_macro_datum(xeno, king_doom_check)
			return TRUE

/datum/keybinding/xenomorph/king_destroy
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "king_destroy"
	full_name = "King: Destroy"
	keybind_signal = COMSIG_KB_XENO_KING_DESTROY

/datum/keybinding/xenomorph/king_destroy/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/destroy/king_destroy_check = get_action(xeno, /datum/action/xeno_action/activable/destroy)
	if(king_destroy_check)
		if(king_destroy_check && !king_destroy_check.hidden)
			handle_xeno_macro_datum(xeno, king_destroy_check)
			return TRUE

/datum/keybinding/xenomorph/king_shield
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "king_shield"
	full_name = "King: Shield"
	keybind_signal = COMSIG_KB_XENO_KING_SHIELD

/datum/keybinding/xenomorph/king_shield/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/king_shield/king_shield_check = get_action(xeno, /datum/action/xeno_action/onclick/king_shield)
	if(king_shield_check)
		if(king_shield_check && !king_shield_check.hidden)
			handle_xeno_macro_datum(xeno, king_shield_check)
			return TRUE
// Predalien

/datum/keybinding/xenomorph/predalien_feralrush
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "predalien_feralrush"
	full_name = "Predalien: Feralrush"
	keybind_signal = COMSIG_KB_XENO_PREDALIEN_FERALRUSH

/datum/keybinding/xenomorph/predalien_feralrush/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/feralrush/predalien_feralrush_check = get_action(xeno, /datum/action/xeno_action/onclick/feralrush)
	if(predalien_feralrush_check)
		if(predalien_feralrush_check && !predalien_feralrush_check.hidden)
			handle_xeno_macro_datum(xeno, predalien_feralrush_check)
			return TRUE

/datum/keybinding/xenomorph/predalien_roar
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "predalien_roar"
	full_name = "Predalien: Roar"
	keybind_signal = COMSIG_KB_XENO_PREDALIEN_ROAR

/datum/keybinding/xenomorph/predalien_roar/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/predalien_roar/predalien_roar_check = get_action(xeno, /datum/action/xeno_action/onclick/predalien_roar)
	if(predalien_roar_check)
		if(predalien_roar_check && !predalien_roar_check.hidden)
			handle_xeno_macro_datum(xeno, predalien_roar_check)
			return TRUE

/datum/keybinding/xenomorph/predalien_feral_smash
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "predalien_feral_smash"
	full_name = "Predalien: Feral smash"
	keybind_signal = COMSIG_KB_XENO_PREDALIEN_FERALRUSH

/datum/keybinding/xenomorph/predalien_feral_smash/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/feral_smash/predalien_feral_smash_check = get_action(xeno, /datum/action/xeno_action/activable/feral_smash)
	if(predalien_feral_smash_check)
		if(predalien_feral_smash_check && !predalien_feral_smash_check.hidden)
			handle_xeno_macro_datum(xeno, predalien_feral_smash_check)
			return TRUE

/datum/keybinding/xenomorph/predalien_feralfrenzy
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "predalien_feralfrenzy"
	full_name = "Predalien: Feral frenzy"
	keybind_signal = COMSIG_KB_XENO_PREDALIEN_FERALFRENZY

/datum/keybinding/xenomorph/predalien_feralfrenzy/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/activable/feralfrenzy/predalien_feralfrenzy_check = get_action(xeno, /datum/action/xeno_action/activable/feralfrenzy)
	if(predalien_feralfrenzy_check)
		if(predalien_feralfrenzy_check && !predalien_feralfrenzy_check.hidden)
			handle_xeno_macro_datum(xeno, predalien_feralfrenzy_check)
			return TRUE

/datum/keybinding/xenomorph/predalien_toggle_gut_targeting
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "predalien_toggle_gut_targeting"
	full_name = "Predalien: Toggle gut targeting"
	keybind_signal = COMSIG_KB_XENO_PREDALIEN_TOGGLE_GUT_TARGETING

/datum/keybinding/xenomorph/predalien_toggle_gut_targeting/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/carbon/xenomorph/xeno = user.mob
	var/datum/action/xeno_action/onclick/toggle_gut_targeting/predalien_toggle_gut_targeting_check = get_action(xeno, /datum/action/xeno_action/onclick/toggle_gut_targeting)
	if(predalien_toggle_gut_targeting_check)
		if(predalien_toggle_gut_targeting_check && !predalien_toggle_gut_targeting_check.hidden)
			handle_xeno_macro_datum(xeno, predalien_toggle_gut_targeting_check)
			return TRUE
