/datum/action/ghost
	name = "Ghost"
	action_icon_state = "ghost"

/datum/action/ghost/action_activate()
	. = ..()
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

/datum/action/ghost/xeno
	action_icon_state = "ghost_xeno"

/datum/action/join_ert
	name = "Join ERT"
	action_icon_state = "join_ert"
	listen_signal = COMSIG_KB_OBSERVER_JOIN_ERT

/datum/action/join_ert/New(Target, override_icon_state)
	. = ..()
	RegisterSignal(Target, COMSIG_ERT_SETUP, PROC_REF(cleanup))

/datum/action/join_ert/proc/cleanup()
	SIGNAL_HANDLER
	qdel(src)

/datum/action/join_ert/action_activate()
	. = ..()
	if(!owner.client)
		return

	var/mob/dead/observer/activator = owner
	activator.do_join_response_team()

/datum/action/join_predator
	name = "Join the Hunt"
	action_icon_state = "join_pred"
	listen_signal = COMSIG_KB_OBSERVER_JOIN_PREDATOR

/datum/action/join_predator/action_activate()
	. = ..()
	var/mob/dead/observer/activator = owner
	activator.join_as_yautja()

/datum/action/observer_action/view_crew_manifest
	name = "View Crew Manifest"
	action_icon_state = "view_crew_manifest"

/datum/action/observer_action/view_crew_manifest/action_activate()
	. = ..()
	show_browser(owner, GLOB.data_core.get_manifest(), "Crew Manifest", "manifest", "size=450x750")

/datum/action/observer_action/view_hive_status
	name = "View Hive Status"
	action_icon_state = "view_hive_status"

/datum/action/observer_action/view_hive_status/action_activate()
	. = ..()
	var/mob/dead/observer/activator = owner
	activator.hive_status()

/datum/action/observer_action/join_xeno
	name = "Join as Xeno"
	action_icon_state = "join_xeno"
	listen_signal = COMSIG_KB_OBSERVER_JOIN_XENO

/datum/action/observer_action/join_xeno/action_activate()
	. = ..()
	if(!owner.client)
		return

	if(SSticker.current_state < GAME_STATE_PLAYING || !SSticker.mode)
		owner.balloon_alert(owner, "game must start!")
		return

	if(SSticker.mode.check_xeno_late_join(owner))
		SSticker.mode.attempt_to_join_as_xeno(owner)

/datum/action/observer_action/join_lesser_drone
	name = "Join as Lesser Drone"
	action_icon_state = "join_lesser_drone"
	listen_signal = COMSIG_KB_OBSERVER_JOIN_LESSER_DRONE

/datum/action/observer_action/join_lesser_drone/action_activate()
	. = ..()
	if(!owner.client)
		return

	if(SSticker.current_state < GAME_STATE_PLAYING || !SSticker.mode)
		owner.balloon_alert(owner, "game must start!")
		return

	if(SSticker.mode.check_xeno_late_join(owner))
		SSticker.mode.attempt_to_join_as_lesser_drone(owner)

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

/datum/keybinding/observer/join_ert
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "join_ert"
	full_name = "Join ERT"
	keybind_signal = COMSIG_KB_OBSERVER_JOIN_ERT

/datum/keybinding/observer/join_pred
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "join_pred"
	full_name = "Join the Hunt"
	keybind_signal = COMSIG_KB_OBSERVER_JOIN_PREDATOR

/datum/keybinding/observer/join_lesser_drone
	hotkey_keys = list("Unbound")
	classic_keys = list("Unbound")
	name = "join_lesser_drone"
	full_name = "Join as Lesser Drone"
	keybind_signal = COMSIG_KB_OBSERVER_JOIN_LESSER_DRONE
