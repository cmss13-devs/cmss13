/datum/status_effect/poisoned
	id = "poisoned"
	duration = 2 SECONDS
	tick_interval = 0.2 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null
	var/damage_per_sec = 10
	var/penetration
	var/mob/living/cause

/datum/status_effect/poisoned/on_creation(mob/living/new_owner, dps = 10, penetration, cause)
	. = ..()
	if(.)
		damage_per_sec = dps
		src.penetration = penetration
		src.cause = cause

/datum/status_effect/poisoned/tick(seconds_between_ticks)
	. = ..()
	if(!owner)
		return

	var/mob/living/living_owner = owner
	living_owner.apply_armoured_damage(damage_per_sec * (seconds_between_ticks / 0.2), ARMOR_BIO, BURN, penetration = penetration)
	SEND_SIGNAL(cause, COMSIG_MOBA_ACID_DAMAGE_DEALT, living_owner)
