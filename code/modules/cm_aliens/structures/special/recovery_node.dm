//Recovery Node - Heals xenomorphs around it

/obj/effect/alien/resin/special/recovery
	name = XENO_STRUCTURE_RECOVERY
	desc = "A warm, soothing light source that pulsates with a faint hum."
	icon_state = "recovery"
	health = 400
	var/heal_amount = 20
	var/heal_cooldown = 5 SECONDS
	var/last_healed
	var/buff_type = "HEALTH" // Start them off as healers.
	var/plasma_amount = 75

/obj/effect/alien/resin/special/recovery/Initialize(mapload, hive_ref)
	. = ..()
	update_minimap_icon()

/obj/effect/alien/resin/special/recovery/proc/update_minimap_icon()
	SSminimaps.remove_marker(src)
	SSminimaps.add_marker(src, z, get_minimap_flag_for_faction(linked_hive?.hivenumber), "recovery_node")

/obj/effect/alien/resin/special/recovery/Destroy()
	. = ..()
	SSminimaps.remove_marker(src)

/obj/effect/alien/resin/special/recovery/get_examine_text(mob/user)
	. = ..()
	if((isxeno(user) || isobserver(user)) && linked_hive)
		. += "Recovers the health of adjacent Xenomorphs. It's currently giving out [SPAN_GREEN(buff_type)] you can change this by alt-clicking."


/obj/effect/alien/resin/special/recovery/clicked(mob/user, list/mods)
	. = ..()

	var/mob/living/carbon/xenomorph/clicker = user

	if(!isxeno(user))
		return


	if(clicker.hivenumber != src.linked_hive.hivenumber)
		return

	if(mods[ALT_CLICK])
		switch(buff_type)
			if("HEALTH")
				buff_type = "PLASMA"
				icon_state = "recovery_plasma"
				src.update_icon()
			if("PLASMA")
				buff_type = "HEALTH"
				icon_state = "recovery"
				src.update_icon()

/obj/effect/alien/resin/special/recovery/process()
	update_minimap_icon()

	if(buff_type == "HEALTH")
		if(last_healed && world.time < last_healed + heal_cooldown)
			return
		var/list/heal_candidates = list()
		for(var/mob/living/carbon/xenomorph/xeno_in_range in orange(src, 1))
			if(xeno_in_range.health >= xeno_in_range.maxHealth || !xeno_in_range.resting || xeno_in_range.hivenumber != linked_hive.hivenumber)
				continue
			if(xeno_in_range.stat == DEAD)
				continue
			heal_candidates += xeno_in_range
		last_healed = world.time
		if(!length(heal_candidates))
			return
		var/mob/living/carbon/xenomorph/picked_candidate = pick(heal_candidates)
		picked_candidate.visible_message(SPAN_HELPFUL("\The [picked_candidate] glows as a warm aura envelops them."),
					SPAN_HELPFUL("We feel a warm aura envelop us."))
		if(!do_after(picked_candidate, heal_cooldown, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
			return
		picked_candidate.gain_health(heal_amount)

	if(buff_type == "PLASMA")


		if(last_healed && world.time < last_healed + heal_cooldown)
			return

		var/list/plasma_candidates = list()
		for(var/mob/living/carbon/xenomorph/xeno_in_range in orange(src, 1))
			if(xeno_in_range.plasma_stored >= xeno_in_range.plasma_max || !xeno_in_range.resting || xeno_in_range.hivenumber != linked_hive.hivenumber)
				continue
			if(xeno_in_range.stat == DEAD)
				continue
			plasma_candidates += xeno_in_range
		last_healed = world.time
		if(!length(plasma_candidates))
			return
		var/mob/living/carbon/xenomorph/picked_candidate = pick(plasma_candidates)
		picked_candidate.visible_message(SPAN_HELPFUL("\The [picked_candidate] glows as a warm aura envelops them."),
					SPAN_HELPFUL("We feel a warm aura envelop us."))
		if(!do_after(picked_candidate, heal_cooldown, INTERRUPT_MOVED, BUSY_ICON_MEDICAL))
			return

		picked_candidate.gain_plasma(plasma_amount)


