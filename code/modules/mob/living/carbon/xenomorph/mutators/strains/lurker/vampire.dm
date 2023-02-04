
/datum/xeno_mutator/Vampire
	name = "STRAIN: Lurker - Vampire"
	description = "You lose the ability to cloak in exchange for faster speed and armor, along with extra abilities that will allow you to bleed your opponents and execute them, granting you great healing."
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
