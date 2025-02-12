GLOBAL_LIST_EMPTY(moba_castes)
GLOBAL_LIST_EMPTY(moba_castes_name)

/datum/moba_caste
	/// Path of the /datum/caste_datum that is the equivalent of this caste
	var/equivalent_caste_path

	var/name = ""
	var/category = ""
	var/list/ideal_roles = list()

	var/starting_health = 500
	var/ending_health = 2000
	// Multiplier on existing health regen
	var/starting_health_regen = 1.5
	// Same here
	var/ending_health_regen = 6
	var/starting_plasma = 400
	var/ending_plasma = 800
	var/starting_plasma_regen = 1.2
	var/ending_plasma_regen = 3.6
	var/starting_armor = 0
	var/ending_armor = 15
	var/starting_acid_armor = 0
	var/ending_acid_armor = 10
	/// Assumes base speed of -0.8 (drone speed), lower is faster
	var/speed = 0
	/// Lower is faster up until -10 (as fast as possible)
	var/attack_delay_modifier = 0
	var/starting_attack_damage = 37.5
	var/ending_attack_damage = 60

/datum/moba_caste/proc/apply_caste(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/player_component, datum/moba_player/player_datum)
	xeno.ability_speed_modifier = speed
	xeno.attack_speed_modifier = attack_delay_modifier
	handle_level_up(xeno, player_component, player_datum, player_component.level)

/datum/moba_caste/proc/handle_level_up(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/player_component, datum/moba_player/player_datum, new_level = 1)
	var/multiplier = new_level / player_component.level_cap
	xeno.maxHealth = starting_health + ((ending_health - starting_health) * multiplier)
	xeno.regeneration_multiplier = starting_health_regen + ((ending_health_regen - starting_health_regen) * multiplier)
	xeno.plasma_max = starting_plasma + ((ending_plasma_regen - starting_plasma_regen) * multiplier)
	xeno.plasma_gain = starting_plasma_regen + ((ending_plasma_regen - starting_plasma_regen) * multiplier)
	xeno.armor_deflection = starting_armor + ((ending_armor - starting_armor) * multiplier)
	xeno.acid_armor = starting_acid_armor + ((ending_acid_armor - starting_acid_armor) * multiplier)
	xeno.melee_damage_lower = starting_attack_damage + ((ending_attack_damage - starting_attack_damage) * multiplier)
	xeno.melee_damage_upper = starting_attack_damage + ((ending_attack_damage - starting_attack_damage) * multiplier)
