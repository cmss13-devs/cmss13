/**
 * Handles cleaning up resin when the area requests it
 */
/datum/component/resin_cleanup

/datum/component/resin_cleanup/Initialize(...)
	var/area/parent_area = get_area(parent)

	RegisterSignal(parent_area, COMSIG_AREA_RESIN_DISALLOWED, PROC_REF(cleanup_resin))

/datum/component/resin_cleanup/proc/cleanup_resin()
	SIGNAL_HANDLER

	if(isturf(parent))
		var/turf/parent_turf = parent
		addtimer(CALLBACK(parent_turf, TYPE_PROC_REF(/turf, ScrapeAway)), rand(1 SECONDS, 5 SECONDS))
		return

	QDEL_IN(parent, rand(1 SECONDS, 5 SECONDS))
