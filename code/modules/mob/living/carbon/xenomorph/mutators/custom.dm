/datum/xeno_mutator/custom
	individual_only = TRUE
	keystone = TRUE
	/// Allows for multiple passives at once, probably going to break
	var/list/behavior_delegate_types = list()
	///Custom properties list

/datum/xeno_mutator/custom/apply_mutator(datum/mutator_set/individual_mutators/mutator_set)
	. = ..()
	if (!.)
		return

	var/mob/living/carbon/xenomorph/owner = mutator_set.xeno
	//Apply all the custom properties
	mutator_update_actions(owner)
	mutator_set.recalculate_actions(description, flavor_description)
	//Iterate and apply every passive
	//apply_behavior_holder(ravager)

	owner.recalculate_everything()
