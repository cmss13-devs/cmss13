/datum/admins/Topic(href, href_list)
	..()

	if(usr.client != src.owner || !check_rights(0))
		message_admins("[usr.key] has attempted to override the admin panel!")
		return

	if(href_list["editrights"])
		if(!check_rights(R_PERMISSIONS))
			message_admins("[key_name_admin(usr)] attempted to edit the admin permissions without sufficient rights.")
			return

		var/adm_ckey

		var/task = href_list["editrights"]
		if(task == "add")
			var/new_ckey = ckey(input(usr,"New admin's ckey","Admin ckey", null) as text|null)
			if(!new_ckey)	return
			if(new_ckey in admin_datums)
				to_chat(usr, "<font color='red'>Error: Topic 'editrights': [new_ckey] is already an admin</font>")
				return
			adm_ckey = new_ckey
			task = "rank"
		else if(task != "show")
			adm_ckey = ckey(href_list["ckey"])
			if(!adm_ckey)
				to_chat(usr, "<font color='red'>Error: Topic 'editrights': No valid ckey</font>")
				return

		var/datum/admins/D = admin_datums[adm_ckey]

		if(task == "remove")
			if(alert("Are you sure you want to remove [adm_ckey]?","Message","Yes","Cancel") == "Yes")
				if(!D)	return
				admin_datums -= adm_ckey
				D.disassociate()

				message_admins("[key_name_admin(usr)] removed [adm_ckey] from the admins list")

		else if(task == "rank")
			var/new_rank
			if(admin_ranks.len)
				new_rank = input("Please select a rank", "New rank", null, null) as null|anything in (admin_ranks|"*New Rank*")
			else
				new_rank = input("Please select a rank", "New rank", null, null) as null|anything in list("Game Master","Game Admin", "Trial Admin", "Admin Observer","*New Rank*")

			var/rights = 0
			if(D)
				rights = D.rights
			switch(new_rank)
				if(null,"") return
				if("*New Rank*")
					new_rank = input("Please input a new rank", "New custom rank", null, null) as null|text
					if(CONFIG_GET(flag/admin_legacy_system))
						new_rank = ckeyEx(new_rank)
					if(!new_rank)
						to_chat(usr, "<font color='red'>Error: Topic 'editrights': Invalid rank</font>")
						return
					if(CONFIG_GET(flag/admin_legacy_system))
						if(admin_ranks.len)
							if(new_rank in admin_ranks)
								rights = admin_ranks[new_rank]		//we typed a rank which already exists, use its rights
							else
								admin_ranks[new_rank] = 0			//add the new rank to admin_ranks
				else
					if(CONFIG_GET(flag/admin_legacy_system))
						new_rank = ckeyEx(new_rank)
						rights = admin_ranks[new_rank]				//we input an existing rank, use its rights

			if(D)
				D.disassociate()								//remove adminverbs and unlink from client
				D.rank = new_rank								//update the rank
				D.rights = rights								//update the rights based on admin_ranks (default: 0)
			else
				D = new /datum/admins(new_rank, rights, adm_ckey)

			var/client/C = GLOB.directory[adm_ckey]						//find the client with the specified ckey (if they are logged in)
			D.associate(C)											//link up with the client and add verbs

			message_admins("[key_name_admin(usr)] edited the admin rank of [adm_ckey] to [new_rank]")

		else if(task == "permissions")
			if(!D)	return
			var/list/permissionlist = list()
			for(var/i=1, i<=R_HOST, i<<=1)		//that <<= is shorthand for i = i << 1. Which is a left bitshift
				permissionlist[rights2text(i)] = i
			var/new_permission = input("Select a permission to turn on/off", "Permission toggle", null, null) as null|anything in permissionlist
			if(!new_permission)	return
			D.rights ^= permissionlist[new_permission]

			message_admins("[key_name_admin(usr)] toggled the [new_permission] permission of [adm_ckey]")

//======================================================
//Everything that has to do with evac and self destruct.
//The rest of this is awful.
//======================================================
	if(href_list["evac_authority"])
		switch(href_list["evac_authority"])
			if("init_evac")
				if(!EvacuationAuthority.initiate_evacuation())
					to_chat(usr, SPAN_WARNING("You are unable to initiate an evacuation right now!"))
				else
					message_staff("[key_name_admin(usr)] called an evacuation.")

			if("cancel_evac")
				if(!EvacuationAuthority.cancel_evacuation())
					to_chat(usr, SPAN_WARNING("You are unable to cancel an evacuation right now!"))
				else
					message_staff("[key_name_admin(usr)] canceled an evacuation.")

			if("toggle_evac")
				EvacuationAuthority.flags_scuttle ^= FLAGS_EVACUATION_DENY
				message_staff("[key_name_admin(usr)] has [EvacuationAuthority.flags_scuttle & FLAGS_EVACUATION_DENY ? "forbidden" : "allowed"] ship-wide evacuation.")

			if("force_evac")
				if(!EvacuationAuthority.begin_launch())
					to_chat(usr, SPAN_WARNING("You are unable to launch the pods directly right now!"))
				else
					message_staff("[key_name_admin(usr)] force-launched the escape pods.")

			if("init_dest")
				if(!EvacuationAuthority.enable_self_destruct())
					to_chat(usr, SPAN_WARNING("You are unable to authorize the self-destruct right now!"))
				else
					message_staff("[key_name_admin(usr)] force-enabled the self-destruct system.")

			if("cancel_dest")
				if(!EvacuationAuthority.cancel_self_destruct(1))
					to_chat(usr, SPAN_WARNING("You are unable to cancel the self-destruct right now!"))
				else
					message_staff("[key_name_admin(usr)] canceled the self-destruct system.")

			if("use_dest")

				var/confirm = alert("Are you sure you want to self-destruct the Almayer?", "Self-Destruct", "Yes", "Cancel")
				if(confirm != "Yes")
					return

				if(!EvacuationAuthority.initiate_self_destruct(1))
					to_chat(usr, SPAN_WARNING("You are unable to trigger the self-destruct right now!"))
					return
				if(alert("Are you sure you want to destroy the Almayer right now?",, "Yes", "Cancel") == "Cancel") return

				message_staff("[key_name_admin(usr)] forced the self-destrust system, destroying the [MAIN_SHIP_NAME].")

			if("toggle_dest")
				EvacuationAuthority.flags_scuttle ^= FLAGS_SELF_DESTRUCT_DENY
				message_staff("[key_name_admin(usr)] has [EvacuationAuthority.flags_scuttle & FLAGS_SELF_DESTRUCT_DENY ? "forbidden" : "allowed"] the self-destruct system.")

