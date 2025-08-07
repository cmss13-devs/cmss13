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
	lastarea = get_area(loc)

	GLOB.new_player_list += src

	..()

	initialize_lobby_screen() // This has winsets that can sleep, so all variables must be set prior in the event Logout occurs during sleep

	addtimer(CALLBACK(src, PROC_REF(lobby)), 4 SECONDS)

/mob/new_player/proc/initialize_lobby_screen()
	if(!client)
		return

	var/datum/tgui/ui = SStgui.get_open_ui(src, src)
	if(ui)
		ui.close()

	winset(src, "lobby_browser", "is-disabled=false;is-visible=true")
	winset(src, "mapwindow.status_bar", "is-visible=false")
	lobby_window = new(client, "lobby_browser")
	lobby_window.initialize(
		assets = list(
				get_asset_datum(/datum/asset/simple/tgui),
				get_asset_datum(/datum/asset/simple/namespaced/chakrapetch)
			)
	)

	tgui_interact(src)

/mob/new_player/tgui_interact(mob/user, datum/tgui/ui)
	. = ..()

	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "LobbyMenu", window = lobby_window)
		ui.closeable = FALSE
		ui.open(preinitialized = TRUE)

/mob/new_player/ui_state(mob/user)
	return GLOB.always_state

/mob/new_player/ui_data(mob/user)
	. = ..()

	.["character_name"] = client.prefs ? client.prefs.real_name : client.key

	var/postfix_text = (client.xeno_postfix) ? ("-"+client.xeno_postfix) : ""
	var/prefix_text = (client.xeno_prefix) ? client.xeno_prefix : "XX"
	.["xeno_prefix"] = prefix_text
	.["xeno_postfix"] = postfix_text

	.["tutorials_ready"] = SSticker?.current_state == GAME_STATE_PLAYING
	.["round_start"] = !SSticker || !SSticker.mode || SSticker.current_state <= GAME_STATE_PREGAME
	.["readied"] = ready

	.["confirmation_message"] = lobby_confirmation_message

	.["upp_enabled"] = GLOB.master_mode == /datum/game_mode/extended/faction_clash/cm_vs_upp::name
	.["xenomorph_enabled"] = GLOB.master_mode == /datum/game_mode/colonialmarines::name && client.prefs && (client.prefs.get_job_priority(JOB_XENOMORPH) || client.prefs.get_job_priority(JOB_XENOMORPH_QUEEN))
	.["predator_enabled"] = SSticker.mode?.flags_round_type & MODE_PREDATOR && SSticker.mode.check_predator_late_join(src, FALSE)
	.["fax_responder_enabled"] = SSticker.mode?.check_fax_responder_late_join(src, FALSE)

	.["preference_issues"] = client.prefs.errors

/mob/new_player/ui_static_data(mob/user)
	. = ..()

	.["lobby_author"] = SSlobby_art.author

