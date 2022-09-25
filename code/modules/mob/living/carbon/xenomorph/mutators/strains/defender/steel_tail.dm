/datum/xeno_mutator/steel_tail
	name = "STRAIN: Defender - Steel Tail"
	description = "You trade some of your armor, health, and base abilities to become a master in zoning and displacement with your mace like tail."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_DEFENDER)
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/onclick/toggle_crest,
		/datum/action/xeno_action/activable/headbutt,
		/datum/action/xeno_action/onclick/tail_sweep,
		/datum/action/xeno_action/activable/fortify,
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/activable/tail_slam,
		/datum/action/xeno_action/activable/tail_swing,
		/datum/action/xeno_action/activable/tail_fling
	)
	keystone = TRUE

/datum/xeno_mutator/steel_tail/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Defender/L = MS.xeno

	L.health_modifier -= XENO_HEALTH_MOD_MEDSMALL
	L.speed += XENO_SPEED_FASTMOD_TIER_5
	L.armor_modifier -= XENO_ARMOR_MOD_SMALL

	mutator_update_actions(L)
	MS.recalculate_actions(description, flavor_description)
	L.recalculate_everything()
	L.mutation_type = DEFENDER_STEEL_TAIL
