
/datum/game_mode/show_end_statistics(icon_state)
	. = ..()
	for(var/mob/M in GLOB.player_list)
		if(M.client)
			M.view_round_stats()
			give_action(M, /datum/action/show_personal_round_stats, null, icon_state)

/datum/action/show_personal_round_stats
	name = "Посмотреть персональную статистику за раунд"

/datum/action/show_personal_round_stats/can_use_action()
	if(!..())
		return FALSE

	if(!owner.client)
		return FALSE

	return TRUE

/datum/action/show_personal_round_stats/action_activate()
	. = ..()
	if(!can_use_action())
		return

	owner.view_round_stats()
