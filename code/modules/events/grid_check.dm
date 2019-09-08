/datum/event/grid_check	//NOTE: Times are measured in master controller ticks!
	announceWhen		= 5

/datum/event/grid_check/setup()
	endWhen = rand(30,120)

/datum/event/grid_check/start()
	power_failure(0)

/datum/event/grid_check/announce()
	marine_announcement("Abnormal activity detected in the ship power system. As a precaution, power must be shut down for an indefinite duration.", "Automated Grid Check", 'sound/AI/poweroff.ogg')

/datum/event/grid_check/end()
	power_restore()
