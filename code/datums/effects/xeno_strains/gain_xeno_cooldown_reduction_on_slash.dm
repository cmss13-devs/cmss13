/datum/effects/gain_xeno_cooldown_reduction_on_slash
	effect_name = "xeno_cooldown_reduction_on_slash"
	duration = null
	flags = DEL_ON_DEATH | INF_DURATION
	var/effect_source = null
	var/max_reduction_amount = 0
	var/reduction_amount_per_slash = 0
	var/current_reduction = 0

/datum/effects/gain_xeno_cooldown_reduction_on_slash/New(atom/A, mob/from = null, max_reduction_amount = 0, reduction_per_slash = 0, duration = 0, effect_source = null)
	. = ..(A, from, null, null)

	src.effect_source = effect_source
	src.max_reduction_amount = max_reduction_amount
	src.reduction_amount_per_slash = reduction_per_slash
	RegisterSignal(A, list(
	COMSIG_XENO_ALIEN_ATTACK,
	COMSIG_HUMAN_ALIEN_ATTACK
	), PROC_REF(increase_cooldown_reduction))
	QDEL_IN(src, duration)

/datum/effects/gain_xeno_cooldown_reduction_on_slash/validate_atom(atom/A)
	if(isxeno(A))
		return TRUE
	return FALSE

/datum/effects/gain_xeno_cooldown_reduction_on_slash/Destroy()
	if(affected_atom)
		var/mob/living/carbon/xenomorph/xeno  = affected_atom
		xeno.cooldown_reduction_percentage -= current_reduction
		to_chat(xeno, SPAN_XENOWARNING("We feel our frenzy wane! Our cooldowns are back to normal."))
		xeno.balloon_alert(xeno, "we feel our frenzy wane!", text_color = "#99461780")
		playsound(xeno, 'sound/effects/squish_and_exhaust.ogg', 25, 1)
		if(xeno.cooldown_reduction_percentage < 0)
			xeno.cooldown_reduction_percentage = 0

	return ..()

/datum/effects/gain_xeno_cooldown_reduction_on_slash/proc/increase_cooldown_reduction()
	SIGNAL_HANDLER
	if(affected_atom && current_reduction < max_reduction_amount)
		var/mob/living/carbon/xenomorph/xeno  = affected_atom
		var/previous_reduction = current_reduction
		current_reduction = min(current_reduction + reduction_amount_per_slash, max_reduction_amount)
		var/delta = current_reduction - previous_reduction
		xeno.cooldown_reduction_percentage += delta
