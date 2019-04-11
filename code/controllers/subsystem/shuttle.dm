var/datum/subsystem/shuttle/SSshuttle

var/global/datum/controller/shuttle_controller/shuttle_controller

/datum/subsystem/shuttle
	name		= "Shuttle"
	wait		= 5.5 SECONDS
	init_order = SS_INIT_SHUTTLE
	priority = SS_PRIORITY_SHUTTLE
	flags     = SS_NO_TICK_CHECK

/datum/subsystem/shuttle/New()
	NEW_SS_GLOBAL(SSshuttle)

/datum/subsystem/shuttle/Initialize()
	if(!shuttle_controller)
		shuttle_controller = new /datum/controller/shuttle_controller()

/datum/subsystem/shuttle/fire()
	shuttle_controller.process()