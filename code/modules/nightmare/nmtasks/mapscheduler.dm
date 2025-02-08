/// Handles map insertions sequentially and updating the game to match map insertions
/datum/nmtask/scheduler/mapload
	name = "mapload scheduler"
	/// Map boundaries tainted by children nightmare tasks to be handled
	var/list/tainted_bounds = list()

/datum/nmtask/scheduler/mapload/execute()
	. = ..()
	makepowernets()
	repopulate_sorted_areas()
	patch_lighting()

/datum/nmtask/scheduler/mapload/add_task(datum/nmtask/task)
	. = ..()
	RegisterSignal(task, COMSIG_NIGHTMARE_TAINTED_BOUNDS, PROC_REF(register_tainted_bounds))

/datum/nmtask/scheduler/mapload/proc/register_tainted_bounds(datum/nmtask/task, list/bounds)
	tainted_bounds.len++
	tainted_bounds[length(tainted_bounds)] = bounds

/datum/nmtask/scheduler/mapload/proc/patch_lighting()
	var/list/tainted = list()

	for(var/list/bounds as anything in tainted_bounds)
		var/list/TT = block(bounds[MAP_MINX], bounds[MAP_MINY], bounds[MAP_MINZ], bounds[MAP_MAXX], bounds[MAP_MAXY], bounds[MAP_MAXZ])
		tainted |= TT

	for(var/turf/T as anything in tainted)
		var/area/A = T.loc
		if(!A?.area_has_base_lighting)
			continue
		T.update_light()
