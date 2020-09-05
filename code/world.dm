var/global/datum/global_init/init = new ()

/*
	Pre-map initialization stuff should go here.
*/
/datum/global_init/New()
	load_configuration()
	makeDatumRefLists()

var/world_view_size = 7
var/lobby_view_size = 16

var/internal_tick_usage = 0
/world
	mob = /mob/new_player
	turf = /turf/open/space
	area = /area/space
	view = "15x15"
	cache_lifespan = 0	//stops player uploaded stuff from being kept in the rsc past the current session
	hub = "Exadv1.spacestation13"

/world/New()
	internal_tick_usage = 0.2 * world.tick_lag
	extools_initialize()
	maptick_initialize()
	hub_password = "[config.hub_password]"

	//logs
	var/date_string = time2text(world.realtime, "YYYY/MM-Month/DD-Day")
	var/year_string = time2text(world.realtime, "YYYY")
	href_logfile = file("data/logs/[date_string] hrefs.htm")
	diary = file("data/logs/[date_string].log")
	diary << "[log_end]\n[log_end]\nStarting up. [time2text(world.timeofday, "hh:mm.ss")][log_end]\n---------------------[log_end]"
	round_stats = file("data/logs/[year_string]/round_stats.log")
	round_stats << "[log_end]\nStarting up - [time2text(world.realtime,"YYYY-MM-DD (hh:mm:ss)")][log_end]\n---------------------[log_end]"
	round_scheduler_stats = file("data/logs/[year_string]/round_scheduler_stats.log")
	round_scheduler_stats << "[log_end]\nStarting up - [time2text(world.realtime,"YYYY-MM-DD (hh:mm:ss)")][log_end]\n---------------------[log_end]"
	mutator_logs = file("data/logs/[year_string]/mutator_logs.log")
	mutator_logs << "[log_end]\nStarting up - [time2text(world.realtime,"YYYY-MM-DD (hh:mm:ss)")][log_end]\n---------------------[log_end]"
	changelog_hash = md5('html/changelog.html')					//used for telling if the changelog has changed recently

	if(byond_version < DM_VERSION)
		world.log << "Your server's byond version does not meet the recommended requirements for this server. Please update BYOND"

	initialize_marine_armor()

	if(config && config.server_name != null && config.server_suffix && world.port > 0)
		// dumb and hardcoded but I don't care~
		config.server_name += " #[(world.port % 1000) / 100]"

	if(config && config.log_runtime)
		log = file("data/logs/runtime/[time2text(world.realtime,"YYYY-MM-DD-(hh-mm-ss)")]-runtime.log")

	callHook("startup")
	//Emergency Fix
	//end-emergency fix

	update_status()
	. = ..()

	var/testing_locally = (world.params && world.params["local_test"])
	var/running_tests = (world.params && world.params["run_tests"])
	// Only do offline sleeping when the server isn't running unit tests or hosting a local dev test
	sleep_offline = (!running_tests && !testing_locally)

	// Set up roundstart seed list. This is here because vendors were
	// bugging out and not populating with the correct packet names
	// due to this list not being instantiated.
	populate_seed_list()

	if(!RoleAuthority)
		RoleAuthority = new /datum/authority/branch/role()
		to_world(SPAN_DANGER("\b Job setup complete"))

	if(!EvacuationAuthority)		EvacuationAuthority = new

	world.tick_lag = config.Ticklag

	spawn(1)
		Master.Setup()

//	master_controller = new /datum/controller/game_controller()

	//spawn(1)
		//master_controller.setup()

	//Scramble the coords obsfucator
	obfs_x = rand(-500, 500) //A number between -100 and 100
	obfs_y = rand(-500, 500) //A number between -100 and 100

	spawn(3000)		//so we aren't adding to the round-start lag
		if(config.ToRban)
			ToRban_autoupdate()

	// Allow the test manager to run all unit tests if this is being hosted just to run unit tests
	if(running_tests)
		test_executor.host_tests()

	// If the server's configured for local testing, get everything set up ASAP.
	// Shamelessly stolen from the test manager's host_tests() proc
	if(testing_locally)
		master_mode = "extended"

		// If a test environment was specified, initialize it
		if(fexists("test_environment.txt"))
			var/test_environment = file2text("test_environment.txt")

			var/env_type = null
			for(var/type in subtypesof(/datum/test_environment))
				if("[type]" == test_environment)
					env_type = type
					break

			if(env_type)
				var/datum/test_environment/env = new env_type()
				env.initialize()

		// Wait for the game ticker to initialize
		while(!SSticker.initialized)
			sleep(10)

		// Start the game ASAP
		ticker.current_state = GAME_STATE_SETTING_UP

	return

