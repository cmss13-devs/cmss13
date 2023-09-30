//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:31

/obj/structure/machinery/computer/secure_data
	name = "Security Records"
	desc = "Used to view and edit personnel's security records"
	icon_state = "security"
	req_access = list(ACCESS_MARINE_BRIG)
	circuit = /obj/item/circuitboard/computer/secure_data
	var/obj/item/device/clue_scanner/scanner = null

	// For optimisation, we keep track of the viewed record and only send detailed data for it.
	var/active_record_ref= null
	var/datum/data/record/active_record_general = null
	var/datum/data/record/active_record_security = null

/obj/structure/machinery/computer/secure_data/attackby(obj/item/held_object as obj, user as mob)
	if(istype(held_object, /obj/item/device/clue_scanner) && !scanner)
		var/obj/item/device/clue_scanner/held_scanner = held_object
		if(!held_scanner.print_list)
			to_chat(user, SPAN_WARNING("There are no prints stored in \the [held_scanner]!"))
			return

		if(usr.drop_held_item())
			held_scanner.forceMove(src)
			scanner = held_scanner
			to_chat(user, "You insert [held_scanner].")
			update_static_data_for_all_viewers()

	..()

/obj/structure/machinery/computer/secure_data/attack_remote(mob/user as mob)
	return attack_hand(user)

/obj/structure/machinery/computer/secure_data/ui_data(mob/user)
	var/list/data = list()

	if(isnull(GLOB.data_core.general) || isnull(GLOB.data_core.security))
		return

	data["active_record"] = list()

	// Get advanced data only for selected record.
	if (active_record_general)
		data["active_record"]["name"] = active_record_general.fields["name"]
		data["active_record"]["ref"] = "\ref[active_record_general]"
		data["active_record"]["id"] = active_record_general.fields["id"]
		data["active_record"]["rank"] = active_record_general.fields["rank"]
		data["active_record"]["squad"] = active_record_general.fields["squad"]
		data["active_record"]["sex"] = active_record_general.fields["sex"]
		data["active_record"]["age"] = active_record_general.fields["age"]
		data["active_record"]["physical_status"] = active_record_general.fields["p_stat"]
		data["active_record"]["mental_status"] = active_record_general.fields["m_stat"]

	// Get security data, if it exists.
	if (active_record_security)
		data["active_record"]["criminal_status"] = active_record_security.fields["criminal"]
		data["active_record"]["incidents"] = active_record_security.fields["incidents"]
		data["active_record"]["comments"] = active_record_security.fields["comments"]

	return data

/obj/structure/machinery/computer/secure_data/ui_static_data(mob/user)
	var/list/data = list()

	if(isnull(GLOB.data_core.general) || isnull(GLOB.data_core.security))
		return

	data["wanted_statuses"] = WANTED_STATUSES
	data["records"] = list()

	// Get basic data from every record.
	for(var/datum/data/record/record_general_data as anything in GLOB.data_core.general)
		var/crew_member = list()

		crew_member["name"] = record_general_data.fields["name"]
		crew_member["ref"] = "\ref[record_general_data]"
		crew_member["rank"] = record_general_data.fields["rank"]

		for(var/datum/data/record/record_security_data as anything in GLOB.data_core.security)
			if (record_security_data.fields["id"] == record_general_data.fields["id"])
				crew_member["criminal_status"] = record_security_data.fields["criminal"]
				break

		data["records"] += list(crew_member)

	// If a fingerprint scanner is inserted, load the prints.
	data["prints"] = list()
	if (scanner)
		for(var/obj/effect/decal/prints/prints as anything in scanner.print_list)
			var/list/print = list()

			print["name"] = prints.criminal_name
			print["desc"] = prints.description

			if(prints.criminal_squad)
				print["squad"] = prints.criminal_squad

			if(prints.criminal_rank)
				print["rank"] = prints.criminal_rank

			data["prints"] += list(print)

	return data

