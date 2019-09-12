/datum/xeno_mutator/vomiter 
	name = "STRAIN: Spitter - Vomiter"
	description = "In exchange for your ability to spit, you gain the ability to spray a weaker variant of acid spray that does not stun, but still damages."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Spitter") 
	mutator_actions_to_remove = list("Toggle Spit Type", "Xeno Spit")
	mutator_actions_to_add = list (/datum/action/xeno_action/activable/spray_acid)
	keystone = TRUE

/datum/xeno_mutator/vomiter/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return
	
	var/mob/living/carbon/Xenomorph/Spitter/S = MS.xeno
	S.mutation_type = SPITTER_VOMITER
	S.plasma_types -= PLASMA_NEUROTOXIN
	mutator_update_actions(S)
	MS.recalculate_actions(description)
