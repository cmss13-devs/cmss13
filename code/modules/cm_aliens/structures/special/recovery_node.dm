//Recovery Node - Heals xenomorphs around it

/obj/effect/alien/resin/special/recovery
	name = XENO_STRUCTURE_RECOVERY
	desc = "A warm, soothing light source that pulsates with a faint hum."
	icon_state = "recovery"
	health = 400
	var/recovery_pheromone_range = 2
	var/warding_pheromone_range = 8
	var/recovery_strength = 2.5
	var/warding_strength = 1


/obj/effect/alien/resin/special/recovery/get_examine_text(mob/user)
	. = ..()
	if((isxeno(user) || isobserver(user)) && linked_hive)
		. += "Emits pheromones to nearby Xenomorphs."

/obj/effect/alien/resin/special/recovery/process()
	for(var/mob/living/carbon/xenomorph/xenomorph in range(recovery_pheromone_range, loc))
		if(xenomorph.ignores_pheromones)
			continue
		if(recovery_strength > xenomorph.recovery_new && linked_hive == xenomorph.hivenumber)
			xenomorph.recovery_new = recovery_strength

	for(var/mob/living/carbon/xenomorph/xenomorph in range(warding_pheromone_range, loc))
		if(xenomorph.ignores_pheromones)
			continue
		if(warding_strength > xenomorph.warding_new && linked_hive == xenomorph.hivenumber)
			xenomorph.recovery_new = warding_strength
