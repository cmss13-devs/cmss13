/datum/player_action/ban
	action_tag = "mob_ban"
	name = "Ban"
	permissions_required = R_BAN

/datum/player_action/ban/act(client/user, mob/target, list/params)
	user.cmd_admin_do_ban(target)
	return TRUE


/datum/player_action/jobban
	action_tag = "mob_jobban"
	name = "Job-ban"
	permissions_required = R_BAN

/datum/player_action/jobban/act(client/user, mob/target, list/params)
	user.cmd_admin_job_ban(target)
	return TRUE

/datum/player_action/eorgban
	action_tag = "mob_eorg_ban"
	name = "EORG Ban"
	permissions_required = R_BAN

/datum/player_action/eorgban/act(client/user, mob/target, list/params)
	if(target.client && target.client.admin_holder)
		return //admins cannot be banned. Even if they could, the ban doesn't affect them anyway

	if(!target.ckey)
		to_chat(user, SPAN_DANGER("<B>Warning: Mob ckey for [target.name] not found.</b>"))
		return

	var/mins = 0
	var/reason = ""
	switch(alert("Are you sure you want to EORG ban [target.ckey]?", , "Yes", "No"))
		if("Yes")
			mins = 180
			reason = "EORG - Generating combat logs with, or otherwise griefing, friendly/allied players."
		if("No")
			return

	var/datum/entity/player/P = get_player_from_key(target.ckey) // you may not be logged in, but I will find you and I will ban you
	if(P.is_time_banned && alert(user, "Ban already exists. Proceed?", "Confirmation", "Yes", "No") != "Yes")
		return
	P.add_timed_ban(reason, mins)

	return TRUE

/datum/player_action/permanent_ban
	action_tag = "permanent_ban"
	name = "Permanent Ban"
	permissions_required = R_BAN

/datum/player_action/permanent_ban/act(client/user, mob/target, list/params)
	var/reason = tgui_input_text(user, "What message should be given to the permabanned user?", "Permanent Ban", encode = FALSE)
	if(!reason)
		return

	var/internal_reason = tgui_input_text(user, "What's the reason for the ban? This is shown internally, and not displayed in public notes and ban messages. Include as much detail as necessary.", "Permanent Ban", multiline = TRUE, encode = FALSE)
	if(!internal_reason)
		return

	var/datum/entity/player/target_entity = target.client?.player_data
	if(!target_entity)
		target_entity = get_player_from_key(target.ckey || target.persistent_ckey)

	if(!target_entity)
		return

	if(!target_entity.add_perma_ban(reason, internal_reason, user.player_data))
		to_chat(user, SPAN_ADMIN("The user is already permabanned! If necessary, you can remove the permaban, and place a new one."))

/datum/player_action/sticky_ban
	action_tag = "sticky_ban"
	name = "Sticky Ban"
	permissions_required = R_BAN

/datum/player_action/sticky_ban/act(client/user, mob/target, list/params)
	var/datum/entity/player/player = get_player_from_key(target.ckey || target.persistent_ckey)
	if(!player)
		return

	var/persistent_ip = target.client?.address || player.last_known_ip
	var/persistent_cid = target.client?.computer_id || player.last_known_cid

	var/message = tgui_input_text(user, "What message should be given to the impacted users?", "BuildABan", encode = FALSE)
	if(!message)
		return

	var/reason = tgui_input_text(user, "What's the reason for the ban? This is shown internally, and not displayed in public notes and ban messages. Include as much detail as necessary.", "BuildABan", multiline = TRUE, encode = FALSE)
	if(!reason)
		return

	user.cmd_admin_do_stickyban(target.ckey, reason, message, impacted_ckeys = list(target.ckey), impacted_cids = list(persistent_cid), impacted_ips = list(persistent_ip))
	player.add_note("Stickybanned | [message]", FALSE, NOTE_ADMIN, TRUE)
	player.add_note("Internal reason: [reason]", TRUE, NOTE_ADMIN)

	if(target.client)
		qdel(target.client)

/datum/player_action/mute
	action_tag = "mob_mute"
	name = "Mute"


