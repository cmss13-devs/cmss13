#define INACTIVITY_KICK 10 MINUTES

SUBSYSTEM_DEF(inactivity)
	name = "Inactivity"
	wait = 1 MINUTES
	flags = SS_NO_INIT | SS_BACKGROUND
	priority = SS_PRIORITY_INACTIVITY
	runlevels = RUNLEVELS_DEFAULT|RUNLEVEL_LOBBY

	var/list/client/current_run = list()

/datum/controller/subsystem/inactivity/fire(resumed = FALSE)
	if(list_clear_nulls(GLOB.clients))
		debug_log("Removed nulls from GLOB.clients!")
	if(list_clear_nulls(GLOB.player_list))
		debug_log("Removed nulls from GLOB.player_list!")
	if(list_clear_nulls(GLOB.new_player_list))
		debug_log("Removed nulls from GLOB.new_player_list!")

	if(!CONFIG_GET(flag/kick_inactive))
		return

	if(!resumed)
		current_run = GLOB.clients.Copy()

	while(length(current_run))
		var/client/current = current_run[length(current_run)]
		current_run.len--

		if(CLIENT_IS_AFK_SAFE(current)) //Skip admins.
			continue

		if(current.is_afk(INACTIVITY_KICK))
			if(!istype(current.mob, /mob/dead))
				log_access("AFK: [key_name(current)]")
				to_chat(current, SPAN_WARNING("You have been inactive for more than [INACTIVITY_KICK / 600] minutes and have been disconnected."))
				qdel(current)

		if(MC_TICK_CHECK)
			return