/mob/new_player/ui_assets(mob/user)
	. = ..()

	. += get_asset_datum(/datum/asset/simple/icon_states/lobby)
	. += get_asset_datum(/datum/asset/simple/lobby_files)

	if(SSlobby_art.initialized)
		. += get_asset_datum(/datum/asset/simple/lobby_art)

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
				return FALSE

			if(!SSentity_manager.ready)
				to_chat(src, SPAN_WARNING("DB is still starting up, please wait"))
				return FALSE

			client.prefs.ShowChoices(src)
			return TRUE

		if("playtimes")
			if(!SSentity_manager.ready)
				to_chat(src, SPAN_WARNING("DB is still starting up, please wait"))
				return FALSE

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
				return FALSE

			if(SSticker.mode.flags_round_type & MODE_NO_LATEJOIN)
				to_chat(src, SPAN_WARNING("Sorry, you cannot late join during [SSticker.mode.name]. You have to start at the beginning of the round. You may observe or try to join as an alien, if possible."))
				return FALSE

			if(client.player_data?.playtime_loaded && (client.get_total_human_playtime() < CONFIG_GET(number/notify_new_player_age)) && !length(client.prefs.completed_tutorials))
				if(tgui_alert(src, "You have little playtime and haven't completed any tutorials. Would you like to go to the tutorial menu?", "Tutorial", list("Yes", "No")) == "Yes")
					tutorial_menu()
					return FALSE

			late_choices()
			return TRUE

		if("late_join_upp")
			if(SSticker.current_state != GAME_STATE_PLAYING || !SSticker.mode)
				to_chat(src, SPAN_WARNING("The round is either not ready, or has already finished..."))
				return FALSE

			if(SSticker.mode.flags_round_type & MODE_NO_LATEJOIN)
				to_chat(src, SPAN_WARNING("Sorry, you cannot late join during [SSticker.mode.name]. You have to start at the beginning of the round. You may observe or try to join as an alien, if possible."))
				return FALSE

			if(client.player_data?.playtime_loaded && (client.get_total_human_playtime() < CONFIG_GET(number/notify_new_player_age)) && !length(client.prefs.completed_tutorials))
				if(tgui_alert(src, "You have little playtime and haven't completed any tutorials. Would you like to go to the tutorial menu?", "Tutorial", list("Yes", "No")) == "Yes")
					tutorial_menu()
					return FALSE

			late_choices_upp()
			return TRUE

		if("late_join_xeno")
			if(SSticker.current_state != GAME_STATE_PLAYING || !SSticker.mode)
				to_chat(src, SPAN_WARNING("The round is either not ready, or has already finished..."))
				return FALSE

			if(!client)
				return FALSE

			if(SSticker.mode.check_xeno_late_join(src))
				var/mob/new_xeno = SSticker.mode.attempt_to_join_as_xeno(src, FALSE)
				if(!new_xeno)
					lobby_confirmation_message = list(
						"Are you sure you wish to observe to be a xeno candidate?",
						"When you observe, you will not be able to join as marine.",
						"It might also take some time to become a xeno or responder!")
					execute_on_confirm = CALLBACK(src, PROC_REF(observe_for_xeno))

				else if(!istype(new_xeno, /mob/living/carbon/xenomorph/larva))
					SSticker.mode.transfer_xeno(src, new_xeno)

				return TRUE

		if("late_join_pred")
			if(SSticker.current_state != GAME_STATE_PLAYING || !SSticker.mode)
				to_chat(src, SPAN_WARNING("The round is either not ready, or has already finished..."))
				return FALSE

			if(SSticker.mode.check_predator_late_join(src, FALSE))
				SSticker.mode.attempt_to_join_as_predator(src)
				return TRUE

			to_chat(src, SPAN_WARNING("You are no longer able to join as predator."))
			return FALSE

		if("late_join_faxes")
			if(SSticker.current_state != GAME_STATE_PLAYING || !SSticker.mode)
				to_chat(src, SPAN_WARNING("The round is either not ready, or has already finished..."))
				return FALSE

			if(SSticker.mode.check_fax_responder_late_join(src, FALSE))
				SSticker.mode.attempt_to_join_as_fax_responder(src, TRUE)
				return TRUE

			to_chat(src, SPAN_WARNING("You are no longer able to join as a Fax Responder."))
			return FALSE

		if("observe")
			if(!SSticker || SSticker.current_state == GAME_STATE_STARTUP)
				to_chat(src, SPAN_WARNING("The game is still setting up, please try again later."))
				return

			attempt_observe()
			return TRUE

		if("ready")
			if((SSticker.current_state <= GAME_STATE_PREGAME) && !ready) // Make sure we don't ready up after the round has started
				ready = TRUE
				GLOB.readied_players++

			return TRUE

		if("unready")
			if((SSticker.current_state <= GAME_STATE_PREGAME) && ready) // Make sure we don't ready up after the round has started
				ready = FALSE
				GLOB.readied_players--

			return TRUE

		if("confirm")
			lobby_confirmation_message = null
			execute_on_confirm?.Invoke()
			execute_on_confirm = null
			return TRUE

		if("unconfirm")
			lobby_confirmation_message = null
			execute_on_confirm = null
			return TRUE

		if("poll")
			SSpolls.tgui_interact(src)
			return TRUE

		if("keyboard")
			playsound_client(client, get_sfx("keyboard"), vol = 20)

/// Join as a 'xeno' - set us up in the larva queue
/mob/new_player/proc/observe_for_xeno()
	if(client.prefs && !(client.prefs.be_special & BE_ALIEN_AFTER_DEATH))
		client.prefs.be_special |= BE_ALIEN_AFTER_DEATH
		to_chat(src, SPAN_BOLDNOTICE("You will now be considered for Xenomorph after unrevivable death events (where possible)."))
	attempt_observe()

/mob/new_player/proc/lobby()
	if(!client)
		return

	client.playtitlemusic()

	var/datum/tgui/ui = SStgui.get_open_ui(src, src)
	if(!ui)
		initialize_lobby_screen()

	if(GLOB.current_tms)
		to_chat(src, SPAN_BOLDANNOUNCE(GLOB.current_tms))
	if(GLOB.join_motd)
		to_chat(src, "<div class=\"motd\">[GLOB.join_motd]</div>")
