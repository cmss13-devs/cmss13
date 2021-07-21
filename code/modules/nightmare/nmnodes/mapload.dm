/// Abstract node to queue a map insertion task
/datum/nmnode/mapload
	name = "Abstract Map Insert"
	var/filepath

/datum/nmnode/mapload/New(datum/nmreader/reader, list/nodespec)
	. = ..()
	filepath = nodespec["path"]
	filepath = "[CONFIG_GET(string/nightmare_map_path)][filepath]"

/datum/nmnode/mapload/landmark
	name = "Landmark Map Insert"
	var/landmark
	var/keep = FALSE
/datum/nmnode/mapload/landmark/New(datum/nmreader/reader, list/nodespec)
	. = ..()
	if(nodespec["landmark"])
		landmark = nodespec["landmark"]
	if(nodespec["keep"])
		keep = TRUE
/datum/nmnode/mapload/landmark/resolve(datum/nmcontext/context)
	. = ..()
	if(.)
		var/datum/nmtask/mapload/T = new(filepath, landmark, keep)
		context.mapcontroller.register_task(T)

/**
 * Inserts a map file among a set of variations in a folder
 * param: path: some/folder/, landmark
 * files within should be named with a prefix indicating weighting:
 *    some/folder/20.destroyed.dmm
 *    some/folder/50.spaced.dmm
 * using + instead of dot means to keep map contents, eg.
 *    some/folder/20+extras.dmm is added on top
 */
/datum/nmnode/mapload/variations
	name = "Map Variations"
	var/landmark
/datum/nmnode/mapload/variations/New(datum/nmreader/reader, list/nodespec)
	. = ..()
	if(nodespec["landmark"])
		landmark = nodespec["landmark"]
		if(!nodespec["name"])
			name += ": [landmark]"
/datum/nmnode/mapload/variations/resolve(datum/nmcontext/context)
	. = ..()
	if(!. || !landmark)
		return
	var/regex/matcher = new(@"^([0-9]+)([\.\+]).*?\.dmm$", "i")
	var/list/filelist = list()
	var/list/weights = list()
	var/sum = 0
	for(var/filename in flist(filepath))
		if(!matcher.Find(filename))
			continue
		filelist += filename
		var/w = text2num(matcher.group[1])
		weights  += w
		sum      += w
	var/roll = rand(1, sum)
	sum = 0
	for(var/i in 1 to length(filelist))
		sum += weights[i]
		if(sum >= roll && matcher.Find(filelist[i]))
			var/keep = (matcher.group[2] == "+")
			var/datum/nmtask/mapload/T = new("[filepath][matcher.match]", landmark, keep)
			context.mapcontroller.register_task(T)
			break

/**
 * Similar to variations mode, but rolls all files individually rather
 * than picking one, using name for landmark. The prefix number is used
 * as a percentage chance. You can add extra text with an underscore.
 *
 * Example:
 *   some/folder/10.something_funny.dmm
 * would have 10% chance to insert at 'something' landmark
 */
/datum/nmnode/mapload/sprinkles
	name = "Map Sprinkles"
/datum/nmnode/mapload/sprinkles/resolve(datum/nmcontext/context)
	. = ..()
	if(!.) return
	var/successes = 0
	var/regex/matcher = new(@"^([0-9]+)([\.\+])([^_]+)(_.*)?\.dmm$", "i")
	var/list/dircontents = flist(filepath)
	for(var/filename in dircontents)
		if(!matcher.Find(filename))
			continue
		var/chance = Clamp(text2num(matcher.group[1]) / 100, 0, 1)
		if(context.scenario["chaos"])
			chance = 1 - (1 - chance) ** context.scenario["chaos"]
		if(chance < rand())
			continue
		var/keep = (matcher.group[2] == "+")
		var/landmark = matcher.group[3]
		var/datum/nmtask/mapload/T = new("[filepath][matcher.match]", landmark, keep)
		context.mapcontroller.register_task(T)
		successes++
	logself("Queued [successes]/[length(dircontents)] map inserts", FALSE, "OK")
