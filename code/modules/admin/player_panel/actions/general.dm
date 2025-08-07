// DAMAGE
/datum/player_action/rejuvenate
	action_tag = "mob_rejuvenate"
	name = "Rejuvenate"

/datum/player_action/rejuvenate/act(client/user, mob/target, list/params)
	user.cmd_admin_rejuvenate(target)
	return TRUE


/datum/player_action/kill
	action_tag = "mob_kill"
	name = "Kill"

/datum/player_action/kill/act(client/user, mob/target, list/params)
	target.death(create_cause_data("[user.key]"))
	message_admins("[key_name_admin(user)] killed [key_name_admin(target)].")
	return TRUE


/datum/player_action/gib
	action_tag = "mob_gib"
	name = "Gib"
	permissions_required = R_ADMIN

/datum/player_action/gib/act(client/user, mob/target, list/params)
	target.gib(create_cause_data("gibbing", user.key))
	message_admins("[key_name_admin(user)] gibbed [key_name_admin(target)].")
	return TRUE

// MISC
/datum/player_action/mob_sleep
	action_tag = "mob_sleep"
	name = "Toggle Sleeping"

/datum/player_action/mob_sleep/act(client/user, mob/target, list/params)
	if(!istype(target, /mob/living))
		return TRUE
	var/mob/living/living = target

	if (!params["sleep"]) //if they're already slept, set their sleep to zero and remove the icon
		living.sleeping = 0
		living.RemoveSleepingIcon()
	else
		living.sleeping = 9999999 //if they're not, sleep them and add the sleep icon, so other marines nearby know not to mess with them.
		living.AddSleepingIcon()

	message_admins("[key_name_admin(user)] toggled sleep on [key_name_admin(target)].")

	return TRUE


/datum/player_action/send_to_lobby
	action_tag = "send_to_lobby"
	name = "Send To Lobby"

/datum/player_action/send_to_lobby/act(client/user, mob/target, list/params)
	if(!isobserver(target))
		to_chat(user, SPAN_NOTICE("You can only send ghost players back to the Lobby."))
		return

	if(!target.client)
		to_chat(user, SPAN_WARNING("[target.name] doesn't seem to have an active client."))
		return

	if(alert(user, "Send [key_name(target)] back to Lobby?", "Message", "Yes", "No") != "Yes")
		return

	message_admins("[key_name_admin(user)] has sent [key_name_admin(target)] back to the Lobby.")

	target.send_to_lobby()
	return TRUE

/datum/player_action/force_say
	action_tag = "mob_force_say"
	name = "Force Say"
	permissions_required = R_ADMIN

/datum/player_action/force_say/act(client/user, mob/target, list/params)
	if(!params["to_say"])
		return

	target.say(params["to_say"])

	message_admins("[key_name_admin(user)] forced [key_name_admin(target)] to say: [sanitize(params["to_say"])]")

	return TRUE


/datum/player_action/force_emote
	action_tag = "mob_force_emote"
	name = "Force Emote"
	permissions_required = R_ADMIN

/datum/player_action/force_emote/act(client/user, mob/target, list/params)
	if(!params["to_emote"])
		return

	target.manual_emote(params["to_emote"])

	message_admins("[key_name_admin(user)] forced [key_name_admin(target)] to emote: [sanitize(params["to_emote"])]")
	return TRUE


/datum/player_action/toggle_frozen
	action_tag = "toggle_frozen"
	name = "Toggle Frozen"

/datum/player_action/toggle_frozen/act(client/user, mob/target, list/params)
	var/frozen = text2num(params["freeze"])
	if(frozen)
		ADD_TRAIT(target, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ADMIN)
	else
		REMOVE_TRAIT(target, TRAIT_IMMOBILIZED, TRAIT_SOURCE_ADMIN)

	message_admins("[key_name_admin(user)] [frozen? "froze" : "unfroze"] [key_name_admin(target)]")
	return TRUE

// MESSAGE
/datum/player_action/subtle_message
	action_tag = "subtle_message"
	name = "Subtle Message"

/datum/player_action/subtle_message/act(client/user, mob/target, list/params)
	user.cmd_admin_subtle_message(target)
	return TRUE


/datum/player_action/private_message
	action_tag = "private_message"
	name = "Private Message"

/datum/player_action/private_message/act(client/user, mob/target, list/params)
	if(!target.client)
		return

	user.cmd_admin_pm(target.client)
	return TRUE

/datum/player_action/alert_message
	action_tag = "alert_message"
	name = "Alert Message"

/datum/player_action/alert_message/act(client/user, mob/target, list/params)
	if(!target.client)
		return

	user.cmd_admin_alert_message(target)
	return TRUE

// SET NAME/CKEY
/datum/player_action/set_name
	action_tag = "set_name"
	name = "Set Name"

/datum/player_action/set_name/act(client/user, mob/target, list/params)
	if(!params["name"])
		to_chat(user, "The Name field cannot be empty")

		return FALSE

	var/mob/living/living_target = target

	if(istype(living_target, /mob/living/carbon))
		living_target.real_name = params["name"]

	living_target.name = params["name"]

	if(ishuman(living_target))
		var/mob/living/carbon/human/human_target = living_target
		var/obj/item/card/id/card = human_target.get_idcard()
		if(card)
			card.registered_name = human_target.name
			card.name = "[human_target.name]'s [card.id_type][card.assignment ? " ([card.assignment])" : ""]"

	message_admins("[key_name_admin(user)] set [key_name_admin(target)]'s name to [params["name"]]")

	return TRUE

/datum/player_action/set_ckey
	action_tag = "set_ckey"
	name = "Set ckey"

/datum/player_action/set_ckey/act(client/user, mob/target, list/params)
	if(params["ckey"] == "")
		params["ckey"] = " "

	user.change_ckey(target, params["ckey"])
	return TRUE

// TELEPORTATION
/datum/player_action/bring
	action_tag = "mob_bring"
	name = "Bring"


/datum/player_action/bring/act(client/user, mob/target, list/params)
	var/mob/M = user.mob

	target.forceMove(M.loc)
	message_admins("[key_name_admin(user)] teleported [key_name_admin(target)] to themselves.", M.loc.x, M.loc.y, M.loc.z)
	return TRUE

/datum/player_action/follow
	action_tag = "mob_follow"
	name = "Follow"

/datum/player_action/follow/act(client/user, mob/target, list/params)
	if(istype(user.mob, /mob/dead/observer))
		var/mob/dead/observer/O = user.mob
		O.do_observe(target)
		return TRUE
	else
		to_chat(user, SPAN_WARNING("You must be a ghost to do this."))

	return FALSE

/datum/player_action/jump_to
	action_tag = "jump_to"
	name = "Jump To"


/datum/player_action/jump_to/act(client/user, mob/target, list/params)
	user.jumptomob(target)
	return TRUE


// VIEW VARIABLES
/datum/player_action/access_variables
	action_tag = "access_variables"
	name = "Access Variables"


/datum/player_action/access_variables/act(client/user, mob/target, list/params)
	user.debug_variables(target)
	return TRUE

/datum/player_action/access_playtimes
	action_tag = "access_playtimes"
	name = "Access Playtimes"

/datum/player_action/access_playtimes/act(client/user, mob/target, list/params)
	target?.client?.player_data.tgui_interact(user.mob)

	return TRUE


/datum/player_action/access_admin_datum
	action_tag = "access_admin_datum"
	name = "Access Admin Datum"

/datum/player_action/access_admin_datum/act(client/user, mob/target, list/params)
	if(!target.client || !target.client.admin_holder)
		return

	user.debug_variables(target.client.admin_holder)
	return TRUE
