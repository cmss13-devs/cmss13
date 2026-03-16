/// Subsystem that queries an external API for player achievements
SUBSYSTEM_DEF(achievements)
	name = "Achievements"
	wait = 2 SECONDS
	init_order = SS_INIT_ACHIEVEMENTS
	priority = SS_PRIORITY_ACHIEVEMENTS
	runlevels = RUNLEVELS_DEFAULT|RUNLEVEL_LOBBY

	/// Associated list of key -> achievement datum
	var/list/datum/achievement/all_achivements = list()

	var/list/datum/achievement_to_check/queries_to_check = list()
	var/list/datum/achievement_to_check/grants_to_check = list()

/datum/controller/subsystem/achievements/Initialize()
	var/api_url = CONFIG_GET(string/achievements_api_url)
	var/api_key = CONFIG_GET(string/achievements_api_key)
	var/instance = CONFIG_GET(string/achievements_instance)

	if(!api_url || !api_key || !instance)
		return SS_INIT_NO_NEED

	RegisterSignal(SSdcs, COMSIG_GLOB_CLIENT_LOGGED_IN, PROC_REF(on_client_login))

	for(var/datum/achievement/achievement_type as anything in subtypesof(/datum/achievement))
		if(!length(achievement_type::key))
			continue

		var/datum/achievement/achievement = new achievement_type()
		all_achivements[achievement.key] = achievement

	for(var/client/client in GLOB.clients)
		query_achievements_for_player(client.ckey)

	return SS_INIT_SUCCESS

/datum/achievement_to_check
	var/ckey
	var/datum/http_request/request

	var/datum/achievement/achievement

/datum/achievement_to_check/New(ckey, request, achievement)
	src.ckey = ckey
	src.request = request
	src.achievement = achievement

/datum/controller/subsystem/achievements/fire(resumed)
	var/handled_queries = list()
	for(var/datum/achievement_to_check/query in queries_to_check)
		if(!query.request.is_complete())
			continue

		handle_achievements_response(query.ckey, query.request)
		handled_queries += query

	queries_to_check -= handled_queries

	var/handled_grants = list()
	for(var/datum/achievement_to_check/grant in grants_to_check)
		if(!grant.request.is_complete())
			continue

		handle_achievement_set_complete(grant.ckey, grant.request, grant.achievement)
		handled_grants += grant

	grants_to_check -= handled_grants

/// Signal handler for when a client logs in
/datum/controller/subsystem/achievements/proc/on_client_login(source, client/new_client)
	SIGNAL_HANDLER

	if(!new_client?.ckey)
		return

	INVOKE_ASYNC(src, PROC_REF(query_achievements_for_player), new_client.ckey)

/// Queries the achievements API for a specific player
/datum/controller/subsystem/achievements/proc/query_achievements_for_player(ckey)
	set waitfor = FALSE

	var/api_url = CONFIG_GET(string/achievements_api_url)
	var/api_key = CONFIG_GET(string/achievements_api_key)
	var/instance = CONFIG_GET(string/achievements_instance)

	if(!api_url)
		return

	var/list/headers = list()
	headers["Content-Type"] = "application/json"
	headers["Accept"] = "application/json"
	if(api_key)
		headers["Authorization"] = "Bearer [api_key]"

	var/datum/http_request/request = new
	request.prepare(RUSTG_HTTP_METHOD_GET, "[api_url]?ckey=[url_encode(ckey)]&instance=[instance]", "", headers)
	request.begin_async()

	queries_to_check += new /datum/achievement_to_check(ckey, request)

/// Handle the API response and grant achievements to the player
/datum/controller/subsystem/achievements/proc/handle_achievements_response(ckey, datum/http_request/request)
	var/datum/http_response/response = request.into_response()

	if(response.errored)
		log_debug("Achievements API error for [ckey]: [response.error]")
		return

	if(response.status_code != 200)
		log_debug("Achievements API returned status [response.status_code] for [ckey]")
		return

	var/body = response.body

	var/list/data
	try
		data = json_decode(body)
	catch
		log_debug("Achievements API returned invalid JSON for [ckey]")
		return

	if(!islist(data))
		return

	var/list/achievements = data["achievements"]
	if(!islist(achievements) || !length(achievements))
		return

	var/client/client = GLOB.directory[ckey]
	if(!client)
		return

	new /datum/achievement_manager(client, achievements)

