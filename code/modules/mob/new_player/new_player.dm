//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:33
/mob/new_player
	var/ready = FALSE
	var/spawning = FALSE//Referenced when you want to delete the new_player later on in the code.

	invisibility = 101

	density = FALSE
	canmove = FALSE
	anchored = TRUE
	universal_speak = TRUE
	stat = DEAD

/mob/new_player/Initialize()
	. = ..()
	GLOB.new_player_list += src
	GLOB.dead_mob_list -= src

/mob/new_player/Destroy()
	if(ready)
		readied_players--
	GLOB.new_player_list -= src
	return ..()

/mob/new_player/verb/new_player_panel()
	set src = usr
	if(client && client.player_entity)
		client.player_entity.update_panel_data(null)
		new_player_panel_proc()


/mob/new_player/proc/new_player_panel_proc(var/refresh = FALSE)
	if(!client)
		return

	var/tempnumber = rand(1, 999)
	var/postfix_text = (client.prefs && client.prefs.xeno_postfix) ? ("-"+client.prefs.xeno_postfix) : ""
	var/prefix_text = (client.prefs && client.prefs.xeno_prefix) ? client.prefs.xeno_prefix : "XX"
	var/xeno_text = "[prefix_text]-[tempnumber][postfix_text]"
	var/round_start = !SSticker || !SSticker.mode || SSticker.current_state <= GAME_STATE_PREGAME

	var/output = "<div align='center'>Welcome,"
	output +="<br><b>[(client.prefs && client.prefs.real_name) ? client.prefs.real_name : client.key]</b>"
	output +="<br><b>[xeno_text]</b>"
	output += "<p><a href='byond://?src=\ref[src];lobby_choice=show_preferences'>Setup Character</A></p>"

	output += "<p><a href='byond://?src=\ref[src];lobby_choice=show_playtimes'>View Playtimes</A></p>"

	if(round_start)
		output += "<p>\[ [ready? "<b>Ready</b>":"<a href='byond://?src=\ref[src];lobby_choice=ready'>Ready</a>"] | [ready? "<a href='byond://?src=\ref[src];lobby_choice=unready'>Not Ready</a>":"<b>Not Ready</b>"] \]</p>"
		output += "<b>Be Xenomorph:</b> [(client.prefs && (client.prefs.get_job_priority(JOB_XENOMORPH))) ? "Yes" : "No"]"

	else
		output += "<a href='byond://?src=\ref[src];lobby_choice=manifest'>View the Crew Manifest</A><br><br>"
		output += "<p><a href='byond://?src=\ref[src];lobby_choice=late_join'>Join the USCM!</A></p>"
		output += "<p><a href='byond://?src=\ref[src];lobby_choice=late_join_xeno'>Join the Hive!</A></p>"
		if(SSticker.mode.flags_round_type & MODE_PREDATOR)
			if(SSticker.mode.check_predator_late_join(src,0)) output += "<p><a href='byond://?src=\ref[src];lobby_choice=late_join_pred'>Join the Hunt!</A></p>"

	output += "<p><a href='byond://?src=\ref[src];lobby_choice=observe'>Observe</A></p>"

	output += "</div>"
	if (refresh)
		close_browser(src, "playersetup")
	show_browser(src, output, null, "playersetup", "size=240x[round_start ? 330 : 380];can_close=0;can_minimize=0")
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
				client.player_data.ui_interact(src)
			return 1

		if("ready")
			if( (SSticker.current_state <= GAME_STATE_PREGAME) && !ready) // Make sure we don't ready up after the round has started
				ready = TRUE
				readied_players++

			new_player_panel_proc()

		if("unready")
			if((SSticker.current_state <= GAME_STATE_PREGAME) && ready) // Make sure we don't ready up after the round has started
				ready = FALSE
				readied_players--

			new_player_panel_proc()

		if("refresh")
			new_player_panel_proc(TRUE)

		if("observe")
			if(!SSticker || SSticker.current_state == GAME_STATE_STARTUP)
				to_chat(src, "<span class='warning'>The game is still setting up, please try again later.</span>")
				return
			if(alert(src,"Are you sure you wish to observe? When you observe, you will not be able to join as marine. It might also take some time to become a xeno or responder!","Player Setup","Yes","No") == "Yes")
				if(!client)
					return TRUE
				var/mob/dead/observer/observer = new()
				spawning = TRUE
				observer.started_as_observer = TRUE

				close_spawn_windows()

				var/obj/O = locate("landmark*Observer-Start")
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
					observer.client.change_view(world_view_size)

				observer.set_huds_from_prefs()

				qdel(src)
				return 1

		if("late_join")

			if(SSticker.current_state != GAME_STATE_PLAYING || !SSticker.mode)
				to_chat(src, SPAN_WARNING("The round is either not ready, or has already finished..."))
				return

			if(SSticker.mode.flags_round_type	& MODE_NO_LATEJOIN)
				to_chat(src, SPAN_WARNING("Sorry, you cannot late join during [SSticker.mode.name]. You have to start at the beginning of the round. You may observe or try to join as an alien, if possible."))
				return

			if(client.prefs.species != "Human")
				if(!is_alien_whitelisted(src, client.prefs.species) && CONFIG_GET(flag/usealienwhitelist))
					to_chat(src, "You are currently not whitelisted to play [client.prefs.species].")
					return

				var/datum/species/S = GLOB.all_species[client.prefs.species]
				if(!(S.flags & IS_WHITELISTED))
					to_chat(src, alert("Your current species,[client.prefs.species], is not available for play on the station."))
					return

			LateChoices()

		if("late_join_xeno")
			if(SSticker.current_state != GAME_STATE_PLAYING || !SSticker.mode)
				to_chat(src, SPAN_WARNING("The round is either not ready, or has already finished..."))
				return

			if(alert(src,"Are you sure you want to attempt joining as a xenomorph?","Confirmation","Yes","No") == "Yes" )
				if(SSticker.mode.check_xeno_late_join(src))
					var/mob/new_xeno = SSticker.mode.attempt_to_join_as_xeno(src, 0)
					if(new_xeno && !istype(new_xeno, /mob/living/carbon/Xenomorph/Larva))
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

		if("SelectedJob")

			if(!enter_allowed)
				to_chat(usr, SPAN_WARNING("There is an administrative lock on entering the game! (The dropship likely crashed into the Almayer. This should take at most 20 minutes.)"))
				return

			if(client.prefs.species != "Human")
				if(!is_alien_whitelisted(src, client.prefs.species) && CONFIG_GET(flag/usealienwhitelist))
					to_chat(src, alert("You are currently not whitelisted to play [client.prefs.species]."))
					return 0

				var/datum/species/S = GLOB.all_species[client.prefs.species]
				if(!(S.flags & IS_WHITELISTED))
					to_chat(src, alert("Your current species,[client.prefs.species], is not available for play on the station."))
					return 0

			AttemptLateSpawn(href_list["job_selected"])
			return

		else
			if(!ready && href_list["preference"])
				if(client) client.prefs.process_link(src, href_list)
			else new_player_panel()

