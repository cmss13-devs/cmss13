#define INACTIVITY_KICK 10 MINUTES

SUBSYSTEM_DEF(inactivity)
	name = "Inactivity"
	wait = 1 MINUTES
	flags = SS_NO_INIT | SS_BACKGROUND
	priority = SS_PRIORITY_INACTIVITY
	runlevels = RUNLEVELS_DEFAULT|RUNLEVEL_LOBBY

/datum/controller/subsystem/inactivity/fire(resumed = FALSE)
	if(list_clear_nulls(GLOB.clients))
		debug_log("Removed nulls from GLOB.clients!")
	if(list_clear_nulls(GLOB.player_list))
		debug_log("Removed nulls from GLOB.player_list!")

	if (!CONFIG_GET(flag/kick_inactive))
		return

	for(var/client/current as anything in GLOB.clients)
		if(current.admin_holder && current.admin_holder.rights & R_MOD) //Skip admins.
			continue
		if(current.is_afk(INACTIVITY_KICK))
			if(!istype(current.mob, /mob/dead))
				log_access("AFK: [key_name(current)]")
				to_chat(current, SPAN_WARNING("You have been inactive for more than [INACTIVITY_KICK / 600] minutes and have been disconnected."))
				qdel(current)
