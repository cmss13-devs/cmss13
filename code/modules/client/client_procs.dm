	////////////
	//SECURITY//
	////////////
#define TOPIC_SPAM_DELAY	2		//2 ticks is about 2/10ths of a second; it was 4 ticks, but that caused too many clicks to be lost due to lag
#define UPLOAD_LIMIT		10485760	//Restricts client uploads to the server to 10MB //Boosted this thing. What's the worst that can happen?
#define MIN_CLIENT_VERSION	0		//Just an ambiguously low version for now, I don't want to suddenly stop people playing.
									//I would just like the code ready should it ever need to be used.
#define GOOD_BYOND_MAJOR	513
#define GOOD_BYOND_MINOR	1500
	/*
	When somebody clicks a link in game, this Topic is called first.
	It does the stuff in this proc and  then is redirected to the Topic() proc for the src=[0xWhatever]
	(if specified in the link). ie locate(hsrc).Topic()

	Such links can be spoofed.

	Because of this certain things MUST be considered whenever adding a Topic() for something:
		- Can it be fed harmful values which could cause runtimes?
		- Is the Topic call an admin-only thing?
		- If so, does it have checks to see if the person who called it (usr.client) is an admin?
		- Are the processes being called by Topic() particularly laggy?
		- If so, is there any protection against somebody spam-clicking a link?
	If you have any  questions about this stuff feel free to ask. ~Carn
	*/
/client/Topic(href, href_list, hsrc)
	if(!usr || usr != mob)	//stops us calling Topic for somebody else's client. Also helps prevent usr=null
		return

	//Reduces spamming of links by dropping calls that happen during the delay period
	if(next_allowed_topic_time > world.time)
		return
	next_allowed_topic_time = world.time + TOPIC_SPAM_DELAY

	// asset_cache
	var/asset_cache_job
	if(href_list["asset_cache_confirm_arrival"])
		asset_cache_job = asset_cache_confirm_arrival(href_list["asset_cache_confirm_arrival"])
		if (!asset_cache_job)
			return

	//byond bug ID:2256651
	if (asset_cache_job && (asset_cache_job in completed_asset_jobs))
		to_chat(src, "<span class='danger'>An error has been detected in how your client is receiving resources. Attempting to correct.... (If you keep seeing these messages you might want to close byond and reconnect)</span>")
		src << browse("...", "window=asset_cache_browser")
		return

	if (href_list["asset_cache_preload_data"])
		asset_cache_preload_data(href_list["asset_cache_preload_data"])
		return

	if(href_list["_src_"] == "chat") //Hopefully this catches pings before we log
		return chatOutput.Topic(href, href_list)

	//search the href for script injection
	if(findtext(href,"<script",1,0) )
		world.log << "Attempted use of scripts within a topic call, by [src]"
		message_staff("Attempted use of scripts within a topic call, by [src]")
		//del(usr)
		return

	//Admin PM //Why is this not in /datums/admin/Topic()
	if(href_list["priv_msg"])
		var/client/C = locate(href_list["priv_msg"])
		if(ismob(C)) 		//Old stuff can feed-in mobs instead of clients
			var/mob/M = C
			C = M.client
		if(!C) return //Outdated links to logged players generate runtimes
		if(unansweredAhelps[C.computer_id]) unansweredAhelps.Remove(C.computer_id)
		cmd_admin_pm(C,null)
		return

	//Map voting
	if(href_list["vote_for_map"])
		mapVote()
		return

	else if(href_list["FaxView"])
		var/info = locate(href_list["FaxView"])
		show_browser(usr, "<body class='paper'>[info]</body>", "Fax Message", "Fax Message")

	//Logs all hrefs
	if(config && config.log_hrefs && href_logfile)
		href_logfile << "<small>[time2text(world.timeofday,"hh:mm")] [src] (usr:[usr])</small> || [hsrc ? "[hsrc] " : ""][href]<br>"

	switch(href_list["_src_"])
		if("admin_holder")
			hsrc = admin_holder
		if("mhelp")
			var/client/thread_author = GLOB.directory[href_list["mhelp_key"]]
			if(thread_author)
				var/datum/mentorhelp/help_thread = thread_author.current_mhelp
				hsrc = help_thread
		if("usr")
			hsrc = mob
		if("prefs")
			return prefs.process_link(usr, href_list)
		if("vars")
			return view_var_Topic(href, href_list, hsrc)
		if("glob_vars")
			return view_glob_var_Topic(href, href_list, hsrc)
		if("matrices")
			return matrix_editor_Topic(href, href_list, hsrc)
		if("chat")
			return chatOutput.Topic(href, href_list)

	switch(href_list["action"])
		if ("openLink")
			src << link(href_list["link"])
		if ("proccall")
			var/proc_to_call = text2path(href_list["procpath"])
			call(src, proc_to_call)()

	if(href_list[CLAN_ACTION])
		clan_topic(href, href_list)

	return ..()	//redirect to hsrc.Topic()

