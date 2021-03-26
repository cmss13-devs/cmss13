/**
 * Map Loading task
 * Replaces the location at a landmark by contents of a new map file
 */

/datum/nmtask/mapload
	name = "mapload"
	var/filepath
	var/replace = TRUE
	var/turf/target_turf
	var/datum/parsed_map/pmap
	var/loaded = FALSE

/datum/nmtask/mapload/New(filepath, landmark, keep = FALSE)
	. = ..()
	src.filepath = filepath
	name += ": [filepath]"
	target_turf = GLOB.nightmare_landmarks[landmark]
	replace = !keep

/datum/nmtask/mapload/Destroy()
	target_turf = null
	pmap = null
	return ..()

/datum/nmtask/mapload/execute()
	if(!target_turf?.z || !fexists(filepath))
		logself("Location or file invalid", TRUE, "ERROR")
		return NM_TASK_ERROR
	if(!pmap)
		pmap = new(file(filepath))
		if(!pmap?.bounds)
			logself("File Loading failed", TRUE, "ERROR")
			return NM_TASK_ERROR
		if(isnull(pmap.bounds[1]))
			logself("Map Parsing failed", TRUE, "ERROR")
			return NM_TASK_ERROR
		if(TICK_CHECK_HIGH_PRIORITY)
			return NM_TASK_PAUSE
	if(Master.map_loading)
		return NM_TASK_PAUSE
	if(!loaded)
		var/result = pmap.load(target_turf.x, target_turf.y, target_turf.z, cropMap = TRUE, no_changeturf = FALSE, placeOnTop = FALSE, delete = replace)
		if(!result || !pmap.bounds)
			logself("Map Loading failed", TRUE, "ERROR")
			return NM_TASK_ERROR
		else
			loaded = TRUE
			if(initialize_boundary_contents())
				logself("Loaded at ([target_turf.x], [target_turf.y], [target_turf.z])", FALSE, "OK")
			else logself("Lodaded but INIT FAILED", TRUE, "ERROR")
	return NM_TASK_OK

/// Initialize atoms/areas in bounds - we can't afford to do this later since game is half-running
/datum/nmtask/mapload/proc/initialize_boundary_contents()
	var/list/bounds = pmap.bounds
	if(length(bounds) < 6)
		return
	var/list/TT = 	block(	locate(bounds[MAP_MINX], bounds[MAP_MINY], bounds[MAP_MINZ]),
							locate(bounds[MAP_MAXX], bounds[MAP_MAXY], bounds[MAP_MAXZ]))
	var/list/area/arealist = list()
	var/list/atom/atomlist = list()
	for(var/i in TT)
		var/turf/T = i
		atomlist |= T // a turf is an atom too
		if(T.loc) arealist |= T.loc
		for(var/A in T)
			atomlist |= A
	SSmapping.reg_in_areas_in_z(arealist)
	SSatoms.InitializeAtoms(atomlist)
	// We still defer lighting, area sorting, etc
	return TRUE
