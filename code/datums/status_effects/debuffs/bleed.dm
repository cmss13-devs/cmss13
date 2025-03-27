/datum/status_effect/bleed
	id = "bleed"
	duration = 5 SECONDS
	tick_interval = 1 SECONDS
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null
	var/damage_per_sec = 10
	var/penetration

/datum/status_effect/bleed/on_creation(mob/living/new_owner, dps = 10, penetration)
	. = ..()
	if(.)
		damage_per_sec = dps
		src.penetration = penetration

/datum/status_effect/bleed/tick(seconds_between_ticks)
	. = ..()
	if(!owner)
		return

	var/mob/living/living_owner = owner
	living_owner.apply_armoured_damage(damage_per_sec, ARMOR_MELEE, BRUTE, penetration = penetration)
