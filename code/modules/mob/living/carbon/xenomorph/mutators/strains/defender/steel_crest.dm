/datum/xeno_mutator/steel_crest
	name = "STRAIN: Defender - Steel Crest"
	description = "You trade a small amount of your already weak damage and your tail swipe for slightly increased headbutt knockback and damage, and the ability to slowly move and headbutt while fortified."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_DEFENDER)
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/onclick/tail_sweep,
	)
	keystone = TRUE

/datum/xeno_mutator/steel_crest/apply_mutator(datum/mutator_set/individual_mutators/mutator_set)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Defender/defender = mutator_set.xeno
	defender.mutation_type = DEFENDER_STEELCREST
	defender.mutation_icon_state = DEFENDER_STEELCREST
	defender.damage_modifier -= XENO_DAMAGE_MOD_VERYSMALL
	var/datum/behavior_delegate/defender_base/defender_delegate = defender.behavior_delegate
	defender_delegate.steelcrest_strain = TRUE
	mutator_update_actions(defender)
	mutator_set.recalculate_actions(description, flavor_description)
	defender.recalculate_stats()
