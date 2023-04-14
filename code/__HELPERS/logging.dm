#define DIRECT_OUTPUT(A, B) A << B
#define SEND_TEXT(target, text) DIRECT_OUTPUT(target, text)
#define SEND_SOUND(target, sound) DIRECT_OUTPUT(target, sound)
#define WRITE_FILE(file, text) DIRECT_OUTPUT(file, text)

//This is an external call, "true" and "false" are how rust parses out booleans
#define WRITE_LOG(log, text) rustg_log_write(log, text, "true")
#define WRITE_LOG_NO_FORMAT(log, text) rustg_log_write(log, text, "false")

//print an error message to world.log


// On Linux/Unix systems the line endings are LF, on windows it's CRLF, admins that don't use notepad++
// will get logs that are one big line if the system is Linux and they are using notepad.  This solves it by adding CR to every line ending
// in the logs.  ascii character 13 = CR

/var/global/log_end= world.system_type == UNIX ? ascii2text(13) : ""

/proc/error(msg)
	world.log << "## ERROR: [msg][log_end]"
	GLOB.STUI.debug.Add("\[[time_stamp()]]DEBUG: [msg]")
	GLOB.STUI.processing |= STUI_LOG_DEBUG
#define WARNING(MSG) warning("[MSG] in [__FILE__] at line [__LINE__] src: [src] usr: [usr].")
//print a warning message to world.log
/proc/warning(msg)
	world.log << "## WARNING: [msg][log_end]"
	GLOB.STUI.debug.Add("\[[time_stamp()]]WARNING: [msg]")
	GLOB.STUI.processing |= STUI_LOG_DEBUG
//print a testing-mode debug message to world.log
/proc/testing(msg)
	world.log << "## TESTING: [msg][log_end]"
	GLOB.STUI.debug.Add("\[[time_stamp()]]TESTING: [msg]")
	GLOB.STUI.processing |= STUI_LOG_DEBUG

/proc/log_admin(text)
	var/time = time_stamp()
	admin_log.Add(text)
	if (CONFIG_GET(flag/log_admin))
		diary << "\[[time]]ADMIN: [text][log_end]"
		LOG_REDIS("admin", "\[[time]\] [text]")
	GLOB.STUI.admin.Add("\[[time]]ADMIN: [text]")
	GLOB.STUI.processing |= STUI_LOG_ADMIN

/proc/log_asset(text)
	asset_log.Add(text)
	if (CONFIG_GET(flag/log_asset))
		var/time = time_stamp()
		diary << "\[[time]]ADMIN: [text][log_end]"
		LOG_REDIS("asset", "\[[time]\] [text]")

/proc/log_adminpm(text)
	admin_log.Add(text)
	if (CONFIG_GET(flag/log_admin))
		diary << "\[[time_stamp()]]ADMIN: [text][log_end]"
	GLOB.STUI.staff.Add("\[[time_stamp()]]ADMIN: [text]")
	GLOB.STUI.processing |= STUI_LOG_STAFF_CHAT

/proc/log_world(text)
	SEND_TEXT(world.log, text)

/proc/log_debug(text, diary_only=FALSE)
	var/time = time_stamp()
	if (CONFIG_GET(flag/log_debug))
		diary << "\[[time]]DEBUG: [text][log_end]"
		LOG_REDIS("debug", "\[[time]\] [text]")

	if(diary_only)
		return

	GLOB.STUI?.debug.Add("\[[time]]DEBUG: [text]")
	GLOB.STUI?.processing |= STUI_LOG_DEBUG
	for(var/client/C in GLOB.admins)
		if(C.prefs.toggles_chat & CHAT_DEBUGLOGS)
			to_chat(C, "DEBUG: [text]", type = MESSAGE_TYPE_DEBUG)


/proc/log_game(text)
	var/time = time_stamp()
	if (CONFIG_GET(flag/log_game))
		diary << html_decode("\[[time]]GAME: [text][log_end]")
		LOG_REDIS("game", "\[[time]\] [text]")
	GLOB.STUI.admin.Add("\[[time]]GAME: [text]")
	GLOB.STUI.processing |= STUI_LOG_ADMIN

