/datum/pain/human
	max_pain = 200

	threshold_mild = 20
	threshold_discomforting = 30
	threshold_moderate = 40
	threshold_distressing = 60
	threshold_severe = 70
	threshold_horrible = 80

/datum/pain/human/recalculate_pain()
	. = ..()

	if(!ishuman(source_mob))
		return
	var/mob/living/carbon/human/human = source_mob

	for(var/obj/limb/current_limb in human.limbs)
		// Delimbed
		if((current_limb.status & LIMB_DESTROYED) && !(current_limb.status & LIMB_AMPUTATED))
			apply_pain(PAIN_DELIMB)
		// Broken bones
		else if(current_limb.status & LIMB_BROKEN || human.incision_depths[current_limb.name] != SURGERY_DEPTH_SURFACE)
			// Splinted else non-splinted
			if(current_limb.status & LIMB_SPLINTED)
				apply_pain(PAIN_BONE_BREAK - PAIN_BONE_BREAK_SPLINTED)
			else
				apply_pain(PAIN_BONE_BREAK)
		else if((current_limb.status & LIMB_SPLINTED) && !(current_limb.status & LIMB_BROKEN))
			apply_pain(PAIN_BONE_BREAK_SPLINTED)

	//Internal organs
	for(var/datum/internal_organ/organ in human.internal_organs)
		if(organ.damage)
			apply_pain(organ.damage * PAIN_ORGAN_DAMAGE_MULTIPLIER)

	return TRUE
