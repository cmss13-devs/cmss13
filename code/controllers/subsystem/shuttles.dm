var/datum/subsystem/shuttles/SSshuttles


/datum/subsystem/shuttles
	name          = "Shuttles"
	init_order    = SS_INIT_SHUTTLES
	display_order = SS_DISPLAY_SHUTTLES
	priority      = SS_PRIORITY_SHUTTLES
	wait          = 5 SECONDS
	flags         = SS_NO_TICK_CHECK


/datum/subsystem/shuttles/New()
	NEW_SS_GLOBAL(SSshuttles)


/datum/subsystem/shuttles/Initialize(timeofday)
	shuttle_controller = new

	..()


/datum/subsystem/shuttles/fire(resumed = FALSE)
	shuttle_controller.process()
