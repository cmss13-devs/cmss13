/datum/asset/simple/icon_states/lobby
	icon = 'icons/lobby/icon.dmi'
	prefix = FALSE

/datum/asset/simple/icon_states/lobby_art
	icon = 'icons/lobby/title.dmi'
	prefix = FALSE

/datum/asset/simple/icon_states/lobby_art/register()
	var/picked_icon_state = pick(icon_states(icon))

	var/asset = icon(icon, picked_icon_state)
	if (!asset)
		return
	asset = fcopy_rsc(asset) //dedupe
	var/asset_name = sanitize_filename("[prefix ? "[prefix]." : ""][picked_icon_state].png")
	if (generic_icon_names)
		asset_name = "[generate_asset_name(asset)].png"

	SSassets.transport.register_asset(asset_name, asset)
	assets[asset_name] = asset

/datum/asset/simple/lobby_sound
	assets = list(
		"load" = file('sound/lobby/lobby_load.mp3'),
		"interact" = file('sound/lobby/lobby_interact.mp3')
	)