/proc/log_interact(mob/living/carbon/origin, mob/living/carbon/target, msg)
	var/time = time_stamp()
	if (CONFIG_GET(flag/log_interact))
		diary << html_decode("\[[time]]INTERACT: [msg][log_end]")
		LOG_REDIS("interact", "\[[time]\] [msg]")
	origin.attack_log += "\[[time]\]<font color='green'> [msg] </font>"
	target.attack_log += "\[[time]\]<font color='green'> [msg] </font>"

	GLOB.STUI.attack.Add("\[[time]]INTERACT: [msg]")
	GLOB.STUI.processing |= STUI_LOG_ATTACK


/proc/log_overwatch(text)
	var/time = time_stamp()
	if (CONFIG_GET(flag/log_overwatch))
		diary << html_decode("\[[time]]OVERWATCH: [text][log_end]")
		LOG_REDIS("overwatch", "\[[time]\] [text]")
	GLOB.STUI.admin.Add("\[[time]]OVERWATCH: [text]")
	GLOB.STUI.processing |= STUI_LOG_ADMIN

/proc/log_idmod(obj/item/card/id/target_id, msg)
	var/time = time_stamp()
	if (CONFIG_GET(flag/log_idmod))
		diary << html_decode("\[[time]]ID MOD: [msg][log_end]")
		LOG_REDIS("idmod", "\[[time]\] [msg]")
	target_id.modification_log += "\[[time]]: [msg]"

/proc/log_vote(text)
	var/time = time_stamp()
	if (CONFIG_GET(flag/log_vote))
		diary << html_decode("\[[time]]VOTE: [text][log_end]")
		LOG_REDIS("vote", "\[[time]\] [text]")


/proc/log_access(text)
	var/time = time_stamp()
	if (CONFIG_GET(flag/log_access))
		diary << html_decode("\[[time]]ACCESS: [text][log_end]")
		LOG_REDIS("access", "\[[time]\] [text]")
	GLOB.STUI.debug.Add("\[[time]]ACCESS: [text]")
	GLOB.STUI.processing |= STUI_LOG_DEBUG

/proc/log_say(text)
	var/time = time_stamp()
	if (CONFIG_GET(flag/log_say))
		diary << html_decode("\[[time]]SAY: [text][log_end]")
		LOG_REDIS("say", "\[[time]\] [text]")
	GLOB.STUI.game.Add("\[[time]]SAY: [text]")
	GLOB.STUI.processing |= STUI_LOG_GAME_CHAT

/proc/log_hivemind(text)
	var/time = time_stamp()
	if (CONFIG_GET(flag/log_hivemind))
		diary << html_decode("\[[time]]HIVEMIND: [text][log_end]")
		LOG_REDIS("hivemind", "\[[time]\] [text]")
	GLOB.STUI.game.Add("\[[time]]HIVEMIND: [text]")
	GLOB.STUI.processing |= STUI_LOG_GAME_CHAT

/proc/log_ooc(text)
	var/time = time_stamp()
	if (CONFIG_GET(flag/log_ooc))
		LOG_REDIS("ooc", "\[[time]\] [text]")
		diary << html_decode("\[[time]]OOC: [text][log_end]")

/proc/log_whisper(text)
	var/time = time_stamp()
	if (CONFIG_GET(flag/log_whisper))
		LOG_REDIS("whisper", "\[[time]\] [text]")
		diary << html_decode("\[[time]]WHISPER: [text][log_end]")
	GLOB.STUI.game.Add("\[[time]]WHISPER: [text]")
	GLOB.STUI.processing |= STUI_LOG_GAME_CHAT

/proc/log_emote(text)
	var/time = time_stamp()
	if (CONFIG_GET(flag/log_emote))
		LOG_REDIS("emote", "\[[time]\] [text]")
		diary << html_decode("\[[time]]EMOTE: [text][log_end]")
	GLOB.STUI.game.Add("\[[time]]<font color='#999999'>EMOTE: [text]</font>")
	GLOB.STUI.processing |= STUI_LOG_GAME_CHAT

/proc/log_attack(text)
	var/time = time_stamp()
	if (CONFIG_GET(flag/log_attack))
		LOG_REDIS("attack", "\[[time]\] [text]")
		diary << html_decode("\[[time]]ATTACK: [text][log_end]")
	GLOB.STUI.attack.Add("\[[time]]ATTACK: [text]")
	GLOB.STUI.processing |= STUI_LOG_ATTACK

