/mob/living/carbon/xenomorph/Login()
	..()
	if(client)
		set_lighting_alpha_from_prefs(client)
		if(client.player_data)
			generate_name()
//RUCM START
			if(client.player_data?.battlepass)
				SSbattlepass.xeno_battlepass_earners |= client.player_data.battlepass
	handle_skinning_xeno(src, src)
//RUCM END
	if(SSticker.mode)
		SSticker.mode.xenomorphs |= mind
