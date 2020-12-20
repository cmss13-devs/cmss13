var/CMinutes = null
var/savefile/Banlist


/proc/CheckBan(var/ckey, var/id, var/address)
	if(!Banlist)		// if Banlist cannot be located for some reason
		LoadBans()		// try to load the bans
		if(!Banlist)	// uh oh, can't find bans!
			return 0	// ABORT ABORT ABORT

	. = list()
	var/appeal
	if(CONFIG_GET(string/banappeals))
		appeal = "\nFor more information on your ban, or to appeal, head to <a href='[CONFIG_GET(string/banappeals)]'>[CONFIG_GET(string/banappeals)]</a>"
	Banlist.cd = "/base"
	if( "[ckey][id]" in Banlist.dir )
		Banlist.cd = "[ckey][id]"
		if (Banlist["temp"])
			if (!GetExp(Banlist["minutes"]))
				ClearTempbans()
				return 0
			else
				.["desc"] = "\nReason: [Banlist["reason"]]\nExpires: [GetExp(Banlist["minutes"])]\nBy: [Banlist["bannedby"]][appeal]"
		else
			Banlist.cd	= "/base/[ckey][id]"
			.["desc"]	= "\nReason: [Banlist["reason"]]\nExpires: <B>PERMENANT</B>\nBy: [Banlist["bannedby"]][appeal]"
		.["reason"]	= "ckey/id"
		return .
	else
		for (var/A in Banlist.dir)
			Banlist.cd = "/base/[A]"
			var/matches
			if( ckey == Banlist["key"] )
				matches += "ckey"
			if( id == Banlist["id"] )
				if(matches)
					matches += "/"
				matches += "id"
			if( address == Banlist["ip"] )
				if(matches)
					matches += "/"
				matches += "ip"
			if(matches)
				if(Banlist["temp"])
					if (!GetExp(Banlist["minutes"]))
						ClearTempbans()
						return 0
					else
						.["desc"] = "\nReason: [Banlist["reason"]]\nExpires: [GetExp(Banlist["minutes"])]\nBy: [Banlist["bannedby"]][appeal]"
				else
					.["desc"] = "\nReason: [Banlist["reason"]]\nExpires: <B>PERMENANT</B>\nBy: [Banlist["bannedby"]][appeal]"
				.["reason"] = matches
				return .
	return 0

/proc/UpdateTime() //No idea why i made this a proc.
	CMinutes = (world.realtime / 10) / 60
	return 1

/proc/LoadBans()

	Banlist = new("data/banlist.bdb")
	log_admin("Loading Banlist")

	if (!length(Banlist.dir)) log_admin("Banlist is empty.")

	if (!Banlist.dir.Find("base"))
		log_admin("Banlist missing base dir.")
		Banlist.dir.Add("base")
		Banlist.cd = "/base"
	else if (Banlist.dir.Find("base"))
		Banlist.cd = "/base"

	ClearTempbans()
	return 1

/proc/ClearTempbans()
	UpdateTime()

	Banlist.cd = "/base"
	for (var/A in Banlist.dir)
		Banlist.cd = "/base/[A]"
		if (!Banlist["key"] || !Banlist["id"])
			RemoveBan(A)
			log_admin("Invalid Ban.")
			message_staff("Invalid Ban.")
			continue

		if (!Banlist["temp"]) continue
		if (CMinutes >= Banlist["minutes"]) RemoveBan(A)

	return 1


/proc/AddBan(ckey, computerid, reason, bannedby, temp, minutes, address)
	if(!Banlist)		// if Banlist cannot be located for some reason
		LoadBans()		// try to load the bans
		if(!Banlist)	// uh oh, can't find bans!
			return 0	// ABORT ABORT ABORT

	var/bantimestamp

	if (temp)
		UpdateTime()
		bantimestamp = CMinutes + minutes

	Banlist.cd = "/base"
	if ( Banlist.dir.Find("[ckey][computerid]"))
		RemoveBan("[ckey][computerid]") //have to remove dirs before processing

	Banlist.dir.Add("[ckey][computerid]")
	Banlist.cd = "/base/[ckey][computerid]"
	Banlist["key"] << ckey
	Banlist["id"] << computerid
	Banlist["ip"] << address
	Banlist["reason"] << reason
	Banlist["bannedby"] << bannedby
	Banlist["temp"] << temp
	if (temp)
		Banlist["minutes"] << bantimestamp
	return 1

