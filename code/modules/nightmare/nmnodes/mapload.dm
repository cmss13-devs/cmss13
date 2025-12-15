/// Abstract config node designating a map insertion
/datum/nmnode/mapload
	id = "abstract-mapload"
	/// Base file (or directory) path of map files
	var/filepath

/datum/nmnode/mapload/New(list/spec)
	. = ..()
	filepath = spec["path"]

/// Designates insert of a given map file at a specified landmark
/datum/nmnode/mapload/landmark
	id = "map_insert"
	/// Landmark identifier
	var/landmark
	var/keep

/datum/nmnode/mapload/landmark/New(list/spec)
	. = ..()
	if(spec["landmark"])
		landmark = spec["landmark"]
	if(spec["keep"])
		keep = TRUE

/datum/nmnode/mapload/landmark/resolve(datum/nmcontext/context)
	. = ..()
	if(.)
		var/path = context.get_file_path(filepath, "map")
		var/datum/nmtask/mapload/task = new("[name] @ [landmark]", path, landmark, keep)
		context.add_task(task)



/**
 * Inserts a map file among a set of variations in a folder
 * param: path: some/folder/, landmark
 * files within should be named with a prefix indicating weighting:
 * some/folder/20.destroyed.dmm
 * some/folder/50.spaced.dmm
 * using + instead of dot means to keep map contents, eg.
 * some/folder/20+extras.dmm is added on top
 */
/datum/nmnode/mapload/variations
	id = "map_variations"
	name = "Map Variations"
	var/landmark
/datum/nmnode/mapload/variations/New(list/spec)
	. = ..()
	if(spec["landmark"])
		landmark = spec["landmark"]
		if(!spec["name"])
			name += ": [landmark]"
/datum/nmnode/mapload/variations/resolve(datum/nmcontext/context)
	. = ..()
	if(!. || !landmark)
		return
	var/dir_path = context.get_file_path(filepath, "map")
	var/regex/matcher = new(@"^([0-9]+)([\.\+]).*?\.dmm$", "i")
	var/list/filelist = list()
	var/list/weights = list()
	var/sum = 0
	for(var/filename in flist(dir_path))
		if(!matcher.Find(filename))
			continue
		filelist += filename
		var/w = text2num(matcher.group[1])
		weights  += w
		sum   += w
	var/roll = rand(1, sum)
#if !defined(UNIT_TESTS)
	sum = 0
#endif // Remove the possibility of chance for testing
	for(var/i in 1 to length(filelist))
		sum += weights[i]
		if(sum >= roll && matcher.Find(filelist[i]))
			var/keep = (matcher.group[2] == "+")
			var/datum/nmtask/mapload/task = new("[name] @ [landmark]", "[dir_path][matcher.match]", landmark, keep)
			context.add_task(task)
			break

/**
 * Similar to variations mode, but rolls all files individually rather
 * than picking one, using name for landmark. The prefix number is used
 * as a percentage chance.
 *
 * Example:
 *   some/folder/10.something_funny.dmm
 * would have 10% chance to insert at the 'something_funny' landmark
 */
/datum/nmnode/mapload/sprinkles
	id = "map_sprinkle"
	name = "Map Sprinkles"
/datum/nmnode/mapload/sprinkles/resolve(datum/nmcontext/context, list/statsmap)
	. = ..()
	if(!.)
		return
	var/dir_path = context.get_file_path(filepath, "map")
	var/regex/matcher = new(@"^([0-9]+)([\.\+])(([^_]+)(.*))?\.dmm$", "i")
	var/list/dircontents = flist(dir_path)
	for(var/filename in dircontents)
		if(!matcher.Find(filename))
			continue
#if !defined(UNIT_TESTS)
		var/fprob = clamp(text2num(matcher.group[1]) / 100, 0, 1)
		if(fprob < rand())
			continue
#endif // Remove the possibility of chance for testing
		var/landmark = matcher.group[3]
		var/keep = (matcher.group[2] == "+")
		var/datum/nmtask/mapload/task = new("[name] @ [landmark]", "[dir_path][matcher.match]", landmark, keep)
		context.add_task(task)
