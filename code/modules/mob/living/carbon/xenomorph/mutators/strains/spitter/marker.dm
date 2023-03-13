/datum/xeno_mutator/marker
	name = "STRAIN: Spitter - Marker"
	description = "You weaken your corrosive acid in exchange an acid that heals nearby sisters on contact with a hostile target, additonally the targets your acid hits will take extra damage and be marked with a yellow outline, you also gain the ability to empower your healing spits by mixing the acid, plasma and resin to create a spit that heals xenos within an area of a targeted turf."
	flavor_description = "Help your sisters fight better."
	cost = MUTATOR_COST_EXPENSIVE
	individual_only = TRUE
	caste_whitelist = list(XENO_CASTE_SPITTER)
	mutator_actions_to_remove = list(
		/datum/action/xeno_action/onclick/charge_spit,
		/datum/action/xeno_action/activable/spray_acid/spitter,
	)
	mutator_actions_to_add = list(
		/datum/action/xeno_action/onclick/healing_surge,
	)
	keystone = TRUE

	behavior_delegate_type = /datum/behavior_delegate

/datum/xeno_mutator/marker/apply_mutator(datum/mutator_set/individual_mutators/marker)
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/xenomorph/spitter/marker_strain = marker.xeno
	marker_strain.mutation_type = SPITTER_MARKER
	marker_strain.ammo = GLOB.ammo_list[/datum/ammo/xeno/acid/marking]
	apply_behavior_holder(marker_strain)
	mutator_update_actions(marker_strain)
	marker_strain.recalculate_actions(description, flavor_description)

/datum/behavior_delegate/ranged_attack_on_hit()
	. = ..()

