/datum/status_effect/stacking/bleed
	id = "bleed"
	stack_decay = 10
	delay_before_decay = 5 SECONDS
	consumed_on_threshold = FALSE
	tick_interval = 1 SECONDS
	alert_type = null
	max_stacks = 10
	var/damage_per_stack_per_sec = 5

/datum/status_effect/stacking/bleed/on_creation(mob/living/new_owner, stacks_to_apply, dps = 5)
	. = ..()
	if(.)
		damage_per_stack_per_sec = dps

/datum/status_effect/stacking/bleed/tick(seconds_between_ticks)
	. = ..()
	if(!owner)
		return

	var/mob/living/living_owner = owner
	living_owner.apply_armoured_damage(stacks * damage_per_stack_per_sec, ARMOR_MELEE, BRUTE)
