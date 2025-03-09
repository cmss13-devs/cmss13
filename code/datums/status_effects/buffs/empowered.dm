/datum/status_effect/empowered
	id = "empowered"
	status_type = STATUS_EFFECT_REFRESH
	duration = 3 SECONDS
	alert_type = /atom/movable/screen/alert/status_effect/empowered
	var/speed_buff
	var/attack_delay_buff

/datum/status_effect/empowered/New(list/arglist)
	speed_buff = arglist[2]
	attack_delay_buff = arglist[3]
	return ..() //ugh

/datum/status_effect/empowered/on_apply()
	. = ..()
	if(!.)
		return

	var/mob/living/carbon/xenomorph/target = owner
	to_chat(target, SPAN_XENO("We feel empowered!"))
	target.ability_speed_modifier += speed_buff
	target.attack_speed_modifier += attack_delay_buff

/datum/status_effect/empowered/on_remove()
	var/mob/living/carbon/xenomorph/target = owner
	to_chat(target, SPAN_XENO("We feel our strength wane."))
	target.ability_speed_modifier -= speed_buff
	target.attack_speed_modifier -= attack_delay_buff

	return ..()

/atom/movable/screen/alert/status_effect/empowered
	name = "Empowered"
	desc = "You feel faster!"
	icon_state = ALERT_FLOORED
