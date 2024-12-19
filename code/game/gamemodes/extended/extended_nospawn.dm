/datum/game_mode/extended/nospawn
	name = "Extended - No Spawn"
	config_tag = "Extended - No Spawn"
	flags_round_type = MODE_NO_LATEJOIN|MODE_NO_SPAWN
	votable = FALSE

/datum/game_mode/extended/nospawn/post_setup()
	round_time_lobby = world.time
	return ..()
