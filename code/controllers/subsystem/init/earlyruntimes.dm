// Reports early runtime errors (occuring during static init) to STUI and messages about them
SUBSYSTEM_DEF(earlyruntimes)
	name    = "Early Runtimes"
	init_order = SS_INIT_EARLYRUNTIMES
	init_stage = INITSTAGE_EARLY
	flags   = SS_NO_FIRE

/datum/controller/subsystem/earlyruntimes/stat_entry(msg)
	msg = " | Init Runtimes: [early_init_runtimes_count]"
	return ..()

/datum/controller/subsystem/earlyruntimes/Initialize()
	if(early_init_runtimes_count)
		. = SS_INIT_FAILURE
		to_chat(world, SPAN_BOLDANNOUNCE("[early_init_runtimes_count] errors occured during early init. Reporting them to STUI."))
	else
		return SS_INIT_SUCCESS
	GLOB.STUI.runtime = early_init_runtimes | GLOB.STUI.runtime
	GLOB.STUI.processing |= STUI_LOG_RUNTIME
