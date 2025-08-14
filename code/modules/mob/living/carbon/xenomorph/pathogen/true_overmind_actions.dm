/datum/action/xeno_action/onclick/return_to_core
	name = "Return to Core"
	action_icon_state = "retrieve"

/datum/action/xeno_action/onclick/return_to_core/action_activate()
	SEND_SIGNAL(owner, COMSIG_XENOMORPH_CORE_RETURN)
	return ..()

/datum/action/xeno_action/onclick/change_form
	name = "Change form"
	action_icon_state = "manifest"

/datum/action/xeno_action/onclick/change_form/can_use_action(silent = FALSE, override_flags)
	var/mob/living/carbon/xenomorph/overmind = owner
	if(overmind && (overmind.status_flags & INCORPOREAL) && (overmind.health != overmind.maxHealth))
		return FALSE
	return ..()

/datum/action/xeno_action/onclick/change_form/action_activate()
	var/mob/living/carbon/xenomorph/overmind/overmind = owner
	overmind.change_form()
	return ..()

/datum/action/xeno_action/onclick/emit_pheromones/overmind/can_use_action(silent = FALSE, override_flags)
	if(owner?.status_flags & INCORPOREAL)
		return FALSE
	return ..()


/datum/action/xeno_action/watch_xeno/overmind/can_use_action(silent = FALSE, override_flags)
	var/mob/living/carbon/xenomorph/overmind/overmind = owner
	if(overmind && !COOLDOWN_FINISHED(overmind, cooldown_hivemind_manifestation))
		return FALSE
	return ..()

/*
/datum/action/xeno_action/watch_xeno/overmind/on_list_xeno_selection(datum/source, mob/living/carbon/xenomorph/selected_xeno)
	if(!can_use_action())
		return
	var/mob/living/carbon/xenomorph/overmind/overmind = source
	overmind.jump(selected_xeno)
*/
