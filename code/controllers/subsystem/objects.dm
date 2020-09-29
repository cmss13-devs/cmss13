var/list/processing_objects = list()

SUBSYSTEM_DEF(obj)
	name          = "Objects"
	priority      = SS_PRIORITY_OBJECTS
	wait          = 2 SECONDS
	flags = SS_NO_INIT

	var/list/currentrun = list()

/datum/controller/subsystem/obj/stat_entry()
	..("P:[processing_objects.len]")


/datum/controller/subsystem/obj/fire(resumed = FALSE)
	if (!resumed)
		currentrun = global.processing_objects.Copy()

	while (currentrun.len)
		var/atom/o = currentrun[currentrun.len]
		currentrun.len--

		if (!o || QDELETED(o))
			continue

		o.process()
		if (MC_TICK_CHECK)
			return
