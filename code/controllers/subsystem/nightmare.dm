GLOBAL_SUBTYPE_PATHS_LIST_INDEXED(nightmare_node_map, /datum/nmnode, id)

SUBSYSTEM_DEF(nightmare)
	name    = "Nightmare"
	init_order = SS_INIT_NIGHTMARE
	flags = SS_NO_FIRE

	var/stat = NIGHTMARE_STATUS_STANDBY
	var/start_time = 0

	/// List of nightmare context types, mapped to their instance
	var/list/contexts = list()
	/// List of parsed file nodes
	var/list/roots = list()

/datum/controller/subsystem/nightmare/Initialize(start_timeofday)
	var/global_nightmare_path = CONFIG_GET(string/nightmare_path)
	if(global_nightmare_path)
		var/datum/nmcontext/CTX = new /datum/nmcontext
		contexts[NIGHTMARE_CTX_GLOBAL] = CTX
		CTX.config["prefix_nightmare"] = global_nightmare_path
		load_file("[global_nightmare_path]/[NIGHTMARE_FILE_SCENARIO]", "[NIGHTMARE_CTX_GLOBAL]-[NIGHTMARE_ACT_SCENARIO]")
		load_file("[global_nightmare_path]/[NIGHTMARE_FILE_BASE]", "[NIGHTMARE_CTX_GLOBAL]-[NIGHTMARE_ACT_BASE]")
	load_map_config(NIGHTMARE_CTX_GROUND, GROUND_MAP)
	load_map_config(NIGHTMARE_CTX_SHIP, SHIP_MAP)
	set_scenario_value("gamemode", GLOB.master_mode)
	for(var/context_name in contexts)
		resolve_nodes(context_name, NIGHTMARE_ACT_SCENARIO)
	return SS_INIT_SUCCESS

/datum/controller/subsystem/nightmare/proc/resolve_nodes(context_name, scope)
	var/datum/nmcontext/context = contexts[context_name]
	context.set_scenario_value("gamemode", GLOB.master_mode)
	var/datum/nmnode/nodes = roots["[context_name]-[scope]"]
	nodes?.invoke(context)

/datum/controller/subsystem/nightmare/proc/prepare_game()
	// set waitfor = TRUE
	//
	// as of current tasks should be synchronous the whole way to here
	// in the event this call tree disappears/goes awol, SSticker
	// can recover by cancelling execution (setting to NIGHTMARE_STATUS_DONE)
	//
	// this is the only way i've found to make this work, other than going
	// full cooperative scheduling with the tasks / a ticking SS

	if(!initialized)
		message_admins("Nightmare subsystem is performing prepare_game prior to initialization! No nightmare inserts will be loaded.")

	if(stat == NIGHTMARE_STATUS_DONE)
		return TRUE
	if(stat == NIGHTMARE_STATUS_RUNNING)
		return FALSE
	if(stat == NIGHTMARE_STATUS_STANDBY)
		start_time = world.time
		stat = NIGHTMARE_STATUS_RUNNING
	. = FALSE
	for(var/context_name in contexts)
		if(stat != NIGHTMARE_STATUS_RUNNING)
			return TRUE // Panic Abort
		set_scenario_value("gamemode", GLOB.master_mode) // Architectural pitfall - Hope it doesn't change during setup :(
		var/datum/nmcontext/context = contexts[context_name]
		var/datum/nmnode/root = roots["[context_name]-[NIGHTMARE_ACT_BASE]"]
		if(root)
			root.invoke(context)
			log_debug("Nightmare: Resolved context [context_name]")
	for(var/context_name in contexts)
		if(stat != NIGHTMARE_STATUS_RUNNING)
			return TRUE // Panic Abort
		var/datum/nmcontext/context = contexts[context_name]
		context.set_scenario_value("gamemode", GLOB.master_mode)
		var/ret = context.run_tasks()
		if(ret != NIGHTMARE_TASK_OK)
			log_debug("Nightmare: Failed tasks execution for [context_name]")
	stat = NIGHTMARE_STATUS_DONE
	return TRUE

/// Load nightmare steps relevant to a map
/datum/controller/subsystem/nightmare/proc/load_map_config(context_name, map_type)
	var/datum/map_config/MC = SSmapping.configs[map_type]
	var/datum/nmcontext/CTX = new /datum/nmcontext/map
	contexts[context_name] = CTX
	CTX.config["prefix_map"] = "maps/[MC.map_path]"
	CTX.config["prefix_nightmare"] = MC.nightmare_path
	load_file("[MC.nightmare_path]/[NIGHTMARE_FILE_SCENARIO]", "[context_name]-[NIGHTMARE_ACT_SCENARIO]")
	load_file("[MC.nightmare_path]/[NIGHTMARE_FILE_BASE]", "[context_name]-[NIGHTMARE_ACT_BASE]")
	log_debug("Nightmare: Loaded map environment {[context_name],[map_type]}")

/// Returns a value from the global scenario
/datum/controller/subsystem/nightmare/proc/get_scenario_value(name)
	var/datum/nmcontext/context = contexts[NIGHTMARE_CTX_GLOBAL]
	return context.get_scenario_value(name)

/// Override a value from the global scenario.
/datum/controller/subsystem/nightmare/proc/set_scenario_value(name, value)
	var/datum/nmcontext/context = contexts[NIGHTMARE_CTX_GLOBAL]
	return context.set_scenario_value(name, value)

/// Reads a JSON file, returns a branch nmnode representing contents of file
/datum/controller/subsystem/nightmare/proc/load_file(filename, tag)
	RETURN_TYPE(/datum/nmnode/branch)
	var/datum/nmnode/branch/root = new(list())
	var/list/datum/nmnode/nodes = parse_file(filename)
	root.nodes = nodes
	if(root && tag)
		roots[tag] = root
	return root

/// Reads a JSON file, returns list of config nodes in the file
/datum/controller/subsystem/nightmare/proc/parse_file(filename)
	RETURN_TYPE(/list/datum/nmnode)
	. = list()
	var/data = file(filename)
	if(!data)
		log_debug("Nightmare: Failed to read config file: [filename]")
		CRASH("Could not get requested nightmare config file!")
	if(data) data = file2text(data)
	if(data) data = json_decode(data)
	return parse_tree(data)

/// Instanciates nmnodes from parsed JSON
/datum/controller/subsystem/nightmare/proc/parse_tree(list/parsed)
	RETURN_TYPE(/list/datum/nmnode)
	if(!islist(parsed)) return
	var/list/datum/nmnode/nodes = list()
	if(!parsed["type"]) // This is a JSON array
		for(var/list/spec as anything in parsed)
			var/datum/nmnode/N = read_node(spec)
			if(N) nodes += N
	else // This is a JSON hash
		var/datum/nmnode/N = read_node(parsed)
		if(N) nodes += N
	return nodes

/// Instanciate a single nmnode from its JSON definition
/datum/controller/subsystem/nightmare/proc/read_node(list/parsed)
	RETURN_TYPE(/datum/nmnode)
	var/jsontype = parsed["type"]
	var/nodetype = GLOB.nightmare_node_map[jsontype]
	if(nodetype)
		return new nodetype(parsed)
	else
		CRASH("Tried to instanciate an invalid node type")

