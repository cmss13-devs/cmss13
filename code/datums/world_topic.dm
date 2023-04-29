// VERSION

// Update topic version whenever changes are made
// The Version Number follows SemVer http://semver.org/
#define TOPIC_VERSION_MAJOR		2	//	Major Version Number --> Increment when implementing breaking changes
#define TOPIC_VERSION_MINOR		0	//	Minor Version Number --> Increment when adding features
#define TOPIC_VERSION_PATCH		0	//	Patchlevel --> Increment when fixing bugs

// DATUM

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

/datum/world_topic/api_get_version
	key = "api_get_version"
	anonymous = TRUE

/datum/world_topic/api_get_version/Run(list/input)
	. = ..()
	var/list/version = list()
	var/versionstring = null

	version["major"] = TOPIC_VERSION_MAJOR
	version["minor"] = TOPIC_VERSION_MINOR
	version["patch"] = TOPIC_VERSION_PATCH

	versionstring = "[version["major"]].[version["minor"]].[version["patch"]]"

	statuscode = 200
	response = versionstring
	data = version

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
		admins[++admins.len] = list(
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
	data["version"] = GLOB.game_version
	data["mode"] = GLOB.master_mode
	data["enter"] = GLOB.enter_allowed
	data["vote"] = CONFIG_GET(flag/allow_vote_mode)
	data["ai"] = CONFIG_GET(flag/allow_ai)
	data["host"] = world.host ? world.host : null
	// data["round_id"] = text2num(GLOB.round_id)
	data["players"] = GLOB.clients.len
	data["revision"] = GLOB.revdata.commit
	data["revision_date"] = GLOB.revdata.date

	var/list/adm = get_admin_counts()
	var/list/presentmins = adm["present"]
	var/list/afkmins = adm["afk"]
	data["admins"] = presentmins.len + afkmins.len //equivalent to the info gotten from adminwho
	data["gamestate"] = SSticker.current_state

	data["map_name"] = SSmapping.configs[GROUND_MAP]?.map_name || "Loading..."

	data["security_level"] = get_security_level()
	data["round_duration"] = ROUND_TIME
	// Amount of world's ticks in seconds, useful for calculating round duration

	//Time dilation stats.
	/*
	data["time_dilation_current"] = SStime_track.time_dilation_current
	data["time_dilation_avg"] = SStime_track.time_dilation_avg
	data["time_dilation_avg_slow"] = SStime_track.time_dilation_avg_slow
	data["time_dilation_avg_fast"] = SStime_track.time_dilation_avg_fast
	*/

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

/datum/world_topic/certify
	key = "certify"
	required_params = list("identifier", "id")

/datum/world_topic/certify/Run(list/input)
	var/identifier = input["identifier"]
	var/discord_id = input["id"]

	data = list()

	var/datum/entity/discord_identifier/id = DB_EKEY(/datum/entity/discord_identifier, identifier)

	if(!id)
		statuscode = 500
		response = "Database query failed"
		return

	var/datum/entity/player/player = DB_ENTITY(/datum/entity/player, id.playerid)

	if(!player)
		return

	player.discord_id = discord_id
	player.save()

	statuscode = 200
	response = "CKEY [player.ckey] certified."

#undef TOPIC_VERSION_MAJOR
#undef TOPIC_VERSION_MINOR
#undef TOPIC_VERSION_PATCH
