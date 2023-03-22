/datum/effects/dancer_tag
	effect_name = "dancer tag"
	duration = null
	flags = DEL_ON_DEATH | INF_DURATION


/datum/effects/dancer_tag/New(atom/A, mob/from = null, last_dmg_source = null, zone = "chest", ttl = 35)
	. = ..(A, from, last_dmg_source, zone)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), src), ttl)

	if (ishuman(A))
		var/mob/living/carbon/human/human = A
		human.update_xeno_hostile_hud()


/datum/effects/dancer_tag/validate_atom(mob/living/carbon/human)
	if (!isxeno_human(human) || human.stat == DEAD)
		return FALSE
	return ..()


/datum/effects/dancer_tag/process_mob()
	. = ..()

	// Also checks for null atoms
	if (!istype(affected_atom, /mob/living/carbon/human))
		return

	var/mob/living/carbon/human/human = affected_atom
	human.update_xeno_hostile_hud()


/datum/effects/dancer_tag/Destroy()
	if (!ishuman(affected_atom))
		return ..()

	var/mob/living/carbon/human/human = affected_atom
	addtimer(CALLBACK(human, TYPE_PROC_REF(/mob/living/carbon/human, update_xeno_hostile_hud)), 3)

	return ..()
