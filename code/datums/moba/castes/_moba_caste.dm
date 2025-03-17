GLOBAL_LIST_EMPTY(moba_castes)
GLOBAL_LIST_EMPTY(moba_castes_name)

#define MOBA_LEVEL_ABILITY_DESC_HELPER(level, one, two, three) "[level == 1 ? "<b>[##one]</b>" : "[##one]"]/[level == 2 ? "<b>[##two]</b>" : "[##two]"]/[level == 3 ? "<b>[##three]</b>" : "[##three]"]"

/datum/moba_caste
	/// Path of the /datum/caste_datum that is the equivalent of this caste
	var/equivalent_caste_path
	/// Path of the /mob/living/carbon/xenomorph that is the equivalent of this caste
	var/equivalent_xeno_path

	var/name = ""
	var/desc = "Empty description"
	var/category = ""
	var/icon = 'icons/misc/moba/caste_icons.dmi'
	var/icon_state = ""
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
	var/speed = 1
	/// Lower is faster up until -10 (as fast as possible)
	var/attack_delay_modifier = 0
	var/starting_attack_damage = 37.5
	var/ending_attack_damage = 60

	var/list/abilities_to_add = list()

/datum/moba_caste/proc/apply_caste(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/player_component, datum/moba_player/player_datum)
	xeno.ability_speed_modifier = speed
	xeno.attack_speed_modifier = attack_delay_modifier
	handle_level_up(xeno, player_component, player_datum, player_datum.level)
	for(var/path in abilities_to_add)
		var/datum/action/xeno_action = give_action(xeno, path, player_datum)
		xeno_action.AddComponent(/datum/component/moba_action, 3, (path == abilities_to_add[length(abilities_to_add)]), player_datum) // We assume the last ability is the ultimate
		if(!player_datum.ability_path_level_dict[path])
			player_datum.ability_path_level_dict[path] = 0

/datum/moba_caste/proc/handle_level_up(mob/living/carbon/xenomorph/xeno, datum/component/moba_player/player_component, datum/moba_player/player_datum, new_level = 1)
	var/multiplier = (new_level - 1) / (MOBA_MAX_LEVEL - 1)
	xeno.maxHealth = round(starting_health + ((ending_health - starting_health) * multiplier), 1)
	player_component.healing_value_standing = round(starting_health_regen + ((ending_health_regen - starting_health_regen) * multiplier), 0.1)
	player_component.healing_value_resting = round(starting_health_regen + ((ending_health_regen - starting_health_regen) * multiplier), 0.1) * MOBA_RESTING_HEAL_MULTIPLIER
	var/old_plasma = xeno.plasma_max
	xeno.plasma_max = round(starting_plasma + ((ending_plasma - starting_plasma) * multiplier), 1)
	xeno.plasma_stored += xeno.plasma_max - old_plasma
	xeno.plasma_gain = round(starting_plasma_regen + ((ending_plasma_regen - starting_plasma_regen) * multiplier), 1)
	player_component.plasma_value_standing = round(starting_plasma_regen + ((ending_plasma_regen - starting_plasma_regen) * multiplier), 0.1)
	player_component.plasma_value_resting = round(starting_plasma_regen + ((ending_plasma_regen - starting_plasma_regen) * multiplier), 0.1) * MOBA_RESTING_HEAL_MULTIPLIER
	xeno.armor_deflection = round(starting_armor + ((ending_armor - starting_armor) * multiplier), 1)
	xeno.acid_armor = round(starting_acid_armor + ((ending_acid_armor - starting_acid_armor) * multiplier), 1)
	xeno.melee_damage_lower = round(starting_attack_damage + ((ending_attack_damage - starting_attack_damage) * multiplier), 1)
	xeno.melee_damage_upper = round(starting_attack_damage + ((ending_attack_damage - starting_attack_damage) * multiplier), 1)
