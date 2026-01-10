/datum/asset/simple/icon_states/lobby
	icon = 'icons/lobby/icon.dmi'
	prefix = FALSE

/datum/asset/simple/lobby_art/register()
	var/icon_string = "config/lobby_art/[SSlobby_art.selected_file_name].png"

	if(!icon_string || !fexists(icon_string))
		return

	var/asset = icon(icon_string)
	if (!asset)
		return

	asset = fcopy_rsc(asset) //dedupe
	var/asset_name = "lobby_art.png"

	SSassets.transport.register_asset(asset_name, asset)
	assets[asset_name] = asset

/datum/asset/simple/lobby_files
	keep_local_name = TRUE
	assets = list(
		"load.mp3" = 'sound/lobby/lobby_load.mp3',
	)

/datum/asset/simple/restart_animation
	assets = list(
		"loading" = 'html/lobby/loading.gif'
	)
