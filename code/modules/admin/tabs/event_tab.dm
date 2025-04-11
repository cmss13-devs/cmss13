/client/proc/cmd_admin_change_custom_event()
	set name = "Setup Event Info"
	set category = "Admin.Events"

	if(!admin_holder)
		to_chat(usr, "Only administrators may use this command.")
		return

	if(!LAZYLEN(GLOB.custom_event_info_list))
		to_chat(usr, "custom_event_info_list is not initialized, tell a dev.")
		return

	var/list/temp_list = list()

	for(var/T in GLOB.custom_event_info_list)
		var/datum/custom_event_info/CEI = GLOB.custom_event_info_list[T]
		temp_list["[CEI.msg ? "(x) [CEI.faction]" : CEI.faction]"] = CEI.faction

	var/faction = tgui_input_list(usr, "Select faction. Ghosts will see only \"Global\" category message. Factions with event message set are marked with (x).", "Faction Choice", temp_list)
	if(!faction)
		return

	faction = temp_list[faction]

	if(!GLOB.custom_event_info_list[faction])
		to_chat(usr, "Error has occurred, [faction] category is not found.")
		return

	var/datum/custom_event_info/CEI = GLOB.custom_event_info_list[faction]

	var/input = input(usr, "Enter the custom event message for \"[faction]\" category. Be descriptive. \nTo remove the event message, remove text and confirm.", "[faction] Event Message", CEI.msg) as message|null
	if(isnull(input))
		return

	if(input == "" || !input)
		CEI.msg = ""
		message_admins("[key_name_admin(usr)] has removed the event message for \"[faction]\" category.")
		return

	CEI.msg = html_encode(input)
	message_admins("[key_name_admin(usr)] has changed the event message for \"[faction]\" category.")

	CEI.handle_event_info_update(faction)

/client/proc/get_whitelisted_clients()
	set name = "Find Whitelisted Players"
	set category = "Admin.Events"
	if(!admin_holder)
		return

	var/flag = tgui_input_list(src, "Which flag?", "Whitelist Flags", GLOB.bitfields["whitelist_status"])

	var/list/ckeys = list()
	for(var/client/test_client in GLOB.clients)
		if(test_client.check_whitelist_status(GLOB.bitfields["whitelist_status"][flag]))
			ckeys += test_client.ckey
	if(!length(ckeys))
		to_chat(src, SPAN_NOTICE("There are no players with that whitelist online"))
		return
	to_chat(src, SPAN_NOTICE("Whitelist holders: [ckeys.Join(", ")]."))

/client/proc/change_security_level()
	if(!check_rights(R_ADMIN))
		return
	var sec_level = input(usr, "It's currently code [get_security_level()].", "Select Security Level")  as null|anything in (list("green","blue","red","delta")-get_security_level())
	if(sec_level && alert("Switch from code [get_security_level()] to code [sec_level]?","Change security level?","Yes","No") == "Yes")
		set_security_level(seclevel2num(sec_level))
		log_admin("[key_name(usr)] changed the security level to code [sec_level].")

/client/proc/toggle_gun_restrictions()
	if(!admin_holder || !config)
		return

	if(CONFIG_GET(flag/remove_gun_restrictions))
		to_chat(src, "<b>Enabled gun restrictions.</b>")
		message_admins("Admin [key_name_admin(usr)] has enabled WY gun restrictions.")
	else
		to_chat(src, "<b>Disabled gun restrictions.</b>")
		message_admins("Admin [key_name_admin(usr)] has disabled WY gun restrictions.")
	CONFIG_SET(flag/remove_gun_restrictions, !CONFIG_GET(flag/remove_gun_restrictions))

/client/proc/togglebuildmodeself()
	set name = "Buildmode"
	set category = "Admin.Events"
	if(!check_rights(R_ADMIN))
		return

	if(src.mob)
		togglebuildmode(src.mob)

/client/proc/drop_bomb()
	set name = "Drop Bomb"
	set desc = "Cause an explosion of varying strength at your location."
	set category = "Admin.Fun"

	var/turf/epicenter = mob.loc
	handle_bomb_drop(epicenter)

/client/proc/handle_bomb_drop(atom/epicenter)
	var/custom_limit = 5000
	var/power_warn_threshold = 500
	var/falloff_warn_threshold = 0.05
	var/list/choices = list("Small Bomb", "Medium Bomb", "Big Bomb", "Custom Bomb")
	var/list/falloff_shape_choices = list("CANCEL", "Linear", "Exponential")
	var/choice = tgui_input_list(usr, "What size explosion would you like to produce?", "Drop Bomb", choices)
	var/datum/cause_data/cause_data = create_cause_data("divine intervention")
	switch(choice)
		if(null)
			return 0
		if("Small Bomb")
			explosion(epicenter, 1, 2, 3, 3, , , , cause_data)
		if("Medium Bomb")
			explosion(epicenter, 2, 3, 4, 4, , , , cause_data)
		if("Big Bomb")
			explosion(epicenter, 3, 5, 7, 5, , , , cause_data)
		if("Custom Bomb")
			var/power = tgui_input_number(src, "Power?", "Power?")
			if(!power)
				return

			var/falloff = tgui_input_number(src, "Falloff?", "Falloff?")
			if(!falloff)
				return

			var/shape_choice = tgui_input_list(src, "Select falloff shape?", "Select falloff shape", falloff_shape_choices)
			var/explosion_shape = EXPLOSION_FALLOFF_SHAPE_LINEAR
			switch(shape_choice)
				if("CANCEL")
					return 0
				if("Exponential")
					explosion_shape = EXPLOSION_FALLOFF_SHAPE_EXPONENTIAL

			if(power > custom_limit)
				return

			if((power >= power_warn_threshold) && ((1 / (power / falloff)) <= falloff_warn_threshold) && (explosion_shape == EXPLOSION_FALLOFF_SHAPE_LINEAR)) // The lag can be a bit situational, but a large-power explosion with minimal (linear) falloff can absolutely bring the server to a halt in certain cases.
				if(tgui_input_list(src, "This bomb has the potential to lag the server. Are you sure you wish to drop it?", "Drop confirm", list("Yes", "No")) != "Yes")
					return

			cell_explosion(epicenter, power, falloff, explosion_shape, null, cause_data)
			message_admins("[key_name(src, TRUE)] dropped a custom cell bomb with power [power], falloff [falloff] and falloff_shape [shape_choice]!")
	message_admins("[ckey] used 'Drop Bomb' at [epicenter.loc].")


