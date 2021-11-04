
/datum/internal_organ/heart
	name = "heart"
	removed_type = /obj/item/organ/heart
	robotic_type = /obj/item/organ/heart/prosthetic
	organ_tag = ORGAN_HEART
	var/revival_damage = 5//How much damage should the heart inflict to itself upon being revived
	var/revival_damage_chance = 25 //Chance of getting damaged on revival
	var/can_heal_on_defib //Can the heart heal the body
	min_bruised_integrity = LIMB_INTEGRITY_SERIOUS
	min_broken_integrity = LIMB_INTEGRITY_NONE

/datum/internal_organ/heart/prosthetic //used by synthetic species
	robotic = ORGAN_ROBOT
	removed_type = /obj/item/organ/heart/prosthetic

/datum/internal_organ/heart/proc/can_revive()
	return !(HAS_TRAIT(src, TRAIT_ORGAN_BROKEN))

/datum/internal_organ/heart/proc/handle_defib(defib_heal)
	if(prob(revival_damage_chance))
		take_damage(revival_damage)

	if(!(HAS_TRAIT(src, TRAIT_ORGAN_MALFUNCTIONING)))
		handle_defib_heal(defib_heal)

/datum/internal_organ/heart/proc/handle_defib_heal(defib_heal)
	owner.apply_damage(-defib_heal, BRUTE)
	owner.apply_damage(-defib_heal, BURN)
	owner.apply_damage(-defib_heal, TOX)
	owner.apply_damage(-defib_heal, CLONE)
	owner.apply_damage(-owner.getOxyLoss(), OXY)
	owner.updatehealth() //Needed for the check to register properly
