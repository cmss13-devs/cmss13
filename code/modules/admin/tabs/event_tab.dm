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
		to_chat(usr, "Error has occured, [faction] category is not found.")
		return

	var/datum/custom_event_info/CEI = GLOB.custom_event_info_list[faction]

	var/input = input(usr, "Enter the custom event message for \"[faction]\" category. Be descriptive. \nTo remove the event message, remove text and confirm.", "[faction] Event Message", CEI.msg) as message|null

	if(input == "" || !input)
		CEI.msg = ""
		message_staff("[key_name_admin(usr)] has removed the event message for \"[faction]\" category.")
		return

	CEI.msg = html_encode(input)
	message_staff("[key_name_admin(usr)] has changed the event message for \"[faction]\" category.")

	CEI.handle_event_info_update(faction)

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
		message_staff("Admin [key_name_admin(usr)] has enabled WY gun restrictions.")
	else
		to_chat(src, "<b>Disabled gun restrictions.</b>")
		message_staff("Admin [key_name_admin(usr)] has disabled WY gun restrictions.")
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
	var/custom_limit = 5000
	var/list/choices = list("Small Bomb", "Medium Bomb", "Big Bomb", "Custom Bomb")
	var/list/falloff_shape_choices = list("CANCEL", "Linear", "Exponential")
	var/choice = tgui_input_list(usr, "What size explosion would you like to produce?", "Drop Bomb", choices)
	switch(choice)
		if(null)
			return 0
		if("Small Bomb")
			explosion(epicenter, 1, 2, 3, 3)
		if("Medium Bomb")
			explosion(epicenter, 2, 3, 4, 4)
		if("Big Bomb")
			explosion(epicenter, 3, 5, 7, 5)
		if("Custom Bomb")
			var/power = input(src, "Power?", "Power?") as num
			if(!power)
				return

			var/falloff = input(src, "Falloff?", "Falloff?") as num
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
			cell_explosion(epicenter, power, falloff, explosion_shape)
			message_staff("[key_name(src, TRUE)] dropped a custom cell bomb with power [power], falloff [falloff] and falloff_shape [shape_choice]!")
	message_staff("[ckey] used 'Drop Bomb' at [epicenter.loc].")

/client/proc/cmd_admin_emp(atom/O as obj|mob|turf in world)
	set name = "EM Pulse"
	set category = "Admin.Fun"

	if(!check_rights(R_DEBUG|R_FUN))
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
	message_staff("[key_name_admin(usr)] created an EM PUlse ([heavy],[light]) at ([O.x],[O.y],[O.z])")
	return

/datum/admins/proc/admin_force_ERT_shuttle()
	set name = "Force ERT Shuttle"
	set desc = "Force Launch the ERT Shuttle."
	set category = "Admin.Shuttles"

	if (!SSticker.mode)
		return
	if(!check_rights(R_ADMIN))
		return

	var/tag = tgui_input_list(usr, "Which ERT shuttle should be force launched?", "Select an ERT Shuttle:", list("Distress", "Distress_PMC", "Distress_UPP", "Distress_Big"))
	if(!tag) return

	var/datum/shuttle/ferry/ert/shuttle = shuttle_controller.shuttles[tag]
	if(!shuttle || !istype(shuttle))
		message_staff("Warning: Distress shuttle not found. Aborting.")
		return

	if(shuttle.location) //in start zone in admin z level
		var/dock_id
		var/dock_list = list("Port", "Starboard", "Aft")
		if(shuttle.use_umbilical)
			dock_list = list("Port Hangar", "Starboard Hangar")
		var/dock_name = tgui_input_list(usr, "Where on the [MAIN_SHIP_NAME] should the shuttle dock?", "Select a docking zone:", dock_list)
		switch(dock_name)
			if("Port") dock_id = /area/shuttle/distress/arrive_2
			if("Starboard") dock_id = /area/shuttle/distress/arrive_1
			if("Aft") dock_id = /area/shuttle/distress/arrive_3
			if("Port Hangar") dock_id = /area/shuttle/distress/arrive_s_hangar
			if("Starboard Hangar") dock_id = /area/shuttle/distress/arrive_n_hangar
			else return
		for(var/datum/shuttle/ferry/ert/F in shuttle_controller.process_shuttles)
			if(F != shuttle)
				//other ERT shuttles already docked on almayer or about to be
				if(!F.location || F.moving_status != SHUTTLE_IDLE)
					if(F.area_station.type == dock_id)
						message_staff("Warning: That docking zone is already taken by another shuttle. Aborting.")
						return

		for(var/area/A in all_areas)
			if(A.type == dock_id)
				shuttle.area_station = A
				break

	if(!shuttle.can_launch())
		message_staff("Warning: Unable to launch this Distress shuttle at this moment. Aborting.")
		return

	shuttle.launch()

	message_staff("[key_name_admin(usr)] force launched a distress shuttle ([tag])")

