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

	data["notes"] = get_all_notes(player.ckey)
	data["total_minutes"] = get_total_living_playtime(player.id)
	data["roles"] = get_whitelisted_roles(player.ckey)
	statuscode = 200
	response = "Lookup successful."

/datum/world_topic/refresh_admins
	key = "refresh_admins"

/datum/world_topic/refresh_admins/Run(list/input)
	. = ..()

	load_admins()

/datum/world_topic/cmtv
	key = "cmtv"
	required_params = list("command")

/datum/world_topic/cmtv/Run(list/input)
	. = ..()

	var/datum/cmtv_command/selected_command = GLOB.cmtv_commands[input["command"]]
	if(!selected_command)
		statuscode = 404
		response = "Invalid command! Use !help to view all commands."
		return

	var/cannot_run = selected_command.cannot_run(input)
	if(cannot_run)
		statuscode = 401
		response = cannot_run
		return

	selected_command.pre_execute(input)

	response = selected_command.execute(input)
	statuscode = selected_command.successful ? 200 : 303

	selected_command.post_execute(input)

/datum/world_topic/active_mobs
	key = "active_mobs"

/datum/world_topic/active_mobs/Run(list/input)
	var/to_follow = SScmtv.get_most_active_list()
	if(!length(to_follow))
		statuscode = 404
		response = "No active mobs available."
		return

	var/list/mobs = list()

	for(var/datum/weakref/weakref in to_follow)
		var/mob/living/living_mob = weakref.resolve()
		if(!living_mob)
			continue

		var/minimap_icon
		var/background

		if(isxeno(living_mob))
			var/mob/living/carbon/xenomorph/xeno = living_mob
			minimap_icon = xeno.caste.minimap_icon
			background = xeno.caste.minimap_background
		else if(ishuman(living_mob))
			var/mob/living/carbon/human/human = living_mob
			if(human.assigned_squad)
				background = human.assigned_squad.background_icon
			else
				background = human.assigned_equipment_preset?.minimap_background

			minimap_icon = human.assigned_equipment_preset?.minimap_icon || "private"

		mobs += list(
			list("name" = living_mob.real_name, "job" = minimap_icon, "background" = background)
		)

	data = mobs
	statuscode = 200
	response = "Active mobs available."
