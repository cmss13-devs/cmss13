/datum/game_mode/horde_mode
	name = "Horde Mode"
	config_tag = "Horde Mode"
	flags_round_type = MODE_NO_LATEJOIN|MODE_NO_SPAWN
	required_players = 1
	latejoin_larva_drop = 0
	static_comms_amount = 0
	votable = FALSE
	taskbar_icon = 'icons/taskbar/gml_colonyrp.png'

/datum/game_mode/horde_mode/announce()
	to_world("<B>The current game mode is - Horde Mode!</B>")

/datum/game_mode/horde_mode/post_setup()
	round_time_lobby = world.time
	return ..()

/datum/game_mode/horde_mode/process()
	. = ..()

/datum/game_mode/horde_mode/check_finished()
	if(round_finished)
		return TRUE

/datum/game_mode/horde_mode/check_win()
	return

/datum/game_mode/horde_mode/declare_completion()
	announce_ending()
	var/musical_track = pick('sound/theme/neutral_hopeful1.ogg','sound/theme/neutral_hopeful2.ogg')
	world << musical_track

	if(GLOB.round_statistics)
		GLOB.round_statistics.game_mode = name
		GLOB.round_statistics.round_length = world.time
		GLOB.round_statistics.end_round_player_population = length(GLOB.clients)
		GLOB.round_statistics.log_round_statistics()

	calculate_end_statistics()
	declare_completion_announce_predators()
	declare_completion_announce_medal_awards()

	GLOB.round_statistics?.save()

	return TRUE
