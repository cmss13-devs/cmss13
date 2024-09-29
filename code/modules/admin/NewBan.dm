GLOBAL_VAR(CMinutes)
GLOBAL_DATUM(Banlist, /savefile)


/proc/CheckBan(ckey, id, address)
	if(!GLOB.Banlist) // if GLOB.Banlist cannot be located for some reason
		LoadBans() // try to load the bans
		if(!GLOB.Banlist) // uh oh, can't find bans!
			return 0 // ABORT ABORT ABORT

	. = list()
	var/appeal
	if(CONFIG_GET(string/banappeals))
		appeal = "\nFor more information on your ban, or to appeal, head to <a href='[CONFIG_GET(string/banappeals)]'>[CONFIG_GET(string/banappeals)]</a>"
	GLOB.Banlist.cd = "/base"
	if( "[ckey][id]" in GLOB.Banlist.dir )
		GLOB.Banlist.cd = "[ckey][id]"
		if (GLOB.Banlist["temp"])
			if (!GetExp(GLOB.Banlist["minutes"]))
				ClearTempbans()
				return 0
			else
				.["desc"] = "\nReason: [GLOB.Banlist["reason"]]\nExpires: [GetExp(GLOB.Banlist["minutes"])]\nBy: [GLOB.Banlist["bannedby"]][appeal]"
		else
			GLOB.Banlist.cd = "/base/[ckey][id]"
			.["desc"] = "\nReason: [GLOB.Banlist["reason"]]\nExpires: <B>PERMENANT</B>\nBy: [GLOB.Banlist["bannedby"]][appeal]"
		.["reason"] = "ckey/id"
		return .
	else
		for (var/A in GLOB.Banlist.dir)
			GLOB.Banlist.cd = "/base/[A]"
			var/matches
			if( ckey == GLOB.Banlist["key"] )
				matches += "ckey"
			if( id == GLOB.Banlist["id"] )
				if(matches)
					matches += "/"
				matches += "id"
			if( address == GLOB.Banlist["ip"] )
				if(matches)
					matches += "/"
				matches += "ip"
			if(matches)
				if(GLOB.Banlist["temp"])
					if (!GetExp(GLOB.Banlist["minutes"]))
						ClearTempbans()
						return 0
					else
						.["desc"] = "\nReason: [GLOB.Banlist["reason"]]\nExpires: [GetExp(GLOB.Banlist["minutes"])]\nBy: [GLOB.Banlist["bannedby"]][appeal]"
				else
					.["desc"] = "\nReason: [GLOB.Banlist["reason"]]\nExpires: <B>PERMENANT</B>\nBy: [GLOB.Banlist["bannedby"]][appeal]"
				.["reason"] = matches
				return .
	return 0

/proc/UpdateTime() //No idea why i made this a proc.
	GLOB.CMinutes = (world.realtime / 10) / 60
	return 1

/proc/LoadBans()

	GLOB.Banlist = new("data/banlist.bdb")
	log_admin("Loading GLOB.Banlist")

	if (!length(GLOB.Banlist.dir)) log_admin("GLOB.Banlist is empty.")

	if (!GLOB.Banlist.dir.Find("base"))
		log_admin("GLOB.Banlist missing base dir.")
		GLOB.Banlist.dir.Add("base")
		GLOB.Banlist.cd = "/base"
	else if (GLOB.Banlist.dir.Find("base"))
		GLOB.Banlist.cd = "/base"

	ClearTempbans()
	return 1

/proc/ClearTempbans()
	UpdateTime()

	GLOB.Banlist.cd = "/base"
	for (var/A in GLOB.Banlist.dir)
		GLOB.Banlist.cd = "/base/[A]"
		if (!GLOB.Banlist["key"] || !GLOB.Banlist["id"])
			RemoveBan(A)
			log_admin("Invalid Ban.")
			message_admins("Invalid Ban.")
			continue

		if (!GLOB.Banlist["temp"]) continue
		if (GLOB.CMinutes >= GLOB.Banlist["minutes"]) RemoveBan(A)

	return 1


