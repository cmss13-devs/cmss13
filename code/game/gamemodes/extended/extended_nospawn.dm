/datum/game_mode/extended/nospawn
	name = MODE_NAME_EXTENDED_NO_SPAWN
	config_tag = MODE_NAME_EXTENDED_NO_SPAWN
	flags_round_type = MODE_NO_LATEJOIN|MODE_NO_SPAWN
	votable = FALSE

/datum/game_mode/extended/nospawn/post_setup()
	round_time_lobby = world.time
	return ..()