/client/proc/cmd_admin_emp(atom/O as obj|mob|turf in world)
	set name = "EM Pulse"
	set category = "Admin.Fun"

	if(!check_rights(R_DEBUG|R_ADMIN))
		return

	var/heavy = input("Range of heavy pulse.", text("Input"))  as num|null
	if(heavy == null)
		return
	var/light = input("Range of light pulse.", text("Input"))  as num|null
	if(light == null)
		return

	if(!heavy && !light)
		return

	empulse(O, heavy, light)
	message_admins("[key_name_admin(usr)] created an EM PUlse ([heavy],[light]) at ([O.x],[O.y],[O.z])")
	return

/datum/admins/proc/admin_force_ERT_shuttle()
	set name = "Force ERT Shuttle"
	set desc = "Force Launch the ERT Shuttle."
	set category = "Admin.Shuttles"

	if (!SSticker.mode)
		return
	if(!check_rights(R_EVENT))
		return

	var/list/shuttle_map = list()
	for(var/obj/docking_port/mobile/emergency_response/ert_shuttles in SSshuttle.mobile)
		shuttle_map[ert_shuttles.name] = ert_shuttles.id
	var/tag = tgui_input_list(usr, "Which ERT shuttle should be force launched?", "Select an ERT Shuttle:", shuttle_map)
	if(!tag)
		return

	var/shuttleId = shuttle_map[tag]
	var/list/docks = SSshuttle.stationary
	var/list/targets = list()
	var/list/target_names = list()
	var/obj/docking_port/mobile/emergency_response/ert = SSshuttle.getShuttle(shuttleId)
	for(var/obj/docking_port/stationary/emergency_response/dock in docks)
		var/can_dock = ert.canDock(dock)
		if(can_dock == SHUTTLE_CAN_DOCK)
			targets += list(dock)
			target_names +=  list(dock.name)
	var/dock_name = tgui_input_list(usr, "Where on the [MAIN_SHIP_NAME] should the shuttle dock?", "Select a docking zone:", target_names)
	var/launched = FALSE
	if(!dock_name)
		return
	for(var/obj/docking_port/stationary/emergency_response/dock as anything in targets)
		if(dock.name == dock_name)
			var/obj/docking_port/stationary/target = SSshuttle.getDock(dock.id)
			ert.request(target)
			launched=TRUE
	if(!launched)
		to_chat(usr, SPAN_WARNING("Unable to launch this Distress shuttle at this moment. Aborting."))
		return

	message_admins("[key_name_admin(usr)] force launched a distress shuttle ([tag])")

/datum/admins/proc/admin_force_distress()
	set name = "Distress Beacon"
	set desc = "Call a distress beacon. This should not be done if the shuttle's already been called."
	set category = "Admin.Shuttles"

	if (!SSticker.mode)
		return

	if(!check_rights(R_EVENT)) // Seems more like an event thing than an admin thing
		return

	var/list/list_of_calls = list()
	var/list/assoc_list = list()

	for(var/datum/emergency_call/L in SSticker.mode.all_calls)
		if(L && L.name != "name")
			list_of_calls += L.name
			assoc_list += list(L.name = L)
	list_of_calls = sortList(list_of_calls)

	list_of_calls += "Randomize"

	var/choice = tgui_input_list(usr, "Which distress call?", "Distress Signal", list_of_calls)

	if(!choice)
		return

	var/datum/emergency_call/chosen_ert
	if(choice == "Randomize")
		chosen_ert = SSticker.mode.get_random_call()
	else
		var/datum/emergency_call/em_call = assoc_list[choice]
		chosen_ert = new em_call.type()

	if(!istype(chosen_ert))
		return
	var/quiet_launch = TRUE
	var/ql_prompt = tgui_alert(usr, "Would you like to broadcast the beacon launch? This will reveal the distress beacon to all players.", "Announce distress beacon?", list("Yes", "No"), 20 SECONDS)
	if(ql_prompt == "Yes")
		quiet_launch = FALSE

	var/announce_receipt = FALSE
	var/ar_prompt = tgui_alert(usr, "Would you like to announce the beacon received message? This will reveal the distress beacon to all players.", "Announce beacon received?", list("Yes", "No"), 20 SECONDS)
	if(ar_prompt == "Yes")
		announce_receipt = TRUE

	var/turf/override_spawn_loc
	var/prompt = tgui_alert(usr, "Spawn at their assigned spawn, or at your location?", "Spawnpoint Selection", list("Spawn", "Current Location"), 0)
	if(!prompt)
		qdel(chosen_ert)
		return
	if(prompt == "Current Location")
		override_spawn_loc = get_turf(usr)

	chosen_ert.activate(quiet_launch, announce_receipt, override_spawn_loc)

	message_admins("[key_name_admin(usr)] admin-called a [choice == "Randomize" ? "randomized ":""]distress beacon: [chosen_ert.name]")

/datum/admins/proc/admin_force_evacuation()
	set name = "Trigger Evacuation"
	set desc = "Triggers emergency evacuation."
	set category = "Admin.Events"

	if(!SSticker.mode || !check_rights(R_ADMIN))
		return
	set_security_level(SEC_LEVEL_RED)
	SShijack.initiate_evacuation()

	message_admins("[key_name_admin(usr)] forced an emergency evacuation.")

/datum/admins/proc/admin_cancel_evacuation()
	set name = "Cancel Evacuation"
	set desc = "Cancels emergency evacuation."
	set category = "Admin.Events"

	if(!SSticker.mode || !check_rights(R_ADMIN))
		return
	SShijack.cancel_evacuation()

	message_admins("[key_name_admin(usr)] canceled an emergency evacuation.")

/datum/admins/proc/add_req_points()
	set name = "Add Requisitions Points"
	set desc = "Add points to the ship requisitions department."
	set category = "Admin.Events"
	if(!SSticker.mode || !check_rights(R_ADMIN))
		return

	var/points_to_add = tgui_input_real_number(usr, "Enter the amount of points to give, or a negative number to subtract. 1 point = $100.", "Points", 0)
	if(!points_to_add)
		return
	else if((GLOB.supply_controller.points + points_to_add) < 0)
		GLOB.supply_controller.points = 0
	else if((GLOB.supply_controller.points + points_to_add) > 99999)
		GLOB.supply_controller.points = 99999
	else
		GLOB.supply_controller.points += points_to_add


	message_admins("[key_name_admin(usr)] granted requisitions [points_to_add] points.")
	if(points_to_add >= 0)
		shipwide_ai_announcement("Additional Supply Budget has been authorised for this operation.")
	message_admins("[key_name_admin(usr)] granted UPP requisitions [points_to_add] points.")

