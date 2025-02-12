SUBSYSTEM_DEF(moba)
	name = "Heroes of the League of Xenomorphs 2"
	wait = 2 SECONDS
	flags = SS_KEEP_TIMING
	priority = SS_PRIORITY_MOBA

	var/list/datum/moba_controller/controllers = list()
	var/list/datum/moba_controller/controller_id_dict = list()

	var/list/datum/moba_controller/current_run

	var/list/datum/moba_player/players_in_queue = list()
	COOLDOWN_DECLARE(matchmaking_cooldown)

	var/current_highest_map_id = 1

/datum/controller/subsystem/moba/Initialize()
	for(var/caste_path in subtypesof(/datum/moba_caste))
		var/datum/moba_caste/caste = new caste_path
		GLOB.moba_castes[caste.equivalent_caste_path] = caste
		GLOB.moba_castes_name[caste.name] = caste
	return SS_INIT_SUCCESS

/datum/controller/subsystem/moba/stat_entry(msg)
	msg = "M:[length(controllers)]|Q:[length(players_in_queue)]"
	return ..()

/datum/controller/subsystem/moba/fire(resumed = FALSE)
	if(!resumed)
		current_run = controllers.Copy()

	while(length(current_run))
		var/datum/moba_controller/controller = current_run[length(current_run)]
		current_run.len--

		if(!controller || QDELETED(controller))
			continue

		controller.handle_tick()

		if(MC_TICK_CHECK)
			return

	if(COOLDOWN_FINISHED(src, matchmaking_cooldown) && (length(players_in_queue) >= 8)) // We can actually make a match
		do_matchmaking()

/datum/controller/subsystem/moba/proc/add_to_queue(datum/moba_player/player)
	players_in_queue |= player

/datum/controller/subsystem/moba/proc/remove_from_queue(datum/moba_player/player)
	players_in_queue -= player

/// I'm not bothering with MMR or whatever the hell
/// Pure randomness, this is where boys become men
/datum/controller/subsystem/moba/proc/do_matchmaking()
	var/list/already_taken_castes_team1 = list()
	var/list/already_taken_castes_team2 = list()
	var/list/team1_players = list()
	var/list/team2_players = list()
	var/list/team1_needed_roles = list(
		MOBA_LANE_TOP,
		MOBA_LANE_JUNGLE,
		MOBA_LANE_SUPPORT,
		MOBA_LANE_BOT,
	)
	var/list/team2_needed_roles = list(
		MOBA_LANE_TOP,
		MOBA_LANE_JUNGLE,
		MOBA_LANE_SUPPORT,
		MOBA_LANE_BOT,
	)

	var/list/randomized_queue = shuffle(players_in_queue.Copy())
	mm_loop:
		for(var/datum/moba_player/player as anything in randomized_queue)
			//roles_had[player.queue_slots[1].position]++
			for(var/i in 1 to 3)
				if((player.queue_slots[i].position in team1_needed_roles) && !(player.queue_slots[i].caste in already_taken_castes_team1))
					team1_needed_roles -= player.queue_slots[i].position
					already_taken_castes_team1 += player.queue_slots[i].caste
					team1_players += player
					randomized_queue -= player
				else if((player.queue_slots[i].position in team2_needed_roles) && !(player.queue_slots[i].caste in already_taken_castes_team2))
					team2_needed_roles -= player.queue_slots[i].position
					already_taken_castes_team2 += player.queue_slots[i].caste
					team2_players += player
					randomized_queue -= player

				if(length(team1_players) == 4 && length(team2_players) == 4)
					break mm_loop

	if(length(team1_players) == 4 && length(team2_players) == 4)
		make_game(team1_players, team2_players)
	else
		COOLDOWN_START(src, matchmaking_cooldown, 5 SECONDS) // We redo this check every 5s until we either drop below 8 in queue or finally make a game

/datum/controller/subsystem/moba/proc/make_game(list/team1_players, list/team2_players)
	var/datum/moba_controller/new_controller = new(team1_players, team2_players, current_highest_map_id)
	controllers += new_controller
	controller_id_dict["[current_highest_map_id]"] = new_controller
	current_highest_map_id++

/datum/controller/subsystem/moba/proc/get_moba_controller(map_id)
	RETURN_TYPE(/datum/moba_controller)
	if(!map_id)
		return

	return controller_id_dict["[map_id]"]
