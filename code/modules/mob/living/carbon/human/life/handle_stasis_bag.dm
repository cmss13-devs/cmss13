//Refer to life.dm for caller

/mob/living/carbon/human/proc/handle_stasis_bag()
	//Handle side effects from stasis
	switch(in_stasis)
		if(STASIS_IN_BAG)
			Knockdown(1 SECONDS)
		if(STASIS_IN_CRYO_CELL)
			if(sleeping < 10) sleeping += 10 //Puts the mob to sleep indefinitely.
