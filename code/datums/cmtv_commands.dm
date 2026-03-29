GLOBAL_REFERENCE_LIST_INDEXED(cmtv_commands, /datum/cmtv_command, name)

/datum/cmtv_command
	/// What must be invoked in chat to trigger this
	var/name

	/// Helptext of the command. Keep it short, we've only got 500 characters to play with.
	var/description

	/// If this command requires being a moderator to invoke
	var/require_moderator

	/// How long the cooldown must be which applies to everyone, other than moderators
	var/global_cooldown_time
	COOLDOWN_DECLARE(_global_cooldown)

	/// How long the personal cooldown is which applies to individuals, other than moderators
	var/user_cooldown_time
	var/_user_cooldown = list()

	/// If the [/datum/cmtv_command/proc/execute] function determines no cooldown should be applied,
	/// this should be toggled to false. For instance, when a command fails.
	var/successful = TRUE

/datum/cmtv_command/proc/cannot_run(list/arguments)
	if(!SScmtv.online())
		return "CMTV is not currently running."

	if(arguments["is_moderator"])
		return FALSE

	if(require_moderator)
		return "This command requires Moderator."

	if(user_cooldown_time && _user_cooldown[arguments["user_id"]] && !COOLDOWN_FINISHED(src, _user_cooldown[arguments["user_id"]]))
		return "On user cooldown: [COOLDOWN_SECONDSLEFT(src, _user_cooldown[arguments["user_id"]])]s left."

	if(global_cooldown_time && !COOLDOWN_FINISHED(src, _global_cooldown))
		return "On global cooldown: [COOLDOWN_SECONDSLEFT(src, _global_cooldown)]s left."

	return FALSE

/datum/cmtv_command/proc/pre_execute(list/arguments)
	successful = TRUE

/// The actual execution of the command. The returned text is what will be displayed in chat.
/datum/cmtv_command/proc/execute(list/arguments)

/datum/cmtv_command/proc/post_execute(list/arguments)
	log_game("CMTV: [name] ([arguments["args"]]) executed by [arguments["username"] || arguments["user_id"]].")

	if(arguments["is_moderator"])
		return

	if(!successful)
		return

	if(global_cooldown_time)
		COOLDOWN_START(src, _global_cooldown, global_cooldown_time)

	if(user_cooldown_time)
		COOLDOWN_START(src, _user_cooldown[arguments["user_id"]], user_cooldown_time)


/datum/cmtv_command/help
	name = "help"

/datum/cmtv_command/help/execute(list/arguments)
	var/response_text = ""

	for(var/command in GLOB.cmtv_commands)
		var/datum/cmtv_command/command_datum = GLOB.cmtv_commands[command]
		if(!command_datum.description)
			continue

		if(command_datum.require_moderator && !arguments["is_moderator"])
			continue

		response_text += "![command]: [command_datum.description]\n"

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
	return "Fix chat executed."

/datum/cmtv_command/newperspective
	name = "changeperspective"
	description = "Changes perspective to anyone."
	require_moderator = TRUE

/datum/cmtv_command/newperspective/execute(list/arguments)
	SScmtv.reset_perspective("Chat command requested reset by [arguments["username"]]")
	return "Switching to new perspective after delay..."

/datum/cmtv_command/follow
	name = "follow"
	description = "Follow new mob for 60s (requires name)."

	global_cooldown_time = 2 MINUTES
	user_cooldown_time = 3 MINUTES

/datum/cmtv_command/follow/execute(list/arguments)
	var/looking_for = arguments["args"]

	for(var/priority, mob_list in SScmtv.priority_list)
		for(var/datum/weakref/mob_ref in mob_list)
			var/mob/living/active_mob = mob_ref.resolve()
			if(!active_mob)
				continue

			if(active_mob.real_name == looking_for)
				SScmtv.change_observed_mob(active_mob, set_showtime = 60 SECONDS, change_reason = "Switching to [looking_for]...")
				return "Player is still active, switching after delay..."

	successful = FALSE
	return "Given name is not in active player list. Name must be retrieved from !getmobs"

/datum/cmtv_command/getmobs
	name = "getmobs"
	description = "Gets active mobs."

	global_cooldown_time = 30 SECONDS

/datum/cmtv_command/getmobs/execute(list/arguments)
	var/to_follow = SScmtv.get_most_active_list()
	if(!length(to_follow))
		return "No players to follow at this time."

	var/return_text = "Available to follow: "

	var/budget = length(return_text)
	for(var/datum/weakref/mob_ref in to_follow)
		var/mob/living/active_mob = mob_ref.resolve()
		if(!active_mob)
			continue

		var/text_to_add = "'[active_mob.real_name]' "
		if(length(text_to_add) + budget > 500)
			break

		return_text += text_to_add
		budget += length(text_to_add)

	return return_text
