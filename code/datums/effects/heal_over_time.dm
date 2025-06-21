/datum/effects/heal_over_time
	effect_name = "heal over time"
	duration = 0
	flags = NO_PROCESS_ON_DEATH | DEL_ON_UNDEFIBBABLE
	var/total_heal_amount = 0
	var/ticks_between_heals = 1
	var/heal_each_process = 0

/datum/effects/heal_over_time/New(atom/A, heal_amount = 0, healing_time = 5, time_between_heals = 1, limb_name = null)
	..(A, null, null, limb_name)

	duration = healing_time
	total_heal_amount = heal_amount
	ticks_between_heals = time_between_heals
	heal_each_process = (heal_amount / healing_time) * time_between_heals

/datum/effects/heal_over_time/validate_atom(atom/A)
	if(isobj(A))
		return FALSE
	. = ..()

/datum/effects/heal_over_time/process_mob()
	. = ..()
	if(!.)
		return FALSE

	if(duration % ticks_between_heals)
		return

	var/mob/living/carbon/xenomorph/affected_mob = affected_atom
	affected_mob.gain_health(heal_each_process)
	affected_mob.updatehealth()

	return TRUE

/datum/effects/heal_over_time/Destroy()
	if(affected_atom)
		var/mob/living/carbon/xenomorph/xeno = affected_atom
		if(istype(xeno))
			xeno.balloon_alert(xeno, "our regeneration speed returns to normal.", text_color = "#17991b80")
			playsound(xeno, 'sound/effects/squish_and_exhaust.ogg', 25, 1)
	return ..()
