var/list/fast_machines = list()


SUBSYSTEM_DEF(fast_machinery)
	name          = "Fast Machinery"
	wait          = SS_WAIT_FAST_MACHINERY
	priority      = SS_PRIORITY_FAST_MACHINERY
	display_order = SS_DISPLAY_FAST_MACHINERY
	flags		  = SS_NO_INIT
	var/list/currentrun = list()

/datum/subsystem/fast_machinery/stat_entry(var/msg)
	..("FP:[fast_machines.len]")

/datum/subsystem/fast_machinery/fire(resumed = FALSE)
	if(!resumed)
		currentrun = fast_machines.Copy()
	while(currentrun.len)
		var/obj/structure/machinery/M = currentrun[currentrun.len]
		currentrun.len--
		
		if(QDELETED(M))
			continue

		M.process()		
		if(MC_TICK_CHECK)
			return
