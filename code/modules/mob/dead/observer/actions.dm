/datum/action/observer_action/join_xeno
	name = "Join as Xeno"
	action_icon_state = "join_xeno"
	listen_signal = COMSIG_KB_OBSERVER_JOIN_XENO

/datum/action/observer_action/join_xeno/action_activate()
	if(!owner.client)
		return

	if(SSticker.current_state < GAME_STATE_PLAYING || !SSticker.mode)
		owner.balloon_alert(owner, "game must start!")
		to_chat(owner, SPAN_WARNING("The game hasn't started yet!"))
		return

	if(SSticker.mode.check_xeno_late_join(owner))
		SSticker.mode.attempt_to_join_as_xeno(owner)

/datum/keybinding/observer
	category = CATEGORY_OBSERVER
	weight = WEIGHT_DEAD

/datum/keybinding/observer/can_use(client/user)
	if(!isobserver(user?.mob))
		return FALSE
	return TRUE

/datum/keybinding/observer/join_as_xeno
	hotkey_keys = list()
	classic_keys = list()
	name = "join_as_xeno"
	full_name = "Join as Xeno"
	keybind_signal = COMSIG_KB_OBSERVER_JOIN_XENO
