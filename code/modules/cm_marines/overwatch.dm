#define MAX_SAVED_COORDINATES 3

#define HIDE_ALMAYER 2
#define HIDE_GROUND 1
#define HIDE_NONE 0

/obj/structure/machinery/computer/overwatch
	name = "Overwatch Console"
	desc = "State of the art machinery for giving orders to a squad."
	icon_state = "dummy"
	req_access = list(ACCESS_MARINE_DATABASE)
	unacidable = TRUE

	var/datum/squad/current_squad = null
	var/state = 0
	var/obj/structure/machinery/camera/cam = null
	var/list/network = list(CAMERA_NET_OVERWATCH)
	var/x_supply = 0
	var/y_supply = 0
	var/x_bomb = 0
	var/y_bomb = 0
	var/living_marines_sorting = FALSE
	var/busy = FALSE //The overwatch computer is busy launching an OB/SB, lock controls
	var/dead_hidden = FALSE //whether or not we show the dead marines in the squad
	var/z_hidden = 0 //which z level is ignored when showing marines.
	var/marine_filter = list() // individual marine hiding control - list of string references
	var/marine_filter_enabled = TRUE
	var/faction = FACTION_MARINE

	var/datum/tacmap/tacmap
	var/minimap_type = MINIMAP_FLAG_USCM

	var/list/saved_coordinates = list()

	//DELETE THIS
	var/tgui = TRUE

/obj/structure/machinery/computer/overwatch/Initialize()
	. = ..()
	tacmap = new(src, minimap_type)

/obj/structure/machinery/computer/overwatch/Destroy()
	QDEL_NULL(tacmap)
	return ..()

/obj/structure/machinery/computer/overwatch/attackby(obj/I as obj, mob/user as mob)  //Can't break or disassemble.
	return

/obj/structure/machinery/computer/overwatch/bullet_act(obj/item/projectile/Proj) //Can't shoot it
	return FALSE

/obj/structure/machinery/computer/overwatch/attack_remote(mob/user as mob)
	if(!ismaintdrone(user))
		return attack_hand(user)

/obj/structure/machinery/computer/overwatch/attack_hand(mob/user)
	if(..())  //Checks for power outages
		return

	if(istype(src, /obj/structure/machinery/computer/overwatch/almayer/broken))
		return

	if(!ishighersilicon(usr) && !skillcheck(user, SKILL_LEADERSHIP, SKILL_LEAD_EXPERT) && SSmapping.configs[GROUND_MAP].map_name != MAP_WHISKEY_OUTPOST)
		to_chat(user, SPAN_WARNING("You don't have the training to use [src]."))
		return

	if(tgui)
		tgui_interact(user)
		return

	user.set_interaction(src)
	var/dat = "<body>"

	if(!operator)
		dat += "<BR><B>Operator:</b> <A href='?src=\ref[src];operation=change_operator'>----------</A><BR>"
	else
		dat += "<BR><B>Operator:</b> <A href='?src=\ref[src];operation=change_operator'>[operator.name]</A><BR>"
		dat += "   <A href='?src=\ref[src];operation=logout'>Stop Overwatch</A><BR>"
		dat += "<hr>"

		switch(state)
			if(0) // Base menu
				dat += get_base_menu_text()
			if(1) //Info screen.
				dat += get_info_screen_text()
			if(2)
				dat += get_supply_drop_menu_text()
			if(3)
				dat += get_orbital_bombardment_control_text()

	show_browser(user, dat, "Overwatch Console", "overwatch", "size=550x550")
	return

/obj/structure/machinery/computer/overwatch/ui_static_data(mob/user)
	var/list/data = list()
	data["mapRef"] = tacmap.map_holder.map_ref
	return data

/obj/structure/machinery/computer/overwatch/tgui_interact(mob/user, datum/tgui/ui)
	if(!tacmap.map_holder)
		var/level = SSmapping.levels_by_trait(tacmap.targeted_ztrait)
		if(!level[1])
			return
		tacmap.map_holder = SSminimaps.fetch_tacmap_datum(level[1], tacmap.allowed_flags)

	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		user.client.register_map_obj(tacmap.map_holder.map)
		ui = new(user, src, "OverwatchConsole", "Overwatch Console")
		ui.open()

/obj/structure/machinery/computer/overwatch/ui_data(mob/user)
	var/list/data = list()

	data["squad_list"] = list()
	for(var/datum/squad/S in RoleAuthority.squads)
		if(S.active && !S.overwatch_officer && S.faction == faction && S.name != "Root")
			data["squad_list"] += S.name

	if(!current_squad)
		return data

	data["current_squad"] = current_squad.name

	data["primary_objective"] = current_squad.primary_objective
	data["secondary_objective"] = current_squad.secondary_objective

	data["marines"] = list()

	var/leader_count = 0
	var/ftl_count = 0
	var/spec_count = 0
	var/medic_count = 0
	var/engi_count = 0
	var/smart_count = 0
	var/marine_count = 0

	var/leaders_alive = 0
	var/ftl_alive = 0
	var/spec_alive= 0
	var/medic_alive= 0
	var/engi_alive = 0
	var/smart_alive = 0
	var/marines_alive = 0

	var/specialist_type

	var/SL_z //z level of the Squad Leader
	if(current_squad.squad_leader)
		var/turf/SL_turf = get_turf(current_squad.squad_leader)
		SL_z = SL_turf.z

	for(var/marine in current_squad.marines_list)
		if(!marine)
			continue //just to be safe
		var/mob_name = "unknown"
		var/mob_state = ""
		var/has_helmet = TRUE
		var/role = "unknown"
		var/acting_sl = ""
		var/fteam = ""
		var/distance = "???"
		var/area_name = "???"
		var/is_squad_leader = FALSE
		var/mob/living/carbon/human/marine_human


		if(ishuman(marine))
			marine_human = marine
			mob_name = marine_human.real_name
			var/area/current_area = get_area(marine_human)
			var/turf/current_turf = get_turf(marine_human)
			if(!current_turf)
				continue
			if(current_area)
				area_name = sanitize_area(current_area.name)

			switch(z_hidden)
				if(HIDE_ALMAYER)
					if(is_mainship_level(current_turf.z))
						continue
				if(HIDE_GROUND)
					if(is_ground_level(current_turf.z))
						continue

			if(marine_human.job)
				role = marine_human.job
			else if(istype(marine_human.wear_id, /obj/item/card/id)) //decapitated marine is mindless,
				var/obj/item/card/id/ID = marine_human.wear_id //we use their ID to get their role.
				if(ID.rank) role = ID.rank


			if(current_squad.squad_leader)
				if(marine_human == current_squad.squad_leader)
					distance = "N/A"
					if(current_squad.name == SQUAD_SOF)
						if(marine_human.job == JOB_MARINE_RAIDER_CMD)
							acting_sl = " (direct command)"
						else if(marine_human.job != JOB_MARINE_RAIDER_SL)
							acting_sl = " (acting TL)"
					else if(marine_human.job != JOB_SQUAD_LEADER)
						acting_sl = " (acting SL)"
					is_squad_leader = TRUE
				else if(current_turf && (current_turf.z == SL_z))
					distance = "[get_dist(marine_human, current_squad.squad_leader)] ([dir2text_short(get_dir(current_squad.squad_leader, marine_human))])"


			switch(marine_human.stat)
				if(CONSCIOUS)
					mob_state = "Conscious"

				if(UNCONSCIOUS)
					mob_state = "Unconscious"

				if(DEAD)
					mob_state = "Dead"

			if(!istype(marine_human.head, /obj/item/clothing/head/helmet/marine))
				has_helmet = FALSE

			if(!marine_human.key || !marine_human.client)
				if(marine_human.stat != DEAD)
					mob_state += " (SSD)"


			if(marine_human.assigned_fireteam)
				fteam = " [marine_human.assigned_fireteam]"

		else //listed marine was deleted or gibbed, all we have is their name
			for(var/datum/data/record/marine_record in GLOB.data_core.general)
				if(marine_record.fields["name"] == marine)
					role = marine_record.fields["real_rank"]
					break
			mob_state = "Dead"
			mob_name = marine


		switch(role)
			if(JOB_SQUAD_LEADER)
				leader_count++
				if(mob_state != "Dead")
					leaders_alive++
			if(JOB_SQUAD_TEAM_LEADER)
				ftl_count++
				if(mob_state != "Dead")
					ftl_alive++
			if(JOB_SQUAD_SPECIALIST)
				spec_count++
				if(istype(marine_human.wear_id, /obj/item/card/id)) //decapitated marine is mindless,
					var/obj/item/card/id/ID = marine_human.wear_id //we use their ID to get their role.
					if(ID.assignment)
						if(specialist_type)
							specialist_type = "MULTIPLE"
						else
							var/list/spec_type = splittext(ID.assignment, "(")
							if(islist(spec_type) && (length(spec_type) > 1))
								specialist_type = splittext(spec_type[2], ")")[1]

				if(mob_state != "Dead")
					spec_alive++
			if(JOB_SQUAD_MEDIC)
				medic_count++
				if(mob_state != "Dead")
					medic_alive++
			if(JOB_SQUAD_ENGI)
				engi_count++
				if(mob_state != "Dead")
					engi_alive++
			if(JOB_SQUAD_SMARTGUN)
				smart_count++
				if(mob_state != "Dead")
					smart_alive++
			if(JOB_SQUAD_MARINE)
				marine_count++
				if(mob_state != "Dead")
					marines_alive++

		var/marine_data = list(list("name" = mob_name, "state" = mob_state, "has_helmet" = has_helmet, "role" = role, "acting_sl" = acting_sl, "fteam" = fteam, "distance" = distance, "area_name" = area_name, "ref" = REF(marine)))
		data["marines"] += marine_data
		if(is_squad_leader)
			if(!data["squad_leader"])
				data["squad_leader"] = marine_data[1]

	data["total_deployed"] = leader_count + ftl_count + spec_count + medic_count + engi_count + smart_count + marine_count
	data["living_count"] = leaders_alive + ftl_alive + spec_alive + medic_alive + engi_alive + smart_alive + marines_alive

	data["leader_count"] = leader_count
	data["ftl_count"] = ftl_count
	data["spec_count"] = spec_count
	data["medic_count"] = medic_count
	data["engi_count"] = engi_count
	data["smart_count"] = smart_count

	data["leaders_alive"] = leaders_alive
	data["ftl_alive"] = ftl_alive
	data["spec_alive"] = spec_alive
	data["medic_alive"] = medic_alive
	data["engi_alive"] = engi_alive
	data["smart_alive"] = smart_alive
	data["specialist_type"] = specialist_type ? specialist_type : "NONE"

	data["z_hidden"] = z_hidden

	data["saved_coordinates"] = list()
	for(var/i=1, i < length(saved_coordinates) + 1, i++)
		data["saved_coordinates"] += list(list("x" = saved_coordinates[i]["x"], "y" = saved_coordinates[i]["y"], "comment" = saved_coordinates[i]["comment"], "index" = i))

	var/obj/structure/closet/crate/supply_crate = locate() in current_squad.drop_pad.loc
	data["has_crate_loaded"] = supply_crate
	data["supply_cooldown"] = COOLDOWN_TIMELEFT(current_squad, next_supplydrop)
	data["ob_cooldown"] = COOLDOWN_TIMELEFT(almayer_orbital_cannon, ob_firing_cooldown)
	data["ob_loaded"] = almayer_orbital_cannon.chambered_tray

	return data


