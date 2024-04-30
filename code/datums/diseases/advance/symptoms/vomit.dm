/*
//////////////////////////////////////

Vomiting

	Very Very Noticeable.
	Decreases resistance.
	Doesn't increase stage speed.
	Little transmittable.
	Medium Level.

Bonus
	Forces the affected mob to vomit!
	Meaning your disease can spread via
	people walking on vomit.
	Makes the affected mob lose nutrition and
	heal toxin damage.

//////////////////////////////////////
*/

/datum/symptom/vomit

	name = "Vomiting"
	stealth = -2
	resistance = -1
	stage_speed = 0
	transmittable = 1
	level = 3

/datum/symptom/vomit/Activate(datum/disease/advance/A)
	..()
	if(prob(SYMPTOM_ACTIVATION_PROB / 2))
		var/mob/living/M = A.affected_mob
		switch(A.stage)
			if(1, 2, 3, 4)
				var/message = "[pick("You feel nauseous.", "You feel like you're going to throw up!")]"
				message = SPAN_NOTICE("[message]")
				to_chat(M, message)
			else
				Vomit(M)

	return

/datum/symptom/vomit/proc/Vomit(mob/living/M)
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		H.vomit_on_floor()
/*
//////////////////////////////////////

Vomiting Blood

	Very Very Noticeable.
	Decreases resistance.
	Decreases stage speed.
	Little transmittable.
	Intense level.

Bonus
	Forces the affected mob to vomit blood!
	Meaning your disease can spread via
	people walking on the blood.
	Makes the affected mob lose health.

//////////////////////////////////////
*/

/datum/symptom/vomit/blood

	name = "Blood Vomiting"
	stealth = -2
	resistance = -1
	stage_speed = -1
	transmittable = 1
	level = 4

/datum/symptom/vomit/blood/Vomit(mob/living/M)

	M.apply_effect(1, STUN)
	M.visible_message("<B>[M]</B> vomits on the floor!")

	// They lose blood and health.
	var/brute_dam = M.getBruteLoss()
	if(brute_dam < 50)
		M.apply_damage(3, BRUTE)

	var/turf/pos = get_turf(M)
	M.add_splatter_floor(pos)
	playsound(pos, 'sound/effects/splat.ogg', 25, 1)
