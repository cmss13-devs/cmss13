/mob/living/carbon/xenomorph/Login()
	..()
	if(client)
		set_lighting_alpha_from_prefs(client)
		if(client.player_data)
			generate_name()
		SSbattlepass.xeno_battlepass_earners |= client.ckey
	if(SSticker.mode)
		SSticker.mode.xenomorphs |= mind
