/datum/element/traitbound/leadership
	associated_trait = TRAIT_LEADERSHIP
	compatible_types = list(/mob/living/carbon/human)

/datum/element/traitbound/leadership/Attach(datum/target)
	. = ..()
	if(. & ELEMENT_INCOMPATIBLE)
		return
	for(var/action_type in subtypesof(/datum/action/human_action/issue_order))
		give_action(target, action_type)

/datum/element/traitbound/leadership/Detach(datum/target)
	var/mob/living/carbon/human/human = target
	for(var/datum/action/human_action/issue_order/order in human.actions)
		order.remove_from(human)
	return ..()