/// Notify a client that they've unlocked an achievement
/datum/controller/subsystem/achievements/proc/notify_achievement_unlocked(client/target, name, description)
	if(!target)
		return

	to_chat(target, SPAN_BOLDNOTICE("Achievement Unlocked: [name]"))
	if(description)
		to_chat(target, SPAN_NOTICE("[description]"))

/// Report that a player has completed an achievement to the backend
/datum/controller/subsystem/achievements/proc/report_achievement_completed(ckey, datum/achievement/achievement)
	set waitfor = FALSE

	if(!ckey || !istype(achievement))
		return

	var/api_url = CONFIG_GET(string/achievements_api_url)
	var/api_key = CONFIG_GET(string/achievements_api_key)
	var/instance = CONFIG_GET(string/achievements_instance)

	if(!api_url)
		return

	var/list/headers = list()
	headers["Content-Type"] = "application/json"
	headers["Accept"] = "application/json"
	if(api_key)
		headers["Authorization"] = "Bearer [api_key]"

	var/list/request_body = list(
		"ckey" = ckey,
		"achievement" = achievement.key,
		"instance" = instance,
	)

	var/datum/http_request/request = new
	request.prepare(RUSTG_HTTP_METHOD_POST, api_url, json_encode(request_body), headers)
	request.begin_async()

	grants_to_check += new /datum/achievement_to_check(ckey, request, achievement)

/datum/controller/subsystem/achievements/proc/handle_achievement_set_complete(ckey, datum/http_request/request, datum/achievement/achievement)
	var/datum/http_response/response = request.into_response()

	if(response.errored)
		log_debug("Achievements API error reporting completion for [ckey] ([achievement.key]): [response.error]")
		return

	if(response.status_code < 200 || response.status_code >= 300)
		log_debug("Achievements API returned status [response.status_code] when reporting completion for [ckey] ([achievement.key])")
		return

	log_debug("Successfully reported achievement '[achievement.key]' completion for [ckey]")

/datum/achievement_manager
	/// The client that we're managing
	var/client/owner

	/// The mob we're tracking, to compare on logged in events
	var/mob/current_mob

	var/list/datum/achievement/achievements = list()

/datum/achievement_manager/New(client/owner, list/achievements)
	if(!owner)
		qdel(src)
		return

	src.owner = owner
	handle_mob_logged_in(new_mob = owner.mob)
	owner.achievement_manager = src

	for(var/achievement_name, achievement_datum in SSachievements.all_achivements)
		if(achievement_name in achievements)
			continue

		var/datum/achievement/existing_achievement = achievement_datum

		var/datum/achievement/my_achievement = new existing_achievement.type
		src.achievements += my_achievement

		my_achievement.register_mob(current_mob)

	RegisterSignal(owner, COMSIG_PARENT_PREQDELETED, PROC_REF(handle_client_qdeleting))
	RegisterSignal(owner, COMSIG_CLIENT_MOB_LOGGED_IN, PROC_REF(handle_mob_logged_in))

/datum/achievement_manager/proc/handle_client_qdeleting()
	SIGNAL_HANDLER

	for(var/datum/achievement/achievement as anything in achievements)
		achievement.unregister_mob(current_mob)

	achievements = null
	owner.achievement_manager = null

/datum/achievement_manager/proc/handle_mob_logged_in(client/_owner, mob/new_mob)
	SIGNAL_HANDLER

	if(current_mob == new_mob)
		return

	for(var/datum/achievement/achievement as anything in achievements)
		achievement.unregister_mob(current_mob)
		achievement.register_mob(new_mob)

	current_mob = new_mob

