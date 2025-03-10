/datum/moba_scoreboard
	var/map_id

/datum/moba_scoreboard/New(map_id)
	. = ..()
	src.map_id = map_id

/datum/moba_scoreboard/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MobaScoreboard")
		ui.open()

/datum/moba_scoreboard/ui_state(mob/user)
	return GLOB.conscious_state

/datum/moba_scoreboard/ui_assets(mob/user)
	return list(
		get_asset_datum(/datum/asset/spritesheet/moba_items),
		get_asset_datum(/datum/asset/spritesheet/moba_castes),
	)

/datum/moba_scoreboard/ui_data(mob/user)
	var/list/data = list()

	data["team1_total_kills"] = 0
	data["team2_total_kills"] = 0

	data["team1_players"] = list()
	data["team2_players"] = list()
	var/datum/moba_controller/controller = SSmoba.get_moba_controller(map_id)
	for(var/datum/moba_queue_player/player_data as anything in controller.team1_data)
		var/list/item_list = list()
		for(var/datum/moba_item/item_path as anything in player_data.player.held_item_types)
			item_list += list(list(
				"name" = item_path::name,
				"desc" = GLOB.moba_item_desc_dict[item_path],
				"icon_state" = item_path::icon_state
			))
		data["team1_players"] += list(list(
			"name" = player_data.player.get_tied_xeno().full_designation,
			"caste" = player_data.caste.name,
			"caste_icon" = player_data.caste.icon_state,
			"kills" = player_data.player.kills,
			"deaths" = player_data.player.deaths,
			"level" = player_data.player.level,
			"items" = item_list,
		))
		data["team1_total_kills"] += player_data.player.kills

	for(var/datum/moba_queue_player/player_data as anything in controller.team2_data)
		var/list/item_list = list()
		for(var/datum/moba_item/item_path as anything in player_data.player.held_item_types)
			item_list += list(list(
				"name" = item_path::name,
				"desc" = GLOB.moba_item_desc_dict[item_path],
				"icon_state" = item_path::icon_state
			))
		data["team2_players"] += list(list(
			"name" = player_data.player.get_tied_xeno().full_designation,
			"caste" = player_data.caste.name,
			"caste_icon" = player_data.caste.icon_state,
			"kills" = player_data.player.kills,
			"deaths" = player_data.player.deaths,
			"level" = player_data.player.level,
			"items" = item_list,
		))
		data["team2_total_kills"] += player_data.player.kills

	return data
