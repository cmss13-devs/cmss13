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
	/// Dict for items to pass data between lives
	var/list/held_item_pass_data = list()
	var/unspent_levels = 1
	var/max_ultimate_level = 0
	/// How many minions / camps (4 CS/camp) we've killed
	var/creep_score = 0

/datum/moba_player/New(ckey, client/new_client)
	. = ..()
	tied_ckey = ckey
	tied_client = new_client
	RegisterSignal(new_client, COMSIG_PARENT_QDELETING, PROC_REF(on_client_delete))

/datum/moba_player/proc/on_client_delete(datum/source)
	SIGNAL_HANDLER

	tied_ckey = null
	tied_client = null

/datum/moba_player/Destroy(force, ...)
	on_client_delete()
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
			SEND_SIGNAL(action, COMSIG_MOBA_ACTION_ADD_LEVELUP)

/datum/moba_player/proc/level_up()
	level++
	unspent_levels++
	if((level == 4) || (level == 8) || (level == 12))
		max_ultimate_level++
	if(tied_xeno)
		for(var/datum/action/action as anything in tied_xeno.actions)
			SEND_SIGNAL(action, COMSIG_MOBA_ACTION_ADD_LEVELUP)

/datum/moba_player/proc/spend_level(path)
	ability_path_level_dict[path]++
	unspent_levels--
	if(tied_xeno)
		for(var/datum/action/action as anything in tied_xeno.actions)
			SEND_SIGNAL(action, COMSIG_MOBA_ACTION_REMOVE_LEVELUP)
