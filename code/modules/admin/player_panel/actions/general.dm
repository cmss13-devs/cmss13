// DAMAGE
/datum/player_action/rejuvenate
	action_tag = "mob_rejuvenate"
	name = "Rejuvenate"

/datum/player_action/rejuvenate/act(var/client/user, var/mob/target, var/list/params)
	user.cmd_admin_rejuvenate(target)
	return TRUE


/datum/player_action/kill
	action_tag = "mob_kill"
	name = "Kill"

/datum/player_action/kill/act(var/client/user, var/mob/target, var/list/params)
	target.death("[user.key]")
	message_staff("[key_name_admin(user)] killed [key_name_admin(target)].")
	return TRUE


/datum/player_action/gib
	action_tag = "mob_gib"
	name = "Gib"
	permissions_required = R_FUN

/datum/player_action/gib/act(var/client/user, var/mob/target, var/list/params)
	target.gib("[user.key]")
	message_staff("[key_name_admin(user)] gibbed [key_name_admin(target)].")
	return TRUE

// MISC
/datum/player_action/mob_sleep
	action_tag = "mob_sleep"
	name = "Toggle Sleeping"

/datum/player_action/mob_sleep/act(var/client/user, var/mob/target, var/list/params)
	if (!params["sleep"]) //if they're already slept, set their sleep to zero and remove the icon
		target.sleeping = 0
		target.RemoveSleepingIcon()
	else
		target.sleeping = 9999999 //if they're not, sleep them and add the sleep icon, so other marines nearby know not to mess with them.
		target.AddSleepingIcon()

	message_staff("[key_name_admin(user)] toggled sleep on [key_name_admin(target)].")

	return TRUE


/datum/player_action/send_to_lobby
	action_tag = "send_to_lobby"
	name = "Send To Lobby"

/datum/player_action/send_to_lobby/act(var/client/user, var/mob/target, var/list/params)
	if(!isobserver(target))
		to_chat(user, SPAN_NOTICE("You can only send ghost players back to the Lobby."))
		return

	if(!target.client)
		to_chat(user, SPAN_WARNING("[target.name] doesn't seem to have an active client."))
		return

	if(alert(user, "Send [key_name(target)] back to Lobby?", "Message", "Yes", "No") != "Yes")
		return

	message_staff("[key_name_admin(user)] has sent [key_name_admin(target)] back to the Lobby.")

	var/mob/new_player/NP = new()

	if(!target.mind)
		target.mind_initialize()

	target.mind.transfer_to(NP)

	qdel(target)
	return TRUE


/datum/player_action/force_say
	action_tag = "mob_force_say"
	name = "Force Say"
	permissions_required = R_FUN

/datum/player_action/force_say/act(var/client/user, var/mob/target, var/list/params)
	if(!params["to_say"]) return

	target.say(params["to_say"])

	message_staff("[key_name_admin(user)] forced [key_name_admin(target)] to say: [sanitize(params["to_say"])]")

	return TRUE


/datum/player_action/force_emote
	action_tag = "mob_force_emote"
	name = "Force Emote"
	permissions_required = R_FUN

/datum/player_action/force_emote/act(var/client/user, var/mob/target, var/list/params)
	if(!params["to_emote"]) return

	target.custom_emote(1, params["to_emote"], TRUE)

	message_staff("[key_name_admin(user)] forced [key_name_admin(target)] to emote: [sanitize(params["to_emote"])]")
	return TRUE


/datum/player_action/toggle_frozen
	action_tag = "toggle_frozen"
	name = "Toggle Frozen"

/datum/player_action/toggle_frozen/act(var/client/user, var/mob/target, var/list/params)
	target.frozen = text2num(params["freeze"])

	message_staff("[key_name_admin(user)] [target.frozen? "froze" : "unfroze"] [key_name_admin(target)]")
	return TRUE

// MESSAGE
/datum/player_action/subtle_message
	action_tag = "subtle_message"
	name = "Subtle Message"

/datum/player_action/subtle_message/act(var/client/user, var/mob/target, var/list/params)
	user.cmd_admin_subtle_message(target)
	return TRUE


/datum/player_action/private_message
	action_tag = "private_message"
	name = "Private Message"

/datum/player_action/private_message/act(var/client/user, var/mob/target, var/list/params)
	if(!target.client)
		return

	user.cmd_admin_pm(target.client)
	return TRUE

// SET NAME/CKEY
/datum/player_action/set_name
	action_tag = "set_name"
	name = "Set Name"

/datum/player_action/set_name/act(var/client/user, var/mob/target, var/list/params)
	target.name = params["name"]
	message_staff("[key_name_admin(user)] set [key_name_admin(target)]'s name to [params["name"]]")
	return TRUE

/datum/player_action/set_ckey
	action_tag = "set_ckey"
	name = "Set ckey"

/datum/player_action/set_ckey/act(var/client/user, var/mob/target, var/list/params)
	if(params["ckey"] == "")
		params["ckey"] = " "

	user.change_ckey(target, params["ckey"])
	return TRUE

// TELEPORTATION
/datum/player_action/bring
	action_tag = "mob_bring"
	name = "Bring"


/datum/player_action/bring/act(var/client/user, var/mob/target, var/list/params)
	var/mob/M = user.mob

	target.forceMove(M.loc)
	message_staff("[key_name_admin(user)] teleported [key_name_admin(target)] to themselves.", M.loc.x, M.loc.y, M.loc.z)
	return TRUE


/datum/player_action/jump_to
	action_tag = "jump_to"
	name = "Jump To"


/datum/player_action/jump_to/act(var/client/user, var/mob/target, var/list/params)
	user.jumptomob(target)
	return TRUE


// VIEW VARIABLES
/datum/player_action/access_variables
	action_tag = "access_variables"
	name = "Access Variables"


/datum/player_action/access_variables/act(var/client/user, var/mob/target, var/list/params)
	user.debug_variables(target)
	return TRUE


/datum/player_action/access_admin_datum
	action_tag = "access_admin_datum"
	name = "Access Admin Datum"

/datum/player_action/access_admin_datum/act(var/client/user, var/mob/target, var/list/params)
	if(!target.client || !target.client.admin_holder)
		return

	user.debug_variables(target.client.admin_holder)
	return TRUE