/datum/achievement
	/// The name of this achievement in the backend
	var/key

	/// What signal should be tracked on the mob to trigger completion
	var/listen_signal

/// When the achievement has been accomplished and should be reported to the backend
/datum/achievement/proc/achieved(client/achiever)
	SSachievements.report_achievement_completed(achiever.ckey, src)

	unregister_mob(achiever.mob)

	achiever.achievement_manager.achievements -= src

/datum/achievement/proc/register_mob(mob/registered)
	if(!key || !listen_signal)
		return

	RegisterSignal(registered, listen_signal, PROC_REF(handle_achieved))

/datum/achievement/proc/unregister_mob(mob/unregistered)
	if(!key || !listen_signal)
		return

	UnregisterSignal(unregistered, listen_signal)

/datum/achievement/proc/handle_achieved(mob/achieved)
	achieved(achieved.client)

/datum/achievement/squad
	var/squad

/datum/achievement/squad/register_mob(mob/registered)
	RegisterSignal(registered, COMSIG_SET_SQUAD, PROC_REF(handle_set_squad))

/datum/achievement/squad/unregister_mob(mob/unregistered)
	UnregisterSignal(unregistered, COMSIG_SET_SQUAD)

/datum/achievement/squad/proc/handle_set_squad(mob/living/carbon/human/set_squad)
	SIGNAL_HANDLER

	if(set_squad.assigned_squad && set_squad.assigned_squad.name == src.squad)
		achieved(set_squad.client)

/datum/achievement/squad/alpha
	key = "join_as_alpha"
	squad = SQUAD_MARINE_1

/datum/achievement/squad/bravo
	key = "join_as_bravo"
	squad = SQUAD_MARINE_2

/datum/achievement/squad/charlie
	key = "join_as_charlie"
	squad = SQUAD_MARINE_3

/datum/achievement/squad/delta
	key = "join_as_delta"
	squad = SQUAD_MARINE_4

/datum/achievement/role
	var/role

/datum/achievement/role/register_mob(mob/registered)
	RegisterSignal(registered, COMSIG_POST_SPAWN_UPDATE, PROC_REF(handle_post_spawn))

/datum/achievement/role/unregister_mob(mob/unregistered)
	UnregisterSignal(unregistered, COMSIG_POST_SPAWN_UPDATE)

/datum/achievement/role/proc/handle_post_spawn(mob/post_spawned)
	SIGNAL_HANDLER

	if(post_spawned.job == role)
		achieved(post_spawned.client)

/datum/achievement/role/doctor
	key = "join_as_doctor"
	role = JOB_DOCTOR

/datum/achievement/role/mp
	key = "join_as_mp"
	role = JOB_POLICE

/datum/achievement/remove_larva
	key = "surgery_remove_larva"
	listen_signal = COMSIG_HUMAN_REMOVED_A_LARVA

/datum/achievement/win_at_rps
	key = "win_at_rps"
	listen_signal = COMSIG_HUMAN_WON_RPS

/datum/achievement/help_ally_up
	key = "help_ally_up"
	listen_signal = COMSIG_HUMAN_HELPING_UP

/datum/achievement/enlist_as_marine
	key = "enlist_as_marine"

/datum/achievement/enlist_as_marine/register_mob(mob/registered)
	RegisterSignal(registered, COMSIG_POST_SPAWN_UPDATE, PROC_REF(handle_post_spawn))

/datum/achievement/enlist_as_marine/unregister_mob(mob/unregistered)
	UnregisterSignal(unregistered, COMSIG_POST_SPAWN_UPDATE)

/datum/achievement/enlist_as_marine/proc/handle_post_spawn(mob/post_spawned)
	if(post_spawned.faction == FACTION_MARINE)
		achieved(post_spawned.client)

/datum/achievement/complete_round_marine
	key = "complete_round_marine"
	listen_signal = COMSIG_HUMAN_FINISHED_ROUND

/datum/achievement/burst_as_xeno
	key = "burst_as_xeno"
	listen_signal = COMSIG_XENO_BURSTED
