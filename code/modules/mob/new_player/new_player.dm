//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33
/mob/new_player
	var/ready = FALSE
	var/spawning = FALSE//Referenced when you want to delete the new_player later on in the code.

	invisibility = 101

	density = FALSE
	anchored = TRUE
	universal_speak = TRUE
	stat = DEAD

/mob/new_player/Initialize()
	. = ..()
	GLOB.new_player_list += src
	GLOB.dead_mob_list -= src
	ADD_TRAIT(src, TRAIT_IMMOBILIZED, TRAIT_SOURCE_INHERENT)

/mob/new_player/Destroy()
	if(ready)
		GLOB.readied_players--
	GLOB.new_player_list -= src
	return ..()

/mob/new_player/verb/new_player_panel()
	set src = usr
	if(client && client.player_entity)
		client.player_entity.update_panel_data(null)
		new_player_panel_proc()


/mob/new_player/proc/new_player_panel_proc(refresh = FALSE)
	if(!client)
		return

	var/tempnumber = rand(1, 999)
	var/postfix_text = (client.xeno_postfix) ? ("-"+client.xeno_postfix) : ""
	var/prefix_text = (client.xeno_prefix) ? client.xeno_prefix : "XX"
	var/xeno_text = "[prefix_text]-[tempnumber][postfix_text]"
	var/round_start = !SSticker || !SSticker.mode || SSticker.current_state <= GAME_STATE_PREGAME

	var/output = "<div align='center'>Welcome,"
	output +="<br><b>[(client.prefs && client.prefs.real_name) ? client.prefs.real_name : client.key]</b>"
	output +="<br><b>[xeno_text]</b>"
	output += "<p><a href='byond://?src=\ref[src];lobby_choice=tutorial'>Tutorial</A></p>"
	output += "<p><a href='byond://?src=\ref[src];lobby_choice=show_preferences'>Setup Character</A></p>"

	output += "<p><a href='byond://?src=\ref[src];lobby_choice=show_playtimes'>View Playtimes</A></p>"

	if(round_start)
		output += "<p>\[ [ready? "<b>Ready</b>":"<a href='byond://?src=\ref[src];lobby_choice=ready'>Ready</a>"] | [ready? "<a href='byond://?src=\ref[src];lobby_choice=unready'>Not Ready</a>":"<b>Not Ready</b>"] \]</p>"
		output += "<b>Be Xenomorph:</b> [(client.prefs && (client.prefs.get_job_priority(JOB_XENOMORPH))) ? "Yes" : "No"]"

	else
		output += "<a href='byond://?src=\ref[src];lobby_choice=manifest'>View the Crew Manifest</A><br><br>"
		output += "<a href='byond://?src=\ref[src];lobby_choice=hiveleaders'>View Hive Leaders</A><br><br>"
		output += "<p><a href='byond://?src=\ref[src];lobby_choice=late_join'>Join the USCM!</A></p>"
		output += "<p><a href='byond://?src=\ref[src];lobby_choice=late_join_xeno'>Join the Hive!</A></p>"
		if(SSticker.mode.flags_round_type & MODE_PREDATOR)
			if(SSticker.mode.check_predator_late_join(src,0)) output += "<p><a href='byond://?src=\ref[src];lobby_choice=late_join_pred'>Join the Hunt!</A></p>"

	output += "<p><a href='byond://?src=\ref[src];lobby_choice=observe'>Observe</A></p>"

	output += "</div>"
	if (refresh)
		close_browser(src, "playersetup")
	show_browser(src, output, null, "playersetup", "size=240x[round_start ? 500 : 610];can_close=0;can_minimize=0")
	return

