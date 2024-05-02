/datum/admins/proc/CheckAdminHref(href, href_list)
	var/auth = href_list["admin_token"]
	. = auth && (auth == href_token || auth == GLOB.href_token)
	if(.)
		return
	var/msg = !auth ? "no" : "a bad"
	message_admins("[key_name_admin(usr)] clicked an href with [msg] authorization key!")
	if(CONFIG_GET(flag/debug_admin_hrefs))
		message_admins("Debug mode enabled, call not blocked. Please ask your coders to review this round's logs.")
		log_world("UAH: [href]")
		return TRUE
	log_admin_private("[key_name(usr)] clicked an href with [msg] authorization key! [href]")

/datum/admins/Topic(href, href_list)
	..()

	if(usr.client != src.owner || !check_rights(0))
		message_admins("[usr.key] has attempted to override the admin panel!")
		return

	if(!CheckAdminHref(href, href_list))
		return


	if(href_list["ahelp"])
		if(!check_rights(R_ADMIN|R_MOD, TRUE))
			return

		var/ahelp_ref = href_list["ahelp"]
		var/datum/admin_help/AH = locate(ahelp_ref)
		if(AH)
			AH.Action(href_list["ahelp_action"])
		else
			to_chat(usr, "Ticket [ahelp_ref] has been deleted!", confidential = TRUE)
		return

	if(href_list["adminplayeropts"])
		var/mob/M = locate(href_list["adminplayeropts"])
		show_player_panel(M)
		return

	if(href_list["editrights"])
		if(!check_rights(R_PERMISSIONS))
			message_admins("[key_name_admin(usr)] attempted to edit the admin permissions without sufficient rights.")
			return

		var/adm_ckey

		var/task = href_list["editrights"]
		if(task == "add")
			var/new_ckey = ckey(input(usr,"New admin's ckey","Admin ckey", null) as text|null)
			if(!new_ckey) return
			if(new_ckey in GLOB.admin_datums)
				to_chat(usr, "<font color='red'>Error: Topic 'editrights': [new_ckey] is already an admin</font>")
				return
			adm_ckey = new_ckey
			task = "rank"
		else if(task != "show")
			adm_ckey = ckey(href_list["ckey"])
			if(!adm_ckey)
				to_chat(usr, "<font color='red'>Error: Topic 'editrights': No valid ckey</font>")
				return

		var/datum/admins/D = GLOB.admin_datums[adm_ckey]

		if(task == "remove")
			if(alert("Are you sure you want to remove [adm_ckey]?","Message","Yes","Cancel") == "Yes")
				if(!D) return
				GLOB.admin_datums -= adm_ckey
				D.disassociate()

				message_admins("[key_name_admin(usr)] removed [adm_ckey] from the admins list")

		else if(task == "rank")
			var/new_rank
			if(GLOB.admin_ranks.len)
				new_rank = tgui_input_list(usr, "Please select a rank", "New rank", (GLOB.admin_ranks|"*New Rank*"))
			else
				new_rank = tgui_input_list(usr, "Please select a rank", "New rank", list("Game Master","Game Admin", "Trial Admin", "Admin Observer","*New Rank*"))

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
						if(GLOB.admin_ranks.len)
							if(new_rank in GLOB.admin_ranks)
								rights = GLOB.admin_ranks[new_rank] //we typed a rank which already exists, use its rights
							else
								GLOB.admin_ranks[new_rank] = 0 //add the new rank to admin_ranks
				else
					if(CONFIG_GET(flag/admin_legacy_system))
						new_rank = ckeyEx(new_rank)
						rights = GLOB.admin_ranks[new_rank] //we input an existing rank, use its rights

			if(D)
				D.disassociate() //remove adminverbs and unlink from client
				D.rank = new_rank //update the rank
				D.rights = rights //update the rights based on admin_ranks (default: 0)
			else
				D = new /datum/admins(new_rank, rights, adm_ckey)

			var/client/C = GLOB.directory[adm_ckey] //find the client with the specified ckey (if they are logged in)
			D.associate(C) //link up with the client and add verbs

			message_admins("[key_name_admin(usr)] edited the admin rank of [adm_ckey] to [new_rank]")

		else if(task == "permissions")
			if(!D) return
			var/list/permissionlist = list()
			for(var/i=1, i<=R_HOST, i<<=1) //that <<= is shorthand for i = i << 1. Which is a left bitshift
				permissionlist[rights2text(i)] = i
			var/new_permission = tgui_input_list(usr, "Select a permission to turn on/off", "Permission toggle", permissionlist)
			if(!new_permission) return
			D.rights ^= permissionlist[new_permission]

			message_admins("[key_name_admin(usr)] toggled the [new_permission] permission of [adm_ckey]")

//======================================================
//Everything that has to do with evac and self-destruct.
//The rest of this is awful.
//======================================================
	if(href_list["evac_authority"])
		switch(href_list["evac_authority"])
			if("init_evac")
				if(!SShijack.initiate_evacuation())
					to_chat(usr, SPAN_WARNING("You are unable to initiate an evacuation right now!"))
				else
					message_admins("[key_name_admin(usr)] called an evacuation.")

			if("cancel_evac")
				if(!SShijack.cancel_evacuation())
					to_chat(usr, SPAN_WARNING("You are unable to cancel an evacuation right now!"))
				else
					message_admins("[key_name_admin(usr)] canceled an evacuation.")

			if("toggle_evac")
				SShijack.evac_admin_denied = !SShijack.evac_admin_denied
				message_admins("[key_name_admin(usr)] has [SShijack.evac_admin_denied ? "forbidden" : "allowed"] ship-wide evacuation.")

