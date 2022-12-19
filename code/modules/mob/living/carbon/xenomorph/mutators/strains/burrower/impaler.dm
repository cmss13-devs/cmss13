/datum/xeno_mutator/burrower_impaler
	name = "STRAIN: Burrower - Impaler"
	description = "You mutate your ability to burrow to only work on weeds which allows you to use your tail to attack them from below. You can also fortify on weeds to increase your range, vision, and damage on abilities."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_BURROWER)
	keystone = TRUE
	behavior_delegate_type = /datum/behavior_delegate/burrower_impaler
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/onclick/build_tunnel,
		/datum/action/xeno_action/activable/burrow,
		/datum/action/xeno_action/onclick/tremor,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/activable/place_construction,
		/datum/action/xeno_action/onclick/plant_weeds,
		/datum/action/xeno_action/onclick/place_trap
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/activable/burrowed_spikes,
		/datum/action/xeno_action/activable/sunken_tail,
		/datum/action/xeno_action/onclick/burrow,
		/datum/action/xeno_action/onclick/ensconce
	)

/datum/xeno_mutator/burrower_impaler/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Burrower/B = MS.xeno
	B.mutation_type = BURROWER_IMPALER

	mutator_update_actions(B)
	MS.recalculate_actions(description, flavor_description)

	apply_behavior_holder(B)
	B.recalculate_everything()
	B.acid_level = 0


/datum/behavior_delegate/burrower_impaler
	name = "Impaler Burrower Behavior Delegate"

/datum/behavior_delegate/burrower_impaler/on_update_icons()
	if(bound_xeno.stat == DEAD)
		return

	if(bound_xeno.burrow)
		bound_xeno.icon_state = "[bound_xeno.mutation_type] Burrower Burrowed"
		return TRUE

	if(bound_xeno.fortify)
		bound_xeno.icon_state = "[bound_xeno.mutation_type] Burrower Fortify"
		return TRUE