/mob/new_player/Topic(href, href_list[])
	. = ..()
	if(.)
		return
	if(!client)
		return

	switch(href_list["lobby_choice"])
		if("show_preferences")
			// Otherwise the preview dummy will runtime
			// because atoms aren't initialized yet
			if(SSticker.current_state < GAME_STATE_PREGAME)
				to_chat(src, "Game is still starting up, please wait")
				return
			if(!SSentity_manager.ready)
				to_chat(src, "DB is still starting up, please wait")
				return
			client.prefs.ShowChoices(src)
			return 1

		if("show_playtimes")
			if(!SSentity_manager.ready)
				to_chat(src, "DB is still starting up, please wait")
				return
			if(client.player_data)
				client.player_data.tgui_interact(src)
			return 1

		if("ready")
			if( (SSticker.current_state <= GAME_STATE_PREGAME) && !ready) // Make sure we don't ready up after the round has started
				ready = TRUE
				GLOB.readied_players++

			new_player_panel_proc()

		if("unready")
			if((SSticker.current_state <= GAME_STATE_PREGAME) && ready) // Make sure we don't ready up after the round has started
				ready = FALSE
				GLOB.readied_players--

			new_player_panel_proc()

		if("refresh")
			new_player_panel_proc(TRUE)

		if("observe")
			if(!SSticker || SSticker.current_state == GAME_STATE_STARTUP)
				to_chat(src, SPAN_WARNING("The game is still setting up, please try again later."))
				return
			if(alert(src,"Are you sure you wish to observe? When you observe, you will not be able to join as marine. It might also take some time to become a xeno or responder!","Player Setup","Yes","No") == "Yes")
				if(!client)
					return TRUE
				if(!client.prefs?.preview_dummy)
					client.prefs.update_preview_icon()
				var/mob/dead/observer/observer = new /mob/dead/observer(null, client.prefs.preview_dummy)
				observer.set_lighting_alpha_from_pref(client)
				spawning = TRUE
				observer.started_as_observer = TRUE

				close_spawn_windows()

				var/obj/effect/landmark/observer_start/O = SAFEPICK(GLOB.observer_starts)
				if(istype(O))
					to_chat(src, SPAN_NOTICE("Now teleporting."))
					observer.forceMove(O.loc)
				else
					to_chat(src, SPAN_DANGER("Could not locate an observer spawn point. Use the Teleport verb to jump to the station map."))
				observer.icon = 'icons/mob/humans/species/r_human.dmi'
				observer.icon_state = "anglo_example"
				observer.alpha = 127

				if(client.prefs.be_random_name)
					client.prefs.real_name = random_name(client.prefs.gender)
				observer.real_name = client.prefs.real_name
				observer.name = observer.real_name

				mind.transfer_to(observer, TRUE)

				if(observer.client)
					observer.client.change_view(GLOB.world_view_size)

				observer.set_huds_from_prefs()

				qdel(src)
				return TRUE

		if("late_join")

			if(SSticker.current_state != GAME_STATE_PLAYING || !SSticker.mode)
				to_chat(src, SPAN_WARNING("The round is either not ready, or has already finished..."))
				return

			if(SSticker.mode.flags_round_type & MODE_NO_LATEJOIN)
				to_chat(src, SPAN_WARNING("Sorry, you cannot late join during [SSticker.mode.name]. You have to start at the beginning of the round. You may observe or try to join as an alien, if possible."))
				return

			if(client.player_data?.playtime_loaded && (client.get_total_human_playtime() < CONFIG_GET(number/notify_new_player_age)) && !length(client.prefs.completed_tutorials))
				if(tgui_alert(src, "You have little playtime and haven't completed any tutorials. Would you like to go to the tutorial menu?", "Tutorial", list("Yes", "No")) == "Yes")
					tutorial_menu()
					return

			LateChoices()

		if("late_join_xeno")
			if(SSticker.current_state != GAME_STATE_PLAYING || !SSticker.mode)
				to_chat(src, SPAN_WARNING("The round is either not ready, or has already finished..."))
				return

			if(alert(src,"Are you sure you want to attempt joining as a xenomorph?","Confirmation","Yes","No") == "Yes" )
				if(SSticker.mode.check_xeno_late_join(src))
					var/mob/new_xeno = SSticker.mode.attempt_to_join_as_xeno(src, 0)
					if(new_xeno && !istype(new_xeno, /mob/living/carbon/xenomorph/larva))
						SSticker.mode.transfer_xeno(src, new_xeno)
						close_spawn_windows()

		if("late_join_pred")
			if(SSticker.current_state != GAME_STATE_PLAYING || !SSticker.mode)
				to_chat(src, SPAN_WARNING("The round is either not ready, or has already finished..."))
				return

			if(alert(src,"Are you sure you want to attempt joining as a predator?","Confirmation","Yes","No") == "Yes" )
				if(SSticker.mode.check_predator_late_join(src,0))
					close_spawn_windows()
					SSticker.mode.attempt_to_join_as_predator(src)
				else
					to_chat(src, SPAN_WARNING("You are no longer able to join as predator."))
					new_player_panel()

		if("manifest")
			ViewManifest()

		if("hiveleaders")
			ViewHiveLeaders()

		if("SelectedJob")

			if(!GLOB.enter_allowed)
				to_chat(usr, SPAN_WARNING("There is an administrative lock on entering the game! (The dropship likely crashed into the Almayer. This should take at most 20 minutes.)"))
				return

			AttemptLateSpawn(href_list["job_selected"])
			return

		if("tutorial")
			tutorial_menu()

		else
			new_player_panel()

