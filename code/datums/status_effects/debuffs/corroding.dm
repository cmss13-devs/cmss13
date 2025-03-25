/datum/status_effect/corroding
	id = "corroding"
	status_type = STATUS_EFFECT_REFRESH
	duration = 3 SECONDS
	tick_interval = 1 SECONDS
	var/max_health_percent = 0.025

/datum/status_effect/corroding/on_creation(mob/living/new_owner, mhp = 0.025)
	. = ..()
	if(.)
		max_health_percent = mhp

/datum/status_effect/corroding/tick(seconds_between_ticks)
	var/mob/living/living = owner
	living.apply_armoured_damage(living.getMaxHealth() * max_health_percent * seconds_between_ticks, ARMOR_BIO, BURN)
