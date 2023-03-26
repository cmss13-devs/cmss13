/// Just messages the unwary coder to tell them there are errors that likely escaped their debugguer.
SUBSYSTEM_DEF(earlyruntimes)
	name       = "Early Runtimes"
	init_order = SS_INIT_EARLYRUNTIMES
	flags      = SS_NO_FIRE

/datum/controller/subsystem/earlyruntimes/stat_entry(msg)
	msg = " Early Runtimes: [init_runtimes_count || 0] | All runtimes: [total_runtimes || 0]"
	return ..()

/datum/controller/subsystem/earlyruntimes/Initialize()
	if(init_runtimes_count)
		return SS_INIT_FAILURE
	return SS_INIT_SUCCESS
