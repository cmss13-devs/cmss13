var/datum/subsystem/defcon/SSdefcon

/datum/subsystem/defcon
	name		= "DEFCON"
	wait		= 5.5 SECONDS
	init_order = SS_INIT_DEFCON
	priority = SS_PRIORITY_DEFCON
	flags     = SS_NO_TICK_CHECK

/datum/subsystem/defcon/New()
	..()
	NEW_SS_GLOBAL(SSdefcon)
	if(!defcon_controller)
		defcon_controller = new /datum/defcon()

/datum/subsystem/defcon/Initialize()
	if(!defcon_controller)
		defcon_controller = new /datum/defcon()

/datum/subsystem/defcon/fire()

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
