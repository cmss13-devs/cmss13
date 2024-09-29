//allows right clicking mobs to send an admin PM to their client, forwards the selected mob's client to cmd_admin_pm
/client/proc/cmd_admin_pm_context(mob/M in GLOB.mob_list)
	set category = null
	set name = "Admin PM Mob"
	if(!CLIENT_IS_STAFF(src))
		to_chat(src,
			type = MESSAGE_TYPE_ADMINPM,
			html = SPAN_DANGER("Error: Admin-PM-Context: Only administrators may use this command."),
			confidential = TRUE)
		return
	if(!ismob(M) || !M.client)
		return
	cmd_admin_pm(M.client,null)

//shows a list of clients we could send PMs to, then forwards our choice to cmd_admin_pm
/client/proc/cmd_admin_pm_panel()
	set category = "Admin"
	set name = "Admin PM"
	if(!CLIENT_IS_STAFF(src))
		to_chat(src,
			type = MESSAGE_TYPE_ADMINPM,
			html = SPAN_DANGER("Error: Admin-PM-Panel: Only administrators may use this command."),
			confidential = TRUE)
		return
	var/list/targets = list()
	for(var/client/client as anything in GLOB.clients)
		if(client.mob)
			if(isnewplayer(client.mob))
				targets["(New Player) - [client]"] = client
			else if(isobserver(client.mob))
				targets["[client.mob.name](Ghost) - [client]"] = client
			else
				targets["[client.mob.real_name](as [client.mob.name]) - [client]"] = client
		else
			targets["(No Mob) - [client]"] = client
	var/target = input(src,"To whom shall we send a message?","Admin PM",null) as null|anything in sort_list(targets)
	cmd_admin_pm(targets[target],null)

/client/proc/cmd_ahelp_reply(whom)
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src,
			type = MESSAGE_TYPE_ADMINPM,
			html = SPAN_DANGER("Error: Admin-PM: You are unable to use admin PM-s (muted)."),
			confidential = TRUE)
		return
	var/client/C
	if(istext(whom))
		C = GLOB.directory[whom]
	else if(istype(whom, /client))
		C = whom
	if(!C)
		if(CLIENT_IS_STAFF(src))
			to_chat(src,
				type = MESSAGE_TYPE_ADMINPM,
				html = SPAN_DANGER("Error: Admin-PM: Client not found."),
				confidential = TRUE)
		return

	var/datum/admin_help/AH = C.current_ticket

	var/message_prompt = "Message:"

	if(AH && !AH.marked_admin)
		AH.mark_ticket()

	if((AH?.opening_responders && length(AH.ticket_interactions) == 1 ) || ((AH?.marked_admin && AH?.marked_admin != usr.ckey) && length(AH.ticket_interactions) == 2))
		SEND_SOUND(src, sound('sound/machines/buzz-sigh.ogg', volume=30))
		message_prompt += "\n\n**This ticket is already being responded to by: [length(AH.opening_responders) ? english_list(AH.opening_responders) : AH.marked_admin]**"

	if(AH)
		message_admins("[key_name_admin(src)] has started replying to [key_name_admin(C, 0, 0)]'s admin help.")
		if(length(AH.ticket_interactions) == 1) // add the admin who is currently responding to the list of people responding
			LAZYADD(AH.opening_responders, src)

	var/msg = input(src, message_prompt, "Private message to [C.admin_holder?.fakekey ? "an Administrator" : key_name(C, 0, 0)].") as message|null

	if(AH)
		LAZYREMOVE(AH.opening_responders, src)
		if (!msg)
			message_admins("[key_name_admin(src)] has cancelled their reply to [key_name_admin(C, 0, 0)]'s admin help.")
			return

	if(!C) //We lost the client during input, disconnected or relogged.
		if(GLOB.directory[AH.initiator_ckey]) // Client has reconnected, lets try to recover
			whom = GLOB.directory[AH.initiator_ckey]
		else
			to_chat(src,
				type = MESSAGE_TYPE_ADMINPM,
				html = SPAN_DANGER("Error: Admin-PM: Client not found."),
				confidential = TRUE)
			to_chat(src,
				type = MESSAGE_TYPE_ADMINPM,
				html = "[SPAN_DANGER("<b>Message not sent:</b>")]<br>[msg]",
				confidential = TRUE)
			AH.AddInteraction("<b>No client found, message not sent:</b><br>[msg]")
			return
	cmd_admin_pm(whom, msg)

