/datum/game_mode/extended
	name = "extended"
	config_tag = "extended"
	required_players = 0
	latejoin_larva_drop = 0

	uplink_welcome = "Syndicate Uplink Console:"
	uplink_uses = 10

/datum/game_mode/announce()
	to_world("<B>The current game mode is - Extended!</B>")

/datum/game_mode/extended/pre_setup()
	return 1

/datum/game_mode/extended/post_setup()
	initialize_post_marine_gear_list()

	round_time_lobby = world.time
	defer_powernet_rebuild = 2 //Build powernets a little bit later, it lags pretty hard.

/datum/game_mode/extended/check_finished()
	if(round_finished) return 1

/datum/game_mode/extended/check_win()

/datum/game_mode/extended/declare_completion()
	announce_ending()
	var/musical_track = pick('sound/theme/neutral_hopeful1.ogg','sound/theme/neutral_hopeful2.ogg')
	world << musical_track

	round_statistics.round_finished = round_finished
	round_statistics.game_mode = name
	round_statistics.round_time = duration2text()
	round_statistics.end_round_player_population = clients.len
	round_statistics.total_predators_spawned = predators.len

	round_statistics.log_round_statistics()

	declare_completion_announce_individual()
	declare_completion_announce_predators()
	declare_completion_announce_medal_awards()
	return 1
