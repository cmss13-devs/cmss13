GLOBAL_REFERENCE_LIST_INDEXED(cmtv_commands, /datum/cmtv_command, name)

/datum/cmtv_command
	var/name

/datum/cmtv_command/proc/execute(list/arguments)

/datum/cmtv_command/ping
	name = "ping"

/datum/cmtv_command/ping/execute(list/arguments)
	return "Pong!"
