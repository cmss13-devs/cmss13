// Vanguard shields rapidly decay after the first hit.
/datum/xeno_shield/vanguard
	var/hit_yet = FALSE
	var/explosive_armor_amount = XENO_EXPOSIVEARMOR_MOD_VERY_LARGE
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
	if (linked_xeno)
		linked_xeno.explosivearmor_modifier -= explosive_armor_amount
		linked_xeno.recalculate_armor()

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
		sleep(0.4 SECONDS)

	if (amount <= 0)
		if (linked_xeno)
			if (QDELETED(linked_xeno) || !istype(linked_xeno))
				return

			linked_xeno.overlay_shields()
			var/datum/action/xeno_action/activable/cleave/cAction = get_action(linked_xeno, /datum/action/xeno_action/activable/cleave)
			if (istype(cAction))
				addtimer(CALLBACK(cAction, TYPE_PROC_REF(/datum/action/xeno_action/activable/cleave, remove_buff)), 7, TIMER_UNIQUE)

/datum/xeno_shield/vanguard/proc/notify_xeno()
	if (!istype(linked_xeno))
		return

	var/datum/behavior_delegate/praetorian_vanguard/behavior = linked_xeno.behavior_delegate
	if (istype(behavior))
		behavior.last_combat_time = world.time
