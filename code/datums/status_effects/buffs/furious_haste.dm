/datum/status_effect/stacking/furious_haste
	id = "furious_haste"
	stack_decay = 4
	delay_before_decay = 4 SECONDS
	consumed_on_threshold = FALSE
	alert_type = null
	max_stacks = 4
	var/movespeed_per_stack = 0.25
	var/movespeed_granted = 0

/datum/status_effect/stacking/furious_haste/add_stacks(stacks_added)
	. = ..()
	if(!owner)
		return

	var/mob/living/carbon/xenomorph/xeno = owner
	xeno.ability_speed_modifier -= movespeed_granted
	movespeed_granted = stacks * movespeed_per_stack
	xeno.ability_speed_modifier += movespeed_granted

/datum/status_effect/stacking/furious_haste/on_remove()
	. = ..()
	var/mob/living/carbon/xenomorph/xeno = owner
	xeno.ability_speed_modifier -= movespeed_granted
