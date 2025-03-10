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

// Duplicating this code across /datum/action/xeno_action and /datum/action/xeno_action/activable sucks but I don't have a good alternative

/datum/action/xeno_action/moba
	var/datum/weakref/player_datum
	var/static/mutable_appearance/level_up_overlay
	var/max_level = 3
	var/is_ultimate = FALSE

/datum/action/xeno_action/moba/New(datum/moba_player/player)
	player_datum = WEAKREF(player)
	. = ..()
	if(!level_up_overlay)
		level_up_overlay = mutable_appearance('icons/effects/techtree/tech.dmi', "upgrade")

/datum/action/xeno_action/moba/can_use_action()
	var/datum/moba_player/player = player_datum.resolve()
	if(!player)
		return FALSE
	if(player.unspent_levels)
		if(is_ultimate && (player.ability_path_level_dict[type] >= player.max_ultimate_level))
			if(!player.ability_path_level_dict[type])
				return FALSE
			return ..()
		return TRUE
	if(!player.ability_path_level_dict[type])
		return FALSE
	return ..()

/datum/action/xeno_action/moba/action_activate()
	var/datum/moba_player/player = player_datum.resolve()
	if(!player)
		return ..()
	if(player.unspent_levels && (player.ability_path_level_dict[type] < max_level))
		if(is_ultimate && (player.ability_path_level_dict[type] >= player.max_ultimate_level))
			return ..()
		player.spend_level(type)
		level_up_ability()
		return FALSE
	return ..()

/datum/action/xeno_action/moba/update_button_icon()
	if(!button)
		return
	if(!can_use_action())
		button.color = rgb(128,0,0,128)
	else if(!action_cooldown_check())
		if(cooldown_timer_id == TIMER_ID_NULL)
			button.color = rgb(255,255,255,255)
		else
			button.color = rgb(240,180,0,200)
	else
		button.color = rgb(255,255,255,255)

/datum/action/xeno_action/moba/proc/start_level_up_overlay()
	var/datum/moba_player/player = player_datum.resolve()
	if(!player)
		return

	if(player.ability_path_level_dict[type] >= max_level)
		return

	button.overlays += level_up_overlay

/datum/action/xeno_action/moba/proc/stop_level_up_overlay()
	button.overlays.Cut(2) // byond bug means i can't just -= the level up overlay

/datum/action/xeno_action/moba/proc/level_up_ability(new_level)
	return


/datum/action/xeno_action/moba/onclick // god is dead
	action_type = XENO_ACTION_CLICK
	no_cooldown_msg = TRUE

/datum/action/xeno_action/moba/onclick/action_activate()
	. = ..()
	if(!.)
		return .
	use_ability_wrapper(null)





/datum/action/xeno_action/activable/moba
	var/datum/weakref/player_datum
	var/static/mutable_appearance/level_up_overlay
	var/max_level = 3
	var/is_ultimate = FALSE

/datum/action/xeno_action/activable/moba/New(datum/moba_player/player)
	player_datum = WEAKREF(player)
	. = ..()
	if(!level_up_overlay)
		level_up_overlay = mutable_appearance('icons/effects/techtree/tech.dmi', "upgrade")

/datum/action/xeno_action/activable/moba/can_use_action()
	var/datum/moba_player/player = player_datum.resolve()
	if(!player)
		return FALSE
	if(player.unspent_levels)
		if(is_ultimate && (player.ability_path_level_dict[type] >= player.max_ultimate_level))
			if(!player.ability_path_level_dict[type])
				return FALSE
			return ..()
		return TRUE
	if(!player.ability_path_level_dict[type])
		return FALSE
	return ..()

/datum/action/xeno_action/activable/moba/action_activate()
	var/datum/moba_player/player = player_datum.resolve()
	if(!player)
		return ..()
	if(player.unspent_levels && (player.ability_path_level_dict[type] < max_level))
		if(is_ultimate && (player.ability_path_level_dict[type] >= player.max_ultimate_level))
			return ..()
		player.spend_level(type)
		level_up_ability(player.ability_path_level_dict[type])
		return FALSE
	return ..()

/datum/action/xeno_action/activable/moba/update_button_icon()
	if(!button)
		return
	if(!can_use_action())
		button.color = rgb(128,0,0,128)
	else if(!action_cooldown_check())
		if(cooldown_timer_id == TIMER_ID_NULL)
			button.color = rgb(255,255,255,255)
		else
			button.color = rgb(240,180,0,200)
	else
		button.color = rgb(255,255,255,255)

/datum/action/xeno_action/activable/moba/proc/start_level_up_overlay()
	var/datum/moba_player/player = player_datum.resolve()
	if(!player)
		return

	if(player.ability_path_level_dict[type] >= max_level)
		return

	button.overlays += level_up_overlay

/datum/action/xeno_action/activable/moba/proc/stop_level_up_overlay()
	button.overlays.Cut(2) // byond bug means i can't just -= the level up overlay

/datum/action/xeno_action/activable/moba/proc/level_up_ability(new_level)
	return
