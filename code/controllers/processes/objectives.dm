/datum/controller/process/objectives

/datum/controller/process/objectives/setup()
	name = "Objectives"
	schedule_interval = 20 //2 seconds

/datum/controller/process/objectives/doWork()

    for(var/datum/cm_objective/A in objectives_controller.inactive_objectives)
        if(A.can_be_activated())
            A.activate()

    for(var/datum/cm_objective/O in objectives_controller.active_objectives)
        O.process()
        O.check_completion()
        if(O.is_complete())
            O.deactivate()