var/world_topic_spam_protect_ip = "0.0.0.0"
var/world_topic_spam_protect_time = world.timeofday

/world/Topic(T, addr, master, key)
	if(findtext(T, "mapdaemon") == 0) diary << "TOPIC: \"[T]\", from:[addr], master:[master], key:[key][log_end]"

	if (T == "ping")
		var/x = 1
		for (var/client/C)
			x++
		return x

	else if(T == "players")
		var/n = 0
		for(var/mob/M in player_list)
			if(M.client)
				n++
		return n

	else if (T == "status")
		var/list/s = list()
		s["version"] = game_version
		s["mode"] = master_mode
		s["respawn"] = config ? abandon_allowed : 0
		s["enter"] = enter_allowed
		s["vote"] = config.allow_vote_mode
		s["ai"] = config.allow_ai
		s["host"] = host ? host : null
		s["players"] = list()
		s["stationtime"] = duration2text()
		var/n = 0
		var/admins = 0

		for(var/client/C in clients)
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
		for(var/client/C in clients)
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


	/*
	Comment out as we don't use IRC
	else if(copytext(T,1,6) == "notes")
		/*
			We got a request for notes from the IRC Bot
			expected output:
				1. notes = ckey of person the notes lookup is for
				2. validationkey = the key the bot has, it should match the gameservers commspassword in it's configuration.
		*/
		var/input[] = params2list(T)
		if(input["key"] != config.comms_password)
			if(world_topic_spam_protect_ip == addr && abs(world_topic_spam_protect_time - world.time) < 50)

				spawn(50)
					world_topic_spam_protect_time = world.time
					return "Bad Key (Throttled)"

			world_topic_spam_protect_time = world.time
			world_topic_spam_protect_ip = addr
			return "Bad Key"

		return player_notes_show_irc(input["notes"])
		*/


	//START: MAPDAEMON PROCESSING
	if(addr == "127.0.0.1") //Verify that instructions are coming from the local machine

		var/list/md_args = splittext(T,"&")
		var/command = md_args[1]
		var/MD_UID = md_args[2]

		if(command == "mapdaemon_get_round_status")

			if(!ticker) return "ERROR" //Yeah yeah wrong data type, but MapDaemon.java can handle it

			if(MapDaemon_UID == -1) MapDaemon_UID = MD_UID //If we haven't seen an instance of MD yet, this is ours now

			if(kill_map_daemon || MD_UID != MapDaemon_UID) return 2 //The super secret killing code that kills it until it's been killed.

			else if(!ticker.mode) return 0 //Before round start

			else if(ticker.mode.round_finished || force_mapdaemon_vote) return 1

			else return 0 //IDK what would cause this but why not, don't really want runtimes

		else if(MD_UID != MapDaemon_UID)
			return 2 //kill the imposter, kill it with fire

		else if(command == "mapdaemon_delay_round")

			if(!ticker) return "ERROR"
			spawn(200) //20 seconds

				var/text = ""
				text += "<hr><br>"
				text += SPAN_CENTERBOLD("<font color='#00CC00'>You have 30 seconds to vote for the next map! Use the \"Map Vote\" verb in the OOC tab or click <a href='?src=\ref[src];vote_for_map=1'>here</a> to select an option, or open voting window again to change your choice.</font>")
				text += "<hr><br>"

				to_world(text)
				world << 'sound/voice/start_your_voting.ogg'

				for(var/client/C in clients)
					C.mapVote()

				load_maps_for_vote()

			ticker.automatic_delay_end = TRUE
			message_staff("World/Topic() call (likely MapDaemon.exe) has delayed the round end.", 1)
			return "SUCCESS"

		else if(command == "mapdaemon_restart_round")

			if(!ticker) return "ERROR"

			ticker.automatic_delay_end = FALSE
			message_staff("World/Topic() call (likely MapDaemon.exe) has resumed the round end.", 1)

			//So admins have a chance to make EORG bans and do whatever
			if(!ticker.delay_end)
				message_staff(FONT_SIZE_LARGE(SPAN_BOLDANNOUNCE("NOTICE: Delay round within 30 seconds in order to prevent auto-restart!")), 1)

			MapDaemonHandleRestart() //Doesn't hold

			return "WILL DO" //Yessir!

		else if(command == "mapdaemon_receive_votes")
			return count_votes()

