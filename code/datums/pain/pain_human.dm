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

	for(var/obj/limb/O in human.limbs)
		// Delimbed
		if((O.status & LIMB_DESTROYED) && !(O.status & LIMB_AMPUTATED))
			apply_pain(PAIN_DELIMB)
			continue //we take no extra pain from destroyed limb
		// Broken bones
		if(O.status & LIMB_BROKEN || human.incision_depths[O.name] != SURGERY_DEPTH_SURFACE)
			// Splinted else non-splinted
			if(O.status & LIMB_SPLINTED)
				apply_pain(PAIN_BONE_BREAK - PAIN_BONE_BREAK_SPLINTED)
			else
				apply_pain(PAIN_BONE_BREAK)
		else if((O.status & LIMB_SPLINTED) && !(O.status & LIMB_BROKEN))
			apply_pain(PAIN_BONE_BREAK_SPLINTED)

		if(O.status & LIMB_ESCHAR)
			apply_pain(PAIN_ESCHAR)

	//Internal organs
	for(var/datum/internal_organ/O in human.internal_organs)
		if(O.damage)
			apply_pain(O.damage * PAIN_ORGAN_DAMAGE_MULTIPLIER)

	if(human.bodytemperature > human.species.heat_level_3)
		apply_pain(HEAT_DAMAGE_LEVEL_3, BURN)
	else if(human.bodytemperature > human.species.heat_level_2)
		apply_pain(HEAT_DAMAGE_LEVEL_2, BURN)
	else if(human.bodytemperature > human.species.heat_level_1)
		apply_pain(HEAT_DAMAGE_LEVEL_1, BURN)

	if(human.bodytemperature < human.species.cold_level_3)
		apply_pain(COLD_DAMAGE_LEVEL_3, BURN)
	else if(human.bodytemperature < human.species.cold_level_2)
		apply_pain(COLD_DAMAGE_LEVEL_2, BURN)
	else if(human.bodytemperature < human.species.cold_level_1)
		apply_pain(COLD_DAMAGE_LEVEL_1, BURN)

	return TRUE