/datum/admins/proc/add_upp_req_points()
	set name = "Add UPP Requisitions Points"
	set desc = "Add points to the UPP ship requisitions department."
	set category = "Admin.Events"
	if(!SSticker.mode || !check_rights(R_ADMIN))
		return

	var/points_to_add = tgui_input_real_number(usr, "Enter the amount of points to give, or a negative number to subtract. 1 point = $100.", "Points", 0)
	if(!points_to_add)
		return
	else if((GLOB.supply_controller_upp.points + points_to_add) < 0)
		GLOB.supply_controller_upp.points = 0
	else if((GLOB.supply_controller_upp.points + points_to_add) > 99999)
		GLOB.supply_controller_upp.points = 99999
	else
		GLOB.supply_controller.points += points_to_add
	message_admins("[key_name_admin(usr)] granted UPP requisitions [points_to_add] points.")


/datum/admins/proc/check_req_heat()
	set name = "Check Requisitions Heat"
	set desc = "Check how close the CMB is to arriving to search Requisitions."
	set category = "Admin.Events"
	if(!SSticker.mode || !check_rights(R_ADMIN))
		return

	var/req_heat_change = tgui_input_real_number(usr, "Set the new requisitions black market heat. ERT is called at 100, disabled at -1. Current Heat: [GLOB.supply_controller.black_market_heat]", "Modify Req Heat", 0, 100, -1)
	if(!req_heat_change)
		return

	GLOB.supply_controller.black_market_heat = req_heat_change
	message_admins("[key_name_admin(usr)] set requisitions heat to [req_heat_change].")


/datum/admins/proc/admin_force_selfdestruct()
	set name = "Self-Destruct"
	set desc = "Trigger self-destruct countdown. This should not be done if the self-destruct has already been called."
	set category = "Admin.Events"

	if(!SSticker.mode || !check_rights(R_ADMIN) || get_security_level() == "delta")
		return

	if(alert(src, "Are you sure you want to do this?", "Confirmation", "Yes", "No") != "Yes")
		return

	set_security_level(SEC_LEVEL_DELTA)

	message_admins("[key_name_admin(usr)] admin-started self-destruct system.")

/client/proc/view_faxes()
	set name = "Reply to Faxes"
	set desc = "View faxes from this round"
	set category = "Admin.Events"

	if(!admin_holder)
		return

	var/list/options = list(
		"Weyland-Yutani", "High Command", "Provost", "Press",
		"Colonial Marshal Bureau", "Union of Progressive Peoples",
		"Three World Empire", "Colonial Liberation Front",
		"Other", "Cancel")
	var/answer = tgui_input_list(src, "Which kind of faxes would you like to see?", "Faxes", options)
	switch(answer)
		if("Weyland-Yutani")
			var/body = "<body>"

			for(var/text in GLOB.WYFaxes)
				body += text
				body += "<br><br>"

			body += "<br><br></body>"
			show_browser(src, body, "Faxes to Weyland-Yutani", "wyfaxviewer", width = 300, height = 600)

		if("High Command")
			var/body = "<body>"

			for(var/text in GLOB.USCMFaxes)
				body += text
				body += "<br><br>"

			body += "<br><br></body>"
			show_browser(src, body, "Faxes to High Command", "uscmfaxviewer", width = 300, height = 600)

		if("Provost")
			var/body = "<body>"

			for(var/text in GLOB.ProvostFaxes)
				body += text
				body += "<br><br>"

			body += "<br><br></body>"
			show_browser(src, body, "Faxes to the Provost Office", "provostfaxviewer", width = 300, height = 600)

		if("Press")
			var/body = "<body>"

			for(var/text in GLOB.PressFaxes)
				body += text
				body += "<br><br>"

			body += "<br><br></body>"
			show_browser(src, body, "Faxes to Press organizations", "pressfaxviewer", width = 300, height = 600)

		if("Colonial Marshal Bureau")
			var/body = "<body>"

			for(var/text in GLOB.CMBFaxes)
				body += text
				body += "<br><br>"

			body += "<br><br></body>"
			show_browser(src, body, "Faxes to the Colonial Marshal Bureau", "cmbfaxviewer", width = 300, height = 600)

		if("Union of Progressive Peoples")
			var/body = "<body>"

			for(var/text in GLOB.UPPFaxes)
				body += text
				body += "<br><br>"

			body += "<br><br></body>"
			show_browser(src, body, "Faxes to the Union of Progressive Peoples", "uppfaxviewer", width = 300, height = 600)

		if("Three World Empire")
			var/body = "<body>"

			for(var/text in GLOB.TWEFaxes)
				body += text
				body += "<br><br>"

			body += "<br><br></body>"
			show_browser(src, body, "Faxes to the Three World Empire", "twefaxviewer", width = 300, height = 600)

		if("Colonial Liberation Front")
			var/body = "<body>"

			for(var/text in GLOB.CLFFaxes)
				body += text
				body += "<br><br>"

			body += "<br><br></body>"
			show_browser(src, body, "Faxes to the Colonial Liberation Front", "clffaxviewer", width = 300, height = 600)

		if("Other")
			var/body = "<body>"

			for(var/text in GLOB.GeneralFaxes)
				body += text
				body += "<br><br>"

			body += "<br><br></body>"
			show_browser(src, body, "Inter-machine Faxes", "otherfaxviewer", width = 300, height = 600)
		if("Cancel")
			return

/client/proc/award_medal()
	if(!check_rights(R_ADMIN))
		return

	give_medal_award(as_admin=TRUE)

/client/proc/award_jelly()
	if(!check_rights(R_ADMIN))
		return

	// Mostly replicated code from observer.dm.hive_status()
	var/list/hives = list()
	var/datum/hive_status/last_hive_checked

	var/datum/hive_status/hive
	for(var/hivenumber in GLOB.hive_datum)
		hive = GLOB.hive_datum[hivenumber]
		if(length(hive.totalXenos) > 0 || length(hive.total_dead_xenos) > 0)
			hives += list("[hive.name]" = hive.hivenumber)
			last_hive_checked = hive

	if(!length(hives))
		to_chat(src, SPAN_ALERT("There seem to be no hives at the moment."))
		return
	else if(length(hives) > 1) // More than one hive, display an input menu for that
		var/faction = tgui_input_list(src, "Select which hive to award", "Hive Choice", hives, theme="hive_status")
		if(!faction)
			to_chat(src, SPAN_ALERT("Hive choice error. Aborting."))
			return
		last_hive_checked = GLOB.hive_datum[hives[faction]]

	give_jelly_award(last_hive_checked, as_admin=TRUE)

