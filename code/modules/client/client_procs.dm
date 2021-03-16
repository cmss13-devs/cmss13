	////////////
	//SECURITY//
	////////////
#define TOPIC_SPAM_DELAY	2		//2 ticks is about 2/10ths of a second; it was 4 ticks, but that caused too many clicks to be lost due to lag
#define UPLOAD_LIMIT		10485760	//Restricts client uploads to the server to 10MB //Boosted this thing. What's the worst that can happen?
#define MIN_CLIENT_VERSION	0		//Just an ambiguously low version for now, I don't want to suddenly stop people playing.
									//I would just like the code ready should it ever need to be used.
#define GOOD_BYOND_MAJOR	513
#define GOOD_BYOND_MINOR	1500

#define LIMITER_SIZE	5
#define CURRENT_SECOND	1
#define SECOND_COUNT	2
#define CURRENT_MINUTE	3
#define MINUTE_COUNT	4
#define ADMINSWARNED_AT	5
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

// This can be replaced with a more sophisticated solution later
GLOBAL_LIST_INIT(whitelisted_client_procs, list(
	/client/proc/toggle_ignore_self,
	/client/proc/toggle_help_intent_safety,
	/client/proc/toggle_auto_eject,
	/client/proc/toggle_auto_eject_to_hand,
	/client/proc/toggle_eject_to_hand,
	/client/proc/toggle_automatic_punctuation,
	/client/proc/toggle_middle_mouse_click
))

/client/Topic(href, href_list, hsrc)
	if(!usr || usr != mob)	//stops us calling Topic for somebody else's client. Also helps prevent usr=null
		return

	// asset_cache
	var/asset_cache_job
	if(href_list["asset_cache_confirm_arrival"])
		asset_cache_job = asset_cache_confirm_arrival(href_list["asset_cache_confirm_arrival"])
		if (!asset_cache_job)
			return

	// Rate limiting
	var/mtl = CONFIG_GET(number/minute_topic_limit)
	if (!admin_holder && mtl)
		var/minute = round(world.time, 600)
		if (!topiclimiter)
			topiclimiter = new(LIMITER_SIZE)
		if (minute != topiclimiter[CURRENT_MINUTE])
			topiclimiter[CURRENT_MINUTE] = minute
			topiclimiter[MINUTE_COUNT] = 0
		topiclimiter[MINUTE_COUNT] += 1
		if (topiclimiter[MINUTE_COUNT] > mtl)
			var/msg = "Your previous action was ignored because you've done too many in a minute."
			if (minute != topiclimiter[ADMINSWARNED_AT]) //only one admin message per-minute. (if they spam the admins can just boot/ban them)
				topiclimiter[ADMINSWARNED_AT] = minute
				msg += " Administrators have been informed."
				log_game("[key_name(src)] Has hit the per-minute topic limit of [mtl] topic calls in a given game minute")
				message_admins("[key_name(usr)] Has hit the per-minute topic limit of [mtl] topic calls in a given game minute")
			to_chat(src, "<span class='danger'>[msg]</span>")
			return

	var/stl = CONFIG_GET(number/second_topic_limit)
	if (!admin_holder && stl)
		var/second = round(world.time, 10)
		if (!topiclimiter)
			topiclimiter = new(LIMITER_SIZE)
		if (second != topiclimiter[CURRENT_SECOND])
			topiclimiter[CURRENT_SECOND] = second
			topiclimiter[SECOND_COUNT] = 0
		topiclimiter[SECOND_COUNT] += 1
		if (topiclimiter[SECOND_COUNT] > stl)
			to_chat(src, "<span class='danger'>Your previous action was ignored because you've done too many in a second</span>")
			return

	// Tgui Topic middleware
	if(tgui_Topic(href_list))
		return
	if(href_list["reload_tguipanel"])
		nuke_chat()
	if(href_list["reload_statbrowser"])
		src << browse(file('html/statbrowser.html'), "window=statbrowser")

	//byond bug ID:2256651
	if (asset_cache_job && (asset_cache_job in completed_asset_jobs))
		to_chat(src, "<span class='danger'>An error has been detected in how your client is receiving resources. Attempting to correct.... (If you keep seeing these messages you might want to close byond and reconnect)</span>")
		src << browse("...", "window=asset_cache_browser")
		return

	if (href_list["asset_cache_preload_data"])
		asset_cache_preload_data(href_list["asset_cache_preload_data"])
		return

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

	else if(href_list["FaxView"])
		var/info = locate(href_list["FaxView"])
		show_browser(usr, "<body class='paper'>[info]</body>", "Fax Message", "Fax Message")

	//Logs all hrefs
	if(CONFIG_GET(flag/log_hrefs) && href_logfile)
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
		if("vote")
			return SSvote.Topic(href, href_list)

	switch(href_list["action"])
		if ("openLink")
			src << link(href_list["link"])
		if ("proccall")
			var/proc_to_call = text2path(href_list["procpath"])

			if(proc_to_call in GLOB.whitelisted_client_procs)
				call(src, proc_to_call)()
			else
				message_staff("[key_name_admin(src)] attempted to do a href exploit. (Inputted command: [proc_to_call])")
			return // Don't call hsrc in this case since it's ourselves

	if(href_list[CLAN_ACTION])
		clan_topic(href, href_list)

	return ..()	//redirect to hsrc.Topic()

