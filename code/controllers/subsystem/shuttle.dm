SUBSYSTEM_DEF(oldshuttle)
	name = "Old Shuttle"
	wait = 5.5 SECONDS
	init_order = SS_INIT_SHUTTLE
	priority = SS_PRIORITY_SHUTTLE

	var/datum/controller/shuttle_controller/shuttle_controller

/datum/controller/subsystem/oldshuttle/Initialize()
	if(GLOB.perf_flags & PERF_TOGGLE_SHUTTLES)
		can_fire = FALSE
		return
	if(!shuttle_controller)
		shuttle_controller = new /datum/controller/shuttle_controller()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/oldshuttle/fire()
	if(GLOB.perf_flags & PERF_TOGGLE_SHUTTLES)
		return
	shuttle_controller.process()
