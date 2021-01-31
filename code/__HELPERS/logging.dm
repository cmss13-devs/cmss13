#define DIRECT_OUTPUT(A, B) A << B
#define SEND_TEXT(target, text) DIRECT_OUTPUT(target, text)
#define SEND_SOUND(target, sound) DIRECT_OUTPUT(target, sound)
#define WRITE_FILE(file, text) DIRECT_OUTPUT(file, text)

//print an error message to world.log


// On Linux/Unix systems the line endings are LF, on windows it's CRLF, admins that don't use notepad++
// will get logs that are one big line if the system is Linux and they are using notepad.  This solves it by adding CR to every line ending
// in the logs.  ascii character 13 = CR

/var/global/log_end= world.system_type == UNIX ? ascii2text(13) : ""


/proc/error(msg)
	world.log << "## ERROR: [msg][log_end]"
	GLOB.STUI.debug.Add("\[[time_stamp()]]DEBUG: [msg]<br>")
	GLOB.STUI.processing |= STUI_LOG_DEBUG
#define WARNING(MSG) warning("[MSG] in [__FILE__] at line [__LINE__] src: [src] usr: [usr].")
//print a warning message to world.log
/proc/warning(msg)
	world.log << "## WARNING: [msg][log_end]"
	GLOB.STUI.debug.Add("\[[time_stamp()]]WARNING: [msg]<br>")
	GLOB.STUI.processing |= STUI_LOG_DEBUG
//print a testing-mode debug message to world.log
/proc/testing(msg)
	world.log << "## TESTING: [msg][log_end]"
	GLOB.STUI.debug.Add("\[[time_stamp()]]TESTING: [msg]<br>")
	GLOB.STUI.processing |= STUI_LOG_DEBUG

/proc/log_admin(text)
	admin_log.Add(text)
	if (CONFIG_GET(flag/log_admin))
		diary << "\[[time_stamp()]]ADMIN: [text][log_end]"
	GLOB.STUI.admin.Add("\[[time_stamp()]]ADMIN: [text]<br>")
	GLOB.STUI.processing |= STUI_LOG_ADMIN

/proc/log_asset(text)
	asset_log.Add(text)
	if (CONFIG_GET(flag/log_asset))
		diary << "\[[time_stamp()]]ADMIN: [text][log_end]"

/proc/log_adminpm(text)
	admin_log.Add(text)
	if (CONFIG_GET(flag/log_admin))
		diary << "\[[time_stamp()]]ADMIN: [text][log_end]"
	GLOB.STUI.staff.Add("\[[time_stamp()]]ADMIN: [text]<br>")
	GLOB.STUI.processing |= STUI_LOG_STAFF_CHAT

/proc/log_world(text)
	SEND_TEXT(world.log, text)

/proc/log_debug(text, diary_only=FALSE)
	if (CONFIG_GET(flag/log_debug))
		diary << "\[[time_stamp()]]DEBUG: [text][log_end]"

	if(diary_only)
		return

	GLOB.STUI?.debug.Add("\[[time_stamp()]]DEBUG: [text]<br>")
	GLOB.STUI?.processing |= STUI_LOG_DEBUG
	for(var/client/C in GLOB.admins)
		if(C.prefs.toggles_chat & CHAT_DEBUGLOGS)
			to_chat(C, "DEBUG: [text]")


/proc/log_game(text)
	if (CONFIG_GET(flag/log_game))
		diary << html_decode("\[[time_stamp()]]GAME: [text][log_end]")
	GLOB.STUI.admin.Add("\[[time_stamp()]]GAME: [text]<br>")
	GLOB.STUI.processing |= STUI_LOG_ADMIN

/proc/log_interact(var/mob/living/carbon/origin, var/mob/living/carbon/target, var/msg)
	if (CONFIG_GET(flag/log_interact))
		diary << html_decode("\[[time_stamp()]]INTERACT: [msg][log_end]")
	origin.attack_log += "\[[time_stamp()]\]<font color='green'> [msg] </font>"
	target.attack_log += "\[[time_stamp()]\]<font color='green'> [msg] </font>"

	GLOB.STUI.attack.Add("\[[time_stamp()]]INTERACT: [msg]<br>")
	GLOB.STUI.processing |= STUI_LOG_ATTACK

/proc/log_vote(text)
	if (CONFIG_GET(flag/log_vote))
		diary << html_decode("\[[time_stamp()]]VOTE: [text][log_end]")