/obj/structure/machinery/computer/overwatch/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	var/mob/user = usr

	switch(action)
		if("pick_squad")
			if(current_squad)
				return
			var/datum/squad/selected_squad
			for(var/datum/squad/searching_squad in RoleAuthority.squads)
				if(searching_squad.active && !searching_squad.overwatch_officer && searching_squad.faction == faction && searching_squad.name != "Root" && searching_squad.name == params["squad"])
					selected_squad = searching_squad
					break

			if(!selected_squad)
				return

			if(selected_squad.assume_overwatch(user))
				current_squad = selected_squad
				operator = user
				current_squad.send_squad_message("Attention - Your squad has been selected for Overwatch. Check your Status pane for objectives.", displayed_icon = src)
				current_squad.send_squad_message("Your Overwatch officer is: [operator.name].", displayed_icon = src)
				visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Tactical data for squad '[current_squad]' loaded. All tactical functions initialized.")]")
				return TRUE
		if("logout")
			if(current_squad?.release_overwatch())
				if(ishighersilicon(user))
					current_squad.send_squad_message("Attention. [operator.name] has released overwatch system control. Overwatch functions deactivated.", displayed_icon = src)
					to_chat(user, "[icon2html(src, user)] [SPAN_BOLDNOTICE("Overwatch system control override disengaged.")]")
				else
					var/mob/living/carbon/human/H = operator
					var/obj/item/card/id/ID = H.get_idcard()
					current_squad.send_squad_message("Attention. [ID ? "[ID.rank] ":""][operator ? "[operator.name]":"sysadmin"] is no longer your Overwatch officer. Overwatch functions deactivated.", displayed_icon = src)
					visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Overwatch systems deactivated. Goodbye, [ID ? "[ID.rank] ":""][operator ? "[operator.name]":"sysadmin"].")]")
			operator = null
			current_squad = null
			if(cam && !ishighersilicon(user))
				user.reset_view(null)
				user.UnregisterSignal(cam, COMSIG_PARENT_QDELETING)
			cam = null
			ui.close()
			return TRUE

		if("message")
			if(current_squad && operator == user)
				var/input = sanitize_control_chars(stripped_input(user, "Please write a message to announce to the squad:", "Squad Message"))
				if(input)
					current_squad.send_message(input, 1) //message, adds username
					current_squad.send_maptext(input, "Squad Message:")
					visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Message '[input]' sent to all Marines of squad '[current_squad]'.")]")
					log_overwatch("[key_name(user)] sent '[input]' to squad [current_squad].")

		if("sl_message")
			if(current_squad && operator == user)
				var/input = sanitize_control_chars(stripped_input(user, "Please write a message to announce to the squad leader:", "SL Message"))
				if(input)
					current_squad.send_message(input, 1, 1) //message, adds username, only to leader
					current_squad.send_maptext(input, "Squad Leader Message:", 1)
					visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Message '[input]' sent to Squad Leader [current_squad.squad_leader] of squad '[current_squad]'.")]")
					log_overwatch("[key_name(user)] sent '[input]' to Squad Leader [current_squad.squad_leader] of squad [current_squad].")

		if("check_primary")
			if(current_squad) //This is already checked, but ehh.
				if(current_squad.primary_objective)
					visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Reminding '[current_squad]' of primary objectives: [current_squad.primary_objective].")]")
					current_squad.send_message("Your primary objective is '[current_squad.primary_objective]'. See Status pane for details.")
					current_squad.send_maptext(current_squad.primary_objective, "Primary Objective:")

		if("check_secondary")
			if(current_squad) //This is already checked, but ehh.
				if(current_squad.secondary_objective)
					visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Reminding '[current_squad]' of secondary objectives: [current_squad.secondary_objective].")]")
					current_squad.send_message("Your secondary objective is '[current_squad.secondary_objective]'. See Status pane for details.")
					current_squad.send_maptext(current_squad.secondary_objective, "Secondary Objective:")

		if("set_primary")
			var/input = sanitize_control_chars(stripped_input(usr, "What will be the squad's primary objective?", "Primary Objective"))
			if(current_squad && input)
				current_squad.primary_objective = "[input] ([worldtime2text()])"
				current_squad.send_message("Your primary objective has been changed to '[input]'. See Status pane for details.")
				current_squad.send_maptext(input, "Primary Objective Updated:")
				visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Primary objective of squad '[current_squad]' set to '[input]'.")]")
				log_overwatch("[key_name(usr)] set [current_squad]'s primary objective to '[input]'.")
				return TRUE

		if("set_secondary")
			var/input = sanitize_control_chars(stripped_input(usr, "What will be the squad's secondary objective?", "Secondary Objective"))
			if(input)
				current_squad.secondary_objective = input + " ([worldtime2text()])"
				current_squad.send_message("Your secondary objective has been changed to '[input]'. See Status pane for details.")
				current_squad.send_maptext(input, "Secondary Objective Updated:")
				visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Secondary objective of squad '[current_squad]' set to '[input]'.")]")
				log_overwatch("[key_name(usr)] set [current_squad]'s secondary objective to '[input]'.")
				return TRUE
		if("replace_lead")
			if(!params["ref"])
				return
			change_lead_tgui(params["ref"])

		if("insubordination")
			mark_insubordination()
		if("squad_transfer")
			transfer_squad()

		if("change_locations_ignored")
			switch(z_hidden)
				if(HIDE_NONE)
					z_hidden = HIDE_ALMAYER
					to_chat(user, "[icon2html(src, usr)] [SPAN_NOTICE("Marines on the Almayer are now hidden.")]")
				if(HIDE_ALMAYER)
					z_hidden = HIDE_GROUND
					to_chat(user, "[icon2html(src, usr)] [SPAN_NOTICE("Marines on the ground are now hidden.")]")
				else
					z_hidden = HIDE_NONE
					to_chat(user, "[icon2html(src, usr)] [SPAN_NOTICE("No location is ignored anymore.")]")
		if("tacmap_unpin")
			tacmap.tgui_interact(user)
		if("dropbomb")
			if(!params["x"] || !params["y"])
				return
			x_bomb = text2num(params["x"])
			y_bomb = text2num(params["y"])
			if(almayer_orbital_cannon.is_disabled)
				to_chat(user, "[icon2html(src, usr)] [SPAN_WARNING("Orbital bombardment cannon disabled!")]")
			else if(!COOLDOWN_FINISHED(almayer_orbital_cannon, ob_firing_cooldown))
				to_chat(user, "[icon2html(src, usr)] [SPAN_WARNING("Orbital bombardment cannon not yet ready to fire again! Please wait [COOLDOWN_TIMELEFT(almayer_orbital_cannon, ob_firing_cooldown)/10] seconds.")]")
			else
				handle_bombard(user)

		if("dropsupply")
			if(!params["x"] || !params["y"])
				return
			x_supply = text2num(params["x"])
			y_supply = text2num(params["y"])
			if(current_squad)
				if(!COOLDOWN_FINISHED(current_squad, next_supplydrop))
					to_chat(user, "[icon2html(src, user)] [SPAN_WARNING("Supply drop not yet ready to launch again!")]")
				else
					handle_supplydrop()

		if("save_coordinates")
			if(!params["x"] || !params["y"])
				return
			if(length(saved_coordinates) >= MAX_SAVED_COORDINATES)
				popleft(saved_coordinates)
			saved_coordinates += list(list("x" = text2num(params["x"]), "y" = text2num(params["y"])))
		if("change_coordinate_comment")
			if(!params["index"] || !params["comment"])
				return
			var/index = text2num(params["index"])
			if(length(saved_coordinates) + 1 < index)
				return
			saved_coordinates[index]["comment"] = params["comment"]

		if("watch_camera")
			if(isRemoteControlling(user))
				to_chat(user, "[icon2html(src, user)] [SPAN_WARNING("Unable to override console camera viewer. Track with camera instead. ")]")
				return
			if(!params["target_ref"])
				return
			if(current_squad)
				var/mob/cam_target = locate(params["target_ref"])
				var/obj/structure/machinery/camera/new_cam = get_camera_from_target(cam_target)
				if(!new_cam || !new_cam.can_use())
					to_chat(user, "[icon2html(src, user)] [SPAN_WARNING("Searching for helmet cam. No helmet cam found for this marine! Tell your squad to put their helmets on!")]")
				else if(cam && cam == new_cam)//click the camera you're watching a second time to stop watching.
					visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Stopping helmet cam view of [cam_target].")]")
					user.UnregisterSignal(cam, COMSIG_PARENT_QDELETING)
					cam = null
					user.reset_view(null)
				else if(user.client.view != world_view_size)
					to_chat(user, SPAN_WARNING("You're too busy peering through binoculars."))
				else
					if(cam)
						user.UnregisterSignal(cam, COMSIG_PARENT_QDELETING)
					cam = new_cam
					user.reset_view(cam)
					user.RegisterSignal(cam, COMSIG_PARENT_QDELETING, TYPE_PROC_REF(/mob, reset_observer_view_on_deletion))

