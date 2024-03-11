/datum/battlepass_challenge
	/// What this challenge is called
	var/name = "" as text
	/// The description that is given to the user on what the challenge is and how to complete it
	var/desc = "" as text
	/// If this challenge has been completed
	var/completed = FALSE as num
	/// How much XP this challenge gives on completion
	var/completion_xp = 0 as num
	/// If this is a xeno or marine-focused challenge
	var/challenge_category = CHALLENGE_NONE as text
	/// How much weight this challenge has in its category
	var/pick_weight = 1 as num

/datum/battlepass_challenge/New(client/owning_client)
	. = ..()
	if(!owning_client)
		return FALSE

	RegisterSignal(owning_client, COMSIG_CLIENT_MOB_LOGGED_IN, PROC_REF(on_client_login_mob))
	return TRUE

/// Override to change the desc of the challenge post-init
/datum/battlepass_challenge/proc/regenerate_desc()
	return

/// Override this to add behavior to any mob connected to the owning client
/datum/battlepass_challenge/proc/on_client_login_mob(datum/source, mob/logged_in_mob)
	SIGNAL_HANDLER
	SHOULD_CALL_PARENT(TRUE)

	UnregisterSignal(logged_in_mob.client, COMSIG_CLIENT_MOB_LOGGED_IN)
	RegisterSignal(logged_in_mob, COMSIG_MOB_LOGOUT, PROC_REF(on_client_logout_mob))

/// Cleanup code from on_client_login_mob
/datum/battlepass_challenge/proc/on_client_logout_mob(mob/source)
	SIGNAL_HANDLER
	SHOULD_CALL_PARENT(TRUE)

	unhook_signals(source)
	UnregisterSignal(source, COMSIG_MOB_LOGOUT)
	if(source.logging_ckey in GLOB.directory)
		RegisterSignal(GLOB.directory[source.logging_ckey], COMSIG_CLIENT_MOB_LOGGED_IN, PROC_REF(on_client_login_mob))

/datum/battlepass_challenge/proc/unhook_signals(mob/source)
	return

/// Override to return true/false depending on the challenge's completion
/datum/battlepass_challenge/proc/check_challenge_completed()
	return TRUE

/// Do things if the challenge is completed, will do nothing if it is not
/datum/battlepass_challenge/proc/on_possible_challenge_completed()
	if(!check_challenge_completed())
		return FALSE
	SEND_SIGNAL(src, COMSIG_BATTLEPASS_CHALLENGE_COMPLETED)
	return TRUE

/// Convert data about this challenge into a list to be inserted in a savefile
/datum/battlepass_challenge/proc/serialize()
	SHOULD_CALL_PARENT(TRUE)
	return list(
		"type" = type,
		"name" = name,
		"desc" = desc,
		"completion_xp" = completion_xp,
		"completed" = completed
	)

/// Given a list, update the challenge data accordingly
/datum/battlepass_challenge/proc/deserialize(list/save_list)
	SHOULD_CALL_PARENT(TRUE)
	name = save_list["name"]
	desc = save_list["desc"]
	completion_xp = save_list["completion_xp"]
	completed = save_list["completed"]

