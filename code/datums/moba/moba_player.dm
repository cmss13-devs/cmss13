// Holds data about the player that should persist for the entire game

/datum/moba_player
	var/tied_ckey
	VAR_PRIVATE/mob/living/carbon/xenomorph/tied_xeno
	var/client/tied_client
	var/list/datum/moba_player_slot/queue_slots = list()
	var/right_team = FALSE

	var/kills = 0
	var/deaths = 0
	var/list/held_item_types = list()
	var/gold = 0
	var/level = 1
	var/xp = 0

	var/list/ability_path_level_dict = list()
	var/unspent_levels = 0

/datum/moba_player/New(ckey, client/new_client)
	. = ..()
	tied_ckey = ckey
	tied_client = new_client
	RegisterSignal(new_client, COMSIG_PARENT_QDELETING, PROC_REF(on_client_delete))

/datum/moba_player/proc/on_client_delete(datum/source)
	SIGNAL_HANDLER

	qdel(src)

/datum/moba_player/Destroy(force, ...)
	tied_client = null
	tied_xeno = null
	QDEL_NULL_LIST(queue_slots)
	return ..()

/datum/moba_player/proc/get_tied_xeno()
	RETURN_TYPE(/mob/living/carbon/xenomorph)
	return tied_xeno

/datum/moba_player/proc/set_tied_xeno(mob/living/carbon/xenomorph/xeno)
	tied_xeno = xeno
	if(tied_xeno && unspent_levels)
		for(var/datum/action/action as anything in tied_xeno.actions)
			if(istype(action, /datum/action/xeno_action/moba))
				var/datum/action/xeno_action/moba/moba_action = action
				moba_action.start_level_up_overlay()
			else if(istype(action, /datum/action/xeno_action/activable/moba))
				var/datum/action/xeno_action/activable/moba/moba_action = action
				moba_action.start_level_up_overlay()

/datum/moba_player/proc/level_up()
	level++
	unspent_levels++
	if(tied_xeno)
		for(var/datum/action/action as anything in tied_xeno.actions)
			if(istype(action, /datum/action/xeno_action/moba))
				var/datum/action/xeno_action/moba/moba_action = action
				moba_action.start_level_up_overlay()
			else if(istype(action, /datum/action/xeno_action/activable/moba))
				var/datum/action/xeno_action/activable/moba/moba_action = action
				moba_action.start_level_up_overlay()

/datum/moba_player/proc/spend_level(path)
	ability_path_level_dict[path]++
	unspent_levels--
	if(tied_xeno)
		for(var/datum/action/action as anything in tied_xeno.actions)
			if(istype(action, /datum/action/xeno_action/moba))
				var/datum/action/xeno_action/moba/moba_action = action
				if((ability_path_level_dict[action.type] >= moba_action.max_level) || !unspent_levels)
					moba_action.stop_level_up_overlay()
			else if(istype(action, /datum/action/xeno_action/activable/moba))
				var/datum/action/xeno_action/activable/moba/moba_action = action
				if((ability_path_level_dict[action.type] >= moba_action.max_level) || !unspent_levels)
					moba_action.stop_level_up_overlay()