/obj/structure/machinery/computer/overwatch/proc/change_lead_tgui(sl_ref)
	if(!usr)
		return
	var/mob/user = usr

	if(!current_squad)
		return

	var/mob/living/carbon/human/selected_sl = locate(sl_ref) in current_squad.marines_list
	if(!selected_sl)
		return
	if(!istype(selected_sl))
		return

	if(!istype(selected_sl) || !selected_sl.mind || selected_sl.stat == DEAD) //marines_list replaces mob refs of gibbed marines with just a name string
		to_chat(user, "[icon2html(src, usr)] [SPAN_WARNING("[selected_sl] is KIA!")]")
		return
	if(selected_sl == current_squad.squad_leader)
		to_chat(user, "[icon2html(src, usr)] [SPAN_WARNING("[selected_sl] is already the Squad Leader!")]")
		return
	if(jobban_isbanned(selected_sl, JOB_SQUAD_LEADER))
		to_chat(user, "[icon2html(src, usr)] [SPAN_WARNING("[selected_sl] is unfit to lead!")]")
		return
	if(current_squad.squad_leader)
		current_squad.send_message("Attention: [current_squad.squad_leader] is [current_squad.squad_leader.stat == DEAD ? "stepping down" : "demoted"]. A new Squad Leader has been set: [selected_sl.real_name].")
		visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Squad Leader [current_squad.squad_leader] of squad '[current_squad]' has been [current_squad.squad_leader.stat == DEAD ? "replaced" : "demoted and replaced"] by [selected_sl.real_name]! Logging to enlistment files.")]")
		var/old_lead = current_squad.squad_leader
		current_squad.demote_squad_leader(current_squad.squad_leader.stat != DEAD)
		SStracking.start_tracking(current_squad.tracking_id, old_lead)
	else
		current_squad.send_message("Attention: A new Squad Leader has been set: [selected_sl.real_name].")
		visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("[selected_sl.real_name] is the new Squad Leader of squad '[current_squad]'! Logging to enlistment file.")]")

	to_chat(selected_sl, "[icon2html(src, selected_sl)] <font size='3' color='blue'><B>Overwatch: You've been promoted to \'[selected_sl.job == JOB_SQUAD_LEADER ? "SQUAD LEADER" : "ACTING SQUAD LEADER"]\' for [current_squad.name]. Your headset has access to the command channel (:v).</B></font>")
	to_chat(user, "[icon2html(src, usr)] [selected_sl.real_name] is [current_squad]'s new leader!")

	if(selected_sl.assigned_fireteam)
		if(selected_sl == current_squad.fireteam_leaders[selected_sl.assigned_fireteam])
			current_squad.unassign_ft_leader(selected_sl.assigned_fireteam, TRUE, FALSE)
		current_squad.unassign_fireteam(selected_sl, FALSE)

	current_squad.squad_leader = selected_sl
	current_squad.update_squad_leader()
	current_squad.update_free_mar()

	SStracking.set_leader(current_squad.tracking_id, selected_sl)
	SStracking.start_tracking("marine_sl", selected_sl)

	if(selected_sl.job == JOB_SQUAD_LEADER)//a real SL
		selected_sl.comm_title = "SL"
	else //an acting SL
		selected_sl.comm_title = "aSL"
	ADD_TRAIT(selected_sl, TRAIT_LEADERSHIP, TRAIT_SOURCE_SQUAD_LEADER)

	var/obj/item/device/radio/headset/almayer/marine/R = selected_sl.get_type_in_ears(/obj/item/device/radio/headset/almayer/marine)
	if(R)
		R.keys += new /obj/item/device/encryptionkey/squadlead/acting(R)
		R.recalculateChannels()
	if(istype(selected_sl.wear_id, /obj/item/card/id))
		var/obj/item/card/id/ID = selected_sl.wear_id
		ID.access += ACCESS_MARINE_LEADER
	selected_sl.hud_set_squad()
	selected_sl.update_inv_head() //updating marine helmet leader overlays
	selected_sl.update_inv_wear_suit()


/obj/structure/machinery/computer/overwatch/proc/get_base_menu_text()
	var/dat = ""

	if(!current_squad) //No squad has been set yet. Pick one.
		dat += "Current Squad: <A href='?src=\ref[src];operation=pick_squad'>----------</A><BR>"
		return dat;

	dat += "Current Squad: [current_squad.name] Squad</A>   "
	dat += "<A href='?src=\ref[src];operation=message'>Message Squad</a><br><br>"
	dat += "<A href='?src=\ref[src];operation=mapview'>Toggle Tactical Map</a>"
	dat += "<br><hr>"
	if(current_squad.squad_leader)
		dat += "<B>Squad Leader:</B> <A href='?src=\ref[src];operation=use_cam;cam_target=\ref[current_squad.squad_leader]'>[current_squad.squad_leader.name]</a> "
		dat += "<A href='?src=\ref[src];operation=sl_message'>MSG</a> "
		dat += "<A href='?src=\ref[src];operation=change_lead'>CHANGE SQUAD LEADER</a><BR><BR>"
	else
		dat += "<B>Squad Leader:</B> <font color=red>NONE</font> <A href='?src=\ref[src];operation=change_lead'>ASSIGN SQUAD LEADER</a><BR><BR>"

	dat += "<B>Primary Objective:</B> "
	if(current_squad.primary_objective)
		dat += "<A href='?src=\ref[src];operation=check_primary'>Check</A> <A href='?src=\ref[src];operation=set_primary'>Set</A><BR>"
	else
		dat += "<B><font color=red>NONE!</font></B> <A href='?src=\ref[src];operation=set_primary'>Set</A><BR>"
	dat += "<B>Secondary Objective:</B> "
	if(current_squad.secondary_objective)
		dat += "<A href='?src=\ref[src];operation=check_secondary'>Check</A> <A href='?src=\ref[src];operation=set_secondary'>Set</A><BR>"
	else
		dat += "<B><font color=red>NONE!</font></B> <A href='?src=\ref[src];operation=set_secondary'>Set</A><BR>"
	dat += "<BR>"
	dat += "<A href='?src=\ref[src];operation=insubordination'>Report a marine for insubordination</a><BR>"
	dat += "<A href='?src=\ref[src];operation=squad_transfer'>Transfer a marine to another squad</a><BR><BR>"

	dat += "<A href='?src=\ref[src];operation=supplies'>Supply Drop Control</a><BR>"
	dat += "<A href='?src=\ref[src];operation=bombs'>Orbital Bombardment Control</a><BR>"
	dat += "<A href='?src=\ref[src];operation=monitor'>Squad Monitor</a><br>"
	dat += "<hr>"
	dat += "<A href='?src=\ref[src];operation=refresh'>Refresh</a></Body>"

	return dat

