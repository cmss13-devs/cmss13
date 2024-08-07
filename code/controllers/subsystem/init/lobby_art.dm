SUBSYSTEM_DEF(lobby_art)
	name = "Lobby Art"
	init_order = SS_INIT_LOBBYART
	flags   = SS_NO_FIRE

/datum/controller/subsystem/lobby_art/Initialize()
	var/list/lobby_arts = CONFIG_GET(str_list/lobby_art_images)
	if(length(lobby_arts))
		force_lobby_art(rand(1, length(lobby_arts)))
	return SS_INIT_SUCCESS
