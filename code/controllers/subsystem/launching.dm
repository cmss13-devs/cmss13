SUBSYSTEM_DEF(launching)
	name = "Launching"
	wait = 1
	init_order = SS_INIT_LAUNCHING
	flags = SS_TICKER
	priority = SS_PRIORITY_LAUNCHING

	VAR_PRIVATE/list/currentrun
	var/list/in_launch = list()

/datum/controller/subsystem/launching/stat_entry(msg)
	msg = " | #Launching: [length(in_launch)]"
	return ..()

/datum/controller/subsystem/launching/Initialize(start_timeofday)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/launching/fire(resumed = FALSE)
	if (!resumed)
		src.currentrun = in_launch.Copy()

	var/list/currentrun = src.currentrun
	while (length(currentrun))
		var/datum/component/launching/launching_component = currentrun[currentrun.len]
		currentrun.len--
		if (QDELETED(launching_component))
			in_launch -= launching_component
			if (MC_TICK_CHECK)
				return
			continue

		var/result = launching_component.process(wait)
		switch (result)
			if (/datum/component/launching::LAUNCH_RESULT_STOPPED)
				in_launch -= launching_component
				qdel(launching_component)
			if (/datum/component/launching::LAUNCH_RESULT_DELETED)
				in_launch -= launching_component


		if (MC_TICK_CHECK)
			return

/datum/controller/subsystem/launching/proc/queue_launch(datum/component/launching/launching_component)

