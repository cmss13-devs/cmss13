/*
//////////////////////////////////////

Fever

	No change to hidden.
	Increases resistance.
	Increases stage speed.
	Little transmittable.
	Low level.

Bonus
	Heats up your body.

//////////////////////////////////////
*/

/datum/symptom/fever

	name = "Fever"
	stealth = 0
	resistance = 3
	stage_speed = 3
	transmittable = 2
	level = 2

/datum/symptom/fever/Activate(datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/carbon/mob = A.affected_mob
		var/message = "[pick("You feel hot.", "You feel like you're burning.")]"
		to_chat(mob, SPAN_NOTICE(message))
		if(mob.bodytemperature < BODYTEMP_HEAT_DAMAGE_LIMIT)
			mob.bodytemperature = min(mob.bodytemperature + (20 * A.stage), BODYTEMP_HEAT_DAMAGE_LIMIT - 1)
			mob.recalculate_move_delay = TRUE

	return
