GLOBAL_REFERENCE_LIST_INDEXED(cmtv_commands, /datum/cmtv_command, name)

/datum/cmtv_command
	var/name
	var/description

	var/require_moderator

	var/global_cooldown_time
	COOLDOWN_DECLARE(global_cooldown)

	var/user_cooldown_time
	var/user_cooldown = list()

/datum/cmtv_command/proc/cannot_run(list/arguments)
	if(arguments["is_moderator"])
		return FALSE

	if(require_moderator)
		return "This command requires Moderator."

	if(user_cooldown_time && user_cooldown[arguments["username"]] && !COOLDOWN_FINISHED(src, user_cooldown[arguments["username"]]))
		return "On user cooldown: [COOLDOWN_SECONDSLEFT(src, user_cooldown[arguments["username"]])]s left."

	if(global_cooldown_time && !COOLDOWN_FINISHED(src, global_cooldown))
		return "On global cooldown: [COOLDOWN_SECONDSLEFT(src, global_cooldown)]s left."

	return FALSE

/datum/cmtv_command/proc/execute(list/arguments)

/datum/cmtv_command/proc/post_execute(list/arguments)
	if(arguments["is_moderator"])
		return

	if(global_cooldown_time)
		COOLDOWN_START(src, global_cooldown, global_cooldown_time)

	if(user_cooldown_time)
		COOLDOWN_START(src, user_cooldown[arguments["username"]], user_cooldown_time)

	log_game("CMTV: [name] ([arguments["args"]]) executed by [arguments["username"]].")

/datum/cmtv_command/help
	name = "help"

/datum/cmtv_command/help/execute(list/arguments)
	var/response_text = ""

	for(var/command in GLOB.cmtv_commands)
		var/datum/cmtv_command/command_datum = GLOB.cmtv_commands[command]
		if(!command_datum.description)
			continue

		response_text += "![command]: [command_datum.description]"

	return response_text

/datum/cmtv_command/ping
	name = "ping"
	description = "Pingpong!"

/datum/cmtv_command/ping/execute(list/arguments)
	return "Pong!"

/datum/cmtv_command/fixchat
	name = "fixchat"
	description = "Fixes the chat."

	global_cooldown_time = 3 MINUTES
	user_cooldown_time = 9 MINUTES

/datum/cmtv_command/fixchat/execute(list/arguments)
	SScmtv.restart_chat()

/datum/cmtv_command/newperspective
	name = "changeperspective"
	require_moderator = TRUE

/datum/cmtv_command/newperspective/execute(list/arguments)
	SScmtv.reset_perspective()