/mob/new_player/proc/AttemptLateSpawn(rank)
	if (src != usr)
		return
	if(SSticker.current_state != GAME_STATE_PLAYING)
		to_chat(usr, SPAN_WARNING("The round is either not ready, or has already finished!"))
		return
	if(!enter_allowed)
		to_chat(usr, SPAN_WARNING("There is an administrative lock on entering the game! (The dropship likely crashed into the Almayer. This should take at most 20 minutes.)"))
		return
	if(!RoleAuthority.assign_role(src, RoleAuthority.roles_for_mode[rank], 1))
		to_chat(src, alert("[rank] is not available. Please try another."))
		return

	spawning = TRUE
	close_spawn_windows()

	var/turf/T
	if(SSmapping.configs[GROUND_MAP].map_name != MAP_WHISKEY_OUTPOST)
		T = get_turf(pick(GLOB.latejoin))
	else if (SSmapping.configs[GROUND_MAP].map_name == MAP_WHISKEY_OUTPOST)
		T = get_turf(pick(GLOB.latewhiskey))

	var/mob/living/carbon/human/character = create_character()	//creates the human and transfers vars and mind
	RoleAuthority.equip_role(character, RoleAuthority.roles_for_mode[rank], T)
	EquipCustomItems(character)

	GLOB.data_core.manifest_inject(character)
	if(SSmapping.configs[GROUND_MAP].map_name == MAP_WHISKEY_OUTPOST)
		call(/datum/game_mode/whiskey_outpost/proc/spawn_player)(character)
	SSticker.minds += character.mind//Cyborgs and AIs handle this in the transform proc.	//TODO!!!!! ~Carn
	SSticker.mode.latejoin_tally++

	for(var/datum/squad/sq in RoleAuthority.squads)
		if(sq)
			sq.max_engineers = engi_slot_formula(GLOB.clients.len)
			sq.max_medics = medic_slot_formula(GLOB.clients.len)

	if(SSticker.mode.latejoin_larva_drop && SSticker.mode.latejoin_tally >= SSticker.mode.latejoin_larva_drop)
		SSticker.mode.latejoin_tally -= SSticker.mode.latejoin_larva_drop
		var/datum/hive_status/HS
		for(var/hivenumber in GLOB.hive_datum)
			HS = GLOB.hive_datum[hivenumber]
			if(length(HS.totalXenos))
				HS.stored_larva++
				HS.hive_ui.update_pooled_larva()

	if(character.mind && character.mind.player_entity)
		var/datum/entity/player_entity/player = character.mind.player_entity
		if(player.get_playtime(STATISTIC_HUMAN) == 0 && player.get_playtime(STATISTIC_XENO) == 0)
			msg_admin_niche("NEW PLAYER: <b>[key_name(character, 1, 1, 0)] (<A HREF='?_src_=admin_holder;ahelp=adminmoreinfo;extra=\ref[character]'>?</A>)</b>. IP: [character.lastKnownIP], CID: [character.computer_id]")

	character.client.init_statbrowser() // init verbs for the late join

	qdel(src)


