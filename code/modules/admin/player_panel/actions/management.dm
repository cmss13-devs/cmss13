/datum/player_action/nameless_ban
	action_tag = "nameless_ban"
	name = "Nameless Ban"
	permissions_required = R_PERMISSIONS

/datum/player_action/nameless_ban/act(client/user, mob/target, list/params)
	user.cmd_admin_do_ban(target)
	return TRUE


/datum/player_action/perma_ban
	action_tag = "perma_ban"
	name = "Permanent Ban"
	permissions_required = R_PERMISSIONS

/datum/player_action/perma_ban/act(client/user, mob/target, list/params)
	user.cmd_admin_do_ban(target)
	return TRUE