/datum/admins/proc/admin_force_distress()
	set name = "Distress Beacon"
	set desc = "Call a distress beacon. This should not be done if the shuttle's already been called."
	set category = "Admin.Shuttles"

	if (!SSticker.mode)
		return

	if(!check_rights(R_FUN)) // Seems more like an event thing than an admin thing
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

	var/is_announcing = TRUE
	var/announce = alert(src, "Would you like to announce the distress beacon to the server population? This will reveal the distress beacon to all players.", "Announce distress beacon?", "Yes", "No")
	if(announce == "No")
		is_announcing = FALSE

	chosen_ert.activate(is_announcing)

	message_staff("[key_name_admin(usr)] admin-called a [choice == "Randomize" ? "randomized ":""]distress beacon: [chosen_ert.name]")

/datum/admins/proc/admin_force_evacuation()
	set name = "Trigger Evacuation"
	set desc = "Triggers emergency evacuation."
	set category = "Admin.Events"

	if(!SSticker.mode || !check_rights(R_ADMIN))
		return
	set_security_level(SEC_LEVEL_RED)
	EvacuationAuthority.initiate_evacuation()

	message_staff("[key_name_admin(usr)] forced an emergency evacuation.")

/datum/admins/proc/admin_cancel_evacuation()
	set name = "Cancel Evacuation"
	set desc = "Cancels emergency evacuation."
	set category = "Admin.Events"

	if(!SSticker.mode || !check_rights(R_ADMIN))
		return
	EvacuationAuthority.cancel_evacuation()

	message_staff("[key_name_admin(usr)] canceled an emergency evacuation.")

/datum/admins/proc/admin_force_selfdestruct()
	set name = "Self Destruct"
	set desc = "Trigger self destruct countdown. This should not be done if the self destruct has already been called."
	set category = "Admin.Events"

	if(!SSticker.mode || !check_rights(R_ADMIN) || get_security_level() == "delta")
		return

	if(alert(src, "Are you sure you want to do this?", "Confirmation", "Yes", "No") == "No")
		return

	set_security_level(SEC_LEVEL_DELTA)

	message_staff("[key_name_admin(usr)] admin-started self destruct stystem.")

/client/proc/view_faxes()
	set name = "View Faxes"
	set desc = "View faxes from this round"
	set category = "Admin.Events"

	if(!admin_holder)
		return

	var/answer = alert(src, "Which kind of faxes would you like to see?", "Faxes", "CL faxes", "USCM faxes", "Cancel")
	switch(answer)
		if("CL faxes")
			var/body = "<body>"

			for(var/text in CLFaxes)
				body += text
				body += "<br><br>"

			body += "<br><br></body>"
			show_browser(src, body, "Faxes from the CL", "clfaxviewer", "size=300x600")
		if("USCM faxes")
			var/body = "<body>"

			for(var/text in USCMFaxes)
				body += text
				body += "<br><br>"

			body += "<br><br></body>"
			show_browser(src, body, "Faxes from the USCM", "uscmfaxviewer", "size=300x600")
		if("Cancel")
			return

/client/proc/award_medal()
	if(!check_rights(R_ADMIN))
		return

	give_medal_award()

/client/proc/turn_everyone_into_primitives()
	var/random_names = FALSE
	if (alert(src, "Do you want to give everyone random numbered names?", "Confirmation", "Yes", "No") == "Yes")
		random_names = TRUE
	if (alert(src, "Are you sure you want to do this? It will laaag.", "Confirmation", "Yes", "No") == "No")
		return
	for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
		if(ismonkey(H))
			continue
		H.set_species(pick("Monkey", "Yiren", "Stok", "Farwa", "Neaera"))
		H.is_important = TRUE
		if(random_names)
			var/random_name = "[lowertext(H.species.name)] ([rand(1, 999)])"
			H.change_real_name(H, random_name)
			if(H.wear_id)
				var/obj/item/card/id/card = H.wear_id
				card.registered_name = H.real_name
				card.name = "[card.registered_name]'s ID Card ([card.assignment])"

	message_staff("Admin [key_name(usr)] has turned everyone into a primitive")

