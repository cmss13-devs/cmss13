/mob/living/carbon/Xenomorph/Login()
	..()
	if(client)
		set_lighting_alpha_from_prefs(client)
		if(client.player_data)
			generate_name()
	if(SSticker.mode)
		SSticker.mode.xenomorphs |= mind
