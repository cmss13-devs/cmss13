/datum/internal_organ/kidneys
	name = "kidneys"
	removed_type = /obj/item/organ/kidneys
	robotic_type = /obj/item/organ/kidneys/prosthetic
	organ_tag = ORGAN_KIDNEYS

/datum/internal_organ/kidneys/on_malfunction(trait_source)
	..()
	owner.xeno_neurotoxin_buff += 1.5

/*
/datum/internal_organ/kidneys/process()
	..()
	//Deal toxin damage if damaged
	if(owner.chem_effect_flags & CHEM_EFFECT_ORGAN_STASIS)
		return
	if(is_bruised() && prob(25))
		owner.apply_damage(0.1 * (damage/3), TOX)
	else if(is_broken() && prob(50))
		owner.apply_damage(0.2 * (damage/3), TOX)

*/

/datum/internal_organ/kidneys/prosthetic
	robotic = ORGAN_ROBOT
	removed_type = /obj/item/organ/kidneys
