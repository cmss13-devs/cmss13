

//This is a list of words which are ignored by the parser when comparing message contents for names. MUST BE IN LOWER CASE!
var/list/adminhelp_ignored_words = list("unknown","the","a","an","of","monkey","alien","as")

// Associative list with mob ref as key and message they sent as the values
// Required for storing messages without fucking up the html
var/global/list/ahelp_msgs = list()

/client/verb/adminhelp()
	set category = "OOC"
	set name = "Adminhelp"

	//handle muting and automuting
	if(prefs.muted & MUTE_ADMINHELP)
		to_chat(src, "<font color='red'>Error: Admin-PM: You cannot send adminhelps (Muted).</font>")
		return


	adminhelped = 1 //Determines if they get the message to reply by clicking the name.

	var/msg
	var/list/type = list ("Github (Bug Reports)", "AdminHelp", "MentorHelp")
	var/selected_type = input("- Github is an external site where you can post your bug reports. If you want to implement a suggestion, make a Merge Request.\
	\n\n- AdminHelp is used to contact staff members online for reporting griefers, rule clarification and asking assistance in dealing with crucial bugs.\
	\n\n- MentorHelp is used to ask questions about gameplay mechanics and for tips and advices.\
	\n\nSelect an option:", "AdminHelp", null, null) as null|anything in type
	if(selected_type == "AdminHelp")
		msg = input("Please enter your message:", "AdminHelp", null, null) as message|null

	if(selected_type == "Github (Bug Reports)")
		switch(alert("CM Github Issues page will be opened in your default browser.",,"Go to Github","Cancel"))
			if("Go to Github")
				src << link(URL_ISSUE_TRACKER)
			else
				return

	// Mentor help
	if(selected_type == "MentorHelp")
		if(current_mhelp && current_mhelp.open)
			if(alert("You already have a mentorhelp thread open, would you like to close it?", "Mentor Help", "Yes", "No") == "Yes")
				current_mhelp.close(src)
			return
		current_mhelp = new(src)
		if(!current_mhelp.broadcast_request(src))
			QDEL_NULL(current_mhelp)
		return

	var/selected_upper = uppertext(selected_type)

	if(src.handle_spam_prevention(msg,MUTE_ADMINHELP))
		return


	//clean the input msg
	if(!msg)	return
	msg = strip_html(msg)
	if(!msg)	return
	var/original_msg = msg



	//explode the input msg into a list
	var/list/msglist = splittext(msg, " ")

	//generate keywords lookup
	var/list/surnames = list()
	var/list/forenames = list()
	var/list/ckeys = list()
	for(var/mob/M in GLOB.mob_list)
		var/list/indexing = list(M.real_name, M.name)
		if(M.mind)	indexing += M.mind.name

		for(var/string in indexing)
			var/list/L = splittext(string, " ")
			var/surname_found = 0
			//surnames
			for(var/i=L.len, i>=1, i--)
				var/word = ckey(L[i])
				if(word)
					surnames[word] = M
					surname_found = i
					break
			//forenames
			for(var/i=1, i<surname_found, i++)
				var/word = ckey(L[i])
				if(word)
					forenames[word] = M
			//ckeys
			ckeys[M.ckey] = M

	var/ai_found = 0
	msg = ""
	var/list/mobs_found = list()
	for(var/original_word in msglist)
		var/word = ckey(original_word)
		if(word)
			if(!(word in adminhelp_ignored_words))
				if(word == "ai")
					ai_found = 1
				else
					var/mob/found = ckeys[word]
					if(!found)
						found = surnames[word]
						if(!found)
							found = forenames[word]
					if(found)
						if(!(found in mobs_found))
							mobs_found += found
							if(!ai_found && isRemoteControlling(found))
								ai_found = 1
							msg += "<b><font color='black'>[original_word] (<A HREF='?_src_=admin_holder;adminmoreinfo;extra=\ref[found]'>?</A>)</font></b> "
							continue
			msg += "[original_word] "

	if(!mob)	return	//this doesn't happen

	GLOB.STUI.staff.Add("\[[time_stamp()]] <font color=red>[key_name(src)] AHELP: </font><font color='#006400'>[get_options_bar(mob, 4, 1, 1, 0)]:</b> [msg]</font><br>")
	GLOB.STUI.processing |= STUI_LOG_STAFF_CHAT
	msg = "<font color='#009900'><b>[selected_upper]: [get_options_bar(mob, 2, 1, 1, msg=original_msg)]:</b></font> <br>&emsp;<font color='#DA6200'><b>[msg]</font></b>"

	var/admins_non_afk = 0
	for(var/client/C in GLOB.admins)
		if(C && C.admin_holder && (C.admin_holder.rights & R_MOD))
			if(!C.is_afk())
				admins_non_afk++
			if(C.prefs.toggles_sound & SOUND_ADMINHELP)
				sound_to(C, 'sound/effects/adminhelp_new.ogg')
			to_chat_spaced(C, type = MESSAGE_TYPE_ADMINPM, margin_bottom = 0.5, margin_top = 0.5, html = SPAN_PM(msg))

	//show it to the person adminhelping too
	to_chat_spaced(src, margin_bottom = 0.5, margin_top = 0.5, type = MESSAGE_TYPE_ADMINPM, html = SPAN_PM("<font color='#009900'><b>PM to Staff ([selected_type]):</font><br>&emsp;<font color='#DA6200'>[original_msg]</b></font>"))

	// Adminhelp cooldown
	remove_verb(src, /client/verb/adminhelp)
	addtimer(CALLBACK(GLOBAL_PROC, .proc/add_verb, src, /client/verb/adminhelp), 2 MINUTES)

	log_admin("HELP: [key_name(src)]: [original_msg] - heard by [admins_non_afk] non-AFK staff.")

	unansweredAhelps["[src.computer_id]"] = msg //We are gonna do it by CID, since any other way really gets fucked over by ghosting etc

	return

