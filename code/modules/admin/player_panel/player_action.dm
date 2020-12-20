GLOBAL_LIST_INIT(pp_actions, generate_pp_actions())
GLOBAL_LIST_INIT(pp_actions_data, generate_pp_actions_data())

/datum/player_action
	var/name
	var/action_tag
	var/permissions_required = R_MOD

	var/list/data

// usr here is set to user.mob
/datum/player_action/proc/act(var/client/user, var/mob/target, var/list/params)
	return TRUE

/proc/generate_pp_actions()
	. = list()
	for(var/I in subtypesof(/datum/player_action))
		var/datum/player_action/P = I
		if(initial(P.action_tag))
			.[initial(P.action_tag)] = new I()

/proc/generate_pp_actions_data()
	. = list()
	for(var/I in subtypesof(/datum/player_action))
		var/datum/player_action/P = I
		if(initial(P.action_tag))
			.["[initial(P.action_tag)]"] = list(
				"name" = initial(P.name),
				"action_tag" = initial(P.action_tag),
				"permissions_required" = initial(P.permissions_required)
			)
