SUBSYSTEM_DEF(central)
	name = "Central"
	var/list/discord_links = list()
	flags = SS_NO_FIRE

/datum/controller/subsystem/central/stat_entry(msg)
	if(!initialized)
		msg = "OFFLINE"
	else
		msg = "[CONFIG_GET(string/server_type)]"
	return ..()

/datum/controller/subsystem/central/proc/get_player_discord_async(client/player)
	var/endpoint = "[CONFIG_GET(string/central_api_url)]/players/ckey/[player.ckey]"

	SShttp.create_async_request(RUSTG_HTTP_METHOD_GET, endpoint, "", list(), CALLBACK(src, PROC_REF(get_player_discord_callback), player))

/datum/controller/subsystem/central/proc/get_player_discord_callback(client/player, datum/http_response/response)
	if(response.errored || response.status_code != 200 && response.status_code != 404)
		stack_trace("Failed to get player discord: HTTP status code [response.status_code] - [response.error] - [response.body]")
		return

	if(response.status_code == 404)
		return

	var/list/data = json_decode(response.body)
	var/discord_id = data["discord_id"]
	var/ckey = data["ckey"]
	discord_links[ckey] = discord_id

	player.prefs.discord_id = discord_id

/datum/controller/subsystem/central/proc/is_player_discord_linked(client/player)
	if(!player)
		return FALSE

	if(player.prefs.discord_id)
		return TRUE

	// If player somehow losed its id. Not sure if needed
	if(SScentral.discord_links[player.ckey])
		player.prefs.discord_id = SScentral.discord_links[player.ckey]
		return TRUE

	// Update the info just in case
	SScentral.get_player_discord_async(player)

	return FALSE

/datum/controller/subsystem/central/proc/get_player_donate_tier_blocking(client/player)
	var/endpoint = "[CONFIG_GET(string/central_api_url)]/donates?ckey=[player.ckey]&active_only=true&page=1&page_size=1"
	var/datum/http_response/response = SShttp.make_sync_request(RUSTG_HTTP_METHOD_GET, endpoint, "", list())
	if(response.errored || response.status_code != 200)
		stack_trace("Failed to get player donate tier: HTTP status code [response.status_code] - [response.error] - [response.body]")
		return 0

	var/list/data = json_decode(response.body)
	if(length(data["items"]))
		return data["items"][1]["tier"]
