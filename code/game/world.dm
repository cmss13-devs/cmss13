
GLOBAL_VAR_INIT(world_view_size, 7)
GLOBAL_VAR_INIT(lobby_view_size, 16)

GLOBAL_LIST_FILE_LOAD(reboot_sfx, "config/reboot_sfx.txt")
/world
	mob = /mob/new_player
	turf = /turf/open/space/basic
	area = /area/space
	view = "15x15"
	cache_lifespan = 0	//stops player uploaded stuff from being kept in the rsc past the current session
	hub = "Exadv1.spacestation13"

/world/New()
	var/debug_server = world.GetConfig("env", "AUXTOOLS_DEBUG_DLL")
	if (debug_server)
		call(debug_server, "auxtools_init")()
		enable_debugging()
	GLOB.internal_tick_usage = 0.2 * world.tick_lag
	hub_password = "kMZy3U5jJHSiBQjr"

#ifdef BYOND_TRACY
	#warn BYOND_TRACY is enabled
	prof_init()
#endif

	//logs
	var/date_string = time2text(world.realtime, "YYYY/MM-Month/DD-Day")
	var/year_string = time2text(world.realtime, "YYYY")
	GLOB.href_logfile = file("data/logs/[date_string] hrefs.htm")
	GLOB.diary = file("data/logs/[date_string].log")
	GLOB.diary << "[GLOB.log_end]\n[GLOB.log_end]\nStarting up. [time2text(world.timeofday, "hh:mm.ss")][GLOB.log_end]\n---------------------[GLOB.log_end]"
	GLOB.round_stats = file("data/logs/[year_string]/round_stats.log")
	GLOB.round_stats << "[GLOB.log_end]\nStarting up - [time2text(world.realtime,"YYYY-MM-DD (hh:mm:ss)")][GLOB.log_end]\n---------------------[GLOB.log_end]"
	GLOB.round_scheduler_stats = file("data/logs/[year_string]/round_scheduler_stats.log")
	GLOB.round_scheduler_stats << "[GLOB.log_end]\nStarting up - [time2text(world.realtime,"YYYY-MM-DD (hh:mm:ss)")][GLOB.log_end]\n---------------------[GLOB.log_end]"
	GLOB.mutator_logs = file("data/logs/[year_string]/mutator_logs.log")
	GLOB.mutator_logs << "[GLOB.log_end]\nStarting up - [time2text(world.realtime,"YYYY-MM-DD (hh:mm:ss)")][GLOB.log_end]\n---------------------[GLOB.log_end]"
	var/latest_changelog = file("[global.config.directory]/../html/changelogs/archive/" + time2text(world.timeofday, "YYYY-MM") + ".yml")
	GLOB.changelog_hash = fexists(latest_changelog) ? md5(latest_changelog) : 0 //for telling if the changelog has changed recently

	GLOB.revdata = new
	initialize_tgs()
	initialize_marine_armor()

	config.Load(params[OVERRIDE_CONFIG_DIRECTORY_PARAMETER])

	if(CONFIG_GET(flag/log_runtime))
		log = file("data/logs/runtime/[time2text(world.realtime,"YYYY-MM-DD-(hh-mm-ss)")]-runtime.log")

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

	. = ..()

	var/testing_locally = (world.params && world.params["local_test"])
	var/running_tests = (world.params && world.params["run_tests"])
	// Only do offline sleeping when the server isn't running unit tests or hosting a local dev test
	sleep_offline = (!running_tests && !testing_locally)

	if(!GLOB.RoleAuthority)
		GLOB.RoleAuthority = new /datum/authority/branch/role()
		to_world(SPAN_DANGER("\b Job setup complete"))

	if(!GLOB.EvacuationAuthority)		GLOB.EvacuationAuthority = new

	change_tick_lag(CONFIG_GET(number/ticklag))
	GLOB.timezoneOffset = text2num(time2text(0,"hh")) * 36000

	Master.Initialize(10, FALSE, TRUE)
	update_status()

	//Scramble the coords obsfucator
	GLOB.obfs_x = rand(-500, 500) //A number between -100 and 100
	GLOB.obfs_y = rand(-500, 500) //A number between -100 and 100

	spawn(3000)		//so we aren't adding to the round-start lag
		if(CONFIG_GET(flag/ToRban))
			ToRban_autoupdate()

		// Wait for the game ticker to initialize
		while(!SSticker.initialized)
			sleep(10)

		// Start the game ASAP
		SSticker.request_start()
	return