/obj/structure/machinery/computer/overwatch/proc/get_info_screen_text()
	var/dat = ""

	dat += {"
	<script type="text/javascript">
		function updateSearch() {
			var filter_text = document.getElementById("filter");
			var filter = filter_text.value.toLowerCase();

			var marine_list = document.getElementById("marine_list");
			var ltr = marine_list.getElementsByTagName("tr");

			for(var i = 0; i < ltr.length; ++i) {
				try {
					var tr = ltr\[i\];
					tr.style.display = '';
					var ltd = tr.getElementsByTagName("td")
					var name = ltd\[0\].innerText.toLowerCase();
					var role = ltd\[1\].innerText.toLowerCase()
					if(name.indexOf(filter) == -1 && role.indexOf(filter) == -1) {
						tr.style.display = 'none';
					}
				} catch(err) {}
			}
		}
	</script>
	"}

	if(!current_squad)
		dat += "No Squad selected!<BR>"
	else
		var/leader_text = ""
		var/leader_count = 0
		var/tl_text = ""
		var/tl_count = 0
		var/spec_text = ""
		var/spec_count = 0
		var/medic_text = ""
		var/medic_count = 0
		var/engi_text = ""
		var/engi_count = 0
		var/smart_text = ""
		var/smart_count = 0
		var/marine_text = ""
		var/marine_count = 0
		var/misc_text = ""
		var/living_count = 0

		var/conscious_text = ""
		var/unconscious_text = ""
		var/dead_text = ""

		var/SL_z //z level of the Squad Leader
		if(current_squad.squad_leader)
			var/turf/SL_turf = get_turf(current_squad.squad_leader)
			SL_z = SL_turf.z


		for(var/X in current_squad.marines_list)
			if(!X)
				continue //just to be safe
			var/mob_name = "unknown"
			var/mob_state = ""
			var/role = "unknown"
			var/act_sl = ""
			var/fteam = ""
			var/dist = "<b>???</b>"
			var/area_name = "<b>???</b>"
			var/mob/living/carbon/human/H

			var/is_filtered = FALSE
			if(X && ("\ref[X]" in marine_filter))
				is_filtered = TRUE

			if(ishuman(X))
				H = X
				mob_name = H.real_name
				var/area/A = get_area(H)
				var/turf/M_turf = get_turf(H)
				if(!M_turf)
					continue
				if(A)
					area_name = sanitize_area(A.name)

				switch(z_hidden)
					if(HIDE_ALMAYER)
						if(is_mainship_level(M_turf.z))
							continue
					if(HIDE_GROUND)
						if(is_ground_level(M_turf.z))
							continue

				if(H.job)
					role = H.job
				else if(istype(H.wear_id, /obj/item/card/id)) //decapitated marine is mindless,
					var/obj/item/card/id/ID = H.wear_id //we use their ID to get their role.
					if(ID.rank) role = ID.rank

				if(current_squad.squad_leader)
					if(H == current_squad.squad_leader)
						dist = "<b>N/A</b>"
						if(current_squad.name == SQUAD_SOF)
							if(H.job == JOB_MARINE_RAIDER_CMD)
								act_sl = " (direct command)"
							else if(H.job != JOB_MARINE_RAIDER_SL)
								act_sl = " (acting TL)"
						else if(H.job != JOB_SQUAD_LEADER)
							act_sl = " (acting SL)"
					else if(M_turf && (M_turf.z == SL_z))
						dist = "[get_dist(H, current_squad.squad_leader)] ([dir2text_short(get_dir(current_squad.squad_leader, H))])"

				if(is_filtered && marine_filter_enabled)
					continue

				switch(H.stat)
					if(CONSCIOUS)
						mob_state = "Conscious"
						living_count++
						conscious_text += "<tr><td><A href='?src=\ref[src];operation=use_cam;cam_target=\ref[H]'>[mob_name]</a></td><td>[role][act_sl]</td><td>[mob_state]</td><td>[area_name]</td><td>[dist]</td><td><A class='[is_filtered ? "green" : "red"]' href='?src=\ref[src];operation=filter_marine;squaddie=\ref[H]'>[is_filtered ? "Show" : "Hide"]</a></td></tr>"

					if(UNCONSCIOUS)
						mob_state = "<b>Unconscious</b>"
						living_count++
						unconscious_text += "<tr><td><A href='?src=\ref[src];operation=use_cam;cam_target=\ref[H]'>[mob_name]</a></td><td>[role][act_sl]</td><td>[mob_state]</td><td>[area_name]</td><td>[dist]</td><td><A class='[is_filtered ? "green" : "red"]' href='?src=\ref[src];operation=filter_marine;squaddie=\ref[H]'>[is_filtered ? "Show" : "Hide"]</a></td></tr>"

					if(DEAD)
						if(dead_hidden)
							continue
						mob_state = SET_CLASS("DEAD", INTERFACE_RED)
						dead_text += "<tr><td><A href='?src=\ref[src];operation=use_cam;cam_target=\ref[H]'>[mob_name]</a></td><td>[role][act_sl]</td><td>[mob_state]</td><td>[area_name]</td><td>[dist]</td><td><A class='[is_filtered ? "green" : "red"]' href='?src=\ref[src];operation=filter_marine;squaddie=\ref[H]'>[is_filtered ? "Show" : "Hide"]</a></td></tr>"

				if(!istype(H.head, /obj/item/clothing/head/helmet/marine))
					mob_state += SET_CLASS(" <b>(NO HELMET)</b>", INTERFACE_ORANGE)

				if(!H.key || !H.client)
					if(H.stat != DEAD)
						mob_state += " (SSD)"


				if(H.assigned_fireteam)
					fteam = " [H.assigned_fireteam]"

			else //listed marine was deleted or gibbed, all we have is their name
				if(dead_hidden)
					continue
				if(z_hidden) //gibbed marines are neither on the colony nor on the almayer
					continue
				for(var/datum/data/record/t in GLOB.data_core.general)
					if(t.fields["name"] == X)
						role = t.fields["real_rank"]
						break
				mob_state = SET_CLASS("DEAD", INTERFACE_RED)
				mob_name = X

				dead_text += "<tr><td><A href='?src=\ref[src];operation=use_cam;cam_target=\ref[H]'>[mob_name]</a></td><td>[role][act_sl]</td><td>[mob_state]</td><td>[area_name]</td><td>[dist]</td><td><A class='[is_filtered ? "green" : "red"]' href='?src=\ref[src];operation=filter_marine;squaddie=\ref[H]'>[is_filtered ? "Show" : "Hide"]</a></td></tr>"


			var/marine_infos = "<tr><td><A href='?src=\ref[src];operation=use_cam;cam_target=\ref[H]'>[mob_name]</a></td><td>[role][act_sl][fteam]</td><td>[mob_state]</td><td>[area_name]</td><td>[dist]</td><td><A class='[is_filtered ? "green" : "red"]' href='?src=\ref[src];operation=filter_marine;squaddie=\ref[H]'>[is_filtered ? "Show" : "Hide"]</a></td></tr>"
			switch(role)
				if(JOB_SQUAD_LEADER)
					leader_text += marine_infos
					leader_count++
				if(JOB_SQUAD_TEAM_LEADER)
					tl_text += marine_infos
					tl_count++
				if(JOB_SQUAD_SPECIALIST)
					spec_text += marine_infos
					spec_count++
				if(JOB_SQUAD_MEDIC)
					medic_text += marine_infos
					medic_count++
				if(JOB_SQUAD_ENGI)
					engi_text += marine_infos
					engi_count++
				if(JOB_SQUAD_SMARTGUN)
					smart_text += marine_infos
					smart_count++
				if(JOB_SQUAD_MARINE)
					marine_text += marine_infos
					marine_count++
				else
					misc_text += marine_infos

		dat += "<b>[leader_count ? "Squad Leader Deployed" : SET_CLASS("No Squad Leader Deployed!", INTERFACE_RED)]</b><BR>"
		dat += "<b>Fireteam Leaders: [tl_count ? "[tl_count]" : SET_CLASS("No Fireteam Leaders Deployed!", INTERFACE_RED)]</b><BR>"
		dat += "<b>[spec_count ? "Squad Specialist Deployed" : SET_CLASS("No Specialist Deployed!", INTERFACE_RED)]</b><BR>"
		dat += "<b>[smart_count ? "Squad Smartgunner Deployed" : SET_CLASS("No Smartgunner Deployed!", INTERFACE_RED)]</b><BR>"
		dat += "<b>Squad Hospital Corpsmen: [medic_count] Deployed | Squad Combat Technicians: [engi_count] Deployed</b><BR>"
		dat += "<b>Squad Riflemen: [marine_count] Deployed</b><BR>"
		dat += "<b>Total: [current_squad.marines_list.len] Deployed</b><BR>"
		dat += "<b>Marines alive: [living_count]</b><BR><BR><BR>"
		dat += "<center><b>Search:</b> <input type='text' id='filter' value='' onkeyup='updateSearch();' style='width:300px;'></center>"
		dat += "<table id='marine_list' border='2px' style='width: 100%; border-collapse: collapse;' align='center'><tr>"
		dat += "<th>Name</th><th>Role</th><th>State</th><th>Location</th><th>SL Distance</th><th>Filter</th></tr>"
		if(!living_marines_sorting)
			dat += leader_text + tl_text + spec_text + medic_text + engi_text + smart_text + marine_text + misc_text
		else
			dat += conscious_text + unconscious_text + dead_text
		dat += "</table>"
	dat += "<br><hr>"
	dat += "<A href='?src=\ref[src];operation=refresh'>Refresh</a><br>"
	dat += "<A href='?src=\ref[src];operation=change_sort'>Change Sorting Method</a><br>"
	dat += "<A href='?src=\ref[src];operation=hide_dead'>[dead_hidden ? "Show Dead Marines" : "Hide Dead Marines" ]</a><br>"
	dat += "<A href='?src=\ref[src];operation=toggle_marine_filter'>[marine_filter_enabled ? "Disable Marine Filter" : "Enable Marine Filter"]</a><br>"
	dat += "<A href='?src=\ref[src];operation=choose_z'>Change Locations Ignored</a><br>"
	dat += "<br><A href='?src=\ref[src];operation=back'>Back</a></body>"
	return dat

/obj/structure/machinery/computer/overwatch/proc/get_supply_drop_menu_text()
	var/dat = "<B>Supply Drop Control</B><BR><BR>"
	if(!current_squad)
		dat += "No squad selected!"
	else
		dat += "<B>Current Supply Drop Status:</B> "
		var/cooldown_left = COOLDOWN_TIMELEFT(current_squad, next_supplydrop)
		if(cooldown_left > 0)
			dat += "Launch tubes resetting ([round(cooldown_left/10)] seconds)<br>"
		else
			dat += SET_CLASS("Ready!", INTERFACE_GREEN)
			dat += "<br>"
		dat += "<B>Launch Pad Status:</b> "
		var/obj/structure/closet/crate/C = locate() in current_squad.drop_pad.loc
		if(C)
			dat += SET_CLASS("Supply crate loaded", INTERFACE_GREEN)
			dat += "<BR>"
		else
			dat += "Empty<BR>"
		dat += "<B>Longitude:</B> [x_supply] <A href='?src=\ref[src];operation=supply_x'>Change</a><BR>"
		dat += "<B>Latitude:</B> [y_supply] <A href='?src=\ref[src];operation=supply_y'>Change</a><BR><BR>"
		dat += "<A class='green' href='?src=\ref[src];operation=dropsupply'>LAUNCH!</a>"
	dat += "<br><hr>"
	dat += "<A href='?src=\ref[src];operation=refresh'>Refresh</a><br>"
	dat += "<A href='?src=\ref[src];operation=back'>Back</a></body>"
	return dat

/obj/structure/machinery/computer/overwatch/proc/get_orbital_bombardment_control_text()
	var/dat = "<B>Orbital Bombardment Control</B><BR><BR>"
	if(!current_squad)
		dat += "No squad selected!"
	else
		dat += "<B>Current Cannon Status:</B> "
		var/cooldown_left = COOLDOWN_TIMELEFT(almayer_orbital_cannon, ob_firing_cooldown)
		if(almayer_orbital_cannon.is_disabled)
			dat += "Cannon is disabled!<br>"
		else if(cooldown_left > 0)
			dat += "Cannon on cooldown ([round(cooldown_left/10)] seconds)<br>"
		else if(!almayer_orbital_cannon.chambered_tray)
			dat += SET_CLASS("No ammo chambered in the cannon.", INTERFACE_RED)
			dat += "<br>"
		else
			dat += SET_CLASS("Ready!", INTERFACE_GREEN)
			dat += "<br>"
		dat += "<B>Longitude:</B> [x_bomb] <A href='?src=\ref[src];operation=bomb_x'>Change</a><BR>"
		dat += "<B>Latitude:</B> [y_bomb] <A href='?src=\ref[src];operation=bomb_y'>Change</a><BR><BR>"
		dat += "<A class='red' href='?src=\ref[src];operation=dropbomb'>FIRE!</a>"
	dat += "<br><hr>"
	dat += "<A href='?src=\ref[src];operation=refresh'>Refresh</a><br>"
	dat += "<A href='?src=\ref[src];operation=back'>Back</a></body>"
	return dat

/obj/structure/machinery/computer/overwatch/Topic(href, href_list)
	if(..())
		return
	if(!href_list["operation"])
		return

	if((usr.contents.Find(src) || (in_range(src, usr) && istype(loc, /turf))) || (ishighersilicon(usr)))
		usr.set_interaction(src)

	switch(href_list["operation"])
		// main interface
		if("mapview")
			tacmap.tgui_interact(usr)
		if("back")
			state = 0
		if("monitor")
			state = 1
		if("supplies")
			state = 2
		if("bombs")
			state = 3
		if("change_operator")
			if(operator != usr)
				if(operator && ishighersilicon(operator))
					visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("AI override in progress. Access denied.")]")
					return
				if(!current_squad || current_squad.assume_overwatch(usr))
					operator = usr
				if(ishighersilicon(usr))
					to_chat(usr, "[icon2html(src, usr)] [SPAN_BOLDNOTICE("Overwatch system AI override protocol successful.")]")
					current_squad?.send_squad_message("Attention. [operator.name] has engaged overwatch system control override.", displayed_icon = src)
				else
					var/mob/living/carbon/human/H = operator
					var/obj/item/card/id/ID = H.get_idcard()
					visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Basic overwatch systems initialized. Welcome, [ID ? "[ID.rank] ":""][operator.name]. Please select a squad.")]")
					current_squad?.send_squad_message("Attention. Your Overwatch officer is now [ID ? "[ID.rank] ":""][operator.name].", displayed_icon = src)
		if("logout")
			if(current_squad?.release_overwatch())
				if(ishighersilicon(usr))
					current_squad.send_squad_message("Attention. [operator.name] has released overwatch system control. Overwatch functions deactivated.", displayed_icon = src)
					to_chat(usr, "[icon2html(src, usr)] [SPAN_BOLDNOTICE("Overwatch system control override disengaged.")]")
				else
					var/mob/living/carbon/human/H = operator
					var/obj/item/card/id/ID = H.get_idcard()
					current_squad.send_squad_message("Attention. [ID ? "[ID.rank] ":""][operator ? "[operator.name]":"sysadmin"] is no longer your Overwatch officer. Overwatch functions deactivated.", displayed_icon = src)
					visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Overwatch systems deactivated. Goodbye, [ID ? "[ID.rank] ":""][operator ? "[operator.name]":"sysadmin"].")]")
			operator = null
			current_squad = null
			if(cam && !ishighersilicon(usr))
				usr.reset_view(null)
				usr.UnregisterSignal(cam, COMSIG_PARENT_QDELETING)
			cam = null
			state = 0
		if("pick_squad")
			if(operator == usr)
				if(current_squad)
					to_chat(usr, SPAN_WARNING("[icon2html(src, usr)] You are already selecting a squad."))
				else
					var/list/squad_list = list()
					for(var/datum/squad/S in RoleAuthority.squads)
						if(S.active && !S.overwatch_officer && S.faction == faction && S.name != "Root")
							squad_list += S.name

					var/name_sel = tgui_input_list(usr, "Which squad would you like to claim for Overwatch?", "Claim Squad", squad_list)
					if(!name_sel)
						return
					if(operator != usr)
						return
					if(current_squad)
						to_chat(usr, SPAN_WARNING("[icon2html(src, usr)] You are already selecting a squad."))
						return
					var/datum/squad/selected = get_squad_by_name(name_sel)
					if(selected)
						//Link everything together, squad, console, and officer
						if(selected.assume_overwatch(usr))
							current_squad = selected
							current_squad.send_squad_message("Attention - Your squad has been selected for Overwatch. Check your Status pane for objectives.", displayed_icon = src)
							current_squad.send_squad_message("Your Overwatch officer is: [operator.name].", displayed_icon = src)
							visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Tactical data for squad '[current_squad]' loaded. All tactical functions initialized.")]")
							attack_hand(usr)
					else
						to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Invalid input. Aborting.")]")
		if("message")
			if(current_squad && operator == usr)
				var/input = sanitize_control_chars(stripped_input(usr, "Please write a message to announce to the squad:", "Squad Message"))
				if(input)
					current_squad.send_message(input, 1) //message, adds username
					current_squad.send_maptext(input, "Squad Message:")
					visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Message '[input]' sent to all Marines of squad '[current_squad]'.")]")
					log_overwatch("[key_name(usr)] sent '[input]' to squad [current_squad].")
		if("sl_message")
			if(current_squad && operator == usr)
				var/input = sanitize_control_chars(stripped_input(usr, "Please write a message to announce to the squad leader:", "SL Message"))
				if(input)
					current_squad.send_message(input, 1, 1) //message, adds username, only to leader
					current_squad.send_maptext(input, "Squad Leader Message:", 1)
					visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Message '[input]' sent to Squad Leader [current_squad.squad_leader] of squad '[current_squad]'.")]")
					log_overwatch("[key_name(usr)] sent '[input]' to Squad Leader [current_squad.squad_leader] of squad [current_squad].")
		if("check_primary")
			if(current_squad) //This is already checked, but ehh.
				if(current_squad.primary_objective)
					visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Reminding primary objectives of squad '[current_squad]'.")]")
					to_chat(usr, "[icon2html(src, usr)] <b>Primary Objective:</b> [current_squad.primary_objective]")
		if("check_secondary")
			if(current_squad) //This is already checked, but ehh.
				if(current_squad.secondary_objective)
					visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Reminding secondary objectives of squad '[current_squad]'.")]")
					to_chat(usr, "[icon2html(src, usr)] <b>Secondary Objective:</b> [current_squad.secondary_objective]")
		if("set_primary")
			var/input = sanitize_control_chars(stripped_input(usr, "What will be the squad's primary objective?", "Primary Objective"))
			if(current_squad && input)
				current_squad.primary_objective = "[input] ([worldtime2text()])"
				current_squad.send_message("Your primary objective has been changed to '[input]'. See Status pane for details.")
				current_squad.send_maptext(input, "Primary Objective Updated:")
				visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Primary objective of squad '[current_squad]' set to '[input]'.")]")
				log_overwatch("[key_name(usr)] set [current_squad]'s primary objective to '[input]'.")
		if("set_secondary")
			var/input = sanitize_control_chars(stripped_input(usr, "What will be the squad's secondary objective?", "Secondary Objective"))
			if(input)
				current_squad.secondary_objective = input + " ([worldtime2text()])"
				current_squad.send_message("Your secondary objective has been changed to '[input]'. See Status pane for details.")
				current_squad.send_maptext(input, "Secondary Objective Updated:")
				visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Secondary objective of squad '[current_squad]' set to '[input]'.")]")
				log_overwatch("[key_name(usr)] set [current_squad]'s secondary objective to '[input]'.")
		if("supply_x")
			var/input = tgui_input_real_number(usr,"What longitude should be targetted? (Increments towards the east)", "X Coordinate", 0)
			to_chat(usr, "[icon2html(src, usr)] [SPAN_NOTICE("Longitude is now [input].")]")
			x_supply = input
		if("supply_y")
			var/input = tgui_input_real_number(usr,"What latitude should be targetted? (Increments towards the north)", "Y Coordinate", 0)
			to_chat(usr, "[icon2html(src, usr)] [SPAN_NOTICE("Latitude is now [input].")]")
			y_supply = input
		if("bomb_x")
			var/input = tgui_input_real_number(usr,"What longitude should be targetted? (Increments towards the east)", "X Coordinate", 0)
			to_chat(usr, "[icon2html(src, usr)] [SPAN_NOTICE("Longitude is now [input].")]")
			x_bomb = input
		if("bomb_y")
			var/input = tgui_input_real_number(usr,"What latitude should be targetted? (Increments towards the north)", "Y Coordinate", 0)
			to_chat(usr, "[icon2html(src, usr)] [SPAN_NOTICE("Latitude is now [input].")]")
			y_bomb = input
		if("refresh")
			attack_hand(usr)
		if("change_sort")
			living_marines_sorting = !living_marines_sorting
			if(living_marines_sorting)
				to_chat(usr, "[icon2html(src, usr)] [SPAN_NOTICE("Marines are now sorted by health status.")]")
			else
				to_chat(usr, "[icon2html(src, usr)] [SPAN_NOTICE("Marines are now sorted by rank.")]")
		if("hide_dead")
			dead_hidden = !dead_hidden
			if(dead_hidden)
				to_chat(usr, "[icon2html(src, usr)] [SPAN_NOTICE("Dead marines are now not shown.")]")
			else
				to_chat(usr, "[icon2html(src, usr)] [SPAN_NOTICE("Dead marines are now shown again.")]")
		if("choose_z")
			switch(z_hidden)
				if(HIDE_NONE)
					z_hidden = HIDE_ALMAYER
					to_chat(usr, "[icon2html(src, usr)] [SPAN_NOTICE("Marines on the Almayer are now hidden.")]")
				if(HIDE_ALMAYER)
					z_hidden = HIDE_GROUND
					to_chat(usr, "[icon2html(src, usr)] [SPAN_NOTICE("Marines on the ground are now hidden.")]")
				else
					z_hidden = HIDE_NONE
					to_chat(usr, "[icon2html(src, usr)] [SPAN_NOTICE("No location is ignored anymore.")]")

		if("toggle_marine_filter")
			if(marine_filter_enabled)
				marine_filter_enabled = FALSE
				to_chat(usr, "[icon2html(src, usr)] [SPAN_NOTICE("All marines will now be shown regardless of filter.")]")
			else
				marine_filter_enabled = TRUE
				to_chat(usr, "[icon2html(src, usr)] [SPAN_NOTICE("Individual Marine Filter is now enabled.")]")
		if("filter_marine")
			if (current_squad)
				var/squaddie = href_list["squaddie"]
				if(!(squaddie in marine_filter))
					marine_filter += squaddie
					to_chat(usr, "[icon2html(src, usr)] [SPAN_NOTICE("Marine now hidden.")]")
				else
					marine_filter -= squaddie
					to_chat(usr, "[icon2html(src, usr)] [SPAN_NOTICE("Marine will now be shown.")]")
		if("change_lead")
			change_lead()
		if("insubordination")
			mark_insubordination()
		if("squad_transfer")
			transfer_squad()
		if("dropsupply")
			if(current_squad)
				if(!COOLDOWN_FINISHED(current_squad, next_supplydrop))
					to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Supply drop not yet ready to launch again!")]")
				else
					handle_supplydrop()
		if("dropbomb")
			if(almayer_orbital_cannon.is_disabled)
				to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Orbital bombardment cannon disabled!")]")
			else if(!COOLDOWN_FINISHED(almayer_orbital_cannon, ob_firing_cooldown))
				to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Orbital bombardment cannon not yet ready to fire again! Please wait [COOLDOWN_TIMELEFT(almayer_orbital_cannon, ob_firing_cooldown)/10] seconds.")]")
			else
				handle_bombard(usr)
		if("back")
			state = 0
		if("use_cam")
			if(isRemoteControlling(usr))
				to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Unable to override console camera viewer. Track with camera instead. ")]")
				return
			if(current_squad)
				var/mob/cam_target = locate(href_list["cam_target"])
				var/obj/structure/machinery/camera/new_cam = get_camera_from_target(cam_target)
				if(!new_cam || !new_cam.can_use())
					to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Searching for helmet cam. No helmet cam found for this marine! Tell your squad to put their helmets on!")]")
				else if(cam && cam == new_cam)//click the camera you're watching a second time to stop watching.
					visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Stopping helmet cam view of [cam_target].")]")
					usr.UnregisterSignal(cam, COMSIG_PARENT_QDELETING)
					cam = null
					usr.reset_view(null)
				else if(usr.client.view != world_view_size)
					to_chat(usr, SPAN_WARNING("You're too busy peering through binoculars."))
				else
					if(cam)
						usr.UnregisterSignal(cam, COMSIG_PARENT_QDELETING)
					cam = new_cam
					usr.reset_view(cam)
					usr.RegisterSignal(cam, COMSIG_PARENT_QDELETING, TYPE_PROC_REF(/mob, reset_observer_view_on_deletion))
	attack_hand(usr) //The above doesn't ever seem to work.

