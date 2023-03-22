/*
//////////////////////////////////////

Coughing

	Noticable.
	Little Resistance.
	Doesn't increase stage speed much.
	Transmittable.
	Low Level.

BONUS
	Will force the affected mob to drop small items!

//////////////////////////////////////
*/

/datum/symptom/cough

	name = "Cough"
	stealth = -1
	resistance = 3
	stage_speed = 1
	transmittable = 2
	level = 1

/datum/symptom/cough/Activate(datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB))
		var/mob/living/mob = A.affected_mob
		switch(A.stage)
			if(1, 2, 3)
				to_chat(mob, SPAN_NOTICE("[pick("You swallow excess mucus.", "You lightly cough.")]"))
			else
				mob.emote("cough")
				var/obj/item/item = mob.get_active_hand()
				if(item && item.w_class < SIZE_MEDIUM)
					mob.drop_held_item()
	return
