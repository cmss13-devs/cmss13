/datum/component/moba_action
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/datum/action/xeno_action/parent_action
	var/datum/weakref/player_datum
	var/static/mutable_appearance/level_up_overlay
	var/max_level = 3
	var/is_ultimate = FALSE

/datum/component/moba_action/Initialize(max_level, is_ultimate)
	. = ..()
	if(!istype(parent, /datum/action/xeno_action))
		return COMPONENT_INCOMPATIBLE

	parent_action = parent
	src.max_level = max_level
	src.is_ultimate = is_ultimate

	if(!level_up_overlay)
		level_up_overlay = mutable_appearance('icons/effects/techtree/tech.dmi', "upgrade")

/datum/component/moba_action/Destroy(force, silent)
	handle_qdel()
	return ..()

/datum/component/moba_action/RegisterWithParent()
	..()
	RegisterSignal(parent_action, COMSIG_PARENT_QDELETING, PROC_REF(handle_qdel))


/datum/component/moba_action/proc/handle_qdel()
	SIGNAL_HANDLER

	parent_action = null