/client/proc/handle_spam_prevention(var/message, var/mute_type)
	if(config.automute_on && !admin_holder && src.last_message == message)
		src.last_message_count++
		if(src.last_message_count >= SPAM_TRIGGER_AUTOMUTE)
			to_chat(src, SPAN_DANGER("You have exceeded the spam filter limit for identical messages. An auto-mute was applied."))
			cmd_admin_mute(src.mob, mute_type, 1)
			return 1
		if(src.last_message_count >= SPAM_TRIGGER_WARNING)
			to_chat(src, SPAN_DANGER("You are nearing the spam filter limit for identical messages."))
			return 0
	else
		last_message = message
		src.last_message_count = 0
		return 0

//This stops files larger than UPLOAD_LIMIT being sent from client to server via input(), client.Import() etc.
/client/AllowUpload(filename, filelength)
	if(filelength > UPLOAD_LIMIT)
		to_chat(src, "<font color='red'>Error: AllowUpload(): File Upload too large. Upload Limit: [UPLOAD_LIMIT/1024]KiB.</font>")
		return 0
/*	//Don't need this at the moment. But it's here if it's needed later.
	//Helps prevent multiple files being uploaded at once. Or right after eachother.
	var/time_to_wait = fileaccess_timer - world.time
	if(time_to_wait > 0)
		to_chat(src, "<font color='red'>Error: AllowUpload(): Spam prevention. Please wait [round(time_to_wait/10)] seconds.</font>")
		return 0
	fileaccess_timer = world.time + FTPDELAY	*/
	return 1


	///////////
	//CONNECT//
	///////////
