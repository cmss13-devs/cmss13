/datum/xeno_mutator/marker
	name = "STRAIN: Spitter - Marker"
	description = "You weaken your corrosive acid for acidic fumes to support your sisters and acid to weaken your foes"
	flavor_description = "Help your sisters fight better"
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_SPITTER)
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/onclick/charge_spit,
		/datum/action/xeno_action/activable/spray_acid/spitter,
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/onclick/toggle_long_range/marker
	)
	keystone = TRUE

	behavior_delegate_type = /datum/behavior_delegate

/datum/xeno_mutator/marker/apply_mutator(datum/mutator_set/individual_mutators/Marker)
	. = ..()
	if(. == FALSE)
		return

	var/mob/living/carbon/xenomorph/spitter/MarkerStrain = Marker.xeno
	MarkerStrain.mutation_type = SPITTER_MARKER
	MarkerStrain.ammo = GLOB.ammo_list[/datum/ammo/xeno/acid/marking]
	MarkerStrain.viewsize = 16
	apply_behavior_holder(MarkerStrain)
	mutator_update_actions(MarkerStrain)
	MarkerStrain.recalculate_actions(description, flavor_description)

/datum/behavior_delegate/ranged_attack_on_hit()
	. = ..()

