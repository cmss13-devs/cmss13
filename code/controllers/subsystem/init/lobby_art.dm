SUBSYSTEM_DEF(lobby_art)
	name = "Lobby Art"
	init_order = SS_INIT_LOBBYART
	init_stage = INITSTAGE_EARLY
	wait = 1 SECONDS
	runlevels = ALL

	/// The clients who we've waited a [wait] duration to start working. If they haven't, we reboot them
	var/to_reinitialize = list()

	/// The file name of the selected lobby art, matches a .png in config/lobby_art/, from LOBBY_ART_IMAGES config
	var/selected_file_name

	/// The author of the selected lobby art, determined by the LOBBY_ART_AUTHORS config
	var/author

/datum/controller/subsystem/lobby_art/Initialize()
	var/list/lobby_arts = CONFIG_GET(str_list/lobby_art_images)
	if(!length(lobby_arts))
		return SS_INIT_SUCCESS

	var/index = rand(1, length(lobby_arts))
	selected_file_name = lobby_arts[index]

	var/list/lobby_authors = CONFIG_GET(str_list/lobby_art_authors)
	if(length(lobby_authors) && length(lobby_authors) >= index)
		author = lobby_authors[index]

	for(var/client/client as anything in GLOB.clients)
		var/mob/new_player/player = client.mob // if something is no longer a new player this early, i'm happy with a runtime

		var/datum/tgui/ui = SStgui.get_open_ui(player, player)
		if(!ui)
			continue

		ui.refresh_cooldown = FALSE
		ui.send_full_update(force = TRUE)

		player.lobby_window.send_asset(get_asset_datum(/datum/asset/simple/lobby_art))

	return SS_INIT_SUCCESS

/datum/controller/subsystem/lobby_art/fire(resumed)
	var/list/new_players = GLOB.new_player_list

	for(var/mob/new_player/player as anything in to_reinitialize)
		if(!player.client)
			continue

		var/datum/tgui/ui = SStgui.get_open_ui(player, player)
		if(ui && player.lobby_window && player.lobby_window.status > TGUI_WINDOW_CLOSED)
			continue

		log_tgui(player, "Reinitialized [player.client.ckey]'s lobby window: [ui ? "ui" : "no ui"], status: [player.lobby_window?.status].", "lobby_art/Fire")
		INVOKE_ASYNC(player, TYPE_PROC_REF(/mob/new_player, initialize_lobby_screen))

	var/initialize_queue = list()
	for(var/mob/new_player/player as anything in new_players)
		if(!player.client)
			continue

		if(player in to_reinitialize)
			continue

		var/datum/tgui/ui = SStgui.get_open_ui(player, player)
		if(ui && player.lobby_window && player.lobby_window.status > TGUI_WINDOW_CLOSED)
			continue

		initialize_queue += player

	to_reinitialize = initialize_queue

/datum/controller/subsystem/lobby_art/Shutdown()
	var/to_send = "<!DOCTYPE html><html lang='en'><head><meta http-equiv='X-UA-Compatible' content='IE=edge' /></head><body style='overflow: hidden;padding: 0 !important;margin: 0 !important'><div style='background-image: url([get_asset_datum(/datum/asset/simple/restart_animation).get_url_mappings()["loading"]]);background-position:center;background-size:cover;position:absolute;width:100%;height:100%'></body></html>"

	for(var/client/client as anything in GLOB.clients)
		winset(client, "lobby_browser", "is-disabled=false;is-visible=true")

		client << browse(to_send, "window=lobby_browser")

