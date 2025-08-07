/datum/world_topic
	/// query key
	var/key

	/// can be used with anonymous authentication
	var/anonymous = FALSE

	var/list/required_params = list()
	var/statuscode
	var/response
	var/data

/datum/world_topic/proc/CheckParams(list/params)
	var/list/missing_params = list()
	var/errorcount = 0

	for(var/param in required_params)
		if(!params[param])
			errorcount++
			missing_params += param

	if(errorcount)
		statuscode = 400
		response = "Bad Request - Missing parameters"
		data = missing_params
		return errorcount

/datum/world_topic/proc/Run(list/input)
	// Always returns true; actual details in statuscode, response and data variables
	return TRUE

// API INFO TOPICS

/datum/world_topic/api_get_authed_functions
	key = "api_get_authed_functions"
	anonymous = TRUE

/datum/world_topic/api_get_authed_functions/Run(list/input)
	. = ..()
	var/list/functions = GLOB.topic_tokens[input["auth"]]
	if(functions)
		statuscode = 200
		response = "Authorized functions retrieved"
		data = functions
	else
		statuscode = 401
		response = "Unauthorized - No functions found"
		data = null

// TOPICS

/datum/world_topic/ping
	key = "ping"
	anonymous = TRUE

/datum/world_topic/ping/Run(list/input)
	. = ..()
	statuscode = 200
	response = "Pong!"
	data = length(GLOB.clients)

/datum/world_topic/playing
	key = "playing"
	anonymous = TRUE

/datum/world_topic/playing/Run(list/input)
	. = ..()
	statuscode = 200
	response = "Player count retrieved"
	data = length(GLOB.player_list)

/datum/world_topic/adminwho
	key = "adminwho"

/datum/world_topic/adminwho/Run(list/input)
	. = ..()
	var/list/admins = list()
	for(var/client/admin in GLOB.admins)
		admins += list(
			"ckey" = admin.ckey,
			"key" = admin.key,
			"rank" = admin.admin_holder.rank,
			"stealth" = admin.admin_holder.fakekey ? TRUE : FALSE,
			"afk" = admin.is_afk(),
		)
	statuscode = 200
	response = "Admin list fetched"
	data = admins

/datum/world_topic/playerlist
	key = "playerlist"
	anonymous = TRUE

/datum/world_topic/playerlist/Run(list/input)
	. = ..()
	data = list()
	for(var/client/C as() in GLOB.clients)
		data += C.ckey
	statuscode = 200
	response = "Player list fetched"

/datum/world_topic/status
	key = "status"
	anonymous = TRUE

/datum/world_topic/status/Run(list/input)
	. = ..()
	data = list()

	data["mode"] = GLOB.master_mode
	data["vote"] = CONFIG_GET(flag/allow_vote_mode)
	data["ai"] = CONFIG_GET(flag/allow_ai)
	data["host"] = world.host ? world.host : null
	data["round_id"] = text2num(GLOB.round_id)
	data["players"] = length(GLOB.clients)
	data["revision"] = GLOB.revdata.commit
	data["revision_date"] = GLOB.revdata.date

	var/list/adm = get_admin_counts()
	var/list/presentmins = adm["present"]
	var/list/afkmins = adm["afk"]
	data["admins"] = length(presentmins) + length(afkmins) //equivalent to the info gotten from adminwho
	data["gamestate"] = SSticker.current_state

	data["map_name"] = SSmapping.configs[GROUND_MAP]?.map_name || "Loading..."

	data["security_level"] = get_security_level()
	data["round_duration"] = ROUND_TIME
	// Amount of world's ticks in seconds, useful for calculating round duration

	//Time dilation stats.
	data["time_dilation_current"] = SStime_track.time_dilation_current
	data["time_dilation_avg"] = SStime_track.time_dilation_avg
	data["time_dilation_avg_slow"] = SStime_track.time_dilation_avg_slow
	data["time_dilation_avg_fast"] = SStime_track.time_dilation_avg_fast

	data["mcpu"] = world.map_cpu
	data["cpu"] = world.cpu

	statuscode = 200
	response = "Status retrieved"

/datum/world_topic/status/authed
	key = "status_authed"
	anonymous = FALSE

/datum/world_topic/status/authed/Run(list/input)
	. = ..()
	// Add on a little extra data for our "special" patrons
	data["active_players"] = get_active_player_count()
	if(SSticker.HasRoundStarted())
		data["real_mode"] = SSticker.mode.name

	data["testmerges"] = list()
	for(var/datum/tgs_revision_information/test_merge/test_merge as anything in GLOB.revdata.testmerge)
		data["testmerges"] += list(
			list("title" = test_merge.title, "number" = test_merge.number, "url" = test_merge.url, "author" = test_merge.author)
		)

/datum/world_topic/certify
	key = "certify"
	required_params = list("identifier", "discord_id")

