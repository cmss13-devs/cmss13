/datum/admins/Topic(href, href_list)
	..()

	if(usr.client != src.owner || !check_rights(0))
		log_admin("[key_name(usr)] tried to use the admin panel without authorization.")
		message_admins("[usr.key] has attempted to override the admin panel!")
		return

	if(ticker.mode && ticker.mode.check_antagonists_topic(href, href_list))
		check_antagonists()
		return

	if(href_list["dbsearchckey"] || href_list["dbsearchadmin"])
		var/adminckey = href_list["dbsearchadmin"]
		var/playerckey = href_list["dbsearchckey"]

		DB_ban_panel(playerckey, adminckey)
		return

	else if(href_list["dbbanedit"])
		var/banedit = href_list["dbbanedit"]
		var/banid = text2num(href_list["dbbanid"])
		if(!banedit || !banid)
			return

		DB_ban_edit(banid, banedit)
		return

	else if(href_list["dbbanaddtype"])

		var/bantype = text2num(href_list["dbbanaddtype"])
		var/banckey = href_list["dbbanaddckey"]
		var/banduration = text2num(href_list["dbbaddduration"])
		var/banjob = href_list["dbbanaddjob"]
		var/banreason = href_list["dbbanreason"]

		banckey = ckey(banckey)

		switch(bantype)
			if(BANTYPE_PERMA)
				if(!banckey || !banreason)
					to_chat(usr, "Not enough parameters (Requires ckey and reason)")
					return
				banduration = null
				banjob = null
			if(BANTYPE_TEMP)
				if(!banckey || !banreason || !banduration)
					to_chat(usr, "Not enough parameters (Requires ckey, reason and duration)")
					return
				banjob = null
			if(BANTYPE_JOB_PERMA)
				if(!banckey || !banreason || !banjob)
					to_chat(usr, "Not enough parameters (Requires ckey, reason and job)")
					return
				banduration = null
			if(BANTYPE_JOB_TEMP)
				if(!banckey || !banreason || !banjob || !banduration)
					to_chat(usr, "Not enough parameters (Requires ckey, reason and job)")
					return

		var/mob/playermob

		for(var/mob/M in player_list)
			if(M.ckey == banckey)
				playermob = M
				break

		banreason = "(MANUAL BAN) "+banreason

		DB_ban_record(bantype, playermob, banduration, banreason, banjob, null, banckey)

	else if(href_list["editrights"])
		if(!check_rights(R_PERMISSIONS))
			message_admins("[key_name_admin(usr)] attempted to edit the admin permissions without sufficient rights.")
			log_admin("[key_name(usr)] attempted to edit the admin permissions without sufficient rights.")
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
				log_admin("[key_name(usr)] removed [adm_ckey] from the admins list")
				log_admin_rank_modification(adm_ckey, "Removed")

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
					if(config.admin_legacy_system)
						new_rank = ckeyEx(new_rank)
					if(!new_rank)
						to_chat(usr, "<font color='red'>Error: Topic 'editrights': Invalid rank</font>")
						return
					if(config.admin_legacy_system)
						if(admin_ranks.len)
							if(new_rank in admin_ranks)
								rights = admin_ranks[new_rank]		//we typed a rank which already exists, use its rights
							else
								admin_ranks[new_rank] = 0			//add the new rank to admin_ranks
				else
					if(config.admin_legacy_system)
						new_rank = ckeyEx(new_rank)
						rights = admin_ranks[new_rank]				//we input an existing rank, use its rights

			if(D)
				D.disassociate()								//remove adminverbs and unlink from client
				D.rank = new_rank								//update the rank
				D.rights = rights								//update the rights based on admin_ranks (default: 0)
			else
				D = new /datum/admins(new_rank, rights, adm_ckey)

			var/client/C = directory[adm_ckey]						//find the client with the specified ckey (if they are logged in)
			D.associate(C)											//link up with the client and add verbs

			message_admins("[key_name_admin(usr)] edited the admin rank of [adm_ckey] to [new_rank]")
			log_admin("[key_name(usr)] edited the admin rank of [adm_ckey] to [new_rank]")
			log_admin_rank_modification(adm_ckey, new_rank)

		else if(task == "permissions")
			if(!D)	return
			var/list/permissionlist = list()
			for(var/i=1, i<=R_HOST, i<<=1)		//that <<= is shorthand for i = i << 1. Which is a left bitshift
				permissionlist[rights2text(i)] = i
			var/new_permission = input("Select a permission to turn on/off", "Permission toggle", null, null) as null|anything in permissionlist
			if(!new_permission)	return
			D.rights ^= permissionlist[new_permission]

			message_admins("[key_name_admin(usr)] toggled the [new_permission] permission of [adm_ckey]")
			log_admin("[key_name(usr)] toggled the [new_permission] permission of [adm_ckey]")
			log_admin_permission_modification(adm_ckey, permissionlist[new_permission])

		edit_admin_permissions()

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
					log_admin("[key_name(usr)] called an evacuation.")
					message_admins(SPAN_NOTICE("[key_name_admin(usr)] called an evacuation."), 1)

			if("cancel_evac")
				if(!EvacuationAuthority.cancel_evacuation())
					to_chat(usr, SPAN_WARNING("You are unable to cancel an evacuation right now!"))
				else
					log_admin("[key_name(usr)] canceled an evacuation.")
					message_admins(SPAN_NOTICE("[key_name_admin(usr)] canceled an evacuation."), 1)

			if("toggle_evac")
				EvacuationAuthority.flags_scuttle ^= FLAGS_EVACUATION_DENY
				log_admin("[key_name(src)] has [EvacuationAuthority.flags_scuttle & FLAGS_EVACUATION_DENY ? "forbidden" : "allowed"] ship-wide evacuation.")
				message_admins("[key_name_admin(usr)] has [EvacuationAuthority.flags_scuttle & FLAGS_EVACUATION_DENY ? "forbidden" : "allowed"] ship-wide evacuation.")

			if("force_evac")
				if(!EvacuationAuthority.begin_launch())
					to_chat(usr, SPAN_WARNING("You are unable to launch the pods directly right now!"))
				else
					log_admin("[key_name(usr)] force-launched the escape pods.")
					message_admins(SPAN_NOTICE("[key_name_admin(usr)] force-launched the escape pods."), 1)

			if("init_dest")
				if(!EvacuationAuthority.enable_self_destruct())
					to_chat(usr, SPAN_WARNING("You are unable to authorize the self-destruct right now!"))
				else
					log_admin("[key_name(usr)] force-enabled the self-destruct system.")
					message_admins(SPAN_NOTICE("[key_name_admin(usr)] force-enabled the self-destruct system."), 1)

			if("cancel_dest")
				if(!EvacuationAuthority.cancel_self_destruct(1))
					to_chat(usr, SPAN_WARNING("You are unable to cancel the self-destruct right now!"))
				else
					log_admin("[key_name(usr)] canceled the self-destruct system.")
					message_admins(SPAN_NOTICE("[key_name_admin(usr)] canceled the self-destruct system."), 1)

			if("use_dest")

				var/confirm = alert("Are you sure you want to self-destruct the Almayer?", "Self-Destruct", "Yes", "Cancel")
				if(confirm != "Yes")
					return

				if(!EvacuationAuthority.initiate_self_destruct(1))
					to_chat(usr, SPAN_WARNING("You are unable to trigger the self-destruct right now!"))
					return
				if(alert("Are you sure you want to destroy the Almayer right now?",, "Yes", "Cancel") == "Cancel") return

				log_admin("[key_name(usr)] forced the self-destruct system, destroying the [MAIN_SHIP_NAME].")
				message_admins(SPAN_NOTICE("[key_name_admin(usr)] forced the self-destrust system, destroying the [MAIN_SHIP_NAME]."), 1)

			if("toggle_dest")
				EvacuationAuthority.flags_scuttle ^= FLAGS_SELF_DESTRUCT_DENY
				log_admin("[key_name(src)] has [EvacuationAuthority.flags_scuttle & FLAGS_SELF_DESTRUCT_DENY ? "forbidden" : "allowed"] the self-destruct system.")
				message_admins("[key_name_admin(usr)] has [EvacuationAuthority.flags_scuttle & FLAGS_SELF_DESTRUCT_DENY ? "forbidden" : "allowed"] the self-destruct system.")


		href_list["secretsadmin"] = "check_antagonist"

//======================================================
//======================================================

	else if(href_list["delay_round_end"])
		if(!check_rights(R_SERVER))	return

		ticker.delay_end = !ticker.delay_end
		log_admin("[key_name(usr)] [ticker.delay_end ? "delayed the round end" : "has made the round end normally"].")
		message_admins(SPAN_NOTICE("[key_name(usr)] [ticker.delay_end ? "delayed the round end" : "has made the round end normally"]."), 1)
		href_list["secretsadmin"] = "check_antagonist"

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

		log_admin("[key_name(usr)] has used rudimentary transformation on [key_name(M)]. Transforming to [href_list["simplemake"]]; deletemob=[delmob]")
		message_admins(SPAN_NOTICE("[key_name_admin(usr)] has used rudimentary transformation on [key_name_admin(M)]. Transforming to [href_list["simplemake"]]; deletemob=[delmob]"), 1)

		switch(href_list["simplemake"])
			if("observer")		M.change_mob_type( /mob/dead/observer , null, null, delmob )

			if("larva")				M.change_mob_type( /mob/living/carbon/Xenomorph/Larva , null, null, delmob )
			if("defender")			M.change_mob_type( /mob/living/carbon/Xenomorph/Defender, null, null, delmob )
			if("warrior")			M.change_mob_type( /mob/living/carbon/Xenomorph/Warrior, null, null, delmob )
			if("runner")			M.change_mob_type( /mob/living/carbon/Xenomorph/Runner , null, null, delmob )
			if("drone")				M.change_mob_type( /mob/living/carbon/Xenomorph/Drone , null, null, delmob )
			if("sentinel")			M.change_mob_type( /mob/living/carbon/Xenomorph/Sentinel , null, null, delmob )
			if("lurker")			M.change_mob_type( /mob/living/carbon/Xenomorph/Lurker , null, null, delmob )
			if("carrier")			M.change_mob_type( /mob/living/carbon/Xenomorph/Carrier , null, null, delmob )
			if("hivelord")			M.change_mob_type( /mob/living/carbon/Xenomorph/Hivelord , null, null, delmob )
			if("praetorian")		M.change_mob_type( /mob/living/carbon/Xenomorph/Praetorian , null, null, delmob )
			if("ravager")			M.change_mob_type( /mob/living/carbon/Xenomorph/Ravager , null, null, delmob )
			if("spitter")			M.change_mob_type( /mob/living/carbon/Xenomorph/Spitter , null, null, delmob )
			if("boiler")			M.change_mob_type( /mob/living/carbon/Xenomorph/Boiler , null, null, delmob )
			if("burrower")			M.change_mob_type( /mob/living/carbon/Xenomorph/Burrower , null, null, delmob )
			if("crusher")			M.change_mob_type( /mob/living/carbon/Xenomorph/Crusher , null, null, delmob )
			if("queen")				M.change_mob_type( /mob/living/carbon/Xenomorph/Queen , null, null, delmob )
			if("ravenger")			M.change_mob_type( /mob/living/carbon/Xenomorph/Ravager/ravenger , null, null, delmob )
			if("predalien")			M.change_mob_type( /mob/living/carbon/Xenomorph/Predalien , null, null, delmob )

			if("human")				M.change_mob_type( /mob/living/carbon/human , null, null, delmob, href_list["species"])
			if("monkey")			M.change_mob_type( /mob/living/carbon/human/monkey , null, null, delmob )
			if("farwa")			M.change_mob_type( /mob/living/carbon/human/farwa , null, null, delmob )
			if("neaera")			M.change_mob_type( /mob/living/carbon/human/neaera , null, null, delmob )
			if("yiren")			M.change_mob_type( /mob/living/carbon/human/yiren , null, null, delmob )
			if("robot")				M.change_mob_type( /mob/living/silicon/robot , null, null, delmob )
			if("cat")				M.change_mob_type( /mob/living/simple_animal/cat , null, null, delmob )
			if("runtime")			M.change_mob_type( /mob/living/simple_animal/cat/Runtime , null, null, delmob )
			if("corgi")				M.change_mob_type( /mob/living/simple_animal/corgi , null, null, delmob )
			if("ian")				M.change_mob_type( /mob/living/simple_animal/corgi/Ian , null, null, delmob )
			if("crab")				M.change_mob_type( /mob/living/simple_animal/crab , null, null, delmob )
			if("coffee")			M.change_mob_type( /mob/living/simple_animal/crab/Coffee , null, null, delmob )
			if("parrot")			M.change_mob_type( /mob/living/simple_animal/parrot , null, null, delmob )
			if("polyparrot")		M.change_mob_type( /mob/living/simple_animal/parrot/Poly , null, null, delmob )


	/////////////////////////////////////new ban stuff
	else if(href_list["unbanf"])
		if(!check_rights(R_BAN))	return

		var/banfolder = href_list["unbanf"]
		Banlist.cd = "/base/[banfolder]"
		var/key = Banlist["key"]
		if(alert(usr, "Are you sure you want to unban [key]?", "Confirmation", "Yes", "No") == "Yes")
			if((Banlist["minutes"] - CMinutes) > 10080)
				if(!check_rights(R_ADMIN)) return
				log_admin("[key_name(usr)] removed [key]'s permaban.")
				ban_unban_log_save("[key_name(usr)] removed [key]'s permaban.")
				message_admins(SPAN_NOTICE("[key_name_admin(usr)] removed [key]'s permaban."), 1)
			if(RemoveBan(banfolder))
				unbanpanel()
			else
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

		log_admin("[key_name(usr)] upgraded [banned_key]'s ban to a permaban. Reason: [sanitize(reason)]")
		ban_unban_log_save("[key_name(usr)] upgraded [banned_key]'s ban to a permaban. Reason: [sanitize(reason)]")
		message_admins(SPAN_NOTICE("[key_name_admin(usr)] upgraded [banned_key]'s ban to a permaban. Reason: [sanitize(reason)]"), 1)
		Banlist.cd = "/base/[banfolder]"
		Banlist["reason"] << sanitize(reason)
		Banlist["temp"] << 0
		Banlist["minutes"] << minutes
		Banlist["bannedby"] << usr.ckey
		Banlist.cd = "/base"
		feedback_inc("ban_upgrade",1)
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

		log_admin("[key_name(usr)] edited [banned_key]'s ban. Reason: [sanitize(reason)] Duration: [duration]")
		ban_unban_log_save("[key_name(usr)] edited [banned_key]'s ban. Reason: [sanitize(reason)] Duration: [duration]")
		message_admins(SPAN_NOTICE("[key_name_admin(usr)] edited [banned_key]'s ban. Reason: [sanitize(reason)] Duration: [duration]"), 1)
		Banlist.cd = "/base/[banfolder]"
		Banlist["reason"] << sanitize(reason)
		Banlist["temp"] << temp
		Banlist["minutes"] << minutes
		Banlist["bannedby"] << usr.ckey
		Banlist.cd = "/base"
		feedback_inc("ban_edit",1)
		unbanpanel()

	/////////////////////////////////////new ban stuff

	else if(href_list["jobban2"])