/obj/structure/machinery/computer/overwatch/check_eye(mob/user)
	if(user.is_mob_incapacitated(TRUE) || get_dist(user, src) > 1 || user.blinded) //user can't see - not sure why canmove is here.
		user.unset_interaction()
	else if(!cam || !cam.can_use()) //camera doesn't work, is no longer selected or is gone
		user.unset_interaction()

/obj/structure/machinery/computer/overwatch/on_unset_interaction(mob/user)
	..()
	if(!isRemoteControlling(user))
		if(cam)
			user.UnregisterSignal(cam, COMSIG_PARENT_QDELETING)
		cam = null
		user.reset_view(null)

//returns the helmet camera the human is wearing
/obj/structure/machinery/computer/overwatch/proc/get_camera_from_target(mob/living/carbon/human/H)
	if(current_squad)
		if(H && istype(H) && istype(H.head, /obj/item/clothing/head/helmet/marine))
			var/obj/item/clothing/head/helmet/marine/helm = H.head
			return helm.camera


// Alerts all groundside marines about the incoming OB
/obj/structure/machinery/computer/overwatch/proc/alert_ob(turf/target)
	var/area/ob_area = get_area(target)
	if(!ob_area)
		return
	var/ob_type = almayer_orbital_cannon.tray.warhead ? almayer_orbital_cannon.tray.warhead.warhead_kind : "UNKNOWN"

	for(var/datum/squad/S in RoleAuthority.squads)
		if(!S.active)
			continue
		for(var/mob/living/carbon/human/M in S.marines_list)
			if(!is_ground_level(M.z))
				continue
			if(M.stat != CONSCIOUS || !M.client)
				continue
			playsound_client(M.client, 'sound/effects/ob_alert.ogg', M)
			to_chat(M, SPAN_HIGHDANGER("Orbital bombardment launch command detected!"))
			to_chat(M, SPAN_DANGER("Launch command informs [ob_type] warhead. Estimated impact area: [ob_area.name]"))

