//Refer to life.dm for caller

/mob/living/carbon/human/proc/handle_stasis_bag()
	//Handle side effects from stasis
	switch(in_stasis)
		if(STASIS_IN_BAG)
			// At least 6 seconds, but reduce by 2s every time - IN ADDITION to normal recovery
			// Don't ask me why and feel free to change it
			KnockDown(3)
			AdjustKnockDown(-1)
		if(STASIS_IN_CRYO_CELL)
			if(sleeping < 10)
				sleeping += 10 //Puts the mob to sleep indefinitely.

	//APS Stuff
	for(var/datum/reagent/antiparasitic_reagent in reagents.reagent_list)
		var/datum/chem_property/property = antiparasitic_reagent.get_property(PROPERTY_ANTIPARASITIC) //If I have APS in me. Tell player APS is not working in stasis
		if(property) //If we have APS and a 25% chance to run
			var/obj/item/alien_embryo/embryo = locate() in contents //Check if we have an embryo in us
			if(embryo)
				if(prob(25) && embryo.stage >= 2) //Embryo should only be noticed when you are above stage 2 (This is the standard in embryo.dm)
					to_chat(src, SPAN_NOTICE("As your metabolism slows down, something inside you relaxes")) //Inform the marine the stasis makes it ineffective
			break// otherwise, stop looping this handling regardless