/client/proc/force_shuttle()
	set name = "Force Dropship"
	set desc = "Force a dropship to launch"
	set category = "Admin.Shuttles"

	var/tag = tgui_input_list(usr, "Which dropship should be force launched?", "Select a dropship:", list("Dropship 1", "Dropship 2"))
	if(!tag) return
	var/crash = 0
	switch(alert("Would you like to force a crash?", , "Yes", "No", "Cancel"))
		if("Yes") crash = 1
		if("No") crash = 0
		else return

	var/datum/shuttle/ferry/marine/dropship = shuttle_controller.shuttles[MAIN_SHIP_NAME + " " + tag]
	if(!dropship)
		to_chat(src, SPAN_DANGER("Error: Attempted to force a dropship launch but the shuttle datum was null. Code: MSD_FSV_DIN"))
		log_admin("Error: Attempted to force a dropship launch but the shuttle datum was null. Code: MSD_FSV_DIN")
		return

	if(crash && dropship.location != 1)
		switch(alert("Error: Shuttle is on the ground. Proceed with standard launch anyways?", , "Yes", "No"))
			if("Yes")
				dropship.process_state = WAIT_LAUNCH
				log_admin("[usr] ([usr.key]) forced a [dropship.iselevator? "elevator" : "shuttle"] using the Force Dropship verb")
			if("No")
				to_chat(src, SPAN_WARNING("Aborting shuttle launch."))
				return
	else if(crash)
		dropship.process_state = FORCE_CRASH
	else
		dropship.process_state = WAIT_LAUNCH

/client/proc/force_ground_shuttle()
	set name = "Force Ground Transport"
	set desc = "Force a ground transport vehicle to launch"
	set category = "Admin.Shuttles"

	var/tag = tgui_input_list(usr, "Which vehicle should be force launched?", "Select a dropship:", list("Transport 1"))
	if(!tag)
		return

	var/datum/shuttle/ferry/marine/dropship = shuttle_controller.shuttles["Ground" + " " + tag]
	if(!dropship)
		to_chat(src, SPAN_DANGER("Error: Attempted to force a dropship launch but the shuttle datum was null. Code: MSD_FSV_DIN_2</span>"))
		to_chat(src, SPAN_DANGER("This is expected if map != CORSAT.</span>"))
		log_admin("Error: Attempted to force a dropship launch but the shuttle datum was null. Code: MSD_FSV_DIN")
		return

	dropship.process_state = WAIT_LAUNCH

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
	var/customname = input(usr, "Pick a title for the announcement. Cancel for \"USCM Update\" title.", "Title") as text|null
	if(!customname)
		customname = "USCM Update"
	if(faction == FACTION_MARINE)
		for(var/obj/structure/machinery/computer/almayer_control/C in machines)
			if(!(C.inoperable()))
				var/obj/item/paper/P = new /obj/item/paper( C.loc )
				P.name = "'[command_name] Update.'"
				P.info = input
				P.update_icon()
				C.messagetitle.Add("[command_name] Update")
				C.messagetext.Add(P.info)

		if(alert("Press \"Yes\" if you want to announce it to ship crew and marines. Press \"No\" to keep it only as printed report on communication console.",,"Yes","No") == "Yes")
			if(alert("Do you want PMCs (not Death Squad) to see this announcement?",,"Yes","No") == "Yes")
				marine_announcement(input, customname, 'sound/AI/commandreport.ogg', faction)
			else
				marine_announcement(input, customname, 'sound/AI/commandreport.ogg', faction, FALSE)
	else
		marine_announcement(input, customname, 'sound/AI/commandreport.ogg', faction)

	message_staff("[key_name_admin(src)] has created a [faction] command report")
	log_admin("[key_name_admin(src)] [faction] command report: [input]")

/client/proc/cmd_admin_xeno_report()
	set name = "Report: Queen Mother"
	set desc = "Basically a command announcement, but only for selected Xenos Hive"
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

	message_staff("[key_name_admin(src)] has created a [hive_choice] Queen Mother report")
	log_admin("[key_name_admin(src)] Queen Mother ([hive_choice]): [input]")

/client/proc/cmd_admin_create_AI_report()
	set name = "Report: ARES Comms"
	set category = "Admin.Factions"

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return
	var/input = input(usr, "This is a standard message from the ship's AI. It uses Almayer General channel and won't be heard by humans without access to Almayer General channel (headset or intercom). Check with online staff before you send this. Do not use html.", "What?", "") as message|null
	if(!input)
		return FALSE

	for(var/obj/structure/machinery/computer/almayer_control/C in machines)
		if(!(C.inoperable()))