/obj/structure/machinery/computer/overwatch/proc/change_lead()
	if(!usr || usr != operator)
		return
	if(!current_squad)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("No squad selected!")]")
		return
	var/sl_candidates = list()
	for(var/mob/living/carbon/human/H in current_squad.marines_list)
		if(istype(H) && H.stat != DEAD && H.mind && !jobban_isbanned(H, JOB_SQUAD_LEADER))
			sl_candidates += H
	var/new_lead = tgui_input_list(usr, "Choose a new Squad Leader", "Replace SL", sl_candidates)
	if(!new_lead || new_lead == "Cancel")
		return
	var/mob/living/carbon/human/H = new_lead
	if(!istype(H) || !H.mind || H.stat == DEAD) //marines_list replaces mob refs of gibbed marines with just a name string
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("[H] is KIA!")]")
		return
	if(H == current_squad.squad_leader)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("[H] is already the Squad Leader!")]")
		return
	if(jobban_isbanned(H, JOB_SQUAD_LEADER))
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("[H] is unfit to lead!")]")
		return
	if(current_squad.squad_leader)
		current_squad.send_message("Attention: [current_squad.squad_leader] is [current_squad.squad_leader.stat == DEAD ? "stepping down" : "demoted"]. A new Squad Leader has been set: [H.real_name].")
		visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Squad Leader [current_squad.squad_leader] of squad '[current_squad]' has been [current_squad.squad_leader.stat == DEAD ? "replaced" : "demoted and replaced"] by [H.real_name]! Logging to enlistment files.")]")
		var/old_lead = current_squad.squad_leader
		current_squad.demote_squad_leader(current_squad.squad_leader.stat != DEAD)
		SStracking.start_tracking(current_squad.tracking_id, old_lead)
	else
		current_squad.send_message("Attention: A new Squad Leader has been set: [H.real_name].")
		visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("[H.real_name] is the new Squad Leader of squad '[current_squad]'! Logging to enlistment file.")]")

	to_chat(H, "[icon2html(src, H)] <font size='3' color='blue'><B>Overwatch: You've been promoted to \'[H.job == JOB_SQUAD_LEADER ? "SQUAD LEADER" : "ACTING SQUAD LEADER"]\' for [current_squad.name]. Your headset has access to the command channel (:v).</B></font>")
	to_chat(usr, "[icon2html(src, usr)] [H.real_name] is [current_squad]'s new leader!")

	if(H.assigned_fireteam)
		if(H == current_squad.fireteam_leaders[H.assigned_fireteam])
			current_squad.unassign_ft_leader(H.assigned_fireteam, TRUE, FALSE)
		current_squad.unassign_fireteam(H, FALSE)

	current_squad.squad_leader = H
	current_squad.update_squad_leader()
	current_squad.update_free_mar()

	SStracking.set_leader(current_squad.tracking_id, H)
	SStracking.start_tracking("marine_sl", H)

	if(H.job == JOB_SQUAD_LEADER)//a real SL
		H.comm_title = "SL"
	else //an acting SL
		H.comm_title = "aSL"
	ADD_TRAIT(H, TRAIT_LEADERSHIP, TRAIT_SOURCE_SQUAD_LEADER)

	var/obj/item/device/radio/headset/almayer/marine/R = H.get_type_in_ears(/obj/item/device/radio/headset/almayer/marine)
	if(R)
		R.keys += new /obj/item/device/encryptionkey/squadlead/acting(R)
		R.recalculateChannels()
	if(istype(H.wear_id, /obj/item/card/id))
		var/obj/item/card/id/ID = H.wear_id
		ID.access += ACCESS_MARINE_LEADER
	H.hud_set_squad()
	H.update_inv_head() //updating marine helmet leader overlays
	H.update_inv_wear_suit()

