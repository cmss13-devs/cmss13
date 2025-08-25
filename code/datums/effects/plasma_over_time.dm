/datum/effects/plasma_over_time
	effect_name = "plasma over time"
	duration = 0
	flags = NO_PROCESS_ON_DEATH | DEL_ON_DEATH
	var/total_plasma_amount = 0
	var/ticks_between_plasmas = 1
	var/plasma_each_process = 0

/datum/effects/plasma_over_time/New(atom/A, plasma_amount = 0, plasma_time = 5, time_between_plasmas = 1)
	..(A, null, null)

	duration = plasma_time
	total_plasma_amount = plasma_amount
	ticks_between_plasmas = time_between_plasmas
	plasma_each_process = (plasma_amount / plasma_time) * time_between_plasmas

/datum/effects/plasma_over_time/validate_atom(atom/A)
	if(!isxeno(A))
		return FALSE
	. = ..()

/datum/effects/plasma_over_time/process_mob()
	. = ..()
	if(!.)
		return FALSE

	if(duration % ticks_between_plasmas)
		return

	var/mob/living/carbon/xenomorph/affected_mob = affected_atom
	affected_mob.gain_plasma(plasma_each_process)

	return TRUE

/datum/effects/plasma_over_time/Destroy()
	if(affected_atom)
		var/mob/living/carbon/xenomorph/xeno = affected_atom
		if(istype(xeno))
			xeno.balloon_alert(xeno, "our plasma rush subsides.", text_color = "#1e6072")
			playsound(xeno, 'sound/effects/squish_and_exhaust.ogg', 25, 1)
	return ..()