/proc/log_access(text)
	if (CONFIG_GET(flag/log_access))
		diary << html_decode("\[[time_stamp()]]ACCESS: [text][log_end]")
	GLOB.STUI.debug.Add("\[[time_stamp()]]ACCESS: [text]<br>")
	GLOB.STUI.processing |= STUI_LOG_DEBUG

/proc/log_say(text)
	if (CONFIG_GET(flag/log_say))
		diary << html_decode("\[[time_stamp()]]SAY: [text][log_end]")
	GLOB.STUI.game.Add("\[[time_stamp()]]SAY: [text]<br>")
	GLOB.STUI.processing |= STUI_LOG_GAME_CHAT

/proc/log_hivemind(text)
	if (CONFIG_GET(flag/log_hivemind))
		diary << html_decode("\[[time_stamp()]]HIVEMIND: [text][log_end]")
	GLOB.STUI.game.Add("\[[time_stamp()]]HIVEMIND: [text]<br>")
	GLOB.STUI.processing |= STUI_LOG_GAME_CHAT

/proc/log_ooc(text)
	if (CONFIG_GET(flag/log_ooc))
		diary << html_decode("\[[time_stamp()]]OOC: [text][log_end]")

/proc/log_whisper(text)
	if (CONFIG_GET(flag/log_whisper))
		diary << html_decode("\[[time_stamp()]]WHISPER: [text][log_end]")
	GLOB.STUI.game.Add("\[[time_stamp()]]WHISPER: [text]<br>")
	GLOB.STUI.processing |= STUI_LOG_GAME_CHAT

/proc/log_emote(text)
	if (CONFIG_GET(flag/log_emote))
		diary << html_decode("\[[time_stamp()]]EMOTE: [text][log_end]")
	GLOB.STUI.game.Add("\[[time_stamp()]]<font color='#999999'>EMOTE: [text]</font><br>")
	GLOB.STUI.processing |= STUI_LOG_GAME_CHAT

/proc/log_attack(text)
	if (CONFIG_GET(flag/log_attack))
		diary << html_decode("\[[time_stamp()]]ATTACK: [text][log_end]")
	GLOB.STUI.attack.Add("\[[time_stamp()]]ATTACK: [text]<br>")
	GLOB.STUI.processing |= STUI_LOG_ATTACK

/proc/log_adminsay(text)
	if (CONFIG_GET(flag/log_adminchat))
		diary << html_decode("\[[time_stamp()]]ADMINSAY: [text][log_end]")

/proc/log_adminwarn(text)
	if (CONFIG_GET(flag/log_adminwarn))
		diary << html_decode("\[[time_stamp()]]ADMINWARN: [text][log_end]")
	GLOB.STUI.admin.Add("\[[time_stamp()]]ADMIN: [text]<br>")
	GLOB.STUI.processing |= STUI_LOG_ADMIN

/proc/log_misc(text)
	diary << html_decode("\[[time_stamp()]]MISC: [text][log_end]")
	GLOB.STUI?.debug.Add("\[[time_stamp()]]MISC: [text]<br>")

/proc/log_mutator(text)
	if(!mutator_logs)
		return
	mutator_logs << text + "[log_end]"

/proc/log_hiveorder(text)
	diary << html_decode("\[[time_stamp()]]HIVE ORDER: [text][log_end]")
	GLOB.STUI.debug.Add("\[[time_stamp()]]HIVE ORDER: [text]<br>")

/proc/log_announcement(text)
	diary << html_decode("\[[time_stamp()]]ANNOUNCEMENT: [text][log_end]")
	GLOB.STUI.admin.Add("\[[time_stamp()]]ANNOUNCEMENT: [text]<br>")

/proc/log_mhelp(text)
	diary << html_decode("\[[time_stamp()]]MENTORHELP: [text][log_end]")
	GLOB.STUI.admin.Add("\[[time_stamp()]]MENTORHELP: [text]<br>")

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
	diary << html_decode("\[[time_stamp()]]TGUI: [entry][log_end]")
	GLOB.STUI.tgui.Add("\[[time_stamp()]]TGUI: [entry]<br>")

//wrapper macros for easier grepping
#define WRITE_LOG(log, text) rustg_log_write(log, text, "true")

GLOBAL_VAR(config_error_log)
GLOBAL_PROTECT(config_error_log)

/* Rarely gets called; just here in case the config breaks. */
/proc/log_config(text)
	WRITE_LOG(GLOB.config_error_log, text)
	SEND_TEXT(world.log, text)

/proc/log_admin_private(text)
	log_admin(text)
