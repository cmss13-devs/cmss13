/datum/effects/floored_target
	effect_name = "floored target"
	duration = null
	flags = DEL_ON_DEATH | INF_DURATION

	var/shorter = FALSE
	var/mob/living/carbon/xenomorph/source_xeno

/datum/effects/floored_target/New(atom/target_atom, mob/from = null, last_dmg_source = null, zone = "chest", ttl = 10 SECONDS)
	. = ..(target_atom, from, last_dmg_source, zone)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), src), ttl)

	if(istype(from, /mob/living/carbon/xenomorph))
		source_xeno = from

	if(ishuman(target_atom))
		var/mob/living/carbon/human/target_human = target_atom
		target_human.update_xeno_hostile_hud()


/datum/effects/floored_target/validate_atom(mob/living/carbon/target_human)
	if(!isxeno_human(target_human) || target_human.stat == DEAD)
		return FALSE
	return ..()


/datum/effects/floored_target/process_mob()
	. = ..()

	// Also checks for null atoms
	if(!istype(affected_atom, /mob/living/carbon/human))
		return

	var/mob/living/carbon/human/target_human = affected_atom
	target_human.update_xeno_hostile_hud()


/datum/effects/floored_target/Destroy()
	if(ishuman(affected_atom))
		var/mob/living/carbon/human/target_human = affected_atom
		target_human.update_xeno_hostile_hud()

	return ..()
