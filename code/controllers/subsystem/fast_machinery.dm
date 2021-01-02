var/list/fast_machines = list()


SUBSYSTEM_DEF(fast_machinery)
	name          = "Fast Machinery"
	wait          = 0.7 SECONDS
	priority      = SS_PRIORITY_FAST_MACHINERY
	flags		  = SS_NO_INIT
	var/list/currentrun = list()

/datum/controller/subsystem/fast_machinery/stat_entry(msg)
	msg = "FP:[fast_machines.len]"
	return ..()

/datum/controller/subsystem/fast_machinery/fire(resumed = FALSE)
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