var/list/datum/entity/map_vote/all_votes

/world/proc/load_maps_for_vote()
	SSentity_manager.filter_then(/datum/entity/map_vote, null, CALLBACK(world, /world.proc/load_maps_for_vote_callback))

/world/proc/load_maps_for_vote_callback(var/list/datum/entity/map_vote/votes)
	all_votes = list()
	for(var/i in DEFAULT_NEXT_MAP_CANDIDATES)
		var/found = FALSE
		var/datum/entity/map_vote/vote
		for(var/datum/entity/map_vote/in_vote in votes)
			if(in_vote.map_name == i)
				found = TRUE
				vote = in_vote
				break
		
		if(!found)
			vote = SSentity_manager.select(/datum/entity/map_vote)
			vote.map_name = i
			vote.total_votes = 0
			vote.save()

		all_votes[i] = vote
		
/world/proc/count_votes()
	var/list/L = list()

	var/i
	for(i in NEXT_MAP_CANDIDATES)
		if(all_votes && all_votes[i]) // safety check
			L[i] = all_votes[i].total_votes
		else
			L[i] = 0 //Initialize it

	var/forced = 0
	var/force_result = ""
	i = null //Sanitize for safety
	var/j
	for(i in player_votes)
		j = player_votes[i]
		if(i == "}}}") //Special invalid ckey for forcing the next map
			forced = 1
			force_result = j
			continue
		L[j] = L[j] + 1 //Just number of votes indexed by map name

	i = null
	var/most_votes = -1
	var/next_map = ""
	for(i in L)
		if(L[i] > most_votes && (!all_votes || !all_votes[i] || L[i] != all_votes[i].total_votes)) // so if it didn't get any new votes (due to being out of rotation or shit or broken) it is not picked
			most_votes = L[i]
			next_map = i

	if(!enable_map_vote && ticker && ticker.mode)
		next_map = ticker.mode.name
	else if(enable_map_vote && forced)
		next_map = force_result

	var/text = ""
	text += "<font color='#00CC00'>"

	var/log_text = ""
	log_text += "\[[time2text(world.realtime, "DD Month YYYY")]\] Winner: [next_map] ("

	text += "The voting results were:<br>"
	for(var/name in L)
		var/item_text = "[name] - [L[name]]"
		if(!forced && all_votes && all_votes[name])
			var/new_votes = L[name] - all_votes[name].total_votes
			if(!new_votes)
				continue
			item_text += " ([new_votes] new)"
			if(next_map != name)
				all_votes[name].total_votes = L[name]
			else
				all_votes[name].total_votes = 0
			all_votes[name].save()
		
		text += item_text + "<br>"
		log_text += item_text + ","

	log_text += ")\n"

	if(forced) 
		text += "<b>An admin has forced the next map.</b><br>"
	else
		text2file(log_text, "data/map_votes.txt")

	text += "<b>The next map will be on [forced ? force_result : next_map].</b>"

	text += "</font>"

	to_world(text)

	return next_map

