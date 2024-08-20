//SUPPLY PACKS
//NOTE: only secure crate types use the access var (and are lockable)
//ANOTER NOTE: Contraband is obtainable through modified supplycomp circuitboards.
//BIG NOTE: Don't add living things to crates, that's bad, it will break the shuttle.
//NOTE: Do NOT set the price of any crates below 7 points. Doing so allows infinite points.

// The lists of supply groups and contraband groups have been moved to /obj/structure/machinery/computer/supplycomp definition as static variables.

/datum/supply_packs
	var/name = "Basic supply pack."
	/// If this variable is null (not if it's an empty list), *and* so is containertype, it won't show up on the order computer.
	var/list/contains = list()
	var/manifest = ""
	var/cost = 7 /// Determine the price of the crate. Give it a value between 7 and 100 to avoid breaking the game.
	/// If this variable is null (not if it's an empty list), *and* so is contains, it won't show up on the order computer.
	var/containertype = null
	var/containername = null
	var/access = null
	var/contraband = 0 /// Tell if the crate is a contraband value 1 or not 0.
	var/group = null
	var/buyable = 1 ///Can this pack be bought? These packs don't show up at all - they have to be spawned externally (fe: DEFCON ASRS)
	var/randomised_num_contained = 0 //Randomly picks X of items out of the contains list instead of using all.
	/// How many W-Y dollars are deducted from the supply controller. Only use for contraband.
	var/dollar_cost = 0
	/// How much "heat" this crate adds, too much heat will send an investigation. Only use for contraband.
	var/crate_heat = 0

/datum/supply_packs/New()
	if(randomised_num_contained)
		manifest += "Contains any [randomised_num_contained] of:"
	manifest += "<ul>"
	for(var/atom/movable/path in contains)
		if(!path) continue
		manifest += "<li>[initial(path.name)]</li>"
	manifest += "</ul>"
