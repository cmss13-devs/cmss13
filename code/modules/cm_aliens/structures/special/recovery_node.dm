/obj/effect/alien/resin/special/plasma_tree
	name = XENO_STRUCTURE_PLASMA_TREE
	desc = "A tree shaped node that has liquid plasma dripping around it."
	health = 400
	icon_state =  "recovery_plasma"
	var/replenish_amount = 75
	COOLDOWN_DECLARE(last_replenish)

/obj/effect/alien/resin/special/plasma_tree/Initialize(mapload, hive_ref)
	. = ..()
	update_minimap_icon()
	RegisterSignal(SSdcs, COMSIG_GLOB_BOOST_XENOMORPH_WALLS, PROC_REF(enable_boost))
	RegisterSignal(SSdcs, COMSIG_GLOB_STOP_BOOST_XENOMORPH_WALLS, PROC_REF(disable_boost))

/obj/effect/alien/resin/special/plasma_tree/proc/update_minimap_icon()
	SSminimaps.remove_marker(src)
	SSminimaps.add_marker(src, z, get_minimap_flag_for_faction(linked_hive?.hivenumber), "recovery_node")

/obj/effect/alien/resin/special/plasma_tree/get_examine_text(mob/user)
	. = ..()
	if((isxeno(user) || isobserver(user)) && linked_hive)
		. += "Recovers the [SPAN_BLUE("plasma")] of adjacent Xenomorphs."

/obj/effect/alien/resin/special/plasma_tree/process()
	update_minimap_icon()


	if(boosted_structure)
		replenish_amount = 200 // Increase plasma replenish by a bit
		if(health <= maxhealth)
			health += 25 // Regenerate health by 25
	else
		replenish_amount = 75


	if(!COOLDOWN_FINISHED(src, last_replenish))
		return

	var/list/plasma_candidates = list()

	for(var/mob/living/carbon/xenomorph/xeno_in_range in orange(src, 1))
		if(xeno_in_range.plasma_stored >= xeno_in_range.plasma_max || !xeno_in_range.resting || xeno_in_range.hivenumber != linked_hive.hivenumber)
			continue

		if(xeno_in_range.stat == DEAD)
			continue

		plasma_candidates += xeno_in_range
	COOLDOWN_START(src, last_replenish, 3 SECONDS)

	if(!length(plasma_candidates))
		return

	var/mob/living/carbon/xenomorph/picked_candidate = pick(plasma_candidates)
	picked_candidate.visible_message(SPAN_HELPFUL("[picked_candidate] glows as a warm aura envelops them."),
			SPAN_HELPFUL("We feel a warm aura envelop us."))

	picked_candidate.gain_plasma(replenish_amount)

//Recovery Node - Heals xenomorphs around it

/obj/effect/alien/resin/special/recovery
	name = XENO_STRUCTURE_RECOVERY
	desc = "A warm, soothing light source that pulsates with a faint hum."
	icon_state = "recovery"
	health = 400
	var/heal_amount = 20
	COOLDOWN_DECLARE(last_heal)

/obj/effect/alien/resin/special/recovery/Initialize(mapload, hive_ref)
	. = ..()
	update_minimap_icon()
	RegisterSignal(SSdcs, COMSIG_GLOB_BOOST_XENOMORPH_WALLS, PROC_REF(enable_boost))
	RegisterSignal(SSdcs, COMSIG_GLOB_STOP_BOOST_XENOMORPH_WALLS, PROC_REF(disable_boost))

/obj/effect/alien/resin/special/recovery/proc/update_minimap_icon()
	SSminimaps.remove_marker(src)
	SSminimaps.add_marker(src, z, get_minimap_flag_for_faction(linked_hive?.hivenumber), "recovery_node")

/obj/effect/alien/resin/special/recovery/Destroy()
	. = ..()
	SSminimaps.remove_marker(src)

/obj/effect/alien/resin/special/recovery/get_examine_text(mob/user)
	. = ..()
	if((isxeno(user) || isobserver(user)) && linked_hive)
		. += "Recovers the [SPAN_MAROON("health")] of adjacent Xenomorphs."


/obj/effect/alien/resin/special/recovery/process()
	update_minimap_icon()

	if(boosted_structure)
		heal_amount = 100 // increase heal amount by abit, needs tweaking probably
		if(health <= maxhealth)
			health += 25 // Regenerate health by 25
	else
		heal_amount = 25

	if(!COOLDOWN_FINISHED(src, last_heal))
		return

	var/list/heal_candidates = list()

	for(var/mob/living/carbon/xenomorph/xeno_in_range in orange(src, 1))
		if(xeno_in_range.health >= xeno_in_range.maxHealth || !xeno_in_range.resting || xeno_in_range.hivenumber != linked_hive.hivenumber)
			continue
		if(xeno_in_range.stat == DEAD)
			continue
		heal_candidates += xeno_in_range

	COOLDOWN_START(src, last_heal, 3 SECONDS)



	if(!length(heal_candidates))
		return

	var/mob/living/carbon/xenomorph/picked_candidate = pick(heal_candidates)
	picked_candidate.visible_message(SPAN_HELPFUL("\The [picked_candidate] glows as a warm aura envelops them."),
			SPAN_HELPFUL("We feel a warm aura envelop us."))

	picked_candidate.gain_health(heal_amount)
