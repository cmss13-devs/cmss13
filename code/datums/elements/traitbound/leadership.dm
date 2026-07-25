/datum/element/traitbound/leadership
	associated_trait = TRAIT_LEADERSHIP
	compatible_types = list(/mob/living/carbon/human)

/datum/element/traitbound/leadership/Attach(datum/target)
	. = ..()
	if(. & ELEMENT_INCOMPATIBLE)
		return
	for(var/action_type in subtypesof(/datum/action/human_action/issue_order))
		give_action(target, action_type)

	give_action(target, /datum/action/human_action/cycle_voice_level)

	var/mob/living/carbon/human/leader = target
	leader.langchat_styles = "langchat_smaller_bolded"

/datum/element/traitbound/leadership/Detach(datum/target)
	var/mob/living/carbon/human/leader = target
	for(var/datum/action/human_action/issue_order/order in leader.actions)
		order.remove_from(leader)

	var/datum/action/human_action/cycle_voice_level/voice = get_action(leader, /datum/action/human_action/cycle_voice_level)
	voice?.remove_from(leader)

	leader.langchat_styles = ""

	return ..()
