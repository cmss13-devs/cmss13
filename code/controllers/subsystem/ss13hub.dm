SUBSYSTEM_DEF(ss13hub)
	name = "SS13Hub"
	wait = 30 SECONDS

/datum/controller/subsystem/ss13hub/Initialize()
	SS13LIB

	return SS_INIT_SUCCESS

/datum/controller/subsystem/ss13hub/fire(resumed)
	var/datum/ss13lib/lib = SS13LIB
	lib.perform_heartbeat()