/obj/structure/machinery/computer/overwatch/proc/mark_insubordination()
	if(!usr)
		return
	if(!current_squad)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("No squad selected!")]")
		return
	var/mob/living/carbon/human/wanted_marine = tgui_input_list(usr, "Report a marine for insubordination", "Mark for Insubordination", current_squad.marines_list)
	if(!wanted_marine)
		return
	if(!istype(wanted_marine))//gibbed/deleted, all we have is a name.
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("[wanted_marine] is missing in action.")]")
		return

	var/marine_ref = WEAKREF(wanted_marine)
	for(var/datum/data/record/E in GLOB.data_core.general)
		if(E.fields["ref"] == marine_ref)
			for(var/datum/data/record/R in GLOB.data_core.security)
				if(R.fields["id"] == E.fields["id"])
					if(!findtext(R.fields["ma_crim"],"Insubordination."))
						R.fields["criminal"] = "*Arrest*"
						if(R.fields["ma_crim"] == "None")
							R.fields["ma_crim"] = "Insubordination."
						else
							R.fields["ma_crim"] += "Insubordination."

						var/insub = "[icon2html(src, usr)] [SPAN_BOLDNOTICE("[wanted_marine] has been reported for insubordination. Logging to enlistment file.")]"
						if(isRemoteControlling(usr))
							usr << insub
						else
							visible_message(insub)
						to_chat(wanted_marine, "[icon2html(src, wanted_marine)] <font size='3' color='blue'><B>Overwatch:</b> You've been reported for insubordination by your overwatch officer.</font>")
						wanted_marine.sec_hud_set_security_status()
					return

/obj/structure/machinery/computer/overwatch/proc/transfer_squad()
	if(!usr)
		return
	if(!current_squad)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("No squad selected!")]")
		return
	var/datum/squad/S = current_squad
	var/mob/living/carbon/human/transfer_marine = tgui_input_list(usr, "Choose marine to transfer", "Transfer Marine", current_squad.marines_list)
	if(!transfer_marine || S != current_squad) //don't change overwatched squad, idiot.
		return

	if(!istype(transfer_marine) || !transfer_marine.mind || transfer_marine.stat == DEAD) //gibbed, decapitated, dead
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("[transfer_marine] is KIA.")]")
		return

	if(!istype(transfer_marine.wear_id, /obj/item/card/id))
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Transfer aborted. [transfer_marine] isn't wearing an ID.")]")
		return

	var/list/available_squads = list()
	for(var/datum/squad/squad as anything in RoleAuthority.squads)
		if(squad.active && !squad.locked && squad.faction == faction && squad.name != "Root")
			available_squads += squad

	var/datum/squad/new_squad = tgui_input_list(usr, "Choose the marine's new squad", "Squad Selection", available_squads)
	if(!new_squad || S != current_squad)
		return

	if(!istype(transfer_marine) || !transfer_marine.mind || transfer_marine.stat == DEAD)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("[transfer_marine] is KIA.")]")
		return

	if(!istype(transfer_marine.wear_id, /obj/item/card/id))
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Transfer aborted. [transfer_marine] isn't wearing an ID.")]")
		return

	var/datum/squad/old_squad = transfer_marine.assigned_squad
	if(new_squad == old_squad)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("[transfer_marine] is already in [new_squad]!")]")
		return

	if(RoleAuthority.check_squad_capacity(transfer_marine, new_squad))
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Transfer aborted. [new_squad] can't have another [transfer_marine.job].")]")
		return

	. = transfer_marine_to_squad(transfer_marine, new_squad, old_squad)
	if(.)
		visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("[transfer_marine] has been transfered from squad '[old_squad]' to squad '[new_squad]'. Logging to enlistment file.")]")
		to_chat(transfer_marine, "[icon2html(src, transfer_marine)] <font size='3' color='blue'><B>\[Overwatch\]:</b> You've been transfered to [new_squad]!</font>")
	else
		visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("[transfer_marine] transfer from squad '[old_squad]' to squad '[new_squad]' unsuccessful.")]")

