
// Vanguard shields rapidly decay after the first hit.
/datum/xeno_shield/vanguard
	var/hit_yet = FALSE
	var/explosive_armor_amount = XENO_EXPOSIVEARMOR_MOD_VERYLARGE
	amount = 800


/datum/xeno_shield/vanguard/on_hit(damage)
	notify_xeno()

	if (!hit_yet)
		hit_yet = TRUE
		rapid_decay()
		return 0
	else
		return ..(damage)

/datum/xeno_shield/vanguard/Destroy()
	if (linked_xeno && istype(linked_xeno, /mob/living/carbon/Xenomorph))
		var/mob/living/carbon/Xenomorph/X = linked_xeno
		X.explosivearmor_modifier -= explosive_armor_amount
		X.recalculate_armor()

	return ..()

/// Decay is suppressed for Vanguard Shield and triggered on hit
/datum/xeno_shield/vanguard/begin_decay()
	return // Don't process us
/datum/xeno_shield/vanguard/process()
	return PROCESS_KILL // REALLY, don't process us!

/datum/xeno_shield/vanguard/proc/rapid_decay()
	set waitfor = 0
	while(amount > 0)
		amount *= 0.70
		amount -= 50

		notify_xeno()
		sleep(1)

	if (amount <= 0)
		if (linked_xeno && istype(linked_xeno, /mob/living/carbon/Xenomorph))
			var/mob/living/carbon/Xenomorph/X = linked_xeno

			if (QDELETED(X) || !istype(X))
				return

			qdel(src)
			X.overlay_shields()

			var/datum/action/xeno_action/activable/cleave/cAction = get_xeno_action_by_type(linked_xeno, /datum/action/xeno_action/activable/cleave)
			if (istype(cAction))
				addtimer(CALLBACK(cAction, /datum/action/xeno_action/activable/cleave.proc/remove_buff), 7, TIMER_UNIQUE)

/datum/xeno_shield/vanguard/proc/notify_xeno()
	var/mob/living/carbon/Xenomorph/X = linked_xeno
	if (!istype(X))
		return

	if (X.mutation_type == PRAETORIAN_VANGUARD)
		var/datum/behavior_delegate/praetorian_vanguard/BD = X.behavior_delegate
		if (istype(BD))
			BD.last_combat_time = world.time