GLOBAL_VAR_INIT(world_topic_spam_protect_ip, "0.0.0.0")
GLOBAL_VAR_INIT(world_topic_spam_protect_time, world.timeofday)

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
		s["version"] = GLOB.game_version
		s["mode"] = GLOB.master_mode
		s["respawn"] = CONFIG_GET(flag/respawn)
		s["enter"] = GLOB.enter_allowed
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
					continue	//so stealthmins aren't revealed by the hub
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
		if(!GLOB.SSdatabase.connection.connection_ready())
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

/world/Reboot(var/reason)
	Master.Shutdown()
	send_reboot_sound()
	var/server = CONFIG_GET(string/server)
	for(var/thing in GLOB.clients)
		if(!thing)
			continue
		var/client/C = thing
		C?.tgui_panel?.send_roundrestart()
		if(server)	//if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
			C << link("byond://[server]")

	if(TgsAvailable())
		send_tgs_restart()

		TgsReboot()
		TgsEndProcess()
	else
		shutdown()

/world/proc/send_tgs_restart()
	if(CONFIG_GET(string/new_round_alert_channel) && CONFIG_GET(string/new_round_alert_role_id))
		if(GLOB.round_statistics)
			send2chat("[GLOB.round_statistics.round_name] completed!", CONFIG_GET(string/new_round_alert_channel))
		if(SSmapping.next_map_configs)
			var/datum/map_config/next_map = SSmapping.next_map_configs[GROUND_MAP]
			if(next_map)
				send2chat("<@&[CONFIG_GET(string/new_round_alert_role_id)]> Restarting! Next map is [next_map.map_name]", CONFIG_GET(string/new_round_alert_channel))
		else
			send2chat("<@&[CONFIG_GET(string/new_round_alert_role_id)]> Restarting!", CONFIG_GET(string/new_round_alert_channel))
	return

/world/proc/send_reboot_sound()
	var/reboot_sound = SAFEPICK(GLOB.reboot_sfx)
	if(reboot_sound)
		var/sound/reboot_sound_ref = sound(reboot_sound)
		for(var/client/client as anything in GLOB.clients)
			if(client?.prefs.toggles_sound & SOUND_REBOOT)
				SEND_SOUND(client, reboot_sound_ref)

/world/proc/load_mode()
	var/list/Lines = file2list("data/mode.txt")
	if(Lines.len)
		if(Lines[1])
			GLOB.master_mode = Lines[1]
			log_misc("Saved mode is '[GLOB.master_mode]'")

/world/proc/save_mode(var/the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	F << the_mode

/world/proc/load_motd()
	GLOB.join_motd = file2text("config/motd.txt")

/world/proc/load_tm_message()
	var/datum/getrev/revdata = GLOB.revdata
	if(revdata.testmerge.len)
		GLOB.current_tms = revdata.GetTestMergeInfo()

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
GLOBAL_VAR_INIT(failed_db_connections, 0)
GLOBAL_VAR_INIT(failed_old_db_connections, 0)

// /hook/startup/proc/connectDB()
// 	if(!setup_database_connection())
// 		world.log << "Your server failed to establish a connection with the feedback database."
// 	else
// 		world.log << "Feedback database connection established."
// 	return 1

GLOBAL_DATUM(connection, /datum/BSQL_Connection)
/proc/setup_database_connection()

	if(GLOB.failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to conenct anymore.
		return 0


	return .

/proc/set_global_view(view_size)
	GLOB.world_view_size = view_size
	for(var/client/c in GLOB.clients)
		c.view = GLOB.world_view_size

#undef FAILED_DB_CONNECTION_CUTOFF

/proc/give_image_to_client(var/obj/O, icon_text)
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
 *	byond-tracy is a useful profiling tool that allows the user to view the CPU usage and execution time of procs as they run.
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

	var/init = call(lib, "init")()
	if("0" != init)
		CRASH("[lib] init error: [init]")
