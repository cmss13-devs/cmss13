/datum/pain/human
	max_pain 			= 200

	threshold_mild 				= 20
	threshold_discomforting 	= 30
	threshold_moderate			= 40
	threshold_distressing		= 60
	threshold_severe			= 70
	threshold_horrible			= 80

/datum/pain/human/recalculate_pain()
	. = ..()

	if(!ishuman(source_mob))
		return
	var/mob/living/carbon/human/H = source_mob

	for(var/obj/limb/O in H.limbs)
		// Delimbed
		if((O.status & LIMB_DESTROYED) && !(O.status & LIMB_AMPUTATED))
			apply_pain(PAIN_DELIMB)
		// Broken bones
		else if(O.status & LIMB_BROKEN || H.incision_depths[O.name] != SURGERY_DEPTH_SURFACE)
			// Splinted else non-splinted
			if(O.status & LIMB_SPLINTED)
				apply_pain(PAIN_BONE_BREAK - PAIN_BONE_BREAK_SPLINTED)
			else
				apply_pain(PAIN_BONE_BREAK)
		else if((O.status & LIMB_SPLINTED) && !(O.status & LIMB_BROKEN))
			apply_pain(PAIN_BONE_BREAK_SPLINTED)

	//Internal organs
	for(var/datum/internal_organ/O in H.internal_organs)
		if(O.damage)
			apply_pain(O.damage * PAIN_ORGAN_DAMAGE_MULTIPLIER)

	return TRUE