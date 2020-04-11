var/datum/subsystem/machinery/fast/SSfast_machinery

var/list/fast_machines = list()


/datum/subsystem/machinery/fast
	name          = "Fast Machinery"
	wait          = SS_WAIT_FAST_MACHINERY
	priority      = SS_PRIORITY_FAST_MACHINERY
	display_order = SS_DISPLAY_FAST_MACHINERY
	var/list/currentrun = list()

/datum/subsystem/machinery/fast/New()
	NEW_SS_GLOBAL(SSfast_machinery)


/datum/subsystem/machinery/fast/stat_entry(var/msg)
	..("FP:[fast_machines.len]")

/datum/subsystem/machinery/fast/fire(resumed = FALSE)
	if(!resumed)
		currentrun = fast_machines.Copy()
	while(currentrun.len)
		var/obj/structure/machinery/M = currentrun[currentrun.len]
		currentrun.len--
		
		if(isnull(M))
			continue

		M.process()		
		if(MC_TICK_CHECK)
			return