/client/proc/handle_spam_prevention(var/message, var/mute_type)
	if(CONFIG_GET(flag/automute_on) && !admin_holder && src.last_message == message)
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
	soundOutput = new /datum/soundOutput(src)
	TopicData = null							//Prevent calls to client.Topic from connect

	if(!(connection in list("seeker", "web")))					//Invalid connection type.
		return null

	if(IsGuestKey(key))
		alert(src,"This server doesn't allow guest accounts to play. Please go to http://www.byond.com/ and register for a key.","Guest","OK")
		qdel(src)
		return

	GLOB.clients += src
	GLOB.directory[ckey] = src

	// Instantiate tgui panel
	tgui_panel = new(src)

	// Change the way they should download resources.
	var/static/next_external_rsc = 0
	var/list/external_rsc_urls = CONFIG_GET(keyed_list/external_rsc_urls)
	if(length(external_rsc_urls))
		next_external_rsc = WRAP(next_external_rsc+1, 1, external_rsc_urls.len+1)
		preload_rsc = external_rsc_urls[next_external_rsc]

	player_entity = setup_player_entity(ckey)

	if(!CONFIG_GET(flag/no_localhost_rank))
		var/static/list/localhost_addresses = list("127.0.0.1", "::1")
		if(isnull(address) || (address in localhost_addresses))
			var/datum/admins/admin = new("!localhost!", R_EVERYTHING, ckey)
			admin.associate(src)

	//Admin Authorisation
	admin_holder = admin_datums[ckey]
	if(admin_holder)
		admin_holder.associate(src)

	add_pref_verbs()
	//preferences datum - also holds some persistant data for the client (because we may as well keep these datums to a minimum)
	prefs = preferences_datums[ckey]
	if(QDELETED(prefs) || !istype(prefs))
		prefs = new /datum/preferences(src)
		preferences_datums[ckey] = prefs
	prefs.client_reconnected(src)
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

	var/full_version = "[byond_version].[byond_build ? byond_build : "xxx"]"

	if(GLOB.player_details[ckey])
		player_details = GLOB.player_details[ckey]
		player_details.byond_version = full_version
	else
		player_details = new
		player_details.byond_version = full_version
		GLOB.player_details[ckey] = player_details

	view = world_view_size
	. = ..()	//calls mob.Login()

	runtime_macro_insert("Northeast", "hotkeymode", ".SwapMobHand")
	runtime_macro_insert("Northeast", "default", ".SwapMobHand")

	if(SSinput.initialized)
		set_macros()

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

	// Initialize tgui panel
	src << browse(file('html/statbrowser.html'), "window=statbrowser")
	addtimer(CALLBACK(src, .proc/check_panel_loaded), 30 SECONDS)
	tgui_panel.initialize()

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

	connection_time = world.time
	winset(src, null, "command=\".configure graphics-hwmode on\"")

	send_assets()

	create_clickcatcher()
	apply_clickcatcher()

	if(prefs.lastchangelog != changelog_hash) //bolds the changelog button on the interface so we know there are updates.
		winset(src, "infowindow.changelog", "background-color=#ED9F9B;font-style=bold")


	var/file = file2text("config/donators.txt")
	var/lines = splittext(file, "\n")

	for(var/line in lines)
		if(src.ckey == line)
			src.donator = 1
			add_verb(src, /client/proc/set_ooc_color_self)

	//if(prefs.window_skin & TOGGLE_WINDOW_SKIN)
	//	set_night_skin()

	load_player_data()

	view = world_view_size

	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_CLIENT_LOGIN, src)

	//////////////
	//DISCONNECT//
	//////////////
