//exists only to handle immunities for now

/datum/component/status_effect
	var/has_immunity = FALSE
	var/grace_period = 20

/datum/component/status_effect/proc/cleanse()
	has_immunity = TRUE

/datum/component/status_effect/process(delta_time)
	if(has_immunity)
		grace_period -= 1 * delta_time
		if(grace_period <= 0)
			RemoveComponent()
