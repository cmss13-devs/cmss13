
var/world_view_size = 7
var/lobby_view_size = 16

var/internal_tick_usage = 0

var/list/reboot_sfx = file2list("config/reboot_sfx.txt")
/world
	mob = /mob/new_player
	turf = /turf/open/space/basic
	area = /area/space
	view = "15x15"
	cache_lifespan = 0 //stops player uploaded stuff from being kept in the rsc past the current session
	hub = "Exadv1.spacestation13"

/world/New()
	var/debug_server = world.GetConfig("env", "AUXTOOLS_DEBUG_DLL")
	if (debug_server)
		LIBCALL(debug_server, "auxtools_init")()
		enable_debugging()
	internal_tick_usage = 0.2 * world.tick_lag
	hub_password = "kMZy3U5jJHSiBQjr"

#ifdef BYOND_TRACY
	#warn BYOND_TRACY is enabled
	prof_init()
#endif

	GLOB.config_error_log = GLOB.world_attack_log = GLOB.world_href_log = GLOB.world_attack_log = "data/logs/config_error.[GUID()].log"

	config.Load(params[OVERRIDE_CONFIG_DIRECTORY_PARAMETER])

	SSdatabase.start_up()

	SSentity_manager.start_up()
	SSentity_manager.setup_round_id()

	var/latest_changelog = file("[global.config.directory]/../html/changelogs/archive/" + time2text(world.timeofday, "YYYY-MM") + ".yml")
	GLOB.changelog_hash = fexists(latest_changelog) ? md5(latest_changelog) : 0 //for telling if the changelog has changed recently

	initialize_tgs()

	#ifdef UNIT_TESTS
	GLOB.test_log = "data/logs/tests.log"
	#endif

	load_admins()
	jobban_loadbanfile()
	LoadBans()
	load_motd()
	load_tm_message()
	load_mode()
	loadShuttleInfoDatums()
	populate_gear_list()
	initialize_global_regex()

	//Emergency Fix
	//end-emergency fix

	init_global_referenced_datums()

	var/testing_locally = (world.params && world.params["local_test"])
	var/running_tests = (world.params && world.params["run_tests"])
	#if defined(AUTOWIKI) || defined(UNIT_TESTS)
	running_tests = TRUE
	#endif
	// Only do offline sleeping when the server isn't running unit tests or hosting a local dev test
	sleep_offline = (!running_tests && !testing_locally)

	if(!RoleAuthority)
		RoleAuthority = new /datum/authority/branch/role()
		to_world(SPAN_DANGER("\b Job setup complete"))

	if(!EvacuationAuthority) EvacuationAuthority = new

	initiate_minimap_icons()

	change_tick_lag(CONFIG_GET(number/ticklag))
	GLOB.timezoneOffset = text2num(time2text(0,"hh")) * 36000

	Master.Initialize(10, FALSE, TRUE)

	#ifdef UNIT_TESTS
	HandleTestRun()
	#endif

	#ifdef AUTOWIKI
	setup_autowiki()
	#endif

	update_status()

	//Scramble the coords obsfucator
	obfs_x = rand(-500, 500) //A number between -100 and 100
	obfs_y = rand(-500, 500) //A number between -100 and 100

	spawn(3000) //so we aren't adding to the round-start lag
		if(CONFIG_GET(flag/ToRban))
			ToRban_autoupdate()

	// If the server's configured for local testing, get everything set up ASAP.
	// Shamelessly stolen from the test manager's host_tests() proc
	if(testing_locally)
		master_mode = "Extended"

		// Wait for the game ticker to initialize
		while(!SSticker.initialized)
			sleep(10)

		// Start the game ASAP
		SSticker.request_start()
	return

var/world_topic_spam_protect_ip = "0.0.0.0"
var/world_topic_spam_protect_time = world.timeofday

/proc/start_logging()
	GLOB.round_id = SSentity_manager.round.id

	GLOB.log_directory = "data/logs/[time2text(world.realtime, "YYYY/MM-Month/DD-Day")]/round-"

	if(GLOB.round_id)
		GLOB.log_directory += GLOB.round_id
	else
		GLOB.log_directory += "[replacetext(time_stamp(), ":", ".")]"

	runtime_logging_ready = TRUE // Setting up logging now, so disabling early logging
	#ifndef UNIT_TESTS
	world.log = file("[GLOB.log_directory]/dd.log")
	#endif
	backfill_runtime_log()

	GLOB.logger.init_logging()

	GLOB.tgui_log = "[GLOB.log_directory]/tgui.log"
	GLOB.world_href_log = "[GLOB.log_directory]/hrefs.log"
	GLOB.world_game_log = "[GLOB.log_directory]/game.log"
	GLOB.world_attack_log = "[GLOB.log_directory]/attack.log"
	GLOB.world_runtime_log = "[GLOB.log_directory]/runtime.log"
	GLOB.round_stats = "[GLOB.log_directory]/round_stats.log"
	GLOB.scheduler_stats = "[GLOB.log_directory]/round_scheduler_stats.log"
	GLOB.mutator_logs = "[GLOB.log_directory]/mutator_logs.log"

	start_log(GLOB.tgui_log)
	start_log(GLOB.world_href_log)
	start_log(GLOB.world_game_log)
	start_log(GLOB.world_attack_log)
	start_log(GLOB.world_runtime_log)
	start_log(GLOB.round_stats)
	start_log(GLOB.scheduler_stats)
	start_log(GLOB.mutator_logs)

	if(fexists(GLOB.config_error_log))
		fcopy(GLOB.config_error_log, "[GLOB.log_directory]/config_error.log")
		fdel(GLOB.config_error_log)

	if(GLOB.round_id)
		log_game("Round ID: [GLOB.round_id]")

	log_runtime(GLOB.revdata.get_log_message())