//			var/obj/item/paper/P = new /obj/item/paper(C.loc)//Don't need a printed copy currently.
//			P.name = "'[MAIN_AI_SYSTEM] Update.'"
//			P.info = input
//			P.update_icon()
			C.messagetitle.Add("[MAIN_AI_SYSTEM] Update")
			C.messagetext.Add(input)
			ai_announcement(input)
			message_staff("[key_name_admin(src)] has created an AI comms report")
			log_admin("AI comms report: [input]")
		else
			to_chat(usr, SPAN_WARNING("[MAIN_AI_SYSTEM] is not responding. It may be offline or destroyed."))

/client/proc/cmd_admin_create_AI_shipwide_report()
	set name = "Report: ARES Shipwide"
	set category = "Admin.Factions"

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return
	var/input = input(usr, "This is an announcement type message from the ship's AI. This will be announced to every conscious human on Almayer z-level. Be aware, this will work even if ARES unpowered/destroyed. Check with online staff before you send this.", "What?", "") as message|null
	if(!input)
		return FALSE

	for(var/obj/structure/machinery/computer/almayer_control/C in machines)
		if(!(C.inoperable()))
//			var/obj/item/paper/P = new /obj/item/paper(C.loc)//Don't need a printed copy currently.
//			P.name = "'[MAIN_AI_SYSTEM] Update.'"
//			P.info = input
//			P.update_icon()
			C.messagetitle.Add("[MAIN_AI_SYSTEM] Shipwide Update")
			C.messagetext.Add(input)

	shipwide_ai_announcement(input)
	message_staff("[key_name_admin(src)] has created an AI shipwide report")
	log_admin("[key_name_admin(src)] AI shipwide report: [input]")

/client/proc/cmd_admin_create_predator_report()
	set name = "Report: Yautja AI"
	set category = "Admin.Factions"

	if(!admin_holder || !(admin_holder.rights & R_MOD))
		to_chat(src, "Only administrators may use this command.")
		return
	var/input = input(usr, "This is a message from the predator ship's AI. Check with online staff before you send this.", "What?", "") as message|null
	if(!input)
		return FALSE
	yautja_announcement(SPAN_YAUTJABOLDBIG(input))
	message_staff("[key_name_admin(src)] has created a predator ship AI report")
	log_admin("[key_name_admin(src)] predator ship AI report: [input]")

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
	message_staff("\bold GlobalNarrate: [key_name_admin(usr)] : [msg]")


/client
	var/remote_control = FALSE

/client/proc/toogle_door_control()
	set name = "Toggle Remote Control"
	set category = "Admin.Events"

	if(!check_rights(R_FUN))
		return

	remote_control = !remote_control
	message_staff("[key_name_admin(src)] has toggled remote control [remote_control? "on" : "off"] for themselves")

/client/proc/enable_event_mob_verbs()
	set name = "Mob Event Verbs - Show"
	set category = "Admin.Events"

	add_verb(src, admin_mob_event_verbs_hideable)
	remove_verb(src, /client/proc/enable_event_mob_verbs)

/client/proc/hide_event_mob_verbs()
	set name = "Mob Event Verbs - Hide"
	set category = "Admin.Events"

	remove_verb(src, admin_mob_event_verbs_hideable)
	add_verb(src, /client/proc/enable_event_mob_verbs)

// ----------------------------
// PANELS
// ----------------------------

