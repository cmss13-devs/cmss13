var/list/fast_objects = list()

SUBSYSTEM_DEF(fast_obj)
	name          = "Fast objects"
	priority      = SS_PRIORITY_FAST_OBJECTS
	wait          = 0.5 SECONDS
	flags         = SS_NO_INIT
	var/list/currentrun = list()

/datum/controller/subsystem/fast_obj/stat_entry()
	..("P:[fast_objects.len]")

/datum/controller/subsystem/fast_obj/fire(var/resumed = FALSE)
	if (!resumed)
		currentrun = global.fast_objects.Copy()

	while (currentrun.len)
		var/atom/o = currentrun[currentrun.len]
		currentrun.len--

		if (!o || QDELETED(o))
			continue

		// > this fucking proc isn't defined on a global level.
		// > Which means I can't fucking set waitfor on all of them.
		o:process()
		if (MC_TICK_CHECK)
			return