/world/proc/initialize_tgs()
	TgsNew(new /datum/tgs_event_handler/impl, TGS_SECURITY_TRUSTED)
	GLOB.revdata.load_tgs_info()

/world/Topic(T, addr, master, key)
	TGS_TOPIC


	var/list/response = list()

	if(length(T) > CONFIG_GET(number/topic_max_size))
		response["statuscode"] = 413
		response["response"] = "Payload too large"
		return json_encode(response)

	if(SSfail_to_topic?.IsRateLimited(addr))
		response["statuscode"] = 429
		response["response"] = "Rate limited"
		return json_encode(response)

	var/logging = CONFIG_GET(flag/log_world_topic)
	var/topic_decoded = rustg_url_decode(T)
	if(!rustg_json_is_valid(topic_decoded))
		if(logging)
			log_topic("(NON-JSON) \"[topic_decoded]\", from:[addr], master:[master], key:[key]")
		// Fallback check for spacestation13.com requests
		if(topic_decoded == "status")
			return list2params(list("players" = length(GLOB.clients)))
		response["statuscode"] = 400
		response["response"] = "Bad Request - Invalid JSON format"
		return json_encode(response)

	var/list/params = json_decode(topic_decoded)
	params["addr"] = addr
	var/query = params["query"]
	var/auth = params["auth"]
	var/source = params["source"]

	if(logging)
		var/list/censored_params = params.Copy()
		censored_params["auth"] = "***[copytext(params["auth"], -4)]"
		log_topic("\"[json_encode(censored_params)]\", from:[addr], master:[master], auth:[censored_params["auth"]], key:[key], source:[source]")

	if(!source)
		response["statuscode"] = 400
		response["response"] = "Bad Request - No source specified"
		return json_encode(response)

	if(!query)
		response["statuscode"] = 400
		response["response"] = "Bad Request - No endpoint specified"
		return json_encode(response)

	if(!LAZYACCESS(GLOB.topic_tokens["[auth]"], "[query]"))
		response["statuscode"] = 401
		response["response"] = "Unauthorized - Bad auth"
		return json_encode(response)

	var/datum/world_topic/command = GLOB.topic_commands["[query]"]
	if(!command)
		response["statuscode"] = 501
		response["response"] = "Not Implemented"
		return json_encode(response)

	if(command.CheckParams(params))
		response["statuscode"] = command.statuscode
		response["response"] = command.response
		response["data"] = command.data
		return json_encode(response)
	else
		command.Run(params)
		response["statuscode"] = command.statuscode
		response["response"] = command.response
		response["data"] = command.data
		return json_encode(response)

/world/Reboot(reason)
	Master.Shutdown()
	send_reboot_sound()
	var/server = CONFIG_GET(string/server)
	for(var/thing in GLOB.clients)
		if(!thing)
			continue
		var/client/C = thing
		C?.tgui_panel?.send_roundrestart()
		if(server) //if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
			C << link("byond://[server]")

	#ifdef UNIT_TESTS
	FinishTestRun()
	return
	#endif

	shutdown_logging()

	if(TgsAvailable())
		send_tgs_restart()
		TgsReboot()
		TgsEndProcess()
	else
		shutdown()

/world/proc/send_tgs_restart()
	if(CONFIG_GET(string/new_round_alert_channel) && CONFIG_GET(string/new_round_alert_role_id))
		if(round_statistics)
			send2chat("[round_statistics.round_name][GLOB.round_id ? " (Round [GLOB.round_id])" : ""] completed!", CONFIG_GET(string/new_round_alert_channel))
		if(SSmapping.next_map_configs)
			var/datum/map_config/next_map = SSmapping.next_map_configs[GROUND_MAP]
			if(next_map)
				send2chat("<@&[CONFIG_GET(string/new_round_alert_role_id)]> Restarting! Next map is [next_map.map_name]", CONFIG_GET(string/new_round_alert_channel))
		else
			send2chat("<@&[CONFIG_GET(string/new_round_alert_role_id)]> Restarting!", CONFIG_GET(string/new_round_alert_channel))
	return

/world/proc/send_reboot_sound()
	var/reboot_sound = SAFEPICK(reboot_sfx)
	if(reboot_sound)
		var/sound/reboot_sound_ref = sound(reboot_sound)
		for(var/client/client as anything in GLOB.clients)
			if(client?.prefs.toggles_sound & SOUND_REBOOT)
				SEND_SOUND(client, reboot_sound_ref)

