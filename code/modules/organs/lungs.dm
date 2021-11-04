/datum/internal_organ/lungs
	name = "lungs"
	removed_type = /obj/item/organ/lungs
	robotic_type = /obj/item/organ/lungs/prosthetic
	organ_tag = ORGAN_LUNGS

/*
/datum/internal_organ/lungs/process()
	..()
	if(owner.chem_effect_flags & CHEM_EFFECT_ORGAN_STASIS)
		return
	if(is_bruised())
		if(prob(2))
			spawn owner.emote("me", 1, "coughs up blood!")
			owner.drip(10)
		if(prob(4))
			spawn owner.emote("me", 1, "gasps for air!")
			owner.losebreath += 15

/datum/internal_organ/lungs/rejuvenate()
	owner.losebreath = 0
	..()

*/

/datum/internal_organ/lungs/prosthetic
	robotic = ORGAN_ROBOT
	removed_type = /obj/item/organ/lungs/prosthetic
