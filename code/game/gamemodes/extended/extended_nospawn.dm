/datum/game_mode/extended/nospawn
	name = "extended no spawn"
	config_tag = "extended - no spawn"
	flags_round_type = MODE_NO_LATEJOIN|MODE_NO_SPAWN
	votable = FALSE

/datum/game_mode/extended/nospawn/post_setup()
	initialize_map_resource_list()
	for(var/mob/new_player/np in GLOB.new_player_list)
		np.new_player_panel_proc()
	round_time_lobby = world.time
	return ..()
