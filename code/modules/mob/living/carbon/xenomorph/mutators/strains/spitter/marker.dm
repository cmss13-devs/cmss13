/datum/xeno_mutator/marker
	name = "STRAIN: Spitter - Marker"
	description = "You weaken your corrosive acid for pheremones to support your sisters and acid to weaken your foes"
	flavor_description = "Help your sisters fight better"
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_SPITTER)
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/onclick/charge_spit,
		/datum/action/xeno_action/activable/spray_acid/spitter,
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/activable/xeno_spit/,
		/datum/action/xeno_action/onclick/toggle_long_range/marker
	)
	keystone = TRUE

	behavior_delegate_type = /datum/behavior_delegate/marker_spitter

/datum/xeno_mutator/marker/apply_mutator(datum/mutator_set/individual_mutators/MS)
	. = ..()
	if(. == 0)
		return

	var/mob/living/carbon/Xenomorph/Spitter/I = MS.xeno
	I.mutation_type = SPITTER_MARKER
	I.ammo = GLOB.ammo_list[/datum/ammo/xeno/acid/marking]
	I.viewsize = 16
	apply_behavior_holder(I)
	mutator_update_actions(I)
	MS.recalculate_actions(description, flavor_description)

/datum/behavior_delegate/marker_spitter
	name = "Marker Spitter Behavior Delegate"

/datum/behavior_delegate/marker_spitter/ranged_attack_on_hit()
	. = ..()

