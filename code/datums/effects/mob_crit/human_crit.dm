/datum/effects/crit/human/process_mob()
	. = ..()
	if(!.)
		return FALSE

	var/mob/living/carbon/affected_mob = affected_atom
	if(affected_mob.health > affected_mob.human_health_threshold_crit)
		qdel(src)
		return FALSE

	affected_mob.apply_effect(3, PARALYZE)
	if(!affected_mob.reagents || !affected_mob.reagents.has_reagent("inaprovaline"))
		affected_mob.apply_damage(1, OXY)

	return TRUE