/world/proc/load_mode()
	var/list/Lines = file2list("data/mode.txt")
	if(Lines.len)
		if(Lines[1])
			master_mode = Lines[1]
			log_misc("Saved mode is '[master_mode]'")

/world/proc/save_mode(the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	F << the_mode

/world/proc/load_motd()
	join_motd = file2text("config/motd.txt")

/world/proc/load_tm_message()
	var/datum/getrev/revdata = GLOB.revdata
	if(revdata.testmerge.len)
		current_tms = revdata.GetTestMergeInfo()

/world/proc/update_status()
	//Note: Hub content is limited to 254 characters, including limited HTML/CSS.
	var/s = ""

	if(CONFIG_GET(string/servername))
		s += "<a href=\"[CONFIG_GET(string/forumurl)]\"><b>[CONFIG_GET(string/servername)]</b></a>"

	if(SSmapping?.configs)
		var/datum/map_config/MG = SSmapping.configs[GROUND_MAP]
		s += "<br>Map: [MG?.map_name ? "<b>[MG.map_name]</b>" : ""]"
	if(SSticker?.mode)
		s += "<br>Mode: <b>[SSticker.mode.name]</b>"
		s += "<br>Round time: <b>[duration2text()]</b>"

	world.status = s

#define FAILED_DB_CONNECTION_CUTOFF 1
var/failed_db_connections = 0
var/failed_old_db_connections = 0

// /hook/startup/proc/connectDB()
// if(!setup_database_connection())
// world.log << "Your server failed to establish a connection with the feedback database."
// else
// world.log << "Feedback database connection established."
// return 1

var/datum/BSQL_Connection/connection
/proc/setup_database_connection()

	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF) //If it failed to establish a connection more than 5 times in a row, don't bother attempting to conenct anymore.
		return 0


	return .

/proc/set_global_view(view_size)
	world_view_size = view_size
	for(var/client/c in GLOB.clients)
		c.view = world_view_size

#undef FAILED_DB_CONNECTION_CUTOFF

/proc/give_image_to_client(obj/O, icon_text)
	var/image/I = image(null, O)
	I.maptext = icon_text
	for(var/client/c in GLOB.clients)
		if(!ishuman(c.mob))
			continue
		c.images += I

/world/proc/change_fps(new_value = 20)
	if(new_value <= 0)
		CRASH("change_fps() called with [new_value] new_value.")
	if(fps == new_value)
		return //No change required.

	fps = new_value
	on_tickrate_change()

/world/proc/change_tick_lag(new_value = 0.5)
	if(new_value <= 0)
		CRASH("change_tick_lag() called with [new_value] new_value.")
	if(tick_lag == new_value)
		return //No change required.

	tick_lag = new_value
	on_tickrate_change()

/world/proc/on_tickrate_change()
	SStimer.reset_buckets()

/world/proc/incrementMaxZ()
	maxz++
	//SSmobs.MaxZChanged()

/** For initializing and starting byond-tracy when BYOND_TRACY is defined
 * byond-tracy is a useful profiling tool that allows the user to view the CPU usage and execution time of procs as they run.
*/
/world/proc/prof_init()
	var/lib

	switch(world.system_type)
		if(MS_WINDOWS)
			lib = "prof.dll"
		if(UNIX)
			lib = "libprof.so"
		else
			CRASH("unsupported platform")

	var/init = LIBCALL(lib, "init")()
	if("0" != init)
		CRASH("[lib] init error: [init]")

/world/proc/HandleTestRun()
	// Wait for the game ticker to initialize
	Master.sleep_offline_after_initializations = FALSE
	UNTIL(SSticker.initialized)

	//trigger things to run the whole process
	SSticker.request_start()
	CONFIG_SET(number/round_end_countdown, 0)
	var/datum/callback/cb
#ifdef UNIT_TESTS
	cb = CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(RunUnitTests))
#else
	cb = VARSET_CALLBACK(SSticker, force_ending, TRUE)
#endif
	SSticker.OnRoundstart(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(_addtimer), cb, 10 SECONDS))

/world/proc/FinishTestRun()
	set waitfor = FALSE
	var/list/fail_reasons
	if(!GLOB)
		fail_reasons = list("Missing GLOB!")
	else if(total_runtimes)
		fail_reasons = list("Total runtimes: [total_runtimes]")
#ifdef UNIT_TESTS
	if(GLOB.failed_any_test)
		LAZYADD(fail_reasons, "Unit Tests failed!")
#endif
	if(!fail_reasons)
		text2file("Success!", "data/logs/ci/clean_run.lk")
	else
		log_world("Test run failed!\n[fail_reasons.Join("\n")]")
	sleep(0) //yes, 0, this'll let Reboot finish and prevent byond memes
	qdel(src) //shut it down


/proc/backfill_runtime_log()
	if(length(full_init_runtimes))
		world.log << "========= EARLY RUNTIME ERRORS ========"
		for(var/line in full_init_runtimes)
			world.log << line
		world.log << "======================================="
		world.log << ""
