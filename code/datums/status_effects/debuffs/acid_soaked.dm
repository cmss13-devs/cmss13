/datum/status_effect/acid_soaked
	id = "acid_soaked"
	status_type = STATUS_EFFECT_REFRESH
	duration = 2 SECONDS
	tick_interval = 1 SECONDS
	var/damage_per_sec = 10

/datum/status_effect/acid_soaked/New(list/arguments)
	if(!antiheal_overlay)
		antiheal_overlay = icon('icons/mob/hud/hud.dmi', "antiheal")

	if(length(arguments) >= 2)
		damage_per_sec = arguments[2]
	return ..()

/datum/status_effect/acid_soaked/tick(seconds_between_ticks)
	var/mob/living/living = owner
	living.apply_armoured_damage(damage_per_sec * seconds_between_ticks, ARMOR_BIO, BURN)
	living.Slow(2) // Life() removes 1 every 2 seconds so this should be okay
