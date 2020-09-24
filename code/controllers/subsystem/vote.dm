SUBSYSTEM_DEF(vote)
	name     = "Vote"
	flags    = SS_NO_INIT
	wait     = 1 SECONDS
	priority = SS_PRIORITY_VOTE
	flags    = SS_FIRE_IN_LOBBY | SS_KEEP_TIMING | SS_DISABLE_FOR_TESTING

/datum/subsystem/vote/fire(resumed = FALSE)
	vote.process()
