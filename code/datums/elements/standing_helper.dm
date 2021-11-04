//Lets a mob help another mob stand by grabbing
/datum/element/standing_helper

/datum/element/standing_helper/Attach(datum/target)
	. = ..()
	var/mob/M = target
	if(!istype(M) || !ismob(M.pulling))
		return ELEMENT_INCOMPATIBLE
	var/mob/pulled = M.pulling

	ADD_TRAIT(M.pulling, TRAIT_ADDITIONAL_STAND_SUPPORT, TRAIT_SOURCE_HELP_ACTION)
	pulled.update_can_stand()
	RegisterSignal(target, COMSIG_MOB_STOPPED_PULLING, .proc/let_go)

//Mob will stop pulling when deleted, so this catches all detach conditions
/datum/element/standing_helper/proc/let_go(target, mob/prev_helped)
	REMOVE_TRAIT(prev_helped, TRAIT_ADDITIONAL_STAND_SUPPORT, TRAIT_SOURCE_HELP_ACTION)
	UnregisterSignal(target, COMSIG_MOB_STOPPED_PULLING)
	prev_helped.update_can_stand()
	Detach(target)


