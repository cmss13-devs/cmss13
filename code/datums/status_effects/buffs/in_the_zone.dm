/datum/status_effect/in_the_zone
	id = "in_the_zone"
	status_type = STATUS_EFFECT_REFRESH
	alert_type = null
	var/evasion_chance
	var/speed_bonus

/datum/status_effect/in_the_zone/New(list/arguments)
	evasion_chance = arguments[2]
	speed_bonus = arguments[3]
	duration = arguments[4]
	return ..()

/datum/status_effect/in_the_zone/on_apply()
	. = ..()
	if(!owner)
		return

	owner.add_filter("in_the_zone", 1, gauss_blur_filter(0))
	animate(owner.get_filter("in_the_zone"), size = 2, time = 0.5 SECONDS, easing = BOUNCE_EASING) // slightly wobbly
	playsound(owner.loc, prob(95) ? 'sound/effects/xeno_newlarva.ogg' : 'sound/vehicles/box_van_overdrive.ogg', 100, FALSE)

	if(!isxeno(owner))
		return

	var/mob/living/carbon/xenomorph/runner = owner
	runner.slash_evasion += evasion_chance
	runner.ability_speed_modifier += speed_bonus

/datum/status_effect/in_the_zone/on_remove()
	. = ..()
	animate(owner.get_filter("in_the_zone"), size = 0, time = 0.5 SECONDS)
	playsound(owner.loc, "alien_growl", 50, FALSE)

	var/mob/living/carbon/xenomorph/runner = owner
	runner.slash_evasion -= evasion_chance
	runner.ability_speed_modifier -= speed_bonus
