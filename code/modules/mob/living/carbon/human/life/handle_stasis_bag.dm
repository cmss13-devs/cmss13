//Refer to life.dm for caller

/mob/living/carbon/human/proc/handle_stasis_bag()
	//Handle side effects from stasis
	switch(in_stasis)
		if(STASIS_IN_BAG)
			// I hate whoever wrote this and statuses with a passion
			knocked_down = knocked_down? --knocked_down : knocked_down + 10 //knocked_down set.
			if(knocked_down <= 0)
				knocked_down_callback()
		if(STASIS_IN_CRYO_CELL)
			if(sleeping < 10) sleeping += 10 //Puts the mob to sleep indefinitely.
