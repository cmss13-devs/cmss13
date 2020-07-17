//THIS IS A BLANK LABEL ONLY SO PEOPLE CAN SEE WHEN WE RUNNIN DIS BITCH.   Should probably write a real one one day.  Maybe.
/datum/game_mode/infection
	name = "Infection"
	config_tag = "Infection"
	required_players = 0 //otherwise... no zambies
	latejoin_larva_drop = 0
	flags_round_type = MODE_INFECTION //Apparently without this, the game mode checker ignores this as a potential legit game mode.

	uplink_welcome = "IF YOU SEE THIS, SHIT A BRICK AND AHELP"
	uplink_uses = 10

/datum/game_mode/infection/announce()
	to_world("<B>The current game mode is - ZOMBIES!</B>")
	to_world("<B>Just have fun and role-play!</B>")
	to_world("<B>If you die as a zombie, you come back.  NO MATTER HOW MUCH DAMAGE.</B>")
	to_world("<B>Don't ahelp asking for specific details, you won't get them.</B>")

/datum/game_mode/infection/pre_setup()
	setup_round_stats()
	return 1

/datum/game_mode/infection/post_setup()
	initialize_post_survivor_list()
	initialize_post_marine_gear_list()
	initialize_map_resource_list()
	for(var/mob/new_player/np in player_list)
		np.new_player_panel_proc()
	spawn(50)
		marine_announcement("We've lost contact with the Weston-Yamada's research facility, [name]. The [MAIN_SHIP_NAME] has been dispatched to assist.", "[MAIN_SHIP_NAME]")

/datum/game_mode/infection/can_start()
	initialize_starting_survivor_list()
	return 1

/datum/game_mode/infection/check_win()
	var/living_player_list[] = count_humans_and_xenos(EvacuationAuthority.get_affected_zlevels())
	var/num_humans = living_player_list[1]
	var/zed = living_player_list[2]

	if(num_humans <=0 && zed >= 1)
		round_finished = MODE_INFECTION_ZOMBIE_WIN

/datum/game_mode/infection/check_finished()
	if(round_finished) return 1

/datum/game_mode/infection/process()
	. = ..()
	if(--round_started > 0) 
		return FALSE //Initial countdown, just to be safe, so that everyone has a chance to spawn before we check anything.

	if(!round_finished)
		if(++round_checkwin >= 5) //Only check win conditions every 5 ticks.
			check_win()
			round_checkwin = 0

/datum/game_mode/infection/declare_completion()
	announce_ending()
	var/musical_track = pick('sound/theme/sad_loss1.ogg','sound/theme/sad_loss2.ogg')
	world << musical_track

	if(round_statistics)
		round_statistics.game_mode = name
		round_statistics.round_length = world.time
		round_statistics.end_round_player_population = clients.len
		round_statistics.log_round_statistics()

	declare_completion_announce_xenomorphs()
	declare_completion_announce_predators()
	declare_completion_announce_medal_awards()
	return 1
