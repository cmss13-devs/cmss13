/datum/status_effect/stacking/spit_detonation
	id = "spit_detonation"
	stack_decay = 3
	delay_before_decay = 10 SECONDS
	consumed_on_threshold = TRUE
	stack_threshold = 3
	tick_interval = 1 SECONDS
	max_stacks = 3
	refresh_decay_timer_on_stack = FALSE
	var/explosion_damage = 130

/datum/status_effect/stacking/spit_detonation/New(list/arguments)
	if(length(arguments) >= 2)
		explosion_damage = arguments[2]

	return ..()

/datum/status_effect/stacking/spit_detonation/stacks_consumed_effect()
	. = ..()

