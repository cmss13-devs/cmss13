/// Loads a chunk of map at the specified position
/datum/nmtask/mapload
	var/filepath
	var/landmark
	var/datum/parsed_map/parsed
	var/turf/target_turf
	var/loaded  = FALSE
	var/replace = TRUE

/datum/nmtask/mapload/New(name, filepath, landmark, keep = FALSE)
	. = ..()
	src.filepath = filepath
	src.landmark = landmark
	replace = !keep

/datum/nmtask/mapload/cleanup()
	QDEL_NULL(parsed)
	return ..()

/datum/nmtask/mapload/Destroy()
	QDEL_NULL(parsed)
	target_turf = null
	return ..()

/datum/nmtask/mapload/execute()
	if(loaded)
		return NIGHTMARE_TASK_OK
	if(step_parse() || step_loadmap() || step_init())
		return NIGHTMARE_TASK_ERROR
	loaded = TRUE
	return NIGHTMARE_TASK_OK

/// Step 1: Validate file and asks for parsing
/datum/nmtask/mapload/proc/step_parse()
	. = TRUE
	if(!fexists(filepath))
		log_debug("Nightmare Mapload: File does not exist: [filepath]")
		return
	if(!parsed)
		parsed = new(file(filepath))
		if(!parsed?.bounds)
			log_debug("Nightmare Mapload: File loading failed: [filepath]")
			return
		if(isnull(parsed.bounds[1]))
			log_debug("Nightmare Mapload: Map parsing failed: [filepath]")
			return
	return FALSE

/datum/nmtask/mapload/proc/step_loadmap(list/statsmap)
	. = TRUE
	UNTIL(!Master.map_loading)
	target_turf = GLOB.nightmare_landmarks[landmark]
	if(!target_turf?.z)
		log_debug("Nightmare Mapload: Could not find landmark: [landmark]")
		return
	var/result = parsed.load(target_turf.x, target_turf.y, target_turf.z, crop_map = TRUE, no_changeturf = FALSE, place_on_top = FALSE, delete = replace)
	if(!result || !parsed.bounds)
		log_debug("Nightmare Mapload: Map insertion failed unexpectedly for file: [filepath]")
		return
	return FALSE

/datum/nmtask/mapload/proc/step_init(list/statsmap)
	if(initialize_boundary_contents())
		log_debug("Nightmare Mapload: Loaded '[filepath]' at '[landmark]' ([target_turf.x], [target_turf.y], [target_turf.z])")
		return FALSE
	log_debug("Nightmare Mapload: Loaded map file but could not initialize: '[filepath]' at ([target_turf.x], [target_turf.y], [target_turf.z])")
	return TRUE

/// Initialize atoms/areas in bounds - basically a Nightmare version of [/datum/map_template/initTemplateBounds]
/datum/nmtask/mapload/proc/initialize_boundary_contents()
	var/list/bounds = parsed.bounds
	if(length(bounds) < 6)
		return
	var/list/turf_block = block( locate(bounds[MAP_MINX], bounds[MAP_MINY], bounds[MAP_MINZ]),
							locate(bounds[MAP_MAXX], bounds[MAP_MAXY], bounds[MAP_MAXZ]))
	var/list/area/arealist = list()
	var/list/atom/atomlist = list()
	for(var/turf/turf as anything in turf_block)
		atomlist += turf
		if(turf.loc)
			arealist |= turf.loc
		for(var/atom/movable/movable as anything in turf)
			atomlist += movable // Much like initTemplateBounds() this only recurses content once. Never been an issue so far, but keep it in mind.
	SSmapping.reg_in_areas_in_z(arealist) // Legacy. Not sure this is needed as it should already be carried out through area Initialize.
	SSatoms.InitializeAtoms(atomlist + arealist)
	// We still defer lighting, area sorting, etc, to be done all in one go!
	SEND_SIGNAL(src, COMSIG_NIGHTMARE_TAINTED_BOUNDS, bounds)
	return TRUE
