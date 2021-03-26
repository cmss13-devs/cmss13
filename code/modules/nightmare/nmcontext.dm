/// Nightmare setup global state
/datum/nmcontext
	/// Setup name
	var/name = "default nmcontext"
	/// Scenario values
	var/list/scenario
	/// Hash of config nodes by type
	var/list/steps = list()
	/// Global task controller
	var/datum/nmtask/sync/maintask
	/// Map loading controller
	var/datum/nmtask/sync/mapinit/mapcontroller
	/// TRUE once finished running the tasks
	var/done = FALSE
	/// Time of start of setup
	var/start_time

/datum/nmcontext/Destroy(force)
	scenario = null
	QDEL_NULL(maintask)
	QDEL_NULL(mapcontroller)
	QDEL_LIST_ASSOC_VAL(steps)
	return ..()

/// Loads nightmare config from a map config
/datum/nmcontext/proc/init_config(map_type = GROUND_MAP)
	SHOULD_NOT_SLEEP(TRUE)
	var/datum/map_config/MC = SSmapping.configs[map_type]
	var/list/allconfigs = MC?.nightmare
	if(!length(allconfigs))
		return FALSE
	for(var/name in allconfigs)
		var/datum/nmreader/reader = GLOB.nmreaders[name]
		var/datum/nmnode/tree = reader?.load_file(allconfigs[name])
		if(!tree)
			log_debug("NIGHTMARE: Failed to load step: [name] -> [allconfigs[name]]")
			continue
		steps[name] = tree
		. = TRUE

/// Initializes pre-generated scenario
/datum/nmcontext/proc/init_scenario()
	SHOULD_NOT_SLEEP(TRUE)
	if(!length(steps)) return FALSE
	scenario = list()
	var/datum/nmnode/storyboard = steps["scenario"]
	steps.Remove("scenario")
	if(!storyboard)
		log_debug("NIGHTMARE: Warning: running without a scenario config")
	else storyboard?.resolve(src)
	return scenario

/// Wrapper to request to execute the whole scenario
/datum/nmcontext/proc/start_setup()
	set waitfor = FALSE
	. = FALSE
	if(start_time || done) return
	start_time = REALTIMEOFDAY
	if(resolve_scenario())
		. = TRUE
		sleep(world.tick_lag) // Force detach from running subsystem so MC doesn't murder it
		run_steps()

/// Resolves result of the main steps for execution
/datum/nmcontext/proc/resolve_scenario()
	SHOULD_NOT_SLEEP(TRUE)
	mapcontroller  = new
	maintask = new
	maintask.register_task(mapcontroller)
	for(var/name in steps)
		var/datum/nmnode/tree = steps[name]
		tree?.resolve(src)
		. = TRUE

/// Run scenario steps synchronously - sleeps
/datum/nmcontext/proc/run_steps()
	PROTECTED_PROC(TRUE)
	// set waitfor = TRUE
	. = NM_TASK_ERROR
	var/retval
	while(!done)
		if(TICK_CHECK_HIGH_PRIORITY)
			stoplag()
		retval = maintask.invoke() // Synchronous only
		if(retval != NM_TASK_PAUSE)
			break
	done = TRUE
	SEND_GLOBAL_SIGNAL(COMSIG_GLOB_NIGHTMARE_SETUP_DONE, src, retval) // To be replaced later for multiple contexts
	if(retval == NM_TASK_OK)
		log_debug("NMCTX [name]: Setup finished in [(REALTIMEOFDAY - start_time)/10] seconds")
	else
		log_debug("NMCTX [name]: Execution error!")
	return retval
