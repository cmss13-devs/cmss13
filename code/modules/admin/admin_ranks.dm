GLOBAL_LIST_EMPTY(admin_ranks) //list of all ranks with associated rights

//load our rank - > rights associations
/proc/load_admin_ranks()
	GLOB.admin_ranks.Cut()

	//load text from file
	var/list/Lines = file2list("config/admin_ranks.txt")

	//process each line separately
	for(var/line in Lines)
		if(!length(line))
			continue
		if(copytext(line,1,2) == "#")
			continue

		var/list/List = splittext(line,"+")
		if(!length(List))
			continue

		var/rank = ckeyEx(List[1])
		switch(rank)
			if(null,"")
				continue
			if("Removed")
				continue //Reserved

		GLOB.admin_ranks[rank] = get_rights(List.Copy(2))

	#ifdef TESTING
	var/msg = "Permission Sets Built:\n"
	for(var/rank in GLOB.admin_ranks)
		msg += "\t[rank] - [GLOB.admin_ranks[rank]]\n"
	testing(msg)
	#endif

/proc/get_rights(input_list)
	var/rights = NONE

	for(var/right in input_list)
		right = lowertext(right)

		switch(right)
			if("buildmode","build")
				rights |= R_BUILDMODE
			if("admin")
				rights |= R_ADMIN
			if("ban")
				rights |= R_BAN
			if("server")
				rights |= R_SERVER
			if("debug")
				rights |= R_DEBUG
			if("permissions","rights")
				rights |= R_PERMISSIONS
			if("possess")
				rights |= R_POSSESS
			if("stealth")
				rights |= R_STEALTH
			if("color")
				rights |= R_COLOR
			if("varedit")
				rights |= R_VAREDIT
			if("event")
				rights |= R_EVENT
			if("sound","sounds")
				rights |= R_SOUNDS
			if("nolock")
				rights |= R_NOLOCK
			if("spawn","create")
				rights |= R_SPAWN
			if("mod")
				rights |= R_MOD
			if("mentor")
				rights |= R_MENTOR
			if("profiler")
				rights |= R_PROFILER
			if("host")
				rights |= RL_HOST
			if("everything")
				rights |= RL_EVERYTHING

	return rights

/proc/load_admins()
	//clear the datums references
	GLOB.admin_datums.Cut()
	for(var/client/C in GLOB.admins)
		C.remove_admin_verbs()
		C.admin_holder = null
	GLOB.admins.Cut()

	//Clear profile access
	for(var/admin in world.GetConfig("admin"))
		log_debug("Clearing [admin] from APP/admin.")
		world.SetConfig("APP/admin", admin, null)

	if(CONFIG_GET(string/cmdb_url) && CONFIG_GET(string/cmdb_api_key) && fetch_api_admins())
		return
		// API fetch failed, fall through to load from config files

	load_admin_ranks()

		//load text from file
	var/list/ALines = file2list("config/admins.txt")
	var/list/MLines = file2list("config/mentors.txt")

	//process each line separately
	for(var/line in MLines)
		process_rank_file(line, TRUE)
	for(var/line in ALines)
		process_rank_file(line)

	#ifdef TESTING
	var/msg = "Admins Built:\n"
	for(var/ckey in GLOB.admin_datums)
		var/rank
		var/datum/admins/D = GLOB.admin_datums[ckey]
		if(D)
			rank = D.rank
		msg += "\t[ckey] - [rank]\n"
	testing(msg)
	#endif

/proc/process_rank_file(line, mentor = FALSE)
	var/list/MentorRanks = file2list("config/mentor_ranks.txt")
	if(!length(line))
		return
	if(copytext(line,1,2) == "#")
		return

	//Split the line at every "-"
	var/list/List = splittext(line, "-")
	if(!length(List))
		return

	//ckey is before the first "-"
	var/ckey = ckey(List[1])
	if(!ckey)
		return

	//rank follows the first "-"
	var/rank = ""
	if(length(List) >= 2)
		rank = ckeyEx(List[2])

	var/list/extra_titles = list()
	if(length(List) >= 3)
		extra_titles = List.Copy(3)

	if(mentor)
		if(!(LAZYISIN(MentorRanks, rank)))
			log_admin("ADMIN LOADER: WARNING: Mentors.txt attempted to override staff ranks!")
			log_admin("ADMIN LOADER: Override attempt: (Ckey/[ckey]) (Rank/[rank])")
			return

	//load permissions associated with this rank
	var/rights = GLOB.admin_ranks[rank]

	//create the admin datum and store it for later use
	var/datum/admins/D = new /datum/admins(rank, rights, ckey, extra_titles)

	//find the client for a ckey if they are connected and associate them with the new admin datum
	INVOKE_ASYNC(D, TYPE_PROC_REF(/datum/admins, associate), GLOB.directory[ckey])

