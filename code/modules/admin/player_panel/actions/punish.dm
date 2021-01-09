/datum/player_action/ban
	action_tag = "mob_ban"
	name = "Ban"
	permissions_required = R_BAN

/datum/player_action/ban/act(var/client/user, var/mob/target, var/list/params)
	user.cmd_admin_do_ban(target)
	return TRUE


/datum/player_action/jobban
	action_tag = "mob_jobban"
	name = "Job-ban"
	permissions_required = R_BAN

/datum/player_action/jobban/act(var/client/user, var/mob/target, var/list/params)
	user.cmd_admin_job_ban(target)
	return TRUE

/datum/player_action/eorgban
	action_tag = "mob_eorg_ban"
	name = "EORG Ban"
	permissions_required = R_BAN

/datum/player_action/eorgban/act(var/client/user, var/mob/target, var/list/params)
	if(target.client && target.client.admin_holder)	return	//admins cannot be banned. Even if they could, the ban doesn't affect them anyway

	if(!target.ckey)
		to_chat(user, SPAN_DANGER("<B>Warning: Mob ckey for [target.name] not found.</b>"))
		return

	var/mins = 0
	var/reason = ""
	switch(alert("Are you sure you want to EORG ban [target.ckey]?", , "Yes", "No"))
		if("Yes")
			mins = 180
			reason = "EORG"
		if("No")
			return

	var/datum/entity/player/P = get_player_from_key(target.ckey) // you may not be logged in, but I will find you and I will ban you
	if(P.is_time_banned && alert(user, "Ban already exists. Proceed?", "Confirmation", "Yes", "No") != "Yes")
		return
	P.add_timed_ban(reason, mins)

	return TRUE

/datum/player_action/mute
	action_tag = "mob_mute"
	name = "Mute"


/datum/player_action/mute/act(var/client/user, var/mob/target, var/list/params)
	if(!target.client)
		return

	target.client.prefs.muted = text2num(params["mute_flag"])
	log_admin("[key_name(user)] set the mute flags for [key_name(target)] to [target.client.prefs.muted].")
	return TRUE

/datum/player_action/show_notes
	action_tag = "show_notes"
	name = "Show Notes"


/datum/player_action/show_notes/act(var/client/user, var/mob/target, var/list/params)
	user.admin_holder.player_notes_show(target.ckey)
	return TRUE


/datum/player_action/reset_xeno_name
	action_tag = "reset_xeno_name"
	name = "Reset Xeno Name"


/datum/player_action/reset_xeno_name/act(var/client/user, var/mob/target, var/list/params)
	var/mob/living/carbon/Xenomorph/X = target
	if(!isXeno(X))
		to_chat(user, SPAN_WARNING("[target.name] is not a xeno!"))
		return

	if(alert(user, "Are you sure you want to reset xeno name for [X.ckey]?", , "Yes", "No") == "No")
		return

	if(!X.ckey)
		to_chat(user, SPAN_DANGER("Warning: Mob ckey for [X.name] not found."))
		return

	message_staff("[user.ckey] has reset [X.ckey] xeno name")

	to_chat(X, SPAN_DANGER("Warning: Your xeno name has been reset by [user.ckey]."))

	X.client.xeno_prefix = "XX"
	X.client.xeno_postfix = ""
	X.client.prefs.xeno_prefix = "XX"
	X.client.prefs.xeno_postfix = ""

	X.client.prefs.save_preferences()
	X.generate_name()

/datum/player_action/xeno_name_ban
	action_tag = "ban_xeno_name"
	name = "Ban Xeno Name"
	permissions_required = R_BAN



/datum/player_action/xeno_name_ban/act(var/client/user, var/mob/target, var/list/params)
	if(!target.client)
		return

	var/client/targetClient = target.client

	if(targetClient.xeno_name_ban)
		if(alert(user, "Are you sure you want to UNBAN [target.ckey] and let them use xeno name?", ,"Yes", "No") == "No")
			return
		targetClient.xeno_name_ban = FALSE
		targetClient.prefs.xeno_name_ban = FALSE

		targetClient.prefs.save_preferences()
		message_staff("[user.ckey] has unbanned [target.ckey] from using xeno names")

		notes_add(target.ckey, "Xeno Name Unbanned by [user.ckey]", user.mob)
		to_chat(target, SPAN_DANGER("Warning: You can use xeno names again."))
		return

	if(!isXeno(target))
		to_chat(user, SPAN_DANGER("Target is not a xenomorph. Aborting."))
		return

	if(alert("Are you sure you want to BAN [target.ckey] from ever using any xeno name?", , "Yes", "No") == "No")
		return

	if(!target.ckey)
		to_chat(user, SPAN_DANGER("Warning: Mob ckey for [target.name] not found."))
		return

	message_staff("[user.ckey] has banned [target.ckey] from using xeno names")

	notes_add(target.ckey, "Xeno Name Banned by [user.ckey]|Reason: Xeno name was [target.name]", user.mob)

	to_chat(target, SPAN_DANGER("Warning: You were banned from using xeno names by [user.ckey]."))

	targetClient.xeno_prefix = "XX"
	targetClient.xeno_postfix = ""
	targetClient.xeno_name_ban = TRUE
	targetClient.prefs.xeno_prefix = "XX"
	targetClient.prefs.xeno_postfix = ""
	targetClient.prefs.xeno_name_ban = TRUE

	targetClient.prefs.save_preferences()

	var/mob/living/carbon/Xenomorph/X = target
	X.generate_name()
