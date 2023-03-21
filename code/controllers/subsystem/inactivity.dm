#define INACTIVITY_KICK 6000 //10 minutes in ticks (approx.)

SUBSYSTEM_DEF(inactivity)
	name = "Inactivity"
	wait = INACTIVITY_KICK
	flags = SS_NO_INIT | SS_BACKGROUND
	priority = SS_PRIORITY_INACTIVITY
	runlevels = RUNLEVELS_DEFAULT|RUNLEVEL_LOBBY

/datum/controller/subsystem/inactivity/fire(resumed = FALSE)
	if (CONFIG_GET(flag/kick_inactive))
		for(var/i in GLOB.clients)
			var/client/current_client = i
			if(current_client.admin_holder && current_client.admin_holder.rights & R_ADMIN) //Skip admins.
				continue
			if (current_client.is_afk(INACTIVITY_KICK))
				if (!istype(current_client.mob, /mob/dead))
					log_access("AFK: [key_name(current_client)]")
					to_chat(current_client, SPAN_WARNING("You have been inactive for more than 10 minutes and have been disconnected."))
					qdel(current_client)
