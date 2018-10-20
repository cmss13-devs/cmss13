var/global/datum/objectives_controller/objectives_controller

var/datum/subsystem/objectives/SSobjectives

/datum/subsystem/objectives
	name          = "Objectives"
	init_order    = SS_INIT_OBJECTIVES
	display_order = SS_DISPLAY_OBJECTIVES
	priority      = SS_PRIORITY_OBJECTIVES
	wait          = 2 SECONDS
	flags         = SS_NO_TICK_CHECK | SS_KEEP_TIMING


/datum/subsystem/objectives/New()
	NEW_SS_GLOBAL(SSobjectives)


/datum/subsystem/objectives/Initialize(timeofday)
	objectives_controller = new /datum/objectives_controller
	// Setup some global objectives
	objectives_controller.power = new /datum/cm_objective/establish_power
	objectives_controller.comms = new /datum/cm_objective/communications
	objectives_controller.marines = new /datum/cm_objective/recover_corpses/marines
	objectives_controller.add_objective(new /datum/cm_objective/minimise_losses/squad_marines)
	objectives_controller.add_objective(new /datum/cm_objective/recover_corpses/colonists)
	objectives_controller.active_objectives += objectives_controller.power
	objectives_controller.active_objectives += objectives_controller.comms
	..()


/datum/subsystem/objectives/fire(resumed = FALSE)
	for(var/datum/cm_objective/A in objectives_controller.inactive_objectives)
		if(A.can_be_activated())
			A.activate()

	for(var/datum/cm_objective/O in objectives_controller.active_objectives)
		O.process()
		O.check_completion()
		if(O.is_complete())
			O.deactivate()
