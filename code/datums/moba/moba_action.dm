// Duplicating this code across /datum/action/xeno_action and /datum/action/xeno_action/activable sucks but I don't have a good alternative

/datum/action/xeno_action/moba
	var/datum/weakref/player_datum
	var/static/mutable_appearance/level_up_overlay
	var/max_level = 3

/datum/action/xeno_action/moba/New(datum/moba_player/player)
	player_datum = WEAKREF(player)
	. = ..()
	if(!level_up_overlay)
		level_up_overlay = mutable_appearance('icons/effects/techtree/tech.dmi', "upgrade")

/datum/action/xeno_action/moba/can_use_action()
	var/datum/moba_player/player = player_datum.resolve()
	if(!player)
		return ..()
	if(player.unspent_levels)
		return TRUE
	if(!player.ability_path_level_dict[type])
		return FALSE
	return ..()

/datum/action/xeno_action/moba/action_activate()
	var/datum/moba_player/player = player_datum.resolve()
	if(!player)
		return ..()
	if(player.unspent_levels && (player.ability_path_level_dict[type] < max_level))
		player.spend_level(type)
		level_up_ability()
		return
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
	use_ability_wrapper(null)





/datum/action/xeno_action/activable/moba
	var/datum/weakref/player_datum
	var/static/mutable_appearance/level_up_overlay
	var/max_level = 3

/datum/action/xeno_action/activable/moba/New(datum/moba_player/player)
	player_datum = WEAKREF(player)
	. = ..()
	if(!level_up_overlay)
		level_up_overlay = mutable_appearance('icons/effects/techtree/tech.dmi', "upgrade")

/datum/action/xeno_action/activable/moba/can_use_action()
	var/datum/moba_player/player = player_datum.resolve()
	if(!player)
		return ..()
	if(player.unspent_levels)
		return TRUE
	if(!player.ability_path_level_dict[type])
		return FALSE
	return ..()

/datum/action/xeno_action/activable/moba/action_activate()
	var/datum/moba_player/player = player_datum.resolve()
	if(!player)
		return ..()
	if(player.unspent_levels && (player.ability_path_level_dict[type] < max_level))
		player.spend_level(type)
		level_up_ability(player.ability_path_level_dict[type])
		return
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