//======================================================
//======================================================

	else if(href_list["delay_round_end"])
		if(!check_rights(R_SERVER))	return

		SSticker.delay_end = !SSticker.delay_end
		message_staff("[key_name(usr)] [SSticker.delay_end ? "delayed the round end" : "has made the round end normally"].")

	else if(href_list["simplemake"])

		if(!check_rights(R_SPAWN))	return

		var/mob/M = locate(href_list["mob"])
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		var/delmob = 0
		switch(alert("Delete old mob?","Message","Yes","No","Cancel"))
			if("Cancel")	return
			if("Yes")		delmob = 1

		message_staff("[key_name_admin(usr)] has used rudimentary transformation on [key_name_admin(M)]. Transforming to [href_list["simplemake"]]; deletemob=[delmob]")

		var/mob/transformed
		var/hivenumber = XENO_HIVE_NORMAL

		if(isXeno(M))
			var/mob/living/carbon/Xenomorph/X = M
			hivenumber = X.hivenumber

		switch(href_list["simplemake"])
			if("observer")			transformed = M.change_mob_type( /mob/dead/observer , null, null, delmob )

			if("larva")				transformed = M.change_mob_type( /mob/living/carbon/Xenomorph/Larva , null, null, delmob )
			if("defender")			transformed = M.change_mob_type( /mob/living/carbon/Xenomorph/Defender, null, null, delmob )
			if("warrior")			transformed = M.change_mob_type( /mob/living/carbon/Xenomorph/Warrior, null, null, delmob )
			if("runner")			transformed = M.change_mob_type( /mob/living/carbon/Xenomorph/Runner , null, null, delmob )
			if("drone")				transformed = M.change_mob_type( /mob/living/carbon/Xenomorph/Drone , null, null, delmob )
			if("sentinel")			transformed = M.change_mob_type( /mob/living/carbon/Xenomorph/Sentinel , null, null, delmob )
			if("lurker")			transformed = M.change_mob_type( /mob/living/carbon/Xenomorph/Lurker , null, null, delmob )
			if("carrier")			transformed = M.change_mob_type( /mob/living/carbon/Xenomorph/Carrier , null, null, delmob )
			if("hivelord")			transformed = M.change_mob_type( /mob/living/carbon/Xenomorph/Hivelord , null, null, delmob )
			if("praetorian")		transformed = M.change_mob_type( /mob/living/carbon/Xenomorph/Praetorian , null, null, delmob )
			if("ravager")			transformed = M.change_mob_type( /mob/living/carbon/Xenomorph/Ravager , null, null, delmob )
			if("spitter")			transformed = M.change_mob_type( /mob/living/carbon/Xenomorph/Spitter , null, null, delmob )
			if("boiler")			transformed = M.change_mob_type( /mob/living/carbon/Xenomorph/Boiler , null, null, delmob )
			if("burrower")			transformed = M.change_mob_type( /mob/living/carbon/Xenomorph/Burrower , null, null, delmob )
			if("crusher")			transformed = M.change_mob_type( /mob/living/carbon/Xenomorph/Crusher , null, null, delmob )
			if("queen")				transformed = M.change_mob_type( /mob/living/carbon/Xenomorph/Queen , null, null, delmob )
			if("predalien")			transformed = M.change_mob_type( /mob/living/carbon/Xenomorph/Predalien , null, null, delmob )

			if("human")				transformed = M.change_mob_type( /mob/living/carbon/human , null, null, delmob, href_list["species"])
			if("monkey")			transformed = M.change_mob_type( /mob/living/carbon/human/monkey , null, null, delmob )
			if("farwa")				transformed = M.change_mob_type( /mob/living/carbon/human/farwa , null, null, delmob )
			if("neaera")			transformed = M.change_mob_type( /mob/living/carbon/human/neaera , null, null, delmob )
			if("yiren")				transformed = M.change_mob_type( /mob/living/carbon/human/yiren , null, null, delmob )
			if("robot")				transformed = M.change_mob_type( /mob/living/silicon/robot , null, null, delmob )
			if("cat")				transformed = M.change_mob_type( /mob/living/simple_animal/cat , null, null, delmob )
			if("runtime")			transformed = M.change_mob_type( /mob/living/simple_animal/cat/Runtime , null, null, delmob )
			if("corgi")				transformed = M.change_mob_type( /mob/living/simple_animal/corgi , null, null, delmob )
			if("ian")				transformed = M.change_mob_type( /mob/living/simple_animal/corgi/Ian , null, null, delmob )
			if("crab")				transformed = M.change_mob_type( /mob/living/simple_animal/crab , null, null, delmob )
			if("coffee")			transformed = M.change_mob_type( /mob/living/simple_animal/crab/Coffee , null, null, delmob )
			if("parrot")			transformed = M.change_mob_type( /mob/living/simple_animal/parrot , null, null, delmob )
			if("polyparrot")		transformed = M.change_mob_type( /mob/living/simple_animal/parrot/Poly , null, null, delmob )

		if(isXeno(transformed) && hivenumber)
			var/mob/living/carbon/Xenomorph/X = transformed
			X.set_hive_and_update(hivenumber)

	/////////////////////////////////////new ban stuff
	else if(href_list["unbanf"])
		var/datum/entity/player/P = get_player_from_key(href_list["unbanf"])
		switch(alert("Are you sure you want to remove timed ban from [P.ckey]?", , "Yes", "No"))
			if("No")
				return
		if(!P.remove_timed_ban())
			alert(usr, "This ban has already been lifted / does not exist.", "Error", "Ok")
		unbanpanel()

	else if(href_list["warn"])
		usr.client.warn(href_list["warn"])

	else if(href_list["unbanupgradeperma"])
		if(!check_rights(R_ADMIN)) return
		UpdateTime()
		var/reason

		var/banfolder = href_list["unbanupgradeperma"]
		Banlist.cd = "/base/[banfolder]"
		var/reason2 = Banlist["reason"]

		var/minutes = Banlist["minutes"]

		var/banned_key = Banlist["key"]
		Banlist.cd = "/base"

		var/mins = 0
		if(minutes > CMinutes)
			mins = minutes - CMinutes
		if(!mins)	return
		mins = max(5255990,mins) // 10 years
		minutes = CMinutes + mins
		reason = input(usr,"Reason?","reason",reason2) as message|null
		if(!reason)	return

		ban_unban_log_save("[key_name(usr)] upgraded [banned_key]'s ban to a permaban. Reason: [sanitize(reason)]")
		message_staff("[key_name_admin(usr)] upgraded [banned_key]'s ban to a permaban. Reason: [sanitize(reason)]")
		Banlist.cd = "/base/[banfolder]"
		Banlist["reason"] << sanitize(reason)
		Banlist["temp"] << 0
		Banlist["minutes"] << minutes
		Banlist["bannedby"] << usr.ckey
		Banlist.cd = "/base"
		unbanpanel()

	else if(href_list["unbane"])
		if(!check_rights(R_BAN))	return

		UpdateTime()
		var/reason

		var/banfolder = href_list["unbane"]
		Banlist.cd = "/base/[banfolder]"
		var/reason2 = Banlist["reason"]
		var/temp = Banlist["temp"]

		var/minutes = Banlist["minutes"]

		var/banned_key = Banlist["key"]
		Banlist.cd = "/base"

		var/duration

		var/mins = 0
		if(minutes > CMinutes)
			mins = minutes - CMinutes
		mins = input(usr,"How long (in minutes)? \n 1440 = 1 day \n 4320 = 3 days \n 10080 = 7 days","Ban time",1440) as num|null
		if(!mins)	return
		mins = min(525599,mins)
		minutes = CMinutes + mins
		duration = GetExp(minutes)
		reason = input(usr,"Reason?","reason",reason2) as message|null
		if(!reason)	return

		ban_unban_log_save("[key_name(usr)] edited [banned_key]'s ban. Reason: [sanitize(reason)] Duration: [duration]")
		message_staff("[key_name_admin(usr)] edited [banned_key]'s ban. Reason: [sanitize(reason)] Duration: [duration]")
		Banlist.cd = "/base/[banfolder]"
		Banlist["reason"] << sanitize(reason)
		Banlist["temp"] << temp
		Banlist["minutes"] << minutes
		Banlist["bannedby"] << usr.ckey
		Banlist.cd = "/base"
		unbanpanel()

	/////////////////////////////////////new ban stuff

	else if(href_list["jobban2"])
//		if(!check_rights(R_BAN))	return
		/*
		var/mob/M = locate(href_list["jobban2"])
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		if(!M.ckey)	//sanity
			to_chat(usr, "This mob has no ckey")
			return
		if(!RoleAuthority)
			to_chat(usr, "The Role Authority is not set up!")
			return

		var/datum/entity/player/P = get_player_from_key(M.ckey)

		var/dat = ""
		var/body
		var/jobs = ""

	/***********************************WARNING!************************************
				      The jobban stuff looks mangled and disgusting
						      But it looks beautiful in-game
						                -Nodrak
	************************************WARNING!***********************************/