/proc/get_options_bar(whom, detail = 2, name = 0, link = 1, highlight_special = 1, msg = "")
	if(!whom)
		return "<b>(*null*)</b>"
	var/mob/M
	var/client/C
	if(istype(whom, /client))
		C = whom
		M = C.mob
	else if(istype(whom, /mob))
		M = whom
		C = M.client
	else
		return "<b>(*not a mob*)</b>"

	var/ref_mob = "\ref[M]"
	var/ref_client = "\ref[C]"
	ahelp_msgs[ref_client] = msg
	switch(detail)
		if(0)
			return "<b>[key_name(C, link, name, highlight_special)]</b>"
		if(1)
			return "<b>[key_name(C, link, name, highlight_special)] \
			(<A HREF='?_src_=admin_holder;ahelp=adminmoreinfo;extra=[ref_mob]'>?</A>)</b>"
		if(2)
			return "<b>[key_name(C, link, name, highlight_special)] \
			(<A HREF='?_src_=admin_holder;ahelp=mark;extra=[ref_mob]'>Mark</A> |  \
			<A HREF='?_src_=admin_holder;ahelp=noresponse;extra=[ref_mob]'>NR</A> |  \
			<A HREF='?_src_=admin_holder;ahelp=warning;extra=[ref_mob]'>Warn</A> |  \
			<A HREF='?_src_=admin_holder;ahelp=autoresponse;extra=[ref_mob]'>AutoResponse</A> |  \
			<A HREF='?_src_=admin_holder;ahelp=defermhelp;extra=[ref_client]'>Defer</A> |  \
			<A HREF='?_src_=admin_holder;ahelp=adminmoreinfo;extra=[ref_mob]'>?</A> |  \
			<A HREF='?_src_=admin_holder;ahelp=adminplayeropts;extra=[ref_mob]'>PP</A> |  \
			<A HREF='?_src_=vars;Vars=[ref_mob]'>VV</A> |  \
			<A HREF='?_src_=admin_holder;subtlemessage=[ref_mob]'>SM</A> |  \
			<A HREF='?_src_=admin_holder;adminplayerobservejump=[ref_mob]'>JMP</A>)</b>"
		if(3)
			return "<b>[key_name(C, link, name, highlight_special)] \
			(<A HREF='?_src_=vars;Vars=[ref_mob]'>VV</A> |  \
			<A HREF='?_src_=admin_holder;adminplayerobservejump=[ref_mob]'>JMP</A>)</b>"
