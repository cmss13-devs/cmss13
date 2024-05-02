
/datum/game_mode/colonialmarines
	required_players = 2
	population_min = 10

/* Pre-pre-startup */
/datum/game_mode/colonialmarines/can_start(bypass_checks = FALSE)
	if(!bypass_checks)
		var/list/datum/mind/possible_xenomorphs = get_players_for_role(JOB_XENOMORPH)
		var/list/datum/mind/possible_queens = get_players_for_role(JOB_XENOMORPH_QUEEN)
		if(possible_xenomorphs.len + possible_queens.len < xeno_required_num) //We don't have enough aliens, we don't consider people rolling for only Queen.
			to_world("Not enough players have chosen to be a xenomorph in their character setup. <b>Aborting</b>.")
			return FALSE

		var/players = 0
		for(var/mob/new_player/player in GLOB.new_player_list)
			if(player.client && player.ready)
				players++

		if(players < required_players)
			return FALSE

	initialize_special_clamps()
	return TRUE
