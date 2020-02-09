/datum/xeno_mutator/royal_guard
	name = "STRAIN: Praetorian - Royal Guard"
	description = "You gain better pheromones, more damage, tail sweep, and another way to acid spray together with a lower activation time. Your screech now increases your sister's strength in combat."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list("Praetorian") //Only praetorian.
	mutator_actions_to_remove = list("Xeno Spit","Toggle Spit Type", "Spray Acid")
	mutator_actions_to_add = list(/datum/action/xeno_action/activable/tail_sweep, /datum/action/xeno_action/activable/prae_spray_acid, /datum/action/xeno_action/prae_switch_spray_type)
	keystone = TRUE

/datum/xeno_mutator/royal_guard/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if (. == 0)
		return

	var/mob/living/carbon/Xenomorph/Praetorian/P = MS.xeno
	P.mutation_type = PRAETORIAN_ROYALGUARD
	P.acid_spray_activation_time = 0
	P.phero_modifier += XENO_PHERO_MOD_LARGE
	P.armor_modifier -= XENO_ARMOR_MOD_VERYSMALL
	P.health_modifier -= XENO_HEALTH_MOD_SMALL
	mutator_update_actions(P)
	MS.recalculate_actions(description)
	P.recalculate_everything()