/mob/new_player/proc/tutorial_menu()
	if(SSticker.current_state <= GAME_STATE_SETTING_UP)
		to_chat(src, SPAN_WARNING("Please wait for the round to start before entering a tutorial."))
		return

	if(SSticker.current_state == GAME_STATE_FINISHED)
		to_chat(src, SPAN_WARNING("The round has ended. Please wait for the next round to enter a tutorial."))
		return

	if(SSticker.tutorial_disabled)
		to_chat(src, SPAN_WARNING("Tutorials are currently disabled because something broke, sorry!"))
		return

	var/datum/tutorial_menu/menu = new(src)
	menu.ui_interact(src)

/mob/new_player/proc/AttemptLateSpawn(rank)
	var/datum/job/player_rank = GLOB.RoleAuthority.roles_for_mode[rank]
	if (src != usr)
		return
	if(SSticker.current_state != GAME_STATE_PLAYING)
		to_chat(usr, SPAN_WARNING("The round is either not ready, or has already finished!"))
		return
	if(!GLOB.enter_allowed)
		to_chat(usr, SPAN_WARNING("There is an administrative lock on entering the game! (The dropship likely crashed into the Almayer. This should take at most 20 minutes.)"))
		return
	if(!GLOB.RoleAuthority.assign_role(src, player_rank, 1))
		to_chat(src, alert("[rank] is not available. Please try another."))
		return

	spawning = TRUE
	close_spawn_windows()

	var/mob/living/carbon/human/character = create_character(TRUE) //creates the human and transfers vars and mind
	GLOB.RoleAuthority.equip_role(character, player_rank, late_join = TRUE)
	EquipCustomItems(character)

	if((GLOB.security_level > SEC_LEVEL_BLUE || SShijack.hijack_status) && player_rank.gets_emergency_kit)
		to_chat(character, SPAN_HIGHDANGER("As you stagger out of hypersleep, the sleep bay blares: '[SShijack.evac_status ? "VESSEL UNDERGOING EVACUATION PROCEDURES, SELF DEFENSE KIT PROVIDED" : "VESSEL IN HEIGHTENED ALERT STATUS, SELF DEFENSE KIT PROVIDED"]'."))
		character.put_in_hands(new /obj/item/storage/box/kit/cryo_self_defense(character.loc))

	GLOB.data_core.manifest_inject(character)
	SSticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc. //TODO!!!!! ~Carn
	SSticker.mode.latejoin_update(player_rank)
	SSticker.mode.update_gear_scale()

	for(var/datum/squad/sq in GLOB.RoleAuthority.squads)
		if(sq)
			sq.max_engineers = engi_slot_formula(GLOB.clients.len)
			sq.max_medics = medic_slot_formula(GLOB.clients.len)

	if(SSticker.mode.latejoin_larva_drop && SSticker.mode.latejoin_tally - SSticker.mode.latejoin_larva_used >= SSticker.mode.latejoin_larva_drop)
		SSticker.mode.latejoin_larva_used += SSticker.mode.latejoin_larva_drop
		var/datum/hive_status/hive
		for(var/hivenumber in GLOB.hive_datum)
			hive = GLOB.hive_datum[hivenumber]
			if(hive.latejoin_burrowed == TRUE)
				if(length(hive.totalXenos) && (hive.hive_location || ROUND_TIME < XENO_ROUNDSTART_PROGRESS_TIME_2))
					hive.stored_larva++
					hive.hive_ui.update_burrowed_larva()

	if(character.mind && character.mind.player_entity)
		var/datum/entity/player_entity/player = character.mind.player_entity
		if(player.get_playtime(STATISTIC_HUMAN) == 0 && player.get_playtime(STATISTIC_XENO) == 0)
			msg_admin_niche("NEW JOIN: <b>[key_name(character, 1, 1, 0)]</b>. IP: [character.lastKnownIP], CID: [character.computer_id]")
		if(character.client)
			var/client/client = character.client
			if(client.player_data && client.player_data.playtime_loaded && length(client.player_data.playtimes) == 0)
				msg_admin_niche("NEW PLAYER: <b>[key_name(character, 1, 1, 0)]</b>. IP: [character.lastKnownIP], CID: [character.computer_id]")
			if(client.player_data && client.player_data.playtime_loaded && ((round(client.get_total_human_playtime() DECISECONDS_TO_HOURS, 0.1)) <= CONFIG_GET(number/notify_new_player_age)))
				msg_sea("NEW PLAYER: <b>[key_name(character, 0, 1, 0)]</b> only has [(round(client.get_total_human_playtime() DECISECONDS_TO_HOURS, 0.1))] hours as a human. Current role: [get_actual_job_name(character)] - Current location: [get_area(character)]")

	character.client.init_verbs()
	qdel(src)


