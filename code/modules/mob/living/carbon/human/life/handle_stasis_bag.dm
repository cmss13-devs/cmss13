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
