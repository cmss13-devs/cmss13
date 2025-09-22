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
