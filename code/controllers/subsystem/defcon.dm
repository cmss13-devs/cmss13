SUBSYSTEM_DEF(defcon)
	name		= "DEFCON"
	wait		= 5.5 SECONDS
	init_order = SS_INIT_DEFCON
	priority = SS_PRIORITY_DEFCON
	flags     = SS_DISABLE_FOR_TESTING
	var/list/current_inactive_run = list()
	var/list/current_active_run = list()

/datum/controller/subsystem/defcon/Initialize(start_timeofday)
	//text2file("DEFCON initialization started","data/defcon_log.txt")
	if(!defcon_controller)
		defcon_controller = new /datum/controller/defcon()
	defcon_controller.initialize_level_triggers_by_map()
	return ..()

/datum/controller/subsystem/defcon/fire(resumed = FALSE)
	if(!resumed)
		defcon_controller.check_defcon_level()
		current_inactive_run = objectives_controller.inactive_objectives.Copy()
		current_active_run = objectives_controller.active_objectives.Copy()

	while(length(current_inactive_run))
		var/datum/cm_objective/O = current_inactive_run[length(current_inactive_run)]
		current_inactive_run.len--
		if(O.can_be_activated())
			O.activate()
		if(MC_TICK_CHECK)
			return

	while(length(current_inactive_run))
		var/datum/cm_objective/O = current_active_run[length(current_active_run)]
		current_active_run.len--
		O.process()
		O.check_completion()
		if(O.is_complete())
			O.deactivate()
		if(MC_TICK_CHECK)
			return