/obj/structure/machinery/computer/overwatch/proc/handle_bombard(mob/user)
	if(!user)
		return

	if(busy)
		to_chat(user, "[icon2html(src, user)] [SPAN_WARNING("The [name] is busy processing another action!")]")
		return

	if(!current_squad)
		to_chat(user, "[icon2html(src, user)] [SPAN_WARNING("No squad selected!")]")
		return

	if(!almayer_orbital_cannon.chambered_tray)
		to_chat(user, "[icon2html(src, user)] [SPAN_WARNING("The orbital cannon has no ammo chambered.")]")
		return

	var/x_coord = deobfuscate_x(x_bomb)
	var/y_coord = deobfuscate_y(y_bomb)
	var/z_coord = SSmapping.levels_by_trait(ZTRAIT_GROUND)
	if(length(z_coord))
		z_coord = z_coord[1]
	else
		z_coord = 1 // fuck it

	var/turf/T = locate(x_coord, y_coord, z_coord)

	if(isnull(T) || istype(T, /turf/open/space))
		to_chat(user, "[icon2html(src, user)] [SPAN_WARNING("The target zone appears to be out of bounds. Please check coordinates.")]")
		return

	if(protected_by_pylon(TURF_PROTECTION_OB, T))
		to_chat(user, "[icon2html(src, user)] [SPAN_WARNING("The target zone has strong biological protection. The orbital strike cannot reach here.")]")
		return

	var/area/A = get_area(T)

	if(istype(A) && CEILING_IS_PROTECTED(A.ceiling, CEILING_DEEP_UNDERGROUND))
		to_chat(user, "[icon2html(src, user)] [SPAN_WARNING("The target zone is deep underground. The orbital strike cannot reach here.")]")
		return


	//All set, let's do this.
	busy = TRUE
	visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Orbital bombardment request for squad '[current_squad]' accepted. Orbital cannons are now calibrating.")]")
	playsound(T,'sound/effects/alert.ogg', 25, 1)  //Placeholder
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/structure/machinery/computer/overwatch, alert_ob), T), 2 SECONDS)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/structure/machinery/computer/overwatch, begin_fire)), 6 SECONDS)
	addtimer(CALLBACK(src, TYPE_PROC_REF(/obj/structure/machinery/computer/overwatch, fire_bombard), user, A, T), 6 SECONDS + 6)

/obj/structure/machinery/computer/overwatch/proc/begin_fire()
	for(var/mob/living/carbon/H in GLOB.alive_mob_list)
		if(is_mainship_level(H.z) && !H.stat) //USS Almayer decks.
			to_chat(H, SPAN_WARNING("The deck of the [MAIN_SHIP_NAME] shudders as the orbital cannons open fire on the colony."))
			if(H.client)
				shake_camera(H, 10, 1)
	visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("Orbital bombardment for squad '[current_squad]' has fired! Impact imminent!")]")
	current_squad.send_message("WARNING! Ballistic trans-atmospheric launch detected! Get outside of Danger Close!")

/obj/structure/machinery/computer/overwatch/proc/fire_bombard(mob/user, area/A, turf/T)
	if(!A || !T)
		return

	var/ob_name = lowertext(almayer_orbital_cannon.tray.warhead.name)
	announce_dchat("\A [ob_name] targeting [A.name] has been fired!", T)
	message_admins(FONT_SIZE_HUGE("ALERT: [key_name(user)] fired an orbital bombardment in [A.name] for squad '[current_squad]' [ADMIN_JMP(T)]"))
	log_attack("[key_name(user)] fired an orbital bombardment in [A.name] for squad '[current_squad]'")

	/// Project ARES interface log.
	GLOB.ares_link.log_ares_bombardment(user, ob_name, "X[x_bomb], Y[y_bomb] in [A.name]")

	busy = FALSE
	var/turf/target = locate(T.x + rand(-3, 3), T.y + rand(-3, 3), T.z)
	if(target && istype(target))
		almayer_orbital_cannon.fire_ob_cannon(target, user)
		user.count_niche_stat(STATISTICS_NICHE_OB)

/obj/structure/machinery/computer/overwatch/proc/handle_supplydrop()
	SHOULD_NOT_SLEEP(TRUE)
	if(!usr || usr != operator)
		return

	if(busy)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("The [name] is busy processing another action!")]")
		return

	var/obj/structure/closet/crate/C = locate() in current_squad.drop_pad.loc //This thing should ALWAYS exist.
	if(!istype(C))
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("No crate was detected on the drop pad. Get Requisitions on the line!")]")
		return

	var/x_coord = deobfuscate_x(x_supply)
	var/y_coord = deobfuscate_y(y_supply)
	var/z_coord = SSmapping.levels_by_trait(ZTRAIT_GROUND)
	if(length(z_coord))
		z_coord = z_coord[1]
	else
		z_coord = 1 // fuck it

	var/turf/T = locate(x_coord, y_coord, z_coord)
	if(!T)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("Error, invalid coordinates.")]")
		return

	var/area/A = get_area(T)
	if(A && CEILING_IS_PROTECTED(A.ceiling, CEILING_PROTECTION_TIER_2))
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("The landing zone is underground. The supply drop cannot reach here.")]")
		return

	if(istype(T, /turf/open/space) || T.density)
		to_chat(usr, "[icon2html(src, usr)] [SPAN_WARNING("The landing zone appears to be obstructed or out of bounds. Package would be lost on drop.")]")
		return

	busy = TRUE
	C.visible_message(SPAN_WARNING("\The [C] loads into a launch tube. Stand clear!"))
	C.anchored = TRUE //To avoid accidental pushes
	current_squad.send_message("'[C.name]' supply drop incoming. Heads up!")
	current_squad.send_maptext(C.name, "Incoming Supply Drop:")
	var/datum/squad/S = current_squad //in case the operator changes the overwatched squad mid-drop
	COOLDOWN_START(S, next_supplydrop, 500 SECONDS)
	if(ismob(usr))
		var/mob/M = usr
		M.count_niche_stat(STATISTICS_NICHE_CRATES)

	playsound(C.loc,'sound/effects/bamf.ogg', 50, 1)  //Ehh
	var/obj/structure/droppod/supply/pod = new()
	C.forceMove(pod)
	pod.launch(T)
	visible_message("[icon2html(src, viewers(src))] [SPAN_BOLDNOTICE("'[C.name]' supply drop launched! Another launch will be available in five minutes.")]")
	busy = FALSE

/obj/structure/machinery/computer/overwatch/almayer
	density = FALSE
	icon = 'icons/obj/structures/machinery/computer.dmi'
	icon_state = "overwatch"

/obj/structure/machinery/computer/overwatch/almayer/broken
	name = "Broken Overwatch Console"

/obj/structure/machinery/computer/overwatch/clf
	faction = FACTION_CLF
/obj/structure/machinery/computer/overwatch/upp
	faction = FACTION_UPP
/obj/structure/machinery/computer/overwatch/pmc
	faction = FACTION_PMC
/obj/structure/machinery/computer/overwatch/twe
	faction = FACTION_TWE
/obj/structure/machinery/computer/overwatch/freelance
	faction = FACTION_FREELANCER

/obj/structure/supply_drop
	name = "Supply Drop Pad"
	desc = "Place a crate on here to allow bridge Overwatch officers to drop them on people's heads."
	icon = 'icons/effects/warning_stripes.dmi'
	anchored = TRUE
	density = FALSE
	unslashable = TRUE
	unacidable = TRUE
	layer = 2.1 //It's the floor, man
	var/squad = SQUAD_MARINE_1
	var/sending_package = 0

/obj/structure/supply_drop/Initialize(mapload, ...)
	. = ..()
	GLOB.supply_drop_list += src

/obj/structure/supply_drop/Destroy()
	GLOB.supply_drop_list -= src
	return ..()

/obj/structure/supply_drop/alpha
	icon_state = "alphadrop"
	squad = SQUAD_MARINE_1

/obj/structure/supply_drop/bravo
	icon_state = "bravodrop"
	squad = SQUAD_MARINE_2

/obj/structure/supply_drop/charlie
	icon_state = "charliedrop"
	squad = SQUAD_MARINE_3

/obj/structure/supply_drop/delta
	icon_state = "deltadrop"
	squad = SQUAD_MARINE_4

/obj/structure/supply_drop/echo //extra supply drop pad
	icon_state = "echodrop"
	squad = SQUAD_MARINE_5

#undef HIDE_ALMAYER
#undef HIDE_GROUND
#undef HIDE_NONE