/datum/admins/proc/event_panel()
	if(!check_rights(R_FUN,0))
		return

	var/dat = {"
		<B>Ship</B><BR>
		<A href='?src=\ref[src];events=securitylevel'>Set Security Level</A><BR>
		<A href='?src=\ref[src];events=distress'>Send a Distress Beacon</A><BR>
		<A href='?src=\ref[src];events=selfdestruct'>Activate Self-Destruct</A><BR>
		<A href='?src=\ref[src];events=evacuation_start'>Trigger Evacuation</A><BR>
		<A href='?src=\ref[src];events=evacuation_cancel'>Cancel Evacuation</A><BR>
		<BR>
		<B>Research</B><BR>
		<A href='?src=\ref[src];events=change_clearance'>Change Research Clearance</A><BR>
		<A href='?src=\ref[src];events=give_research_credits'>Give Research Credits</A><BR>
		<BR>
		<B>Power</B><BR>
		<A href='?src=\ref[src];events=unpower'>Unpower ship SMESs and APCs</A><BR>
		<A href='?src=\ref[src];events=power'>Power ship SMESs and APCs</A><BR>
		<A href='?src=\ref[src];events=quickpower'>Power ship SMESs</A><BR>
		<A href='?src=\ref[src];events=powereverything'>Power ALL SMESs and APCs everywhere</A><BR>
		<A href='?src=\ref[src];events=powershipreactors'>Power all ship reactors</A><BR>
		<BR>
		<B>Events</B><BR>
		<A href='?src=\ref[src];events=blackout'>Break all lights</A><BR>
		<A href='?src=\ref[src];events=whiteout'>Repair all lights</A><BR>
		<A href='?src=\ref[src];events=comms_blackout'>Trigger a Communication Blackout</A><BR>
		<BR>
		<B>Misc</B><BR>
		<A href='?src=\ref[src];events=medal'>Award a medal</A><BR>
		<A href='?src=\ref[src];events=pmcguns'>Toggle PMC gun restrictions</A><BR>
		<A href='?src=\ref[src];events=monkify'>Turn everyone into monkies</A><BR>
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
	if(!check_rights(R_MOD)) return

	var/dat
	if(check_rights(R_MOD,0))
		dat += {"<A href='?src=\ref[src];chem_panel=view_reagent'>View Reagent</A><br>
				"}
	if(check_rights(R_VAREDIT,0))
		dat += {"<A href='?src=\ref[src];chem_panel=view_reaction'>View Reaction</A><br>"}
		dat += {"<A href='?src=\ref[src];chem_panel=sync_filter'>Sync Reaction</A><br>
				<br>"}
	if(check_rights(R_SPAWN,0))
		dat += {"<A href='?src=\ref[src];chem_panel=spawn_reagent'>Spawn Reagent in Container</A><br>
				<A href='?src=\ref[src];chem_panel=make_report'>Make Chem Report</A><br>
				<br>"}
	if(check_rights(R_FUN,0))
		dat += {"<A href='?src=\ref[src];chem_panel=create_random_reagent'>Generate Reagent</A><br>
				<br>
				<A href='?src=\ref[src];chem_panel=create_custom_reagent'>Create Custom Reagent</A><br>
				<A href='?src=\ref[src];chem_panel=create_custom_reaction'>Create Custom Reaction</A><br>
				"}

	show_browser(usr, dat, "Chem Panel", "chempanel", "size=210x300")
	return

/client/proc/chem_panel()
	set name = "Chem Panel"
	set category = "Admin.Panels"
	if(admin_holder)
		admin_holder.chempanel()
	return

/datum/admins/var/create_humans_html = null
/datum/admins/proc/create_humans(var/mob/user)
	if(!GLOB.gear_presets_list)
		return

	if(!create_humans_html)
		var/equipment_presets = jointext(GLOB.gear_presets_list, ";")
		create_humans_html = file2text('html/create_humans.html')
		create_humans_html = replacetext(create_humans_html, "null /* object types */", "\"[equipment_presets]\"")

	show_browser(user, replacetext(create_humans_html, "/* ref src */", "\ref[src]"), "Create Humans", "create_humans", "size=450x630")

/client/proc/create_humans()
	set name = "Create Humans"
	set category = "Admin.Events"
	if(admin_holder)
		admin_holder.create_humans(usr)
	return

/client/proc/clear_mutineers()
	set name = "Clear All Mutineers"
	set category = "Admin.Events"
	if(admin_holder)
		admin_holder.clear_mutineers()
	return

/datum/admins/proc/clear_mutineers()
	if(!check_rights(R_MOD))
		return

	if(alert(usr, "Are you sure you want to change all mutineers back to normal?", "Confirmation", "Yes", "No") == "No")
		return

	for(var/mob/living/carbon/human/H in GLOB.human_mob_list)
		if(H && H.faction == FACTION_MUTINEER)
			H.faction = FACTION_MARINE
			H.hud_set_squad()

			for(var/datum/action/human_action/activable/mutineer/A in H.actions)
				A.remove_from(H)

/client/proc/cmd_fun_fire_ob()
	set category = "Admin.Fun"
	set desc = "Fire an OB warhead at your current location."
	set name = "Fire OB"

	if(!check_rights(R_ADMIN))
		return

	if(alert("Are you SURE you want to do this? It will create an OB explosion!",, "Yes", "No") == "No") return

	// Select the warhead.
	var/list/warheads = subtypesof(/obj/structure/ob_ammo/warhead/)
	var/choice = tgui_input_list(usr, "Select the warhead:", "Warhead to use", warheads)
	var/obj/structure/ob_ammo/warhead/warhead = new choice
	var/turf/target = get_turf(usr.loc)
	message_staff("[key_name(usr)] has fired \an [warhead.name] at ([target.x],[target.y],[target.z]).")
	warhead.warhead_impact(target)
	QDEL_IN(warhead, OB_CRASHING_DOWN)