//takes input from cmd_admin_pm_context, cmd_admin_pm_panel or /client/Topic and sends them a PM.
//Fetching a message if needed. src is the sender and C is the target client
/client/proc/cmd_admin_pm(whom, msg)
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src,
			type = MESSAGE_TYPE_ADMINPM,
			html = SPAN_DANGER("Error: Admin-PM: You are unable to use admin PM-s (muted)."),
			confidential = TRUE)
		return

	if(!CLIENT_IS_STAFF(src) && !current_ticket) //no ticket? https://www.youtube.com/watch?v=iHSPf6x1Fdo
		to_chat(src,
			type = MESSAGE_TYPE_ADMINPM,
			html = SPAN_DANGER("You can no longer reply to this ticket, please open another one by using the Adminhelp verb if need be."),
			confidential = TRUE)
		to_chat(src,
			type = MESSAGE_TYPE_ADMINPM,
			html = SPAN_NOTICE("Message: [msg]"),
			confidential = TRUE)
		return

	var/client/recipient
	var/recipient_ckey // Stored in case client is deleted between this and after the message is input
	var/datum/admin_help/recipient_ticket // Stored in case client is deleted between this and after the message is input
	var/external = 0
	if(istext(whom))
		recipient = GLOB.directory[whom]
	else if(istype(whom, /client))
		recipient = whom

	if(!recipient)
		to_chat(src,
			type = MESSAGE_TYPE_ADMINPM,
			html = SPAN_DANGER("Error: Admin-PM: Client not found."),
			confidential = TRUE)
		return

	recipient_ckey = recipient.ckey
	recipient_ticket = recipient.current_ticket

	//get message text, limit it's length.and clean/escape html
	if(!msg)
		msg = input(src,"Message:", "Private message to [recipient.admin_holder?.fakekey ? "an Administrator" : key_name(recipient, 0, 0)].") as message|null
		msg = trim(msg)
		if(!msg)
			return

	if(!recipient)
		if(GLOB.directory[recipient_ckey]) // Client has reconnected, lets try to recover
			recipient = GLOB.directory[recipient_ckey]
		else
			if(CLIENT_IS_STAFF(src))
				to_chat(src,
					type = MESSAGE_TYPE_ADMINPM,
					html = SPAN_DANGER("Error: Admin-PM: Client not found."),
					confidential = TRUE)
				to_chat(src,
					type = MESSAGE_TYPE_ADMINPM,
					html = "[SPAN_DANGER("<b>Message not sent:</b>")]<br>[msg]",
					confidential = TRUE)
				if(recipient_ticket)
					recipient_ticket.AddInteraction("<b>No client found, message not sent:</b><br>[msg]")
				return
			else
				current_ticket.MessageNoRecipient(msg)
				return


	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src,
			type = MESSAGE_TYPE_ADMINPM,
			html = SPAN_DANGER("Error: Admin-PM: You are unable to use admin PM-s (muted)."),
			confidential = TRUE)
		return

	if (src.handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	if(external) //no sending html to the poor bots - but preserve any html tags with encoded entities
		msg = sanitize(copytext_char(msg, 1, MAX_MESSAGE_LEN))
	else //clean the message
		msg = strip_html(copytext_char(msg, 1, MAX_MESSAGE_LEN))

	if(!msg)
		return

	var/rawmsg = msg

	if(CLIENT_IS_STAFF(src))
		msg = emoji_parse(msg)

	var/badmin = FALSE //Lets figure out if an admin is getting bwoinked.
	if(CLIENT_IS_STAFF(src) && CLIENT_IS_STAFF(recipient) && !current_ticket) //Both are admins, and this is not a reply to our own ticket.
		badmin = TRUE
	if(CLIENT_IS_STAFF(recipient) && !badmin)
		if(CLIENT_IS_STAFF(src))
			to_chat(recipient,
				type = MESSAGE_TYPE_ADMINPM,
				html = SPAN_ADMINSAY("\nAdmin PM from-<b>[key_name(src, recipient, 1)]</b>: <span class='linkify'>[msg]</span>\n\n"),
				confidential = TRUE)
			to_chat(src,
				type = MESSAGE_TYPE_ADMINPM,
				html = SPAN_NOTICE("Admin PM to-<b>[key_name(recipient, src, 1)]</b>: <span class='linkify'>[msg]</span>"),
				confidential = TRUE)
			SEND_SIGNAL(src, COMSIG_ADMIN_HELP_RECEIVED, msg)
			//omg this is dumb, just fill in both their tickets
			var/interaction_message = "<font color='green'>PM from-<b>[key_name(src, recipient, TRUE)]</b> to-<b>[key_name(recipient, src, TRUE)]</b>: [msg]</font>"
			var/player_interaction_message = "<font color='green'>PM from-<b>[key_name(src, recipient, FALSE)]</b> to-<b>[key_name(recipient, src, FALSE)]</b>: [msg]</font>"
			admin_ticket_log(src, interaction_message, log_in_blackbox = FALSE, player_message = player_interaction_message)
			if(recipient != src) //reeee
				admin_ticket_log(recipient, interaction_message, log_in_blackbox = FALSE, player_message = player_interaction_message)
			log_ahelp(current_ticket.id, "Reply", msg, recipient.ckey, src.ckey)
		else //recipient is an admin but sender is not
			current_ticket.player_replied = TRUE
			SEND_SIGNAL(current_ticket, COMSIG_ADMIN_HELP_REPLIED)
			var/replymsg = "Reply PM from-<b>[key_name(src, recipient, TRUE)]</b>: <span class='linkify'>[msg]</span>"
			var/player_replymsg = "Reply PM from-<b>[key_name(src, recipient, FALSE)]</b>: <span class='linkify'>[msg]</span>"
			admin_ticket_log(src, "<font color='red'>[replymsg]</font>", log_in_blackbox = FALSE, player_message = player_replymsg)
			to_chat(recipient,
				type = MESSAGE_TYPE_ADMINPM,
				html = SPAN_DANGER("\n[replymsg]\n"),
				confidential = TRUE)
			to_chat(src,
				type = MESSAGE_TYPE_ADMINPM,
				html = SPAN_NOTICE("PM to-<b>Admins</b>: <span class='linkify'>[msg]</span>"),
				confidential = TRUE)
			log_ahelp(current_ticket.id, "Reply", msg, recipient.ckey, src.ckey)

		//play the receiving admin the adminhelp sound (if they have them enabled)
		if(recipient.prefs.toggles_sound & SOUND_ADMINHELP)
			SEND_SOUND(recipient, sound('sound/effects/adminhelp_new.ogg'))
	else
		if(CLIENT_IS_STAFF(src)) //sender is an admin but recipient is not. Do BIG RED TEXT
			var/already_logged = FALSE
			if(!recipient.current_ticket)
				var/datum/admin_help/new_ticket = new(msg, recipient, TRUE)
				new_ticket.marked_admin = ckey
				already_logged = TRUE
				log_ahelp(recipient.current_ticket.id, "Ticket Opened", msg, recipient.ckey, src.ckey)

			SEND_SIGNAL(src, COMSIG_ADMIN_HELP_RECEIVED, msg)
			to_chat(recipient,
				type = MESSAGE_TYPE_ADMINPM,
				html = "\n<font color='red' size='4'><b>-- Administrator private message --</b></font>",
				confidential = TRUE)
			to_chat(recipient,
				type = MESSAGE_TYPE_ADMINPM,
				html = SPAN_ADMINSAY("Admin PM from-<b>[key_name(src, recipient, 0)]</b>: <span class='linkify'>[msg]</span>"),
				confidential = TRUE)
			to_chat(recipient,
				type = MESSAGE_TYPE_ADMINPM,
				html = SPAN_ADMINSAY("<i>Click on the administrator's name to reply.</i>\n\n"),
				confidential = TRUE)
			to_chat(src,
				type = MESSAGE_TYPE_ADMINPM,
				html = SPAN_NOTICE("Admin PM to-<b>[key_name(recipient, src, 1)]</b>: <span class='linkify'>[msg]</span>"),
				confidential = TRUE)

			admin_ticket_log(recipient, "<font color='green'>PM From [key_name_admin(src)]: [msg]</font>", log_in_blackbox = FALSE, player_message = "<font color='green'>PM From [key_name_admin(src, include_name = FALSE)]: [msg]</font>")

			if(!already_logged) //Reply to an existing ticket
				log_ahelp(recipient.current_ticket.id, "Reply", msg, recipient.ckey, src.ckey)

			//always play non-admin recipients the adminhelp sound
			SEND_SOUND(recipient, sound('sound/effects/adminhelp_new.ogg'))

		else //neither are admins
			if(!current_ticket)
				to_chat(src,
					type = MESSAGE_TYPE_ADMINPM,
					html = SPAN_DANGER("Error: Admin-PM: Non-admin to non-admin PM communication is forbidden."),
					confidential = TRUE)
				to_chat(src,
					type = MESSAGE_TYPE_ADMINPM,
					html = "[SPAN_DANGER("<b>Message not sent:</b>")]<br>[msg]",
					confidential = TRUE)
				return
			current_ticket.MessageNoRecipient(msg)

	window_flash(recipient)
	log_admin_private("PM: [key_name(src)]->[key_name(recipient)]: [rawmsg]")
	//we don't use message_admins here because the sender/receiver might get it too
	for(var/client/X in GLOB.admins)
		if(!CLIENT_IS_STAFF(X))
			continue
		if(X.key!=key && X.key!=recipient.key) //check client/X is an admin and isn't the sender or recipient
			to_chat(X,
				type = MESSAGE_TYPE_ADMINPM,
				html = SPAN_NOTICE("<B>PM: [key_name(src, X, 0)]-&gt;[key_name(recipient, X, 0)]:</B> [msg]") ,
				confidential = TRUE)
