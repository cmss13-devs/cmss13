#define XENO_DEEVOLVE_COOLDOWN 5 MINUTES

/**
 * A component that should be on all xenos that should be prevented from de-evolution manipulation.
 */
/datum/component/deevolve_cooldown
	/// The xeno that we are bound to
	var/mob/living/carbon/xenomorph/parent_xeno
	/// Assoc list of caste define to timerid of recent de-evolves this xeno has performed that are still on cooldown
	var/list/deevolves_on_cooldown = list()

/datum/component/deevolve_cooldown/Initialize(mob/living/carbon/xenomorph/old_xeno)
	parent_xeno = parent
	if(!istype(parent_xeno))
		return COMPONENT_INCOMPATIBLE
	var/datum/component/deevolve_cooldown/old_component = old_xeno?.GetComponent(/datum/component/deevolve_cooldown)
	if(old_component)
		deevolves_on_cooldown = old_component.deevolves_on_cooldown

/datum/component/deevolve_cooldown/RegisterWithParent()
	RegisterSignal(parent_xeno, COMSIG_XENO_DEEVOLVE, PROC_REF(on_deevolve))
	RegisterSignal(parent_xeno, COMSIG_XENO_TRY_EVOLVE, PROC_REF(on_try_evolve))

/datum/component/deevolve_cooldown/UnregisterFromParent()
	UnregisterSignal(parent_xeno, list(COMSIG_XENO_DEEVOLVE, COMSIG_XENO_TRY_EVOLVE))

/// Signal handler for COMSIG_XENO_DEEVOLVE to add the current xeno as a de-evolution
/datum/component/deevolve_cooldown/proc/on_deevolve()
	deevolves_on_cooldown[parent_xeno.caste_type] = addtimer(VARSET_LIST_REMOVE_CALLBACK(deevolves_on_cooldown, "[parent_xeno.caste_type]"), XENO_DEEVOLVE_COOLDOWN, TIMER_STOPPABLE)
	return

/// Signal handler for COMSIG_XENO_TRY_EVOLVE to determine is the evolution is allowed
/datum/component/deevolve_cooldown/proc/on_try_evolve(mob/living/carbon/xenomorph/old_xeno, castepick)
	var/on_cooldown_timer = deevolves_on_cooldown[castepick]
	if(on_cooldown_timer)
		to_chat(old_xeno, SPAN_WARNING("We cannot evolve into this caste again yet! ([DisplayTimeText(timeleft(on_cooldown_timer), 1)] remaining)"))
		return COMPONENT_OVERRIDE_EVOLVE
	return FALSE
