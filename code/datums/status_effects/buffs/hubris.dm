/datum/status_effect/hubris
	id = "hubris"
	status_type = STATUS_EFFECT_REPLACE
	duration = 90 SECONDS
	alert_type = null
	var/damage_to_add = 10

/datum/status_effect/hubris/on_creation(mob/living/new_owner, damage_to_add = 10)
	. = ..()
	if(.)
		src.damage_to_add = damage_to_add

/datum/status_effect/hubris/on_apply()
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/xenomorph/target = owner
	to_chat(target, SPAN_XENO("With another kill, our prowess grows to now grant us [damage_to_add] extra slash damage."))
	target.melee_damage_lower += damage_to_add
	target.melee_damage_upper += damage_to_add

/datum/status_effect/hubris/on_remove()
	var/mob/living/carbon/xenomorph/target = owner
	to_chat(target, SPAN_XENO("We feel less confident, our damage waning by [damage_to_add]."))
	target.melee_damage_lower -= damage_to_add
	target.melee_damage_upper -= damage_to_add

	return ..()