/client/proc/give_nuke()
	if(!check_rights(R_ADMIN))
		return
	var/nukename = "Decrypted Operational Blockbuster"
	var/encrypt = tgui_alert(src, "Do you want the nuke to be already decrypted?", "Nuke Type", list("Encrypted", "Decrypted"), 20 SECONDS)
	if(encrypt == "Encrypted")
		nukename = "Encrypted Operational Blockbuster"
	var/prompt = tgui_alert(src, "THIS CAN BE USED TO END THE ROUND. Are you sure you want to spawn a nuke? The nuke will be put onto the ASRS Lift.", "DEFCON 1", list("No", "Yes"), 30 SECONDS)
	if(prompt != "Yes")
		return

	var/nuketype = GLOB.supply_packs_types[nukename]

	var/datum/supply_order/new_order = new()
	new_order.ordernum = GLOB.supply_controller.ordernum++
	new_order.objects = list(GLOB.supply_packs_datums[nuketype])
	new_order.orderedby = MAIN_AI_SYSTEM
	new_order.approvedby = MAIN_AI_SYSTEM
	GLOB.supply_controller.shoppinglist += new_order

	marine_announcement("A nuclear device has been supplied and will be delivered to requisitions via ASRS.", "NUCLEAR ARSENAL ACQUIRED", 'sound/misc/notice2.ogg')
	message_admins("[key_name_admin(usr)] admin-spawned \a [encrypt] nuke.")
	log_game("[key_name_admin(usr)] admin-spawned \a [encrypt] nuke.")

/client/proc/turn_everyone_into_primitives()
	var/random_names = FALSE
	if (alert(src, "Do you want to give everyone random numbered names?", "Confirmation", "Yes", "No") == "Yes")
		random_names = TRUE
	if (alert(src, "Are you sure you want to do this? It will laaag.", "Confirmation", "Yes", "No") != "Yes")
		return
	for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
		if(ismonkey(H))
			continue
		H.set_species(pick("Monkey", "Yiren", "Stok", "Farwa", "Neaera"))
		H.is_important = TRUE
		if(random_names)
			var/random_name = "[lowertext(H.species.name)] ([rand(1, 999)])"
			H.change_real_name(H, random_name)
			var/obj/item/card/id/card = H.get_idcard()
			if(card)
				card.registered_name = H.real_name
				card.name = "[card.registered_name]'s [card.id_type] ([card.assignment])"

	message_admins("Admin [key_name(usr)] has turned everyone into a primitive")

/client/proc/force_hijack()
	set name = "Force Hijack"
	set desc = "Force a dropship to be hijacked"
	set category = "Admin.Shuttles"

	var/list/shuttles = list(DROPSHIP_ALAMO, DROPSHIP_NORMANDY)
	var/tag = tgui_input_list(usr, "Which dropship should be force hijacked?", "Select a dropship:", shuttles)
	if(!tag)
		return

	var/obj/docking_port/mobile/marine_dropship/dropship = SSshuttle.getShuttle(tag)

	if(!dropship)
		to_chat(src, SPAN_DANGER("Error: Attempted to force a dropship hijack but the shuttle datum was null. Code: MSD_FSV_DIN"))
		log_admin("Error: Attempted to force a dropship hijack but the shuttle datum was null. Code: MSD_FSV_DIN")
		return

	var/confirm = tgui_alert(usr, "Are you sure you want to hijack [dropship]?", "Force hijack", list("Yes", "No")) == "Yes"
	if(!confirm)
		return

	var/obj/structure/machinery/computer/shuttle/dropship/flight/computer = dropship.getControlConsole()
	computer.hijack(usr, force = TRUE)

/client/proc/cmd_admin_create_centcom_report()
	set name = "Report: Faction"
	set category = "Admin.Factions"

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return
	var/faction = tgui_input_list(usr, "Please choose faction your announcement will be shown to.", "Faction Selection", (FACTION_LIST_HUMANOID - list(FACTION_YAUTJA) + list("Everyone (-Yautja)")))
	if(!faction)
		return
	var/input = input(usr, "Please enter announcement text. Be advised, this announcement will be heard both on Almayer and planetside by conscious humans of selected faction.", "What?", "") as message|null
	if(!input)
		return
	var/customname = input(usr, "Pick a title for the announcement. Confirm empty text for \"[faction] Update\" title.", "Title") as text|null
	if(isnull(customname))
		return
	if(!customname)
		customname = "[faction] Update"
	if(faction == FACTION_MARINE)
		for(var/obj/structure/machinery/computer/almayer_control/C in GLOB.machines)
			if(!(C.inoperable()))
				var/obj/item/paper/P = new /obj/item/paper( C.loc )
				P.name = "'[customname].'"
				P.info = input
				P.update_icon()
				C.messagetitle.Add("[customname]")
				C.messagetext.Add(P.info)

		if(alert("Press \"Yes\" if you want to announce it to ship crew and marines. Press \"No\" to keep it only as printed report on communication console.",,"Yes","No") == "Yes")
			if(alert("Do you want PMCs (not Death Squad) to see this announcement?",,"Yes","No") == "Yes")
				marine_announcement(input, customname, 'sound/AI/commandreport.ogg', faction, TRUE)
			else
				marine_announcement(input, customname, 'sound/AI/commandreport.ogg', faction, FALSE)
	else
		marine_announcement(input, customname, 'sound/AI/commandreport.ogg', faction)

	message_admins("[key_name_admin(src)] has created \a [faction] command report")
	log_admin("[key_name_admin(src)] [faction] command report: [input]")

/client/proc/cmd_admin_xeno_report()
	set name = "Report: Queen Mother"
	set desc = "Basically a command announcement, but only for selected Xeno's Hive"
	set category = "Admin.Factions"

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	var/list/hives = list()
	for(var/hivenumber in GLOB.hive_datum)
		var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
		hives += list("[hive.name]" = hive.hivenumber)

	hives += list("All Hives" = "everything")
	var/hive_choice = tgui_input_list(usr, "Please choose the hive you want to see your announcement. Selecting \"All hives\" option will change title to \"Unknown Higher Force\"", "Hive Selection", hives)
	if(!hive_choice)
		return FALSE

	var/hivenumber = hives[hive_choice]


	var/input = input(usr, "This should be a message from the ruler of the Xenomorph race.", "What?", "") as message|null
	if(!input)
		return FALSE

	var/hive_prefix = ""
	if(GLOB.hive_datum[hivenumber])
		var/datum/hive_status/hive = GLOB.hive_datum[hivenumber]
		hive_prefix = "[hive.prefix] "

	if(hivenumber == "everything")
		xeno_announcement(input, hivenumber, HIGHER_FORCE_ANNOUNCE)
	else
		xeno_announcement(input, hivenumber, SPAN_ANNOUNCEMENT_HEADER_BLUE("[hive_prefix][QUEEN_MOTHER_ANNOUNCE]"))

	message_admins("[key_name_admin(src)] has created a [hive_choice] Queen Mother report")
	log_admin("[key_name_admin(src)] Queen Mother ([hive_choice]): [input]")

