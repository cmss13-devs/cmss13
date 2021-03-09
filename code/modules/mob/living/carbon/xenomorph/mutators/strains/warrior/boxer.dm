/datum/xeno_mutator/boxer
	name = "STRAIN: Warrior - Boxer"
	description = "In exchange for your ability to fling and use agility mode, you gain KO meter and ability to resist stuns. Your punches no longer break bones but remove cooldown from Job. Jab lets you close in and confuse your opponents while resetting Punch cooldown. Your slashes and abilities build up KO meter that later let's you deal damage, knockback, heal, and restore your stun resistance depending on how much KO meter you gained."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Warrior")
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/activable/fling,
		/datum/action/xeno_action/activable/lunge,
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/activable/jab,
		/datum/action/xeno_action/activable/uppercut,
	)
	behavior_delegate_type = /datum/behavior_delegate/boxer
	keystone = TRUE

/datum/xeno_mutator/boxer/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Warrior/W = MS.xeno
	W.health_modifier += XENO_HEALTH_MOD_MED
	W.armor_modifier += XENO_ARMOR_MOD_VERYSMALL
	W.agility = FALSE
	W.mutation_type = WARRIOR_BOXER
	apply_behavior_holder(W)
	mutator_update_actions(W)
	MS.recalculate_actions(description, flavor_description)
