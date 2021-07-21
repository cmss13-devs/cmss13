/// Handles mapload tasks, then initializing map
/datum/nmtask/sync/mapinit
	name = "mapinit"

/datum/nmtask/sync/mapinit/execute()
	. = ..()
	if(. == NM_TASK_OK)
		postload()

/datum/nmtask/sync/mapinit/proc/postload()
	SHOULD_NOT_SLEEP(TRUE)
	makepowernets()
	repopulate_sorted_areas()
	patch_lighting()

/datum/nmtask/sync/mapinit/proc/patch_lighting()
	var/list/turf/tainted = list()

	for(var/datum/nmtask/mapload/LT in finished)
		if(finished[LT] != NM_TASK_OK)
			continue
		if(!LT?.pmap || length(LT.pmap.bounds) < 6)
			continue
		var/list/bounds = LT.pmap.bounds
		var/list/TT = 	block(	locate(bounds[MAP_MINX], bounds[MAP_MINY], bounds[MAP_MINZ]),
								locate(bounds[MAP_MAXX], bounds[MAP_MAXY], bounds[MAP_MAXZ]))
		tainted |= TT

	for(var/turf/T in tainted)
		var/area/A = T.loc
		if(!A?.lighting_use_dynamic)
			continue
		T.cached_lumcount = -1 // Invalidate lumcount to force update here
		T.lighting_changed = TRUE
		SSlighting.changed_turfs += T