/proc/AddBan(ckey, computerid, reason, bannedby, temp, minutes, address)
	if(!GLOB.Banlist) // if GLOB.Banlist cannot be located for some reason
		LoadBans() // try to load the bans
		if(!GLOB.Banlist) // uh oh, can't find bans!
			return 0 // ABORT ABORT ABORT

	var/bantimestamp

	if (temp)
		UpdateTime()
		bantimestamp = GLOB.CMinutes + minutes

	GLOB.Banlist.cd = "/base"
	if ( GLOB.Banlist.dir.Find("[ckey][computerid]"))
		RemoveBan("[ckey][computerid]") //have to remove dirs before processing

	GLOB.Banlist.dir.Add("[ckey][computerid]")
	GLOB.Banlist.cd = "/base/[ckey][computerid]"
	GLOB.Banlist["key"] << ckey
	GLOB.Banlist["id"] << computerid
	GLOB.Banlist["ip"] << address
	GLOB.Banlist["reason"] << reason
	GLOB.Banlist["bannedby"] << bannedby
	GLOB.Banlist["temp"] << temp
	if (temp)
		GLOB.Banlist["minutes"] << bantimestamp
	return 1

/proc/RemoveBan(foldername)
	if(!GLOB.Banlist) // if GLOB.Banlist cannot be located for some reason
		LoadBans() // try to load the bans
		if(!GLOB.Banlist) // uh oh, can't find bans!
			return 0 // ABORT ABORT ABORT

	var/key
	var/id

	GLOB.Banlist.cd = "/base/[foldername]"
	GLOB.Banlist["key"] >> key
	GLOB.Banlist["id"] >> id
	GLOB.Banlist.cd = "/base"

	if (!GLOB.Banlist.dir.Remove(foldername)) return 0

	if(!usr)
		log_admin("Ban Expired: [key]")
		message_admins("Ban Expired: [key]")
	else
		ban_unban_log_save("[key_name_admin(usr)] unbanned [key]")
		log_admin("[key_name_admin(usr)] unbanned [key]")
		message_admins("[key_name_admin(usr)] unbanned: [key]")
	for (var/A in GLOB.Banlist.dir)
		GLOB.Banlist.cd = "/base/[A]"
		if (key == GLOB.Banlist["key"] /*|| id == GLOB.Banlist["id"]*/)
			GLOB.Banlist.cd = "/base"
			GLOB.Banlist.dir.Remove(A)
			continue

	return 1

/proc/GetExp(minutes as num)
	UpdateTime()
	var/exp = minutes - GLOB.CMinutes
	if (exp <= 0)
		return 0
	else
		var/timeleftstring
		if (exp >= 1440) //1440 = 1 day in minutes
			timeleftstring = "[round(exp / 1440, 0.1)] Days"
		else if (exp >= 60) //60 = 1 hour in minutes
			timeleftstring = "[round(exp / 60, 0.1)] Hours"
		else
			timeleftstring = "[exp] Minutes"
		return timeleftstring

/datum/admins/proc/unbanpanel()
	var/dat

	var/list/datum/view_record/players/PBV = DB_VIEW(/datum/view_record/players, DB_OR(DB_COMP("is_permabanned", DB_EQUALS, 1), DB_COMP("is_time_banned", DB_EQUALS, 1))) // a filter

	for(var/datum/view_record/players/ban in PBV)
		var/expiry
		if(!ban.is_permabanned)
			expiry = GetExp(ban.expiration)
			if(!expiry)
				expiry = "Removal Pending"
		else
			expiry = "Permaban"
		var/unban_link
		if(ban.is_permabanned)
			unban_link = "<a href='?src=\ref[src];[HrefToken()];unban_perma=[ban.ckey]'>(UP)</a>"
		else
			unban_link = "<A href='?src=\ref[src];[HrefToken(forceGlobal = TRUE)];unbanf=[ban.ckey]'>(UT)</A>"

		dat += "<tr><td>[unban_link] Key: <B>[ban.ckey]</B></td><td>ComputerID: <B>[ban.last_known_cid]</B></td><td>IP: <B>[ban.last_known_ip]</B></td><td> [expiry]</td><td>(By: [ban.admin ? ban.admin : "AdminBot"])</td><td>(Reason: [ban.reason])</td></tr>"

	dat += "</table>"
	var/dat_header = "<HR><B>Bans:</B> <span class='[INTERFACE_BLUE]'>(UP) = Unban Perma (UT) = Unban Timed"
	dat_header += "</span> - <span class='[INTERFACE_GREEN]'>Ban Listing</span><HR><table border=1 rules=all frame=void cellspacing=0 cellpadding=3 >[dat]"
	show_browser(usr, dat_header, "Unban Panel", "unbanp", "size=875x400")

