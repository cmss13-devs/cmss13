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

	if(facehugger.pounce_distance <= 1 && can_hug(L, facehugger.hivenumber))
		facehugger.handle_hug(L)