/datum/world_topic/certify/Run(list/input)
	var/identifier = input["identifier"]
	var/discord_id = input["discord_id"]

	data = list()

	var/datum/view_record/discord_link/existing_link = locate() in DB_VIEW(/datum/view_record/discord_link, DB_COMP("discord_id", DB_EQUALS, discord_id))

	if(existing_link)
		statuscode = 504
		response = "Discord ID already verified."
		return

	var/datum/entity/discord_identifier/id = get_discord_identifier_by_token(identifier)

	if(!id || !id.playerid)
		id.delete()

		statuscode = 500
		response = "Database query failed"
		return

	if(id.realtime < world.realtime - 4 HOURS)
		statuscode = 501
		response = "Authentication timed out."

	var/datum/entity/player/player = DB_ENTITY(/datum/entity/player, id.playerid)
	player.sync()

	if(!player.ckey)
		statuscode = 500
		response = "Database query failed."
		return

	data["ckey"] = player.ckey
	data["roles"] = get_whitelisted_roles(player.ckey)

	if(player.discord_link)
		statuscode = 503
		response = "Player already authenticated."
		return

	var/datum/entity/discord_link/link = DB_EKEY(/datum/entity/discord_link, discord_id)
	link.discord_id = discord_id
	link.player_id = text2num(player.id)
	link.save()
	link.sync()

	player.discord_link = link
	player.discord_link_id = link.id
	player.save()
	player.sync()

	id.used = TRUE
	id.save()
	id.sync()

	statuscode = 200
	response = "Successfully certified."
	data["related_ckeys"] = analyze_ckey(player.ckey)

/datum/world_topic/decertify_by_ckey
	key = "decertify_ckey"
	required_params = list("ckey")

/datum/world_topic/decertify_by_ckey/Run(list/input)
	data = list()

	var/datum/entity/player/player = get_player_from_key(input["ckey"])

	if(!player)
		statuscode = 500
		response = "Database lookup failed."
		return

	if(!player.discord_link)
		statuscode = 501
		response = "No linked Discord."
		return

	var/discord_id = player.discord_link.discord_id

	player.discord_link.delete()
	player.discord_link = null

	player.discord_link_id = null
	player.save()
	player.sync()

	data["discord_id"] = discord_id
	statuscode = 200
	response = "Decertification successful."

/datum/world_topic/decertify_by_discord_id
	key = "decertify_discord_id"
	required_params = list("discord_id")

/datum/world_topic/decertify_by_discord_id/Run(list/input)
	data = list()

	var/datum/view_record/discord_link/link = locate() in DB_VIEW(/datum/view_record/discord_link, DB_COMP("discord_id", DB_EQUALS, input["discord_id"]))

	if(!link || !link.player_id)
		statuscode = 500
		response = "Database lookup failed."
		return

	var/datum/entity/player/player = DB_ENTITY(/datum/entity/player, link.player_id)
	player.sync()

	if(!player.discord_link)
		statuscode = 501
		response = "No linked Discord."
		return

	player.discord_link.delete()
	player.discord_link = null

	player.discord_link_id = null
	player.save()
	player.sync()

	data["discord_id"] = input["discord_id"]
	data["ckey"] = player.ckey
	statuscode = 200
	response = "Decertification successful."

/datum/world_topic/lookup_discord_id
	key = "lookup_discord_id"
	required_params = list("discord_id")

/datum/world_topic/lookup_discord_id/Run(list/input)
	data = list()

	var/datum/view_record/discord_link/link = locate() in DB_VIEW(/datum/view_record/discord_link, DB_COMP("discord_id", DB_EQUALS, input["discord_id"]))

	if(!link || !link.player_id)
		statuscode = 500
		response = "Database lookup failed."
		return

	var/datum/view_record/players/player = locate() in DB_VIEW(/datum/view_record/players, DB_COMP("id", DB_EQUALS, link.player_id))

	data["notes"] = get_all_notes(player.ckey)
	data["total_minutes"] = get_total_living_playtime(player.id)
	data["ckey"] = player.ckey
	data["roles"] = get_whitelisted_roles(player.ckey)
	statuscode = 200
	response = "Lookup successful."

/datum/world_topic/lookup_ckey
	key = "lookup_ckey"
	required_params = list("ckey")

/datum/world_topic/lookup_ckey/Run(list/input)
	data = list()

	var/datum/view_record/players/player = locate() in DB_VIEW(/datum/view_record/players, DB_COMP("ckey", DB_EQUALS, input["ckey"]))
	if(!player)
		statuscode = 501
		response = "Database lookup failed."
		return

	if(player.discord_link_id)
		var/datum/view_record/discord_link/link = locate() in DB_VIEW(/datum/view_record/discord_link, DB_COMP("id", DB_EQUALS, player.discord_link_id))

		if(link && link.discord_id)
			data["discord_id"] = link.discord_id

	data["notes"] = get_all_notes(player.ckey)
	data["total_minutes"] = get_total_living_playtime(player.id)
	data["roles"] = get_whitelisted_roles(player.ckey)
	statuscode = 200
	response = "Lookup successful."