/mob/new_player/proc/LateChoices()
	var/mills = world.time // 1/10 of a second, not real milliseconds but whatever
	//var/secs = ((mills % 36000) % 600) / 10 //Not really needed, but I'll leave it here for refrence... or something
	var/mins = (mills % 36000) / 600
	var/hours = mills / 36000

	var/dat = "<html><body onselectstart='return false;'><center>"
	dat += "Round Duration: [round(hours)]h [round(mins)]m<br>"

	if(SShijack)
		switch(SShijack.evac_status)
			if(EVACUATION_STATUS_INITIATED)
				dat += "<font color='red'><b>The [MAIN_SHIP_NAME] is being evacuated.</b></font><br>"

	dat += "Choose from the following open positions:<br>"
	var/roles_show = FLAG_SHOW_ALL_JOBS

	for(var/i in GLOB.RoleAuthority.roles_for_mode)
		var/datum/job/J = GLOB.RoleAuthority.roles_for_mode[i]
		if(!GLOB.RoleAuthority.check_role_entry(src, J, TRUE))
			continue
		var/active = 0
		// Only players with the job assigned and AFK for less than 10 minutes count as active
		for(var/mob/M in GLOB.player_list)
			if(M.client && M.job == J.title)
				active++
		if(roles_show & FLAG_SHOW_CIC && GLOB.ROLES_CIC.Find(J.title))
			dat += "Command:<br>"
			roles_show ^= FLAG_SHOW_CIC

		else if(roles_show & FLAG_SHOW_AUXIL_SUPPORT && GLOB.ROLES_AUXIL_SUPPORT.Find(J.title))
			dat += "<hr>Auxiliary Combat Support:<br>"
			roles_show ^= FLAG_SHOW_AUXIL_SUPPORT

		else if(roles_show & FLAG_SHOW_MISC && GLOB.ROLES_MISC.Find(J.title))
			dat += "<hr>Other:<br>"
			roles_show ^= FLAG_SHOW_MISC

		else if(roles_show & FLAG_SHOW_POLICE && GLOB.ROLES_POLICE.Find(J.title))
			dat += "<hr>Military Police:<br>"
			roles_show ^= FLAG_SHOW_POLICE

		else if(roles_show & FLAG_SHOW_ENGINEERING && GLOB.ROLES_ENGINEERING.Find(J.title))
			dat += "<hr>Engineering:<br>"
			roles_show ^= FLAG_SHOW_ENGINEERING

		else if(roles_show & FLAG_SHOW_REQUISITION && GLOB.ROLES_REQUISITION.Find(J.title))
			dat += "<hr>Requisitions:<br>"
			roles_show ^= FLAG_SHOW_REQUISITION

		else if(roles_show & FLAG_SHOW_MEDICAL && GLOB.ROLES_MEDICAL.Find(J.title))
			dat += "<hr>Medbay:<br>"
			roles_show ^= FLAG_SHOW_MEDICAL

		else if(roles_show & FLAG_SHOW_MARINES && GLOB.ROLES_MARINES.Find(J.title))
			dat += "<hr>Marines:<br>"
			roles_show ^= FLAG_SHOW_MARINES

		dat += "<a href='byond://?src=\ref[src];lobby_choice=SelectedJob;job_selected=[J.title]'>[J.disp_title] ([J.current_positions]) (Active: [active])</a><br>"

	dat += "</center>"
	show_browser(src, dat, "Late Join", "latechoices", "size=420x700")


