/mob/living/is_mob_incapacitated(ignore_restrained)
	// IsKnockdown() here is problematic because we check for this particular status rather than its effects
	// eg. you are incapacitated if knocked down, but not if resting/lying
	// This is probably a logical error that needs straightening out, after which we can use mobility_flags instead
	return (stat || stunned || IsKnockdown() || knocked_out || (!ignore_restrained && is_mob_restrained()))

/* KNOCKDOWN */
/mob/living/proc/IsKnockdown() //If we're knocked down
	return has_status_effect(/datum/status_effect/incapacitating/knockdown)

/mob/living/proc/AmountKnockdown() //How many deciseconds remain in our knockdown
	var/datum/status_effect/incapacitating/knockdown/K = IsKnockdown()
	if(K)
		return K.duration - world.time
	return 0

/mob/living/proc/Knockdown(amount) //Can't go below remaining duration
	amount = get_knockdown_duration(amount)
	var/datum/status_effect/incapacitating/knockdown/K = IsKnockdown()
	if(K)
		K.duration = max(world.time + amount, K.duration)
	else if(amount > 0)
		K = apply_status_effect(/datum/status_effect/incapacitating/knockdown, amount)
	return K

/mob/living/proc/SetKnockdown(amount) //Sets remaining duration
	amount = get_knockdown_duration(amount)
	var/datum/status_effect/incapacitating/knockdown/K = IsKnockdown()
	if(amount <= 0)
		if(K)
			qdel(K)
	else
		if(K)
			K.duration = world.time + amount
		else
			K = apply_status_effect(/datum/status_effect/incapacitating/knockdown, amount)
	return K

/mob/living/proc/AdjustKnockdown(amount, ignore_canstun = FALSE) //Adds to remaining duration
	amount = get_knockdown_duration(amount)
	var/datum/status_effect/incapacitating/knockdown/K = IsKnockdown()
	if(K)
		K.duration += amount
	else if(amount > 0)
		K = apply_status_effect(/datum/status_effect/incapacitating/knockdown, amount)
	return K

/// Returns effective time-duration for a given knockdown value
/mob/living/proc/get_knockdown_duration(base_amount)
	return base_amount / recovery_constant * 10
