//THIS IS A BLANK LABEL ONLY SO PEOPLE CAN SEE WHEN WE RUNNIN DIS BITCH.   Should probably write a real one one day.  Maybe.
/datum/game_mode/infection
	name = "Infection"
	config_tag = "Infection"
	required_players = 0 //otherwise... no zambies
	latejoin_larva_drop = 0
	flags_round_type = MODE_INFECTION //Apparently without this, the game mode checker ignores this as a potential legit game mode.

	uplink_welcome = "IF YOU SEE THIS, SHIT A BRICK AND AHELP"
	uplink_uses = 10

	var/const/waittime_l = 600 //lower bound on time before intercept arrives (in tenths of seconds)
	var/const/waittime_h = 1800

/datum/game_mode/infection/announce()
	to_world("<B>The current game mode is - ZOMBIES!</B>")
	to_world("<B>Just have fun and role-play!</B>")
	to_world("<B>If you die as a zombie, you come back.  NO MATTER HOW MUCH DAMAGE.</B>")
	to_world("<B>Don't ahelp asking for specific details, you won't get them.</B>")

/datum/game_mode/infection/pre_setup()
	return 1

/datum/game_mode/infection/post_setup()
	initialize_post_marine_gear_list()

/datum/game_mode/infection/can_start()
	initialize_starting_survivor_list()
	return 1

/datum/game_mode/infection/check_win()
	var/living_player_list[] = count_humans_and_xenos(EvacuationAuthority.get_affected_zlevels())
	var/num_humans = living_player_list[1]
	var/zed = living_player_list[2]
//	to_world("ZED: [zed]")
//	to_world("Humie: [num_humans]")

	if(num_humans <=0 && zed >= 1)
		round_finished = MODE_INFECTION_ZOMBIE_WIN

/datum/game_mode/infection/check_finished()
	if(round_finished) return 1

/datum/game_mode/infection/process()
	. = ..()
	if(--round_started > 0) r_FAL //Initial countdown, just to be safe, so that everyone has a chance to spawn before we check anything.

	if(!round_finished)
		if(++round_checkwin >= 5) //Only check win conditions every 5 ticks.
			check_win()
			round_checkwin = 0

/datum/game_mode/infection/declare_completion()
	announce_ending()
	var/musical_track = pick('sound/theme/sad_loss1.ogg','sound/theme/sad_loss2.ogg')
	world << musical_track

	round_statistics.round_finished = round_finished
	round_statistics.game_mode = name
	round_statistics.round_time = duration2text()
	round_statistics.end_round_player_population = clients.len
	round_statistics.total_predators_spawned = predators.len

	round_statistics.log_round_statistics()

	declare_completion_announce_predators()
	declare_completion_announce_xenomorphs()
	declare_completion_announce_survivors()
	declare_completion_announce_medal_awards()
	return 1




/datum/game_mode/infection/post_setup()
	initialize_post_survivor_list()

	spawn (50)
		command_announcement.Announce("We've lost contact with the Weyland-Yutani's research facility, [name]. The [MAIN_SHIP_NAME] has been dispatched to assist.", "[MAIN_SHIP_NAME]")