/client/New(TopicData)
	chatOutput = new /datum/chatOutput(src)
	soundOutput = new /datum/soundOutput(src)
	TopicData = null							//Prevent calls to client.Topic from connect

	if(!(connection in list("seeker", "web")))					//Invalid connection type.
		return null

	if(!guests_allowed && IsGuestKey(key))
		alert(src,"This server doesn't allow guest accounts to play. Please go to http://www.byond.com/ and register for a key.","Guest","OK")
		qdel(src)
		return

	// Change the way they should download resources.
	if(config.resource_urls)
		src.preload_rsc = pick(config.resource_urls)
	else src.preload_rsc = 1 // If config.resource_urls is not set, preload like normal.

	to_chat_forced(src, SPAN_WARNING("If the title screen is black, resources are still downloading. Please be patient until the title screen appears."))


	GLOB.clients += src
	GLOB.directory[ckey] = src
	player_entity = setup_player_entity(ckey)

	//Admin Authorisation
	admin_holder = admin_datums[ckey]
	if(admin_holder)
		GLOB.admins += src
		admin_holder.owner = src
	add_pref_verbs()
	//preferences datum - also holds some persistant data for the client (because we may as well keep these datums to a minimum)
	prefs = preferences_datums[ckey]
	if(QDELETED(prefs) || !istype(prefs))
		prefs = new /datum/preferences(src)
		preferences_datums[ckey] = prefs
	prefs.owner = src
	prefs.last_ip = address				//these are gonna be used for banning
	prefs.last_id = computer_id			//these are gonna be used for banning
	fps = prefs.fps
	xeno_prefix = prefs.xeno_prefix	
	xeno_postfix = prefs.xeno_postfix
	xeno_name_ban = prefs.xeno_name_ban
	if(!xeno_prefix || xeno_name_ban)	
		xeno_prefix = "XX"
	if(!xeno_postfix || xeno_name_ban)
		xeno_postfix = ""
	. = ..()	//calls mob.Login()
	chatOutput.start()

	// Macros added at runtime
	runtime_macro_insert(prefs.swap_hand_hotkeymode, "hotkeymode", ".SwapMobHand")
	runtime_macro_insert(prefs.swap_hand_default, "default", ".SwapMobHand")
	runtime_macro_insert("Northeast", "hotkeymode", ".SwapMobHand")
	runtime_macro_insert("Northeast", "default", ".SwapMobHand")

	// Version check below if we ever need to start checking against BYOND versions again.

	/*if((byond_version < world.byond_version) || ((byond_version == world.byond_version) && (byond_build < world.byond_build)))
		src << "<span class='warning'>Your version of Byond (v[byond_version].[byond_build]) differs from the server (v[world.byond_version].[world.byond_build]). You may experience graphical glitches, crashes, or other errors. You will be disconnected until your version matches or exceeds the server version.<br> \
		Direct Download (Windows Installer): http://www.byond.com/download/build/[world.byond_version]/[world.byond_version].[world.byond_build]_byond.exe <br> \
		Other versions (search for [world.byond_build] or higher): http://www.byond.com/download/build/[world.byond_version]</span>"
		qdel(src)
		return*/
	//hardcode for now
	if((byond_version < GOOD_BYOND_MAJOR) || ((byond_version == GOOD_BYOND_MAJOR) && (byond_build < GOOD_BYOND_MINOR)))
		to_chat(src, FONT_SIZE_HUGE(SPAN_BOLDNOTICE("YOUR BYOND VERSION IS NOT WELL SUITED FOR THIS SERVER. Download latest BETA build or you may suffer random crashes or disconnects.")))

	var/datum/custom_event_info/CEI = GLOB.custom_event_info_list["Global"]
	CEI.show_player_event_info(src)

	if(mob && !isobserver(mob) && !isnewplayer(mob))
		if(isXeno(mob))
			var/mob/living/carbon/Xenomorph/X = mob
			if(X.hive && GLOB.custom_event_info_list[X.hive])
				CEI = GLOB.custom_event_info_list[X.hive]
				CEI.show_player_event_info(src)

		else if(mob.faction && GLOB.custom_event_info_list[mob.faction])
			CEI = GLOB.custom_event_info_list[mob.faction]
			CEI.show_player_event_info(src)

	if( (world.address == address || !address) && !host )
		host = key
		world.update_status()

	if(admin_holder)
		add_admin_verbs()
		add_admin_whitelists()

	send_assets()

	connection_time = world.time

	create_clickcatcher()
	apply_clickcatcher()

	if(prefs.lastchangelog != changelog_hash) //bolds the changelog button on the interface so we know there are updates.
		winset(src, "rpane.changelog", "background-color=#ED9F9B;font-style=bold")


	var/file = file2text("config/donators.txt")
	var/lines = splittext(file, "\n")

	for(var/line in lines)
		if(src.ckey == line)
			src.donator = 1
			verbs += /client/proc/set_ooc_color_self

	if(prefs.window_skin & TOGGLE_WINDOW_SKIN)
		set_night_skin()

	load_player_data()

	view = world_view_size

	//////////////
	//DISCONNECT//
	//////////////
/client/Del()
	QDEL_NULL(chatOutput)
	QDEL_NULL(soundOutput)
	if(prefs)
		prefs.owner = null
		QDEL_NULL(prefs.preview_dummy)

	if(admin_holder)
		admin_holder.owner = null
		GLOB.admins -= src
	GLOB.directory -= ckey
	GLOB.clients -= src

	. = ..()

/client/Destroy()
	. = ..()

	return QDEL_HINT_HARDDEL_NOW


#undef TOPIC_SPAM_DELAY
#undef UPLOAD_LIMIT
#undef MIN_CLIENT_VERSION

//checks if a client is afk
//3000 frames = 5 minutes
/client/proc/is_afk(duration=3000)
	if(inactivity > duration)	return inactivity
	return 0

