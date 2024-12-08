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

	new_player_panel()
	addtimer(CALLBACK(src, PROC_REF(lobby)), 4 SECONDS)

/mob/new_player/tgui_interact(mob/user, datum/tgui/ui)
	. = ..()

	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "LobbyMenu", window = lobby_window)
		ui.handle_geometry = FALSE
		ui.open()

/mob/new_player/ui_state(mob/user)
	return GLOB.always_state

/mob/new_player/ui_static_data(mob/user)
	. = ..()

	.["icon"] = get_asset_datum(/datum/asset/simple/icon_states/lobby).get_url_mappings()["uscm.png"]

	var/lobby_art = get_asset_datum(/datum/asset/simple/icon_states/lobby_art).get_url_mappings()

	.["lobby_icon"] = lobby_art[pick(lobby_art)]

/mob/new_player/ui_assets(mob/user)
	. = ..()

	. += get_asset_datum(/datum/asset/simple/icon_states/lobby)
	. += get_asset_datum(/datum/asset/simple/icon_states/lobby_art)

/mob/new_player/Logout()
	winset(GLOB.directory[persistent_ckey], "lobby_browser", "is-disabled=true;is-visible=false")

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