//		if(!check_rights(R_BAN))	return

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

		var/dat = ""
		var/header = "<head><title>Job-Ban Panel: [M.name]</title></head>"
		var/body
		var/jobs = ""

	/***********************************WARNING!************************************
				      The jobban stuff looks mangled and disgusting
						      But it looks beautiful in-game
						                -Nodrak
	************************************WARNING!***********************************/
		var/counter = 0
//Regular jobs
	//Command (Blue)
		jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
		jobs += "<tr align='center' bgcolor='ccccff'><th colspan='[length(ROLES_COMMAND)]'><a href='?src=\ref[src];jobban3=commanddept;jobban4=\ref[M]'>Command Positions</a></th></tr><tr align='center'>"
		for(var/jobPos in ROLES_COMMAND)
			if(!jobPos)	continue
			var/datum/job/job = RoleAuthority.roles_by_name[jobPos]
			if(!job) continue

			if(jobban_isbanned(M, job.title))
				jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=[job.title];jobban4=\ref[M]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
				counter++
			else
				jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=[job.title];jobban4=\ref[M]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
				counter++

			if(counter >= 6) //So things dont get squiiiiished!
				jobs += "</tr><tr>"
				counter = 0
		jobs += "</tr></table>"


	//Engineering (Yellow)
		counter = 0
		jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
		jobs += "<tr bgcolor='fff5cc'><th colspan='[length(ROLES_ENGINEERING)]'><a href='?src=\ref[src];jobban3=engineeringdept;jobban4=\ref[M]'>Engineering Positions</a></th></tr><tr align='center'>"
		for(var/jobPos in ROLES_ENGINEERING)
			if(!jobPos)	continue
			var/datum/job/job = RoleAuthority.roles_by_name[jobPos]
			if(!job) continue

			if(jobban_isbanned(M, job.title))
				jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=[job.title];jobban4=\ref[M]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
				counter++
			else
				jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=[job.title];jobban4=\ref[M]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
				counter++

			if(counter >= 5) //So things dont get squiiiiished!
				jobs += "</tr><tr align='center'>"
				counter = 0
		jobs += "</tr></table>"

	//Cargo (Yellow) //Copy paste, yada, yada. Hopefully Snail can rework this in the future.
		counter = 0
		jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
		jobs += "<tr bgcolor='fff5cc'><th colspan='[length(ROLES_REQUISITION)]'><a href='?src=\ref[src];jobban3=cargodept;jobban4=\ref[M]'>Requisition Positions</a></th></tr><tr align='center'>"
		for(var/jobPos in ROLES_REQUISITION)
			if(!jobPos)	continue
			var/datum/job/job = RoleAuthority.roles_by_name[jobPos]
			if(!job) continue

			if(jobban_isbanned(M, job.title))
				jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=[job.title];jobban4=\ref[M]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
				counter++
			else
				jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=[job.title];jobban4=\ref[M]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
				counter++

			if(counter >= 5) //So things dont get squiiiiished!
				jobs += "</tr><tr align='center'>"
				counter = 0
		jobs += "</tr></table>"

	//Medical (White)
		counter = 0
		jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
		jobs += "<tr bgcolor='ffeef0'><th colspan='[length(ROLES_MEDICAL)]'><a href='?src=\ref[src];jobban3=medicaldept;jobban4=\ref[M]'>Medical Positions</a></th></tr><tr align='center'>"
		for(var/jobPos in ROLES_MEDICAL)
			if(!jobPos)	continue
			var/datum/job/job = RoleAuthority.roles_by_name[jobPos]
			if(!job) continue

			if(jobban_isbanned(M, job.title))
				jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=[job.title];jobban4=\ref[M]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
				counter++
			else
				jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=[job.title];jobban4=\ref[M]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
				counter++

			if(counter >= 5) //So things dont get squiiiiished!
				jobs += "</tr><tr align='center'>"
				counter = 0
		jobs += "</tr></table>"

	//Marines
		counter = 0
		jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
		jobs += "<tr bgcolor='fff5cc'><th colspan='[length(ROLES_MARINES)]'><a href='?src=\ref[src];jobban3=marinedept;jobban4=\ref[M]'>Marine Positions</a></th></tr><tr align='center'>"
		for(var/jobPos in ROLES_MARINES)
			if(!jobPos)	continue
			var/datum/job/job = RoleAuthority.roles_by_name[jobPos]
			if(!job) continue

			if(jobban_isbanned(M, job.title))
				jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=[job.title];jobban4=\ref[M]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
				counter++
			else
				jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=[job.title];jobban4=\ref[M]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
				counter++

			if(counter >= 5) //So things dont get squiiiiished!
				jobs += "</tr><tr align='center'>"
				counter = 0
		jobs += "</tr></table>"

	//Antagonist (Orange)
		var/isbanned_dept = jobban_isbanned(M, "Syndicate")
		jobs += "<table cellpadding='1' cellspacing='0' width='100%'>"
		jobs += "<tr bgcolor='ffeeaa'><th colspan='10'><a href='?src=\ref[src];jobban3=Syndicate;jobban4=\ref[M]'>Antagonist Positions</a></th></tr><tr align='center'>"

		//Traitor
		if(jobban_isbanned(M, "traitor") || isbanned_dept)
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=traitor;jobban4=\ref[M]'><font color=red>[replacetext("Traitor", " ", "&nbsp")]</font></a></td>"
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=traitor;jobban4=\ref[M]'>[replacetext("Traitor", " ", "&nbsp")]</a></td>"

		//Changeling
		if(jobban_isbanned(M, "changeling") || isbanned_dept)
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=changeling;jobban4=\ref[M]'><font color=red>[replacetext("Changeling", " ", "&nbsp")]</font></a></td>"
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=changeling;jobban4=\ref[M]'>[replacetext("Changeling", " ", "&nbsp")]</a></td>"

		//Nuke Operative
		if(jobban_isbanned(M, "operative") || isbanned_dept)
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=operative;jobban4=\ref[M]'><font color=red>[replacetext("Nuke Operative", " ", "&nbsp")]</font></a></td>"
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=operative;jobban4=\ref[M]'>[replacetext("Nuke Operative", " ", "&nbsp")]</a></td>"

		//Revolutionary
		if(jobban_isbanned(M, "revolutionary") || isbanned_dept)
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=revolutionary;jobban4=\ref[M]'><font color=red>[replacetext("Revolutionary", " ", "&nbsp")]</font></a></td>"
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=revolutionary;jobban4=\ref[M]'>[replacetext("Revolutionary", " ", "&nbsp")]</a></td>"

		jobs += "</tr><tr align='center'>" //Breaking it up so it fits nicer on the screen every 5 entries

		//Cultist
		if(jobban_isbanned(M, "cultist") || isbanned_dept)
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=cultist;jobban4=\ref[M]'><font color=red>[replacetext("Cultist", " ", "&nbsp")]</font></a></td>"
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=cultist;jobban4=\ref[M]'>[replacetext("Cultist", " ", "&nbsp")]</a></td>"

		//Wizard
		if(jobban_isbanned(M, "wizard") || isbanned_dept)
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=wizard;jobban4=\ref[M]'><font color=red>[replacetext("Wizard", " ", "&nbsp")]</font></a></td>"
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=wizard;jobban4=\ref[M]'>[replacetext("Wizard", " ", "&nbsp")]</a></td>"

		//ERT
		if(jobban_isbanned(M, "Emergency Response Team") || isbanned_dept)
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=Emergency Response Team;jobban4=\ref[M]'><font color=red>Emergency Response Team</font></a></td>"
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=Emergency Response Team;jobban4=\ref[M]'>Emergency Response Team</a></td>"

		//Xenos
		if(jobban_isbanned(M, "Alien") || isbanned_dept)
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=Alien;jobban4=\ref[M]'><font color=red>Alien</font></a></td>"
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=Alien;jobban4=\ref[M]'>Alien</a></td>"

		//Queen
		if(jobban_isbanned(M, "Queen") || isbanned_dept)
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=Queen;jobban4=\ref[M]'><font color=red>Queen</font></a></td>"
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=Queen;jobban4=\ref[M]'>Queen</a></td>"


		//Survivor
		if(jobban_isbanned(M, "Survivor") || isbanned_dept)
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=Survivor;jobban4=\ref[M]'><font color=red>Survivor</font></a></td>"
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=Survivor;jobban4=\ref[M]'>Survivor</a></td>"

		//Whiskey Outpost Role
		if(jobban_isbanned(M, "WO Role") || isbanned_dept)
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=WO Role;jobban4=\ref[M]'><font color=red>WO Role</font></a></td>"
		else
			jobs += "<td width='20%'><a href='?src=\ref[src];jobban3=WO Role;jobban4=\ref[M]'>WO Role</a></td>"


		jobs += "</tr></table>"

		body = "<body>[jobs]</body>"
		dat = "<tt>[header][body]</tt>"
		usr << browse(dat, "window=jobban2;size=800x490")
		return
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

		//get jobs for department if specified, otherwise just returnt he one job in a list.
		var/list/joblist = list()
		switch(href_list["jobban3"])
			if("commanddept")
				for(var/jobPos in ROLES_COMMAND)
					if(!jobPos)	continue
					var/datum/job/temp = RoleAuthority.roles_by_name[jobPos]
					if(!temp) continue
					joblist += temp.title
			if("engineeringdept")
				for(var/jobPos in ROLES_ENGINEERING)
					if(!jobPos)	continue
					var/datum/job/temp = RoleAuthority.roles_by_name[jobPos]
					if(!temp) continue
					joblist += temp.title
			if("cargodept")
				for(var/jobPos in ROLES_REQUISITION)
					if(!jobPos)	continue
					var/datum/job/temp = RoleAuthority.roles_by_name[jobPos]
					if(!temp) continue
					joblist += temp.title
			if("medicaldept")
				for(var/jobPos in ROLES_MEDICAL)
					if(!jobPos)	continue
					var/datum/job/temp = RoleAuthority.roles_by_name[jobPos]
					if(!temp) continue
					joblist += temp.title
			if("marinedept")
				for(var/jobPos in ROLES_MARINES)
					if(!jobPos)	continue
					var/datum/job/temp = RoleAuthority.roles_by_name[jobPos]
					if(!temp) continue
					joblist += temp.title
			else
				joblist += href_list["jobban3"]

		//Create a list of unbanned jobs within joblist
		var/list/notbannedlist = list()
		for(var/job in joblist)
			if(!jobban_isbanned(M, job))
				notbannedlist += job

		//Banning comes first
		if(notbannedlist.len) //at least 1 unbanned job exists in joblist so we have stuff to ban.
			// switch(alert("Temporary Ban?",,"Yes","No", "Cancel"))
			// 	if("Yes")
			// 		if(!check_rights(R_MOD,0) && !check_rights(R_BAN))  return
			// 		if(config.ban_legacy_system)
			// 			to_chat(usr, SPAN_DANGER("Your server is using the legacy banning system, which does not support temporary job bans. Consider upgrading. Aborting ban."))
			// 			return
			// 		var/mins = input(usr,"How long (in minutes)?","Ban time",1440) as num|null
			// 		if(!mins)
			// 			return
			// 		var/reason = input(usr,"Reason?","Please State Reason","") as text|null
			// 		if(!reason)
			// 			return

			// 		var/msg
			// 		for(var/job in notbannedlist)
			// 			ban_unban_log_save("[key_name(usr)] temp-jobbanned [key_name(M)] from [job] for [mins] minutes. reason: [reason]")
			// 			log_admin("[key_name(usr)] temp-jobbanned [key_name(M)] from [job] for [mins] minutes")
			// 			feedback_inc("ban_job_tmp",1)
			// 			DB_ban_record(BANTYPE_JOB_TEMP, M, mins, reason, job)
			// 			feedback_add_details("ban_job_tmp","- [job]")
			// 			jobban_fullban(M, job, "[reason]; By [usr.ckey] on [time2text(world.realtime)]") //Legacy banning does not support temporary jobbans.
			// 			if(!msg)
			// 				msg = job
			// 			else
			// 				msg += ", [job]"
			// 		notes_add(M.ckey, "Banned  from [msg] - [reason]")
			// 		message_admins(SPAN_NOTICE("[key_name_admin(usr)] banned [key_name_admin(M)] from [msg] for [mins] minutes"), 1)
			// 		to_chat(M, SPAN_WARNING("<BIG><B>You have been jobbanned by [usr.client.ckey] from: [msg].</B></BIG>"))
			// 		to_chat(M, SPAN_WARNING("<B>The reason is: [reason]</B>"))
			// 		to_chat(M, SPAN_WARNING("This jobban will be lifted in [mins] minutes."))
			// 		jobban_savebanfile()
			// 		href_list["jobban2"] = 1 // lets it fall through and refresh
			// 		return 1
			// 	if("No")
			if(!check_rights(R_BAN))  return
			var/reason = input(usr,"Reason?","Please State Reason","") as text|null
			if(reason)
				var/msg
				for(var/job in notbannedlist)
					ban_unban_log_save("[key_name(usr)] perma-jobbanned [key_name(M)] from [job]. reason: [reason]")
					log_admin("[key_name(usr)] perma-banned [key_name(M)] from [job]")
					feedback_inc("ban_job",1)
					DB_ban_record(BANTYPE_JOB_PERMA, M, -1, reason, job)
					feedback_add_details("ban_job","- [job]")
					jobban_fullban(M, job, "[reason]; By [usr.ckey] on [time2text(world.realtime)]")
					if(!msg)	msg = job
					else		msg += ", [job]"
				notes_add(M.ckey, "Banned  from [msg] - [reason]")
				message_admins(SPAN_NOTICE("[key_name_admin(usr)] banned [key_name_admin(M)] from [msg]"), 1)
				to_chat(M, SPAN_WARNING("<BIG><B>You have been jobbanned by [usr.client.ckey] from: [msg].</B></BIG>"))
				to_chat(M, SPAN_WARNING("<B>The reason is: [reason]</B>"))
				to_chat(M, SPAN_WARNING("Jobban can be lifted only upon request."))
				jobban_savebanfile()
				href_list["jobban2"] = 1 // lets it fall through and refresh
				return 1
				// if("Cancel")
				// 	return

		//Unbanning joblist
		//all jobs in joblist are banned already OR we didn't give a reason (implying they shouldn't be banned)
		if(joblist.len) //at least 1 banned job exists in joblist so we have stuff to unban.
			if(!config.ban_legacy_system)
				to_chat(usr, "Unfortunately, database based unbanning cannot be done through this panel")
				DB_ban_panel(M.ckey)
				return
			var/msg
			for(var/job in joblist)
				var/reason = jobban_isbanned(M, job)
				if(!reason) continue //skip if it isn't jobbanned anyway
				switch(alert("Job: '[job]' Reason: '[reason]' Un-jobban?","Please Confirm","Yes","No"))
					if("Yes")
						ban_unban_log_save("[key_name(usr)] unjobbanned [key_name(M)] from [job]")
						log_admin("[key_name(usr)] unbanned [key_name(M)] from [job]")
						DB_ban_unban(M.ckey, BANTYPE_JOB_PERMA, job)
						feedback_inc("ban_job_unban",1)
						feedback_add_details("ban_job_unban","- [job]")
						jobban_unban(M, job)
						if(!msg)	msg = job
						else		msg += ", [job]"
					else
						continue
			if(msg)
				message_admins(SPAN_NOTICE("[key_name_admin(usr)] unbanned [key_name_admin(M)] from [msg]"), 1)
				to_chat(M, SPAN_WARNING("<BIG><B>You have been un-jobbanned by [usr.client.ckey] from [msg].</B></BIG>"))
				href_list["jobban2"] = 1 // lets it fall through and refresh
			jobban_savebanfile()
			return 1
		return 0 //we didn't do anything!

	else if(href_list["boot2"])
		var/mob/M = locate(href_list["boot2"])
		if (ismob(M))
			if(!check_if_greater_rights_than(M.client))
				return
			var/reason = input("Please enter reason")
			if(!reason)
				to_chat(M, SPAN_WARNING("You have been kicked from the server"))
			else
				to_chat(M, SPAN_WARNING("You have been kicked from the server: [reason]"))
			log_admin("[key_name(usr)] booted [key_name(M)].")
			message_admins(SPAN_NOTICE("[key_name_admin(usr)] booted [key_name_admin(M)]."), 1)
			//M.client = null
			qdel(M.client)