/obj/structure/machinery/computer/secure_data/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	playsound(src, "keyboard", 15, 1)

	switch(action)
		if ("new_general_record")
			set_active_record_general(CreateGeneralRecord())
			set_active_record_security(null)
			update_static_data_for_all_viewers()

		if ("new_security_record")
			if (istype(active_record_security, /datum/data/record) || !sanity_check(params["ref"]))
				return

			set_active_record_security(CreateSecurityRecord(active_record_general.fields["name"], active_record_general.fields["id"]))

		if ("delete_security_record")
			if (!istype(active_record_security, /datum/data/record) || !sanity_check(params["ref"]))
				return

			GLOB.data_core.security -= active_record_security
			qdel(active_record_security)

			var/mob_gid = hex2num(active_record_general.fields["id"])
			for(var/mob/living/carbon/human/human as anything in GLOB.human_mob_list)
				if (human.gid == mob_gid)
					human.sec_hud_set_security_status()
					break

		if ("delete_all_security_records")
			for(var/datum/data/record/record as anything in GLOB.data_core.security)
				GLOB.data_core.security -= record
				qdel(record)

			for(var/mob/living/carbon/human/human as anything in GLOB.human_mob_list)
				human.sec_hud_set_security_status()

		if ("set_active_record")
			var/datum/data/record/general_record = locate(params["ref"])
			if (!istype(general_record))
				return

			set_active_record_general(general_record)
			set_active_record_security(null)

			// Get active security record, if one exists.
			for(var/datum/data/record/security_record as anything in GLOB.data_core.security)
				if (security_record.fields["id"] == general_record.fields["id"])
					set_active_record_security(security_record)
					break

		if ("edit_name")
			if (!sanity_check(params["ref"]))
				return

			var/sanitised_name = reject_bad_name(tgui_input_text(usr, "Enter a new name", "New Name", active_record_general.fields["name"]))
			if (!sanitised_name || !sanity_check(params["ref"]))
				return

			message_admins("[key_name(usr)] has changed the record name of [active_record_general.fields["name"]] to [sanitised_name]")
			active_record_general.fields["name"] = sanitised_name

		if("toggle_sex")
			if (!sanity_check(params["ref"]))
				return

			if (active_record_general.fields["sex"] == "male")
				active_record_general.fields["sex"] = "female"
			else
				active_record_general.fields["sex"] = "male"

		if("edit_age")
			if (!sanity_check(params["ref"]))
				return

			// New records have a string in their age field which will break this input.
			var/default_age = active_record_general.fields["age"] == "Unknown" ? 0 : active_record_general.fields["age"]

			var/input = tgui_input_number(usr, "Enter a new age", "New Age", default_age, AGE_MAX, AGE_MIN)
			if (!input || !sanity_check(params["ref"]))
				return

			active_record_general.fields["age"] = input

		if ("set_criminal_status")
			if (!istype(active_record_security, /datum/data/record) || !sanity_check(params["ref"]))
				return

			var/new_wanted_status = params["new_status"]
			if(!new_wanted_status || !(new_wanted_status in WANTED_STATUSES))
				return

			active_record_security.fields["criminal"] = new_wanted_status

			var/mob_gid = hex2num(active_record_general.fields["id"])
			for(var/mob/living/carbon/human/human as anything in GLOB.human_mob_list)
				if (human.gid == mob_gid)
					human.sec_hud_set_security_status()
					break

		if ("add_comment")
			if (!istype(active_record_security, /datum/data/record) || !sanity_check(params["ref"]))
				return

			var/input = tgui_input_text(usr, "Your name and time will be added to this new comment", "New Comment", multiline = TRUE)
			if (!input || !istype(active_record_security, /datum/data/record) || !sanity_check(params["ref"]))
				return

			var/created_at = text("[]&nbsp;&nbsp;[]&nbsp;&nbsp;[]", time2text(world.realtime, "MMM DD"), time2text(world.time, "[worldtime2text()]:ss"), game_year)

			var/created_by_name = ""
			var/created_by_rank = ""
			if(istype(usr, /mob/living/carbon/human))
				var/mob/living/carbon/human/human = usr
				created_by_name = human.get_authentification_name()
				created_by_rank = human.get_assignment()
			else if(istype(usr, /mob/living/silicon/robot))
				var/mob/living/silicon/robot/robot = usr
				created_by_name = robot.name
				created_by_rank = "[robot.modtype] [robot.braintype]"

			var/new_comment = list(
				"entry" = input,
				"created_by_name" = created_by_name,
				"created_by_rank" = created_by_rank,
				"created_at" = created_at,
				"deleted_by" = null,
				"deleted_at" = null
			)

			active_record_security.fields["comments"] += list(new_comment)

			to_chat(usr, text("You have added a new comment to the Security Record of [].", active_record_security.fields["name"]))

		if("edit_comment")
			if (!istype(active_record_security, /datum/data/record) || !sanity_check(params["ref"]))
				return

			var/old_content = active_record_security.fields["comments"][params["comment_id"]]["entry"]
			var/new_comment = tgui_input_text(usr, "Edit the comment", "Edit Comment", html_decode(old_content), multiline = TRUE)
			if (!new_comment || !istype(active_record_security, /datum/data/record) || !sanity_check(params["ref"]))
				return

			active_record_security.fields["comments"][params["comment_id"]]["entry"] = new_comment

		if("delete_comment")
			if (!active_record_security || !sanity_check(params["ref"]))
				return

			var/deleter = ""
			if (istype(usr, /mob/living/carbon/human))
				var/mob/living/carbon/human/human = usr
				deleter = "[human.get_authentification_name()] ([human.get_assignment()])"
			else if (istype(usr, /mob/living/silicon/robot))
				var/mob/living/silicon/robot/robot = usr
				deleter = "[robot.name] ([robot.modtype] [robot.braintype])"

			var/deleted_at = text("[]&nbsp;&nbsp;[]&nbsp;&nbsp;[]", time2text(world.realtime, "MMM DD"), time2text(world.time, "[worldtime2text()]:ss"), game_year)

			active_record_security.fields["comments"][params["comment_id"]]["deleted_by"] = deleter
			active_record_security.fields["comments"][params["comment_id"]]["deleted_at"] = deleted_at

			to_chat(usr, text("You have deleted a comment from the Security Record of [].", active_record_security.fields["name"]))

		if ("print_active_record")
			if (!istype(active_record_general, /datum/data/record))
				return

			print_active_record()

		if ("eject_fingerprint_scanner")
			if (!scanner)
				return

			scanner.forceMove(get_turf(src))
			scanner = null
			update_static_data_for_all_viewers()

		if ("print_fingerprint_report")
			if (!scanner || !length(scanner.print_list))
				return

			var/obj/item/paper/fingerprint/print_paper = new /obj/item/paper/fingerprint(src, null, scanner.print_list)
			print_paper.forceMove(loc)
			var/refkey = ""
			for(var/obj/effect/decal/prints/print as anything in scanner.print_list)
				refkey += print.criminal_name
			print_paper.name = "fingerprint report ([md5(refkey)])"
			playsound(loc, 'sound/machines/twobeep.ogg', 15, 1)

		if ("wipe_fingerprint_scanner")
			if (!scanner || !length(scanner.print_list))
				return

			QDEL_NULL_LIST(scanner.print_list)
			scanner.update_icon()
			scanner.forceMove(get_turf(src))
			scanner = null
			update_static_data_for_all_viewers()

	add_fingerprint(usr)
	updateUsrDialog()
	. = TRUE

