/mob/new_player/var/datum/tgui_window/lobby_window

/mob/new_player/Login()
	if(!mind)
		mind = new /datum/mind(key, ckey)
		mind.active = 1
		mind.current = src
		mind_initialize()

	if(length(GLOB.newplayer_start))
		forceMove(get_turf(pick(GLOB.newplayer_start)))
	else
		forceMove(locate(1,1,1))
	lastarea = get_area(src.loc)

	winset(src, "lobby_browser", "is-disabled=false;is-visible=true")
	lobby_window = new(client, "lobby_browser")
	lobby_window.initialize()

	tgui_interact(src)

	. = ..()

	addtimer(CALLBACK(src, PROC_REF(lobby)), 4 SECONDS)

/mob/new_player/tgui_interact(mob/user, datum/tgui/ui)
	. = ..()

	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "LobbyMenu", window = lobby_window)
		ui.set_autoupdate(FALSE)
		ui.open()

/mob/new_player/ui_state(mob/user)
	return GLOB.always_state

/mob/new_player/ui_static_data(mob/user)
	. = ..()

	.["icon"] = get_asset_datum(/datum/asset/simple/icon_states/lobby).get_url_mappings()["uscm.png"]

	var/icons = get_asset_datum(/datum/asset/simple/icon_states/lobby_art).get_url_mappings()
	.["lobby_icon"] = icons[icons[1]]

	.["sound"] = get_asset_datum(/datum/asset/simple/lobby_sound).get_url_mappings()["load"]
	.["sound_interact"] = get_asset_datum(/datum/asset/simple/lobby_sound).get_url_mappings()["interact"]

/mob/new_player/ui_data(mob/user)
	. = ..()

	.["character_name"] = client.prefs ? client.prefs.real_name : client.key

	var/tempnumber = rand(1, 999)
	var/postfix_text = (client.xeno_postfix) ? ("-"+client.xeno_postfix) : ""
	var/prefix_text = (client.xeno_prefix) ? client.xeno_prefix : "XX"
	var/xeno_text = "[prefix_text]-[tempnumber][postfix_text]"
	.["display_number"] = xeno_text

	.["round_start"] = !SSticker || !SSticker.mode || SSticker.current_state <= GAME_STATE_PREGAME
	.["readied"] = ready

	.["upp_enabled"] = GLOB.master_mode == /datum/game_mode/extended/faction_clash/cm_vs_upp::name
	.["xenomorph_enabled"] = client.prefs && (client.prefs.get_job_priority(JOB_XENOMORPH))
	.["predator_enabled"] = SSticker.mode.flags_round_type & MODE_PREDATOR && SSticker.mode.check_predator_late_join(src, FALSE)
	.["fax_responder_enabled"] = SSticker.mode.check_fax_responder_late_join(src, FALSE)

/mob/new_player/ui_assets(mob/user)
	. = ..()

	. += get_asset_datum(/datum/asset/simple/icon_states/lobby)
	. += get_asset_datum(/datum/asset/simple/icon_states/lobby_art)
	. += get_asset_datum(/datum/asset/simple/lobby_sound)

