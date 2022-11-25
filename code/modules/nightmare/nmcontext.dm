/// Context within which we resolve nightmare actions
/datum/nmcontext
	/// User-friendly name
	var/name = "context"
	/// Storage of scenario values in the context as KV
	var/list/scenario = list()
	/// Config values used internally relevant to context
	var/list/config = list()
	/// Scheduler task type
	var/scheduler_type = /datum/nmtask/scheduler
	/// Holder for tasks to execute in the context
	VAR_PRIVATE/datum/nmtask/scheduler/scheduler
	/// Runtime debug list of resolved nodes in the context
	var/list/datum/nmnode/trace = list()

/datum/nmcontext/Destroy()
	QDEL_NULL(scheduler)
	scenario = null
	return ..()

/datum/nmcontext/New(name)
	. = ..()
	if(name)
		src.name = name
	scheduler = new scheduler_type

/// Get a value from the scenario, or a global value
/datum/nmcontext/proc/get_scenario_value(pname)
	var/datum/nmcontext/scope = src
	var/modifier = copytext(pname, 1, 2)
	if(modifier == "$")
		pname = copytext(pname, 2)
		scope = SSnightmare.contexts[NIGHTMARE_CTX_GLOBAL]
	return scope.scenario[pname]

/// Set a value in the scenario. This should only be used by manual user intervention, such as admins tweaking scenario!!
/datum/nmcontext/proc/set_scenario_value(pname, value)
	scenario[pname] = value

/// Resolve a config file path using context configuration
/datum/nmcontext/proc/get_file_path(relative_path, file_type = "config")
	if(config["prefix_[file_type]"])
		relative_path = "[config["prefix_[file_type]"]]/[relative_path]"
	if(fexists(relative_path))
		return relative_path
	CRASH("Nightmare context '[name]' failed to find file in scope '[file_type]': [relative_path]")

/datum/nmcontext/proc/add_task(task)
	scheduler.add_task(task)

/datum/nmcontext/proc/run_tasks()
	. = scheduler.invoke_sync()

/// Context belonging to a map scope (ground map, ship map, etc)
/datum/nmcontext/map
	// TODO: Factor in map traits to provide info about the map
	scheduler_type = /datum/nmtask/scheduler/mapload