/mob/new_player/proc/LateChoices()
	var/mills = world.time // 1/10 of a second, not real milliseconds but whatever
	//var/secs = ((mills % 36000) % 600) / 10 //Not really needed, but I'll leave it here for refrence.. or something
	var/mins = (mills % 36000) / 600
	var/hours = mills / 36000

	var/dat = "<html><body onselectstart='return false;'><center>"
	dat += "Round Duration: [round(hours)]h [round(mins)]m<br>"

	if(EvacuationAuthority)
		switch(EvacuationAuthority.evac_status)
			if(EVACUATION_STATUS_INITIATING) dat += "<font color='red'><b>The [MAIN_SHIP_NAME] is being evacuated.</b></font><br>"
			if(EVACUATION_STATUS_COMPLETE) dat += "<font color='red'>The [MAIN_SHIP_NAME] has undergone evacuation.</font><br>"

	dat += "Choose from the following open positions:<br>"
	var/roles_show = FLAG_SHOW_ALL_JOBS

	for(var/i in RoleAuthority.roles_for_mode)
		var/datum/job/J = RoleAuthority.roles_for_mode[i]
		if(!RoleAuthority.check_role_entry(src, J, TRUE))
			continue
		var/active = 0
		// Only players with the job assigned and AFK for less than 10 minutes count as active
		for(var/mob/M in GLOB.player_list)
			if(M.client && M.job == J.title)
				active++
		if(roles_show & FLAG_SHOW_CIC && ROLES_CIC.Find(J.title))
			dat += "Command:<br>"
			roles_show ^= FLAG_SHOW_CIC

		else if(roles_show & FLAG_SHOW_AUXIL_SUPPORT && ROLES_AUXIL_SUPPORT.Find(J.title))
			dat += "<hr>Auxiliary Combat Support:<br>"
			roles_show ^= FLAG_SHOW_AUXIL_SUPPORT

		else if(roles_show & FLAG_SHOW_MISC && ROLES_MISC.Find(J.title))
			dat += "<hr>Other:<br>"
			roles_show ^= FLAG_SHOW_MISC

		else if(roles_show & FLAG_SHOW_POLICE && ROLES_POLICE.Find(J.title))
			dat += "<hr>Military Police:<br>"
			roles_show ^= FLAG_SHOW_POLICE

		else if(roles_show & FLAG_SHOW_ENGINEERING && ROLES_ENGINEERING.Find(J.title))
			dat += "<hr>Engineering:<br>"
			roles_show ^= FLAG_SHOW_ENGINEERING

		else if(roles_show & FLAG_SHOW_REQUISITION && ROLES_REQUISITION.Find(J.title))
			dat += "<hr>Requisitions:<br>"
			roles_show ^= FLAG_SHOW_REQUISITION

		else if(roles_show & FLAG_SHOW_MEDICAL && ROLES_MEDICAL.Find(J.title))
			dat += "<hr>Medbay:<br>"
			roles_show ^= FLAG_SHOW_MEDICAL

		else if(roles_show & FLAG_SHOW_MARINES && ROLES_MARINES.Find(J.title))
			dat += "<hr>Squad Marine:<br>"
			roles_show ^= FLAG_SHOW_MARINES

		dat += "<a href='byond://?src=\ref[src];lobby_choice=SelectedJob;job_selected=[J.title]'>[J.disp_title] ([J.current_positions]) (Active: [active])</a><br>"

	dat += "</center>"
	show_browser(src, dat, "Late Join", "latechoices", "size=420x700")


