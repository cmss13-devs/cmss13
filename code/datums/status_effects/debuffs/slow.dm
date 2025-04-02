//SLOWED
/datum/status_effect/slow
	id = "slow"
	status_type = STATUS_EFFECT_MULTIPLE
	alert_type = null
	var/speed_debuff

/datum/status_effect/slow/New(list/arglist)
	speed_debuff = arglist[2]
	duration = arglist[3]
	return ..()

/datum/status_effect/slow/on_apply()
	. = ..()
	if(!owner)
		return

	var/mob/living/carbon/xenomorph/target = owner
	target.ability_speed_modifier += speed_debuff

/datum/status_effect/slow/on_remove()
	var/mob/living/carbon/xenomorph/target = owner
	target.ability_speed_modifier -= speed_debuff
	return ..()

/datum/status_effect/slow/refresh
	id = "slow_refresh"
	status_type = STATUS_EFFECT_REFRESH
