/datum/status_effect/stacking/rended_armor
	id = "rended_armor"
	stack_decay = 5
	delay_before_decay = 3 SECONDS
	consumed_on_threshold = FALSE
	alert_type = null
	max_stacks = 5
	var/shred_per_stack = 7
	var/armor_shredded = 0

/datum/status_effect/stacking/rended_armor/add_stacks(stacks_added)
	. = ..()
	if(!owner)
		return

	var/mob/living/carbon/xenomorph/xeno = owner
	xeno.armor_integrity_modifier += armor_shredded
	armor_shredded = stacks * shred_per_stack
	xeno.armor_integrity_modifier -= armor_shredded

/datum/status_effect/stacking/rended_armor/on_remove()
	. = ..()
	var/mob/living/carbon/xenomorph/xeno = owner
	xeno.armor_integrity_modifier += armor_shredded
