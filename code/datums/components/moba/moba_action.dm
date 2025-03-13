/// Only relevant for moba abilities, should be overriden
/datum/action/xeno_action/proc/level_up_ability(new_level)
	return

/datum/component/moba_action
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/datum/action/xeno_action/parent_action
	var/datum/weakref/player_datum
	var/static/mutable_appearance/level_up_overlay
	var/max_level = 3
	var/is_ultimate = FALSE

/datum/component/moba_action/Initialize(max_level, is_ultimate, datum/moba_player/player_datum)
	. = ..()
	if(!istype(parent, /datum/action/xeno_action))
		return COMPONENT_INCOMPATIBLE

	parent_action = parent
	parent_action.no_timer_color = rgb(255,255,255,255)
	src.max_level = max_level
	src.is_ultimate = is_ultimate
	src.player_datum = WEAKREF(player_datum)

	if(!level_up_overlay)
		level_up_overlay = mutable_appearance('icons/effects/techtree/tech.dmi', "upgrade")

/datum/component/moba_action/Destroy(force, silent)
	handle_qdel()
	return ..()

/datum/component/moba_action/RegisterWithParent()
	..()
	RegisterSignal(parent_action, COMSIG_PARENT_QDELETING, PROC_REF(handle_qdel))
	RegisterSignal(parent_action, COMSIG_XENO_ACTION_TRY_CAN_USE, PROC_REF(on_can_action_use))
	RegisterSignal(parent_action, COMSIG_ACTION_ACTIVATED, PROC_REF(on_action_activate))
	RegisterSignal(parent_action, COMSIG_MOBA_ACTION_ADD_LEVELUP, PROC_REF(start_level_up_overlay))
	RegisterSignal(parent_action, COMSIG_MOBA_ACTION_REMOVE_LEVELUP, PROC_REF(stop_level_up_overlay))

/datum/component/moba_action/proc/handle_qdel()
	SIGNAL_HANDLER

	parent_action = null

/datum/component/moba_action/proc/on_can_action_use(datum/source, mob/living/carbon/xenomorph/xeno)
	SIGNAL_HANDLER

	var/datum/moba_player/player = player_datum.resolve()
	if(!player)
		return COMPONENT_BLOCK_ACTION_USE
	if(player.unspent_levels)
		if(is_ultimate && (player.ability_path_level_dict[type] >= player.max_ultimate_level))
			if(!player.ability_path_level_dict[type])
				return COMPONENT_BLOCK_ACTION_USE
			return
		return
	if(!player.ability_path_level_dict[type])
		return COMPONENT_BLOCK_ACTION_USE

/datum/component/moba_action/proc/on_action_activate(datum/source)
	SIGNAL_HANDLER

	var/datum/moba_player/player = player_datum.resolve()
	if(!player)
		return
	if(player.unspent_levels && (player.ability_path_level_dict[type] < max_level))
		if(is_ultimate && (player.ability_path_level_dict[type] >= player.max_ultimate_level))
			return
		player.spend_level(type)
		parent_action.level_up_ability(player.ability_path_level_dict[type])
		return COMPONENT_BLOCK_ACTIVATION

/datum/component/moba_action/proc/start_level_up_overlay(datum/source)
	SIGNAL_HANDLER

	var/datum/moba_player/player = player_datum.resolve()
	if(!player)
		return

	if(player.ability_path_level_dict[type] >= max_level)
		return

	if(is_ultimate && (player.ability_path_level_dict[parent_action.type] >= player.max_ultimate_level))
		return

	parent_action.button.overlays += level_up_overlay

/datum/component/moba_action/proc/stop_level_up_overlay(datum/source)
	SIGNAL_HANDLER

	var/datum/moba_player/player = player_datum.resolve()
	if(!player)
		return

	if((player.ability_path_level_dict[parent_action.type] >= max_level) || !player.unspent_levels)
		parent_action.button.overlays.Cut(2) // byond bug means i can't just -= the level up overlay
