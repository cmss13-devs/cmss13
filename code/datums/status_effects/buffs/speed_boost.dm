/datum/status_effect/speed_boost
	id = "speed_boost"
	status_type = STATUS_EFFECT_REPLACE
	duration = -1
	alert_type = null
	var/speedboost_value

/datum/status_effect/speed_boost/on_creation(mob/living/new_owner, speedboost_value)
	src.speedboost_value = speedboost_value
	return ..()

/datum/status_effect/speed_boost/on_apply()
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/xenomorph/target = owner
	target.ability_speed_modifier += speedboost_value

/datum/status_effect/speed_boost/on_remove()
	var/mob/living/carbon/xenomorph/target = owner
	target.ability_speed_modifier -= speedboost_value
	return ..()
