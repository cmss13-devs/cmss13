//SUPPLY PACKS
//NOTE: only secure crate types use the access var (and are lockable)
//ANOTER NOTE: Contraband is obtainable through modified supplycomp circuitboards.
//BIG NOTE: Don't add living things to crates, that's bad, it will break the shuttle.
//NOTE: Do NOT set the price of any crates below 7 points. Doing so allows infinite points.

// The lists of supply groups and contraband groups have been moved to /obj/structure/machinery/computer/supply/asrs definition as static variables.

/datum/supply_packs
	var/name = null // Abstract type
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

/datum/supply_packs/proc/get_contains()
	return contains

/datum/supply_packs/New()
	if(randomised_num_contained)
		manifest += "Contains any [randomised_num_contained] of:"
	manifest += "<ul>"
	for(var/atom/movable/path as anything in contains)
		manifest += "<li>[initial(path.name)]</li>"
	manifest += "</ul>"

/datum/supply_packs/proc/get_list_representation()
	var/types_in_contents = list()
	for(var/contents_type in contains)
		if(!types_in_contents[contents_type])
			types_in_contents[contents_type] = 1
			continue

		types_in_contents[contents_type]++

	var/pack_contents = list()
	for(var/atom/deduped_type as anything in types_in_contents)
		pack_contents += list(
			list(
				"name" = deduped_type::name,
				"quantity" = types_in_contents[deduped_type],
				"icon" = list(
					"icon" = deduped_type::icon,
					"icon_state" = deduped_type::icon_state
				)
			)
		)

	var/atom/container = containertype

	return list(
		"name" = name,
		"cost" = cost,
		"dollar_cost" = dollar_cost,
		"contains" = pack_contents,
		"category" = group,
		"type" = type,
		"icon" = container ? list(
			"icon" = container::icon,
			"icon_state" = container::icon_state
			) : null
	)
