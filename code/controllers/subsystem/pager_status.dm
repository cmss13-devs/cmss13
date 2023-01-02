/// Updates BYOND pager status periodically
SUBSYSTEM_DEF(pager_status)
	name   = "Pager Status"
	wait   = 1 MINUTES
	priority  = SS_PRIORITY_PAGER_STATUS
	flags  = SS_NO_INIT
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY

// Look you can't make /world processable and it'd be a terrible idea anyway
/datum/controller/subsystem/pager_status/fire(resumed = FALSE)
	world.update_status()