/obj/structure/machinery/computer/secure_data/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "SecurityRecords", "Security Records")
		ui.open()
		ui.set_autoupdate(FALSE)

/obj/structure/machinery/computer/secure_data/attack_hand(mob/user as mob)
	if(..() || inoperable())
		to_chat(user, SPAN_INFO("It does not appear to be working."))
		return

	if(!allowed(usr))
		to_chat(user, SPAN_WARNING("Access denied."))
		return

	if(!is_mainship_level(z))
		to_chat(user, SPAN_DANGER("<b>Unable to establish a connection</b>: \black You're too far away from the station!"))
		return

	tgui_interact(user)

/obj/structure/machinery/computer/secure_data/emp_act(severity)
	if(inoperable())
		..(severity)
		return

	for(var/datum/data/record/record as anything in GLOB.data_core.security)
		if(prob(10 / severity))
			switch(rand(1, 6))
				if(1)
					record.fields["name"] = "[pick(pick(first_names_male), pick(first_names_female))] [pick(last_names)]"
				if(2)
					record.fields["sex"] = pick("male", "female")
				if(3)
					record.fields["age"] = rand(5, 85)
				if(4)
					record.fields["criminal"] = pick(WANTED_STATUSES)
				if(5)
					record.fields["p_stat"] = pick("*Unconcious*", "Active", "Physically Unfit")
				if(6)
					record.fields["m_stat"] = pick("*Insane*", "*Unstable*", "*Watch*", "Stable")
			continue

		else if(prob(1))
			GLOB.data_core.security -= record
			qdel(record)
			continue

	..(severity)

