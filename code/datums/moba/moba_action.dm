// Duplicating this code across /datum/action/xeno_action and /datum/action/xeno_action/activable sucks but I don't have a good alternative

/datum/action/xeno_action/moba
	var/datum/weakref/player_datum

/datum/action/xeno_action/moba/New(datum/moba_player/player)
	. = ..()
	player_datum = WEAKREF(player)

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
	if(player.unspent_levels)
		player.spend_level(type)
		return
	return ..()

/datum/action/xeno_action/moba/proc/start_level_up_overlay()

/datum/action/xeno_action/activable/moba
	var/datum/weakref/player_datum

/datum/action/xeno_action/activable/moba/New(datum/moba_player/player)
	. = ..()
	player_datum = WEAKREF(player)

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
	if(player.unspent_levels)
		player.spend_level(type)
		return
	return ..()

/datum/action/xeno_action/activable/moba/start_level_up_overlay()
