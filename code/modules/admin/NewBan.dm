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
				.["desc"] = "\nПричина: [GLOB.Banlist["reason"]]\nСрок: [GetExp(GLOB.Banlist["minutes"])]\nВыдан: [GLOB.Banlist["bannedby"]][appeal]"
		else
			GLOB.Banlist.cd = "/base/[ckey][id]"
			.["desc"] = "\nПричина: [GLOB.Banlist["reason"]]\nСрок: <B>ПЕРМА</B>\nВыдан: [GLOB.Banlist["bannedby"]][appeal]"
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
						.["desc"] = "\nПричина: [GLOB.Banlist["reason"]]\nСрок: [GetExp(GLOB.Banlist["minutes"])]\nBy: [GLOB.Banlist["bannedby"]][appeal]"
				else
					.["desc"] = "\nПричина: [GLOB.Banlist["reason"]]\nСрок: <B>ПЕРМА</B>\nВыдан: [GLOB.Banlist["bannedby"]][appeal]"
				.["reason"] = matches
				return .
	return 0

/proc/UpdateTime() //No idea why i made this a proc.
	GLOB.CMinutes = (world.realtime / 10) / 60
	return 1

/proc/LoadBans()

	GLOB.Banlist = new("data/GLOB.Banlist.bdb")
	log_admin("Loading GLOB.Banlist")

	if (!length(GLOB.Banlist.dir)) log_admin("Банлист пуст. Ой.")

	if (!GLOB.Banlist.dir.Find("base"))
		log_admin("Банлист не имеет базовой директории.")
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
			log_admin("Некорректный бан.")
			message_admins("Некорректный бан.")
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
		log_admin("Срок бана истек: [key]")
		message_admins("Срок бана истек: [key]")
	else
		ban_unban_log_save("[key_name_admin(usr)] разбанил [key]")
		log_admin("[key_name_admin(usr)] разбанил [key]")
		message_admins("[key_name_admin(usr)] разбанил: [key]")
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
			timeleftstring = "[round(exp / 1440, 0.1)] Дней"
		else if (exp >= 60) //60 = 1 hour in minutes
			timeleftstring = "[round(exp / 60, 0.1)] Часов"
		else
			timeleftstring = "[exp] Минут"
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
		var/unban_link = "<A href='?src=\ref[src];[HrefToken(forceGlobal = TRUE)];unbanf=[ban.ckey]'>(U)</A>"

		dat += "<tr><td>[unban_link] Ключ: <B>[ban.ckey]</B></td><td>ComputerID: <B>[ban.last_known_cid]</B></td><td>IP: <B>[ban.last_known_ip]</B></td><td> [expiry]</td><td>(By: [ban.admin])</td><td>(Причина: [ban.reason])</td></tr>"

	dat += "</table>"
	var/dat_header = "<HR><B>Баны:</B> <span class='[INTERFACE_BLUE]'>(U) = Разбанить"
	dat_header += "</span> - <span class='[INTERFACE_GREEN]'>Список банов</span><HR><table border=1 rules=all frame=void cellspacing=0 cellpadding=3 >[dat]"
	show_browser(usr, dat_header, "Панель Разбанов", "unbanp", "size=875x400")

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
		to_chat(usr, SPAN_DANGER("<B>Внимание: Сикей для моба [M.name] не найден.</b>"))
		return
	var/mob_key = M.ckey
	var/mins = tgui_input_number(usr,"На сколько (в минутах)? \n 180 = 3 часа \n 1440 = 1 день \n 4320 = 3 дня \n 10080 = Неделя \n 43800 = Месяц","Срок бана", 1440, 262800, 1)
	if(!mins)
		return
	if(mins >= 525600) mins = 525599
	var/reason = input(usr,"Причина? \n\nНажмите 'ОК' чтобы закончить.","причина","Гриферок") as message|null
	if(!reason)
		return
	var/datum/entity/player/P = get_player_from_key(mob_key) // you may not be logged in, but I will find you and I will ban you
	if(P.is_time_banned && alert(usr, "Бан уже существует. Продолжим?", "Подтверждение", "Да", "Нет") != "Да")
		return
	P.add_timed_ban(reason, mins)