/obj/structure/machinery/computer/secure_data/proc/print_active_record()
	var/obj/item/paper/paper = new /obj/item/paper(loc)
	paper.name = text("Security Record ([])", active_record_general.fields["name"])
	paper.info = "<CENTER><B>Security Record</B></CENTER><BR>"
	paper.info += text("Name: []<br />\nID: []<br />\nSex: []<br />\nAge: []<br />\nRank: []<br />\nPhysical Status: []<br />\nMental Status: []<br />", active_record_general.fields["name"], active_record_general.fields["id"], active_record_general.fields["sex"], active_record_general.fields["age"], active_record_general.fields["rank"], active_record_general.fields["p_stat"], active_record_general.fields["m_stat"])

	if (istype(active_record_security, /datum/data/record))
		paper.info += text("Criminal Status: []<br />", active_record_security.fields["criminal"])

		paper.info += text("<BR>\n<CENTER><B>Incidents</B></CENTER><BR>\n")

		if (length(active_record_security.fields["incidents"]))
			var/incident_index = 0
			for (var/list/incident as anything in active_record_security.fields["incidents"])
				incident_index++

				paper.info += text("<b>Incident []:</b><br />", incident_index)

				for (var/charge in incident["crimes"])
					paper.info += text("[]<br />", charge)

				paper.info += text("<b>Notes:</b> <i>[]</i><br /><br />", incident["summary"])
		else
			paper.info += text("No incidents<br />")

		paper.info += text("<CENTER><B>Comments</B></CENTER><BR>\n")
		if (length(active_record_security.fields["comments"]))
			for (var/list/comment as anything in active_record_security.fields["comments"])
				paper.info += text("<b>[] / [] ([])</b><br />", comment["created_at"], comment["created_by_name"], comment["created_by_rank"])
				if (isnull(comment["deleted_by"]))
					paper.info += comment["entry"]
				else
					paper.info += text("<i>Comment deleted by [] at []</i>", comment["deleted_by"], comment["deleted_at"])
				paper.info += "<br /><br />"
		else
			paper.info += text("No comments<br />")

	else
		paper.info += "<br /><B>Security Record Lost!</B><BR>"
	paper.info += "</TT>"

	playsound(loc, 'sound/machines/twobeep.ogg', 15, 1)
	updateUsrDialog()

/obj/structure/machinery/computer/secure_data/proc/set_active_record_general(datum/data/record/record)
	if (active_record_general)
		UnregisterSignal(active_record_general, COMSIG_PARENT_QDELETING)

	active_record_general = record
	active_record_ref = null

	if (active_record_general)
		active_record_ref = "\ref[active_record_general]"
		RegisterSignal(active_record_general, COMSIG_PARENT_QDELETING, PROC_REF(clean_active_record_general))

/obj/structure/machinery/computer/secure_data/proc/set_active_record_security(datum/data/record/record)
	if (active_record_security)
		UnregisterSignal(active_record_security, COMSIG_PARENT_QDELETING)

	active_record_security = record

	if (active_record_security)
		RegisterSignal(active_record_security, COMSIG_PARENT_QDELETING, PROC_REF(clean_active_record_security))

// Handle record deletion.
/obj/structure/machinery/computer/secure_data/proc/clean_active_record_general()
	SIGNAL_HANDLER
	active_record_general = null
	active_record_ref = null
	update_static_data_for_all_viewers()

// Handle record deletion.
/obj/structure/machinery/computer/secure_data/proc/clean_active_record_security()
	SIGNAL_HANDLER
	active_record_security = null
	update_static_data_for_all_viewers()

// Check a record is still loaded, and it is the same one the player is referencing.
/obj/structure/machinery/computer/secure_data/proc/sanity_check(ref)
	return (active_record_ref && active_record_ref == ref)