/datum/config_entry/string/cmdb_url
	protection = CONFIG_ENTRY_LOCKED

/datum/config_entry/string/cmdb_api_key
	protection = CONFIG_ENTRY_HIDDEN | CONFIG_ENTRY_LOCKED

/**
 * Using the API backed admins/admin_ranks requires a response from the endpoint following this schema:

 * ```
 * {
 *   $schema: https://json-schema.org/draft/2020-12/schema,
 *   type: object,
 *   required: [users, groups],
 *   properties: {
 *     users: {
 *       type: array,
 *       items: {
 *         type: object,
 *         required: [ckey, primary_group, display_name],
 *         properties: {
 *           ckey: {
 *             type: string,
 *             description: Unique identifier for the user
 *           },
 *           primary_group: {
 *             type: string,
 *             description: The user's primary permission group
 *           },
 *           display_name: {
 *             type: string,
 *             description: Human-readable role name
 *           },
 *           additional_title: {
 *             type: string,
 *             description: Additional title for the user, only present when the group has a display_name configured
 *           }
 *         }
 *       }
 *     },
 *     groups: {
 *       type: object,
 *       additionalProperties: {
 *         type: object,
 *         additionalProperties: {
 *           type: array,
 *           items: {
 *             type: string,
 *             enum: [
 *               ADMIN,
 *               MOD,
 *               SERVER,
 *               BAN,
 *               VAREDIT,
 *               SPAWN,
 *               DEBUG,
 *               POSSESS,
 *               BUILDMODE,
 *               SOUNDS,
 *               NOLOCK,
 *               MENTOR,
 *               EVENT,
 *               PROFILER,
 *               HOST,
 *               STEALTH,
 *               COLOR,
 *               PERMISSIONS
 *             ]
 *           },
 *           description: List of permissions for this server
 *         }
 *       },
 *       description: Permission groups mapped to servers and their permissions
 *     }
 *   }
 * }
 * ```
 */
/proc/fetch_api_admins()
	var/api_url = CONFIG_GET(string/cmdb_url)
	var/api_key = CONFIG_GET(string/cmdb_api_key)

	if(!api_key || !api_url)
		return FALSE

	var/instance_name = CONFIG_GET(string/instance_name)

	if(!instance_name)
		log_admin("\[ADMIN_API\] INSTANCE_NAME not configured.")
		return FALSE

	var/datum/http_request/request = new
	request.prepare(RUSTG_HTTP_METHOD_GET, api_url, null, list("Authorization" = "Bearer [api_key]"))
	request.execute_blocking()

	var/datum/http_response/response = request.into_response()

	if(!response || response.status_code != 200)

	var/admins_response = null
	try
		admins_response = json_decode(response.body)
	catch(var/exception/error)
		log_admin("\[ADMIN_API\] Error occured while decoding, defaulting to configuration files.")
		return FALSE

	if(isnull(admins_response) || !islist(admins_response))
		log_admin("\[ADMIN_API\] Failed to parse JSON from API response, defaulting to configuration files.")
		return FALSE

	if(!("users" in admins_response) || !("groups" in admins_response))
		log_admin("\[ADMIN_API\] API did not return a properly formed response, defaulting to configuration files.")
		return FALSE

	var/users = admins_response["users"]
	var/groups = admins_response["groups"]

	for(var/group_name, group_ranks in groups)
		if(!(instance_name in group_ranks))
			continue

		GLOB.admin_ranks[group_name] = get_rights(group_ranks[instance_name])

	for(var/user in users)
		if(!("display_name" in user) || !("primary_group" in user) || !("ckey" in user))
			log_admin("\[ADMIN_API\] Invalid entry ([user]) in API response, skipping!")
			continue

		var/additional_title = null
		if("additional_title" in user)
			additional_title = list(user["additional_title"])

		var/datum/admins/admin_datum = new(user["display_name"], GLOB.admin_ranks[user["primary_group"]], user["ckey"], additional_title)

		INVOKE_ASYNC(admin_datum, TYPE_PROC_REF(/datum/admins, associate), GLOB.directory[user["ckey"]])