/datum/player_action/mute/act(client/user, mob/target, list/params)
	if(!target.client)
		return

	target.client.prefs.muted = text2num(params["mute_flag"])
	log_admin("[key_name(user)] set the mute flags for [key_name(target)] to [target.client.prefs.muted].")
	return TRUE

/datum/player_action/show_notes
	action_tag = "show_notes"
	name = "Show Notes"


/datum/player_action/show_notes/act(client/user, mob/target, list/params)
	user.admin_holder.player_notes_show(target.ckey)
	return TRUE

/datum/player_action/check_ckey
	action_tag = "check_ckey"
	name = "Check Ckey"


/datum/player_action/check_ckey/act(client/user, mob/target, list/params)
	user.admin_holder.check_ckey(target.ckey)
	return TRUE

/datum/player_action/reset_xeno_name
	action_tag = "reset_xeno_name"
	name = "Reset Xeno Name"


/datum/player_action/reset_xeno_name/act(client/user, mob/target, list/params)
	var/mob/living/carbon/xenomorph/X = target
	if(!isxeno(X))
		to_chat(user, SPAN_WARNING("[target.name] is not a xeno!"))
		return

	if(alert(user, "Are you sure you want to reset xeno name for [X.ckey]?", , "Yes", "No") != "Yes")
		return

	if(!X.ckey)
		to_chat(user, SPAN_DANGER("Warning: Mob ckey for [X.name] not found."))
		return

	message_admins("[user.ckey] has reset [X.ckey] xeno name")

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



/datum/player_action/xeno_name_ban/act(client/user, mob/target, list/params)
	if(!target.client)
		return

	var/client/targetClient = target.client

	if(targetClient.xeno_name_ban)
		if(alert(user, "Are you sure you want to UNBAN [target.ckey] and let them use xeno name?", ,"Yes", "No") != "Yes")
			return
		targetClient.xeno_name_ban = FALSE
		targetClient.prefs.xeno_name_ban = FALSE

		targetClient.prefs.save_preferences()
		message_admins("[user.ckey] has unbanned [target.ckey] from using xeno names")

		notes_add(target.ckey, "Xeno Name Unbanned by [user.ckey]", user.mob)
		to_chat(target, SPAN_DANGER("Warning: You can use xeno names again."))
		return

	if(!isxeno(target))
		to_chat(user, SPAN_DANGER("Target is not a xenomorph. Aborting."))
		return

	if(alert("Are you sure you want to BAN [target.ckey] from ever using any xeno name?", , "Yes", "No") != "Yes")
		return

	if(!target.ckey)
		to_chat(user, SPAN_DANGER("Warning: Mob ckey for [target.name] not found."))
		return

	message_admins("[user.ckey] has banned [target.ckey] from using xeno names")

	notes_add(target.ckey, "Xeno Name Banned by [user.ckey]|Reason: Xeno name was [target.name]", user.mob)

	to_chat(target, SPAN_DANGER("Warning: You were banned from using xeno names by [user.ckey]."))

	targetClient.xeno_prefix = "XX"
	targetClient.xeno_postfix = ""
	targetClient.xeno_name_ban = TRUE
	targetClient.prefs.xeno_prefix = "XX"
	targetClient.prefs.xeno_postfix = ""
	targetClient.prefs.xeno_name_ban = TRUE

	targetClient.prefs.save_preferences()

	var/mob/living/carbon/xenomorph/X = target
	X.generate_name()

/datum/player_action/reset_human_name
	action_tag = "reset_human_name"
	name = "Reset Human Name"


