/mob/verb/view_round_stats()
	set name = "View My Stats"
	set category = "OOC"

	if(!client)
		return
	if(stat != DEAD && SSticker.current_state != GAME_STATE_FINISHED)
		to_chat(src, SPAN_WARNING("Вы можете посмотреть статистику только будучи мертвым, или когда раунд закончился!"))
		return
	var/datum/round_stats/round_stats = new()
	round_stats.tgui_interact(src)

/datum/round_stats

/datum/round_stats/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "RoundStats", "Round Stats")
		ui.open()

/datum/round_stats/ui_close(mob/user)
	. = ..()
	qdel(src)

/datum/round_stats/ui_state(mob/user)
	return GLOB.always_state

/datum/round_stats/ui_static_data(mob/user)
	var/list/data = list()
	var/datum/entity/player_entity/player_entity = GLOB.player_entities["[user.ckey]"]
	if(!player_entity)
		to_chat(user, SPAN_WARNING("Что-то произошло не так при попытке получения ваших данных, позовите кодера!"))
		qdel(src)
	data = player_entity.get_player_round_stat()
	if(!length(data))
		to_chat(user, SPAN_WARNING("Вам нужно участвовать в игре, чтобы получить данные о себе!"))
		qdel(src)
	return data

// Player's holder, has data for all the player's characters who participated in the round
/datum/entity/player_entity/proc/get_player_round_stat()
	if(!length(player_stats))
		return
	var/list/data = list()
	for(var/key in player_stats)
		var/datum/entity/player_stats/stats = player_stats[key]
		data["stats"] += list(stats.get_player_stat())
	return data

// Per faction player's stats for who participated in the round. Linked to a specific player
/datum/entity/player_stats/proc/get_player_stat()
	var/list/data = list()
	data["title"] = "CALL THE CODER"
	data["total_kills"] = total_kills
	data["total_deaths"] = total_deaths
	data["steps_walked"] = steps_walked
	data["humans_killed"] = length(humans_killed)
	data["xenos_killed"] = length(xenos_killed)
	return data

/datum/entity/player_stats/human/get_player_stat()
	var/list/data = ..()
	data["title"] = "Human"
	data["total_friendly_fire"] = total_friendly_fire
	data["total_revives"] = total_revives
	data["total_lives_saved"] = total_lives_saved
	data["total_shots"] = total_shots
	data["total_shots_hit"] = total_shots_hit
	// TODO220: Show per job (mob)
	return data

/datum/entity/player_stats/xeno/get_player_stat()
	var/list/data = ..()
	data["title"] = "Xeno"
	data["total_hits"] = total_hits
	// TODO220: Show per caste (mob)
	return data

// show_end_statistics
