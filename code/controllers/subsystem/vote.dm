SUBSYSTEM_DEF(vote)
	name     = "Vote"
	flags    = SS_NO_INIT
	wait     = 1 SECONDS
	priority = SS_PRIORITY_VOTE
	flags    = SS_KEEP_TIMING | SS_DISABLE_FOR_TESTING
	runlevels = RUNLEVELS_DEFAULT|RUNLEVEL_LOBBY

/datum/controller/subsystem/vote/fire(resumed = FALSE)
	vote.process()