/*
	//Player Notes
	else if(href_list["notes"])
		var/ckey = href_list["ckey"]
		if(!ckey)
			var/mob/M = locate(href_list["mob"])
			if(ismob(M))
				ckey = M.ckey

		switch(href_list["notes"])
			if("show")
				notes_show(ckey)
			if("add")
				notes_add(ckey,href_list["text"])
				notes_show(ckey)
			if("remove")
				notes_remove(ckey,text2num(href_list["from"]),text2num(href_list["to"]))
				notes_show(ckey)
*/
	else if(href_list["removejobban"])
		if(!check_rights(R_BAN))	return

		var/t = href_list["removejobban"]
		if(t)
			if((alert("Do you want to unjobban [t]?","Unjobban confirmation", "Yes", "No") == "Yes") && t) //No more misclicks! Unless you do it twice.
				log_admin("[key_name(usr)] removed [t]")
				message_admins(SPAN_NOTICE("[key_name_admin(usr)] removed [t]"), 1)
				jobban_remove(t)
				jobban_savebanfile()
				href_list["ban"] = 1 // lets it fall through and refresh
				var/t_split = splittext(t, " - ")
				var/key = t_split[1]
				var/job = t_split[2]
				DB_ban_unban(ckey(key), BANTYPE_JOB_PERMA, job)

	else if(href_list["newban"])
		if(!check_rights(R_MOD,0) && !check_rights(R_BAN))  return

		var/mob/M = locate(href_list["newban"])
		if(!ismob(M)) return

		if(M.client && M.client.admin_holder)	return	//admins cannot be banned. Even if they could, the ban doesn't affect them anyway

		if(!M.ckey)
			to_chat(usr, SPAN_DANGER("<B>Warning: Mob ckey for [M.name] not found.</b>"))
			return
		var/mob_key = M.ckey
		var/mob_id = M.computer_id
		var/mob_ip = M.lastKnownIP
		var/client/mob_client = M.client
		var/mins = input(usr,"How long (in minutes)? \n 1440 = 1 day \n 4320 = 3 days \n 10080 = 7 days","Ban time",1440) as num|null
		if(!mins)
			return
		if(mins >= 525600) mins = 525599
		var/reason = input(usr,"Reason? \n\nPress 'OK' to finalize the ban.","reason","Griefer") as message|null
		if(!reason)
			return
		if (AddBan(mob_key, mob_id, reason, usr.ckey, 1, mins, mob_ip))
			ban_unban_log_save("[usr.client.ckey] has banned [mob_key]|Duration: [mins] minutes|Reason: [sanitize(reason)]")
			to_chat(M, SPAN_WARNING("<BIG><B>You have been banned by [usr.client.ckey].\nReason: [sanitize(reason)].</B></BIG>"))
			to_chat(M, SPAN_WARNING("This is a temporary ban, it will be removed in [mins] minutes."))
			feedback_inc("ban_tmp",1)
			DB_ban_record(BANTYPE_TEMP, M, mins, reason)
			feedback_inc("ban_tmp_mins",mins)
			if(config.banappeals)
				to_chat(M, SPAN_WARNING("To try to resolve this matter head to [config.banappeals]"))
			else
				to_chat(M, SPAN_WARNING("No ban appeals URL has been set."))
			log_admin("[usr.client.ckey] has banned [mob_key]|Duration: [mins] minutes|Reason: [sanitize(reason)]")
			message_admins("\blue[usr.client.ckey] has banned [mob_key].\nReason: [sanitize(reason)]\nThis will be removed in [mins] minutes.")
			notes_add(mob_key, "Banned by [usr.client.ckey]|Duration: [mins] minutes|Reason: [sanitize(reason)]", usr)
		qdel(mob_client)

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
		AddBan(M.ckey, M.computer_id, reason, usr.ckey, 1, mins)
		ban_unban_log_save("[usr.client.ckey] has banned [M.ckey]|Duration: [mins] minutes|Reason: [reason]")
		to_chat(M, SPAN_WARNING("<BIG><B>You have been banned by [usr.client.ckey].\nReason: [reason].</B></BIG>"))
		to_chat(M, SPAN_WARNING("This is a temporary ban, it will be removed in [mins] minutes."))
		to_chat(M, SPAN_NOTICE(" This ban was made using a one-click ban system. If you think an error has been made, please visit our forums' ban appeal section."))
		to_chat(M, SPAN_NOTICE(" If you make sure to mention that this was a one-click ban, MadSnailDisease will personally double-check this code for you."))
		if(config.banappeals)
			to_chat(M, SPAN_NOTICE(" The ban appeal forums are located here: [config.banappeals]"))
		else
			to_chat(M, SPAN_NOTICE(" Unfortunately, no ban appeals URL has been set."))
		feedback_inc("ban_tmp", 1)
		DB_ban_record(BANTYPE_TEMP, M, mins, reason)
		feedback_inc("ban_tmp_mins", mins)
		log_admin("[usr.client.ckey] has banned [M.ckey]|Duration: [mins] minutes|Reason: [reason]")
		message_admins("\blue[usr.client.ckey] has banned [M.ckey].\nReason: [reason]\nThis will be removed in [mins] minutes.")
		notes_add(M.ckey, "Banned by [usr.client.ckey]|Duration: [mins] minutes|Reason: [reason]", usr)
		qdel(M.client)


	else if(href_list["mute"])
		if(!check_rights(R_MOD,0) && !check_rights(R_ADMIN))  return

		var/mob/M = locate(href_list["mute"])
		if(!ismob(M))	return
		if(!M.client)	return

		var/mute_type = href_list["mute_type"]
		if(istext(mute_type))	mute_type = text2num(mute_type)
		if(!isnum(mute_type))	return

		cmd_admin_mute(M, mute_type)

	else if(href_list["chem_panel"])
		switch(href_list["chem_panel"])
			if("view_reagent")
				var/target = input(usr,"Enter the ID of the chemical reagent you wish to view:")
				var/datum/reagent/R = chemical_reagents_list[target]
				if(R)
					usr.client.debug_variables(R)
				else
					to_chat(usr,SPAN_WARNING("No reagent with this ID could been found."))
				return
			if("view_reaction")
				var/target = input(usr,"Enter the ID of the chemical reaction you wish to view:")
				var/datum/chemical_reaction/R = chemical_reactions_list[target]
				if(R)
					usr.client.debug_variables(R)
					log_admin("[key_name(usr)] is viewing the chemical reaction for [R].")
				else
					to_chat(usr,SPAN_WARNING("No reaction with this ID could been found."))
				return
			if("spawn_reagent")
				var/target = input(usr,"Enter the ID of the chemical reagent you wish to make:")
				if(!chemical_reagents_list[target])
					to_chat(usr,SPAN_WARNING("No reagent with this ID could been found."))
					return
				var/volume = input(usr,"How much? An appropriate container will be selected.") as num
				if(volume)
					if(volume > 120)
						if(volume > 300)
							volume = 300
						var/obj/item/reagent_container/glass/beaker/bluespace/C = new /obj/item/reagent_container/glass/beaker/bluespace(usr.loc)
						C.reagents.add_reagent(target,volume)
					else if (volume > 60)
						var/obj/item/reagent_container/glass/beaker/large/C = new /obj/item/reagent_container/glass/beaker/large(usr.loc)
						C.reagents.add_reagent(target,volume)
					else if (volume > 30)
						var/obj/item/reagent_container/glass/beaker/C = new /obj/item/reagent_container/glass/beaker(usr.loc)
						C.reagents.add_reagent(target,volume)
					else
						var/obj/item/reagent_container/glass/beaker/vial/C = new /obj/item/reagent_container/glass/beaker/vial(usr.loc)
						C.reagents.add_reagent(target,volume)
				return
			//For quickly generating a new chemical
			if("create_random_reagent")
				var/target = input(usr,"Enter the ID of the chemical reagent you wish to make:")
				if(chemical_reagents_list[target])
					to_chat(usr,SPAN_WARNING("This ID is already in use."))
					return
				var/tier = input(usr,"Enter the generation tier you wish. This will affect the number of properties (tier + 1), rarity of components and potential for good properties. Ought to be 1-4, max 10.") as num
				if(tier > 10) tier = 10
				var/datum/reagent/generated/R = new /datum/reagent/generated
				var/list/stats_holder = list("name","properties","description","overdose","overdose_critical","nutriment_factor","custom_metabolism","color")
				chemical_gen_stats_list["[target]"] += stats_holder
				R.id = target
				R.gen_tier = tier
				R.chemclass = CHEM_CLASS_NONE //So we don't count it towards defcon
				R.properties = list()
				R.generate_name()
				R.generate_stats()
				//Save all variables from our holder
				R.name = chemical_gen_stats_list["[target]"]["name"]
				R.properties = chemical_gen_stats_list["[target]"]["properties"]
				R.description = chemical_gen_stats_list["[target]"]["description"]
				R.overdose = chemical_gen_stats_list["[target]"]["overdose"]
				R.overdose_critical = chemical_gen_stats_list["[target]"]["overdose_critical"]
				R.nutriment_factor = chemical_gen_stats_list["[target]"]["nutriment_factor"]
				R.custom_metabolism = chemical_gen_stats_list["[target]"]["custom_metabolism"]
				R.color = chemical_gen_stats_list["[target]"]["color"]
				//Save our reagent
				chemical_reagents_list[target] = R
				log_admin("[key_name(usr)] has generated the reagent: [target].")
				message_admins("[key_name_admin(usr)] has generated the reagent: [target].", 0)
				var/response = alert(usr,"Do you want to do anything else?",null,"Generate associated reaction","View my reagent","Finish")
				while(response != "Finish")
					switch(response)
						if("Generate associated reaction")
							if(chemical_reactions_list[target])
								to_chat(usr,SPAN_WARNING("This ID is already in use."))
								return
							var/datum/chemical_reaction/generated/G = new /datum/chemical_reaction/generated
							var/list/recipe_holder = list("required_reagents","required_catalysts")
							chemical_gen_reactions_list["[target]"] += recipe_holder
							G.id = target
							G.result = target
							G.name = R.name
							G.gen_tier = tier
							G.generate_recipe()
							//Save all variables from our holder
							G.required_reagents = chemical_gen_reactions_list["[target]"]["required_reagents"]
							G.required_catalysts = chemical_gen_reactions_list["[target]"]["required_catalysts"]
							//Save our reaction
							chemical_reactions_list[target] = G
							if(!chemical_reactions_list[target])
								to_chat(usr,SPAN_WARNING("Something went wrong when saving the reaction."))
								chemical_gen_stats_list["[target]"] -= stats_holder
								return
							var/list/reaction_ids = list()
							if(G.required_reagents && G.required_reagents.len)
								for(var/reaction in G.required_reagents)
									reaction_ids += reaction
							// Create filters based on each reagent id in the required reagents list
							for(var/id in reaction_ids)
								if(!chemical_reactions_filtered_list[id])
									chemical_reactions_filtered_list[id] = list()
								chemical_reactions_filtered_list[id] += G
								break // Don't bother adding ourselves to other reagent ids, it is redundant.
							response = alert(usr,"Do you want to do anything else?",null,"View my reaction","View my reagent","Finish")
						if("View my reagent")
							if(chemical_reagents_list[target])
								R = chemical_reagents_list[target]
								usr.client.debug_variables(R)
								log_admin("[key_name(usr)] is viewing the chemical reaction for [R].")
							else
								to_chat(usr,SPAN_WARNING("No reaction with this ID could been found. Wait what? But I just... Contact a debugger."))
								chemical_gen_stats_list.Remove("[target]")
								chemical_gen_reactions_list.Remove("[target]")
							return
						if("View my reaction")
							if(chemical_reactions_list[target])
								var/datum/chemical_reaction/generated/G = chemical_reactions_list[target]
								usr.client.debug_variables(G)
							else
								to_chat(usr,SPAN_WARNING("No reaction with this ID could been found. Wait what? But I just... Contact a debugger."))
								chemical_gen_stats_list.Remove("[target]")
								chemical_gen_reactions_list.Remove("[target]")
							return
						
						else
							break
				return
				//See what we want to do last
				response = alert(usr,"Spawn container with reagent?","Custom reagent [target]","Yes","No")
				if(response == "Yes")
					var/volume = input(usr,"How much? An appropriate container will be selected.") as num
					if(volume)
						if(volume > 120)
							if(volume > 300)
								volume = 300
							var/obj/item/reagent_container/glass/beaker/bluespace/C = new /obj/item/reagent_container/glass/beaker/bluespace(usr.loc)
							C.reagents.add_reagent(target,volume)
						else if (volume > 60)
							var/obj/item/reagent_container/glass/beaker/large/C = new /obj/item/reagent_container/glass/beaker/large(usr.loc)
							C.reagents.add_reagent(target,volume)
						else if (volume > 30)
							var/obj/item/reagent_container/glass/beaker/C = new /obj/item/reagent_container/glass/beaker(usr.loc)
							C.reagents.add_reagent(target,volume)
						else
							var/obj/item/reagent_container/glass/beaker/vial/C = new /obj/item/reagent_container/glass/beaker/vial(usr.loc)
							C.reagents.add_reagent(target,volume)
				return
			//For creating a custom reagent
			if("create_custom_reagent")
				var/target = input(usr,"Enter the ID of the chemical reagent you wish to make:")
				if(chemical_reagents_list[target])
					to_chat(usr,SPAN_WARNING("This ID is already in use."))
					return
				var/datum/reagent/generated/R = new /datum/reagent/generated
				var/list/stats_holder = list("name" = target,"properties" = list(),"description" = "","overdose" = 15,"overdose_critical" = 30,"nutriment_factor" = 0,"custom_metabolism" = 0.2,"color" = text("#[][][]",num2hex(rand(0,255)),num2hex(rand(0,255)),num2hex(rand(0,255))))
				chemical_gen_stats_list["[target]"] += stats_holder
				R.id = target
				R.chemclass = CHEM_CLASS_NONE //So we don't count it towards defcon
				R.properties = list()
				var/response = alert(usr,"Use capitalized ID as name?","Custom reagent [target]","[capitalize(target)]","Random name")
				if(response == "Random name")
					R.generate_name()
				else
					chemical_gen_stats_list["[target]"]["name"] = capitalize(response)
				
				response = alert(usr,"What do you want customized?","Custom reagent [target]","Add property","Randomize non property vars","Finish")
				while(response != "Finish")
					switch(response)
						if("Add property")
							response = alert(usr,"A specific property or a specific number of random properties?","Custom reagent [target]","Specific property","Specific number","No more properties")
						if("Specific property")	
							var/property_type = alert(usr,"What kind?","Custom reagent [target]","Negative","Neutral","Positive")
							var/list/pool
							switch(property_type)
								if("Negative")
									pool = get_negative_chem_properties(1)
								if("Neutral")
									pool = get_neutral_chem_properties(1)
								if("Positive")
									pool = get_positive_chem_properties(1)
								else
									response = alert(usr,"No? Then..","Custom reagent [target]","Specific property","Specific number","No more properties")
							pool = sortAssoc(pool)
							var/property = input(usr,"Which property do you want?") as null|anything in pool
							var/potency = input(usr,"Choose the potency (this is a strength modifier, ought to be between 1-4)") as num
							R.add_property(property,potency)
							response = alert(usr,"Done. Add more?","Custom reagent [target]","Specific property","Specific number","No more properties")
						if("Specific number")
							var/number = input(usr,"How many properties?") as num
							R.gen_tier = input(usr,"Enter the generation tier. This will affect how potent the properties can be. Must be between 1-4.") as num
							if(number > 10) number = 10
							for(var/i=1,i<=number,i++)
								R.add_property()
							response = alert(usr,"Done. What do you want customized next?","Custom reagent [target]","Add property","Randomize non property vars","Finish")
						if("No more properties")
							response = alert(usr,"What do you want customized?","Custom reagent [target]","Add property","Randomize non property vars","Finish")
						if("Randomize non property vars")
							R.generate_stats(1)
							response = alert(usr,"Done. What do you want customized next?","Custom reagent [target]","Add property","Randomize non property vars","Finish")
						else
							break
				//Save all variables from our holder
				R.name = chemical_gen_stats_list["[target]"]["name"]
				R.properties = chemical_gen_stats_list["[target]"]["properties"]
				R.description = chemical_gen_stats_list["[target]"]["description"]
				R.overdose = chemical_gen_stats_list["[target]"]["overdose"]
				R.overdose_critical = chemical_gen_stats_list["[target]"]["overdose_critical"]
				R.nutriment_factor = chemical_gen_stats_list["[target]"]["nutriment_factor"]
				R.custom_metabolism = chemical_gen_stats_list["[target]"]["custom_metabolism"]
				R.color = chemical_gen_stats_list["[target]"]["color"]
				//Save our reagent
				chemical_reagents_list[target] = R
				log_admin("[key_name(usr)] has created a custom reagent: [target].")
				message_admins("[key_name_admin(usr)] has created a custom reagent: [target].", 0)
				//See what we want to do last
				response = alert(usr,"Spawn container with reagent?","Custom reagent [target]","Yes","No, show me the reagent","No, I'm all done")
				switch(response)
					if("Yes")
						var/volume = input(usr,"How much? An appropriate container will be selected.") as num
						if(volume)
							if(volume > 120)
								if(volume > 300)
									volume = 300
								var/obj/item/reagent_container/glass/beaker/bluespace/C = new /obj/item/reagent_container/glass/beaker/bluespace(usr.loc)
								C.reagents.add_reagent(R.id,volume)
							else if (volume > 60)
								var/obj/item/reagent_container/glass/beaker/large/C = new /obj/item/reagent_container/glass/beaker/large(usr.loc)
								C.reagents.add_reagent(R.id,volume)
							else if (volume > 30)
								var/obj/item/reagent_container/glass/beaker/C = new /obj/item/reagent_container/glass/beaker(usr.loc)
								C.reagents.add_reagent(R.id,volume)
							else
								var/obj/item/reagent_container/glass/beaker/vial/C = new /obj/item/reagent_container/glass/beaker/vial(usr.loc)
								C.reagents.add_reagent(R.id,volume)
					if("No, show me the reagent")
						usr.client.debug_variables(chemical_reagents_list[target])
				return
			//For creating a custom reaction
			if("create_custom_reaction")
				var/target = input(usr,"Enter the ID of the chemical reaction you wish to make:")
				if(chemical_reactions_list[target])
					to_chat(usr,SPAN_WARNING("This ID is already in use."))
					return
				var/datum/chemical_reaction/generated/R = new /datum/chemical_reaction/generated
				var/list/recipe_holder = list("required_reagents","required_catalysts")
				chemical_gen_reactions_list["[target]"] += recipe_holder
				R.id = target
				R.result = input(usr,"Enter the reagent ID the reaction should result in:")
				R.name = capitalize(target)
				var/modifier = 1
				var/component = "water"
				var/catalyst = FALSE
				var/response = alert(usr,"What do you want customized?","Custom reaction [target]","Add component","Add catalyst","Finish")
				while(response != "Finish")
					switch(response)
						if("Add component")
							catalyst = FALSE
							response = "Select type"
						if("Add catalyst")
							catalyst = TRUE
							response = "Select type"
						if("Select type")
							response = alert(usr,"Enter id manually or select from list?","Custom reaction [target]","Select from list","Manual input","Back")
						if("Select from list")
							var/list/pool = chemical_reagents_list
							//for(var/datum/reagent/I in chemical_reagents_list)
								//pool += I.id
							pool = sortAssoc(pool)
							component = input(usr,"Select:") as null|anything in pool
							if(!component)
								response = "Select type"
								continue
							response = "Add"
						if("Manual input")
							component = input(usr,"Enter the ID of the reagent:")
							if(!component)
								response = "Select type"
								continue
							if(!chemical_reagents_list[component])
								to_chat(usr,SPAN_WARNING("ID not found. Try again."))
								continue
							response = "Add"
						if("Add")
							modifier = input("How much is required per reaction?") as num
							R.add_component(component,modifier,catalyst)
							response = "Back"
						if("Back")
							response = alert(usr,"What do you want customized?","Custom reaction [target]","Add component","Add catalyst","Finish")
						else
							return
				//Save all variables from our holder
				R.required_reagents = chemical_gen_reactions_list["[target]"]["required_reagents"]
				R.required_catalysts = chemical_gen_reactions_list["[target]"]["required_catalysts"]
				R.result = chemical_gen_reactions_list["[target]"]["result"]
				//Save each reaction ID
				var/list/reaction_ids = list()
				if(R.required_reagents && R.required_reagents.len)
					for(var/reaction in R.required_reagents)
						reaction_ids += reaction
				if(reaction_ids && reaction_ids.len < 3)
					to_chat(usr,SPAN_WARNING("You need to add at least 3 components."))
					return
				//Save our reaction
				chemical_reactions_list[target] = R
				if(!chemical_reactions_list[target])
					to_chat(usr,SPAN_WARNING("Something went wrong when saving the reaction."))
					return
				// Create filters based on each reagent id in the required reagents list
				for(var/id in reaction_ids)
					if(!chemical_reactions_filtered_list[id])
						chemical_reactions_filtered_list[id] = list()
					chemical_reactions_filtered_list[id] += R
					break // Don't bother adding ourselves to other reagent ids, it is redundant.
				usr.client.debug_variables(chemical_reactions_list[target])
				log_admin("[key_name(usr)] has created a custom chemical reaction: [target].")
				message_admins("[key_name_admin(usr)] has created a custom chemical reaction: [target].", 0)
				return
	else if(href_list["c_mode"])
		if(!check_rights(R_ADMIN))	return

		if(ticker && ticker.mode)
			return alert(usr, "The game has already started.", null, null, null, null)
		var/dat = {"<B>What mode do you wish to play?</B><HR>"}
		for(var/mode in config.modes)
			dat += {"<A href='?src=\ref[src];c_mode2=[mode]'>[config.mode_names[mode]]</A><br>"}
		// dat += {"<A href='?src=\ref[src];c_mode2=secret'>Secret</A><br>"}
		// dat += {"<A href='?src=\ref[src];c_mode2=random'>Random</A><br>"}
		dat += {"Now: [master_mode]"}
		usr << browse(dat, "window=c_mode")

	else if(href_list["f_secret"])
		if(!check_rights(R_ADMIN))	return

		if(ticker && ticker.mode)
			return alert(usr, "The game has already started.", null, null, null, null)
		if(master_mode != "secret")
			return alert(usr, "The game mode has to be secret!", null, null, null, null)
		var/dat = {"<B>What game mode do you want to force secret to be? Use this if you want to change the game mode, but want the players to believe it's secret. This will only work if the current game mode is secret.</B><HR>"}
		for(var/mode in config.modes)
			dat += {"<A href='?src=\ref[src];f_secret2=[mode]'>[config.mode_names[mode]]</A><br>"}
		dat += {"<A href='?src=\ref[src];f_secret2=secret'>Random (default)</A><br>"}
		dat += {"Now: [secret_force_mode]"}
		usr << browse(dat, "window=f_secret")

	else if(href_list["c_mode2"])
		if(!check_rights(R_ADMIN|R_SERVER))	return

		if (ticker && ticker.mode)
			return alert(usr, "The game has already started.", null, null, null, null)
		master_mode = href_list["c_mode2"]
		log_admin("[key_name(usr)] set the mode as [master_mode].")
		message_admins(SPAN_NOTICE("[key_name_admin(usr)] set the mode as [master_mode]."), 1)
		to_world(SPAN_NOTICE("<b><i>The mode is now: [master_mode]!</i></b>"))
		Game() // updates the main game menu
		world.save_mode(master_mode)
		.(href, list("c_mode"=1))

	else if(href_list["f_secret2"])
		if(!check_rights(R_ADMIN|R_SERVER))	return

		if(ticker && ticker.mode)
			return alert(usr, "The game has already started.", null, null, null, null)
		if(master_mode != "secret")
			return alert(usr, "The game mode has to be secret!", null, null, null, null)
		secret_force_mode = href_list["f_secret2"]
		log_admin("[key_name(usr)] set the forced secret mode as [secret_force_mode].")
		message_admins(SPAN_NOTICE("[key_name_admin(usr)] set the forced secret mode as [secret_force_mode]."), 1)
		Game() // updates the main game menu
		.(href, list("f_secret"=1))

	else if(href_list["monkeyone"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["monkeyone"])
		if(!istype(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human")
			return

		log_admin("[key_name(usr)] attempting to monkeyize [key_name(H)]")
		message_admins(SPAN_NOTICE("[key_name_admin(usr)] attempting to monkeyize [key_name_admin(H)]"), 1)
		H.monkeyize()

	else if(href_list["corgione"])
		if(!check_rights(R_SPAWN))	return

		var/mob/living/carbon/human/H = locate(href_list["corgione"])
		if(!istype(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human")
			return

		log_admin("[key_name(usr)] attempting to corgize [key_name(H)]")
		message_admins(SPAN_NOTICE("[key_name_admin(usr)] attempting to corgize [key_name_admin(H)]"), 1)
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
		log_admin("[key_name(usr)] forced [key_name(M)] to say: [speech]")
		message_admins(SPAN_NOTICE("[key_name_admin(usr)] forced [key_name_admin(M)] to say: [speech]"))

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

		log_admin("[key_name(usr)] infected [key_name(H)] with a ZOMBIE VIRUS")
		message_admins(SPAN_NOTICE("[key_name_admin(usr)] infected [key_name_admin(H)] with a ZOMBIE VIRUS"))
	else if(href_list["larvainfect"])
		if(!check_rights(R_ADMIN))	return
		var/mob/living/carbon/human/H = locate(href_list["larvainfect"])
		if(!istype(H))
			to_chat(usr, "this can only be used on instances of type /human")
			return

		if(alert(usr, "Are you sure you want to infect them with a xeno larva?", "Message", "Yes", "No") != "Yes")
			return

		var/list/namelist = list("Normal","Corrupted","Alpha","Beta","Zeta")
		var/newhive = input(usr,"Select a hive.", null, null) in namelist

		if(!H)
			to_chat(usr, "This mob no longer exists")
			return
		var/newhivenumber
		var/newhivefaction
		switch(newhive)
			if("Normal")
				newhivenumber = XENO_HIVE_NORMAL
				newhivefaction = FACTION_XENOMORPH
			if("Corrupted")
				newhivenumber = XENO_HIVE_CORRUPTED
				newhivefaction = FACTION_XENOMORPH_CORRPUTED
			if("Alpha")
				newhivenumber = XENO_HIVE_ALPHA
				newhivefaction = FACTION_XENOMORPH_ALPHA
			if("Beta")
				newhivenumber = XENO_HIVE_BETA
				newhivefaction = FACTION_XENOMORPH_BETA
			if("Zeta")
				newhivenumber = XENO_HIVE_ZETA
				newhivefaction = FACTION_XENOMORPH_ZETA

		var/obj/item/alien_embryo/embryo = new /obj/item/alien_embryo(H)
		embryo.hivenumber = newhivenumber
		embryo.faction = newhivefaction

		log_admin("[key_name(usr)] infected [key_name(H)] with a xeno ([newhive]) larva.")
		message_admins(SPAN_NOTICE("[key_name_admin(usr)] infected [key_name_admin(H)] with a xeno ([newhive]) larva."))
	else if(href_list["forceemote"])
		if(!check_rights(R_FUN))	return

		var/mob/M = locate(href_list["forceemote"])
		if(!ismob(M))
			to_chat(usr, "this can only be used on instances of type /mob")

		var/speech = input("What will [key_name(M)] emote?.", "Force emote", "")// Don't need to sanitize, since it does that in say(), we also trust our admins.
		if(!speech)	return
		M.custom_emote(1, speech, TRUE)
		speech = sanitize(speech) // Nah, we don't trust them
		log_admin("[key_name(usr)] forced [key_name(M)] to emote: [speech]")
		message_admins(SPAN_NOTICE("[key_name_admin(usr)] forced [key_name_admin(M)] to emote: [speech]"))

	else if(href_list["sendtoprison"])
		if(!check_rights(R_ADMIN))	return

		if(alert(usr, "Send to admin prison for the round?", "Message", "Yes", "No") != "Yes")
			return

		var/mob/M = locate(href_list["sendtoprison"])
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return
		if(isAI(M))
			to_chat(usr, "This cannot be used on instances of type /mob/living/silicon/ai")
			return

		var/turf/prison_cell = pick(prisonwarp)
		if(!prison_cell)	return

		var/obj/structure/closet/secure_closet/brig/locker = new /obj/structure/closet/secure_closet/brig(prison_cell)
		locker.opened = 0
		locker.locked = 1

		//strip their stuff and stick it in the crate
		for(var/obj/item/I in M)
			M.drop_inv_item_to_loc(I, locker)

		//so they black out before warping
		M.KnockOut(5)
		sleep(5)
		if(!M)	return

		M.loc = prison_cell
		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/prisoner = M
			prisoner.equip_to_slot_or_del(new /obj/item/clothing/under/color/orange(prisoner), WEAR_BODY)
			prisoner.equip_to_slot_or_del(new /obj/item/clothing/shoes/orange(prisoner), WEAR_FEET)

		to_chat(M, SPAN_WARNING("You have been sent to the prison station!"))
		log_admin("[key_name(usr)] sent [key_name(M)] to the prison station.")
		message_admins(SPAN_NOTICE("[key_name_admin(usr)] sent [key_name_admin(M)] to the prison station."), 1)

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

		log_admin("[key_name(usr)] has sent [key_name(M)] back to the Lobby.")
		message_admins("[key_name(usr)] has sent [key_name(M)] back to the Lobby.")

		var/mob/new_player/NP = new()
		NP.ckey = M.ckey
		if(NP.client) NP.client.change_view(world.view)
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
		M.loc = pick(tdome1)
		spawn(50)
			to_chat(M, SPAN_NOTICE(" You have been sent to the Thunderdome."))
		log_admin("[key_name(usr)] has sent [key_name(M)] to the thunderdome. (Team 1)")
		message_admins("[key_name_admin(usr)] has sent [key_name_admin(M)] to the thunderdome. (Team 1)", 1)

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
		M.loc = pick(tdome2)
		spawn(50)
			to_chat(M, SPAN_NOTICE(" You have been sent to the Thunderdome."))
		log_admin("[key_name(usr)] has sent [key_name(M)] to the thunderdome. (Team 2)")
		message_admins("[key_name_admin(usr)] has sent [key_name_admin(M)] to the thunderdome. (Team 2)", 1)

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
		M.loc = pick(tdomeadmin)
		spawn(50)
			to_chat(M, SPAN_NOTICE(" You have been sent to the Thunderdome."))
		log_admin("[key_name(usr)] has sent [key_name(M)] to the thunderdome. (Admin.)")
		message_admins("[key_name_admin(usr)] has sent [key_name_admin(M)] to the thunderdome. (Admin.)", 1)

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
		M.loc = pick(tdomeobserve)
		spawn(50)
			to_chat(M, SPAN_NOTICE(" You have been sent to the Thunderdome."))
		log_admin("[key_name(usr)] has sent [key_name(M)] to the thunderdome. (Observer.)")
		message_admins("[key_name_admin(usr)] has sent [key_name_admin(M)] to the thunderdome. (Observer.)", 1)

	else if(href_list["revive"])
		if(!check_rights(R_REJUVINATE))	return

		var/mob/living/L = locate(href_list["revive"])
		if(!istype(L))
			to_chat(usr, "This can only be used on instances of type /mob/living")
			return

		if(config.allow_admin_rev)
			L.revive()
			message_admins(SPAN_DANGER("Admin [key_name_admin(usr)] healed / revived [key_name_admin(L)]!"), 1)
			log_admin("[key_name(usr)] healed / revived [key_name(L)]")
		else
			to_chat(usr, "Admin Rejuvinates have been disabled")

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

		message_admins(SPAN_DANGER("Admin [key_name_admin(usr)] AIized [key_name_admin(H)]!"), 1)
		log_admin("[key_name(usr)] AIized [key_name(H)]")
		H.AIize()

	else if(href_list["changehivenumber"])
		if(!check_rights(R_DEBUG|R_ADMIN))	return

		var/mob/living/carbon/Xenomorph/X = locate(href_list["changehivenumber"])
		if(!istype(X))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon/Xenomorph")
			return

		X.set_hivenumber_and_update(href_list["newhivenumber"])
		message_admins(SPAN_NOTICE("[key_name(usr)] changed hivenumber of [X] to [X.hivenumber]."), 1)

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
			M.real_name = y_name
			M.gender = y_gend
			M.regenerate_icons()
			log_admin("[key_name(usr)] changed [H] into a new Yautja, [M.real_name].")
			message_admins("[key_name(usr)] made [H] into a Yautja, [M.real_name].")
			if(H.mind)
				H.mind.transfer_to(M)
				if(M.mind.cm_skills)
					qdel(M.mind.cm_skills)
				M.mind.cm_skills = null //no skill restriction
			else
				M.key = H.key
				if(M.client) M.client.change_view(world.view)
			if(is_alien_whitelisted(M,"Yautja Elder"))
				H.real_name = "Elder [M.real_name]"
				H.equip_to_slot_or_del(new /obj/item/clothing/suit/armor/yautja/full(H), WEAR_JACKET)
				H.equip_to_slot_or_del(new /obj/item/weapon/twohanded/glaive(H), WEAR_L_HAND)

			if(H) qdel(H) //May have to clear up round-end vars and such....

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


	else if(href_list["xenoupgrade"])
		if(!check_rights(R_ADMIN))
			return

		var/mob/living/carbon/Xenomorph/X = locate(href_list["xenoupgrade"])
		
		if(X.upgrade == -1)
			to_chat(usr, "You cannot upgrade this caste.")

		if(alert(usr, "Are you sure you want to upgrade this xenomorph?", "Confirmation", "Yes", "No") != "Yes")
			return

		var/upgrade_list = input("Choose a level.") in list("Young", "Mature", "Elder", "Ancient", "Cancel")

		var/level

		switch(upgrade_list)
			if("Young")
				level = 0
			if("Mature")
				level = 1
			if("Elder")
				level = 2
			if("Ancient")
				level = 3
			if("Cancel")
				return

		X.upgrade_xeno(level)
		log_admin("[usr.ckey] has changed the maturation level of [X] ([X.ckey]) to [level].")
		message_admins("[usr.ckey] has changed the maturation level of [X] ([X.ckey]) to [level].")

/***************** BEFORE**************

	if (href_list["l_players"])
		var/dat = "<B>Name/Real Name/Key/IP:</B><HR>"
		for(var/mob/M in mob_list)
			var/foo = ""
			if (ismob(M) && M.client)
				if(!M.client.authenticated && !M.client.authenticating)
					foo += text("\[ <A HREF='?src=\ref[];adminauth=\ref[]'>Authorize</A>|", src, M)
				else
					foo += text("\[ <B>Authorized</B>|")
				if(M.start)
					if(!istype(M, /mob/living/carbon/human/monkey))
						foo += text("<A HREF='?src=\ref[];monkeyone=\ref[]'>Monkeyize</A>|", src, M)
					else
						foo += text("<B>Monkeyized</B>|")
					if(isAI(M))
						foo += text("<B>Is an AI</B>|")
					else
						foo += text("<A HREF='?src=\ref[];makeai=\ref[]'>Make AI</A>|", src, M)
					if(M.z != 2)
						foo += text("<A HREF='?src=\ref[];sendtoprison=\ref[]'>Prison</A>|", src, M)
						foo += text("<A HREF='?src=\ref[];sendtomaze=\ref[]'>Maze</A>|", src, M)
					else
						foo += text("<B>On Z = 2</B>|")
				else
					foo += text("<B>Hasn't Entered Game</B>|")
				foo += text("<A HREF='?src=\ref[];revive=\ref[]'>Heal/Revive</A>|", src, M)

				foo += text("<A HREF='?src=\ref[];forcespeech=\ref[]'>Say</A> \]", src, M)
			dat += text("N: [] R: [] (K: []) (IP: []) []<BR>", M.name, M.real_name, (M.client ? M.client : "No client"), M.lastKnownIP, foo)

		usr << browse(dat, "window=players;size=900x480")

*****************AFTER******************/

// Now isn't that much better? IT IS NOW A PROC, i.e. kinda like a big panel like unstable

	else if(href_list["adminplayeropts"])
		var/mob/M = locate(href_list["adminplayeropts"])
		show_player_panel(M)

	else if(href_list["playerpanelextended"])
		player_panel_extended()

	else if(href_list["adminplayerobservejump"])
		if(!check_rights(R_MENTOR|R_MOD|R_ADMIN))	return

		var/mob/M = locate(href_list["adminplayerobservejump"])

		var/client/C = usr.client
		if(!isobserver(usr))	C.admin_ghost()
		sleep(2)
		C.jumptomob(M)

	else if(href_list["adminplayerfollow"])
		if(!check_rights(R_MENTOR|R_MOD|R_ADMIN))	return

		var/mob/M = locate(href_list["adminplayerfollow"])

		var/client/C = usr.client
		if(!isobserver(usr))	C.admin_ghost()
		sleep(2)
		if(isobserver(usr))
			var/mob/dead/observer/G = usr
			G.ManualFollow(M)

	else if(href_list["check_antagonist"])
		check_antagonists()

	else if(href_list["adminplayerobservecoodjump"])
		if(!check_rights(R_MOD))	return

		var/x = text2num(href_list["X"])
		var/y = text2num(href_list["Y"])
		var/z = text2num(href_list["Z"])

		var/client/C = usr.client
		if(!isobserver(usr))	C.admin_ghost()
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
		log_admin("[src.owner] has cancelled the orbital strike.")
		message_admins("[src.owner] has cancelled the orbital strike.")

	else if(href_list["adminmoreinfo"])
		var/mob/M = locate(href_list["adminmoreinfo"])
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		var/location_description = ""
		var/special_role_description = ""
		var/health_description = ""
		var/gender_description = ""
		var/turf/T = get_turf(M)

		//Location
		if(isturf(T))
			if(isarea(T.loc))
				location_description = "([M.loc == T ? "at coordinates " : "in [M.loc] at coordinates "] [T.x], [T.y], [T.z] in area <b>[T.loc]</b>)"
			else
				location_description = "([M.loc == T ? "at coordinates " : "in [M.loc] at coordinates "] [T.x], [T.y], [T.z])"

		//Job + antagonist
		if(M.mind)
			special_role_description = "Role: <b>[M.mind.assigned_role]</b>; Antagonist: <font color='red'><b>[M.mind.special_role]</b></font>; Has been rev: [(M.mind.has_been_rev)?"Yes":"No"]"
		else
			special_role_description = "Role: <i>Mind datum missing</i> Antagonist: <i>Mind datum missing</i>; Has been rev: <i>Mind datum missing</i>;"

		//Health
		if(isliving(M))
			var/mob/living/L = M
			var/status
			switch (M.stat)
				if (0) status = "Alive"
				if (1) status = "<font color='orange'><b>Unconscious</b></font>"
				if (2) status = "<font color='red'><b>Dead</b></font>"
			health_description = "Status = [status]"
			health_description += "<BR>Oxy: [L.getOxyLoss()] - Tox: [L.getToxLoss()] - Fire: [L.getFireLoss()] - Brute: [L.getBruteLoss()] - Clone: [L.getCloneLoss()] - Brain: [L.getBrainLoss()]"
		else
			health_description = "This mob type has no health to speak of."

		//Gener
		switch(M.gender)
			if(MALE,FEMALE)	gender_description = "[M.gender]"
			else			gender_description = "<font color='red'><b>[M.gender]</b></font>"

		to_chat(src.owner, "<b>Info about [M.name]:</b> ")
		to_chat(src.owner, "Mob type = [M.type]; Gender = [gender_description] Damage = [health_description]")
		to_chat(src.owner, "Name = <b>[M.name]</b>; Real_name = [M.real_name]; Mind_name = [M.mind?"[M.mind.name]":""]; Key = <b>[M.key]</b>;")
		to_chat(src.owner, "Location = [location_description];")
		to_chat(src.owner, "[special_role_description]")
		to_chat(src.owner, "(<a href='?src=\ref[usr];priv_msg=\ref[M]'>PM</a>) (<A HREF='?src=\ref[src];adminplayeropts=\ref[M]'>PP</A>) (<A HREF='?_src_=vars;Vars=\ref[M]'>VV</A>) (<A HREF='?src=\ref[src];subtlemessage=\ref[M]'>SM</A>) (<A HREF='?src=\ref[src];adminplayerobservejump=\ref[M]'>JMP</A>) (<A HREF='?src=\ref[src];secretsadmin=check_antagonist'>CA</A>)")

	else if(href_list["adminspawncookie"])
		if(!check_rights(R_ADMIN|R_FUN))	return

		var/mob/living/carbon/human/H = locate(href_list["adminspawncookie"])
		if(!ishuman(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human")
			return

		H.equip_to_slot_or_del( new /obj/item/reagent_container/food/snacks/cookie(H), WEAR_L_HAND )
		if(!(istype(H.l_hand,/obj/item/reagent_container/food/snacks/cookie)))
			H.equip_to_slot_or_del( new /obj/item/reagent_container/food/snacks/cookie(H), WEAR_R_HAND )
			if(!(istype(H.r_hand,/obj/item/reagent_container/food/snacks/cookie)))
				log_admin("[key_name(H)] has their hands full, so they did not receive their cookie, spawned by [key_name(src.owner)].")
				message_admins("[key_name(H)] has their hands full, so they did not receive their cookie, spawned by [key_name(src.owner)].")
				return
			else
				H.update_inv_r_hand()//To ensure the icon appears in the HUD
		else
			H.update_inv_l_hand()
		log_admin("[key_name(H)] got their cookie, spawned by [key_name(src.owner)]")
		message_admins("[key_name(H)] got their cookie, spawned by [key_name(src.owner)]")
		feedback_inc("admin_cookies_spawned",1)
		to_chat(H, SPAN_NOTICE(" Your prayers have been answered!! You received the <b>best cookie</b>!"))

	else if(href_list["BlueSpaceArtillery"])
		if(!check_rights(R_ADMIN|R_FUN))	return

		var/mob/living/M = locate(href_list["BlueSpaceArtillery"])
		if(!isliving(M))
			to_chat(usr, "This can only be used on instances of type /mob/living")
			return

		if(alert(src.owner, "Are you sure you wish to hit [key_name(M)] with Blue Space Artillery? This will severely hurt and most likely kill them.",  "Confirm Firing?" , "Yes" , "No") != "Yes")
			return

		if(BSACooldown)
			to_chat(src.owner, "Standby!  Reload cycle in progress!  Gunnary crews ready in five seconds!")
			return

		BSACooldown = 1
		spawn(50)
			BSACooldown = 0

		to_chat(M, "You've been hit by bluespace artillery!")
		log_admin("[key_name(M)] has been hit by Bluespace Artillery fired by [src.owner]")
		message_admins("[key_name(M)] has been hit by Bluespace Artillery fired by [src.owner]")

		var/turf/open/floor/T = get_turf(M)
		if(istype(T))
			if(prob(80))	T.break_tile_to_plating()
			else			T.break_tile()

		if(M.health == 1)
			M.gib()
		else
			M.adjustBruteLoss( min( 99 , (M.health - 1) )    )
			M.Stun(20)
			M.KnockDown(20)
			M.stuttering = 20

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
		if(!input)	return

		to_chat(src.owner, "You sent [input] to [H] via a secure channel.")
		log_admin("[src.owner] replied to [key_name(H)]'s USCM message with the message [input].")
		for(var/client/X in admins)
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
		if(!input)	return

		to_chat(src.owner, "You sent [input] to [H] via a secure channel.")
		log_admin("[src.owner] replied to [key_name(H)]'s Syndicate message with the message [input].")
		to_chat(H, "You hear something crackle in your headset for a moment before a voice speaks.  \"Please stand by for a message from your benefactor.  Message as follows, agent. <b>\"[input]\"</b>  Message ends.\"")

	else if(href_list["USCMFaxReply"])
		var/mob/living/carbon/human/H = locate(href_list["USCMFaxReply"])
		var/obj/machinery/faxmachine/fax = locate(href_list["originfax"])

		var/template_choice = input("Use which template or roll your own?") in list("USCM High Command", "USCM Provost General", "Custom")
		var/fax_message = ""
		switch(template_choice)
			if("Custom")
				var/input = input(src.owner, "Please enter a message to reply to [key_name(H)] via secure connection. NOTE: BBCode does not work, but HTML tags do! Use <br> for line breaks.", "Outgoing message from USCM", "") as message|null
				if(!input)	return
				fax_message = "[input]"
			if("USCM High Command", "USCM Provost General")
				var/subject = input(src.owner, "Enter subject line", "Outgoing message from USCM", "") as message|null
				if(!subject) return
				var/addressed_to = ""
				var/address_option = input("Address it to the sender or custom?") in list("Sender", "Custom")
				if(address_option == "Sender")
					addressed_to = "[H.real_name]"
				else if(address_option == "Custom")
					addressed_to = input(src.owner, "Enter Addressee Line", "Outgoing message from USCM", "") as message|null
					if(!addressed_to) return
				else
					return
				var/message_body = input(src.owner, "Enter Message Body, use <p></p> for paragraphs", "Outgoing message from Weyland USCM", "") as message|null
				if(!message_body) return
				var/sent_by = input(src.owner, "Enter the name and rank you are sending from.", "Outgoing message from USCM", "") as message|null
				if(!sent_by) return
				var/sent_title = "Office of the Provost General"
				if(template_choice == "USCM High Command")
					sent_title = "USCM High Command"

				fax_message = generate_templated_fax(0,"USCM CENTRAL COMMAND",subject,addressed_to,message_body,sent_by,sent_title,"United States Colonial Marine Corps")
		usr << browse(fax_message, "window=uscmfaxpreview;size=600x600")
		var/send_choice = input("Send this fax?") in list("Send", "Cancel")
		if(send_choice == "Cancel") return
		fax_contents += fax_message // save a copy

		USCMFaxes.Add("<a href='?FaxView=\ref[fax_message]'>\[view reply at [world.timeofday]\]</a>")

		var/customname = input(src.owner, "Pick a title for the report", "Title") as text|null

		var/msg_ghost = SPAN_NOTICE("<b><font color='#1F66A0'>USCM FAX REPLY: </font></b> ")
		msg_ghost += "Transmitting '[customname]' via secure connection ... "
		msg_ghost += "<a href='?FaxView=\ref[fax_message]'>view message</a>"
		announce_fax( ,msg_ghost)

		for(var/obj/machinery/faxmachine/F in machines)
			if(F == fax)
				if(! (F.stat & (BROKEN|NOPOWER) ) )

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
				log_admin("[key_name(src.owner)] replied to a fax message from [key_name(H)]: [fax_message]")
				message_admins("[key_name_admin(src.owner)] replied to a fax message from [key_name_admin(H)]", 1)
				return
		to_chat(src.owner, "/red Unable to locate fax!")

	else if(href_list["CLFaxReply"])
		var/mob/living/carbon/human/H = locate(href_list["CLFaxReply"])
		var/obj/machinery/faxmachine/fax = locate(href_list["originfax"])

		var/template_choice = input("Use the template or roll your own?") in list("Template", "Custom")
		var/fax_message = ""
		switch(template_choice)
			if("Custom")
				var/input = input(src.owner, "Please enter a message to reply to [key_name(H)] via secure connection. NOTE: BBCode does not work, but HTML tags do! Use <br> for line breaks.", "Outgoing message from Weyland Yutani", "") as message|null
				if(!input)	return
				fax_message = "[input]"
			if("Template")
				var/subject = input(src.owner, "Enter subject line", "Outgoing message from Weyland Yutani", "") as message|null
				if(!subject) return
				var/addressed_to = ""
				var/address_option = input("Address it to the sender or custom?") in list("Sender", "Custom")
				if(address_option == "Sender")
					addressed_to = "[H.real_name]"
				else if(address_option == "Custom")
					addressed_to = input(src.owner, "Enter Addressee Line", "Outgoing message from Weyland Yutani", "") as message|null
					if(!addressed_to) return
				else
					return
				var/message_body = input(src.owner, "Enter Message Body, use <p></p> for paragraphs", "Outgoing message from Weyland Yutani", "") as message|null
				if(!message_body) return
				var/sent_by = input(src.owner, "Enter JUST the name you are sending this from", "Outgoing message from Weyland Yutani", "") as message|null
				if(!sent_by) return
				fax_message = generate_templated_fax(1,"WEYLAND-YUTANI CORPORATE AFFAIRS - USS ALMAYER",subject,addressed_to,message_body,sent_by,"Corporate Affairs Director","Weyland-Yutani")
		usr << browse(fax_message, "window=clfaxpreview;size=600x600")
		var/send_choice = input("Send this fax?") in list("Send", "Cancel")
		if(send_choice == "Cancel") return
		fax_contents += fax_message // save a copy

		CLFaxes.Add("<a href='?FaxView=\ref[fax_message]'>\[view reply at [world.timeofday]\]</a>") //Add replies so that mods know what the hell is goin on with the RP

		var/customname = input(src.owner, "Pick a title for the report", "Title") as text|null

		var/msg_ghost = SPAN_NOTICE("<b><font color='#1F66A0'>WEYLAND-YUTANI FAX REPLY: </font></b> ")
		msg_ghost += "Transmitting '[customname]' via secure connection ... "
		msg_ghost += "<a href='?FaxView=\ref[fax_message]'>view message</a>"
		announce_fax( ,msg_ghost)


		for(var/obj/machinery/faxmachine/F in machines)
			if(F == fax)
				if(! (F.stat & (BROKEN|NOPOWER) ) )

					// animate! it's alive!
					flick("faxreceive", F)

					// give the sprite some time to flick
					spawn(20)
						var/obj/item/paper/P = new /obj/item/paper( F.loc )
						P.name = "Weyland Yutani - [customname]"
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
						P.stamps += "<HR><i>This paper has been stamped and encrypted by the Weyland Yutani Quantum Relay (tm).</i>"

				to_chat(src.owner, "Message reply to transmitted successfully.")
				log_admin("[key_name(src.owner)] replied to a fax message from [key_name(H)]: [fax_message]")
				message_admins("[key_name_admin(src.owner)] replied to a fax message from [key_name_admin(H)]", 1)
				return
		to_chat(src.owner, "/red Unable to locate fax!")



	else if(href_list["jumpto"])
		if(!check_rights(R_ADMIN))	return

		var/mob/M = locate(href_list["jumpto"])
		usr.client.jumptomob(M)

	else if(href_list["getmob"])
		if(!check_rights(R_ADMIN))	return

		if(alert(usr, "Confirm?", "Message", "Yes", "No") != "Yes")	return
		var/mob/M = locate(href_list["getmob"])
		usr.client.Getmob(M)

	else if(href_list["sendmob"])
		if(!check_rights(R_ADMIN))	return

		var/mob/M = locate(href_list["sendmob"])
		usr.client.sendmob(M)

	else if(href_list["narrateto"])
		if(!check_rights(R_ADMIN))	return

		var/mob/M = locate(href_list["narrateto"])
		usr.client.cmd_admin_direct_narrate(M)

	else if(href_list["subtlemessage"])
		if(!check_rights(R_MOD,0) && !check_rights(R_ADMIN))  return

		var/mob/M = locate(href_list["subtlemessage"])
		usr.client.cmd_admin_subtle_message(M)

	else if(href_list["traitor"])
		if(!check_rights(R_ADMIN|R_MOD))	return

		if(!ticker || !ticker.mode)
			alert("The game hasn't started yet!")
			return

		var/mob/M = locate(href_list["traitor"])
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob.")
			return
		show_traitor_panel(M)

	else if(href_list["create_object"])
		if(!check_rights(R_SPAWN))	return
		return create_object(usr)

	else if(href_list["quick_create_object"])
		if(!check_rights(R_SPAWN))	return
		return quick_create_object(usr)

	else if(href_list["create_turf"])
		if(!check_rights(R_SPAWN))	return
		return create_turf(usr)

	else if(href_list["create_mob"])
		if(!check_rights(R_SPAWN))	return
		return create_mob(usr)

	else if(href_list["object_list"])			//this is the laggiest thing ever
		if(!check_rights(R_SPAWN))	return

		if(!config.allow_admin_spawning)
			to_chat(usr, "Spawning of items is not allowed.")
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
		if (!( where in list("onfloor","inhand","inmarked") ))
			where = "onfloor"

		if( where == "inhand" )
			to_chat(usr, "Support for inhand not available yet. Will spawn on floor.")
			where = "onfloor"

		if ( where == "inhand" )	//Can only give when human or monkey
			if ( !(ishuman(usr)) )
				to_chat(usr, "Can only spawn in hand when you're a human or a monkey.")
				where = "onfloor"
			else if ( usr.get_active_hand() )
				to_chat(usr, "Your active hand is full. Spawning on floor.")
				where = "onfloor"

		if ( where == "inmarked" )
			if ( !marked_datum )
				to_chat(usr, "You don't have any object marked. Abandoning spawn.")
				return
			else
				if ( !istype(marked_datum,/atom) )
					to_chat(usr, "The object you have marked cannot be used as a target. Target must be of type /atom. Abandoning spawn.")
					return

		var/atom/target //Where the object will be spawned
		switch ( where )
			if ( "onfloor" )
				switch (href_list["offset_type"])
					if ("absolute")
						target = locate(0 + X,0 + Y,0 + Z)
					if ("relative")
						target = locate(loc.x + X,loc.y + Y,loc.z + Z)
			if ( "inmarked" )
				target = marked_datum

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
							O.dir = obj_dir
							if(obj_name)
								O.name = obj_name
								if(istype(O,/mob))
									var/mob/M = O
									M.real_name = obj_name

		if (number == 1)
			log_admin("[key_name(usr)] created a [english_list(paths)]")
			for(var/path in paths)
				if(ispath(path, /mob))
					message_admins("[key_name_admin(usr)] created a [english_list(paths)]", 1)
					break
		else
			log_admin("[key_name(usr)] created [number]ea [english_list(paths)]")
			for(var/path in paths)
				if(ispath(path, /mob))
					message_admins("[key_name_admin(usr)] created [number]ea [english_list(paths)]", 1)
					break
		return

	else if(href_list["secretsfun"])
		if(!check_rights(R_FUN))	return

		switch(href_list["secretsfun"])
			if("gravity")
				if(!(ticker && ticker.mode))
					to_chat(usr, "Please wait until the game starts!  Not sure how it will work otherwise.")
					return
				gravity_is_on = !gravity_is_on
				for(var/area/A in all_areas)
					A.gravitychange(gravity_is_on,A)
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","Grav")
				if(gravity_is_on)
					log_admin("[key_name(usr)] toggled gravity on.", 1)
					message_admins(SPAN_NOTICE("[key_name_admin(usr)] toggled gravity on."), 1)
					command_announcement.Announce("Gravity generators are again functioning within normal parameters. Sorry for any inconvenience.")
				else
					log_admin("[key_name(usr)] toggled gravity off.", 1)
					message_admins(SPAN_NOTICE("[key_name_admin(usr)] toggled gravity off."), 1)
					command_announcement.Announce("Feedback surge detected in mass-distributions systems. Artifical gravity has been disabled whilst the system reinitializes. Further failures may result in a gravitational collapse and formation of blackholes. Have a nice day.")
			if("spiders")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","SL")
				new /datum/event/spider_infestation
				message_admins("[key_name_admin(usr)] has spawned spiders", 1)
			if("comms_blackout")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","CB")
				var/answer = alert(usr, "Would you like to alert the crew?", "Alert", "Yes", "No")
				if(answer == "Yes")
					communications_blackout(0)
				else
					communications_blackout(1)
				message_admins("[key_name_admin(usr)] triggered a communications blackout.", 1)
			if("radiation")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","R")
				message_admins("[key_name_admin(usr)] has has irradiated the station", 1)
				new /datum/event/radiation_storm
			if("lightout")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","LO")
				message_admins("[key_name_admin(usr)] has broke a lot of lights", 1)
				lightsout(1,2)
			if("blackout")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","BO")
				message_admins("[key_name_admin(usr)] broke all lights", 1)
				lightsout(0,0)
			if("whiteout")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","WO")
				for(var/obj/machinery/light/L in machines)
					L.fix()
				message_admins("[key_name_admin(usr)] fixed all lights", 1)
			if("power")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","P")
				log_admin("[key_name(usr)] powered all SMESs and APCs", 1)
				message_admins(SPAN_NOTICE("[key_name_admin(usr)] powered all SMESs and APCs"), 1)
				power_restore()
			if("unpower")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","UP")
				log_admin("[key_name(usr)] unpowered all SMESs and APCs", 1)
				message_admins(SPAN_NOTICE("[key_name_admin(usr)] unpowered all SMESs and APCs"), 1)
				power_failure()
			if("quickpower")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","QP")
				log_admin("[key_name(usr)] powered all SMESs", 1)
				message_admins(SPAN_NOTICE("[key_name_admin(usr)] powered all SMESs"), 1)
				power_restore_quick()
			if("powereverything")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","PE")
				log_admin("[key_name(usr)] powered all SMESs and APCs everywhere", 1)
				message_admins(SPAN_NOTICE("[key_name_admin(usr)] powered all SMESs and APCs everywhere"), 1)
				power_restore_everything()
			if("powershipreactors")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","PR")
				log_admin("[key_name(usr)] powered all ship reactors", 1)
				message_admins(SPAN_NOTICE("[key_name_admin(usr)] powered all ship reactors"), 1)
				power_restore_ship_reactors()
			if("gethumans")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","GH")
				log_admin("[key_name(usr)] mass-teleported all humans.", 1)
				message_admins(SPAN_NOTICE("[key_name_admin(usr)] mass-teleported all humans."), 1)
				get_all_humans()
			if("getxenos")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","GX")
				log_admin("[key_name(usr)] mass-teleported all Xenos.", 1)
				message_admins(SPAN_NOTICE("[key_name_admin(usr)] mass-teleported all Xenos."), 1)
				get_all_xenos()
			if("getall")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","GA")
				log_admin("[key_name(usr)] mass-teleported everyone.", 1)
				message_admins(SPAN_NOTICE("[key_name_admin(usr)] mass-teleported everyone."), 1)
				get_all()
			if("rejuvall")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","RA")
				log_admin("[key_name(usr)] mass-rejuvenated everyone.", 1)
				message_admins(SPAN_NOTICE("[key_name_admin(usr)] mass-rejuvenated everyone."), 1)
				rejuv_all()
			if("decrease_defcon")
				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","DD")
				log_admin("[key_name(usr)] decreased DEFCON level.", 1)
				message_admins(SPAN_NOTICE("[key_name_admin(usr)] decreased DEFCON level."), 1)
				defcon_controller.decrease_defcon_level()
			if("give_defcon_points")
				var/amount = input(usr, "How many points to add?") as num
				if(amount != 0) //can add negative numbers too!
					feedback_inc("admin_secrets_fun_used",1)
					feedback_add_details("admin_secrets_fun_used","GDP")
					log_admin("[key_name(usr)] added [amount] DEFCON points.", 1)
					message_admins(SPAN_NOTICE("[key_name_admin(usr)] added [amount] DEFCON points."), 1)
					objectives_controller.add_admin_points(amount)
		if(usr)
			log_admin("[key_name(usr)] used secret [href_list["secretsfun"]]")

	else if(href_list["secretsadmin"])
		if(!check_rights(R_ADMIN))	return

		switch(href_list["secretsadmin"])
			if("clear_bombs")
				//I do nothing
			if("list_bombers")
				var/dat = "<B>Bombing List<HR>"
				for(var/l in bombers)
					dat += text("[l]<BR>")
				usr << browse(dat, "window=bombers")
			if("list_signalers")
				var/dat = "<B>Showing last [length(lastsignalers)] signalers.</B><HR>"
				for(var/sig in lastsignalers)
					dat += "[sig]<BR>"
				usr << browse(dat, "window=lastsignalers;size=800x500")
			if("list_lawchanges")
				var/dat = "<B>Showing last [length(lawchanges)] law changes.</B><HR>"
				for(var/sig in lawchanges)
					dat += "[sig]<BR>"
				usr << browse(dat, "window=lawchanges;size=800x500")
			if("showgm")
				if(!ticker)
					alert("The game hasn't started yet!")
				else if (ticker.mode)
					alert("The game mode is: [ticker.mode.name]")
				else alert("For some reason there's a ticker, but not a game mode")
			if("manifest")
				var/dat = "<B>Showing Crew Manifest.</B><HR>"
				dat += "<table cellspacing=5><tr><th>Name</th><th>Position</th><th>Paygrade</th></tr>"
				for(var/mob/living/carbon/human/H in mob_list)
					if(H.ckey)
						dat += text("<tr><td>[]</td><td>[]</td><td>[]</td></tr>", H.name, H.get_assignment(), H.get_paygrade(0))
				dat += "</table>"
				usr << browse(dat, "window=manifest;size=440x410")
			if("check_antagonist")
				check_antagonists()
			if("DNA")
				var/dat = "<B>Showing DNA from blood.</B><HR>"
				dat += "<table cellspacing=5><tr><th>Name</th><th>DNA</th><th>Blood Type</th></tr>"
				for(var/mob/living/carbon/human/H in mob_list)
					if(H.ckey)
						dat += "<tr><td>[H]</td><td>[H.dna_sequence]</td><td>[H.b_type]</td></tr>"
				dat += "</table>"
				usr << browse(dat, "window=DNA;size=440x410")
			if("fingerprints")
				var/dat = "<B>Showing Fingerprints.</B><HR>"
				dat += "<table cellspacing=5><tr><th>Name</th><th>Fingerprints</th></tr>"
				for(var/mob/living/carbon/human/H in mob_list)
					if(H.ckey)
						dat += "<tr><td>[H]</td><td>[H.fingerprint]</td></tr>"
				dat += "</table>"
				usr << browse(dat, "window=fingerprints;size=440x410")
			if("launchshuttle")
				if(!shuttle_controller) return // Something is very wrong, the shuttle controller has not been created.

				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","ShL")

				var/list/valid_shuttles = list()
				for (var/shuttle_tag in shuttle_controller.shuttles)
					if (istype(shuttle_controller.shuttles[shuttle_tag], /datum/shuttle/ferry))
						valid_shuttles += shuttle_tag

				var/shuttle_tag = input("Which shuttle do you want to launch?") as null|anything in valid_shuttles

				if (!shuttle_tag)
					return

				var/datum/shuttle/ferry/S = shuttle_controller.shuttles[shuttle_tag]
				if (S.can_launch())
					S.launch(usr)
					message_admins(SPAN_NOTICE("[key_name_admin(usr)] launched the [shuttle_tag] shuttle"), 1)
					log_admin("[key_name(usr)] launched the [shuttle_tag] shuttle")
				else
					alert("The [shuttle_tag] shuttle cannot be launched at this time. It's probably busy.")

			if("moveshuttle")

				if(!shuttle_controller) return // Something is very wrong, the shuttle controller has not been created.

				feedback_inc("admin_secrets_fun_used",1)
				feedback_add_details("admin_secrets_fun_used","ShM")

				var/confirm = alert("This command directly moves a shuttle from one area to another. DO NOT USE THIS UNLESS YOU ARE DEBUGGING A SHUTTLE AND YOU KNOW WHAT YOU ARE DOING.", "Are you sure?", "Ok", "Cancel")
				if (confirm == "Cancel")
					return

				var/shuttle_tag = input("Which shuttle do you want to jump?") as null|anything in shuttle_controller.shuttles
				if (!shuttle_tag) return

				var/datum/shuttle/S = shuttle_controller.shuttles[shuttle_tag]

				var/origin_area = input("Which area is the shuttle at now? (MAKE SURE THIS IS CORRECT OR THINGS WILL BREAK)") as null|area in all_areas
				if (!origin_area) return

				var/destination_area = input("Which area do you want to move the shuttle to? (MAKE SURE THIS IS CORRECT OR THINGS WILL BREAK)") as null|area in all_areas
				if (!destination_area) return

				S.move(origin_area, destination_area)
				message_admins(SPAN_NOTICE("[key_name_admin(usr)] moved the [shuttle_tag] shuttle"), 1)
				log_admin("[key_name(usr)] moved the [shuttle_tag] shuttle")

		if (usr)
			log_admin("[key_name(usr)] used secret [href_list["secretsadmin"]]")

	else if(href_list["secretscoder"])
		if(!check_rights(R_DEBUG))	return

		switch(href_list["secretscoder"])
			if("spawn_objects")
				var/dat = "<B>Admin Log<HR></B>"
				for(var/l in admin_log)
					dat += "<li>[l]</li>"
				if(!admin_log.len)
					dat += "No one has done anything this round."
				usr << browse(dat, "window=admin_log")

	else if(href_list["populate_inactive_customitems"])
		if(check_rights(R_ADMIN|R_SERVER))
			populate_inactive_customitems_list(src.owner)

	// player info stuff

	if(href_list["add_player_info"])
		var/key = href_list["add_player_info"]
		var/add = input("Add Player Info") as null|message
		if(!add) return

		notes_add(key,add,usr)
		player_notes_show(key)

	if(href_list["remove_player_info"])
		var/key = href_list["remove_player_info"]
		var/index = text2num(href_list["remove_index"])

		notes_del(key, index)
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
			if("list")
				PlayerNotesPage(text2num(href_list["index"]))
		return

	if(href_list["player_notes_copy"])
		var/key = href_list["player_notes_copy"]
		player_notes_copy(key)
		return

	if(href_list["mark"])
		var/mob/ref_person = locate(href_list["mark"])
		if(!istype(ref_person))
			to_chat(usr, SPAN_NOTICE(" Looks like that person stopped existing!"))
			return
		if(ref_person && ref_person.adminhelp_marked)
			to_chat(usr, "<b>This Adminhelp is already being handled.</b>")
			usr << sound('sound/effects/adminhelp-error.ogg')
			return

		message_staff("[usr.key] has used 'Mark' on the Adminhelp from [key_name_admin(ref_person)] and is preparing to respond...", 1)
		log_admin("[usr.key] has used 'Mark' on the Adminhelp from [key_name_admin(ref_person)].", 1)
		STUI.staff.Add("\[[time_stamp()]][usr.key] has used 'Mark' on the Adminhelp from [key_name_admin(ref_person)].<br>")
		STUI.processing |= 3
		var/msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[usr.key]</font> has marked your request and is preparing to respond...</b>")

		ref_person << msgplayer //send a message to the player when the Admin clicks "Mark"

		unansweredAhelps.Remove(ref_person.computer_id) //It has been answered so take it off of the unanswered list
		src.viewUnheardAhelps() //This SHOULD refresh the page

		ref_person.adminhelp_marked = 1 //Timer to prevent multiple clicks
		ref_person.adminhelp_marked_admin = usr.key //To prevent others autoresponding
		spawn(1000) //This should be <= the Adminhelp cooldown in adminhelp.dm
			if(ref_person)	ref_person.adminhelp_marked = 0

	if(href_list["noresponse"])
		var/mob/ref_person = locate(href_list["noresponse"])
		if(!istype(ref_person))
			to_chat(usr, SPAN_NOTICE(" Looks like that person stopped existing!"))
			return
		if(ref_person && ref_person.adminhelp_marked && ref_person.adminhelp_marked_admin != usr.key)
			to_chat(usr, "<b>This Adminhelp is already being handled.</b>")
			usr << sound('sound/effects/adminhelp-error.ogg')
			return

		message_staff("[usr.key] has used 'No Response' on the Adminhelp from [key_name_admin(ref_person)]. The player has been notified that their issue 'is being handled, it's fixed, or it's nonsensical'.", 1)
		log_admin("[usr.key] has used 'No Response' on the Adminhelp from [key_name_admin(ref_person)].", 1)
		STUI.staff.Add("\[[time_stamp()]][usr.key] has used 'No Response' on the Adminhelp from [key_name_admin(ref_person)].<br>")
		STUI.processing |= 3
		var/msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[usr.key]</font> has received your Adminhelp and marked it as 'No response necessary'. Either your Adminhelp is being handled, it's fixed, or it's nonsensical.</font></b>")

		ref_person << msgplayer //send a message to the player when the Admin clicks "Mark"
		ref_person << sound('sound/effects/adminhelp-error.ogg')

		unansweredAhelps.Remove(ref_person.computer_id) //It has been answered so take it off of the unanswered list
		src.viewUnheardAhelps() //This SHOULD refresh the page

		ref_person.adminhelp_marked = 1 //Timer to prevent multiple clicks
		spawn(1000) //This should be <= the Adminhelp cooldown in adminhelp.dm
			if(ref_person)	ref_person.adminhelp_marked = 0

	if(href_list["warning"])
		var/mob/ref_person = locate(href_list["warning"])
		if(!istype(ref_person))
			to_chat(usr, SPAN_NOTICE(" Looks like that person stopped existing!"))
			return
		if(ref_person && ref_person.adminhelp_marked && ref_person.adminhelp_marked_admin != usr.key)
			to_chat(usr, "<b>This Adminhelp is already being handled.</b>")
			usr << sound('sound/effects/adminhelp-error.ogg')
			return

		message_staff("[usr.key] has used 'Warn' on the Adminhelp from [key_name_admin(ref_person)]. The player has been warned for abusing the Adminhelp system.", 1)
		log_admin("[usr.key] has used 'Warn' on the Adminhelp from [key_name_admin(ref_person)].", 1)
		STUI.staff.Add("\[[time_stamp()]][usr.key] has used 'Warn' on the Adminhelp from [key_name_admin(ref_person)].<br>")
		STUI.processing |= 3
		var/msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[usr.key]</font> has given you a <font color=red>warning</font>. Adminhelps are for serious inquiries only. Please do not abuse this system.</b>")

		ref_person << msgplayer //send a message to the player when the Admin clicks "Mark"
		ref_person << sound('sound/effects/adminhelp-error.ogg')

		unansweredAhelps.Remove(ref_person.computer_id) //It has been answered so take it off of the unanswered list
		src.viewUnheardAhelps() //This SHOULD refresh the page

		ref_person.adminhelp_marked = 1 //Timer to prevent multiple clicks
		spawn(1000) //This should be <= the Adminhelp cooldown in adminhelp.dm
			if(ref_person)	ref_person.adminhelp_marked = 0

	if(href_list["autoresponse"]) // new verb on the Ahelp.  Will tell the person their message was received, and they probably won't get a response
		var/mob/ref_person = locate(href_list["autoresponse"])
		if(!istype(ref_person))
			to_chat(usr, SPAN_NOTICE(" Looks like that person stopped existing!"))
			return
		if(ref_person && ref_person.adminhelp_marked && ref_person.adminhelp_marked_admin != usr.key)
			to_chat(usr, "<b>This Adminhelp is already being handled by another staff member. You can proceed but it's not recommended.</b>")
			usr << sound('sound/effects/adminhelp-error.ogg')
			if(alert(usr, "Are you sure you want to autoreply to this ahelp that is handled by another staff member?", "Confirmation", "Yes", "No") != "Yes")
				return

		if(ref_person && !ref_person.adminhelp_marked)
			to_chat(usr, "<b>This Adminhelp is not marked. You should mark ahelp first before autoresponding.</b>")
			return

		var/choice = input("Which autoresponse option do you want to send to the player?\n\n L - A webpage link.\n A - An answer to a common question.", "Autoresponse", "--CANCEL--") in list ("--CANCEL--", "IC Issue", "Being Handled", "Fixed", "Thanks", "Marine Law","Whitelist Player", "L: Xeno Quickstart Guide", "L: Marine quickstart guide", "L: Current Map", "A: No plasma regen", "A: Devour as Xeno", "J: Job bans", "E: Event in progress", "R: Radios", "B: Binoculars", "D: Joining disabled", "M: Macros", "C: Changelog")

		var/msgplayer
		switch(choice)
			if("IC Issue")
				msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. This issue has been deemed an IC (In-Character) issue, and will not be handled by staff. In case it's relevant, you may wish to ask your <a href='http://cm-ss13.com/wiki/Rank'>Chain Of Command</a> about your issue if you believe <a href='http://cm-ss13.com/wiki/Marine_Law'>Marine Law</a> has been broken.</b>")
			if("Being Handled")
				msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. The issue is already being dealt with.</b>")
			if("Fixed")
				msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. The issue is already fixed.</b>")
			if("Thanks")
				msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>! Have a CM day!</b>")
			if("Marine Law")
				msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. This is a <a href='http://cm-ss13.com/wiki/Marine_Law'>marine law issue</a>. <a href='https://cm-ss13.com/viewforum.php?f=63'>Unless the MP's are breaking procedure in a significant way</a> we will not influence ic events. You do have the right to appeal your sentence and should try to appeal to the Captain first. </b>")
			if("L: Xeno Quickstart Guide")
				msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. Your answer can be found on the Xeno Quickstart Guide on our wiki. <a href='http://cm-ss13.com/wiki/Xeno_Quickstart_Guide'>Check it out here.</a></b>")
			if("L: Marine quickstart guide")
				msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. Your answer can be found on the Marine Quickstart Guide on our wiki. <a href='http://cm-ss13.com/wiki/Marine_Quickstart_Guide'>Check it out here.</a></b>")
			if("L: Current Map")
				msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. If you need a map to the current game, you can (usually) find them on the front page of our wiki in the 'Maps' section. <a href='http://cm-ss13.com/wiki/Main_Page'>Check it out here.</a> If the map is not listed, it's a new or rare map and the overview hasn't been finished yet.</b>")
			if("A: No plasma regen")
				msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. If you have low/no plasma regen, it's most likely because you are off weeds or are currently using a passive ability, such as the Runner's 'Hide' or emitting a pheromone.</b>")
			if("A: Devour as Xeno")
				msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. Devouring is useful to quickly transport incapacitated hosts from one place to another. In order to devour a host as a Xeno, grab the mob (CTRL+Click) and then click on yourself to begin devouring. The host can resist by breaking out of your belly, so make sure your target is incapacitated, or only have them devoured for a short time. To release your target, click 'Regurgitate' on the HUD to throw them back up.</b>")
			if("J: Job bans")
				msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. All job bans, including xeno bans, are permenant until appealed. you can appeal it over on the forums at http://cm-ss13.com/viewforum.php?f=76</b>")
			if("E: Event in progress")
				msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. There is currently a special event running and many things may be changed or different, however normal rules still apply unless you have been specifically instructed otherwise by a staff member.</b>")
			if("R: Radios")
				msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. Radios have been changed, the prefix for all squad marines is now ; to access your squad radio. Squad Medics have access to the medical channel using :m, Engineers have :e and the (acting) Squad Leader has :v for command.  Examine your radio headset to get a listing of the channels you have access to.</b>")
			if("B: Binoculars")
				msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. To use your binoculars, take them into your hand and activate them by using Z (Hotkey Mode). Ctrl + Click on any open tile to set a laser. To switch between the lasers, Right Click the Binoculars in hand and press toggle mode or Alt + Click them. The Red laser is a CAS marker for pilots to fire upon, it must be held for the Pilot to drop ordinance on it. The green laser is a coordinate marker that will give you a longitude and a latitude to give to your Staff Officer and Requisitions Staff. They will give you access to a devastating Orbital Bombardment or to drop supplies for you and your squad. Your squad engineers can also use the coordinates to drop mortar shells on top of your enemies.</b>")
			if("D: Joining disabled")
				msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. A staff member has disabled joining for new players as the current round is coming to an end, you can observe while it ends and wait for a new round to start.</b>")
			if("M: Macros")
				msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. To set a macro right click the title bar, select Client->Macros. Binding unique-action to a key is useful for pumping shotguns etc; Binding load-from-attachment will activate any scopes etc; Binding resist and give to seperate keys is also handy. For more information on macros, head over to our guide, at: http://cm-ss13.com/wiki/Macros</b>")
			if("C: Changelog")
				msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[key_name_admin(usr, 0)]</font> is autoresponding with <font color='#009900'>'[choice]'</font>. The answer to your question can be found in the changelog. Click the changelog button at the top-right of the screen to view it in-game, or visit https://cm-ss13.com/changelog/ to open it in your browser instead.</b>")
			else return
		msgplayer += " <b><i>You may click on the staff member's name to ask more about this response.</i></b>"
		message_staff("[usr.key] is autoresponding to [ref_person] with <font color='#009900'>'[choice]'</font>. They have been shown the following:\n[msgplayer]", 1)
		log_admin("[usr.key] is autoresponding to [ref_person] with <font color='#009900'>'[choice]'</font>.", 1) //No need to log the text we send them.
		STUI.staff.Add("\[[time_stamp()]][usr.key] is autoresponding to [ref_person] with [choice].<br>")
		STUI.processing |= 3
		ref_person << msgplayer //send a message to the player when the Admin clicks "Mark"
		ref_person << sound('sound/effects/adminhelp-reply.ogg')

		unansweredAhelps.Remove(ref_person.computer_id) //It has been answered so take it off of the unanswered list
		src.viewUnheardAhelps() //This SHOULD refresh the page

		ref_person.adminhelp_marked = 1 //Timer to prevent multiple clicks
		spawn(1000) //This should be <= the Adminhelp cooldown in adminhelp.dm
			if(ref_person)	ref_person.adminhelp_marked = 0

	// Saving this for future lels -Rahl
	// if(href_list["retarded"]) // Their message is fucking stupid
	// 	var/mob/ref_person = locate(href_list["retarded"])
	// 	if(!istype(ref_person))
	// 		to_chat(usr, SPAN_NOTICE(" Looks like that person stopped existing!"))
	// 		return
	// 	var/msg = SPAN_NOTICE("<b>NOTICE: <font color=red>[usr.key]</font> has marked the Adminhelp from <font color=red>[ref_person.ckey]/([ref_person])</font> as 'Completely fucking retarded' - this Ahelp was written by someone whom, if they were any less intelligent, would need to be watered twice a day. The player has been nicely notified of this as 'No response necessary'.</b>")
	// 	var/msgplayer = SPAN_NOTICE("<b>NOTICE: <font color=red>[usr.key]</font> has received your Adminhelp and marked it as 'No response necessary'. Either your issue is being handled or it's fixed.</font></b>")
	//
	// 	//send this msg to all admins
	// 	for(var/client/X in admins)
	// 		if((R_ADMIN|R_MOD|R_MENTOR) & X.admin_holder.rights)
	// 			X << msg
	//
	// 	ref_person << msgplayer //send a message to the player


	if(href_list["ccmark"]) // CentComm-mark. We want to let all Admins know that something is "Marked", but not let the player know because it's not very RP-friendly.
		var/mob/ref_person = locate(href_list["ccmark"])
		var/msg = SPAN_NOTICE("<b>NOTICE: <font color=red>[usr.key]</font> is responding to <font color=red>[ref_person.ckey]/([ref_person])</font>.</b>")

		//send this msg to all admins
		for(var/client/X in admins)
			if((R_ADMIN|R_MOD) & X.admin_holder.rights)
				X << msg

		//unanswered_distress -= ref_person

	if(href_list["ccdeny"]) // CentComm-deny. The distress call is denied, without any further conditions
		var/mob/ref_person = locate(href_list["ccdeny"])
		command_announcement.Announce("The distress signal has not received a response, the launch tubes are now recalibrating.", "Distress Beacon")
		log_game("[key_name_admin(usr)] has denied a distress beacon, requested by [key_name_admin(ref_person)]")
		message_mods("[key_name_admin(usr)] has denied a distress beacon, requested by [key_name_admin(ref_person)]", 1)

		//unanswered_distress -= ref_person

	if(href_list["distresscancel"])
		if(distress_cancel)
			to_chat(usr, "The distress beacon was already canceled.")
			return
		if(ticker.mode.waiting_for_candidates)
			to_chat(usr, "Too late! The distress beacon was launched.")
			return
		log_game("[key_name_admin(usr)] has canceled the distress beacon.")
		message_staff("[key_name_admin(usr)] has canceled the distress beacon.")
		distress_cancel = 1
		return

	if(href_list["distress"]) //Distress Beacon, sends a random distress beacon when pressed
		distress_cancel = 0
		message_staff("[key_name_admin(usr)] has opted to SEND the distress beacon! Launching in 10 seconds... (<A HREF='?_src_=admin_holder;distresscancel=\ref[usr]'>CANCEL</A>)")
		spawn(100)
			if(distress_cancel) return
			var/mob/ref_person = locate(href_list["distress"])
			ticker.mode.activate_distress()
			log_game("[key_name_admin(usr)] has sent a randomized distress beacon, requested by [key_name_admin(ref_person)]")
			message_admins("[key_name_admin(usr)] has sent a randomized distress beacon, requested by [key_name_admin(ref_person)]", 1)
		//unanswered_distress -= ref_person

	if(href_list["destroyship"]) //Distress Beacon, sends a random distress beacon when pressed
		destroy_cancel = 0
		message_staff("[key_name_admin(usr)] has opted to GRANT the self destruct! Starting in 10 seconds... (<A HREF='?_src_=admin_holder;sdcancel=\ref[usr]'>CANCEL</A>)")
		spawn(100)
			if(distress_cancel) return
			var/mob/ref_person = locate(href_list["destroy"])
			set_security_level(SEC_LEVEL_DELTA)
			log_game("[key_name_admin(usr)] has granted self destruct, requested by [key_name_admin(ref_person)]")
			message_admins("[key_name_admin(usr)] has granted self destruct, requested by [key_name_admin(ref_person)]", 1)

	if(href_list["sddeny"]) // CentComm-deny. The self destruct is denied, without any further conditions
		var/mob/ref_person = locate(href_list["sddeny"])
		command_announcement.Announce("The self destruct request has not received a response, ARES is now recalculating statistics.", "Self Destruct System")
		log_game("[key_name_admin(usr)] has denied self destruct, requested by [key_name_admin(ref_person)]")
		message_mods("[key_name_admin(usr)] has denied self destruct, requested by [key_name_admin(ref_person)]", 1)

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