/client/Del()
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
	add_verb(src, /client/proc/show_combat_chat_preferences)
	add_verb(src, /client/proc/show_ghost_preferences)

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

	SEND_SIGNAL(src, COMSIG_CLIENT_KEY_DOWN, key)

/client/verb/read_key_up(var/key as text|null)
	set name = ".Read Key Up"
	set hidden = TRUE

	if (!key)
		return

	SEND_SIGNAL(src, COMSIG_CLIENT_KEY_UP, key)


/**
  * Compiles a full list of verbs to be sent to the browser
  * Sends the 2D verbs vector of (verb category, verb name)
  */
/client/proc/init_statbrowser()
	if(IsAdminAdvancedProcCall())
		return
	var/list/verblist = list()
	var/list/verbstoprocess = verbs.Copy()
	if(mob)
		verbstoprocess += mob.verbs
		for(var/AM in mob.contents)
			var/atom/movable/thing = AM
			verbstoprocess += thing.verbs
	panel_tabs.Cut() // panel_tabs get reset in init_statbrowser on JS side anyway
	for(var/thing in verbstoprocess)
		var/procpath/verb_to_init = thing
		if(!verb_to_init)
			continue
		if(verb_to_init.hidden)
			continue
		if(!istext(verb_to_init.category))
			continue
		panel_tabs |= verb_to_init.category
		verblist[++verblist.len] = list(verb_to_init.category, verb_to_init.name)
	src << output("[url_encode(json_encode(panel_tabs))];[url_encode(json_encode(verblist))]", "statbrowser:init_statbrowser")


/client/verb/fix_stat_panel()
	set name = "Fix Stat Panel"
	set hidden = TRUE

	init_statbrowser()

/client/proc/check_panel_loaded()
	if(statbrowser_ready)
		return
	to_chat(src, "<span class='userdanger'>Statpanel failed to load, click <a href='?src=[REF(src)];reload_statbrowser=1'>here</a> to reload the panel </span>")


/**
 * Updates the keybinds for special keys
 *
 * Handles adding macros for the keys that need it
 * And adding movement keys to the clients movement_keys list
 * At the time of writing this, communication(OOC, Say, IC) require macros
 * Arguments:
 * * direct_prefs - the preference we're going to get keybinds from
 */
/client/proc/update_special_keybinds(datum/preferences/direct_prefs)
	var/datum/preferences/D = prefs || direct_prefs
	if(!D?.key_bindings)
		return
	movement_keys = list()
	for(var/key in D.key_bindings)
		for(var/kb_name in D.key_bindings[key])
			switch(kb_name)
				if("North")
					movement_keys[key] = NORTH
				if("East")
					movement_keys[key] = EAST
				if("West")
					movement_keys[key] = WEST
				if("South")
					movement_keys[key] = SOUTH
				if("Say")
					winset(src, "default-[REF(key)]", "parent=default;name=[key];command=say")
				if("OOC")
					winset(src, "default-[REF(key)]", "parent=default;name=[key];command=ooc")
				if("Me")
					winset(src, "default-[REF(key)]", "parent=default;name=[key];command=me")
