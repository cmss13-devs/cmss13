/datum/action/ghost
	name = "Ghost"
	action_icon_state = "ghost"

/datum/action/ghost/action_activate()
	if(!owner.client)
		return

	var/mob/living/activator = owner

	activator.do_ghost()

/datum/action/ghost/give_to(mob/L)
	. = ..()

	RegisterSignal(L, COMSIG_MOB_STAT_SET_ALIVE, PROC_REF(remove_ghost))

/// signal handler to remove the ghost button when someone's not so dead
/datum/action/ghost/proc/remove_ghost(mob/user)
	SIGNAL_HANDLER

	INVOKE_ASYNC(src, PROC_REF(remove_from), user)

/datum/action/observer_action/join_xeno
	name = "Join as Xeno"
	action_icon_state = "join_xeno"
	listen_signal = COMSIG_KB_OBSERVER_JOIN_XENO

/datum/action/observer_action/join_xeno/action_activate()
	if(!owner.client)
		return

	if(SSticker.current_state < GAME_STATE_PLAYING || !SSticker.mode)
		owner.balloon_alert(owner, "game must start!")
		return

	if(SSticker.mode.check_xeno_late_join(owner))
		SSticker.mode.attempt_to_join_as_xeno(owner)

/datum/keybinding/observer
	category = CATEGORY_OBSERVER
	weight = WEIGHT_DEAD

/datum/keybinding/observer/can_use(client/user)
	return isobserver(user?.mob)

/datum/keybinding/observer/join_as_xeno
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "join_as_xeno"
	full_name = "Join as Xeno"
	keybind_signal = COMSIG_KB_OBSERVER_JOIN_XENO
