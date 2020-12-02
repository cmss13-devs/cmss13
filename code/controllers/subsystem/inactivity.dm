#define INACTIVITY_KICK	6000	//10 minutes in ticks (approx.)

SUBSYSTEM_DEF(inactivity)
	name = "Inactivity"
	wait = INACTIVITY_KICK
	flags = SS_NO_INIT | SS_BACKGROUND | SS_DISABLE_FOR_TESTING
	priority = SS_PRIORITY_INACTIVITY
	runlevels = RUNLEVELS_DEFAULT|RUNLEVEL_LOBBY

/datum/controller/subsystem/inactivity/fire(resumed = FALSE)
	if (CONFIG_GET(flag/kick_inactive))
		for(var/i in GLOB.clients)
			var/client/C = i
			if(C.admin_holder && C.admin_holder.rights & R_ADMIN) //Skip admins.
				continue
			if (C.is_afk(INACTIVITY_KICK))
				if (!istype(C.mob, /mob/dead))
					log_access("AFK: [key_name(C)]")
					to_chat(C, SPAN_WARNING("You have been inactive for more than 10 minutes and have been disconnected."))
					qdel(C)
