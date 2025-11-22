/*
//////////////////////////////////////

Hallucinogen

	Very noticeable.
	Lowers resistance considerably.
	Decreases stage speed.
	Reduced transmittable.
	Critical Level.

Bonus
	Makes the affected mob be hallucinated for short periods of time.

//////////////////////////////////////
*/

/datum/symptom/hallucinogen

	name = "Hallucinogen"
	stealth = -2
	resistance = -3
	stage_speed = -3
	transmittable = -1
	level = 5

/datum/symptom/hallucinogen/Activate(datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/carbon/M = A.affected_mob
		switch(A.stage)
			if(1, 2, 3, 4)
				to_chat(M, SPAN_NOTICE("[pick("You notice someone in the corner of your eye.", "Are those footsteps you hear?")]"))
			else
				M.hallucination += 5

	return
