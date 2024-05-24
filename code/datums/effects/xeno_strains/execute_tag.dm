/datum/effects/execute_tag
	effect_name = "execute tag"
	duration = null
	flags = DEL_ON_DEATH | INF_DURATION


/datum/effects/execute_tag/New(atom/affected, mob/from = null, last_dmg_source = null, zone = "chest", ttl = 35)
	. = ..()

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), src), ttl)

	if (ishuman(affected))
		var/mob/living/carbon/human/affected_human = affected
		affected_human.update_xeno_hostile_hud()


/datum/effects/execute_tag/validate_atom(mob/living/carbon/affected_carbon)
	if (!isxeno_human(affected_carbon) || affected_carbon.stat == DEAD)
		return FALSE
	return ..()


/datum/effects/execute_tag/process_mob()
	. = ..()

	// Also checks for null atoms
	if (!istype(affected_atom, /mob/living/carbon/human))
		return

	var/mob/living/carbon/human/affected_human = affected_atom
	affected_human.update_xeno_hostile_hud()


/datum/effects/execute_tag/Destroy()
	if (!ishuman(affected_atom))
		return ..()

	var/mob/living/carbon/human/affected_human = affected_atom
	addtimer(CALLBACK(affected_human, TYPE_PROC_REF(/mob/living/carbon/human, update_xeno_hostile_hud)), 0.3 SECONDS)

	return ..()
