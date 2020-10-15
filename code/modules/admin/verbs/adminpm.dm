//allows right clicking mobs to send an admin PM to their client, forwards the selected mob's client to cmd_admin_pm
/client/proc/cmd_admin_pm_context(mob/M as mob in mob_list)
	set category = null
	set name = "Admin PM Mob"
	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "<font color='red'>Error: Admin-PM-Context: Only administrators may use this command.</font>")
		return
	if( !ismob(M) || !M.client )	return
	cmd_admin_pm(M.client,null)

//takes input from cmd_admin_pm_context, cmd_admin_pm_panel or /client/Topic and sends them a PM.
//Fetching a message if needed. src is the sender and C is the target client
/client/proc/cmd_admin_pm(var/client/C, var/msg = null)
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, "<font color='red'>Error: Private-Message: You are unable to use PMs (muted).</font>")
		return

	if(!istype(C,/client))
		if(admin_holder && (admin_holder.rights & R_MOD))	to_chat(src, "<font color='red'>Error: Private-Message: Client not found.</font>")
		else		to_chat(src, "<font color='red'>Error: Private-Message: Client not found. They may have lost connection, so try using an adminhelp!</font>")
		return

	//get message text, limit it's length.and clean/escape html
	if(!msg)
		msg = input(src,"Message:", "Private message to [key_name(C, 0, admin_holder ? 1 : 0)]") as message|null

		if(!msg)	return
		if(!C)
			if(admin_holder && (admin_holder.rights & R_MOD))	to_chat(src, "<font color='red'>Error: Admin-PM: Client not found.</font>")
			else		to_chat(src, "<font color='red'>Error: Private-Message: Client not found. They may have lost connection, so try using an adminhelp!</font>")
			return

	if (src.handle_spam_prevention(msg,MUTE_ADMINHELP))
		return

	//clean the message if it's not sent by a high-rank admin
	if(!check_rights(R_SERVER|R_DEBUG,0))
		msg = strip_html(msg)
		if(!msg)	return

	var/recieve_color = "purple"
	var/send_pm_type = " "
	var/recieve_pm_type = "Player"


	if(admin_holder && (admin_holder.rights & R_MOD))
		//PMs sent from admins and mods display their rank
		recieve_color = "#009900"
		send_pm_type = admin_holder.rank + " "
		if(!C.admin_holder && admin_holder && admin_holder.fakekey)
			recieve_pm_type = "Admin"
		else
			recieve_pm_type = admin_holder.rank
		// Automatically link certain phrases from staff.
		msg = replacetext(msg,"T:Marine","<a href=\"[URL_WIKI_MARINE_QUICKSTART]\">Marine Quickstart Guide</a>")
		msg = replacetext(msg,"T:Xeno","<a href=\"[URL_WIKI_XENO_QUICKSTART]\">Xeno Quickstart Guide</a>")
		msg = replacetext(msg,"T:Rules","<a href=\"[URL_WIKI_RULES]\">Rules Page</a>")
		msg = replacetext(msg,"T:Law","<a href=\"[URL_WIKI_LAW]\">Marine Law</a>")
		msg = replacetext(msg,"T:Forums","<a href=\"[URL_FORUM]\">Forums</a>")
		msg = replacetext(msg,"T:Wiki","<a href=\"[URL_WIKI_LANDING]\">Wiki</a>")
		msg = replacetext(msg,"T:Gitlab","<a href=\"[URL_ISSUE_TRACKER]\">Gitlab</a>")
		msg = replacetext(msg,"T:APC","<a href=\"[URL_WIKI_APC]\">APC Repair</a>")

	else if(!C.admin_holder || !(C.admin_holder.rights & R_MOD))
		to_chat(src, "<font color='red'>Error: Admin-PM: Non-admin to non-admin PM communication is forbidden.</font>")
		return

	var/recieve_message = ""

	if(admin_holder && (!C.admin_holder || !(C.admin_holder.rights & R_MOD)))
		recieve_message = "<font color='[recieve_color]'><b>-- Click the [recieve_pm_type]'s name to reply --</b></font>\n"
		if(C.adminhelped)
			to_chat(C, recieve_message)
			C.adminhelped = 0

		//AdminPM popup for ApocStation and anybody else who wants to use it. Set it with POPUP_ADMIN_PM in config.txt ~Carn
		if(config.popup_admin_pm)
			spawn(0)	//so we don't hold the caller proc up
				var/sender = src
				var/sendername = key
				var/reply = input(C, msg,"[recieve_pm_type] PM from-[sendername]", "") as text|null		//show message and await a reply
				if(C && reply)
					if(sender)
						C.cmd_admin_pm(sender,reply)										//sender is still about, let's reply to them
					else
						adminhelp(reply)													//sender has left, adminhelp instead
				return

	recieve_message = "<br><font color='[recieve_color]'><b>[recieve_pm_type] PM from [get_options_bar(src, C.admin_holder ? 1 : 0, C.admin_holder ? 1 : 0, 1)]: <font color='#DA6200'>[msg]</b></font><br>"
	to_chat(C, recieve_message)
	to_chat(src, "<br><font color='#009900'><b>[send_pm_type]PM to [get_options_bar(C, admin_holder ? 1 : 0, admin_holder ? 1 : 0, 1)]: <font color='#DA6200'>[msg]</b></font><br>")

	//play the recieving admin the adminhelp sound (if they have them enabled)
	//non-admins shouldn't be able to disable this
	if(C.prefs && C.prefs.toggles_sound & SOUND_ADMINHELP)
		C << 'sound/effects/adminhelp-reply.ogg'

	log_admin("PM: [key_name(src)]->[key_name(C)]: [msg]")
	GLOB.STUI.staff.Add("PM: [key_name(src)]->[key_name(C)]: [msg]<br>")
	GLOB.STUI.processing |= STUI_LOG_STAFF_CHAT
	//we don't use message_admins here because the sender/receiver might get it too
	for(var/client/X in GLOB.admins)
		//check client/X is an admin and isn't the sender or recipient
		if(X == C || X == src)
			continue
		if(X.key!=key && X.key!=C.key && (X.admin_holder.rights & R_ADMIN) || (X.admin_holder.rights & (R_MOD)) )
			to_chat(X, "<B>[SPAN_BLUE("PM: [key_name(src, X, 0)]-&gt;[key_name(C, X, 0)]:</B> \blue [msg]")]") //inform X