/mob/new_player/proc/create_character(is_late_join = FALSE)
	spawning = TRUE
	close_spawn_windows()

	var/mob/living/carbon/human/new_character

	if(!new_character)
		new_character = new(loc)

	new_character.lastarea = get_area(loc)

	setup_human(new_character, src, is_late_join)

	new_character.client?.change_view(GLOB.world_view_size)

	return new_character

/mob/new_player/proc/ViewManifest()
	var/dat = "<html><body>"
	dat += "<h4><center>Crew Manifest:</center></h4>"
	dat += GLOB.data_core.get_manifest(FALSE, TRUE)

	show_browser(src, dat, "Crew Manifest", "manifest", "size=450x750")

/mob/new_player/proc/ViewHiveLeaders()
	if(!GLOB.hive_leaders_tgui)
		GLOB.hive_leaders_tgui = new /datum/hive_leaders()
	GLOB.hive_leaders_tgui.tgui_interact(src)

/datum/hive_leaders/Destroy(force, ...)
	SStgui.close_uis(src)
	return ..()

/datum/hive_leaders/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "HiveLeaders", "Hive Leaders")
		ui.open()
		ui.set_autoupdate(FALSE)

// Player panel
/datum/hive_leaders/ui_data(mob/user)
	var/list/data = list()

	var/datum/hive_status/main_hive = GLOB.hive_datum[XENO_HIVE_NORMAL]
	var/list/queens = list()
	if(main_hive.living_xeno_queen)
		queens += list(list("designation" = main_hive.living_xeno_queen.full_designation, "caste_type" = main_hive.living_xeno_queen.name))
	data["queens"] = queens
	var/list/leaders = list()
	for(var/mob/living/carbon/xenomorph/xeno_leader in main_hive.xeno_leader_list)
		leaders += list(list("designation" = xeno_leader.full_designation, "caste_type" = xeno_leader.caste_type))
	data["leaders"] = leaders
	return data


/datum/hive_leaders/ui_state(mob/user)
	return GLOB.always_state

/mob/new_player/Move()
	return 0

/mob/proc/close_spawn_windows() // Somehow spawn menu stays open for non-newplayers
	close_browser(src, "latechoices") //closes late choices window
	close_browser(src, "playersetup") //closes the player setup window
	src << sound(null, repeat = 0, wait = 0, volume = 85, channel = SOUND_CHANNEL_LOBBY) // Stops lobby music.
	if(src.open_uis)
		for(var/datum/nanoui/ui in src.open_uis)
			if(ui.allowed_user_stat == -1)
				ui.close()
				continue

/mob/new_player/get_gender()
	if(!client || !client.prefs) ..()
	return client.prefs.gender

/mob/new_player/is_ready()
	return ready && ..()

/mob/new_player/hear_say(message, verb = "says", datum/language/language = null, alt_name = "", italics = 0, mob/speaker = null)
	return

/mob/new_player/hear_radio(message, verb, datum/language/language, part_a, part_b, mob/speaker, hard_to_hear, vname, command, no_paygrade = FALSE)
	return

/mob/new_player/get_status_tab_items()
	. = ..()
	. += ""
	. += "Game Mode: [GLOB.master_mode]"

	if(SSticker.HasRoundStarted())
		return

	var/time_remaining = SSticker.GetTimeLeft()
	if(time_remaining > 0)
		. += "Time To Start: [round(time_remaining)]s"
	else if(time_remaining == -10)
		. += "Time To Start: DELAYED"
	else
		. += "Time To Start: SOON"

	. += "Players: [SSticker.totalPlayers]"
	if(client.admin_holder)
		. += "Players Ready: [SSticker.totalPlayersReady]"