/mob/new_player/proc/create_character()
	spawning = TRUE
	close_spawn_windows()

	var/mob/living/carbon/human/new_character

	var/datum/species/chosen_species
	if(client.prefs.species)
		chosen_species = GLOB.all_species[client.prefs.species]
	if(chosen_species)
		// Have to recheck admin due to no usr at roundstart. Latejoins are fine though.
		if(is_species_whitelisted(chosen_species) || has_admin_rights())
			new_character = new(loc, client.prefs.species)

	if(!new_character)
		new_character = new(loc)

	new_character.lastarea = get_area(loc)

	client.prefs.copy_all_to(new_character)

	if (client.prefs.be_random_body)
		var/datum/preferences/TP = new()
		TP.randomize_appearance(new_character)

	if(mind)
		mind_initialize()
		mind.active = 0					//we wish to transfer the key manually
		mind.original = new_character
		mind.transfer_to(new_character)					//won't transfer key since the mind is not active
		mind.setup_human_stats()

	new_character.job = job
	new_character.name = real_name
	new_character.voice = real_name

	if(client.prefs.disabilities)
		new_character.disabilities |= NEARSIGHTED

	// Update the character icons
	// This is done in set_species when the mob is created as well, but
	INVOKE_ASYNC(new_character, /mob/living/carbon/human.proc/regenerate_icons)
	INVOKE_ASYNC(new_character, /mob/living/carbon/human.proc/update_body, 1, 0)
	INVOKE_ASYNC(new_character, /mob/living/carbon/human.proc/update_hair)

	new_character.key = key		//Manually transfer the key to log them in

	if(new_character.client)
		new_character.client.change_view(world_view_size)
		new_character.client.init_statbrowser()

	return new_character

/mob/new_player/proc/ViewManifest()
	var/dat = "<html><body>"
	dat += "<h4><center>Crew Manifest:</center></h4>"
	dat += GLOB.data_core.get_manifest(FALSE, TRUE)

	show_browser(src, dat, "Crew Manifest", "manifest", "size=450x750")

/mob/new_player/Move()
	return 0

/mob/proc/close_spawn_windows() // Somehow spawn menu stays open for non-newplayers
	close_browser(src, "latechoices") //closes late choices window
	close_browser(src, "playersetup") //closes the player setup window
	src << sound(null, repeat = 0, wait = 0, volume = 85, channel = 1) // Stops lobby music.
	if(src.open_uis)
		for(var/datum/nanoui/ui in src.open_uis)
			if(ui.allowed_user_stat == -1)
				ui.close()
				continue

/mob/new_player/proc/has_admin_rights()
	return client.admin_holder.rights & R_ADMIN

/mob/new_player/proc/is_species_whitelisted(datum/species/S)
	if(!S) return 1
	return is_alien_whitelisted(src, S.name) || !CONFIG_GET(flag/usealienwhitelist) || !(S.flags & IS_WHITELISTED)

/mob/new_player/get_species()
	var/datum/species/chosen_species
	if(client.prefs.species)
		chosen_species = GLOB.all_species[client.prefs.species]

	if(!chosen_species)
		return "Human"

	if(is_species_whitelisted(chosen_species) || has_admin_rights())
		return chosen_species.name

	return "Human"

/mob/new_player/get_gender()
	if(!client || !client.prefs) ..()
	return client.prefs.gender

/mob/new_player/is_ready()
	return ready && ..()

/mob/new_player/hear_say(var/message, var/verb = "says", var/datum/language/language = null, var/alt_name = "",var/italics = 0, var/mob/speaker = null)
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
