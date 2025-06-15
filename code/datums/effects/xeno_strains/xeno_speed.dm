/datum/effects/xeno_speed
	effect_name = "speed"
	flags = DEL_ON_DEATH | INF_DURATION
	var/added_effect = FALSE
	var/effect_speed_modifier = 0
	var/effect_modifier_source = null
	var/effect_end_message = null

/datum/effects/xeno_speed/New(atom/A, mob/from = null, last_dmg_source = null, zone = "chest", ttl = 3.5 SECONDS, set_speed_modifier = 0, set_modifier_source = null, set_end_message = SPAN_XENONOTICE("You feel lethargic..."))
	. = ..(A, from, last_dmg_source, zone)
	if(QDELETED(src))
		return
	QDEL_IN(src, ttl)
	var/mob/living/carbon/xenomorph/xeno = A
	xeno.speed_modifier -= set_speed_modifier
	xeno.recalculate_speed()
	if(set_modifier_source)
		LAZYADD(xeno.modifier_sources, set_modifier_source)
	effect_speed_modifier = set_speed_modifier
	effect_modifier_source = set_modifier_source
	effect_end_message = set_end_message
	added_effect = TRUE

/datum/effects/xeno_speed/validate_atom(atom/A)
	if(!isxeno(A))
		return FALSE
	return ..()

/datum/effects/xeno_speed/process_mob()
	..()
	var/mob/living/carbon/affected_mob = affected_atom
	if(HAS_TRAIT(affected_mob, TRAIT_CHARGING))
		to_chat(affected_mob, SPAN_XENOWARNING("The speed boast wanes as you charge!"))
		qdel(src)
		return FALSE
	return ..()

/datum/effects/xeno_speed/Destroy()
	if(added_effect)
		var/mob/living/carbon/xenomorph/xeno = affected_atom
		xeno.speed_modifier += effect_speed_modifier
		xeno.recalculate_speed()
		if(effect_modifier_source)
			LAZYREMOVE(xeno.modifier_sources, effect_modifier_source)
		if(effect_end_message)
			to_chat(xeno, effect_end_message)
		xeno.balloon_alert(xeno, "our speed fall back to normal.", text_color = "#5B248C")
		playsound(xeno, 'sound/effects/squish_and_exhaust.ogg', 25, 1)
	return ..()
