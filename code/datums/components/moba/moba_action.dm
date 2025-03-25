/// Only relevant for moba abilities, should be overriden
/datum/action/xeno_action/proc/level_up_ability(new_level)
	return

/datum/component/moba_action
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/datum/action/xeno_action/parent_action
	var/datum/weakref/player_datum
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

/datum/component/moba_action/Destroy(force, silent)
	handle_qdel()
	return ..()

/datum/component/moba_action/RegisterWithParent()
	..()
	RegisterSignal(parent_action, COMSIG_PARENT_QDELETING, PROC_REF(handle_qdel))
	RegisterSignal(parent_action, COMSIG_XENO_ACTION_TRY_CAN_USE, PROC_REF(on_can_action_use))

/datum/component/moba_action/proc/handle_qdel()
	SIGNAL_HANDLER

	parent_action = null

/datum/component/moba_action/proc/on_can_action_use(datum/source, mob/living/carbon/xenomorph/xeno)
	SIGNAL_HANDLER

	var/datum/moba_player/player = player_datum.resolve()
	if(!player)
		return COMPONENT_BLOCK_ACTION_USE

	if(!player.ability_path_level_dict[parent.type])
		return COMPONENT_BLOCK_ACTION_USE

