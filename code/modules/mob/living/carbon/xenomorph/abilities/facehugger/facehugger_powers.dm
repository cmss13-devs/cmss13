/datum/action/xeno_action/activable/pounce/facehugger/additional_effects_always()
	..()

	var/mob/living/carbon/Xenomorph/facehugger = owner
	if(!istype(facehugger))
		return
	facehugger.update_icons()

/datum/action/xeno_action/activable/pounce/facehugger/additional_effects(mob/living/L)
	if(!ishuman(L))
		return

	var/mob/living/carbon/Xenomorph/Facehugger/facehugger = owner
	if(!istype(facehugger))
		return

	var/key_name = key_name(facehugger)
	var/did_hug = FALSE
	if(facehugger.pounce_distance <= 1 && can_hug(L, facehugger.hivenumber))
		did_hug = facehugger.handle_hug(L)
	log_attack("[key_name] [did_hug ? "successfully hugged" : "tried to hug"] [key_name(L)] (Pounce Distance: [facehugger.pounce_distance]) at [get_location_in_text(L)]")
