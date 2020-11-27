/datum/effects/heal_over_time
	effect_name = "heal over time"
	duration = 0
	flags = NO_PROCESS_ON_DEATH | DEL_ON_UNDEFIBBABLE
	var/total_heal_amount = 0
	var/ticks_between_heals = 1
	var/heal_each_process = 0

/datum/effects/heal_over_time/New(var/atom/A, var/heal_amount = 0, var/healing_time = 5, var/time_between_heals = 1, var/limb_name = null)
	..(A, null, null, limb_name)

	duration = healing_time
	total_heal_amount = heal_amount
	ticks_between_heals = time_between_heals
	heal_each_process = (heal_amount / healing_time) * time_between_heals

/datum/effects/heal_over_time/validate_atom(var/atom/A)
	if(isobj(A))
		return FALSE
	. = ..()

/datum/effects/heal_over_time/process_mob()
	. = ..()
	if(!.)
		return FALSE

	if(duration % ticks_between_heals)
		return

	var/mob/living/carbon/affected_mob = affected_atom
	affected_mob.apply_damage(-heal_each_process, BRUTE, def_zone)

	return TRUE