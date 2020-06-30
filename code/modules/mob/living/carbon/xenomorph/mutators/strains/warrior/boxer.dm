/datum/xeno_mutator/boxer
	name = "STRAIN: Warrior - Boxer"
	description = "In exchange for your ability to fling, you gain the ability to Jab. Your punches no longer break bones, but they do more damage and confuse your enemies. Jab knocks down your target for a very short time, while also pulling you out of agility mode and refreshing your Punch cooldown."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Warrior")
	mutator_actions_to_remove = list("Fling","Lunge")
	mutator_actions_to_add = list(/datum/action/xeno_action/activable/jab, /datum/action/xeno_action/onclick/toggle_agility)
	keystone = TRUE

/datum/xeno_mutator/boxer/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Warrior/W = MS.xeno
	W.mutation_type = WARRIOR_BOXER
	mutator_update_actions(W)
	MS.recalculate_actions(description, flavor_description)