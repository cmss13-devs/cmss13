/datum/effects/gain_xeno_cooldown_reduction_on_slash
	effect_name = "xeno_cooldown_reduction_on_slash"
	duration = null
	flags = DEL_ON_DEATH | INF_DURATION
	var/effect_source = null
	var/max_reduction_amount = 0
	var/reduction_amount_per_slash = 0
	var/current_reduction = 0

/datum/effects/gain_xeno_cooldown_reduction_on_slash/New(var/atom/A, var/mob/from = null, var/max_reduction_amount = 0, var/reduction_per_slash = 0, var/duration = 0, var/effect_source = null)
	. = ..(A, from, null, null)

	src.effect_source = effect_source
	src.max_reduction_amount = max_reduction_amount
	src.reduction_amount_per_slash = reduction_per_slash
	RegisterSignal(A, list(
    COMSIG_XENO_ALIEN_ATTACK,
    COMSIG_HUMAN_ALIEN_ATTACK
	), .proc/increase_cooldown_reduction)
	QDEL_IN(src, duration)

/datum/effects/gain_xeno_cooldown_reduction_on_slash/validate_atom(var/atom/A)
	if(isXeno(A))
		return TRUE
	return FALSE

/datum/effects/gain_xeno_cooldown_reduction_on_slash/Destroy()
	if(affected_atom)
		var/mob/living/carbon/Xenomorph/X  = affected_atom
		X.cooldown_reduction_percentage -= current_reduction
		to_chat(X, SPAN_XENOWARNING("You feel your frenzy wanes! Your cooldowns are back to normal."))
		if(X.cooldown_reduction_percentage < 0)
			X.cooldown_reduction_percentage = 0

	return ..()

/datum/effects/gain_xeno_cooldown_reduction_on_slash/proc/increase_cooldown_reduction()
	SIGNAL_HANDLER
	if(affected_atom && current_reduction < max_reduction_amount)
		var/mob/living/carbon/Xenomorph/X  = affected_atom
		var/previous_reduction = current_reduction
		current_reduction = min(current_reduction + reduction_amount_per_slash, max_reduction_amount)
		var/delta = current_reduction - previous_reduction
		X.cooldown_reduction_percentage += delta