/client/proc/cmd_admin_create_AI_report()
	set name = "Report: ARES Comms"
	set category = "Admin.Factions"

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return FALSE

	if(!ares_is_active())
		to_chat(usr, SPAN_WARNING("[MAIN_AI_SYSTEM] is destroyed, and cannot talk!"))
		return FALSE

	var/input = input(usr, "This is a standard message from the ship's AI. It uses Almayer General channel and won't be heard by humans without access to Almayer General channel (headset or intercom). Check with online staff before you send this. Do not use html.", "What?", "") as message|null
	if(!input)
		return FALSE

	if(!ares_can_interface())
		var/prompt = tgui_alert(src, "ARES interface processor is offline or destroyed, send the message anyways?", "Choose.", list("Yes", "No"), 20 SECONDS)
		if(prompt == "No")
			to_chat(usr, SPAN_WARNING("[MAIN_AI_SYSTEM] is not responding. It's interface processor may be offline or destroyed."))
			return FALSE

	ai_announcement(input)
	message_admins("[key_name_admin(src)] has created an AI comms report")
	log_admin("AI comms report: [input]")


/client/proc/cmd_admin_create_AI_apollo_report()
	set name = "Report: ARES Apollo"
	set category = "Admin.Factions"

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return FALSE

	if(!ares_is_active())
		to_chat(usr, SPAN_WARNING("[MAIN_AI_SYSTEM] is destroyed, and cannot talk!"))
		return FALSE

	var/input = tgui_input_text(usr, "This is a broadcast from the ship AI to Working Joes and Maintenance Drones. Do not use html.", "What?", "")
	if(!input)
		return FALSE

	if(!ares_can_apollo())
		var/prompt = tgui_alert(src, "ARES APOLLO processor is offline or destroyed, send the message anyways?", "Choose.", list("Yes", "No"), 20 SECONDS)
		if(prompt != "Yes")
			to_chat(usr, SPAN_WARNING("[MAIN_AI_SYSTEM] is not responding. It's APOLLO processor may be offline or destroyed."))
			return FALSE

	ares_apollo_talk(input)
	message_admins("[key_name_admin(src)] has created an AI APOLLO report")
	log_admin("AI APOLLO report: [input]")

/client/proc/cmd_admin_create_AI_shipwide_report()
	set name = "Report: ARES Shipwide"
	set category = "Admin.Factions"

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return
	var/input = input(usr, "This is an announcement type message from the ship's AI. This will be announced to every conscious human on Almayer z-level. Be aware, this will work even if ARES unpowered/destroyed. Check with online staff before you send this.", "What?", "") as message|null
	if(!input)
		return FALSE
	if(!ares_can_interface())
		var/prompt = tgui_alert(src, "ARES interface processor is offline or destroyed, send the message anyways?", "Choose.", list("Yes", "No"), 20 SECONDS)
		if(prompt == "No")
			to_chat(usr, SPAN_WARNING("[MAIN_AI_SYSTEM] is not responding. It's interface processor may be offline or destroyed."))
			return

	shipwide_ai_announcement(input)
	message_admins("[key_name_admin(src)] has created an AI shipwide report")
	log_admin("[key_name_admin(src)] AI shipwide report: [input]")

/client/proc/cmd_admin_create_predator_report()
	set name = "Report: Yautja Overseer"
	set category = "Admin.Factions"

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return
	var/input = tgui_input_text(usr, "This is a message from the Yautja Elder Overseer. They are not an AI, but they have witnessed everything that has happened this round through the eyes of all predators, both alive and dead. This message will appear on the screens of all living predator mobs. Check with online staff before sending.", "What Will The Elder Say?")
	if(!input)
		return FALSE
	elder_overseer_message(input, elder_user = "[key_name(src)]")

