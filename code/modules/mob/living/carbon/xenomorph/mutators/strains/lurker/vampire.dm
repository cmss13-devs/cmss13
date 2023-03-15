
/datum/xeno_mutator/Vampire
	name = "STRAIN: Lurker - Vampire"
	description = "You lose all of your abilities and you forefeit a chunk of your health and damage in exchange for a large amount of armor, a little bit of movement speed, increased attack speed, and brand new abilities that make you an assassin. Rush on your opponent to disorient them and Flurry to unleash a forward cleave that can hit and slow three talls and heal you for every tall you hit. Use your special AoE Tail Jab to knock talls away, doing more damage with direct hits and even more damage and a stun if they smack into walls. Finally, execute unconscious talls with a headbite that bypasses armor and heals you for a grand amount of health."
	flavor_description = "Your thirst for tallhost blood surpasses even mine, child. Show no mercy! Slaughter them all!"
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_LURKER)
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/onclick/lurker_invisibility,
		/datum/action/xeno_action/onclick/lurker_assassinate,
		/datum/action/xeno_action/activable/pounce/lurker,
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/activable/pounce/rush,
		/datum/action/xeno_action/activable/flurry,
		/datum/action/xeno_action/activable/tail_jab,
		/datum/action/xeno_action/activable/headbite,
	)
	keystone = TRUE

/datum/xeno_mutator/Vampire/apply_mutator(datum/mutator_set/individual_mutators/mutator_set)
	. = ..()
	if (. == FALSE)
		return

	var/mob/living/carbon/xenomorph/lurker/lurker = mutator_set.xeno

	lurker.plasmapool_modifier = 0
	lurker.health_modifier -= XENO_HEALTH_MOD_MED
	lurker.speed_modifier += XENO_SPEED_FASTMOD_TIER_1
	lurker.armor_modifier += XENO_ARMOR_MOD_LARGE
	lurker.melee_damage_lower = XENO_DAMAGE_TIER_3
	lurker.melee_damage_upper = XENO_DAMAGE_TIER_3
	lurker.attack_speed_modifier -= 2

	mutator_update_actions(lurker)
	mutator_set.recalculate_actions(description, flavor_description)
	lurker.recalculate_everything()
	lurker.mutation_type = LURKER_VAMPIRE
