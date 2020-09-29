var/global/datum/controller/shuttle_controller/shuttle_controller

SUBSYSTEM_DEF(shuttle)
	name		= "Shuttle"
	wait		= 5.5 SECONDS
	init_order = SS_INIT_SHUTTLE
	priority = SS_PRIORITY_SHUTTLE
	flags     = SS_NO_TICK_CHECK

/datum/controller/subsystem/shuttle/Initialize()
	if(!shuttle_controller)
		shuttle_controller = new /datum/controller/shuttle_controller()
	return ..()

/datum/controller/subsystem/shuttle/fire()
	shuttle_controller.process()