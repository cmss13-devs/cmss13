SUBSYSTEM_DEF(lobby_art)
	name = "Lobby Art"
	init_order = SS_INIT_LOBBYART
	flags = SS_NO_FIRE

	var/selected_file_name
	var/author

/datum/controller/subsystem/lobby_art/Initialize()
	var/list/lobby_arts = CONFIG_GET(str_list/lobby_art_images)
	if(!length(lobby_arts))
		return SS_INIT_SUCCESS

	var/index = rand(1, length(lobby_arts))
	selected_file_name = lobby_arts[index]

	var/list/lobby_authors = CONFIG_GET(str_list/lobby_art_authors)
	if(length(lobby_authors) && index >= length(lobby_authors))
		author = lobby_authors[index]

	for(var/client/client as anything in GLOB.clients)
		var/mob/new_player/player = client.mob // if something is no longer a new player this early, i'm happy with a runtime
		player.update_static_data(player)
		player.lobby_window.send_asset(get_asset_datum(/datum/asset/simple/lobby_art))

	return SS_INIT_SUCCESS