/proc/log_adminsay(text)
	if (CONFIG_GET(flag/log_adminchat))
		diary << html_decode("\[[time_stamp()]]ADMINSAY: [text][log_end]")

/proc/log_adminwarn(text)
	if (CONFIG_GET(flag/log_adminwarn))
		diary << html_decode("\[[time_stamp()]]ADMINWARN: [text][log_end]")
	GLOB.STUI.admin.Add("\[[time_stamp()]]ADMIN: [text]")
	GLOB.STUI.processing |= STUI_LOG_ADMIN

/proc/log_misc(text)
	var/time = time_stamp()
	LOG_REDIS("misc", "\[[time]\] [text]")
	diary << html_decode("\[[time]]MISC: [text][log_end]")
	GLOB.STUI?.debug.Add("\[[time]]MISC: [text]")

/proc/log_mutator(text)
	if(!mutator_logs)
		return
	mutator_logs << text + "[log_end]"

/proc/log_hiveorder(text)
	var/time = time_stamp()
	LOG_REDIS("hiveorder", "\[[time]\] [text]")
	diary << html_decode("\[[time]]HIVE ORDER: [text][log_end]")
	GLOB.STUI.debug.Add("\[[time]]HIVE ORDER: [text]")

/proc/log_announcement(text)
	var/time = time_stamp()
	LOG_REDIS("announcement", "\[[time]\] [text]")
	diary << html_decode("\[[time]]ANNOUNCEMENT: [text][log_end]")
	GLOB.STUI.admin.Add("\[[time]]ANNOUNCEMENT: [text]")

/proc/log_mhelp(text)
	var/time = time_stamp()
	LOG_REDIS("mhelp", "\[[time]\] [text]")
	diary << html_decode("\[[time]]MENTORHELP: [text][log_end]")
	GLOB.STUI.admin.Add("\[[time]]MENTORHELP: [text]")

/**
 * Appends a tgui-related log entry. All arguments are optional.
 */
/proc/log_tgui(user, message, context,
		datum/tgui_window/window,
		datum/src_object)
	var/entry = ""
	// Insert user info
	if(!user)
		entry += "<nobody>"
	else if(istype(user, /mob))
		var/mob/mob = user
		entry += "[mob.ckey] (as [mob] at [mob.x],[mob.y],[mob.z])"
	else if(istype(user, /client))
		var/client/client = user
		entry += "[client.ckey]"
	// Insert context
	if(context)
		entry += " in [context]"
	else if(window)
		entry += " in [window.id]"
	// Resolve src_object
	if(!src_object && window?.locked_by)
		src_object = window.locked_by.src_object
	// Insert src_object info
	if(src_object)
		entry += "\nUsing: [src_object.type] [REF(src_object)]"
	// Insert message
	if(message)
		entry += "\n[message]"
	tgui_diary << html_decode("\[[time_stamp()]]TGUI: [entry][log_end]")
	GLOB.STUI.tgui.Add("\[[time_stamp()]]TGUI: [entry]")
	GLOB.STUI.processing |= STUI_LOG_TGUI

GLOBAL_VAR(config_error_log)
GLOBAL_PROTECT(config_error_log)

/* Rarely gets called; just here in case the config breaks. */
/proc/log_config(text)
	WRITE_LOG(GLOB.config_error_log, text)
	SEND_TEXT(world.log, text)

/proc/log_admin_private(text)
	log_admin(text)

#if defined(UNIT_TESTS) || defined(SPACEMAN_DMM)
/proc/log_test(text)
	WRITE_LOG(GLOB.test_log, text)
	SEND_TEXT(world.log, text)
#endif

#if defined(REFERENCE_DOING_IT_LIVE)
#define log_reftracker(msg) log_harddel("## REF SEARCH [msg]")

/proc/log_harddel(text)
	WRITE_LOG(GLOB.harddel_log, text)

#elif defined(REFERENCE_TRACKING) // Doing it locally
#define log_reftracker(msg) log_world("## REF SEARCH [msg]")

#else //Not tracking at all
#define log_reftracker(msg)
#endif
