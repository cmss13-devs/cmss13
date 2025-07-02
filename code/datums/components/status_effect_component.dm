//exists only to handle immunities for now

/datum/component/status_effect
	var/has_immunity = FALSE
	var/grace_period = 30

/datum/component/status_effect/InheritComponent(datum/component/C, i_am_original)
	if(has_immunity)
		grace_period = min(grace_period + 1, initial(grace_period))

/datum/component/status_effect/Initialize()
	. = ..()
	RegisterSignal(parent, list(COMSIG_XENO_DEBUFF_CLEANSE, COMSIG_LIVING_REJUVENATED), PROC_REF(cleanse))

/datum/component/status_effect/proc/cleanse()
	SIGNAL_HANDLER
	has_immunity = TRUE

/datum/component/status_effect/process(delta_time)
	if(has_immunity)
		grace_period -= 1 * delta_time
		if(grace_period <= 0)
			qdel(src)