/datum/player_action/reset_human_name/act(client/user, mob/target, list/params)
	var/mob/target_mob = target
	if(!ismob(target_mob))
		to_chat(user, SPAN_WARNING("[target.name] is not a mob!"))
		return

	if(isxeno(target_mob))
		to_chat(user, SPAN_WARNING("[target.name] is a xeno!"))
		return

	if(!target_mob.client)
		to_chat(user, SPAN_WARNING("[target.name] does not have a client!"))
		return

	if(!target_mob.ckey)
		to_chat(user, SPAN_DANGER("Warning: Mob ckey for [target_mob.name] not found."))
		return

	if(alert(user, "Are you sure you want to reset name for [target_mob.ckey]?", "Confirmation", "Yes", "No") != "Yes")
		return

	var/new_name

	switch(alert(user, "Do you want to manually set the name for [target_mob.ckey]?", "Confirmation", "Yes", "No", "Cancel"))
		if("Cancel")
			return
		if("No")
			new_name = random_name(target_mob.gender)
		if("Yes")
			var/raw_name = input(user, "Choose the new name:", "Name Input")  as text|null
			if(!isnull(raw_name)) // Check to ensure that the user entered text (rather than cancel.)
				new_name = reject_bad_name(raw_name)

	if(!new_name)
		to_chat(user, SPAN_NOTICE("Invalid name. The name should be at least 2 and at most [MAX_NAME_LEN] characters long. It may only contain the characters A-Z, a-z, -, ' and ."))
		return

	if(!target_mob.client)
		to_chat(user, SPAN_WARNING("[target.name] does not have a client!"))
		return

	if(!target_mob.ckey)
		to_chat(user, SPAN_DANGER("Warning: Mob ckey for [target_mob.name] not found."))
		return

	target_mob.change_real_name(target_mob, new_name)
	GLOB.data_core.manifest_modify(new_name, WEAKREF(target_mob))
	if(ishuman(target_mob))
		var/mob/living/carbon/human/target_human = target_mob
		var/obj/item/card/id/card = target_human.get_idcard()
		if(card?.registered_ref == WEAKREF(target_human))
			card.name = "[target_human.real_name]'s [card.id_type]"
			card.registered_name = "[target_human.real_name]"
			if(card.assignment)
				card.name += " ([card.assignment])"

	target_mob.client.prefs.real_name = new_name
	target_mob.client.prefs.save_character()

	message_admins("[user.ckey] has reset [target_mob.ckey]'s name.")

	to_chat(target_mob, FONT_SIZE_HUGE(SPAN_ADMINHELP("Warning: Your name has been reset by [user.ckey].")))

	playsound_client(target_mob.client, sound('sound/effects/adminhelp_new.ogg'), src, 50)

/datum/player_action/ban_human_name
	action_tag = "ban_human_name"
	name = "Ban Human Name"
	permissions_required = R_BAN


/datum/player_action/ban_human_name/act(client/user, mob/target, list/params)
	if(!target.client || !target.ckey)
		to_chat(user, SPAN_NOTICE("Target is lacking either client or ckey. Aborting."))
		return

	var/client/target_client = target.client

	if(target_client.human_name_ban)
		if(alert(user, "Are you sure you want to UNBAN [target.ckey] and let them use human names?", "Confirmation", "Yes", "No") != "Yes")
			return

		if(!target.client || !target.ckey)
			to_chat(user, SPAN_NOTICE("Target is lacking either client or ckey. Aborting."))
			return

		target_client.human_name_ban = FALSE
		target_client.prefs.human_name_ban = FALSE

		target_client.prefs.save_preferences()
		message_admins("[user.ckey] has unbanned [target.ckey] from using human names.")

		notes_add(target.ckey, "Human Name Unbanned by [user.ckey]", user.mob)

		to_chat(target, FONT_SIZE_HUGE(SPAN_ADMINHELP("Warning: You can use human names again.")))
		return


	if(alert("Are you sure you want to BAN [target.ckey] from ever using any human names?", "Confirmation", "Yes", "No") != "Yes")
		return

	if(!target.client || !target.ckey)
		to_chat(user, SPAN_NOTICE("Target is lacking either client or ckey. Aborting."))
		return

	message_admins("[user.ckey] has banned [target.ckey] from using human names.")

	notes_add(target.ckey, "Human Name Banned by [user.ckey]", user.mob)

	to_chat(target, FONT_SIZE_HUGE(SPAN_ADMINHELP("Warning: You were banned from using human names by [user.ckey].")))
	playsound_client(target_client, sound('sound/effects/adminhelp_new.ogg'), src, 50)

	var/new_name = random_name(target.gender)
	target_client.prefs.real_name = new_name

	target_client.human_name_ban = TRUE
	target_client.prefs.real_name = ""
	target_client.prefs.human_name_ban = TRUE

	target_client.prefs.save_character()
	target_client.prefs.save_preferences()
