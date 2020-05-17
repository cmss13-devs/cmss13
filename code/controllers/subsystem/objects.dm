var/datum/subsystem/obj/SSobj

var/list/processing_objects = list()

/datum/subsystem/obj
	name          = "Objects"
	init_order    = SS_INIT_OBJECT
	display_order = SS_DISPLAY_OBJECTS
	priority      = SS_PRIORITY_OBJECTS
	wait          = 2 SECONDS

	var/list/currentrun = list()

/datum/subsystem/obj/New()
	NEW_SS_GLOBAL(SSobj)

/datum/subsystem/obj/stat_entry()
	..("P:[processing_objects.len]")


/datum/subsystem/obj/fire(resumed = FALSE)
	if (!resumed)
		currentrun = global.processing_objects.Copy()

	while (currentrun.len)
		var/atom/o = currentrun[currentrun.len]
		currentrun.len--

		if (!o || o.disposed)
			continue

		o.process()
		if (MC_TICK_CHECK)
			return
