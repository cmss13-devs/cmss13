/datum/internal_organ/eyes
	name = "eyes"
	removed_type = /obj/item/organ/eyes
	robotic_type = /obj/item/organ/eyes/prosthetic
	min_bruised_integrity = LIMB_INTEGRITY_CRITICAL
	min_broken_integrity = LIMB_INTEGRITY_NONE
	organ_tag = ORGAN_EYES
	var/eye_surgery_stage = 0 //stores which stage of the eye surgery the eye is at
	var/color_r = 0
	var/color_g = 0
	var/color_b = 0

/datum/internal_organ/eyes/link_to_body(mob/living/carbon/human/H, initializing)
	..()
	if(initializing)
		color_r = H.r_eyes
		color_g = H.g_eyes
		color_b = H.b_eyes
	else
		H.r_eyes = color_r
		H.g_eyes = color_g
		H.b_eyes = color_b
		H.update_body()

/datum/internal_organ/eyes/unlink_from_body()
	owner.r_eyes = 0
	owner.g_eyes = 0
	owner.b_eyes = 0
	..()

/*
/datum/internal_organ/eyes/process() //Eye damage replaces the old eye_stat var.
	..()
	if(owner.chem_effect_flags & CHEM_EFFECT_ORGAN_STASIS)
		return
	if(is_bruised())
		owner.eye_blurry = 20
	if(is_broken())
		owner.eye_blind = 20
*/

/datum/internal_organ/eyes/prosthetic
	robotic = ORGAN_ROBOT
	removed_type = /obj/item/organ/eyes/prosthetic

/datum/internal_organ/eyes/on_malfunction(trait_source)
	..()
	RegisterSignal(owner, COMSIG_MOB_PRE_GLASSES_SIGHT_BONUS, .proc/block_night_vision)
	RegisterSignal(owner, COMSIG_MOB_PRE_EYE_TINTCHECK, .proc/add_eye_tint)

/datum/internal_organ/eyes/proc/block_night_vision()
	SIGNAL_HANDLER
	return COMPONENT_BLOCK_GLASSES_SIGHT_BONUS

/datum/internal_organ/eyes/proc/add_eye_tint()
	SIGNAL_HANDLER
	return COMPONENT_ADD_EYETINT