/world/Reboot(var/reason)
	/*spawn(0)
		world << sound(pick('sound/AI/newroundsexy.ogg','sound/misc/apcdestroyed.ogg','sound/misc/bangindonk.ogg')) // random end sounds!! - LastyBatsy
		*/

	Master.Shutdown()
	var/round_extra_data = ""
	// Notify helper daemon of reboot, regardless of reason.
	if(ticker && ticker.mode)
		round_extra_data = "&message=[ticker.mode.end_round_message()]"
		
	world.Export("http://127.0.0.1:8888/?rebooting=1[round_extra_data]")
	for(var/client/C in clients)
		var/datum/chatOutput/chat = C.chatOutput
		if(chat)
			chat.browser_send(C, "roundrestart")
		if(config.server)	//if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
			C << link("byond://[config.server]")

	..(reason)




/hook/startup/proc/loadMode()
	world.load_mode()
	return 1

/world/proc/load_mode()
	var/list/Lines = file2list("data/mode.txt")
	if(Lines.len)
		if(Lines[1])
			master_mode = Lines[1]
			log_misc("Saved mode is '[master_mode]'")

/world/proc/save_mode(var/the_mode)
	var/F = file("data/mode.txt")
	fdel(F)
	F << the_mode

/hook/startup/proc/loadMOTD()
	world.load_motd()
	return 1

/world/proc/load_motd()
	join_motd = file2text("config/motd.txt")

/proc/load_configuration()
	config = new /datum/configuration()
	config.load("config/config.txt")
	config.load("config/game_options.txt","game_options")
	config.load("config/icon_source.txt","icon_source")
	// apply some settings from config..
	abandon_allowed = config.respawn


/world/proc/update_status()
	//Note: Hub content is limited to 254 characters, including HTML/CSS. Image width is limited to 450 pixels.
	var/s = ""

	if (config && config.server_name)
		s += "<a href=\"[config.forumurl]\"><b>[config.server_name] &#8212; [MAIN_SHIP_NAME]</b>"
		s += "<br><img src=\"[config.forumurl]/byond_hub_logo.jpg\"></a>"
		// s += "<a href=\"http://goo.gl/04C5lP\">Wiki</a>|<a href=\"http://goo.gl/hMmIKu\">Rules</a>"
		if(ticker)
			if(master_mode)
				s += "<br>Map: <b>[map_tag]</b>"
				if(ticker.mode)
					s += "<br>Mode: <b>[ticker.mode.name]</b>"
				s += "<br>Round time: <b>[duration2text()]</b>"
		else
			s += "<br>Map: <b>[map_tag]</b>"
		// s += enter_allowed ? "<br>Entering: <b>Enabled</b>" : "<br>Entering: <b>Disabled</b>"

		status = s

#define FAILED_DB_CONNECTION_CUTOFF 1
var/failed_db_connections = 0
var/failed_old_db_connections = 0

// /hook/startup/proc/connectDB()
// 	if(!setup_database_connection())
// 		world.log << "Your server failed to establish a connection with the feedback database."
// 	else
// 		world.log << "Feedback database connection established."
// 	return 1

var/datum/BSQL_Connection/connection
proc/setup_database_connection()

	if(failed_db_connections > FAILED_DB_CONNECTION_CUTOFF)	//If it failed to establish a connection more than 5 times in a row, don't bother attempting to conenct anymore.
		return 0


	return .

// /hook/startup/proc/connectOldDB()
// 	if(!setup_old_database_connection())
// 		world.log << "Your server failed to establish a connection with the SQL database."
// 	else
// 		world.log << "SQL database connection established."
// 	return 1

/proc/MapDaemonHandleRestart()
	set waitfor = 0

	ticker.current_state = GAME_STATE_COMPILE_FINISHED

	sleep(300)

	if(ticker.delay_end || ticker.automatic_delay_end)
		return

	to_world(SPAN_DANGER("<b>Restarting world!</b> \blue Initiated by MapDaemon.exe!"))
	log_admin("World/Topic() call (likely MapDaemon.exe) initiated a reboot.")

	sleep(30)
	world.Reboot() //Whatever this is the important part

/proc/set_global_view(view_size)
	world_view_size = view_size
	for(var/client/c in clients)
		c.view = world_view_size

#undef FAILED_DB_CONNECTION_CUTOFF

/proc/give_image_to_client(var/obj/O, icon_text)	
	var/image/I = image(null, O)
	I.maptext = icon_text
	for(var/client/c in clients)
		if(!ishuman(c.mob))
			continue
		c.images += I