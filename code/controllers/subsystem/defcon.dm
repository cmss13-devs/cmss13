SUBSYSTEM_DEF(defcon)
	name		= "DEFCON"
	wait		= 5.5 SECONDS
	init_order = SS_INIT_DEFCON
	priority = SS_PRIORITY_DEFCON
	flags     = SS_NO_TICK_CHECK | SS_DISABLE_FOR_TESTING

/datum/controller/subsystem/defcon/Initialize(start_timeofday)
	//text2file("DEFCON initialization started","data/defcon_log.txt")
	if(!defcon_controller)
		defcon_controller = new /datum/controller/defcon()
	return ..()

/datum/controller/subsystem/defcon/fire()

	// If our lists aren't initialized AND we can't initialize them, return
	if (!defcon_controller.lists_initialized && !defcon_controller.initialize_level_triggers_by_map())
		return

	defcon_controller.check_defcon_level()

	for(var/datum/cm_objective/A in objectives_controller.inactive_objectives)
		if(A)
			if(A.can_be_activated())
				A.activate()

	for(var/datum/cm_objective/O in objectives_controller.active_objectives)
		if(O)
			O.process()
			O.check_completion()
			if(O.is_complete())
				O.deactivate()
