/// Branch toward all other nodes
/datum/nmnode/branch
	name = "Branch"
	var/list/datum/nmnode/nodes

/datum/nmnode/branch/New(datum/nmreader/reader, list/nodespec)
	. = ..()
	if(!nodes)
		nodes = reader.parse_tree(nodespec["nodes"])

/datum/nmnode/branch/Destroy()
	QDEL_NULL_LIST(nodes)
	return ..()

/datum/nmnode/branch/resolve(datum/nmcontext/context)
	. = ..()
	if(!. || !length(nodes))
		return FALSE
	for(var/datum/nmnode/N in nodes)
		N.resolve(context)
	return TRUE

/// Same but load them from another file
/datum/nmnode/branch/include
	name = "Include"
	var/filepath
/datum/nmnode/branch/include/New(datum/nmreader/reader, list/nodespec)
	. = ..()
	if(nodes)
		return
	if(nodespec["file"])
		filepath = nodespec["file"]
	if(!nodespec["name"])
		name += ": [filepath]"
	nodes = reader.parse_file("[CONFIG_GET(string/nightmare_config_path)][filepath]")

/**
 * Pick between weighted random options
 * weights: array of weights for each option
 * amount:  how many to get in total
 */
/datum/nmnode/picker
	name = "Picker"
	var/amount = 1
	var/list/weights
	var/list/datum/nmnode/nodes

/datum/nmnode/picker/New(datum/nmreader/reader, list/nodespec)
	. = ..()
	if(nodespec["amount"])
		amount = nodespec["amount"]
	if(nodespec["weights"])
		var/list/json_weights = nodespec["weights"]
		weights = json_weights.Copy()
	else weights = list()
	nodes = reader.parse_tree(nodespec["choices"])
	weights.len = nodes.len
	for(var/i in 1 to length(nodes))
		if(!isnum(weights[i]) || weights[i] < 0)
			weights[i] = 1
		weights[i] = round(weights[i])

/datum/nmnode/picker/Destroy()
	QDEL_NULL_LIST(nodes)
	weights = null
	return ..()

/// Just a classic weighted pick
/datum/nmnode/picker/resolve(datum/nmcontext/context)
	. = ..()
	if(!.) return
	var/remaining = amount
	var/wtotal = 0
	for(var/w in weights)
		wtotal += w
	if(wtotal < 1)
		return
	while(length(nodes) && remaining)
		var/runtotal = 0
		var/rolled = rand(1, wtotal)
		for(var/i in 1 to length(nodes))
			runtotal += weights[i]
			if(rolled > runtotal)
				continue
			var/datum/nmnode/N = nodes[i]
			remaining--
			wtotal -= weights[i]
			nodes.Cut(i, i+1)
			weights.Cut(i, i+1)
			N.resolve(context)
			break
