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

/datum/player_action/ban_staff
	action_tag = "ban_staff"
	name = "Ban Staff"
	permissions_required = R_PERMISSIONS

/datum/player_action/ban_staff/act(client/user, mob/target, list/params)
	user.cmd_admin_do_ban(target)
	return TRUE


/datum/player_action/shadowban
	action_tag = "shadow_ban"
	name = "Shadow Ban"
	permissions_required = R_PERMISSIONS

/datum/player_action/shadowban/act(client/user, mob/target, list/params)
	user.cmd_admin_do_ban(target)
	return TRUE
