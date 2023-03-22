/*
//////////////////////////////////////

Confusion

	Little bit hidden.
	Lowers resistance.
	Decreases stage speed.
	Not very transmittable.
	Intense Level.

Bonus
	Makes the affected mob be confused for short periods of time.

//////////////////////////////////////
*/

/datum/symptom/confusion

	name = "Confusion"
	stealth = 1
	resistance = -1
	stage_speed = -3
	transmittable = 0
	level = 4


/datum/symptom/confusion/Activate(datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/carbon/mob = A.affected_mob
		switch(A.stage)
			if(1, 2, 3, 4)
				to_chat(mob, SPAN_NOTICE("[pick("You feel confused.", "You forgot what you were thinking about.")]"))
			else
				to_chat(mob, SPAN_NOTICE("You are unable to think straight!"))
				mob.confused = min(100, mob.confused + 2)

	return