//send resources to the client. It's here in its own proc so we can move it around easiliy if need be
/client/proc/send_assets()
	spawn (10) //removing this spawn causes all clients to not get verbs.
		//load info on what assets the client has
		src << browse('code/modules/asset_cache/validate_assets.html', "window=asset_cache_browser")

		//Precache the client with all other assets slowly, so as to not block other browse() calls
		addtimer(CALLBACK(SSassets.transport, /datum/asset_transport.proc/send_assets_slow, src, SSassets.transport.preload), 5 SECONDS)

/client/Stat()
	// We just did a short sleep because of a change, do another to render quickly, but flip the flag back.
	if (stat_fast_update)
		stat_fast_update = 0

	last_statpanel = statpanel

	. = ..() // Do our regular Stat stuff

	//statpanel changed? We doin a short sleep
	if (statpanel != last_statpanel || stat_force_fast_update)
		stat_fast_update = 1
		stat_force_fast_update = 0

	if(!stat_fast_update)
		// Nothing happening, long sleep
		sleep(20)
	return .

/proc/setup_player_entity(var/ckey)
	if(!ckey)
		return
	if(player_entities["[ckey]"])
		return player_entities["[ckey]"]
	var/datum/entity/player_entity/P = new()
	P.ckey = ckey
	P.name = ckey
	player_entities["[ckey]"] = P
	P.setup_save(ckey)
	return P

/proc/save_player_entities()
	for(var/key_ref in player_entities)
		var/datum/entity/player_entity/P = player_entities["[key_ref]"]
		P.save_statistics()
	log_debug("STATISTICS: Statistics saving complete.")
	message_staff("STATISTICS: Statistics saving complete.")

/client/proc/clear_chat_spam_mute(var/warn_level = 1, var/message = FALSE, var/increase_warn = FALSE)
	if(talked > warn_level)
		return
	talked = 0
	if(message)
		to_chat(src, SPAN_NOTICE("You may now speak again."))
	if(increase_warn)
		chatWarn++

//for adding procs that allow showing/hiding other groups of prefs
/client/proc/add_pref_verbs()
	verbs += /client/proc/show_combat_chat_preferences
	verbs += /client/proc/show_ghost_preferences

/client/proc/runtime_macro_insert(var/macro_button, var/parent, var/command)
	if (!macro_button || !parent || !command)
		return

	var/list/macro_sets = params2list(winget(src, null, "macros"))
	if (!(parent in macro_sets))
		var/old = LAZYACCESS(params2list(winget(src, "mainwindow", "macro")), 1)
		if(!old)
			return
		winset(src, null, "mainwindow.macro=[parent]")
		winset(src, null, "mainwindow.macro=[old]")

	winset(src, "[parent].[macro_button]", "parent=[parent];name=[macro_button];command=[command]")

/client/proc/runtime_macro_remove(var/macro_button, var/parent)
	if (!macro_button || !parent)
		return

	var/list/macro_sets = params2list(winget(src, null, "macros"))
	if (!(parent in macro_sets))
		var/old = params2list(winget(src, "mainwindow", "macro"))[1]
		winset(src, null, "mainwindow.macro=[parent]")
		winset(src, null, "mainwindow.macro=[old]")

	winset(src, "[parent].[macro_button]", "parent=")

/client/verb/read_key_down(var/key as text|null)
	set name = ".Read Key Down"
	set hidden = TRUE

	if (!key)
		return

	raiseEvent(src, EVENT_READ_KEY_DOWN, key)

/client/verb/read_key_up(var/key as text|null)
	set name = ".Read Key Up"
	set hidden = TRUE

	if (!key)
		return

	raiseEvent(src, EVENT_READ_KEY_UP, key)

/client/verb/fix_swap_hand_macro()
	set name = "Fix Swap Hand Macros"
	set category = "OOC"

	if (!prefs)
		return

	runtime_macro_remove(prefs.swap_hand_default, "default")
	runtime_macro_insert(prefs.swap_hand_default, "default", ".SwapMobHand")

	runtime_macro_remove(prefs.swap_hand_default, "hotkeymode")
	runtime_macro_insert(prefs.swap_hand_default, "hotkeymode", ".SwapMobHand")

	to_chat(src, SPAN_NOTICE("Fixed your swap hand macros!"))