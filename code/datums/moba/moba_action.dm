/datum/action/open_moba_scoreboard
	name = "Open Scoreboard"
	action_icon_state = "vote"
	var/map_id

/datum/action/open_moba_scoreboard/New(map_id)
	. = ..()
	src.map_id = map_id

/datum/action/open_moba_scoreboard/action_activate()
	. = ..()
	SSmoba.get_moba_controller(map_id).scoreboard.tgui_interact(owner)


/datum/action/level_up_ability
	name = "Level Up Ability"
	action_icon_state = "upgrade"

/datum/action/level_up_ability/New(map_id)
	. = ..()

/datum/action/level_up_ability/action_activate()
	. = ..()
	var/list/player_list = list()
	SEND_SIGNAL(owner, COMSIG_MOBA_GET_PLAYER_DATUM, player_list)
	if(!length(player_list))
		return

	var/datum/moba_player/player = player_list[1]
	if(!player.unspent_levels)
		return

	var/list/input_dict = list()
	for(var/datum/action/xeno_action/action in owner.actions)
		var/datum/component/moba_action/action_comp = action.GetComponent(/datum/component/moba_action)
		if(!action_comp)
			continue

		if(player.ability_path_level_dict[action.type] >= action_comp.max_level)
			continue

		if(action_comp.is_ultimate && (player.ability_path_level_dict[action.type] >= player.max_ultimate_level))
			continue

		input_dict["[action.name] ([player.ability_path_level_dict[action.type]]/[action_comp.max_level])"] = action

	if(!length(input_dict))
		to_chat(owner, SPAN_XENOWARNING("You have no abilities to level up!"))
		return

	var/output = tgui_input_list(owner, "Level up which ability?", "Level Up", input_dict)
	if(!output)
		return

	var/datum/action/xeno_action/chosen_action = input_dict[output]
	if(!chosen_action)
		return

	player.spend_level(chosen_action.type)
	chosen_action.level_up_ability(player.ability_path_level_dict[chosen_action.type])
	to_chat(owner, SPAN_XENONOTICE("[capitalize(chosen_action.name)] levelled up to [player.ability_path_level_dict[chosen_action.type]]."))
	if(!player.unspent_levels)
		remove_action(owner, type)