/datum/admins/proc/stickypanel()
	var/add_sticky = "<a href='?src=\ref[src];[HrefToken()];sticky=1;new_sticky=1'>Add Sticky Ban</a>"
	var/find_sticky = "<a href='?src=\ref[src];[HrefToken()];sticky=1;find_sticky=1'>Find Sticky Ban</a>"

	var/data = "<hr><b>Sticky Bans:</b> [add_sticky] [find_sticky] <table border=1 rules=all frame=void cellspacing=0 cellpadding=3>"

	var/list/datum/view_record/stickyban/stickies = DB_VIEW(/datum/view_record/stickyban,
		DB_COMP("active", DB_EQUALS, TRUE)
	)

	for(var/datum/view_record/stickyban/current_sticky in stickies)
		var/whitelist_link = "<a href='?src=\ref[src];[HrefToken()];sticky=[current_sticky.id];whitelist_ckey=1'>(WHITELIST)</a>"
		var/remove_sticky_link = "<a href='?src=\ref[src];[HrefToken()];sticky=[current_sticky.id];remove=1'>(REMOVE)</a>"
		var/add_to_sticky_link = "<a href='?src=\ref[src];[HrefToken()];sticky=[current_sticky.id];add=1'>(ADD)</a>"

		var/impacted_ckey_link = "<a href='?src=\ref[src];[HrefToken()];sticky=[current_sticky.id];view_all_ckeys=1'>CKEYs</a>"
		var/impacted_ip_link = "<a href='?src=\ref[src];[HrefToken()];sticky=[current_sticky.id];view_all_ips=1'>IPs</a>"
		var/impacted_cid_link = "<a href='?src=\ref[src];[HrefToken()];sticky=[current_sticky.id];view_all_cids=1'>CIDs</a>"

		data += "<tr><td>[whitelist_link][remove_sticky_link][add_to_sticky_link]</td><td>Identifier: [current_sticky.identifier]</td><td>Reason: [current_sticky.reason]</td><td>Message: [current_sticky.message]</td> <td>Admin: [current_sticky.admin]</td> <td>View: [impacted_ckey_link][impacted_ip_link][impacted_cid_link]</td></tr>"

	data += "</table>"

	show_browser(owner, data, "Stickyban Panel", "sticky", "size=875x400")

//////////////////////////////////// DEBUG ////////////////////////////////////

/proc/CreateBans()

	UpdateTime()

	var/i
	var/last

	for(i=0, i<1001, i++)
		var/a = pick(1,0)
		var/b = pick(1,0)
		if(b)
			GLOB.Banlist.cd = "/base"
			GLOB.Banlist.dir.Add("trash[i]trashid[i]")
			GLOB.Banlist.cd = "/base/trash[i]trashid[i]"
			GLOB.Banlist["key"] << "trash[i]"
		else
			GLOB.Banlist.cd = "/base"
			GLOB.Banlist.dir.Add("[last]trashid[i]")
			GLOB.Banlist.cd = "/base/[last]trashid[i]"
			GLOB.Banlist["key"] << last
		GLOB.Banlist["id"] << "trashid[i]"
		GLOB.Banlist["reason"] << "Trashban[i]."
		GLOB.Banlist["temp"] << a
		GLOB.Banlist["minutes"] << GLOB.CMinutes + rand(1,2000)
		GLOB.Banlist["bannedby"] << "trashmin"
		last = "trash[i]"

	GLOB.Banlist.cd = "/base"

