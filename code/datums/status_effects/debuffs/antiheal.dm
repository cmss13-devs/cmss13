/datum/status_effect/antiheal
	id = "antiheal"
	status_type = STATUS_EFFECT_REFRESH
	duration = 5 SECONDS
	alert_type = null
	var/healing_reduction = 0.4
	var/static/icon/antiheal_overlay

/datum/status_effect/antiheal/New(list/arguments)
	if(!antiheal_overlay)
		antiheal_overlay = icon('icons/mob/hud/hud.dmi', "antiheal")
	return ..()

/datum/status_effect/antiheal/on_creation(mob/living/new_owner, healing_reduction = 0.4, duration = 5 SECONDS)
	src.healing_reduction = healing_reduction
	src.duration = duration
	return ..()

/datum/status_effect/antiheal/on_apply()
	. = ..()
	RegisterSignal(owner, COMSIG_XENO_ON_HEAL, PROC_REF(on_heal))
	owner.overlays += antiheal_overlay

/datum/status_effect/antiheal/on_remove()
	. = ..()
	UnregisterSignal(owner, COMSIG_XENO_ON_HEAL)
	owner.overlays -= antiheal_overlay

/datum/status_effect/antiheal/proc/on_heal(datum/source, list/arglist)
	SIGNAL_HANDLER

	arglist["healing"] *= (1 - healing_reduction)
