/datum/game_mode/extended
	name = "extended"
	config_tag = "extended"
	required_players = 0
	latejoin_larva_drop = 0
	votable = FALSE

/datum/game_mode/announce()
	to_world("<B>The current game mode is - Extended!</B>")

/datum/game_mode/extended/pre_setup()
	setup_round_stats()
	roles_to_roll = RoleAuthority.roles_for_mode - (RoleAuthority.roles_for_mode & (ROLES_XENO|ROLES_WHITELISTED|ROLES_SPECIAL))

	return ..()

/datum/game_mode/extended/post_setup()
	initialize_post_marine_gear_list()
	for(var/mob/new_player/np in GLOB.new_player_list)
		np.new_player_panel_proc()
	round_time_lobby = world.time
	return ..()

/datum/game_mode/extended/check_finished()
	if(round_finished)
		return TRUE

/datum/game_mode/extended/check_win()
	return

/datum/game_mode/extended/declare_completion()
	announce_ending()
	var/musical_track = pick('sound/theme/neutral_hopeful1.ogg','sound/theme/neutral_hopeful2.ogg')
	world << musical_track

	if(round_statistics)
		round_statistics.game_mode = name
		round_statistics.round_length = world.time
		round_statistics.end_round_player_population = GLOB.clients.len
		round_statistics.log_round_statistics()

	announce_agents()
	calculate_end_statistics()
	declare_completion_announce_predators()
	declare_completion_announce_medal_awards()
	return TRUE