/proc/ClearAllBans()
	GLOB.Banlist.cd = "/base"
	for (var/A in GLOB.Banlist.dir)
		RemoveBan(A)

/client/proc/cmd_admin_do_ban(mob/M)
	if(IsAdminAdvancedProcCall())
		alert_proccall("cmd_admin_do_ban")
		return PROC_BLOCKED
	if(!check_rights(R_BAN|R_MOD))  return

	if(!ismob(M)) return

	if(M.client && M.client.admin_holder && (M.client.admin_holder.rights & R_MOD))
		return //mods+ cannot be banned. Even if they could, the ban doesn't affect them anyway

	if(!M.ckey)
		to_chat(usr, SPAN_DANGER("<B>Warning: Mob ckey for [M.name] not found.</b>"))
		return
	var/mob_key = M.ckey
	var/mins = tgui_input_number(usr,"How long (in minutes)? \n 180 = 3 hours \n 1440 = 1 day \n 4320 = 3 days \n 10080 = 7 days \n 43800 = 1 Month","Ban time", 1440, 262800, 1)
	if(!mins)
		return
	if(mins >= 525600) mins = 525599
	var/reason = input(usr,"Reason? \n\nPress 'OK' to finalize the ban.","reason","Griefer") as message|null
	if(!reason)
		return
	var/datum/entity/player/P = get_player_from_key(mob_key) // you may not be logged in, but I will find you and I will ban you
	if(P.is_time_banned && alert(usr, "Ban already exists. Proceed?", "Confirmation", "Yes", "No") != "Yes")
		return
	P.add_timed_ban(reason, mins)

/client/proc/cmd_admin_do_stickyban(identifier, reason, message, list/impacted_ckeys, list/impacted_cids, list/impacted_ips)
	if(!identifier)
		identifier = tgui_input_text(src, "Name of the primary CKEY you are adding a stickyban to.", "BuildABan")
	if(!identifier)
		return

	if(!message)
		message = tgui_input_text(src, "What message should be given to the impacted users?", "BuildABan", encode = FALSE)
	if(!message)
		return

	if(!reason)
		reason = tgui_input_text(src, "What's the reason for the ban? This is shown internally, and not displayed in public notes and ban messages. Include as much detail as necessary.", "BuildABan", multiline = TRUE, encode = FALSE)
	if(!reason)
		return

	if(!length(impacted_ckeys))
		impacted_ckeys = splittext(tgui_input_text(src, "Which CKEYs should be impacted by this ban? Include the primary ckey, separated by semicolons.", "BuildABan", "player1;player2;player3"), ";")

	if(!length(impacted_cids))
		impacted_cids = splittext(tgui_input_text(src, "Which CIDs should be impacted by this ban? Separate with semicolons.", "BuildABan", "12345678;87654321"), ";")

	if(!length(impacted_ips))
		impacted_ips = splittext(tgui_input_text(src, "Which IPs should be impacted by this ban? Separate with semicolons.", "BuildABan", "1.1.1.1;8.8.8.8"), ";")

	var/datum/entity/stickyban/new_sticky = SSstickyban.add_stickyban(identifier, reason, message, player_data)

	if(!new_sticky)
		to_chat(src, SPAN_ADMIN("Failed to apply stickyban."))
		return

	for(var/ckey in impacted_ckeys)
		SSstickyban.add_matched_ckey(new_sticky.id, ckey)

	for(var/cid in impacted_cids)
		SSstickyban.add_matched_cid(new_sticky.id, cid)

	for(var/ip in impacted_ips)
		SSstickyban.add_matched_ip(new_sticky.id, ip)

	log_admin("STICKYBAN: Identifier: [identifier] Reason: [reason] Message: [message] CKEYs: [english_list(impacted_ckeys)] IPs: [english_list(impacted_ips)] CIDs: [english_list(impacted_cids)]")
	message_admins("[key_name_admin(src)] has added a new stickyban with the identifier '[identifier]'.")
	var/datum/tgs_chat_embed/field/reason_embed = new("Stickyban Reason", reason)
	important_message_external("[src] has added a new stickyban with the identifier '[identifier]'.", "Stickyban Placed", list(reason_embed))
