/mob/living/carbon/Xenomorph/Login()
	..()
	generate_name()
	if(client)
		set_lighting_alpha_from_prefs(client)
	if(SSticker.mode)
		SSticker.mode.xenomorphs |= mind