/client/proc/cmd_admin_world_narrate() // Allows administrators to fluff events a little easier -- TLE
	set name = "Narrate to Everyone"
	set category = "Admin.Events"

	if (!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	var/msg = input("Message:", text("Enter the text you wish to appear to everyone:")) as text

	if(!msg)
		return

	to_chat_spaced(world, html = SPAN_ANNOUNCEMENT_HEADER_BLUE(msg))
	message_admins("\bold GlobalNarrate: [key_name_admin(usr)] : [msg]")


/client
	var/remote_control = FALSE

/client/proc/toogle_door_control()
	set name = "Toggle Remote Control"
	set category = "Admin.Events"

	if(!check_rights(R_MOD|R_DEBUG))
		return

	remote_control = !remote_control
	message_admins("[key_name_admin(src)] has toggled remote control [remote_control? "on" : "off"] for themselves")

/client/proc/enable_event_mob_verbs()
	set name = "Mob Event Verbs - Show"
	set category = "Admin.Events"

	add_verb(src, GLOB.admin_mob_event_verbs_hideable)
	remove_verb(src, /client/proc/enable_event_mob_verbs)

/client/proc/hide_event_mob_verbs()
	set name = "Mob Event Verbs - Hide"
	set category = "Admin.Events"

	remove_verb(src, GLOB.admin_mob_event_verbs_hideable)
	add_verb(src, /client/proc/enable_event_mob_verbs)

// ----------------------------
// PANELS
// ----------------------------

/datum/admins/proc/event_panel()
	if(!check_rights(R_ADMIN,0))
		return

	var/dat = {"
		<B>Ship</B><BR>
		<A href='byond://?src=\ref[src];[HrefToken()];events=securitylevel'>Set Security Level</A><BR>
		<A href='byond://?src=\ref[src];[HrefToken()];events=distress'>Send a Distress Beacon</A><BR>
		<A href='byond://?src=\ref[src];[HrefToken()];events=selfdestruct'>Activate Self-Destruct</A><BR>
		<A href='byond://?src=\ref[src];[HrefToken()];events=evacuation_start'>Trigger Evacuation</A><BR>
		<A href='byond://?src=\ref[src];[HrefToken()];events=evacuation_cancel'>Cancel Evacuation</A><BR>
		<A href='byond://?src=\ref[src];[HrefToken()];events=disable_shuttle_console'>Disable Shuttle Control</A><BR>
		<A href='byond://?src=\ref[src];[HrefToken()];events=add_req_points'>Add Requisitions Points</A><BR>
		<A href='byond://?src=\ref[src];[HrefToken()];events=add_upp_req_points'>Add UPP Requisitions Points</A><BR>
		<A href='byond://?src=\ref[src];[HrefToken()];events=check_req_heat'>Modify Requisitions Heat</A><BR>
		<BR>
		<B>Research</B><BR>
		<A href='byond://?src=\ref[src];[HrefToken()];events=change_clearance'>Change Research Clearance</A><BR>
		<A href='byond://?src=\ref[src];[HrefToken()];events=give_research_credits'>Give Research Credits</A><BR>
		<BR>
		<B>Power</B><BR>
		<A href='byond://?src=\ref[src];[HrefToken()];events=unpower'>Unpower ship SMESs and APCs</A><BR>
		<A href='byond://?src=\ref[src];[HrefToken()];events=power'>Power ship SMESs and APCs</A><BR>
		<A href='byond://?src=\ref[src];[HrefToken()];events=quickpower'>Power ship SMESs</A><BR>
		<A href='byond://?src=\ref[src];[HrefToken()];events=powereverything'>Power ALL SMESs and APCs everywhere</A><BR>
		<A href='byond://?src=\ref[src];[HrefToken()];events=powershipreactors'>Repair and power all ship reactors</A><BR>
		<BR>
		<B>Events</B><BR>
		<A href='byond://?src=\ref[src];[HrefToken()];events=blackout'>Break all lights</A><BR>
		<A href='byond://?src=\ref[src];[HrefToken()];events=whiteout'>Repair all lights</A><BR>
		<A href='byond://?src=\ref[src];[HrefToken()];events=comms_blackout'>Trigger a Communication Blackout</A><BR>
		<A href='byond://?src=\ref[src];[HrefToken()];events=destructible_terrain'>Toggle destructible terrain</A><BR>
		<BR>
		<B>Misc</B><BR>
		<A href='byond://?src=\ref[src];[HrefToken()];events=medal'>Award a medal</A><BR>
		<A href='byond://?src=\ref[src];[HrefToken()];events=jelly'>Award a royal jelly</A><BR>
		<A href='byond://?src=\ref[src];[HrefToken()];events=nuke'>Spawn a nuke</A><BR>
		<A href='byond://?src=\ref[src];[HrefToken()];events=pmcguns'>Toggle PMC gun restrictions</A><BR>
		<A href='byond://?src=\ref[src];[HrefToken()];events=monkify'>Turn everyone into monkies</A><BR>
		<A href='byond://?src=\ref[src];[HrefToken()];events=xenothumbs'>Give or take opposable thumbs and gun permits from xenos</A><BR>
		<A href='byond://?src=\ref[src];[HrefToken()];events=xenocards'>Give or take card playing abilities from xenos</A><BR>
		<BR>
		"}

	show_browser(usr, dat, "Events Panel", "events")
	return

/client/proc/event_panel()
	set name = "Event Panel"
	set category = "Admin.Panels"
	if (admin_holder)
		admin_holder.event_panel()
	return


/datum/admins/proc/chempanel()
	if(!check_rights(R_MOD))
		return

	var/dat
	if(check_rights(R_MOD,0))
		dat += {"<A href='byond://?src=\ref[src];[HrefToken()];chem_panel=view_reagent'>View Reagent</A><br>
				"}
	if(check_rights(R_VAREDIT,0))
		dat += {"<A href='byond://?src=\ref[src];[HrefToken()];chem_panel=view_reaction'>View Reaction</A><br>"}
		dat += {"<A href='byond://?src=\ref[src];[HrefToken()];chem_panel=sync_filter'>Sync Reaction</A><br>
				<br>"}
	if(check_rights(R_SPAWN,0))
		dat += {"<A href='byond://?src=\ref[src];[HrefToken()];chem_panel=spawn_reagent'>Spawn Reagent in Container</A><br>
				<A href='byond://?src=\ref[src];[HrefToken()];chem_panel=make_report'>Make Chem Report</A><br>
				<br>"}
	if(check_rights(R_ADMIN,0))
		dat += {"<A href='byond://?src=\ref[src];[HrefToken()];chem_panel=create_random_reagent'>Generate Reagent</A><br>
				<br>
				<A href='byond://?src=\ref[src];[HrefToken()];chem_panel=create_custom_reagent'>Create Custom Reagent</A><br>
				<A href='byond://?src=\ref[src];[HrefToken()];chem_panel=create_custom_reaction'>Create Custom Reaction</A><br>
				"}

	show_browser(usr, dat, "Chem Panel", "chempanel", width = 210, height = 300)
	return

/client/proc/chem_panel()
	set name = "Chem Panel"
	set category = "Admin.Panels"
	if(admin_holder)
		admin_holder.chempanel()
	return

/datum/admins/var/create_humans_html = null
/datum/admins/proc/create_humans(mob/user)
	if(!GLOB.gear_name_presets_list)
		return

	if(!create_humans_html)
		var/equipment_presets = jointext(GLOB.gear_name_presets_list, ";")
		create_humans_html = file2text('html/create_humans.html')
		create_humans_html = replacetext(create_humans_html, "null /* object types */", "\"[equipment_presets]\"")
		create_humans_html = replacetext(create_humans_html, "/* href token */", RawHrefToken(forceGlobal = TRUE))

	show_browser(user, replacetext(create_humans_html, "/* ref src */", "\ref[src]"), "Create Humans", "create_humans", width = 450, height = 720)

/client/proc/create_humans()
	set name = "Create Humans"
	set category = "Admin.Events"
	if(admin_holder)
		admin_holder.create_humans(usr)

/datum/admins/var/create_xenos_html = null
/datum/admins/proc/create_xenos(mob/user)
	if(!create_xenos_html)
		var/hive_types = jointext(ALL_XENO_HIVES, ";")
		var/xeno_types = jointext(ALL_XENO_CASTES, ";")
		create_xenos_html = file2text('html/create_xenos.html')
		create_xenos_html = replacetext(create_xenos_html, "null /* hive paths */", "\"[hive_types]\"")
		create_xenos_html = replacetext(create_xenos_html, "null /* xeno paths */", "\"[xeno_types]\"")
		create_xenos_html = replacetext(create_xenos_html, "/* href token */", RawHrefToken(forceGlobal = TRUE))

	show_browser(user, replacetext(create_xenos_html, "/* ref src */", "\ref[src]"), "Create Xenos", "create_xenos", width = 450, height = 630)

/client/proc/create_xenos()
	set name = "Create Xenos"
	set category = "Admin.Events"
	if(admin_holder)
		admin_holder.create_xenos(usr)

/client/proc/clear_mutineers()
	set name = "Clear All Mutineers"
	set category = "Admin.Events"
	if(admin_holder)
		admin_holder.clear_mutineers()
	return

/datum/admins/proc/clear_mutineers()
	if(!check_rights(R_MOD))
		return

	if(alert(usr, "Are you sure you want to change all mutineers back to normal?", "Confirmation", "Yes", "No") != "Yes")
		return

	for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
		if(H.mob_flags & MUTINY_MUTINEER)
			H.mob_flags &= ~MUTINY_MUTINEER

			for(var/datum/action/human_action/activable/mutineer/A in H.actions)
				A.remove_from(H)

		H.mob_flags &= ~MUTINY_LOYALIST
		H.mob_flags &= ~MUTINY_NONCOMBAT
		H.hud_set_squad()

/client/proc/cmd_fun_fire_ob()
	set category = "Admin.Fun"
	set desc = "Fire an OB warhead at your current location."
	set name = "Fire OB"

	if(!check_rights(R_ADMIN))
		return

	var/list/firemodes = list("Standard Warhead", "Custom HE", "Custom Cluster", "Custom Incendiary")
	var/mode = tgui_input_list(usr, "Select fire mode:", "Fire mode", firemodes)
	// Select the warhead.
	var/obj/structure/ob_ammo/warhead/warhead
	var/statsmessage
	var/custom = TRUE
	switch(mode)
		if("Standard Warhead")
			custom = FALSE
			var/list/warheads = subtypesof(/obj/structure/ob_ammo/warhead/)
			var/choice = tgui_input_list(usr, "Select the warhead:", "Warhead to use", warheads)
			if(!choice)
				return
			warhead = new choice
		if("Custom HE")
			var/obj/structure/ob_ammo/warhead/explosive/OBShell = new
			OBShell.name = input("What name should the warhead have?", "Set name", "HE orbital warhead")
			if(!OBShell.name)
				return//null check to cancel
			OBShell.clear_power = tgui_input_number(src, "How much explosive power should the wall clear blast have?", "Set clear power", 1200, 3000)
			if(isnull(OBShell.clear_power))
				return
			OBShell.clear_falloff = tgui_input_number(src, "How much falloff should the wall clear blast have?", "Set clear falloff", 400)
			if(isnull(OBShell.clear_falloff))
				return
			OBShell.standard_power = tgui_input_number(src, "How much explosive power should the main blasts have?", "Set blast power", 600, 3000)
			if(isnull(OBShell.standard_power))
				return
			OBShell.standard_falloff = tgui_input_number(src, "How much falloff should the main blasts have?", "Set blast falloff", 30)
			if(isnull(OBShell.standard_falloff))
				return
			OBShell.clear_delay = tgui_input_number(src, "How much delay should the clear blast have?", "Set clear delay", 3)
			if(isnull(OBShell.clear_delay))
				return
			OBShell.double_explosion_delay = tgui_input_number(src, "How much delay should the clear blast have?", "Set clear delay", 6)
			if(isnull(OBShell.double_explosion_delay))
				return
			statsmessage = "Custom HE OB ([OBShell.name]) Stats from [key_name(usr)]: Clear Power: [OBShell.clear_power], Clear Falloff: [OBShell.clear_falloff], Clear Delay: [OBShell.clear_delay], Blast Power: [OBShell.standard_power], Blast Falloff: [OBShell.standard_falloff], Blast Delay: [OBShell.double_explosion_delay]."
			warhead = OBShell
		if("Custom Cluster")
			var/obj/structure/ob_ammo/warhead/cluster/OBShell = new
			OBShell.name = input("What name should the warhead have?", "Set name", "Cluster orbital warhead")
			if(!OBShell.name)
				return//null check to cancel
			OBShell.total_amount = tgui_input_number(src, "How many salvos should be fired?", "Set cluster number", 60)
			if(isnull(OBShell.total_amount))
				return
			OBShell.instant_amount = tgui_input_number(src, "How many shots per salvo? (Max 10)", "Set shot count", 3)
			if(isnull(OBShell.instant_amount))
				return
			if(OBShell.instant_amount > 10)
				OBShell.instant_amount = 10
			OBShell.explosion_power = tgui_input_number(src, "How much explosive power should the blasts have?", "Set blast power", 300, 1500)
			if(isnull(OBShell.explosion_power))
				return
			OBShell.explosion_falloff = tgui_input_number(src, "How much falloff should the blasts have?", "Set blast falloff", 150)
			if(isnull(OBShell.explosion_falloff))
				return
			statsmessage = "Custom Cluster OB ([OBShell.name]) Stats from [key_name(usr)]: Salvos: [OBShell.total_amount], Shot per Salvo: [OBShell.instant_amount], Explosion Power: [OBShell.explosion_power], Explosion Falloff: [OBShell.explosion_falloff]."
			warhead = OBShell
		if("Custom Incendiary")
			var/obj/structure/ob_ammo/warhead/incendiary/OBShell = new
			OBShell.name = input("What name should the warhead have?", "Set name", "Incendiary orbital warhead")
			if(!OBShell.name)
				return//null check to cancel
			OBShell.clear_power = tgui_input_number(src, "How much explosive power should the wall clear blast have?", "Set clear power", 1200, 3000)
			if(isnull(OBShell.clear_power))
				return
			OBShell.clear_falloff = tgui_input_number(src, "How much falloff should the wall clear blast have?", "Set clear falloff", 400)
			if(isnull(OBShell.clear_falloff))
				return
			OBShell.clear_delay = tgui_input_number(src, "How much delay should the clear blast have?", "Set clear delay", 3)
			if(isnull(OBShell.clear_delay))
				return
			OBShell.distance = tgui_input_number(src, "How many tiles radius should the fire be? (Max 30)", "Set fire radius", 18, 30)
			if(isnull(OBShell.distance))
				return
			if(OBShell.distance > 30)
				OBShell.distance = 30
			OBShell.fire_level = tgui_input_number(src, "How long should the fire last?", "Set fire duration", 70)
			if(isnull(OBShell.fire_level))
				return
			OBShell.burn_level = tgui_input_number(src, "How damaging should the fire be?", "Set fire strength", 80)
			if(isnull(OBShell.burn_level))
				return
			var/list/firetypes = list("white","blue","red","green","custom")
			OBShell.fire_type = tgui_input_list(usr, "Select the fire color:", "Fire color", firetypes)
			if(isnull(OBShell.fire_type))
				return
			OBShell.fire_color = null
			if(OBShell.fire_type == "custom")
				OBShell.fire_type = "dynamic"
				OBShell.fire_color = input(src, "Please select Fire color.", "Fire color") as color|null
				if(isnull(OBShell.fire_color))
					return
			statsmessage = "Custom Incendiary OB ([OBShell.name]) Stats from [key_name(usr)]: Clear Power: [OBShell.clear_power], Clear Falloff: [OBShell.clear_falloff], Clear Delay: [OBShell.clear_delay], Fire Distance: [OBShell.distance], Fire Duration: [OBShell.fire_level], Fire Strength: [OBShell.burn_level]."
			warhead = OBShell

	if(custom)
		if(!warhead)
			return
		if(alert(usr, statsmessage, "Confirm Stats", "Yes", "No") != "Yes")
			qdel(warhead)
			return
		message_admins(statsmessage)

	var/turf/target = get_turf(usr.loc)

	if(alert(usr, "Fire or Spawn Warhead?", "Mode", "Fire", "Spawn") == "Fire")
		if(alert("Are you SURE you want to do this? It will create an OB explosion!",, "Yes", "No") != "Yes")
			qdel(warhead)
			return

		message_admins("[key_name(usr)] has fired \an [warhead.name] at ([target.x],[target.y],[target.z]).")
		warhead.warhead_impact(target)

	else
		warhead.forceMove(target)

/client/proc/change_taskbar_icon()
	set name = "Set Taskbar Icon"
	set desc = "Change the taskbar icon to a preset list of selectable icons."
	set category = "Admin.Events"

	if(!check_rights(R_ADMIN))
		return

	var/taskbar_icon = tgui_input_list(usr, "Select an icon you want to appear on the player's taskbar.", "Taskbar Icon", GLOB.available_taskbar_icons)
	if(!taskbar_icon)
		return

	SSticker.mode.taskbar_icon = taskbar_icon
	SSticker.set_clients_taskbar_icon(taskbar_icon)
	message_admins("[key_name_admin(usr)] has changed the taskbar icon to [taskbar_icon].")

/client/proc/change_weather()
	set name = "Change Weather"
	set category = "Admin.Events"

	if(!check_rights(R_EVENT))
		return

	if(!SSweather.map_holder)
		to_chat(src, SPAN_WARNING("This map has no weather data."))
		return

	if(SSweather.is_weather_event_starting)
		to_chat(src, SPAN_WARNING("A weather event is already starting. Please wait."))
		return

	if(SSweather.is_weather_event)
		if(tgui_alert(src, "A weather event is already in progress! End it?", "Confirm", list("End", "Continue"), 10 SECONDS) == "Continue")
			return
		if(SSweather.is_weather_event)
			SSweather.end_weather_event()

	var/list/mappings = list()
	for(var/datum/weather_event/typepath as anything in subtypesof(/datum/weather_event))
		mappings[initial(typepath.name)] = typepath
	var/chosen_name = tgui_input_list(src, "Select a weather event to start", "Weather Selector", mappings)
	var/chosen_typepath = mappings[chosen_name]
	if(!chosen_typepath)
		return

	var/retval = SSweather.setup_weather_event(chosen_typepath)
	if(!retval)
		to_chat(src, SPAN_WARNING("Could not start the weather event at present!"))
		return
	to_chat(src, SPAN_BOLDNOTICE("Success! The weather event should start shortly."))


/client/proc/cmd_admin_create_bioscan()
	set name = "Report: Bioscan"
	set category = "Admin.Factions"

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return

	var/choice = tgui_alert(usr, "Are you sure you want to trigger a bioscan?", "Bioscan?", list("Yes", "No"))
	if(choice != "Yes")
		return
	else
		var/faction = tgui_input_list(usr, "What faction do you wish to provide a bioscan for?", "Bioscan Faction", list("Xeno","Marine","Yautja"), 20 SECONDS)
		var/variance = tgui_input_number(usr, "How variable do you want the scan to be? (+ or - an amount from truth)", "Variance", 2, 10, 0, 20 SECONDS)
		message_admins("BIOSCAN: [key_name(usr)] admin-triggered a bioscan for [faction].")
		GLOB.bioscan_data.get_scan_data()
		switch(faction)
			if("Xeno")
				GLOB.bioscan_data.qm_bioscan(variance)
			if("Marine")
				var/force_status = FALSE
				if(!ares_can_interface()) //proc checks if ARES is dead or if ARES cannot do announcements
					var/force_check = tgui_alert(usr, "ARES is currently unable to properly display and/or perform the Bioscan, do you wish to force ARES to display the bioscan?", "Display force", list("Yes", "No"), 20 SECONDS)
					if(force_check == "Yes")
						force_status = TRUE
				GLOB.bioscan_data.ares_bioscan(force_status, variance)
			if("Yautja")
				GLOB.bioscan_data.yautja_bioscan()

/client/proc/admin_blurb()
	set name = "Global Blurb Message"
	set category = "Admin.Events"

	if(!check_rights(R_ADMIN|R_DEBUG))
		return FALSE
	var/duration = 5 SECONDS
	var/message = "ADMIN TEST"
	var/text_input = tgui_input_text(usr, "Announcement message", "Message Contents", message, timeout = 5 MINUTES)
	if(!text_input)
		return // Early return here so people dont have to go through the whole process just to cancel it.
	message = text_input
	duration = tgui_input_number(usr, "Set the duration of the alert in deci-seconds.", "Duration", 5 SECONDS, 5 MINUTES, 5 SECONDS, 20 SECONDS)
	var/confirm = tgui_alert(usr, "Are you sure you wish to send '[message]' to all players for [(duration / 10)] seconds?", "Confirm", list("Yes", "No"), 20 SECONDS)
	if(confirm != "Yes")
		return FALSE
	show_blurb(GLOB.player_list, duration, message, TRUE, "center", "center", "#bd2020", "ADMIN")
	message_admins("[key_name(usr)] sent an admin blurb alert to all players. Alert reads: '[message]' and lasts [(duration / 10)] seconds.")