/proc/RemoveBan(foldername)
	if(!Banlist)		// if Banlist cannot be located for some reason
		LoadBans()		// try to load the bans
		if(!Banlist)	// uh oh, can't find bans!
			return 0	// ABORT ABORT ABORT

	var/key
	var/id

	Banlist.cd = "/base/[foldername]"
	Banlist["key"] >> key
	Banlist["id"] >> id
	Banlist.cd = "/base"

	if (!Banlist.dir.Remove(foldername)) return 0

	if(!usr)
		log_admin("Ban Expired: [key]")
		message_staff("Ban Expired: [key]")
	else
		ban_unban_log_save("[key_name_admin(usr)] unbanned [key]")
		log_admin("[key_name_admin(usr)] unbanned [key]")
		message_staff("[key_name_admin(usr)] unbanned: [key]")
	for (var/A in Banlist.dir)
		Banlist.cd = "/base/[A]"
		if (key == Banlist["key"] /*|| id == Banlist["id"]*/)
			Banlist.cd = "/base"
			Banlist.dir.Remove(A)
			continue

	return 1

/proc/GetExp(minutes as num)
	UpdateTime()
	var/exp = minutes - CMinutes
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

	var/list/datum/view_record/player_ban_view/PBV = DB_VIEW(/datum/view_record/player_ban_view) // no filter

	for(var/datum/view_record/player_ban_view/ban in PBV)
		var/expiry
		if(!ban.is_permabanned)
			expiry = GetExp(ban.expiration)
			if(!expiry)
				expiry = "Removal Pending"
		else
			expiry = "Permaban"
		var/unban_link = "<A href='?src=\ref[src];unbanf=[ban.ckey]'>(U)</A>"

		dat += "<tr><td>[unban_link] Key: <B>[ban.ckey]</B></td><td>ComputerID: <B>[ban.last_known_cid]</B></td><td>IP: <B>[ban.last_known_ip]</B></td><td> [expiry]</td><td>(By: [ban.admin])</td><td>(Reason: [ban.reason])</td></tr>"

	dat += "</table>"
	var/dat_header = "<HR><B>Bans:</B> <span class='[INTERFACE_BLUE]'>(U) = Unban"
	dat_header += "</span> - <span class='[INTERFACE_GREEN]'>Ban Listing</span><HR><table border=1 rules=all frame=void cellspacing=0 cellpadding=3 >[dat]"
	show_browser(usr, dat_header, "Unban Panel", "unbanp", "size=875x400")

//////////////////////////////////// DEBUG ////////////////////////////////////

/proc/CreateBans()

	UpdateTime()

	var/i
	var/last

	for(i=0, i<1001, i++)
		var/a = pick(1,0)
		var/b = pick(1,0)
		if(b)
			Banlist.cd = "/base"
			Banlist.dir.Add("trash[i]trashid[i]")
			Banlist.cd = "/base/trash[i]trashid[i]"
			Banlist["key"] << "trash[i]"
		else
			Banlist.cd = "/base"
			Banlist.dir.Add("[last]trashid[i]")
			Banlist.cd = "/base/[last]trashid[i]"
			Banlist["key"] << last
		Banlist["id"] << "trashid[i]"
		Banlist["reason"] << "Trashban[i]."
		Banlist["temp"] << a
		Banlist["minutes"] << CMinutes + rand(1,2000)
		Banlist["bannedby"] << "trashmin"
		last = "trash[i]"

	Banlist.cd = "/base"

/proc/ClearAllBans()
	Banlist.cd = "/base"
	for (var/A in Banlist.dir)
		RemoveBan(A)

/client/proc/cmd_admin_do_ban(var/mob/M)
	if(!check_rights(R_BAN|R_MOD))  return

	if(!ismob(M)) return

	if(M.client && M.client.admin_holder && (M.client.admin_holder.rights & R_MOD))
		return	//mods+ cannot be banned. Even if they could, the ban doesn't affect them anyway

	if(!M.ckey)
		to_chat(usr, SPAN_DANGER("<B>Warning: Mob ckey for [M.name] not found.</b>"))
		return
	var/mob_key = M.ckey
	var/mins = input(usr,"How long (in minutes)? \n 1440 = 1 day \n 4320 = 3 days \n 10080 = 7 days","Ban time",1440) as num|null
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