//Regular jobs
	//Command (Blue)
		jobs += generate_job_ban_list(M, ROLES_CIC, "CIC", "ddddff")
		jobs += "<br>"
	// SUPPORT
		jobs += generate_job_ban_list(M, ROLES_AUXIL_SUPPORT, "Support", "ccccff")
		jobs += "<br>"
	// MPs
		jobs += generate_job_ban_list(M, ROLES_POLICE, "Police", "ffdddd")
		jobs += "<br>"
	//Engineering (Yellow)
		jobs += generate_job_ban_list(M, ROLES_ENGINEERING, "Engineering", "fff5cc")
		jobs += "<br>"
	//Cargo (Yellow) //Copy paste, yada, yada. Hopefully Snail can rework this in the future.
		jobs += generate_job_ban_list(M, ROLES_REQUISITION, "Requisition", "fff5cc")
		jobs += "<br>"
	//Medical (White)
		jobs += generate_job_ban_list(M, ROLES_MEDICAL, "Medical", "ffeef0")
		jobs += "<br>"
	//Marines
		jobs += generate_job_ban_list(M, ROLES_MARINES, "Marines", "ffeeee")
		jobs += "<br>"
	// MISC
		jobs += generate_job_ban_list(M, ROLES_MISC, "Misc", "aaee55")
		jobs += "<br>"
	// Xenos (Orange)
		jobs += generate_job_ban_list(M, ROLES_XENO, "Xenos", "a268b1")
		jobs += "<br>"
	//Extra (Orange)
		var/isbanned_dept = jobban_isbanned(M, "Syndicate", P)
		jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
		jobs += "<tr bgcolor='ffeeaa'><th colspan='10'><a href='?src=\ref[src];jobban3=Syndicate;jobban4=\ref[M]'>Extras</a></th></tr><tr align='center'>"

		//ERT
		if(jobban_isbanned(M, "Emergency Response Team", P) || isbanned_dept)
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=Emergency Response Team;jobban4=\ref[M]'><font color=red>Emergency Response Team</font></a></td>"
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=Emergency Response Team;jobban4=\ref[M]'>Emergency Response Team</a></td>"

		//Survivor
		if(jobban_isbanned(M, "Survivor", P) || isbanned_dept)
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=Survivor;jobban4=\ref[M]'><font color=red>Survivor</font></a></td>"
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=Survivor;jobban4=\ref[M]'>Survivor</a></td>"

		if(jobban_isbanned(M, "Agent", P) || isbanned_dept)
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=Agent;jobban4=\ref[M]'><font color=red>Agent</font></a></td>"
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=Agent;jobban4=\ref[M]'>Agent</a></td>"

		body = "<body>[jobs]</body>"
		dat = "<tt>[body]</tt>"
		show_browser(usr, dat, "Job-Ban Panel: [M.name]", "jobban2", "size=800x490")
		return*/ // DEPRECATED
	//JOBBAN'S INNARDS
	else if(href_list["jobban3"])
		if(!check_rights(R_MOD,0) && !check_rights(R_ADMIN))  return

		var/mob/M = locate(href_list["jobban4"])
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		if(M != usr)																//we can jobban ourselves
			if(M.client && M.client.admin_holder && (M.client.admin_holder.rights & R_BAN))		//they can ban too. So we can't ban them
				alert("You cannot perform this action. You must be of a higher administrative rank!")
				return

		if(!RoleAuthority)
			to_chat(usr, "Role Authority has not been set up!")
			return


		var/datum/entity/player/P1 = M.client?.player_data
		if(!P1)
			P1 = get_player_from_key(M.ckey)

		//get jobs for department if specified, otherwise just returnt he one job in a list.
		var/list/joblist = list()
		switch(href_list["jobban3"])
			if("CICdept")
				joblist += get_job_titles_from_list(ROLES_COMMAND)
			if("Supportdept")
				joblist += get_job_titles_from_list(ROLES_AUXIL_SUPPORT)
			if("Policedept")
				joblist += get_job_titles_from_list(ROLES_POLICE)
			if("Engineeringdept")
				joblist += get_job_titles_from_list(ROLES_ENGINEERING)
			if("Requisitiondept")
				joblist += get_job_titles_from_list(ROLES_REQUISITION)
			if("Medicaldept")
				joblist += get_job_titles_from_list(ROLES_MEDICAL)
			if("Marinesdept")
				joblist += get_job_titles_from_list(ROLES_MARINES)
			if("Miscdept")
				joblist += get_job_titles_from_list(ROLES_MISC)
			if("Xenosdept")
				joblist += get_job_titles_from_list(ROLES_XENO)
			else
				joblist += href_list["jobban3"]

		var/list/notbannedlist = list()
		for(var/job in joblist)
			if(!jobban_isbanned(M, job, P1))
				notbannedlist += job

		//Banning comes first
		if(notbannedlist.len)
			if(!check_rights(R_BAN))  return
			var/reason = input(usr,"Reason?","Please State Reason","") as text|null
			if(reason)
				var/datum/entity/player/P = get_player_from_key(M.ckey)
				P.add_job_ban(reason, notbannedlist)

				href_list["jobban2"] = 1 // lets it fall through and refresh
				return 1

		//Unbanning joblist
		//all jobs in joblist are banned already OR we didn't give a reason (implying they shouldn't be banned)
		if(joblist.len) //at least 1 banned job exists in joblist so we have stuff to unban.
			for(var/job in joblist)
				var/reason = jobban_isbanned(M, job, P1)
				if(!reason) continue //skip if it isn't jobbanned anyway
				switch(alert("Job: '[job]' Reason: '[reason]' Un-jobban?","Please Confirm","Yes","No"))
					if("Yes")
						P1.remove_job_ban(job)
					else
						continue
			href_list["jobban2"] = 1 // lets it fall through and refresh

			return 1
		return 0 //we didn't do anything!

	else if(href_list["boot2"])
		var/mob/M = locate(href_list["boot2"])
		if (ismob(M))
			if(!check_if_greater_rights_than(M.client))
				return
			var/reason = input("Please enter reason")
			if(!reason)
				to_chat_forced(M, SPAN_WARNING("You have been kicked from the server"))
			else
				to_chat_forced(M, SPAN_WARNING("You have been kicked from the server: [reason]"))
			message_staff("[key_name_admin(usr)] booted [key_name_admin(M)].")
			qdel(M.client)

	else if(href_list["removejobban"])
		if(!check_rights(R_BAN))	return

		var/t = href_list["removejobban"]
		if(t)
			if((alert("Do you want to unjobban [t]?","Unjobban confirmation", "Yes", "No") == "Yes") && t) //No more misclicks! Unless you do it twice.
				message_staff("[key_name_admin(usr)] removed [t]")
				jobban_remove(t)
				jobban_savebanfile()
				href_list["ban"] = 1 // lets it fall through and refresh

	else if(href_list["newban"])
		if(!check_rights(R_MOD,0) && !check_rights(R_BAN))  return

		var/mob/M = locate(href_list["newban"])
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

	else if(href_list["eorgban"])
		if(!check_rights(R_MOD,0) && !check_rights(R_BAN))  return

		var/mob/M = locate(href_list["eorgban"])
		if(!ismob(M)) return

		if(M.client && M.client.admin_holder)	return	//admins cannot be banned. Even if they could, the ban doesn't affect them anyway

		if(!M.ckey)
			to_chat(usr, SPAN_DANGER("<B>Warning: Mob ckey for [M.name] not found.</b>"))
			return

		var/mins = 0
		var/reason = ""
		switch(alert("Are you sure you want to EORG ban [M.ckey]?", , "Yes", "No"))
			if("Yes")
				mins = 180
				reason = "EORG"
			if("No")
				return
		var/datum/entity/player/P = get_player_from_key(M.ckey) // you may not be logged in, but I will find you and I will ban you
		if(P.is_time_banned && alert(usr, "Ban already exists. Proceed?", "Confirmation", "Yes", "No") != "Yes")
			return
		P.add_timed_ban(reason, mins)

	else if(href_list["xenoresetname"])
		if(!check_rights(R_MOD,0) && !check_rights(R_BAN))
			return

		var/mob/living/carbon/Xenomorph/X = locate(href_list["xenoresetname"])
		if(!isXeno(X))
			to_chat(usr, SPAN_WARNING("Not a xeno"))
			return

		if(alert("Are you sure you want to reset xeno name for [X.ckey]?", , "Yes", "No") == "No")
			return

		if(!X.ckey)
			to_chat(usr, SPAN_DANGER("Warning: Mob ckey for [X.name] not found."))
			return

		message_staff("[usr.client.ckey] has reset [X.ckey] xeno name")

		to_chat(X, SPAN_DANGER("Warning: Your xeno name has been reset by [usr.client.ckey]."))

		X.client.xeno_prefix = "XX"
		X.client.xeno_postfix = ""
		X.client.prefs.xeno_prefix = "XX"
		X.client.prefs.xeno_postfix = ""

		X.client.prefs.save_preferences()
		X.generate_name()

	else if(href_list["xenobanname"])
		if(!check_rights(R_MOD,0) && !check_rights(R_BAN))
			return

		var/mob/living/carbon/Xenomorph/X = locate(href_list["xenobanname"])
		var/mob/M = locate(href_list["xenobanname"])

		if(ismob(M) && X.client && X.client.xeno_name_ban)
			if(alert("Are you sure you want to UNBAN [X.ckey] and let them use xeno name?", ,"Yes", "No") == "No")
				return
			X.client.xeno_name_ban = FALSE
			X.client.prefs.xeno_name_ban = FALSE

			X.client.prefs.save_preferences()
			message_staff("[usr.client.ckey] has unbanned [X.ckey] from using xeno names")

			notes_add(X.ckey, "Xeno Name Unbanned by [usr.client.ckey]", usr)
			to_chat(X, SPAN_DANGER("Warning: You can use xeno names again."))
			return


		if(!isXeno(X))
			to_chat(usr, SPAN_WARNING("Not a xeno"))
			return

		if(alert("Are you sure you want to BAN [X.ckey] from ever using any xeno name?", , "Yes", "No") == "No")
			return

		if(!X.ckey)
			to_chat(usr, SPAN_DANGER("Warning: Mob ckey for [X.name] not found."))
			return

		message_staff("[usr.client.ckey] has banned [X.ckey] from using xeno names")

		notes_add(X.ckey, "Xeno Name Banned by [usr.client.ckey]|Reason: Xeno name was [X.name]", usr)

		to_chat(X, SPAN_DANGER("Warning: You were banned from using xeno names by [usr.client.ckey]."))

		X.client.xeno_prefix = "XX"
		X.client.xeno_postfix = ""
		X.client.xeno_name_ban = TRUE
		X.client.prefs.xeno_prefix = "XX"
		X.client.prefs.xeno_postfix = ""
		X.client.prefs.xeno_name_ban = TRUE

		X.client.prefs.save_preferences()
		X.generate_name()

	else if(href_list["mute"])
		if(!check_rights(R_MOD,0) && !check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["mute"])
		if(!ismob(M))	return
		if(!M.client)	return

		var/mute_type = href_list["mute_type"]
		if(istext(mute_type))	mute_type = text2num(mute_type)
		if(!isnum(mute_type))	return

		cmd_admin_mute(M, mute_type)

	else if(href_list["chem_panel"])
		topic_chems(href_list["chem_panel"])

	else if(href_list["c_mode"])
		if(!check_rights(R_ADMIN))	return

		if(SSticker.mode)
			return alert(usr, "The game has already started.", null, null, null, null)
		var/dat = {"<B>What mode do you wish to play?</B><HR>"}
		for(var/mode in config.modes)
			dat += {"<A href='?src=\ref[src];c_mode2=[mode]'>[config.mode_names[mode]]</A><br>"}
		dat += {"Now: [master_mode]"}
		show_browser(usr, dat, "Change Gamemode", "c_mode")

	else if(href_list["f_secret"])
		if(!check_rights(R_ADMIN))	return

		if(SSticker.mode)
			return alert(usr, "The game has already started.", null, null, null, null)
		if(master_mode != "secret")
			return alert(usr, "The game mode has to be secret!", null, null, null, null)
		var/dat = {"<B>What game mode do you want to force secret to be? Use this if you want to change the game mode, but want the players to believe it's secret. This will only work if the current game mode is secret.</B><HR>"}
		for(var/mode in config.modes)
			dat += {"<A href='?src=\ref[src];f_secret2=[mode]'>[config.mode_names[mode]]</A><br>"}
		dat += {"<A href='?src=\ref[src];f_secret2=secret'>Random (default)</A><br>"}
		dat += {"Now: [secret_force_mode]"}
		show_browser(usr, dat, "Change Secret Gamemode", "f_secret")

	else if(href_list["c_mode2"])
		if(!check_rights(R_ADMIN|R_SERVER))	return

		if (SSticker.mode)
			return alert(usr, "The game has already started.", null, null, null, null)
		master_mode = href_list["c_mode2"]
		message_staff("[key_name_admin(usr)] set the mode as [master_mode].")
		to_world(SPAN_NOTICE("<b><i>The mode is now: [master_mode]!</i></b>"))
		Game() // updates the main game menu
		world.save_mode(master_mode)
		.(href, list("c_mode"=1))


	else if(href_list["f_secret2"])
		if(!check_rights(R_ADMIN|R_SERVER))	return

		if(SSticker.mode)
			return alert(usr, "The game has already started.", null, null, null, null)
		if(master_mode != "secret")
			return alert(usr, "The game mode has to be secret!", null, null, null, null)
		secret_force_mode = href_list["f_secret2"]
		message_staff("[key_name_admin(usr)] set the forced secret mode as [secret_force_mode].")
		Game() // updates the main game menu
		.(href, list("f_secret"=1))

	else if(href_list["monkeyone"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["monkeyone"])
		if(!istype(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human")
			return

		message_staff("[key_name_admin(usr)] attempting to monkeyize [key_name_admin(H)]")
		H.monkeyize()

	else if(href_list["corgione"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["corgione"])
		if(!istype(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human")
			return

		message_staff("[key_name_admin(usr)] attempting to corgize [key_name_admin(H)]")
		H.corgize()

	else if(href_list["forcespeech"])
		if(!check_rights(R_FUN))	return

		var/mob/M = locate(href_list["forcespeech"])
		if(!ismob(M))
			to_chat(usr, "this can only be used on instances of type /mob")
			return

		var/speech = input("What will [key_name(M)] say?.", "Force speech", "")// Don't need to sanitize, since it does that in say(), we also trust our admins.
		if(!speech)	return
		M.say(speech)
		speech = sanitize(speech) // Nah, we don't trust them
		message_staff("[key_name_admin(usr)] forced [key_name_admin(M)] to say: [speech]")

	else if(href_list["zombieinfect"])
		if(!check_rights(R_ADMIN))	return
		var/mob/living/carbon/human/H = locate(href_list["zombieinfect"])
		if(!istype(H))
			to_chat(usr, "this can only be used on instances of type /human")
			return

		if(alert(usr, "Are you sure you want to infect them with a ZOMBIE VIRUS? This can trigger a major event!", "Message", "Yes", "No") != "Yes")
			return

		var/datum/disease/black_goo/bg = new()
		if(alert(usr, "Make them non-symptomatic carrier?", "Message", "Yes", "No") == "Yes")
			bg.carrier = TRUE
		else
			bg.carrier = FALSE

		H.AddDisease(bg, FALSE)

		message_staff("[key_name_admin(usr)] infected [key_name_admin(H)] with a ZOMBIE VIRUS")
	else if(href_list["larvainfect"])
		if(!check_rights(R_ADMIN))	return
		var/mob/living/carbon/human/H = locate(href_list["larvainfect"])
		if(!istype(H))
			to_chat(usr, "this can only be used on instances of type /human")
			return

		if(alert(usr, "Are you sure you want to infect them with a xeno larva?", "Message", "Yes", "No") != "Yes")
			return

		var/list/hives = list()
		for(var/datum/hive_status/hive in GLOB.hive_datum)
			hives += list("[hive.name]" = hive.hivenumber)

		var/newhive = input(usr,"Select a hive.", null, null) in hives

		if(!H)
			to_chat(usr, "This mob no longer exists")
			return

		var/obj/item/alien_embryo/embryo = new /obj/item/alien_embryo(H)
		embryo.hivenumber = hives[newhive]
		embryo.faction = newhive

		message_staff("[key_name_admin(usr)] infected [key_name_admin(H)] with a xeno ([newhive]) larva.")

	else if(href_list["makemutineer"])
		if(!check_rights(R_DEBUG|R_SPAWN))
			return

		var/mob/living/carbon/human/H = locate(href_list["makemutineer"])
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon/human")
			return

		if(H.faction != FACTION_MARINE)
			to_chat(usr, "This player's faction must equal '[FACTION_MARINE]' to make them a mutineer.")
			return

		var/datum/equipment_preset/other/mutineer/leader/leader_preset = new()
		leader_preset.load_status(H)

		message_staff("[key_name_admin(usr)] has made [key_name_admin(H)] into a mutineer leader.")

	else if(href_list["makecultist"] || href_list["makecultistleader"])
		if(!check_rights(R_DEBUG|R_SPAWN))
			return

		var/mob/living/carbon/human/H = locate(href_list["makecultist"]) || locate(href_list["makecultistleader"])
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon/human")
			return

		var/list/hives = list();
		for(var/datum/hive_status/hive in GLOB.hive_datum)
			LAZYSET(hives, hive.name, hive)
		LAZYSET(hives, "CANCEL", null)

		var/hive_name = input("Which Hive will he belongs to") in hives
		if(!hive_name || hive_name == "CANCEL")
			to_chat(usr, SPAN_ALERT("Hive choice error. Aborting."))

		var/datum/hive_status/hive = hives[hive_name]

		if(href_list["makecultist"])
			var/datum/equipment_preset/other/xeno_cultist/XC = new()
			XC.load_race(H, hive.hivenumber)
			XC.load_status(H)
			message_staff("[key_name_admin(usr)] has made [key_name_admin(H)] into a cultist for [hive.name].")

		else if(href_list["makecultistleader"])
			var/datum/equipment_preset/other/xeno_cultist/leader/XC = new()
			XC.load_race(H, hive.hivenumber)
			XC.load_status(H)
			message_staff("[key_name_admin(usr)] has made [key_name_admin(H)] into a cultist leader for [hive.name].")

		H.faction = hive.internal_faction

	else if(href_list["forceemote"])
		if(!check_rights(R_FUN))	return

		var/mob/M = locate(href_list["forceemote"])
		if(!ismob(M))
			to_chat(usr, "this can only be used on instances of type /mob")

		var/speech = input("What will [key_name(M)] emote?.", "Force emote", "")// Don't need to sanitize, since it does that in say(), we also trust our admins.
		if(!speech)	return
		M.custom_emote(1, speech, TRUE)
		speech = sanitize(speech) // Nah, we don't trust them
		message_staff("[key_name_admin(usr)] forced [key_name_admin(M)] to emote: [speech]")

	else if(href_list["sendbacktolobby"])
		if(!check_rights(R_MOD))
			return

		var/mob/M = locate(href_list["sendbacktolobby"])

		if(!isobserver(M))
			to_chat(usr, SPAN_NOTICE("You can only send ghost players back to the Lobby."))
			return

		if(!M.client)
			to_chat(usr, SPAN_WARNING("[M] doesn't seem to have an active client."))
			return

		if(alert(usr, "Send [key_name(M)] back to Lobby?", "Message", "Yes", "No") != "Yes")
			return

		message_staff("[key_name(usr)] has sent [key_name(M)] back to the Lobby.")

		var/mob/new_player/NP = new()
		NP.ckey = M.ckey
		qdel(M)

	else if(href_list["tdome1"])
		if(!check_rights(R_FUN))	return

		if(alert(usr, "Confirm?", "Message", "Yes", "No") != "Yes")
			return

		var/mob/M = locate(href_list["tdome1"])
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return
		if(isAI(M))
			to_chat(usr, "This cannot be used on instances of type /mob/living/silicon/ai")
			return

		for(var/obj/item/I in M)
			M.drop_inv_item_on_ground(I)

		M.KnockOut(5)
		sleep(5)
		M.forceMove(get_turf(pick(GLOB.thunderdome_one)))
		spawn(50)
			to_chat(M, SPAN_NOTICE(" You have been sent to the Thunderdome."))
		message_staff("[key_name_admin(usr)] has sent [key_name_admin(M)] to the thunderdome. (Team 1)", 1)

	else if(href_list["tdome2"])
		if(!check_rights(R_FUN))	return

		if(alert(usr, "Confirm?", "Message", "Yes", "No") != "Yes")
			return

		var/mob/M = locate(href_list["tdome2"])
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return
		if(isAI(M))
			to_chat(usr, "This cannot be used on instances of type /mob/living/silicon/ai")
			return

		for(var/obj/item/I in M)
			M.drop_inv_item_on_ground(I)

		M.KnockOut(5)
		sleep(5)
		M.forceMove(get_turf(pick(GLOB.thunderdome_two)))
		spawn(50)
			to_chat(M, SPAN_NOTICE(" You have been sent to the Thunderdome."))
		message_staff("[key_name_admin(usr)] has sent [key_name_admin(M)] to the thunderdome. (Team 2)", 1)

	else if(href_list["tdomeadmin"])
		if(!check_rights(R_FUN))	return

		if(alert(usr, "Confirm?", "Message", "Yes", "No") != "Yes")
			return

		var/mob/M = locate(href_list["tdomeadmin"])
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return
		if(isAI(M))
			to_chat(usr, "This cannot be used on instances of type /mob/living/silicon/ai")
			return

		M.KnockOut(5)
		sleep(5)
		M.forceMove(get_turf(pick(GLOB.thunderdome_admin)))
		spawn(50)
			to_chat(M, SPAN_NOTICE(" You have been sent to the Thunderdome."))
		message_staff("[key_name_admin(usr)] has sent [key_name_admin(M)] to the thunderdome. (Admin.)", 1)

	else if(href_list["tdomeobserve"])
		if(!check_rights(R_FUN))	return

		if(alert(usr, "Confirm?", "Message", "Yes", "No") != "Yes")
			return

		var/mob/M = locate(href_list["tdomeobserve"])
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return
		if(isAI(M))
			to_chat(usr, "This cannot be used on instances of type /mob/living/silicon/ai")
			return

		for(var/obj/item/I in M)
			M.drop_inv_item_on_ground(I)

		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/observer = M
			observer.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket(observer), WEAR_BODY)
			observer.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(observer), WEAR_FEET)
		M.KnockOut(5)
		sleep(5)
		M.forceMove(get_turf(pick(GLOB.thunderdome_observer)))
		spawn(50)
			to_chat(M, SPAN_NOTICE(" You have been sent to the Thunderdome."))
		message_staff("[key_name_admin(usr)] has sent [key_name_admin(M)] to the thunderdome. (Observer.)", 1)

	else if(href_list["revive"])
		if(!check_rights(R_REJUVINATE))	return

		var/mob/living/L = locate(href_list["revive"])
		if(!istype(L))
			to_chat(usr, "This can only be used on instances of type /mob/living")
			return

		L.revive()
		message_staff(WRAP_STAFF_LOG(usr, "ahealed [key_name(L)] in [get_area(L)] ([L.x],[L.y],[L.z])."), L.x, L.y, L.z)

	else if(href_list["makealien"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["makealien"])
		if(!istype(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human")
			return

		usr.client.cmd_admin_alienize(H)

	else if(href_list["makeai"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["makeai"])
		if(!istype(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human")
			return

		message_staff(SPAN_DANGER("Admin [key_name_admin(usr)] AIized [key_name_admin(H)]!"), 1)
		H.AIize()

	else if(href_list["changehivenumber"])
		if(!check_rights(R_DEBUG|R_ADMIN))	return

		var/mob/living/carbon/H = locate(href_list["changehivenumber"])
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon/")
			return
		if(usr.client)
			usr.client.cmd_admin_change_their_hivenumber(H)

	else if(href_list["makeyautja"])
		if(!check_rights(R_SPAWN))	return

		if(alert("Are you sure you want to make this person into a yautja? It will delete their old character.","Make Yautja","Yes","No") == "No")
			return

		var/mob/H = locate(href_list["makeyautja"])

		if(!istype(H))
			to_chat(usr, "This can only be used on mobs. How did you even do this?")
			return

		if(!usr.loc || !isturf(usr.loc))
			to_chat(usr, "Only on turfs, please.")
			return

		var/y_name = input(usr, "What name would you like to give this new Predator?","Name", "")
		if(!y_name)
			to_chat(usr, "That is not a valid name.")
			return

		var/y_gend = input(usr, "Gender?","Gender", "male")
		if(!y_gend || (y_gend != "male" && y_gend != "female"))
			to_chat(usr, "That is not a valid gender.")
			return

		var/mob/living/carbon/human/M = new(usr.loc)
		M.set_species("Yautja")
		spawn(0)
			M.gender = y_gend
			M.regenerate_icons()
			message_staff("[key_name(usr)] made [H] into a Yautja, [M.real_name].")
			if(H.mind)
				H.mind.transfer_to(M)
			else
				M.key = H.key
				if(M.client) M.client.change_view(world_view_size)

			if(M.skills)
				qdel(M.skills)
			M.skills = null //no skill restriction

			if(is_alien_whitelisted(M,"Yautja Elder"))
				M.change_real_name(M, "Elder [y_name]")
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/yautja/full(H), WEAR_JACKET)
				H.equip_to_slot_or_del(new /obj/item/weapon/melee/twohanded/glaive(H), WEAR_L_HAND)
			else
				M.change_real_name(M, y_name)
			M.name = "Unknown"	// Yautja names are not visible for oomans

			if(H)
				qdel(H) //May have to clear up round-end vars and such....

		return

	else if(href_list["makerobot"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["makerobot"])
		if(!istype(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human")
			return

		usr.client.cmd_admin_robotize(H)

	else if(href_list["makeanimal"])
		if(!check_rights(R_SPAWN))	return

		var/mob/M = locate(href_list["makeanimal"])
		if(istype(M, /mob/new_player))
			to_chat(usr, "This cannot be used on instances of type /mob/new_player")
			return

		usr.client.cmd_admin_animalize(M)



// Now isn't that much better? IT IS NOW A PROC, i.e. kinda like a big panel like unstable
	else if(href_list["playerpanelextended"])
		player_panel_extended()

	else if(href_list["adminplayerobservejump"])
		if(!check_rights(R_MOD|R_ADMIN))
			return

		var/mob/M = locate(href_list["adminplayerobservejump"])

		var/client/C = usr.client
		if(!isobserver(usr))
			C.admin_ghost()
		sleep(2)
		C.jumptomob(M)

	else if(href_list["adminplayerfollow"])
		if(!check_rights(R_MOD|R_ADMIN))
			return

		var/mob/M = locate(href_list["adminplayerfollow"])

		var/client/C = usr.client
		if(!isobserver(usr))
			C.admin_ghost()
		sleep(2)
		if(isobserver(usr))
			var/mob/dead/observer/G = usr
			G.ManualFollow(M)

	else if(href_list["check_antagonist"])
		check_antagonists()

	else if(href_list["adminplayerobservecoodjump"])
		if(!check_rights(R_MOD))
			return

		var/x = text2num(href_list["X"])
		var/y = text2num(href_list["Y"])
		var/z = text2num(href_list["Z"])

		var/client/C = usr.client
		if(!isobserver(usr))
			C.admin_ghost()
		sleep(2)
		C.jumptocoord(x,y,z)

	else if(href_list["admincancelob"])
		if(!check_rights(R_MOD))	return
		var/cancel_token = href_list["cancellation"]
		if(!cancel_token)
			return
		if(alert("Are you sure you want to cancel this OB?",,"Yes","No") != "Yes")
			return
		orbital_cannon_cancellation["[cancel_token]"] = null
		message_staff("[src.owner] has cancelled the orbital strike.")

	else if(href_list["admincancelpredsd"])
		if (!check_rights(R_MOD))	return
		var/obj/item/clothing/gloves/yautja/bracer = locate(href_list["bracer"])
		var/mob/living/carbon/victim = locate(href_list["victim"])
		if (!istype(bracer))
			return
		if (alert("Are you sure you want to cancel this pred SD?",,"Yes","No") != "Yes")
			return
		bracer.exploding = FALSE
		message_staff("[src.owner] has cancelled the predator self-destruct sequence [victim ? "of [victim] ([victim.key])":""].")

	else if(href_list["adminspawncookie"])
		if(!check_rights(R_ADMIN|R_FUN))
			return

		var/mob/living/carbon/human/H = locate(href_list["adminspawncookie"])
		if(!ishuman(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human")
			return

		H.equip_to_slot_or_del( new /obj/item/reagent_container/food/snacks/cookie(H), WEAR_L_HAND )
		if(!(istype(H.l_hand,/obj/item/reagent_container/food/snacks/cookie)))
			H.equip_to_slot_or_del( new /obj/item/reagent_container/food/snacks/cookie(H), WEAR_R_HAND )
			if(!(istype(H.r_hand,/obj/item/reagent_container/food/snacks/cookie)))
				message_staff("[key_name(H)] has their hands full, so they did not receive their cookie, spawned by [key_name(src.owner)].")
				return
			else
				H.update_inv_r_hand()//To ensure the icon appears in the HUD
		else
			H.update_inv_l_hand()
		message_staff("[key_name(H)] got their cookie, spawned by [key_name(src.owner)]")
		to_chat(H, SPAN_NOTICE(" Your prayers have been answered!! You received the <b>best cookie</b>!"))

	else if(href_list["CentcommReply"])
		var/mob/living/carbon/human/H = locate(href_list["CentcommReply"])

		if(!istype(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human")
			return

		//unanswered_distress -= H

		if(!istype(H.wear_ear, /obj/item/device/radio/headset))
			to_chat(usr, "The person you are trying to contact is not wearing a headset")
			return

		var/input = input(src.owner, "Please enter a message to reply to [key_name(H)] via their headset.","Outgoing message from USCM", "")
		if(!input)
			return

		to_chat(src.owner, "You sent [input] to [H] via a secure channel.")
		log_admin("[src.owner] replied to [key_name(H)]'s USCM message with the message [input].")
		for(var/client/X in GLOB.admins)
			if((R_ADMIN|R_MOD) & X.admin_holder.rights)
				to_chat(X, "<b>ADMINS/MODS: \red [src.owner] replied to [key_name(H)]'s USCM message with: \blue \")[input]\"</b>")
		to_chat(H, SPAN_DANGER("You hear something crackle in your headset before a voice speaks, please stand by for a message from USCM:\" \blue <b>\"[input]\"</b>"))

	else if(href_list["SyndicateReply"])
		var/mob/living/carbon/human/H = locate(href_list["SyndicateReply"])
		if(!istype(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human")
			return
		if(!istype(H.wear_ear, /obj/item/device/radio/headset))
			to_chat(usr, "The person you are trying to contact is not wearing a headset")
			return

		var/input = input(src.owner, "Please enter a message to reply to [key_name(H)] via their headset.","Outgoing message from The Syndicate", "")
		if(!input)
			return

		to_chat(src.owner, "You sent [input] to [H] via a secure channel.")
		log_admin("[src.owner] replied to [key_name(H)]'s Syndicate message with the message [input].")
		to_chat(H, "You hear something crackle in your headset for a moment before a voice speaks.  \"Please stand by for a message from your benefactor.  Message as follows, agent. <b>\"[input]\"</b>  Message ends.\"")

	else if(href_list["USCMFaxReply"])
		var/mob/living/carbon/human/H = locate(href_list["USCMFaxReply"])
		var/obj/structure/machinery/faxmachine/fax = locate(href_list["originfax"])

		var/template_choice = input("Use which template or roll your own?") in list("USCM High Command", "USCM Provost General", "Custom")
		var/fax_message = ""
		switch(template_choice)
			if("Custom")
				var/input = input(src.owner, "Please enter a message to reply to [key_name(H)] via secure connection. NOTE: BBCode does not work, but HTML tags do! Use <br> for line breaks.", "Outgoing message from USCM", "") as message|null
				if(!input)
					return
				fax_message = "[input]"
			if("USCM High Command", "USCM Provost General")
				var/subject = input(src.owner, "Enter subject line", "Outgoing message from USCM", "") as message|null
				if(!subject)
					return
				var/addressed_to = ""
				var/address_option = input("Address it to the sender or custom?") in list("Sender", "Custom")
				if(address_option == "Sender")
					addressed_to = "[H.real_name]"
				else if(address_option == "Custom")
					addressed_to = input(src.owner, "Enter Addressee Line", "Outgoing message from USCM", "") as message|null
					if(!addressed_to)
						return
				else
					return
				var/message_body = input(src.owner, "Enter Message Body, use <p></p> for paragraphs", "Outgoing message from Weston USCM", "") as message|null
				if(!message_body)
					return
				var/sent_by = input(src.owner, "Enter the name and rank you are sending from.", "Outgoing message from USCM", "") as message|null
				if(!sent_by)
					return
				var/sent_title = "Office of the Provost General"
				if(template_choice == "USCM High Command")
					sent_title = "USCM High Command"

				fax_message = generate_templated_fax(0, "USCM CENTRAL COMMAND", subject,addressed_to, message_body,sent_by, sent_title, "United States Colonial Marine Corps")
		show_browser(usr, "<body class='paper'>[fax_message]</body>", "uscmfaxpreview", "size=500x400")
		var/send_choice = input("Send this fax?") in list("Send", "Cancel")
		if(send_choice == "Cancel")
			return
		fax_contents += fax_message // save a copy

		USCMFaxes.Add("<a href='?FaxView=\ref[fax_message]'>\[view reply at [world.timeofday]\]</a>")

		var/customname = input(src.owner, "Pick a title for the report", "Title") as text|null

		var/msg_ghost = SPAN_NOTICE("<b><font color='#1F66A0'>USCM FAX REPLY: </font></b> ")
		msg_ghost += "Transmitting '[customname]' via secure connection ... "
		msg_ghost += "<a href='?FaxView=\ref[fax_message]'>view message</a>"
		announce_fax( ,msg_ghost)

		for(var/obj/structure/machinery/faxmachine/F in machines)
			if(F == fax)
				if(!(F.inoperable()))

					// animate! it's alive!
					flick("faxreceive", F)

					// give the sprite some time to flick
					spawn(20)
						var/obj/item/paper/P = new /obj/item/paper( F.loc )
						P.name = "USCM High Command - [customname]"
						P.info = fax_message
						P.update_icon()

						playsound(F.loc, "sound/machines/fax.ogg", 15)

						// Stamps
						var/image/stampoverlay = image('icons/obj/items/paper.dmi')
						stampoverlay.icon_state = "paper_stamp-uscm"
						if(!P.stamped)
							P.stamped = new
						P.stamped += /obj/item/tool/stamp
						P.overlays += stampoverlay
						P.stamps += "<HR><i>This paper has been stamped by the High Command Quantum Relay.</i>"

				to_chat(src.owner, "Message reply to transmitted successfully.")
				message_staff("[key_name_admin(src.owner)] replied to a fax message from [key_name_admin(H)]", 1)
				return
		to_chat(src.owner, "/red Unable to locate fax!")

	else if(href_list["CLFaxReply"])
		var/mob/living/carbon/human/H = locate(href_list["CLFaxReply"])
		var/obj/structure/machinery/faxmachine/fax = locate(href_list["originfax"])

		var/template_choice = input("Use the template or roll your own?") in list("Template", "Custom")
		var/fax_message = ""
		switch(template_choice)
			if("Custom")
				var/input = input(src.owner, "Please enter a message to reply to [key_name(H)] via secure connection. NOTE: BBCode does not work, but HTML tags do! Use <br> for line breaks.", "Outgoing message from Weston-Yamada", "") as message|null
				if(!input)
					return
				fax_message = "[input]"
			if("Template")
				var/subject = input(src.owner, "Enter subject line", "Outgoing message from Weston-Yamada", "") as message|null
				if(!subject)
					return
				var/addressed_to = ""
				var/address_option = input("Address it to the sender or custom?") in list("Sender", "Custom")
				if(address_option == "Sender")
					addressed_to = "[H.real_name]"
				else if(address_option == "Custom")
					addressed_to = input(src.owner, "Enter Addressee Line", "Outgoing message from Weston-Yamada", "") as message|null
					if(!addressed_to)
						return
				else
					return
				var/message_body = input(src.owner, "Enter Message Body, use <p></p> for paragraphs", "Outgoing message from Weston-Yamada", "") as message|null
				if(!message_body)
					return
				var/sent_by = input(src.owner, "Enter JUST the name you are sending this from", "Outgoing message from Weston-Yamada", "") as message|null
				if(!sent_by)
					return
				fax_message = generate_templated_fax(1, "WESTON-YAMADA CORPORATE AFFAIRS - USS ALMAYER", subject, addressed_to, message_body, sent_by, "Corporate Affairs Director", "Weston-Yamada")
		show_browser(usr, "<body class='paper'>[fax_message]</body>", "clfaxpreview", "size=500x400")
		var/send_choice = input("Send this fax?") in list("Send", "Cancel")
		if(send_choice == "Cancel")
			return
		fax_contents += fax_message // save a copy

		CLFaxes.Add("<a href='?FaxView=\ref[fax_message]'>\[view reply at [world.timeofday]\]</a>") //Add replies so that mods know what the hell is goin on with the RP

		var/customname = input(src.owner, "Pick a title for the report", "Title") as text|null
		if(!customname)
			return

		var/msg_ghost = SPAN_NOTICE("<b><font color='#1F66A0'>WESTON-YAMADA FAX REPLY: </font></b> ")
		msg_ghost += "Transmitting '[customname]' via secure connection ... "
		msg_ghost += "<a href='?FaxView=\ref[fax_message]'>view message</a>"
		announce_fax( ,msg_ghost)


		for(var/obj/structure/machinery/faxmachine/F in machines)
			if(F == fax)
				if(!(F.inoperable()))

					// animate! it's alive!
					flick("faxreceive", F)

					// give the sprite some time to flick
					spawn(20)
						var/obj/item/paper/P = new /obj/item/paper( F.loc )
						P.name = "Weston-Yamada - [customname]"
						P.info = fax_message
						P.update_icon()

						playsound(F.loc, "sound/machines/fax.ogg", 15)

						// Stamps
						var/image/stampoverlay = image('icons/obj/items/paper.dmi')
						stampoverlay.icon_state = "paper_stamp-cent"
						if(!P.stamped)
							P.stamped = new
						P.stamped += /obj/item/tool/stamp
						P.overlays += stampoverlay
						P.stamps += "<HR><i>This paper has been stamped and encrypted by the Weston-Yamada Quantum Relay (tm).</i>"

				to_chat(src.owner, "Message reply to transmitted successfully.")
				message_staff("[key_name_admin(src.owner)] replied to a fax message from [key_name_admin(H)]", 1)
				return
		to_chat(src.owner, "/red Unable to locate fax!")



	else if(href_list["jumpto"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["jumpto"])
		usr.client.jumptomob(M)

	else if(href_list["getmob"])
		if(!check_rights(R_ADMIN))
			return

		if(alert(usr, "Confirm?", "Message", "Yes", "No") != "Yes")
			return
		var/mob/M = locate(href_list["getmob"])
		usr.client.Getmob(M)

	else if(href_list["sendmob"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["sendmob"])
		usr.client.sendmob(M)

	else if(href_list["narrateto"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["narrateto"])
		usr.client.cmd_admin_direct_narrate(M)

	else if(href_list["subtlemessage"])
		if(!check_rights(R_MOD,0) && !check_rights(R_ADMIN))
			return

		var/mob/M = locate(href_list["subtlemessage"])
		usr.client.cmd_admin_subtle_message(M)

	else if(href_list["create_object"])
		if(!check_rights(R_SPAWN))
			return
		return create_object(usr)

	else if(href_list["quick_create_object"])
		if(!check_rights(R_SPAWN))
			return
		return quick_create_object(usr)

	else if(href_list["create_turf"])
		if(!check_rights(R_SPAWN))
			return
		return create_turf(usr)

	else if(href_list["create_mob"])
		if(!check_rights(R_SPAWN))
			return
		return create_mob(usr)

	else if(href_list["object_list"])			//this is the laggiest thing ever
		if(!check_rights(R_SPAWN))
			return

		var/atom/loc = usr.loc

		var/dirty_paths
		if (istext(href_list["object_list"]))
			dirty_paths = list(href_list["object_list"])
		else if (istype(href_list["object_list"], /list))
			dirty_paths = href_list["object_list"]

		var/paths = list()
		var/removed_paths = list()

		for(var/dirty_path in dirty_paths)
			var/path = text2path(dirty_path)
			if(!path)
				removed_paths += dirty_path
				continue
			else if(!ispath(path, /obj) && !ispath(path, /turf) && !ispath(path, /mob))
				removed_paths += dirty_path
				continue
			paths += path

		if(!paths)
			alert("The path list you sent is empty")
			return
		if(length(paths) > 5)
			alert("Select fewer object types, (max 5)")
			return
		else if(length(removed_paths))
			alert("Removed:\n" + jointext(removed_paths, "\n"))

		var/list/offset = splittext(href_list["offset"],",")
		var/number = dd_range(1, 100, text2num(href_list["object_count"]))
		var/X = offset.len > 0 ? text2num(offset[1]) : 0
		var/Y = offset.len > 1 ? text2num(offset[2]) : 0
		var/Z = offset.len > 2 ? text2num(offset[3]) : 0
		var/tmp_dir = href_list["object_dir"]
		var/obj_dir = tmp_dir ? text2num(tmp_dir) : 2
		if(!obj_dir || !(obj_dir in list(1,2,4,8,5,6,9,10)))
			obj_dir = 2
		var/obj_name = sanitize(href_list["object_name"])
		var/where = href_list["object_where"]
		if (!(where in list("onfloor","inhand","inmarked")))
			where = "onfloor"

		if( where == "inhand" )
			to_chat(usr, "Support for inhand not available yet. Will spawn on floor.")
			where = "onfloor"

		if (where == "inhand")	//Can only give when human or monkey
			if (!(ishuman(usr)))
				to_chat(usr, "Can only spawn in hand when you're a human or a monkey.")
				where = "onfloor"
			else if (usr.get_active_hand())
				to_chat(usr, "Your active hand is full. Spawning on floor.")
				where = "onfloor"

		if (where == "inmarked" )
			if (!marked_datums.len)
				to_chat(usr, "You don't have any datum marked. Abandoning spawn.")
				return
			else
				var/datum/D = input_marked_datum(marked_datums)
				if(!D)
					return

				if (!istype(D,/atom))
					to_chat(usr, "The datum you have marked cannot be used as a target. Target must be of type /atom. Abandoning spawn.")
					return

		var/atom/target //Where the object will be spawned
		switch (where)
			if ("onfloor")
				switch (href_list["offset_type"])
					if ("absolute")
						target = locate(0 + X,0 + Y,0 + Z)
					if ("relative")
						target = locate(loc.x + X,loc.y + Y,loc.z + Z)
			if ("inmarked")
				var/datum/D = input_marked_datum(marked_datums)
				if(!D)
					to_chat(usr, "Invalid marked datum. Abandoning.")
					return

				target = D

		if(target)
			for (var/path in paths)
				for (var/i = 0; i < number; i++)
					if(path in typesof(/turf))
						var/turf/O = target
						var/turf/N = O.ChangeTurf(path)
						if(N)
							if(obj_name)
								N.name = obj_name
					else
						var/atom/O = new path(target)
						if(O)
							O.setDir(obj_dir)
							if(obj_name)
								O.name = obj_name
								if(istype(O,/mob))
									var/mob/M = O
									M.change_real_name(M, obj_name)

		if (number == 1)
			log_admin("[key_name(usr)] created a [english_list(paths)]")
			for(var/path in paths)
				if(ispath(path, /mob))
					message_staff("[key_name_admin(usr)] created a [english_list(paths)]", 1)
					break
		else
			log_admin("[key_name(usr)] created [number]ea [english_list(paths)]")
			for(var/path in paths)
				if(ispath(path, /mob))
					message_staff("[key_name_admin(usr)] created [number]ea [english_list(paths)]", 1)
					break
		return

	else if(href_list["create_humans_list"])
		if(!check_rights(R_SPAWN))
			return

		create_humans_list(href_list)

	else if(href_list["events"])
		if(!check_rights(R_FUN))
			return

		topic_events(href_list["events"])

	else if(href_list["debug"])
		if(!check_rights(R_DEBUG))
			return
		topic_debug(href_list["debug"])

	else if(href_list["teleport"])
		if(!check_rights(R_MOD))
			return

		topic_teleports(href_list["teleport"])

	else if(href_list["inviews"])
		if(!check_rights(R_MOD))
			return

		topic_inviews(href_list["inviews"])

	else if(href_list["vehicle"])
		if(!check_rights(R_MOD))
			return

		topic_vehicles(href_list["vehicle"])

	else if(href_list["ahelp"])

		topic_ahelps(href_list)

	else if(href_list["agent"] == "showobjectives")
		if(!check_rights(R_MOD))
			return

		var/mob/M = locate(href_list["extra"])
		show_agent_objectives(M)

	// player info stuff

	if(href_list["add_player_info"])
		var/key = href_list["add_player_info"]
		var/add = input("Add Player Info") as null|message
		if(!add)
			return

		var/datum/entity/player/P = get_player_from_key(key)
		P.add_note(add, FALSE)
		player_notes_show(key)

	if(href_list["add_player_info_confidential"])
		var/key = href_list["add_player_info_confidential"]
		var/add = input("Add Confidential Player Info") as null|message
		if(!add)
			return

		var/datum/entity/player/P = get_player_from_key(key)
		P.add_note(add, TRUE)
		player_notes_show(key)

	if(href_list["remove_player_info"])
		var/key = href_list["remove_player_info"]
		var/index = text2num(href_list["remove_index"])

		var/datum/entity/player/P = get_player_from_key(key)
		P.remove_note(index)
		player_notes_show(key)

	if(href_list["notes"])
		var/ckey = href_list["ckey"]
		if(!ckey)
			var/mob/M = locate(href_list["mob"])
			if(ismob(M))
				ckey = M.ckey

		switch(href_list["notes"])
			if("show")
				player_notes_show(ckey)
		return

	if(href_list["player_notes_copy"])
		var/key = href_list["player_notes_copy"]
		player_notes_copy(key)
		return

	if(href_list["ccmark"]) // CentComm-mark. We want to let all Admins know that something is "Marked", but not let the player know because it's not very RP-friendly.
		var/mob/ref_person = locate(href_list["ccmark"])
		var/msg = SPAN_NOTICE("<b>NOTICE: <font color=red>[usr.key]</font> is responding to <font color=red>[key_name(ref_person)]</font>.</b>")

		//send this msg to all admins
		for(var/client/X in GLOB.admins)
			if((R_ADMIN|R_MOD) & X.admin_holder.rights)
				to_chat(X, msg)

		//unanswered_distress -= ref_person

	if(href_list["ccdeny"]) // CentComm-deny. The distress call is denied, without any further conditions
		var/mob/ref_person = locate(href_list["ccdeny"])
		marine_announcement("The distress signal has not received a response, the launch tubes are now recalibrating.", "Distress Beacon")
		log_game("[key_name_admin(usr)] has denied a distress beacon, requested by [key_name_admin(ref_person)]")
		message_staff("[key_name_admin(usr)] has denied a distress beacon, requested by [key_name_admin(ref_person)]", 1)

		//unanswered_distress -= ref_person

	if(href_list["distresscancel"])
		if(distress_cancel)
			to_chat(usr, "The distress beacon was either canceled, or you are too late to cancel.")
			return
		log_game("[key_name_admin(usr)] has canceled the distress beacon.")
		message_staff("[key_name_admin(usr)] has canceled the distress beacon.")
		distress_cancel = TRUE
		return

	if(href_list["distress"]) //Distress Beacon, sends a random distress beacon when pressed
		distress_cancel = FALSE
		message_staff("[key_name_admin(usr)] has opted to SEND the distress beacon! Launching in 10 seconds... (<A HREF='?_src_=admin_holder;distresscancel=\ref[usr]'>CANCEL</A>)")
		addtimer(CALLBACK(src, .proc/accept_ert, locate(href_list["distress"])), SECONDS_10)
		//unanswered_distress -= ref_person

	if(href_list["destroyship"]) //Distress Beacon, sends a random distress beacon when pressed
		destroy_cancel = FALSE
		message_staff("[key_name_admin(usr)] has opted to GRANT the self destruct! Starting in 10 seconds... (<A HREF='?_src_=admin_holder;sdcancel=\ref[usr]'>CANCEL</A>)")
		spawn(100)
			if(distress_cancel)
				return
			var/mob/ref_person = locate(href_list["destroy"])
			set_security_level(SEC_LEVEL_DELTA)
			log_game("[key_name_admin(usr)] has granted self destruct, requested by [key_name_admin(ref_person)]")
			message_staff("[key_name_admin(usr)] has granted self destruct, requested by [key_name_admin(ref_person)]", 1)

	if(href_list["sddeny"]) // CentComm-deny. The self destruct is denied, without any further conditions
		var/mob/ref_person = locate(href_list["sddeny"])
		marine_announcement("The self destruct request has not received a response, ARES is now recalculating statistics.", "Self Destruct System")
		log_game("[key_name_admin(usr)] has denied self destruct, requested by [key_name_admin(ref_person)]")
		message_staff("[key_name_admin(usr)] has denied self destruct, requested by [key_name_admin(ref_person)]", 1)

	if(href_list["sdcancel"])
		if(destroy_cancel)
			to_chat(usr, "The self destruct was already canceled.")
			return
		if(get_security_level() == "delta")
			to_chat(usr, "Too late! The self destruct was started.")
			return
		log_game("[key_name_admin(usr)] has canceled the self destruct.")
		message_staff("[key_name_admin(usr)] has canceled the self destruct.")
		destroy_cancel = 1
		return

	return

/datum/admins/proc/accept_ert(var/mob/ref_person)
	if(distress_cancel)
		return
	distress_cancel = TRUE
	SSticker.mode.activate_distress()
	log_game("[key_name_admin(usr)] has sent a randomized distress beacon, requested by [key_name_admin(ref_person)]")
	message_staff("[key_name_admin(usr)] has sent a randomized distress beacon, requested by [key_name_admin(ref_person)]")

/datum/admins/proc/generate_job_ban_list(var/mob/M, var/datum/entity/player/P, var/list/roles, var/department, var/color = "ccccff")
	var/counter = 0

	var/dat = ""
	dat += "<table cellpadding='1' cellspacing='0' width='100%'>"
	dat += "<tr align='center' bgcolor='[color]'><th colspan='[length(roles)]'><a href='?src=\ref[src];jobban3=[department]dept;jobban4=\ref[M]'>[department]</a></th></tr><tr align='center'>"
	for(var/jobPos in roles)
		if(!jobPos)
			continue
		var/datum/job/job = RoleAuthority.roles_by_name[jobPos]
		if(!job)
			continue

		if(jobban_isbanned(M, job.title, P))
			dat += "<td width='20%'><a href='?src=\ref[src];jobban3=[job.title];jobban4=\ref[M]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
			counter++
		else
			dat += "<td width='20%'><a href='?src=\ref[src];jobban3=[job.title];jobban4=\ref[M]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
			counter++

		if(counter >= 5) //So things dont get squiiiiished!
			dat += "</tr><tr>"
			counter = 0
	dat += "</tr></table>"
	return dat

/datum/admins/proc/get_job_titles_from_list(var/list/roles)
	var/list/temp = list()
	for(var/jobPos in roles)
		if(!jobPos)
			continue
		var/datum/job/J = RoleAuthority.roles_by_name[jobPos]
		if(!J)
			continue
		temp += J.title
	return temp
