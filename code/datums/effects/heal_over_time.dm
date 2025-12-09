/datum/effects/heal_over_time
	effect_name = "heal over time"
	duration = 0
	flags = NO_PROCESS_ON_DEATH | DEL_ON_UNDEFIBBABLE
	var/total_heal_amount = 0
	var/ticks_between_heals = 1
	var/heal_each_process = 0

/datum/effects/heal_over_time/New(atom/A, heal_amount = 0, healing_time = 5, time_between_heals = 1, limb_name = null, show_baloon_alert = FALSE)
	..(A, null, null, limb_name)

	duration = healing_time
	total_heal_amount = heal_amount
	ticks_between_heals = time_between_heals
	heal_each_process = (heal_amount / healing_time) * time_between_heals
	src.show_baloon_alert = show_baloon_alert

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
		if(istype(xeno) && show_baloon_alert)
			xeno.balloon_alert(xeno, "our regen speed returns to normal", text_color = "#17991b80")
			playsound(xeno, 'sound/effects/squish_and_exhaust.ogg', 25, 1)
	return ..()

/datum/effects/heal_over_time/bandages/New(atom/A, heal_amount, healing_time, time_between_heals, limb_name, show_baloon_alert)
	. = ..()
	if(!.)
		return
	RegisterSignal(A, COMSIG_PARENT_EXAMINE, PROC_REF(bandage_check))
	RegisterSignal(A, COMSIG_XENO_TAKE_DAMAGE, PROC_REF(break_heal))

/datum/effects/heal_over_time/bandages/Destroy()
	if(affected_atom)
		UnregisterSignal(affected_atom, list(COMSIG_PARENT_EXAMINE,COMSIG_XENO_TAKE_DAMAGE))
	..()

/datum/effects/heal_over_time/bandages/proc/bandage_check(datum/source, mob/examiner, list/examine_text)
	SIGNAL_HANDLER

	examine_text += "Its injuries are covered in a large amount of bandages."

/datum/effects/heal_over_time/bandages/proc/break_heal(mob/living/carbon/xenomorph/healee, damage_data, damage_type)
	var/datum/effects/heal_over_time/bandages/healing_bandages = locate() in healee
	var/damage = damage_data["damage"]
	if(healing_bandages && prob(damage))
		qdel(healing_bandages)
		healee.visible_message(
			SPAN_WARNING("[healee]'s bandages come undone as it takes damage!"),
			SPAN_WARNING("Your bandages come undone as you take damage, hampering your natural regeneration!"))
		UnregisterSignal(healee, COMSIG_XENO_TAKE_DAMAGE)
	if(!healing_bandages)
		UnregisterSignal(healee, COMSIG_XENO_TAKE_DAMAGE)
