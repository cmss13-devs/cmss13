
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

	//logs
	var/date_string = time2text(world.realtime, "YYYY/MM-Month/DD-Day")
	var/year_string = time2text(world.realtime, "YYYY")
	href_logfile = file("data/logs/[date_string] hrefs.htm")
	diary = file("data/logs/[date_string].log")
	tgui_diary = file("data/logs/[date_string]_tgui.log")
	diary << "[log_end]\n[log_end]\nStarting up. [time2text(world.timeofday, "hh:mm.ss")][log_end]\n---------------------[log_end]"
	round_stats = file("data/logs/[year_string]/round_stats.log")
	round_stats << "[log_end]\nStarting up - [time2text(world.realtime,"YYYY-MM-DD (hh:mm:ss)")][log_end]\n---------------------[log_end]"
	round_scheduler_stats = file("data/logs/[year_string]/round_scheduler_stats.log")
	round_scheduler_stats << "[log_end]\nStarting up - [time2text(world.realtime,"YYYY-MM-DD (hh:mm:ss)")][log_end]\n---------------------[log_end]"
	mutator_logs = file("data/logs/[year_string]/mutator_logs.log")
	mutator_logs << "[log_end]\nStarting up - [time2text(world.realtime,"YYYY-MM-DD (hh:mm:ss)")][log_end]\n---------------------[log_end]"
	var/latest_changelog = file("[global.config.directory]/../html/changelogs/archive/" + time2text(world.timeofday, "YYYY-MM") + ".yml")
	GLOB.changelog_hash = fexists(latest_changelog) ? md5(latest_changelog) : 0 //for telling if the changelog has changed recently

	GLOB.revdata = new
	initialize_tgs()
	initialize_marine_armor()

	config.Load(params[OVERRIDE_CONFIG_DIRECTORY_PARAMETER])

	if(CONFIG_GET(flag/log_runtime))
		log = file("data/logs/runtime/[time2text(world.realtime,"YYYY-MM-DD-(hh-mm-ss)")]-runtime.log")

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
	#ifdef UNIT_TESTS
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
		master_mode = "extended"

		// Wait for the game ticker to initialize
		while(!SSticker.initialized)
			sleep(10)

		// Start the game ASAP
		SSticker.request_start()
	return

var/world_topic_spam_protect_ip = "0.0.0.0"
var/world_topic_spam_protect_time = world.timeofday

/world/proc/initialize_tgs()
	TgsNew(new /datum/tgs_event_handler/impl, TGS_SECURITY_TRUSTED)
	GLOB.revdata.load_tgs_info()

/world/Topic(T, addr, master, key)
	TGS_TOPIC

	if (T == "ping")
		var/x = 1
		for (var/client/C)
			x++
		return x

	else if(T == "players")
		return length(GLOB.clients)

	else if (T == "status")
		var/list/s = list()
		s["version"] = game_version
		s["mode"] = master_mode
		s["respawn"] = CONFIG_GET(flag/respawn)
		s["enter"] = enter_allowed
		s["vote"] = CONFIG_GET(flag/allow_vote_mode)
		s["ai"] = CONFIG_GET(flag/allow_ai)
		s["host"] = host ? host : null
		s["players"] = list()
		s["stationtime"] = duration2text()
		var/n = 0
		var/admins = 0

		for(var/client/C in GLOB.clients)
			if(C.admin_holder)
				if(C.admin_holder.fakekey)
					continue //so stealthmins aren't revealed by the hub
				admins++
			s["player[n]"] = C.key
			n++
		s["players"] = n

		s["admins"] = admins

		return list2params(s)

	// Used in external requests for player data.
	else if (T == "pinfo")
		var/retdata = ""
		if(addr != "127.0.0.1")
			return "Nah ah ah, you didn't say the magic word"
		for(var/client/C in GLOB.clients)
			retdata  += C.key+","+C.address+","+C.computer_id+"|"

		return retdata

	else if(copytext(T,1,6) == "notes")
		if(addr != "127.0.0.1")
			return "Nah ah ah, you didn't say the magic word"
		if(!SSdatabase.connection.connection_ready())
			return "Database is not yet ready. Please wait."
		var/input[] = params2list(T)
		var/ckey = trim(input["ckey"])
		var/dat = "Notes for [ckey]:<br/><br/>"
		var/datum/entity/player/P = get_player_from_key(ckey)
		if(!P)
			return ""
		P.load_refs()
		if(!P.notes || !P.notes.len)
			return dat + "No information found on the given key."

		for(var/datum/entity/player_note/N in P.notes)
			var/admin_name = (N.admin && N.admin.ckey) ? "[N.admin.ckey]" : "-LOADING-"
			var/ban_text = N.ban_time ? "Banned for [N.ban_time] minutes | " : ""
			var/confidential_text = N.is_confidential ? " \[CONFIDENTIALLY\]" : ""
			dat += "[ban_text][N.text]<br/>by [admin_name] ([N.admin_rank])[confidential_text] on [N.date]<br/><br/>"
		return dat

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

	if(TgsAvailable())
		send_tgs_restart()

		TgsReboot()
		TgsEndProcess()
	else
		shutdown()

/world/proc/send_tgs_restart()
	if(CONFIG_GET(string/new_round_alert_channel) && CONFIG_GET(string/new_round_alert_role_id))
		if(round_statistics)
			send2chat("[round_statistics.round_name] completed!", CONFIG_GET(string/new_round_alert_channel))
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
	//trigger things to run the whole process
	Master.sleep_offline_after_initializations = FALSE
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
	if(GLOB)
		if(GLOB.total_runtimes != 0)
			fail_reasons = list("Total runtimes: [GLOB.total_runtimes]")
#ifdef UNIT_TESTS
		if(GLOB.failed_any_test)
			LAZYADD(fail_reasons, "Unit Tests failed!")
#endif
	else
		fail_reasons = list("Missing GLOB!")
	if(!fail_reasons)
		text2file("Success!", "data/logs/ci/clean_run.lk")
	else
		log_world("Test run failed!\n[fail_reasons.Join("\n")]")
	sleep(0) //yes, 0, this'll let Reboot finish and prevent byond memes
	qdel(src) //shut it down
