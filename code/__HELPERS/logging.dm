//print an error message to world.log


// On Linux/Unix systems the line endings are LF, on windows it's CRLF, admins that don't use notepad++
// will get logs that are one big line if the system is Linux and they are using notepad.  This solves it by adding CR to every line ending
// in the logs.  ascii character 13 = CR

// STUI
var/datum/STUI/STUI = new()

/var/global/log_end= world.system_type == UNIX ? ascii2text(13) : ""


/proc/error(msg)
	world.log << "## ERROR: [msg][log_end]"
	STUI.debug.Add("\[[time_stamp()]]DEBUG: [msg]<br>")
	STUI.processing |= STUI_LOG_DEBUG
#define WARNING(MSG) warning("[MSG] in [__FILE__] at line [__LINE__] src: [src] usr: [usr].")
//print a warning message to world.log
/proc/warning(msg)
	world.log << "## WARNING: [msg][log_end]"
	STUI.debug.Add("\[[time_stamp()]]WARNING: [msg]<br>")
	STUI.processing |= STUI_LOG_DEBUG
//print a testing-mode debug message to world.log
/proc/testing(msg)
	world.log << "## TESTING: [msg][log_end]"
	STUI.debug.Add("\[[time_stamp()]]TESTING: [msg]<br>")
	STUI.processing |= STUI_LOG_DEBUG

/proc/log_admin(text)
	admin_log.Add(text)
	if (config.log_admin)
		diary << "\[[time_stamp()]]ADMIN: [text][log_end]"
	STUI.admin.Add("\[[time_stamp()]]ADMIN: [text]<br>")
	STUI.processing |= STUI_LOG_ADMIN

/proc/log_asset(text)
	asset_log.Add(text)
	if (config.log_asset)
		diary << "\[[time_stamp()]]ADMIN: [text][log_end]"

/proc/log_adminpm(text)
	admin_log.Add(text)
	if (config.log_admin)
		diary << "\[[time_stamp()]]ADMIN: [text][log_end]"
	STUI.staff.Add("\[[time_stamp()]]ADMIN: [text]<br>")
	STUI.processing |= STUI_LOG_STAFF_CHAT


/proc/log_debug(text, diary_only=FALSE)
	if (config.log_debug)
		diary << "\[[time_stamp()]]DEBUG: [text][log_end]"

	if(diary_only)
		return

	STUI.debug.Add("\[[time_stamp()]]DEBUG: [text]<br>")
	STUI.processing |= STUI_LOG_DEBUG
	for(var/client/C in GLOB.admins)
		if(C.prefs.toggles_chat & CHAT_DEBUGLOGS)
			to_chat(C, "DEBUG: [text]")


/proc/log_game(text)
	if (config.log_game)
		diary << html_decode("\[[time_stamp()]]GAME: [text][log_end]")
	STUI.admin.Add("\[[time_stamp()]]GAME: [text]<br>")
	STUI.processing |= STUI_LOG_ADMIN
/proc/log_vote(text)
	if (config.log_vote)
		diary << html_decode("\[[time_stamp()]]VOTE: [text][log_end]")

/proc/log_access(text)
	if (config.log_access)
		diary << html_decode("\[[time_stamp()]]ACCESS: [text][log_end]")
	STUI.debug.Add("\[[time_stamp()]]ACCESS: [text]<br>")
	STUI.processing |= STUI_LOG_DEBUG
/proc/log_say(text)
	if (config.log_say)
		diary << html_decode("\[[time_stamp()]]SAY: [text][log_end]")
	STUI.game.Add("\[[time_stamp()]]SAY: [text]<br>")
	STUI.processing |= STUI_LOG_GAME_CHAT
/proc/log_hivemind(text)
	if (config.log_hivemind)
		diary << html_decode("\[[time_stamp()]]HIVEMIND: [text][log_end]")
	STUI.game.Add("\[[time_stamp()]]HIVEMIND: [text]<br>")
	STUI.processing |= STUI_LOG_GAME_CHAT
/proc/log_ooc(text)
	if (config.log_ooc)
		diary << html_decode("\[[time_stamp()]]OOC: [text][log_end]")

/proc/log_whisper(text)
	if (config.log_whisper)
		diary << html_decode("\[[time_stamp()]]WHISPER: [text][log_end]")
	STUI.game.Add("\[[time_stamp()]]WHISPER: [text]<br>")
	STUI.processing |= STUI_LOG_GAME_CHAT
/proc/log_emote(text)
	if (config.log_emote)
		diary << html_decode("\[[time_stamp()]]EMOTE: [text][log_end]")
	STUI.game.Add("\[[time_stamp()]]<font color='#999999'>EMOTE: [text]</font><br>")
	STUI.processing |= STUI_LOG_GAME_CHAT
/proc/log_attack(text)
	if (config.log_attack)
		diary << html_decode("\[[time_stamp()]]ATTACK: [text][log_end]")
	STUI.attack.Add("\[[time_stamp()]]ATTACK: [text]<br>")
	STUI.processing |= STUI_LOG_ATTACK
/proc/log_adminsay(text)
	if (config.log_adminchat)
		diary << html_decode("\[[time_stamp()]]ADMINSAY: [text][log_end]")

/proc/log_adminwarn(text)
	if (config.log_adminwarn)
		diary << html_decode("\[[time_stamp()]]ADMINWARN: [text][log_end]")
	STUI.admin.Add("\[[time_stamp()]]ADMIN: [text]<br>")
	STUI.processing |= STUI_LOG_ADMIN
/proc/log_pda(text)
	if (config.log_pda)
		diary << html_decode("\[[time_stamp()]]PDA: [text][log_end]")
	STUI.game.Add("\[[time_stamp()]]<font color='#cd6500'>PDA: [text]</font><br>")
	STUI.processing |= STUI_LOG_GAME_CHAT
/proc/log_misc(text)
	diary << html_decode("\[[time_stamp()]]MISC: [text][log_end]")
	STUI.debug.Add("\[[time_stamp()]]MISC: [text]<br>")

/proc/log_mutator(text)
	if(!mutator_logs)
		return
	mutator_logs << text + "[log_end]"

/proc/log_hiveorder(text)
	diary << html_decode("\[[time_stamp()]]HIVE ORDER: [text][log_end]")
	STUI.debug.Add("\[[time_stamp()]]HIVE ORDER: [text]<br>")

/proc/log_announcement(text)
	diary << html_decode("\[[time_stamp()]]ANNOUNCEMENT: [text][log_end]")
	STUI.debug.Add("\[[time_stamp()]]ANNOUNCEMENT: [text]<br>")

/proc/log_mhelp(text)
	diary << html_decode("\[[time_stamp()]]MENTORHELP: [text][log_end]")
	STUI.admin.Add("\[[time_stamp()]]MENTORHELP: [text]<br>")