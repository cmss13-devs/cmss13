/**
 * nmreaders instanciate config nmnodes based on the parsed
 * JSON configuration files
 */
/datum/nmreader
	/// Used to refer to reader
	var/name = "default"
	/// Extra mappings besides default ones
	var/list/nodemaps

/// Reads a file, use a branch node to contain the list
/datum/nmreader/proc/load_file(filename)
	RETURN_TYPE(/datum/nmnode/branch)
	var/datum/nmnode/branch/root = new(src, list())
	root.nodes = parse_file(filename)
	return root

/// Reads a file, return list of nodes
/datum/nmreader/proc/parse_file(filepath)
	RETURN_TYPE(/list/datum/nmnode)
	var/data = file(filepath)
	if(data) data = file2text(data)
	if(data) data = json_decode(data)
	if(!data || !islist(data))
		return list()
	return parse_tree(data)

/// Reads JSON, instanciates a list of nodes
/datum/nmreader/proc/parse_tree(list/parsed)
	if(!islist(parsed)) return
	var/list/datum/nmnode/nodes = list()
	if(!parsed["type"]) // This is a JSON array
		for(var/list/nodespec in parsed)
			var/datum/nmnode/N = read_node(nodespec)
			if(N) nodes += N
	else // This is a JSON hash
		var/datum/nmnode/N = read_node(parsed)
		if(N) nodes += N
	return nodes

/// Instanciates a single node from JSON hash
/datum/nmreader/proc/read_node(list/nodespec)
	RETURN_TYPE(/datum/nmnode)
	var/nodetype = nodespec["type"]
	var/static/list/builtinmaps = list(
		"branch"  = /datum/nmnode/branch,
		"include" = /datum/nmnode/branch/include,
		"pick"    = /datum/nmnode/picker
	)
	if(nodemaps && (nodetype in nodemaps))
		nodetype = nodemaps[nodetype]
	else if(nodetype in builtinmaps)
		nodetype = builtinmaps[nodetype]
	else return // Not found
	return new nodetype(src, nodespec)


// Workflow specific variants

/datum/nmreader/scenario
	name = "scenario"
	nodemaps = list(
		"def" = /datum/nmnode/scenario/def
	)

/datum/nmreader/mapgen
	name = "mapgen"
	nodemaps = list(
		"map_insert"       = /datum/nmnode/mapload/landmark,
		"map_variations"   = /datum/nmnode/mapload/variations,
		"map_sprinkle"     = /datum/nmnode/mapload/sprinkles
	)