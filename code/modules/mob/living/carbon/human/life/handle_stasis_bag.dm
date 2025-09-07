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

/mob/living/carbon/human/proc/handle_stasis_bag_with_APS()
	for(var/datum/reagent/antiparasitic_reagent in src.reagents.reagent_list)
		var/datum/chem_property/property = antiparasitic_reagent.get_property(PROPERTY_ANTIPARASITIC) //Adrenaline helps greatly at restarting the heart
		if(property)
			if(prob(25))
				to_chat(src, SPAN_NOTICE("A strange sensation of anxiety sweeps over you as something inside you relaxes under the stasis field.")) //Inform the marine the stasis field is killing
				break

