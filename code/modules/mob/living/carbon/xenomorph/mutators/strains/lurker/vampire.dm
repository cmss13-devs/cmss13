/datum/xeno_mutator/Vampire
	name = "STRAIN: Lurker - Vampire"
	description = "You lose the ability to cloak in exchange for faster speed and armor, along with extra abilities that will allow you to bleed your opponents and execute them, granting you great healing."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_LURKER)
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/onclick/lurker_invisibility,
		/datum/action/xeno_action/onclick/lurker_assassinate,
		/datum/action/xeno_action/activable/pounce/lurker
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/activable/pounce/rush,
		/datum/action/xeno_action/activable/flurry,
		/datum/action/xeno_action/activable/tail_jab
	)
	keystone = TRUE

/datum/xeno_mutator/Vampire/apply_mutator(var/datum/mutator_set/individual_mutators/selected_xeno)
	. = ..()
	if (. == FALSE)
		return

	var/mob/living/carbon/Xenomorph/Lurker/xeno_client = selected_xeno

	xeno_client.plasmapool_modifier = 0
	xeno_client.health_modifier -= XENO_HEALTH_MOD_MED
	xeno_client.speed_modifier += XENO_SPEED_FASTMOD_TIER_2
	xeno_client.armor_modifier += XENO_ARMOR_MOD_LARGE
	xeno_client.melee_damage_lower = XENO_DAMAGE_TIER_3
	xeno_client.melee_damage_upper = XENO_DAMAGE_TIER_3
	xeno_client.attack_speed_modifier -= 2

	mutator_update_actions(xeno_client)
	xeno_client.recalculate_actions(description, flavor_description)
	xeno_client.recalculate_plasma()
	xeno_client.recalculate_stats()
	xeno_client.mutation_type = LURKER_VAMPIRE
