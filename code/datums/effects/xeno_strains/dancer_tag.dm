/datum/effects/dancer_tag
	effect_name = "dancer tag"
	duration = null
	flags = DEL_ON_DEATH | INF_DURATION

	var/spread = FALSE
	var/mob/living/carbon/xenomorph/source_xeno

/datum/effects/dancer_tag/New(atom/target_atom, mob/from = null, last_dmg_source = null, zone = "chest", ttl = 35)
	. = ..(target_atom, from, last_dmg_source, zone)

	addtimer(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(qdel), src), ttl)

	if(istype(from, /mob/living/carbon/xenomorph))
		source_xeno = from

	if(ishuman(target_atom))
		var/mob/living/carbon/human/target_human = target_atom
		target_human.update_xeno_hostile_hud()


/datum/effects/dancer_tag/validate_atom(mob/living/carbon/target_human)
	if(!isxeno_human(target_human) || target_human.stat == DEAD)
		return FALSE
	return ..()


/datum/effects/dancer_tag/process_mob()
	. = ..()

	// Also checks for null atoms
	if(!istype(affected_atom, /mob/living/carbon/human))
		return

	var/mob/living/carbon/human/target_human = affected_atom
	target_human.update_xeno_hostile_hud()


/datum/effects/dancer_tag/Destroy()
	if(ishuman(affected_atom))
		var/mob/living/carbon/human/target_human = affected_atom
		target_human.update_xeno_hostile_hud()
		if(spread)
			to_chat(target_human, SPAN_XENODANGER("You calm down and get back to your senses."))
			to_chat(source_xeno, SPAN_XENODANGER("Our surging instincts fade away, we no longer feel compelled to hunt them."))
			spread = FALSE

	return ..()

/datum/effects/dancer_tag/normal
	effect_name = "dancer tag normal"

/datum/effects/dancer_tag/spread
	effect_name = "dancer tag spread"

/datum/effects/dancer_tag/spread/New(atom/target_atom, mob/from = null)
	. = ..(target_atom, from, null, "chest", 7 SECONDS)

	to_chat(target_atom, SPAN_XENOHIGHDANGER("You feel fear washing down your spine... you could be next!"))
	spread = TRUE
