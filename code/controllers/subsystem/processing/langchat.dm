PROCESSING_SUBSYSTEM_DEF(langchat)
	name     = "Langchat"
	wait     = 0.2 SECONDS // Just fast enough to not have much delay when you talk
	priority = SS_PRIORITY_LANGCHAT // Low prio
	runlevels = RUNLEVELS_DEFAULT | RUNLEVEL_LOBBY
