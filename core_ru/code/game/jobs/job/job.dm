/datum/job
	var/marine_sided = FALSE
	var/xeno_sided = FALSE

/datum/job/proc/add_to_battlepass_earners(mob/living/carbon/human/character)
	if(!character?.client?.ckey)
		return

	if(character.client?.player_data?.battlepass)
		if(marine_sided)
			SSbattlepass.marine_battlepass_earners |= character.client.player_data.battlepass
		else if(xeno_sided)
			SSbattlepass.xeno_battlepass_earners |= character.client.player_data.battlepass
