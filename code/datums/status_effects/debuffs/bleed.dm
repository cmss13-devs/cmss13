/datum/status_effect/stacking/bleed
	id = "bleed"
	stack_decay = 10
	delay_before_decay = 5 SECONDS
	consumed_on_threshold = FALSE
	tick_interval = 1 SECONDS
	alert_type = null
	max_stacks = 10
	var/damage_per_stack_per_sec = 5

/datum/status_effect/stacking/bleed/New(list/arguments)
	if(length(arguments) >= 2)
		damage_per_stack_per_sec = arguments[2]

	return ..()

/datum/status_effect/stacking/bleed/tick(seconds_between_ticks)
	. = ..()
	var/mob/living/living_owner = owner
	living_owner.take_overall_damage(damage_per_stack_per_sec * stacks)