//======================================================
//======================================================

	else if(href_list["delay_round_end"])
		if(!check_rights(R_SERVER)) return

		SSticker.delay_end = !SSticker.delay_end
		message_admins("[key_name(usr)] [SSticker.delay_end ? "delayed the round end" : "has made the round end normally"].")

	else if(href_list["simplemake"])

		if(!check_rights(R_SPAWN)) return

		var/mob/M = locate(href_list["mob"])
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		var/delmob = 0
		switch(alert("Delete old mob?","Message","Yes","No","Cancel"))
			if("Cancel") return
			if("Yes") delmob = 1

		message_admins("[key_name_admin(usr)] has used rudimentary transformation on [key_name_admin(M)]. Transforming to [href_list["simplemake"]]; deletemob=[delmob]")

		var/mob/transformed
		var/hivenumber = XENO_HIVE_NORMAL

		if(isxeno(M))
			var/mob/living/carbon/xenomorph/X = M
			hivenumber = X.hivenumber

		switch(href_list["simplemake"])
			if("observer") transformed = M.change_mob_type( /mob/dead/observer , null, null, delmob )

			if("larva") transformed = M.change_mob_type( /mob/living/carbon/xenomorph/larva , null, null, delmob )
			if("facehugger") transformed = M.change_mob_type( /mob/living/carbon/xenomorph/facehugger , null, null, delmob )
			if("defender") transformed = M.change_mob_type( /mob/living/carbon/xenomorph/defender, null, null, delmob )
			if("warrior") transformed = M.change_mob_type( /mob/living/carbon/xenomorph/warrior, null, null, delmob )
			if("runner") transformed = M.change_mob_type( /mob/living/carbon/xenomorph/runner , null, null, delmob )
			if("drone") transformed = M.change_mob_type( /mob/living/carbon/xenomorph/drone , null, null, delmob )
			if("sentinel") transformed = M.change_mob_type( /mob/living/carbon/xenomorph/sentinel , null, null, delmob )
			if("lurker") transformed = M.change_mob_type( /mob/living/carbon/xenomorph/lurker , null, null, delmob )
			if("carrier") transformed = M.change_mob_type( /mob/living/carbon/xenomorph/carrier , null, null, delmob )
			if("hivelord") transformed = M.change_mob_type( /mob/living/carbon/xenomorph/hivelord , null, null, delmob )
			if("praetorian") transformed = M.change_mob_type( /mob/living/carbon/xenomorph/praetorian , null, null, delmob )
			if("ravager") transformed = M.change_mob_type( /mob/living/carbon/xenomorph/ravager , null, null, delmob )
			if("spitter") transformed = M.change_mob_type( /mob/living/carbon/xenomorph/spitter , null, null, delmob )
			if("boiler") transformed = M.change_mob_type( /mob/living/carbon/xenomorph/boiler , null, null, delmob )
			if("burrower") transformed = M.change_mob_type( /mob/living/carbon/xenomorph/burrower , null, null, delmob )
			if("crusher") transformed = M.change_mob_type( /mob/living/carbon/xenomorph/crusher , null, null, delmob )
			if("queen") transformed = M.change_mob_type( /mob/living/carbon/xenomorph/queen , null, null, delmob )
			if("predalien") transformed = M.change_mob_type( /mob/living/carbon/xenomorph/predalien , null, null, delmob )

			if("human") transformed = M.change_mob_type( /mob/living/carbon/human , null, null, delmob, href_list["species"])
			if("monkey") transformed = M.change_mob_type( /mob/living/carbon/human/monkey , null, null, delmob )
			if("farwa") transformed = M.change_mob_type( /mob/living/carbon/human/farwa , null, null, delmob )
			if("neaera") transformed = M.change_mob_type( /mob/living/carbon/human/neaera , null, null, delmob )
			if("yiren") transformed = M.change_mob_type( /mob/living/carbon/human/yiren , null, null, delmob )
			if("robot") transformed = M.change_mob_type( /mob/living/silicon/robot , null, null, delmob )
			if("cat") transformed = M.change_mob_type( /mob/living/simple_animal/cat , null, null, delmob )
			if("runtime") transformed = M.change_mob_type( /mob/living/simple_animal/cat/Runtime , null, null, delmob )
			if("corgi") transformed = M.change_mob_type( /mob/living/simple_animal/corgi , null, null, delmob )
			if("ian") transformed = M.change_mob_type( /mob/living/simple_animal/corgi/Ian , null, null, delmob )
			if("crab") transformed = M.change_mob_type( /mob/living/simple_animal/crab , null, null, delmob )
			if("coffee") transformed = M.change_mob_type( /mob/living/simple_animal/crab/Coffee , null, null, delmob )
			if("parrot") transformed = M.change_mob_type( /mob/living/simple_animal/parrot , null, null, delmob )
			if("polyparrot") transformed = M.change_mob_type( /mob/living/simple_animal/parrot/Poly , null, null, delmob )

		if(isxeno(transformed) && hivenumber)
			var/mob/living/carbon/xenomorph/X = transformed
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

	else if(href_list["unban_perma"])
		var/datum/entity/player/unban_player = get_player_from_key(href_list["unban_perma"])
		if(!(tgui_alert(owner, "Do you want to unban [unban_player.ckey]? They are currently permabanned for: [unban_player.permaban_reason], since [unban_player.permaban_date].", "Unban Player", list("Yes", "No")) == "Yes"))
			return

		if(!unban_player.is_permabanned)
			to_chat(owner, "The player is not currently permabanned.")

		unban_player.is_permabanned = FALSE
		unban_player.permaban_admin_id = null
		unban_player.permaban_date = null
		unban_player.permaban_reason = null

		unban_player.save()

		message_admins("[key_name_admin(owner)] has removed the permanent ban on [unban_player.ckey].")
		important_message_external("[owner] has removed the permanent ban on [unban_player.ckey].", "Permaban Removed")

	else if(href_list["sticky"])
		if(href_list["view_all_ckeys"])
			var/list/datum/view_record/stickyban_matched_ckey/all_ckeys = DB_VIEW(/datum/view_record/stickyban_matched_ckey,
				DB_COMP("linked_stickyban", DB_EQUALS, href_list["sticky"])
			)

			var/list/keys = list()
			var/list/whitelisted = list()
			for(var/datum/view_record/stickyban_matched_ckey/match as anything in all_ckeys)
				if(match.whitelisted)
					whitelisted += match.ckey
				else
					keys += match.ckey

			show_browser(owner, "Impacted: [english_list(keys)]<br><br>Whitelisted: [english_list(whitelisted)]", "Stickyban Keys", "stickykeys")
			return

		if(href_list["view_all_cids"])
			var/list/datum/view_record/stickyban_matched_cid/all_cids = DB_VIEW(/datum/view_record/stickyban_matched_cid,
				DB_COMP("linked_stickyban", DB_EQUALS, href_list["sticky"])
			)

			var/list/cids = list()
			for(var/datum/view_record/stickyban_matched_cid/match as anything in all_cids)
				cids += match.cid

			show_browser(owner, english_list(cids), "Stickyban CIDs", "stickycids")
			return

		if(href_list["view_all_ips"])
			var/list/datum/view_record/stickyban_matched_ip/all_ips = DB_VIEW(/datum/view_record/stickyban_matched_ip,
				DB_COMP("linked_stickyban", DB_EQUALS, href_list["sticky"])
			)

			var/list/ips = list()
			for(var/datum/view_record/stickyban_matched_ip/match as anything in all_ips)
				ips += match.ip

			show_browser(owner, english_list(ips), "Stickyban IPs", "stickycips")
			return

		if(href_list["find_sticky"])
			var/ckey = ckey(tgui_input_text(owner, "Which CKEY should we attempt to find stickybans for?", "FindABan"))
			if(!ckey)
				return

			var/list/datum/view_record/stickyban/stickies = SSstickyban.check_for_sticky_ban(ckey)
			if(!stickies)
				to_chat(owner, SPAN_ADMIN("Could not locate any stickbans impacting [ckey]."))
				return

			var/list/impacting_stickies = list()

			for(var/datum/view_record/stickyban/sticky as anything in stickies)
				impacting_stickies += sticky.identifier

			to_chat(owner, SPAN_ADMIN("Found the following stickybans for [ckey]: [english_list(impacting_stickies)]"))

		if(!check_rights_for(owner, R_BAN))
			return

		if(href_list["new_sticky"])
			owner.cmd_admin_do_stickyban()
			return

		var/datum/entity/stickyban/sticky = DB_ENTITY(/datum/entity/stickyban, href_list["sticky"])
		if(!sticky)
			return

		sticky.sync()

		if(href_list["whitelist_ckey"])
			var/ckey_to_whitelist = ckey(tgui_input_text(owner, "What CKEY should be whitelisted? Editing stickyban: [sticky.identifier]"))
			if(!ckey_to_whitelist)
				return

			SSstickyban.whitelist_ckey(sticky.id, ckey_to_whitelist)
			message_admins("[key_name_admin(owner)] has whitelisted [ckey_to_whitelist] against stickyban '[sticky.identifier]'.")
			important_message_external("[owner] has whitelisted [ckey_to_whitelist] against stickyban '[sticky.identifier]'.", "CKEY Whitelisted")

		if(href_list["add"])
			var/option = tgui_input_list(owner, "What do you want to add?", "AddABan", list("CID", "CKEY", "IP"))
			if(!option)
				return

			var/to_add = tgui_input_text(owner, "Provide the [option] to add to the stickyban.", "AddABan")
			if(!to_add)
				return

			switch(option)
				if("CID")
					SSstickyban.add_matched_cid(sticky.id, to_add)
				if("CKEY")
					SSstickyban.add_matched_ckey(sticky.id, to_add)
				if("IP")
					SSstickyban.add_matched_ip(sticky.id, to_add)

			message_admins("[key_name_admin(owner)] has added a [option] ([to_add]) to stickyban '[sticky.identifier]'.")
			important_message_external("[owner] has added a [option] ([to_add]) to stickyban '[sticky.identifier]'.", "[option] Added to Stickyban")

		if(href_list["remove"])
			var/option = tgui_input_list(owner, "What do you want to remove?", "DelABan", list("Entire Stickyban", "CID", "CKEY", "IP"))
			switch(option)
				if("Entire Stickyban")
					if(!(tgui_alert(owner, "Are you sure you want to remove this stickyban? Identifier: [sticky.identifier] Reason: [sticky.reason]", "Confirm", list("Yes", "No")) == "Yes"))
						return

					sticky.active = FALSE
					sticky.save()

					message_admins("[key_name_admin(owner)] has deactivated stickyban '[sticky.identifier]'.")
					important_message_external("[owner] has deactivated stickyban '[sticky.identifier]'.", "Stickyban Deactivated")

				if("CID")
					var/list/datum/view_record/stickyban_matched_cid/all_cids = DB_VIEW(/datum/view_record/stickyban_matched_cid,
						DB_COMP("linked_stickyban", DB_EQUALS, sticky.id)
					)

					var/list/cid_to_record_id = list()
					for(var/datum/view_record/stickyban_matched_cid/match in all_cids)
						cid_to_record_id["[match.cid]"] = match.id

					var/picked = tgui_input_list(owner, "Which CID to remove?", "DelABan", cid_to_record_id)
					if(!picked)
						return

					var/selected = cid_to_record_id[picked]

					var/datum/entity/stickyban_matched_cid/sticky_cid = DB_ENTITY(/datum/entity/stickyban_matched_cid, selected)
					sticky_cid.delete()

					message_admins("[key_name_admin(owner)] has removed a CID ([picked]) from stickyban '[sticky.identifier]'.")
					important_message_external("[owner] has removed a CID ([picked]) from stickyban '[sticky.identifier]'.", "CID Removed from Stickyban")

				if("CKEY")
					var/list/datum/view_record/stickyban_matched_ckey/all_ckeys = DB_VIEW(/datum/view_record/stickyban_matched_ckey,
						DB_COMP("linked_stickyban", DB_EQUALS, sticky.id)
					)

					var/list/ckey_to_record_id = list()
					for(var/datum/view_record/stickyban_matched_ckey/match in all_ckeys)
						ckey_to_record_id["[match.ckey]"] = match.id

					var/picked = tgui_input_list(owner, "Which CKEY to remove?", "DelABan", ckey_to_record_id)
					if(!picked)
						return

					var/selected = ckey_to_record_id[picked]

					var/datum/entity/stickyban_matched_ckey/sticky_ckey = DB_ENTITY(/datum/entity/stickyban_matched_ckey, selected)
					sticky_ckey.delete()

					message_admins("[key_name_admin(owner)] has removed a CKEY ([picked]) from stickyban '[sticky.identifier]'.")
					important_message_external("[owner] has removed a CKEY ([picked]) from stickyban '[sticky.identifier]'.", "CKEY Removed from Stickyban")

				if("IP")
					var/list/datum/view_record/stickyban_matched_ip/all_ips = DB_VIEW(/datum/view_record/stickyban_matched_ip,
						DB_COMP("linked_stickyban", DB_EQUALS, sticky.id)
					)

					var/list/ip_to_record_id = list()
					for(var/datum/view_record/stickyban_matched_ip/match in all_ips)
						ip_to_record_id["[match.ip]"] = match.id

					var/picked = tgui_input_list(owner, "Which IP to remove?", "DelABan", ip_to_record_id)
					if(!picked)
						return

					var/selected = ip_to_record_id[picked]

					var/datum/entity/stickyban_matched_ip/sticky_ip = DB_ENTITY(/datum/entity/stickyban_matched_ip, selected)
					sticky_ip.delete()

					message_admins("[key_name_admin(owner)] has removed an IP ([picked]) from stickyban [sticky.identifier].")
					important_message_external("[owner] has removed an IP ([picked]) from stickyban '[sticky.identifier].", "IP Removed from Stickyban")

	else if(href_list["warn"])
		usr.client.warn(href_list["warn"])

	else if(href_list["unbanupgradeperma"])
		if(!check_rights(R_ADMIN)) return
		UpdateTime()
		var/reason

		var/banfolder = href_list["unbanupgradeperma"]
		GLOB.Banlist.cd = "/base/[banfolder]"
		var/reason2 = GLOB.Banlist["reason"]

		var/minutes = GLOB.Banlist["minutes"]

		var/banned_key = GLOB.Banlist["key"]
		GLOB.Banlist.cd = "/base"

		var/mins = 0
		if(minutes > GLOB.CMinutes)
			mins = minutes - GLOB.CMinutes
		if(!mins) return
		mins = max(5255990,mins) // 10 years
		minutes = GLOB.CMinutes + mins
		reason = input(usr,"Reason?","reason",reason2) as message|null
		if(!reason) return

		ban_unban_log_save("[key_name(usr)] upgraded [banned_key]'s ban to a permaban. Reason: [sanitize(reason)]")
		message_admins("[key_name_admin(usr)] upgraded [banned_key]'s ban to a permaban. Reason: [sanitize(reason)]")
		GLOB.Banlist.cd = "/base/[banfolder]"
		GLOB.Banlist["reason"] << sanitize(reason)
		GLOB.Banlist["temp"] << 0
		GLOB.Banlist["minutes"] << minutes
		GLOB.Banlist["bannedby"] << usr.ckey
		GLOB.Banlist.cd = "/base"
		unbanpanel()

	else if(href_list["unbane"])
		if(!check_rights(R_BAN)) return

		UpdateTime()
		var/reason

		var/banfolder = href_list["unbane"]
		GLOB.Banlist.cd = "/base/[banfolder]"
		var/reason2 = GLOB.Banlist["reason"]
		var/temp = GLOB.Banlist["temp"]

		var/minutes = GLOB.Banlist["minutes"]

		var/banned_key = GLOB.Banlist["key"]
		GLOB.Banlist.cd = "/base"

		var/duration

		var/mins = 0
		if(minutes > GLOB.CMinutes)
			mins = minutes - GLOB.CMinutes
		mins = tgui_input_number(usr,"How long (in minutes)? \n 1440 = 1 day \n 4320 = 3 days \n 10080 = 7 days \n 43800 = 1 Month","Ban time", 1440, 262800, 1)
		if(!mins) return
		mins = min(525599,mins)
		minutes = GLOB.CMinutes + mins
		duration = GetExp(minutes)
		reason = input(usr,"Reason?","reason",reason2) as message|null
		if(!reason) return

		ban_unban_log_save("[key_name(usr)] edited [banned_key]'s ban. Reason: [sanitize(reason)] Duration: [duration]")
		message_admins("[key_name_admin(usr)] edited [banned_key]'s ban. Reason: [sanitize(reason)] Duration: [duration]")
		GLOB.Banlist.cd = "/base/[banfolder]"
		GLOB.Banlist["reason"] << sanitize(reason)
		GLOB.Banlist["temp"] << temp
		GLOB.Banlist["minutes"] << minutes
		GLOB.Banlist["bannedby"] << usr.ckey
		GLOB.Banlist.cd = "/base"
		unbanpanel()

	/////////////////////////////////////new ban stuff

	//JOBBAN'S INNARDS
	else if(href_list["jobban3"])
		if(!check_rights(R_MOD,0) && !check_rights(R_ADMIN))  return

		var/mob/M = locate(href_list["jobban4"])
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		if(M != usr) //we can jobban ourselves
			if(M.client && M.client.admin_holder && (M.client.admin_holder.rights & R_BAN)) //they can ban too. So we can't ban them
				alert("You cannot perform this action. You must be of a higher administrative rank!")
				return

		if(!GLOB.RoleAuthority)
			to_chat(usr, "Role Authority has not been set up!")
			return


		var/datum/entity/player/P1 = M.client?.player_data
		if(!P1)
			P1 = get_player_from_key(M.ckey)

		//get jobs for department if specified, otherwise just returnt he one job in a list.
		var/list/joblist = list()
		switch(href_list["jobban3"])
			if("CICdept")
				joblist += get_job_titles_from_list(GLOB.ROLES_COMMAND)
			if("Supportdept")
				joblist += get_job_titles_from_list(GLOB.ROLES_AUXIL_SUPPORT)
			if("Policedept")
				joblist += get_job_titles_from_list(GLOB.ROLES_POLICE)
			if("Engineeringdept")
				joblist += get_job_titles_from_list(GLOB.ROLES_ENGINEERING)
			if("Requisitiondept")
				joblist += get_job_titles_from_list(GLOB.ROLES_REQUISITION)
			if("Medicaldept")
				joblist += get_job_titles_from_list(GLOB.ROLES_MEDICAL)
			if("Marinesdept")
				joblist += get_job_titles_from_list(GLOB.ROLES_MARINES)
			if("Miscdept")
				joblist += get_job_titles_from_list(GLOB.ROLES_MISC)
			if("Xenosdept")
				joblist += get_job_titles_from_list(GLOB.ROLES_XENO)
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
	else if(href_list["adminplayerobservefollow"])
		if(!isobserver(usr) && !check_rights(R_ADMIN))
			return

		usr.client?.admin_follow(locate(href_list["adminplayerobservefollow"]))
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
			message_admins("[key_name_admin(usr)] booted [key_name_admin(M)].")
			qdel(M.client)

	else if(href_list["removejobban"])
		if(!check_rights(R_BAN)) return

		var/t = href_list["removejobban"]
		if(t)
			if((alert("Do you want to unjobban [t]?","Unjobban confirmation", "Yes", "No") == "Yes") && t) //No more misclicks! Unless you do it twice.
				message_admins("[key_name_admin(usr)] removed [t]")
				jobban_remove(t)
				jobban_savebanfile()
				href_list["ban"] = 1 // lets it fall through and refresh

	else if(href_list["newban"])
		if(!check_rights(R_MOD,0) && !check_rights(R_BAN))  return

		var/mob/M = locate(href_list["newban"])
		if(!ismob(M)) return

		if(M.client && M.client.admin_holder && (M.client.admin_holder.rights & R_MOD))
			return //mods+ cannot be banned. Even if they could, the ban doesn't affect them anyway

		if(!M.ckey)
			to_chat(usr, SPAN_DANGER("<B>Warning: Mob ckey for [M.name] not found.</b>"))
			return
		var/mob_key = M.ckey
		var/mins = tgui_input_number(usr,"How long (in minutes)? \n 1440 = 1 day \n 4320 = 3 days \n 10080 = 7 days \n 43800 = 1 Month","Ban time", 1440, 262800, 1)
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

		if(M.client && M.client.admin_holder) return //admins cannot be banned. Even if they could, the ban doesn't affect them anyway

		if(!M.ckey)
			to_chat(usr, SPAN_DANGER("<B>Warning: Mob ckey for [M.name] not found.</b>"))
			return

		var/mins = 0
		var/reason = ""
		switch(alert("Are you sure you want to EORG ban [M.ckey]?", , "Yes", "No"))
			if("Yes")
				mins = 180
				reason = "EORG - Generating combat logs with, or otherwise griefing, friendly/allied players."
			if("No")
				return
		var/datum/entity/player/P = get_player_from_key(M.ckey) // you may not be logged in, but I will find you and I will ban you
		if(P.is_time_banned && alert(usr, "Ban already exists. Proceed?", "Confirmation", "Yes", "No") != "Yes")
			return
		P.add_timed_ban(reason, mins)

	else if(href_list["xenoresetname"])
		if(!check_rights(R_MOD,0) && !check_rights(R_BAN))
			return

		var/mob/living/carbon/xenomorph/X = locate(href_list["xenoresetname"])
		if(!isxeno(X))
			to_chat(usr, SPAN_WARNING("Not a xeno"))
			return

		if(alert("Are you sure you want to reset xeno name for [X.ckey]?", , "Yes", "No") != "Yes")
			return

		if(!X.ckey)
			to_chat(usr, SPAN_DANGER("Warning: Mob ckey for [X.name] not found."))
			return

		message_admins("[usr.client.ckey] has reset [X.ckey] xeno name")

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

		var/mob/living/carbon/xenomorph/X = locate(href_list["xenobanname"])
		var/mob/M = locate(href_list["xenobanname"])

		if(ismob(M) && X.client && X.client.xeno_name_ban)
			if(alert("Are you sure you want to UNBAN [X.ckey] and let them use xeno name?", ,"Yes", "No") != "Yes")
				return
			X.client.xeno_name_ban = FALSE
			X.client.prefs.xeno_name_ban = FALSE

			X.client.prefs.save_preferences()
			message_admins("[usr.client.ckey] has unbanned [X.ckey] from using xeno names")

			notes_add(X.ckey, "Xeno Name Unbanned by [usr.client.ckey]", usr)
			to_chat(X, SPAN_DANGER("Warning: You can use xeno names again."))
			return


		if(!isxeno(X))
			to_chat(usr, SPAN_WARNING("Not a xeno"))
			return

		if(alert("Are you sure you want to BAN [X.ckey] from ever using any xeno name?", , "Yes", "No") != "Yes")
			return

		if(!X.ckey)
			to_chat(usr, SPAN_DANGER("Warning: Mob ckey for [X.name] not found."))
			return

		message_admins("[usr.client.ckey] has banned [X.ckey] from using xeno names")

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
		if(!ismob(M)) return
		if(!M.client) return

		var/mute_type = href_list["mute_type"]
		if(istext(mute_type)) mute_type = text2num(mute_type)
		if(!isnum(mute_type)) return

		cmd_admin_mute(M, mute_type)

	else if(href_list["chem_panel"])
		topic_chems(href_list["chem_panel"])

	else if(href_list["c_mode"])
		if(!check_rights(R_ADMIN)) return

		var/dat = {"<B>What mode do you wish to play?</B><HR>"}
		for(var/mode in config.modes)
			dat += {"<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];c_mode2=[mode]'>[config.mode_names[mode]]</A><br>"}
		dat += {"Now: [GLOB.master_mode]"}
		show_browser(usr, dat, "Change Gamemode", "c_mode")

	else if(href_list["c_mode2"])
		if(!check_rights(R_ADMIN|R_SERVER)) return

		GLOB.master_mode = href_list["c_mode2"]
		message_admins("[key_name_admin(usr)] set the mode as [GLOB.master_mode].")
		to_world(SPAN_NOTICE("<b><i>The mode for the next round: [GLOB.master_mode]!</i></b>"))
		Game() // updates the main game menu
		SSticker.save_mode(GLOB.master_mode)

	else if(href_list["monkeyone"])
		if(!check_rights(R_SPAWN)) return

		var/mob/living/carbon/human/H = locate(href_list["monkeyone"])
		if(!istype(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human")
			return

		message_admins("[key_name_admin(usr)] attempting to monkeyize [key_name_admin(H)]")
		H.monkeyize()

	else if(href_list["forcespeech"])
		if(!check_rights(R_ADMIN)) return

		var/mob/M = locate(href_list["forcespeech"])
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		var/speech = input("What will [key_name(M)] say?.", "Force speech", "")// Don't need to sanitize, since it does that in say(), we also trust our admins.
		if(!speech) return
		M.say(speech)
		speech = sanitize(speech) // Nah, we don't trust them
		message_admins("[key_name_admin(usr)] forced [key_name_admin(M)] to say: [speech]")

	else if(href_list["zombieinfect"])
		if(!check_rights(R_ADMIN)) return
		var/mob/living/carbon/human/H = locate(href_list["zombieinfect"])
		if(!istype(H))
			to_chat(usr, "This can only be used on instances of type /human")
			return

		if(alert(usr, "Are you sure you want to infect them with a ZOMBIE VIRUS? This can trigger a major event!", "Message", "Yes", "No") != "Yes")
			return

		var/datum/disease/black_goo/bg = new()
		if(alert(usr, "Make them non-symptomatic carrier?", "Message", "Yes", "No") == "Yes")
			bg.carrier = TRUE
		else
			bg.carrier = FALSE

		H.AddDisease(bg, FALSE)

		message_admins("[key_name_admin(usr)] infected [key_name_admin(H)] with a ZOMBIE VIRUS")
	else if(href_list["larvainfect"])
		if(!check_rights(R_ADMIN)) return
		var/mob/living/carbon/human/H = locate(href_list["larvainfect"])
		if(!istype(H))
			to_chat(usr, "This can only be used on instances of type /human")
			return

		if(alert(usr, "Are you sure you want to infect them with a xeno larva?", "Message", "Yes", "No") != "Yes")
			return

		var/list/hives = list()
		var/datum/hive_status/hive
		for(var/hivenumber in GLOB.hive_datum)
			hive = GLOB.hive_datum[hivenumber]
			hives += list("[hive.name]" = hive.hivenumber)

		var/newhive = tgui_input_list(usr,"Select a hive.", "Infect Larva", hives)

		if(!H)
			to_chat(usr, "This mob no longer exists")
			return

		var/obj/item/alien_embryo/embryo = new /obj/item/alien_embryo(H)
		embryo.hivenumber = hives[newhive]
		embryo.faction = newhive

		message_admins("[key_name_admin(usr)] infected [key_name_admin(H)] with a xeno ([newhive]) larva.")

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

		message_admins("[key_name_admin(usr)] has made [key_name_admin(H)] into a mutineer leader.")

	else if(href_list["makecultist"] || href_list["makecultistleader"])
		if(!check_rights(R_DEBUG|R_SPAWN))
			return

		var/mob/living/carbon/human/H = locate(href_list["makecultist"]) || locate(href_list["makecultistleader"])
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon/human")
			return

		var/list/hives = list()
		for(var/hivenumber in GLOB.hive_datum)
			var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
			LAZYSET(hives, hive.name, hive)
		LAZYSET(hives, "CANCEL", null)

		var/hive_name = tgui_input_list(usr, "Which Hive will he belongs to", "Make Cultist", hives)
		if(!hive_name || hive_name == "CANCEL")
			to_chat(usr, SPAN_ALERT("Hive choice error. Aborting."))

		var/datum/hive_status/hive = hives[hive_name]

		if(href_list["makecultist"])
			var/datum/equipment_preset/preset = GLOB.gear_path_presets_list[/datum/equipment_preset/other/xeno_cultist]
			preset.load_race(H)
			preset.load_status(H, hive.hivenumber)
			message_admins("[key_name_admin(usr)] has made [key_name_admin(H)] into a cultist for [hive.name].")

		else if(href_list["makecultistleader"])
			var/datum/equipment_preset/preset = GLOB.gear_path_presets_list[/datum/equipment_preset/other/xeno_cultist/leader]
			preset.load_race(H)
			preset.load_status(H, hive.hivenumber)
			message_admins("[key_name_admin(usr)] has made [key_name_admin(H)] into a cultist leader for [hive.name].")

		H.faction = hive.internal_faction

	else if(href_list["forceemote"])
		if(!check_rights(R_ADMIN)) return

		var/mob/M = locate(href_list["forceemote"])
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob")

		var/speech = input("What will [key_name(M)] emote?.", "Force emote", "")// Don't need to sanitize, since it does that in say(), we also trust our admins.
		if(!speech) return
		M.manual_emote(speech)
		speech = sanitize(speech) // Nah, we don't trust them
		message_admins("[key_name_admin(usr)] forced [key_name_admin(M)] to emote: [speech]")

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

		message_admins("[key_name(usr)] has sent [key_name(M)] back to the Lobby.")

		var/mob/new_player/NP = new()
		NP.ckey = M.ckey
		qdel(M)

	else if(href_list["tdome1"])
		if(!check_rights(R_ADMIN)) return

		if(alert(usr, "Confirm?", "Message", "Yes", "No") != "Yes")
			return

		var/mob/M = locate(href_list["tdome1"])
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		for(var/obj/item/I in M)
			M.drop_inv_item_on_ground(I)

		M.apply_effect(5, PARALYZE)
		sleep(5)
		M.forceMove(get_turf(pick(GLOB.thunderdome_one)))
		spawn(50)
			to_chat(M, SPAN_NOTICE(" You have been sent to the Thunderdome."))
		message_admins("[key_name_admin(usr)] has sent [key_name_admin(M)] to the thunderdome. (Team 1)", 1)

	else if(href_list["tdome2"])
		if(!check_rights(R_ADMIN)) return

		if(alert(usr, "Confirm?", "Message", "Yes", "No") != "Yes")
			return

		var/mob/M = locate(href_list["tdome2"])
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		for(var/obj/item/I in M)
			M.drop_inv_item_on_ground(I)

		M.apply_effect(5, PARALYZE)
		sleep(5)
		M.forceMove(get_turf(pick(GLOB.thunderdome_two)))
		spawn(50)
			to_chat(M, SPAN_NOTICE(" You have been sent to the Thunderdome."))
		message_admins("[key_name_admin(usr)] has sent [key_name_admin(M)] to the thunderdome. (Team 2)", 1)

	else if(href_list["tdomeadmin"])
		if(!check_rights(R_ADMIN)) return

		if(alert(usr, "Confirm?", "Message", "Yes", "No") != "Yes")
			return

		var/mob/M = locate(href_list["tdomeadmin"])
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		M.apply_effect(5, PARALYZE)
		sleep(5)
		M.forceMove(get_turf(pick(GLOB.thunderdome_admin)))
		spawn(50)
			to_chat(M, SPAN_NOTICE(" You have been sent to the Thunderdome."))
		message_admins("[key_name_admin(usr)] has sent [key_name_admin(M)] to the thunderdome. (Admin.)", 1)

	else if(href_list["tdomeobserve"])
		if(!check_rights(R_ADMIN)) return

		if(alert(usr, "Confirm?", "Message", "Yes", "No") != "Yes")
			return

		var/mob/M = locate(href_list["tdomeobserve"])
		if(!ismob(M))
			to_chat(usr, "This can only be used on instances of type /mob")
			return

		for(var/obj/item/I in M)
			M.drop_inv_item_on_ground(I)

		if(istype(M, /mob/living/carbon/human))
			var/mob/living/carbon/human/observer = M
			observer.equip_to_slot_or_del(new /obj/item/clothing/under/suit_jacket(observer), WEAR_BODY)
			observer.equip_to_slot_or_del(new /obj/item/clothing/shoes/black(observer), WEAR_FEET)
		M.apply_effect(5, PARALYZE)
		sleep(5)
		M.forceMove(get_turf(pick(GLOB.thunderdome_observer)))
		spawn(50)
			to_chat(M, SPAN_NOTICE(" You have been sent to the Thunderdome."))
		message_admins("[key_name_admin(usr)] has sent [key_name_admin(M)] to the thunderdome. (Observer.)", 1)

	else if(href_list["revive"])
		if(!check_rights(R_MOD))
			return

		var/mob/living/L = locate(href_list["revive"])
		if(!istype(L))
			to_chat(usr, "This can only be used on instances of type /mob/living")
			return

		L.revive()
		message_admins(WRAP_STAFF_LOG(usr, "ahealed [key_name(L)] in [get_area(L)] ([L.x],[L.y],[L.z])."), L.x, L.y, L.z)

	else if(href_list["makealien"])
		if(!check_rights(R_SPAWN)) return

		var/mob/living/carbon/human/H = locate(href_list["makealien"])
		if(!istype(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human")
			return

		usr.client.cmd_admin_alienize(H)

	else if(href_list["changehivenumber"])
		if(!check_rights(R_DEBUG|R_ADMIN)) return

		var/mob/living/carbon/H = locate(href_list["changehivenumber"])
		if(!istype(H))
			to_chat(usr, "This can only be done to instances of type /mob/living/carbon/")
			return
		if(usr.client)
			usr.client.cmd_admin_change_their_hivenumber(H)

	else if(href_list["makeyautja"])
		if(!check_rights(R_SPAWN)) return

		if(alert("Are you sure you want to make this person into a yautja? It will delete their old character.","Make Yautja","Yes","No") != "Yes")
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
			message_admins("[key_name(usr)] made [H] into a Yautja, [M.real_name].")
			if(H.mind)
				H.mind.transfer_to(M)
			else
				M.key = H.key
				if(M.client) M.client.change_view(GLOB.world_view_size)

			if(M.skills)
				qdel(M.skills)
			M.skills = null //no skill restriction

			M.change_real_name(M, y_name)
			M.name = "Unknown" // Yautja names are not visible for oomans

			if(H)
				qdel(H) //May have to clear up round-end vars and such....

		return

	else if(href_list["makeanimal"])
		if(!check_rights(R_SPAWN)) return

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
			G.do_observe(M)

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
		if(!check_rights(R_MOD)) return
		var/cancel_token = href_list["cancellation"]
		if(!cancel_token)
			return
		if(alert("Are you sure you want to cancel this OB?",,"Yes","No") != "Yes")
			return
		GLOB.orbital_cannon_cancellation["[cancel_token]"] = null
		message_admins("[src.owner] has cancelled the orbital strike.")

	else if(href_list["admincancelpredsd"])
		if (!check_rights(R_MOD)) return
		var/obj/item/clothing/gloves/yautja/hunter/bracer = locate(href_list["bracer"])
		var/mob/living/carbon/victim = locate(href_list["victim"])
		if (!istype(bracer))
			return
		if (alert("Are you sure you want to cancel this pred SD?",,"Yes","No") != "Yes")
			return
		bracer.exploding = FALSE
		message_admins("[src.owner] has cancelled the predator self-destruct sequence [victim ? "of [victim] ([victim.key])":""].")

	else if(href_list["adminspawncookie"])
		if(!check_rights(R_MOD))
			return

		var/mob/living/carbon/human/H = locate(href_list["adminspawncookie"])
		if(!ishuman(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human")
			return

		var/cookie_type = tgui_input_list(usr, "Choose cookie type:", "Give Cookie", list("cookie", "random fortune cookie", "custom fortune cookie"))
		if(!cookie_type)
			return

		var/obj/item/reagent_container/food/snacks/snack
		switch(cookie_type)
			if("cookie")
				snack = new /obj/item/reagent_container/food/snacks/cookie(H.loc)
			if("random fortune cookie")
				snack = new /obj/item/reagent_container/food/snacks/fortunecookie/prefilled(H.loc)
			if("custom fortune cookie")
				var/fortune_text = tgui_input_list(usr, "Choose fortune:", "Cookie customisation", list("Random", "Custom", "None"))
				if(!fortune_text)
					return
				if(fortune_text == "Custom")
					fortune_text = input(usr, "Enter the fortune text:", "Cookie customisation", "")
					if(!fortune_text)
						return
				var/fortune_numbers = tgui_input_list(usr, "Choose lucky numbers:", "Cookie customisation", list("Random", "Custom", "None"))
				if(!fortune_numbers)
					return
				if(fortune_numbers == "Custom")
					fortune_numbers = input(usr, "Enter the lucky numbers:", "Cookie customisation", "1, 2, 3, 4 and 5")
					if(!fortune_numbers)
						return
				if(fortune_text == "None" && fortune_numbers == "None")
					to_chat(usr, "No fortune provided, Give Cookie code crumbled!")
					return
				snack = new /obj/item/reagent_container/food/snacks/fortunecookie/prefilled(H.loc, fortune_text, fortune_numbers)

		if(!snack)
			error("Give Cookie code crumbled!")
		H.put_in_hands(snack)
		message_admins("[key_name(H)] got their [cookie_type], spawned by [key_name(src.owner)]")
		to_chat(H, SPAN_NOTICE(" Your prayers have been answered!! You received the <b>best cookie</b>!"))

	else if(href_list["adminalert"])
		if(!check_rights(R_MOD))
			return

		var/mob/M = locate(href_list["adminalert"])
		usr.client.cmd_admin_alert_message(M)

	else if(href_list["CentcommReply"])
		var/mob/living/carbon/human/H = locate(href_list["CentcommReply"])

		if(!istype(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human")
			return

		//unanswered_distress -= H

		if(!H.get_type_in_ears(/obj/item/device/radio/headset))
			to_chat(usr, "The person you are trying to contact is not wearing a headset")
			return

		var/input = input(src.owner, "Please enter a message to reply to [key_name(H)] via their headset.","Outgoing message from USCM", "")
		if(!input)
			return

		to_chat(src.owner, "You sent [input] to [H] via a secure channel.")
		log_admin("[src.owner] replied to [key_name(H)]'s USCM message with the message [input].")
		for(var/client/X in GLOB.admins)
			if((R_ADMIN|R_MOD) & X.admin_holder.rights)
				to_chat(X, SPAN_STAFF_IC("<b>ADMINS/MODS: \red [src.owner] replied to [key_name(H)]'s USCM message with: \blue \")[input]\"</b>"))
		to_chat(H, SPAN_DANGER("You hear something crackle in your headset before a voice speaks, please stand by for a message:\" \blue <b>\"[input]\"</b>"))

	else if(href_list["SyndicateReply"])
		var/mob/living/carbon/human/H = locate(href_list["SyndicateReply"])
		if(!istype(H))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human")
			return
		if(!H.get_type_in_ears(/obj/item/device/radio/headset))
			to_chat(usr, "The person you are trying to contact is not wearing a headset")
			return

		var/input = input(src.owner, "Please enter a message to reply to [key_name(H)] via their headset.","Outgoing message from The Syndicate", "")
		if(!input)
			return

		to_chat(src.owner, "You sent [input] to [H] via a secure channel.")
		log_admin("[src.owner] replied to [key_name(H)]'s Syndicate message with the message [input].")
		to_chat(H, "You hear something crackle in your headset for a moment before a voice speaks.  \"Please stand by for a message from your benefactor.  Message as follows, agent. <b>\"[input]\"</b>  Message ends.\"")

	else if(href_list["UpdateFax"])
		var/obj/structure/machinery/faxmachine/fax = locate(href_list["originfax"])
		fax.update_departments()

	else if(href_list["PressFaxReply"])
		var/mob/living/carbon/human/H = locate(href_list["PressFaxReply"])
		var/obj/structure/machinery/faxmachine/fax = locate(href_list["originfax"])

		var/template_choice = tgui_input_list(usr, "Use which template or roll your own?", "Fax Templates", list("Template", "Custom"))
		if(!template_choice) return
		var/datum/fax/fax_message
		var/organization_type = ""
		switch(template_choice)
			if("Custom")
				var/input = input(src.owner, "Please enter a message to reply to [key_name(H)] via secure connection. NOTE: BBCode does not work, but HTML tags do! Use <br> for line breaks.", "Outgoing message from Press", "") as message|null
				if(!input)
					return
				fax_message = new(input)
			if("Template")
				var/subject = input(src.owner, "Enter subject line", "Outgoing message from Press", "") as message|null
				if(!subject)
					return
				var/addressed_to = ""
				var/address_option = tgui_input_list(usr, "Address it to the sender or custom?", "Fax Template", list("Sender", "Custom"))
				if(address_option == "Sender")
					addressed_to = "[H.real_name]"
				else if(address_option == "Custom")
					addressed_to = input(src.owner, "Enter Addressee Line", "Outgoing message from Press", "") as message|null
					if(!addressed_to)
						return
				else
					return
				var/message_body = input(src.owner, "Enter Message Body, use <p></p> for paragraphs", "Outgoing message from Press", "") as message|null
				if(!message_body)
					return
				var/sent_by = input(src.owner, "Enter the name and rank you are sending from.", "Outgoing message from Press", "") as message|null
				if(!sent_by)
					return
				organization_type = input(src.owner, "Enter the organization you are sending from.", "Outgoing message from Press", "") as message|null
				if(!organization_type)
					return

				fax_message = new(generate_templated_fax(0, organization_type, subject, addressed_to, message_body, sent_by, "Editor in Chief", organization_type))
		show_browser(usr, "<body class='paper'>[fax_message.data]</body>", "pressfaxpreview", "size=500x400")
		var/send_choice = tgui_input_list(usr, "Send this fax?", "Fax Template", list("Send", "Cancel"))
		if(send_choice != "Send")
			return
		GLOB.fax_contents += fax_message // save a copy
		var/customname = input(src.owner, "Pick a title for the report", "Title") as text|null

		GLOB.PressFaxes.Add("<a href='?FaxView=\ref[fax_message]'>\[view '[customname]' from [key_name(usr)] at [time2text(world.timeofday, "hh:mm:ss")]\]</a>")

		var/msg_ghost = SPAN_NOTICE("<b><font color='#1F66A0'>PRESS REPLY: </font></b> ")
		msg_ghost += "Transmitting '[customname]' via secure connection ... "
		msg_ghost += "<a href='?FaxView=\ref[fax_message]'>view message</a>"
		announce_fax(msg_ghost = msg_ghost)

		for(var/obj/structure/machinery/faxmachine/F in GLOB.machines)
			if(F == fax)
				if(!(F.inoperable()))

					// animate! it's alive!
					flick("faxreceive", F)

					// give the sprite some time to flick
					spawn(20)
						var/obj/item/paper/P = new /obj/item/paper( F.loc )
						P.name = "[organization_type] - [customname]"
						P.info = fax_message.data
						P.update_icon()

						playsound(F.loc, "sound/machines/fax.ogg", 15)

						// Stamps
						var/image/stampoverlay = image('icons/obj/items/paper.dmi')
						stampoverlay.icon_state = "paper_stamp-uscm"
						if(!P.stamped)
							P.stamped = new
						P.stamped += /obj/item/tool/stamp
						P.overlays += stampoverlay
						P.stamps += "<HR><i>This paper has been stamped by the Free Press Quantum Relay.</i>"

				to_chat(src.owner, "Message reply to transmitted successfully.")
				message_admins(SPAN_STAFF_IC("[key_name_admin(src.owner)] replied to a fax message from [key_name_admin(H)]"), 1)
				return
		to_chat(src.owner, "/red Unable to locate fax!")

	else if(href_list["USCMFaxReply"])
		var/mob/living/carbon/human/H = locate(href_list["USCMFaxReply"])
		var/obj/structure/machinery/faxmachine/fax = locate(href_list["originfax"])

		var/template_choice = tgui_input_list(usr, "Use which template or roll your own?", "Fax Templates", list("USCM High Command", "USCM Provost General", "Custom"))
		if(!template_choice) return
		var/datum/fax/fax_message
		switch(template_choice)
			if("Custom")
				var/input = input(src.owner, "Please enter a message to reply to [key_name(H)] via secure connection. NOTE: BBCode does not work, but HTML tags do! Use <br> for line breaks.", "Outgoing message from USCM", "") as message|null
				if(!input)
					return
				fax_message = new(input)
			if("USCM High Command", "USCM Provost General")
				var/subject = input(src.owner, "Enter subject line", "Outgoing message from USCM", "") as message|null
				if(!subject)
					return
				var/addressed_to = ""
				var/address_option = tgui_input_list(usr, "Address it to the sender or custom?", "Fax Template", list("Sender", "Custom"))
				if(address_option == "Sender")
					addressed_to = "[H.real_name]"
				else if(address_option == "Custom")
					addressed_to = input(src.owner, "Enter Addressee Line", "Outgoing message from USCM", "") as message|null
					if(!addressed_to)
						return
				else
					return
				var/message_body = input(src.owner, "Enter Message Body, use <p></p> for paragraphs", "Outgoing message from USCM", "") as message|null
				if(!message_body)
					return
				var/sent_by = input(src.owner, "Enter the name and rank you are sending from.", "Outgoing message from USCM", "") as message|null
				if(!sent_by)
					return
				var/sent_title = "Office of the Provost General"
				if(template_choice == "USCM High Command")
					sent_title = "USCM High Command"

				fax_message = new(generate_templated_fax(0, "USCM CENTRAL COMMAND", subject,addressed_to, message_body,sent_by, sent_title, "United States Colonial Marine Corps"))
		show_browser(usr, "<body class='paper'>[fax_message.data]</body>", "uscmfaxpreview", "size=500x400")
		var/send_choice = tgui_input_list(usr, "Send this fax?", "Fax Template", list("Send", "Cancel"))
		if(send_choice != "Send")
			return
		GLOB.fax_contents += fax_message // save a copy

		var/customname = input(src.owner, "Pick a title for the report", "Title") as text|null

		GLOB.USCMFaxes.Add("<a href='?FaxView=\ref[fax_message]'>\[view '[customname]' from [key_name(usr)] at [time2text(world.timeofday, "hh:mm:ss")]\]</a>")

		var/msg_ghost = SPAN_NOTICE("<b><font color='#1F66A0'>USCM FAX REPLY: </font></b> ")
		msg_ghost += "Transmitting '[customname]' via secure connection ... "
		msg_ghost += "<a href='?FaxView=\ref[fax_message]'>view message</a>"
		announce_fax( ,msg_ghost)

		for(var/obj/structure/machinery/faxmachine/F in GLOB.machines)
			if(F == fax)
				if(!(F.inoperable()))

					// animate! it's alive!
					flick("faxreceive", F)

					// give the sprite some time to flick
					spawn(20)
						var/obj/item/paper/P = new /obj/item/paper( F.loc )
						P.name = "USCM High Command - [customname]"
						P.info = fax_message.data
						P.update_icon()

						playsound(F.loc, "sound/machines/fax.ogg", 15)

						// Stamps
						var/image/stampoverlay = image('icons/obj/items/paper.dmi')
						stampoverlay.icon_state = "paper_stamp-uscm"
						if(!P.stamped)
							P.stamped = new
						P.stamped += /obj/item/tool/stamp
						P.overlays += stampoverlay
						P.stamps += "<HR><i>This paper has been stamped by the USCM High Command Quantum Relay.</i>"

				to_chat(src.owner, "Message reply to transmitted successfully.")
				message_admins(SPAN_STAFF_IC("[key_name_admin(src.owner)] replied to a fax message from [key_name_admin(H)]"), 1)
				return
		to_chat(src.owner, "/red Unable to locate fax!")

	else if(href_list["WYFaxReply"])
		var/mob/living/carbon/human/H = locate(href_list["WYFaxReply"])
		var/obj/structure/machinery/faxmachine/fax = locate(href_list["originfax"])

		var/template_choice = tgui_input_list(usr, "Use the template or roll your own?", "Fax Template", list("Template", "Custom"))
		if(!template_choice) return
		var/datum/fax/fax_message
		switch(template_choice)
			if("Custom")
				var/input = input(src.owner, "Please enter a message to reply to [key_name(H)] via secure connection. NOTE: BBCode does not work, but HTML tags do! Use <br> for line breaks.", "Outgoing message from Weyland-Yutani", "") as message|null
				if(!input)
					return
				fax_message = new(input)
			if("Template")
				var/subject = input(src.owner, "Enter subject line", "Outgoing message from Weyland-Yutani", "") as message|null
				if(!subject)
					return
				var/addressed_to = ""
				var/address_option = tgui_input_list(usr, "Address it to the sender or custom?", "Fax Template", list("Sender", "Custom"))
				if(address_option == "Sender")
					addressed_to = "[H.real_name]"
				else if(address_option == "Custom")
					addressed_to = input(src.owner, "Enter Addressee Line", "Outgoing message from Weyland-Yutani", "") as message|null
					if(!addressed_to)
						return
				else
					return
				var/message_body = input(src.owner, "Enter Message Body, use <p></p> for paragraphs", "Outgoing message from Weyland-Yutani", "") as message|null
				if(!message_body)
					return
				var/sent_by = input(src.owner, "Enter JUST the name you are sending this from", "Outgoing message from Weyland-Yutani", "") as message|null
				if(!sent_by)
					return
				fax_message = new(generate_templated_fax(1, "WEYLAND-YUTANI CORPORATE AFFAIRS - [MAIN_SHIP_NAME]", subject, addressed_to, message_body, sent_by, "Corporate Affairs Director", "Weyland-Yutani"))
		show_browser(usr, "<body class='paper'>[fax_message.data]</body>", "clfaxpreview", "size=500x400")
		var/send_choice = tgui_input_list(usr, "Send this fax?", "Fax Confirmation", list("Send", "Cancel"))
		if(send_choice != "Send")
			return
		GLOB.fax_contents += fax_message // save a copy

		var/customname = input(src.owner, "Pick a title for the report", "Title") as text|null
		if(!customname)
			return

		GLOB.WYFaxes.Add("<a href='?FaxView=\ref[fax_message]'>\[view '[customname]' from [key_name(usr)] at [time2text(world.timeofday, "hh:mm:ss")]\]</a>") //Add replies so that mods know what the hell is goin on with the RP

		var/msg_ghost = SPAN_NOTICE("<b><font color='#1F66A0'>WEYLAND-YUTANI FAX REPLY: </font></b> ")
		msg_ghost += "Transmitting '[customname]' via secure connection ... "
		msg_ghost += "<a href='?FaxView=\ref[fax_message]'>view message</a>"
		announce_fax( ,msg_ghost)


		for(var/obj/structure/machinery/faxmachine/F in GLOB.machines)
			if(F == fax)
				if(!(F.inoperable()))

					// animate! it's alive!
					flick("faxreceive", F)

					// give the sprite some time to flick
					spawn(20)
						var/obj/item/paper/P = new /obj/item/paper( F.loc )
						P.name = "Weyland-Yutani - [customname]"
						P.info = fax_message.data
						P.update_icon()

						playsound(F.loc, "sound/machines/fax.ogg", 15)

						// Stamps
						var/image/stampoverlay = image('icons/obj/items/paper.dmi')
						stampoverlay.icon_state = "paper_stamp-weyyu"
						if(!P.stamped)
							P.stamped = new
						P.stamped += /obj/item/tool/stamp
						P.overlays += stampoverlay
						P.stamps += "<HR><i>This paper has been stamped and encrypted by the Weyland-Yutani Quantum Relay (tm).</i>"

				to_chat(src.owner, "Message reply to transmitted successfully.")
				message_admins(SPAN_STAFF_IC("[key_name_admin(src.owner)] replied to a fax message from [key_name_admin(H)]"), 1)
				return
		to_chat(src.owner, "/red Unable to locate fax!")

	else if(href_list["TWEFaxReply"])
		var/mob/living/carbon/human/H = locate(href_list["TWEFaxReply"])
		var/obj/structure/machinery/faxmachine/fax = locate(href_list["originfax"])

		var/template_choice = tgui_input_list(usr, "Use the template or roll your own?", "Fax Template", list("Template", "Custom"))
		if(!template_choice) return
		var/datum/fax/fax_message
		switch(template_choice)
			if("Custom")
				var/input = input(src.owner, "Please enter a message to reply to [key_name(H)] via secure connection. NOTE: BBCode does not work, but HTML tags do! Use <br> for line breaks.", "Outgoing message from TWE", "") as message|null
				if(!input)
					return
				fax_message = new(input)
			if("Template")
				var/subject = input(src.owner, "Enter subject line", "Outgoing message from TWE", "") as message|null
				if(!subject)
					return
				var/addressed_to = ""
				var/address_option = tgui_input_list(usr, "Address it to the sender or custom?", "Fax Template", list("Sender", "Custom"))
				if(address_option == "Sender")
					addressed_to = "[H.real_name]"
				else if(address_option == "Custom")
					addressed_to = input(src.owner, "Enter Addressee Line", "Outgoing message from TWE", "") as message|null
					if(!addressed_to)
						return
				else
					return
				var/message_body = input(src.owner, "Enter Message Body, use <p></p> for paragraphs", "Outgoing message from TWE", "") as message|null
				if(!message_body)
					return
				var/sent_by = input(src.owner, "Enter JUST the name you are sending this from", "Outgoing message from TWE", "") as message|null
				if(!sent_by)
					return
				fax_message = new(generate_templated_fax(0, "THREE WORLD EMPIRE - ROYAL MILITARY COMMAND", subject, addressed_to, message_body, sent_by, "Office of Military Communications", "Three World Empire"))
		show_browser(usr, "<body class='paper'>[fax_message.data]</body>", "PREVIEW OF TWE FAX", "size=500x400")
		var/send_choice = tgui_input_list(usr, "Send this fax?", "Fax Confirmation", list("Send", "Cancel"))
		if(send_choice != "Send")
			return
		GLOB.fax_contents += fax_message // save a copy

		var/customname = input(src.owner, "Pick a title for the report", "Title") as text|null
		if(!customname)
			return

		GLOB.TWEFaxes.Add("<a href='?FaxView=\ref[fax_message]'>\[view '[customname]' from [key_name(usr)] at [time2text(world.timeofday, "hh:mm:ss")]\]</a>") //Add replies so that mods know what the hell is goin on with the RP

		var/msg_ghost = SPAN_NOTICE("<b><font color='#1F66A0'>THREE WORLD EMPIRE FAX REPLY: </font></b> ")
		msg_ghost += "Transmitting '[customname]' via secure connection ... "
		msg_ghost += "<a href='?FaxView=\ref[fax_message]'>view message</a>"
		announce_fax( ,msg_ghost)

		for(var/obj/structure/machinery/faxmachine/F in GLOB.machines)
			if(F == fax)
				if(!(F.inoperable()))

					// animate! it's alive!
					flick("faxreceive", F)

					// give the sprite some time to flick
					spawn(20)
						var/obj/item/paper/P = new /obj/item/paper( F.loc )
						P.name = "Three World Empire - [customname]"
						P.info = fax_message.data
						P.update_icon()

						playsound(F.loc, "sound/machines/fax.ogg", 15)

						// Stamps
						var/image/stampoverlay = image('icons/obj/items/paper.dmi')
						stampoverlay.icon_state = "paper_stamp-twe"
						if(!P.stamped)
							P.stamped = new
						P.stamped += /obj/item/tool/stamp
						P.overlays += stampoverlay
						P.stamps += "<HR><i>This paper has been stamped by the Three World Empire Quantum Relay (tm).</i>"

				to_chat(src.owner, "Message reply to transmitted successfully.")
				message_admins(SPAN_STAFF_IC("[key_name_admin(src.owner)] replied to a fax message from [key_name_admin(H)]"), 1)
				return
		to_chat(src.owner, "/red Unable to locate fax!")

	else if(href_list["UPPFaxReply"])
		var/mob/living/carbon/human/H = locate(href_list["UPPFaxReply"])
		var/obj/structure/machinery/faxmachine/fax = locate(href_list["originfax"])

		var/template_choice = tgui_input_list(usr, "Use the template or roll your own?", "Fax Template", list("Template", "Custom"))
		if(!template_choice) return
		var/datum/fax/fax_message
		switch(template_choice)
			if("Custom")
				var/input = input(src.owner, "Please enter a message to reply to [key_name(H)] via secure connection. NOTE: BBCode does not work, but HTML tags do! Use <br> for line breaks.", "Outgoing message from UPP", "") as message|null
				if(!input)
					return
				fax_message = new(input)
			if("Template")
				var/subject = input(src.owner, "Enter subject line", "Outgoing message from UPP", "") as message|null
				if(!subject)
					return
				var/addressed_to = ""
				var/address_option = tgui_input_list(usr, "Address it to the sender or custom?", "Fax Template", list("Sender", "Custom"))
				if(address_option == "Sender")
					addressed_to = "[H.real_name]"
				else if(address_option == "Custom")
					addressed_to = input(src.owner, "Enter Addressee Line", "Outgoing message from UPP", "") as message|null
					if(!addressed_to)
						return
				else
					return
				var/message_body = input(src.owner, "Enter Message Body, use <p></p> for paragraphs", "Outgoing message from UPP", "") as message|null
				if(!message_body)
					return
				var/sent_by = input(src.owner, "Enter JUST the name you are sending this from", "Outgoing message from UPP", "") as message|null
				if(!sent_by)
					return
				fax_message = new(generate_templated_fax(0, "UNION OF PROGRESSIVE PEOPLES - MILITARY HIGH KOMMAND", subject, addressed_to, message_body, sent_by, "Military High Kommand", "Union of Progressive Peoples"))
		show_browser(usr, "<body class='paper'>[fax_message.data]</body>", "PREVIEW OF UPP FAX", "size=500x400")
		var/send_choice = tgui_input_list(usr, "Send this fax?", "Fax Confirmation", list("Send", "Cancel"))
		if(send_choice != "Send")
			return
		GLOB.fax_contents += fax_message // save a copy

		var/customname = input(src.owner, "Pick a title for the report", "Title") as text|null
		if(!customname)
			return

		GLOB.UPPFaxes.Add("<a href='?FaxView=\ref[fax_message]'>\[view '[customname]' from [key_name(usr)] at [time2text(world.timeofday, "hh:mm:ss")]\]</a>") //Add replies so that mods know what the hell is goin on with the RP

		var/msg_ghost = SPAN_NOTICE("<b><font color='#1F66A0'>UNION OF PROGRESSIVE PEOPLES FAX REPLY: </font></b> ")
		msg_ghost += "Transmitting '[customname]' via secure connection ... "
		msg_ghost += "<a href='?FaxView=\ref[fax_message]'>view message</a>"
		announce_fax( ,msg_ghost)

		for(var/obj/structure/machinery/faxmachine/F in GLOB.machines)
			if(F == fax)
				if(!(F.inoperable()))

					// animate! it's alive!
					flick("faxreceive", F)

					// give the sprite some time to flick
					spawn(20)
						var/obj/item/paper/P = new /obj/item/paper( F.loc )
						P.name = "Union of Progressive Peoples - [customname]"
						P.info = fax_message.data
						P.update_icon()

						playsound(F.loc, "sound/machines/fax.ogg", 15)

						// Stamps
						var/image/stampoverlay = image('icons/obj/items/paper.dmi')
						stampoverlay.icon_state = "paper_stamp-upp"
						if(!P.stamped)
							P.stamped = new
						P.stamped += /obj/item/tool/stamp
						P.overlays += stampoverlay
						P.stamps += "<HR><i>This paper has been stamped by the Union of Progressive Peoples Quantum Relay (tm).</i>"

				to_chat(src.owner, "Message reply to transmitted successfully.")
				message_admins(SPAN_STAFF_IC("[key_name_admin(src.owner)] replied to a fax message from [key_name_admin(H)]"), 1)
				return
		to_chat(src.owner, "/red Unable to locate fax!")

	else if(href_list["CLFFaxReply"])
		var/mob/living/carbon/human/H = locate(href_list["CLFFaxReply"])
		var/obj/structure/machinery/faxmachine/fax = locate(href_list["originfax"])

		var/template_choice = tgui_input_list(usr, "Use the template or roll your own?", "Fax Template", list("Template", "Custom"))
		if(!template_choice) return
		var/datum/fax/fax_message
		switch(template_choice)
			if("Custom")
				var/input = input(src.owner, "Please enter a message to reply to [key_name(H)] via secure connection. NOTE: BBCode does not work, but HTML tags do! Use <br> for line breaks.", "Outgoing message from CLF", "") as message|null
				if(!input)
					return
				fax_message = new(input)
			if("Template")
				var/subject = input(src.owner, "Enter subject line", "Outgoing message from CLF", "") as message|null
				if(!subject)
					return
				var/addressed_to = ""
				var/address_option = tgui_input_list(usr, "Address it to the sender or custom?", "Fax Template", list("Sender", "Custom"))
				if(address_option == "Sender")
					addressed_to = "[H.real_name]"
				else if(address_option == "Custom")
					addressed_to = input(src.owner, "Enter Addressee Line", "Outgoing message from CLF", "") as message|null
					if(!addressed_to)
						return
				else
					return
				var/message_body = input(src.owner, "Enter Message Body, use <p></p> for paragraphs", "Outgoing message from CLF", "") as message|null
				if(!message_body)
					return
				var/sent_by = input(src.owner, "Enter JUST the name you are sending this from", "Outgoing message from CLF", "") as message|null
				if(!sent_by)
					return
				fax_message = new(generate_templated_fax(0, "COLONIAL LIBERATION FRONT - COLONIAL COUNCIL OF LIBERATION", subject, addressed_to, message_body, sent_by, "Guerilla Forces Command", "Colonial Liberation Front"))
		show_browser(usr, "<body class='paper'>[fax_message.data]</body>", "PREVIEW OF CLF FAX", "size=500x400")
		var/send_choice = tgui_input_list(usr, "Send this fax?", "Fax Confirmation", list("Send", "Cancel"))
		if(send_choice != "Send")
			return
		GLOB.fax_contents += fax_message // save a copy

		var/customname = input(src.owner, "Pick a title for the report", "Title") as text|null
		if(!customname)
			return

		GLOB.CLFFaxes.Add("<a href='?FaxView=\ref[fax_message]'>\[view '[customname]' from [key_name(usr)] at [time2text(world.timeofday, "hh:mm:ss")]\]</a>") //Add replies so that mods know what the hell is goin on with the RP

		var/msg_ghost = SPAN_NOTICE("<b><font color='#1F66A0'>COLONIAL LIBERATION FRONT FAX REPLY: </font></b> ")
		msg_ghost += "Transmitting '[customname]' via secure connection ... "
		msg_ghost += "<a href='?FaxView=\ref[fax_message]'>view message</a>"
		announce_fax( ,msg_ghost)

		for(var/obj/structure/machinery/faxmachine/F in GLOB.machines)
			if(F == fax)
				if(!(F.inoperable()))

					// animate! it's alive!
					flick("faxreceive", F)

					// give the sprite some time to flick
					spawn(20)
						var/obj/item/paper/P = new /obj/item/paper( F.loc )
						P.name = "Colonial Liberation Front - [customname]"
						P.info = fax_message.data
						P.update_icon()

						playsound(F.loc, "sound/machines/fax.ogg", 15)

						// Stamps
						var/image/stampoverlay = image('icons/obj/items/paper.dmi')
						stampoverlay.icon_state = "paper_stamp-clf"
						if(!P.stamped)
							P.stamped = new
						P.stamped += /obj/item/tool/stamp
						P.overlays += stampoverlay
						P.stamps += "<HR><i>This paper has been stamped and encrypted by the Colonial Liberation Front Quantum Relay (tm).</i>"

				to_chat(src.owner, "Message reply to transmitted successfully.")
				message_admins(SPAN_STAFF_IC("[key_name_admin(src.owner)] replied to a fax message from [key_name_admin(H)]"), 1)
				return
		to_chat(src.owner, "/red Unable to locate fax!")

	else if(href_list["CMBFaxReply"])
		var/mob/living/carbon/human/H = locate(href_list["CMBFaxReply"])
		var/obj/structure/machinery/faxmachine/fax = locate(href_list["originfax"])

		var/template_choice = tgui_input_list(usr, "Use the template or roll your own?", "Fax Template", list("Anchorpoint", "Custom"))
		if(!template_choice) return
		var/datum/fax/fax_message
		switch(template_choice)
			if("Custom")
				var/input = input(src.owner, "Please enter a message to reply to [key_name(H)] via secure connection. NOTE: BBCode does not work, but HTML tags do! Use <br> for line breaks.", "Outgoing message from The Colonial Marshal Bureau", "") as message|null
				if(!input)
					return
				fax_message = new(input)
			if("Anchorpoint")
				var/subject = input(src.owner, "Enter subject line", "Outgoing message from The Colonial Marshal Bureau, Anchorpoint Station", "") as message|null
				if(!subject)
					return
				var/addressed_to = ""
				var/address_option = tgui_input_list(usr, "Address it to the sender or custom?", "Fax Template", list("Sender", "Custom"))
				if(address_option == "Sender")
					addressed_to = "[H.real_name]"
				else if(address_option == "Custom")
					addressed_to = input(src.owner, "Enter Addressee Line", "Outgoing message from The Colonial Marshal Bureau", "") as message|null
					if(!addressed_to)
						return
				else
					return
				var/message_body = input(src.owner, "Enter Message Body, use <p></p> for paragraphs", "Outgoing message from The Colonial Marshal Bureau", "") as message|null
				if(!message_body)
					return
				var/sent_by = input(src.owner, "Enter JUST the name you are sending this from", "Outgoing message from The Colonial Marshal Bureau", "") as message|null
				if(!sent_by)
					return
				fax_message = new(generate_templated_fax(0, "COLONIAL MARSHAL BUREAU INCIDENT COMMAND CENTER - ANCHORPOINT STATION", subject, addressed_to, message_body, sent_by, "Supervisory Deputy Marshal", "Colonial Marshal Bureau"))
		show_browser(usr, "<body class='paper'>[fax_message.data]</body>", "PREVIEW OF CMB FAX", "size=500x400")
		var/send_choice = tgui_input_list(usr, "Send this fax?", "Fax Confirmation", list("Send", "Cancel"))
		if(send_choice != "Send")
			return
		GLOB.fax_contents += fax_message // save a copy

		var/customname = input(src.owner, "Pick a title for the report", "Title") as text|null
		if(!customname)
			return

		GLOB.CMBFaxes.Add("<a href='?FaxView=\ref[fax_message]'>\[view '[customname]' from [key_name(usr)] at [time2text(world.timeofday, "hh:mm:ss")]\]</a>") //Add replies so that mods know what the hell is goin on with the RP

		var/msg_ghost = SPAN_NOTICE("<b><font color='#1b748c'>COLONIAL MARSHAL BUREAU FAX REPLY: </font></b> ")
		msg_ghost += "Transmitting '[customname]' via secure connection ... "
		msg_ghost += "<a href='?FaxView=\ref[fax_message]'>view message</a>"
		announce_fax( ,msg_ghost)


		for(var/obj/structure/machinery/faxmachine/F in GLOB.machines)
			if(F == fax)
				if(!(F.inoperable()))

					// animate! it's alive!
					flick("faxreceive", F)

					// give the sprite some time to flick
					spawn(20)
						var/obj/item/paper/P = new /obj/item/paper( F.loc )
						P.name = "Colonial Marshal Bureau - [customname]"
						P.info = fax_message.data
						P.update_icon()

						playsound(F.loc, "sound/machines/fax.ogg", 15)

						// Stamps
						var/image/stampoverlay = image('icons/obj/items/paper.dmi')
						stampoverlay.icon_state = "paper_stamp-cmb"
						if(!P.stamped)
							P.stamped = new
						P.stamped += /obj/item/tool/stamp
						P.overlays += stampoverlay
						P.stamps += "<HR><i>This paper has been stamped by The Office of Colonial Marshals.</i>"

				to_chat(src.owner, "Message reply to transmitted successfully.")
				message_admins(SPAN_STAFF_IC("[key_name_admin(src.owner)] replied to a fax message from [key_name_admin(H)]"), 1)
				return
		to_chat(src.owner, "/red Unable to locate fax!")

	else if(href_list["customise_paper"])
		if(!check_rights(R_MOD))
			return

		var/obj/item/paper/sheet = locate(href_list["customise_paper"])
		usr.client.customise_paper(sheet)

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

	else if(href_list["send_tip"])
		if(!check_rights(R_SPAWN))
			return
		return send_tip(usr)

	else if(href_list["object_list"]) //this is the laggiest thing ever
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

		if (where == "inhand") //Can only give when human or monkey
			if (!(ishuman(usr)))
				to_chat(usr, "Can only spawn in hand when you're a human or a monkey.")
				where = "onfloor"
			else if (usr.get_active_hand())
				to_chat(usr, "Your active hand is full. Spawning on floor.")
				where = "onfloor"

		if (where == "inmarked" )
			if (!marked_datum)
				to_chat(usr, "You don't have any datum marked. Abandoning spawn.")
				return
			else
				var/datum/D = marked_datum
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
				var/datum/D = marked_datum
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
					message_admins("[key_name_admin(usr)] created a [english_list(paths)]", 1)
					break
		else
			log_admin("[key_name(usr)] created [number]ea [english_list(paths)]")
			for(var/path in paths)
				if(ispath(path, /mob))
					message_admins("[key_name_admin(usr)] created [number]ea [english_list(paths)]", 1)
					break
		return

	else if(href_list["create_humans_list"])
		if(!check_rights(R_SPAWN))
			return

		create_humans_list(href_list)

	else if(href_list["create_xenos_list"])
		if(!check_rights(R_SPAWN))
			return

		create_xenos_list(href_list)

	else if(href_list["events"])
		if(!check_rights(R_ADMIN))
			return

		topic_events(href_list["events"])

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

	if(href_list["player_notes_all"])
		var/key = href_list["player_notes_all"]
		player_notes_all(key)
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
		marine_announcement("Сигнал бедствия не получил ответа, перекалибровка пусковых труб.", "Сигнал Бедствия", logging = ARES_LOG_SECURITY)
		log_game("[key_name_admin(usr)] has denied a distress beacon, requested by [key_name_admin(ref_person)]")
		message_admins("[key_name_admin(usr)] has denied a distress beacon, requested by [key_name_admin(ref_person)]", 1)

		//unanswered_distress -= ref_person

	if(href_list["distresscancel"])
		if(GLOB.distress_cancel)
			to_chat(usr, "The distress beacon was either canceled, or you are too late to cancel.")
			return
		log_game("[key_name_admin(usr)] has canceled the distress beacon.")
		message_admins("[key_name_admin(usr)] has canceled the distress beacon.")
		GLOB.distress_cancel = TRUE
		return

	if(href_list["distress"]) //Distress Beacon, sends a random distress beacon when pressed
		GLOB.distress_cancel = FALSE
		message_admins("[key_name_admin(usr)] has opted to SEND the distress beacon! Launching in 10 seconds... (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];distresscancel=\ref[usr]'>CANCEL</A>)")
		addtimer(CALLBACK(src, PROC_REF(accept_ert), usr, locate(href_list["distress"])), 10 SECONDS)
		//unanswered_distress -= ref_person

	if(href_list["distress_handheld"]) //Prepares to call and logs accepted handheld distress beacons
		var/mob/ref_person = href_list["distress_handheld"]
		var/ert_name = href_list["ert_name"]
		GLOB.distress_cancel = FALSE
		message_admins("[key_name_admin(usr)] has opted to SEND [ert_name]! Launching in 10 seconds... (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];distresscancel=\ref[usr]'>CANCEL</A>)")
		addtimer(CALLBACK(src, PROC_REF(accept_handheld_ert), usr, ref_person, ert_name), 10 SECONDS)

	if(href_list["deny_distress_handheld"]) //Logs denied handheld distress beacons
		var/mob/ref_person = href_list["deny_distress_handheld"]
		to_chat(ref_person, "The distress signal has not received a response.")
		log_game("[key_name_admin(usr)] has denied a distress beacon, requested by [key_name_admin(ref_person)]")
		message_admins("[key_name_admin(usr)] has denied a distress beacon, requested by [key_name_admin(ref_person)]")

	if(href_list["destroyship"]) //Distress Beacon, sends a random distress beacon when pressed
		GLOB.destroy_cancel = FALSE
		message_admins("[key_name_admin(usr)] has opted to GRANT the self-destruct! Starting in 10 seconds... (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];sdcancel=\ref[usr]'>CANCEL</A>)")
		spawn(100)
			if(GLOB.distress_cancel)
				return
			var/mob/ref_person = locate(href_list["destroyship"])
			set_security_level(SEC_LEVEL_DELTA)
			log_game("[key_name_admin(usr)] has granted self-destruct, requested by [key_name_admin(ref_person)]")
			message_admins("[key_name_admin(usr)] has granted self-destruct, requested by [key_name_admin(ref_person)]", 1)

	if(href_list["nukeapprove"])
		var/mob/ref_person = locate(href_list["nukeapprove"])
		if(!istype(ref_person))
			return FALSE
		var/nukename = "Encrypted Operational Nuke"
		var/prompt = tgui_alert(usr, "Do you want the nuke to be Encrypted?", "Nuke Type", list("Encrypted", "Decrypted"), 20 SECONDS)
		if(prompt == "Decrypted")
			nukename = "Decrypted Operational Nuke"
		prompt = tgui_alert(usr, "Are you sure you want to authorize '[nukename]' to the marines? This will greatly affect the round!", "DEFCON 1", list("No", "Yes"))
		if(prompt != "Yes")
			return

		var/nuketype = GLOB.supply_packs_types[nukename]
		//make ASRS order for nuke
		var/datum/supply_order/new_order = new()
		new_order.ordernum = GLOB.supply_controller.ordernum++
		new_order.object = GLOB.supply_packs_datums[nuketype]
		new_order.orderedby = ref_person
		new_order.approvedby = "USCM High Command"
		GLOB.supply_controller.shoppinglist += new_order

		//Can no longer request a nuke
		GLOB.ares_datacore.nuke_available = FALSE

		marine_announcement("Использование Ядерного Вооружения было одобрено Старшим Коммандованием. Заряд будет доставлен в карго через ASRS.", "РАЗРЕШЕНО ПРИМЕНЕНИЕ ЯДЕРНОГО ВООРУЖЕНИЯ", 'sound/misc/notice2.ogg', logging = ARES_LOG_MAIN)
		log_game("[key_name_admin(usr)] has authorized \a [nuketype], requested by [key_name_admin(ref_person)]")
		message_admins("[key_name_admin(usr)] has authorized \a [nuketype], requested by [key_name_admin(ref_person)]")

	if(href_list["nukedeny"])
		var/mob/ref_person = locate(href_list["nukedeny"])
		if(!istype(ref_person))
			return FALSE
		marine_announcement("Ваш запрос на предоставление Ядерного Вооружения был рассмотрен и отклонен Старшим Командованием USCM ради обеспечения безопасности операции и колонии. Хорошего дня.", "ОТКЛОНЕНО", 'sound/misc/notice2.ogg', logging = ARES_LOG_MAIN)
		log_game("[key_name_admin(usr)] has denied nuclear ordnance, requested by [key_name_admin(ref_person)]")
		message_admins("[key_name_admin(usr)] has dnied nuclear ordnance, requested by [key_name_admin(ref_person)]")

	if(href_list["sddeny"]) // CentComm-deny. The self-destruct is denied, without any further conditions
		var/mob/ref_person = locate(href_list["sddeny"])
		marine_announcement("Запрос на использование системы самоуничтожения не получил ответа, ARES выполняет перерасчет статистики.", "Система Самоуничтожения", logging = ARES_LOG_SECURITY)
		log_game("[key_name_admin(usr)] has denied self-destruct, requested by [key_name_admin(ref_person)]")
		message_admins("[key_name_admin(usr)] has denied self-destruct, requested by [key_name_admin(ref_person)]", 1)

	if(href_list["sdcancel"])
		if(GLOB.destroy_cancel)
			to_chat(usr, "The self-destruct was already canceled.")
			return
		if(get_security_level() == "delta")
			to_chat(usr, "Too late! The self-destruct was started.")
			return
		log_game("[key_name_admin(usr)] has canceled the self-destruct.")
		message_admins("[key_name_admin(usr)] has canceled the self-destruct.")
		GLOB.destroy_cancel = TRUE
		return

	if(href_list["tag_datum"])
		if(!check_rights(R_ADMIN))
			return
		var/datum/datum_to_tag = locate(href_list["tag_datum"])
		if(!datum_to_tag)
			return
		return add_tagged_datum(datum_to_tag)

	if(href_list["del_tag"])
		if(!check_rights(R_ADMIN))
			return
		var/datum/datum_to_remove = locate(href_list["del_tag"])
		if(!datum_to_remove)
			return
		return remove_tagged_datum(datum_to_remove)

	if(href_list["show_tags"])
		if(!check_rights(R_ADMIN))
			return
		return display_tags()

	if(href_list["mark_datum"])
		if(!check_rights(R_ADMIN))
			return
		var/datum/datum_to_mark = locate(href_list["mark_datum"])
		if(!datum_to_mark)
			return
		return usr.client?.mark_datum(datum_to_mark)

	if(href_list["force_event"])
		if(!check_rights(R_EVENT))
			return
		var/datum/round_event_control/E = locate(href_list["force_event"]) in SSevents.control
		if(!E)
			return
		E.admin_setup(usr)
		var/datum/round_event/event = E.run_event()
		if(event.cancel_event)
			return
		if(event.announce_when>0)
			event.processing = FALSE
			var/prompt = alert(usr, "Would you like to alert the general population?", "Alert", "Yes", "No", "Cancel")
			switch(prompt)
				if("Yes")
					event.announce_chance = 100
				if("Cancel")
					event.kill()
					return
				if("No")
					event.announce_chance = 0
			event.processing = TRUE
		message_admins("[key_name_admin(usr)] has triggered an event. ([E.name])")
		log_admin("[key_name(usr)] has triggered an event. ([E.name])")
		return

	if(href_list["viewnotes"])
		if(!check_rights(R_MOD))
			return

		var/mob/checking = locate(href_list["viewnotes"])

		player_notes_all(checking.key)

	if(href_list["AresReply"])
		var/mob/living/carbon/human/speaker = locate(href_list["AresReply"])

		if(!istype(speaker))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human")
			return FALSE

		if((!GLOB.ares_link.interface) || (GLOB.ares_link.interface.inoperable()))
			to_chat(usr, "ARES Interface offline.")
			return FALSE

		var/input = input(src.owner, "Please enter a message from ARES to reply to [key_name(speaker)].","Outgoing message from ARES", "")
		if(!input)
			return FALSE

		to_chat(src.owner, "You sent [input] to [speaker] via ARES Interface.")
		log_admin("[src.owner] replied to [key_name(speaker)]'s ARES message with the message [input].")
		for(var/client/staff in GLOB.admins)
			if((R_ADMIN|R_MOD) & staff.admin_holder.rights)
				to_chat(staff, SPAN_STAFF_IC("<b>ADMINS/MODS: [SPAN_RED("[src.owner] replied to [key_name(speaker)]'s ARES message")] with: [SPAN_BLUE(input)] </b>"))
		GLOB.ares_link.interface.response_from_ares(input, href_list["AresRef"])

	if(href_list["AresMark"])
		var/mob/living/carbon/human/speaker = locate(href_list["AresMark"])

		if(!istype(speaker))
			to_chat(usr, "This can only be used on instances of type /mob/living/carbon/human")
			return FALSE

		if((!GLOB.ares_link.interface) || (GLOB.ares_link.interface.inoperable()))
			to_chat(usr, "ARES Interface offline.")
			return FALSE

		to_chat(src.owner, "You marked [speaker]'s ARES message for response.")
		log_admin("[src.owner] marked [key_name(speaker)]'s ARES message. [src.owner] will be responding.")
		for(var/client/staff in GLOB.admins)
			if((R_ADMIN|R_MOD) & staff.admin_holder.rights)
				to_chat(staff, SPAN_STAFF_IC("<b>ADMINS/MODS: [SPAN_RED("[src.owner] marked [key_name(speaker)]'s ARES message for response.")]</b>"))

	return

/datum/admins/proc/accept_ert(mob/approver, mob/ref_person)
	if(GLOB.distress_cancel)
		return
	GLOB.distress_cancel = TRUE
	SSticker.mode.activate_distress()
	log_game("[key_name_admin(approver)] has sent a randomized distress beacon, requested by [key_name_admin(ref_person)]")
	message_admins("[key_name_admin(approver)] has sent a randomized distress beacon, requested by [key_name_admin(ref_person)]")

///Handles calling the ERT sent by handheld distress beacons
/datum/admins/proc/accept_handheld_ert(mob/approver, mob/ref_person, ert_called)
	if(GLOB.distress_cancel)
		return
	GLOB.distress_cancel = TRUE
	SSticker.mode.get_specific_call("[ert_called]", TRUE, FALSE)
	log_game("[key_name_admin(approver)] has sent [ert_called], requested by [key_name_admin(ref_person)]")
	message_admins("[key_name_admin(approver)] has sent [ert_called], requested by [key_name_admin(ref_person)]")

/datum/admins/proc/generate_job_ban_list(mob/M, datum/entity/player/P, list/roles, department, color = "ccccff")
	var/counter = 0

	var/dat = ""
	dat += "<table cellpadding='1' cellspacing='0' width='100%'>"
	dat += "<tr align='center' bgcolor='[color]'><th colspan='[length(roles)]'><a href='?src=\ref[src];[HrefToken(forceGlobal = TRUE)];jobban3=[department]dept;jobban4=\ref[M]'>[department]</a></th></tr><tr align='center'>"
	for(var/jobPos in roles)
		if(!jobPos)
			continue
		var/datum/job/job = GLOB.RoleAuthority.roles_by_name[jobPos]
		if(!job)
			continue

		if(jobban_isbanned(M, job.title, P))
			dat += "<td width='20%'><a href='?src=\ref[src];[HrefToken(forceGlobal = TRUE)];jobban3=[job.title];jobban4=\ref[M]'><font color=red>[replacetext(job.title, " ", "&nbsp")]</font></a></td>"
			counter++
		else
			dat += "<td width='20%'><a href='?src=\ref[src];[HrefToken(forceGlobal = TRUE)];jobban3=[job.title];jobban4=\ref[M]'>[replacetext(job.title, " ", "&nbsp")]</a></td>"
			counter++

		if(counter >= 5) //So things dont get squiiiiished!
			dat += "</tr><tr>"
			counter = 0
	dat += "</tr></table>"
	return dat

/datum/admins/proc/get_job_titles_from_list(list/roles)
	var/list/temp = list()
	for(var/jobPos in roles)
		if(!jobPos)
			continue
		var/datum/job/J = GLOB.RoleAuthority.roles_by_name[jobPos]
		if(!J)
			continue
		temp += J.title
	return temp