/mob/new_player/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	switch(action)
		if("tutorial")
			tutorial_menu()
			return TRUE

		if("preferences")
			// Otherwise the preview dummy will runtime
			// because atoms aren't initialized yet
			if(SSticker.current_state < GAME_STATE_PREGAME)
				to_chat(src, SPAN_WARNING("Game is still starting up, please wait"))
				return
			if(!SSentity_manager.ready)
				to_chat(src, SPAN_WARNING("DB is still starting up, please wait"))
				return
			client.prefs.ShowChoices(src)
			return TRUE

		if("playtimes")
			if(!SSentity_manager.ready)
				to_chat(src, SPAN_WARNING("DB is still starting up, please wait"))
				return
			if(client.player_data)
				client.player_data.tgui_interact(src)
			return TRUE

		if("manifest")
			ViewManifest()
			return TRUE

		if("hiveleaders")
			ViewHiveLeaders()
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

			late_choices()
			return TRUE

		if("late_join_upp")
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

			late_choices_upp()
			return TRUE

		if("late_join_xeno")
			if(SSticker.current_state != GAME_STATE_PLAYING || !SSticker.mode)
				to_chat(src, SPAN_WARNING("The round is either not ready, or has already finished..."))
				return

			if(tgui_alert(src, "Are you sure you want to attempt joining as a xenomorph?", "Confirmation", list("Yes", "No")) == "Yes")
				if(!client)
					return TRUE
				if(SSticker.mode.check_xeno_late_join(src))
					var/mob/new_xeno = SSticker.mode.attempt_to_join_as_xeno(src, FALSE)
					if(!new_xeno)
						if(tgui_alert(src, "Are you sure you wish to observe to be a xeno candidate? When you observe, you will not be able to join as marine. It might also take some time to become a xeno or responder!", "Player Setup", list("Yes", "No")) == "Yes")
							if(!client)
								return TRUE
							if(client.prefs && !(client.prefs.be_special & BE_ALIEN_AFTER_DEATH))
								client.prefs.be_special |= BE_ALIEN_AFTER_DEATH
								to_chat(src, SPAN_BOLDNOTICE("You will now be considered for Xenomorph after unrevivable death events (where possible)."))
							attempt_observe()
					else if(!istype(new_xeno, /mob/living/carbon/xenomorph/larva))
						SSticker.mode.transfer_xeno(src, new_xeno)

				return TRUE

		if("late_join_pred")
			if(SSticker.current_state != GAME_STATE_PLAYING || !SSticker.mode)
				to_chat(src, SPAN_WARNING("The round is either not ready, or has already finished..."))
				return

			if(tgui_alert(src, "Are you sure you want to attempt joining as a predator?", "Confirmation", list("Yes", "No")) == "Yes")
				if(SSticker.mode.check_predator_late_join(src, FALSE))
					SSticker.mode.attempt_to_join_as_predator(src)
					return TRUE
				else
					to_chat(src, SPAN_WARNING("You are no longer able to join as predator."))

		if("late_join_faxes")
			if(SSticker.current_state != GAME_STATE_PLAYING || !SSticker.mode)
				to_chat(src, SPAN_WARNING("The round is either not ready, or has already finished..."))
				return

			if(alert(src,"Are you sure you want to attempt joining as a Fax Responder?","Confirmation","Yes","No") == "Yes" )
				if(SSticker.mode.check_fax_responder_late_join(src, FALSE))
					SSticker.mode.attempt_to_join_as_fax_responder(src, TRUE)
					return TRUE
				else
					to_chat(src, SPAN_WARNING("You are no longer able to join as a Fax Responder."))

		if("observe")
			if(!SSticker || SSticker.current_state == GAME_STATE_STARTUP)
				to_chat(src, SPAN_WARNING("The game is still setting up, please try again later."))
				return
			if(tgui_alert(src, "Are you sure you wish to observe? When you observe, you will not be able to join as marine. It might also take some time to become a xeno or responder!", "Player Setup", list("Yes", "No")) == "Yes")
				attempt_observe()
				return TRUE

		if("ready")
			if( (SSticker.current_state <= GAME_STATE_PREGAME) && !ready) // Make sure we don't ready up after the round has started
				ready = TRUE
				GLOB.readied_players++

			return TRUE

		if("unready")
			if((SSticker.current_state <= GAME_STATE_PREGAME) && ready) // Make sure we don't ready up after the round has started
				ready = FALSE
				GLOB.readied_players--

			return TRUE

/mob/new_player/Logout()
	QDEL_NULL(lobby_window)

	var/exiting_client = GLOB.directory[persistent_ckey]
	if(exiting_client)
		winset(exiting_client, "lobby_browser", "is-disabled=true;is-visible=false")

	. = ..()

/mob/new_player/proc/lobby()
	if(!client)
		return

	client.playtitlemusic()

	// To show them the full lobby art. This fixes itself on a mind transfer so no worries there.
	client.change_view(GLOB.lobby_view_size)
	// Credit the lobby art author
	if(GLOB.displayed_lobby_art != -1)
		var/list/lobby_authors = CONFIG_GET(str_list/lobby_art_authors)
		var/author = lobby_authors[GLOB.displayed_lobby_art]
		if(author != "Unknown")
			to_chat(src, SPAN_ROUNDBODY("<hr>This round's lobby art is brought to you by [author]<hr>"))
	if(GLOB.current_tms)
		to_chat(src, SPAN_BOLDANNOUNCE(GLOB.current_tms))
	if(GLOB.join_motd)
		to_chat(src, "<div class=\"motd\">[GLOB.join_motd]</div>")
