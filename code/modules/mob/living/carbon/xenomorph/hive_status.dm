/datum/hive_status
	var/name = "Normal Hive"

	// Used for the faction of the xenomorph. Not recommended to modify.
	var/internal_faction

	/// Short Hive ID as string used in stats reporting
	var/reporting_id = "normal"

	var/hivenumber = XENO_HIVE_NORMAL
	var/mob/living/carbon/xenomorph/queen/living_xeno_queen
	var/egg_planting_range = 15
	var/slashing_allowed = XENO_SLASH_ALLOWED //This initial var allows the queen to turn on or off slashing. Slashing off means harm intent does much less damage.
	var/construction_allowed = NORMAL_XENO //Who can place construction nodes for special structures
	var/destruction_allowed = NORMAL_XENO //Who can destroy special structures
	var/unnesting_allowed = TRUE
	var/hive_orders = "" //What orders should the hive have
	var/color = null
	var/ui_color = null // Color for hive status collapsible buttons and xeno count list
	var/prefix = ""
	var/queen_leader_limit = 2
	var/list/open_xeno_leader_positions = list(1, 2) // Ordered list of xeno leader positions (indexes in xeno_leader_list) that are not occupied
	var/list/xeno_leader_list[2] // Ordered list (i.e. index n holds the nth xeno leader)
	var/stored_larva = 0

	///used by /datum/hive_status/proc/increase_larva_after_burst() to support non-integer increases to larva
	var/partial_larva = 0
	/// Assoc list of free slots available to specific castes
	var/list/free_slots = list(
		/datum/caste_datum/burrower = 1,
		/datum/caste_datum/hivelord = 1,
		/datum/caste_datum/carrier = 1
	)
	/// Assoc list of slots currently used by specific castes (for calculating free_slot usage)
	var/list/used_slots = list()
	/// list of living tier2 xenos
	var/list/tier_2_xenos = list()
	/// list of living tier3 xenos
	var/list/tier_3_xenos = list()
	/// list of living xenos
	var/list/totalXenos = list()
	/// list of previously living xenos (hardrefs currently)
	var/list/total_dead_xenos = list()
	var/xeno_queen_timer
	var/isSlotOpen = TRUE //Set true for starting alerts only after the hive has reached its full potential
	var/allowed_nest_distance = 15 //How far away do we allow nests from an ovied Queen. Default 15 tiles.
	var/obj/effect/alien/resin/special/pylon/core/hive_location = null //Set to ref every time a core is built, for defining the hive location

	var/healthstack = 1
	var/tier_slot_multiplier = 1
	var/larva_gestation_multiplier = 1
	var/bonus_larva_spawn_chance = 1
	var/hijack_burrowed_surge = FALSE //at hijack, start spawning lots of burrowed
	/// how many burrowed is going to spawn during larva surge
	var/hijack_burrowed_left = 0

	var/dynamic_evolution = TRUE
	var/evolution_rate = 3 // Only has use if dynamic_evolution is false
	var/evolution_bonus = 0

	var/allow_no_queen_actions = FALSE
	var/allow_no_queen_evo = FALSE
	var/evolution_without_ovipositor = TRUE //Temporary for the roundstart.
	/// Set to false if you want to prevent evolutions into Queens
	var/allow_queen_evolve = TRUE
	/// Set to true if you want to prevent bursts and spawns of new xenos. Will also prevent healing if the queen no longer exists
	var/hardcore = FALSE
	/// Set to false if you want to prevent getting burrowed larva from latejoin marines
	var/latejoin_burrowed = TRUE
	/// If hit limit of larva from pylons
	var/hit_larva_pylon_limit = FALSE

	var/see_humans_on_tacmap = FALSE

	var/list/hive_inherant_traits

	// Cultist Info
	var/mob/living/carbon/leading_cult_sl

	//List of how many maximum of each special structure you can have
	var/list/hive_structures_limit = list(
		XENO_STRUCTURE_CORE = 1,
		XENO_STRUCTURE_CLUSTER = 8,
		XENO_STRUCTURE_EGGMORPH = 6,
		XENO_STRUCTURE_SUNKEN = 3,
		XENO_STRUCTURE_RECOVERY = 6,
		XENO_STRUCTURE_PYLON = 2,
	)

	var/global/list/hive_structure_types = list(
		XENO_STRUCTURE_CORE = /datum/construction_template/xenomorph/core,
		XENO_STRUCTURE_CLUSTER = /datum/construction_template/xenomorph/cluster,
		XENO_STRUCTURE_EGGMORPH = /datum/construction_template/xenomorph/eggmorph,
		XENO_STRUCTURE_RECOVERY = /datum/construction_template/xenomorph/recovery
	)

	var/list/list/hive_structures = list() //Stringref list of structures that have been built
	var/list/list/hive_constructions = list() //Stringref list of structures that are being built

	var/datum/hive_status_ui/hive_ui
	var/datum/mark_menu_ui/mark_ui
	var/datum/hive_faction_ui/faction_ui

	var/list/tunnels = list()

	var/list/allies = list()

	var/list/resin_marks = list()

	var/list/banished_ckeys = list()

	var/hivecore_cooldown = FALSE

	var/need_round_end_check = FALSE

	//Joining as Facehugger vars
	/// When can huggers join the round
	var/hugger_timelock = 15 MINUTES
	/// How many huggers can the hive support
	var/playable_hugger_limit = 0
	/// Minimum number of huggers available at any hive size
	var/playable_hugger_minimum = 2
	/// This number divides the total xenos counted for slots to give the max number of facehuggers
	var/playable_hugger_max_divisor = 4

	/// How many lesser drones the hive can support
	var/lesser_drone_limit = 0
	/// Slots available for lesser drones will never go below this number
	var/lesser_drone_minimum = 2
	/// This number divides the total xenos counted for slots to give the max number of lesser drones
	var/playable_lesser_drones_max_divisor = 3

	var/datum/tacmap/drawing/xeno/tacmap
	var/minimap_type = MINIMAP_FLAG_XENO

	var/list/available_nicknumbers = list()

	/*Stores the image()'s for the xeno evolution radial menu
	To add an image for your caste - add an icon to icons/mob/xenos/radial_xenos.dmi
	Icon size should be 32x32, to make them fit within the radial menu border size your icon 22x22 and leave 10px transparent border.
	The name of the icon should be the same as the XENO_CASTE_ define for that caste eg. #define XENO_CASTE_DRONE "Drone"
	*/
	var/static/list/evolution_menu_images

/datum/hive_status/New()
	hive_ui = new(src)
	mark_ui = new(src)
	faction_ui = new(src)
	minimap_type = get_minimap_flag_for_faction(hivenumber)
	tacmap = new(src, minimap_type)
	if(!internal_faction)
		internal_faction = name
	for(var/number in 1 to 999)
		available_nicknumbers += number
	if(hivenumber != XENO_HIVE_NORMAL)
		return

	if(!evolution_menu_images)
		evolution_menu_images = list()
		generate_evo_menu_images()

	RegisterSignal(SSdcs, COMSIG_GLOB_POST_SETUP, PROC_REF(post_setup))

///Generate the image()'s requried for the evolution radial menu.
/datum/hive_status/proc/generate_evo_menu_images()
	for(var/datum/caste_datum/caste as anything in subtypesof(/datum/caste_datum))
		evolution_menu_images[initial(caste.caste_type)] = image('icons/mob/xenos/radial_xenos.dmi', initial(caste.caste_type))

/datum/hive_status/proc/post_setup()
	SIGNAL_HANDLER

	setup_evolution_announcements()
	setup_pylon_limits()

/datum/hive_status/proc/setup_evolution_announcements()
	for(var/time in GLOB.xeno_evolve_times)
		if(time == "0")
			continue

		addtimer(CALLBACK(src, PROC_REF(announce_evolve_available), GLOB.xeno_evolve_times[time]), text2num(time))

/// Sets up limits on pylons in New() for potential futureproofing with more static comms
/datum/hive_status/proc/setup_pylon_limits()
	hive_structures_limit[XENO_STRUCTURE_PYLON] = length(GLOB.all_static_telecomms_towers) || 2

/datum/hive_status/proc/announce_evolve_available(list/datum/caste_datum/available_castes)

	var/list/castes_available = list()
	for(var/datum/caste_datum/current_caste as anything in available_castes)
		castes_available += initial(current_caste.caste_type)

	var/castes = castes_available.Join(", ")
	xeno_message(SPAN_XENOANNOUNCE("The Hive is now strong enough to support: [castes]"))
	xeno_maptext("The Hive can now support: [castes]", "Hive Strengthening")


// Adds a xeno to this hive
/datum/hive_status/proc/add_xeno(mob/living/carbon/xenomorph/X)
	if(!X || !istype(X))
		return

	// If the xeno is part of another hive, they should be removed from that one first
	if(X.hive && X.hive != src)
		X.hive.remove_xeno(X, TRUE)

	// Already in the hive
	if(X in totalXenos)
		return

	// Can only have one queen.
	if(isqueen(X))
		if(!living_xeno_queen && !should_block_game_interaction(X)) // Don't consider xenos in admin level
			set_living_xeno_queen(X)

	X.hivenumber = hivenumber
	X.hive = src

	X.set_faction(internal_faction)

	if(X.hud_list)
		X.hud_update()

	var/area/A = get_area(X)
	if(!should_block_game_interaction(X) || (A.flags_atom & AREA_ALLOW_XENO_JOIN))
		totalXenos += X
		if(X.tier == 2)
			tier_2_xenos += X
		else if(X.tier == 3)
			tier_3_xenos += X

	// Xenos are a fuckfest of cross-dependencies of different datums that are initialized at different times
	// So don't even bother trying updating UI here without large refactors

// Removes the xeno from the hive
/datum/hive_status/proc/remove_xeno(mob/living/carbon/xenomorph/xeno, hard = FALSE, light_mode = FALSE)
	if(!xeno || !istype(xeno))
		return

	// Make sure the xeno was in the hive in the first place
	if(!(xeno in totalXenos))
		return

	// This might be a redundant check now that Queen/Destroy() checks, but doesn't hurt to double check
	if(living_xeno_queen == xeno)
		var/mob/living/carbon/xenomorph/queen/next_queen = null
		for(var/mob/living/carbon/xenomorph/queen/queen in totalXenos)
			if(!should_block_game_interaction(queen) && queen != src && !QDELETED(queen))
				next_queen = queen
				break

		set_living_xeno_queen(next_queen) // either null or a queen

	// We allow "soft" removals from the hive (the xeno still retains information about the hive)
	// This is so that xenos can add themselves back to the hive if they should die or otherwise go "on leave" from the hive
	if(hard)
		xeno.hivenumber = 0
		xeno.hive = null
#ifndef UNIT_TESTS // Since this is a hard ref, we shouldn't confuse create_and_destroy
	else
		total_dead_xenos += xeno
#endif

	totalXenos -= xeno
	if(xeno.tier == 2)
		tier_2_xenos -= xeno
	else if(xeno.tier == 3)
		tier_3_xenos -= xeno

	// Only handle free slots if the xeno is not in tdome
	if(!should_block_game_interaction(xeno))
		var/selected_caste = GLOB.xeno_datum_list[xeno.caste_type]?.type
		if(used_slots[selected_caste])
			used_slots[selected_caste]--

	if(!light_mode)
		hive_ui.update_xeno_counts()
		hive_ui.xeno_removed(xeno)

/datum/hive_status/proc/set_living_xeno_queen(mob/living/carbon/xenomorph/queen/queen)
	if(!queen)
		SStracking.delete_leader("hive_[hivenumber]")
		SStracking.stop_tracking("hive_[hivenumber]", living_xeno_queen)
		SShive_status.wait = 10 SECONDS
	else
		SStracking.set_leader("hive_[hivenumber]", queen)
		SShive_status.wait = 2 SECONDS

	SEND_SIGNAL(src, COMSIG_HIVE_NEW_QUEEN, queen)
	living_xeno_queen = queen

	recalculate_hive()

/datum/hive_status/proc/recalculate_hive()
	//No leaders for a Hive without a Queen!
	queen_leader_limit = living_xeno_queen ? 4 : 0

	if (xeno_leader_list.len > queen_leader_limit)
		var/diff = 0
		for (var/i in queen_leader_limit + 1 to xeno_leader_list.len)
			if(!open_xeno_leader_positions.Remove(i))
				remove_hive_leader(xeno_leader_list[i])
			diff++
		xeno_leader_list.len -= diff // Changing the size of xeno_leader_list needs to go at the end or else it won't iterate through the list properly
	else if (xeno_leader_list.len < queen_leader_limit)
		for (var/i in xeno_leader_list.len + 1 to queen_leader_limit)
			open_xeno_leader_positions += i
			xeno_leader_list.len++

	hive_ui.update_all_data()

/datum/hive_status/proc/add_hive_leader(mob/living/carbon/xenomorph/xeno)
	if(!xeno)
		return FALSE //How did this even happen?
	if(!open_xeno_leader_positions.len)
		return FALSE //Too many leaders already (no available xeno leader positions)
	if(xeno.hive_pos != NORMAL_XENO)
		return FALSE //Already on the list
	var/leader_num = open_xeno_leader_positions[1]
	xeno_leader_list[leader_num] = xeno
	xeno.hive_pos = XENO_LEADER_HIVE_POS(leader_num)
	xeno.handle_xeno_leader_pheromones()
	xeno.hud_update() // To add leader star
	open_xeno_leader_positions -= leader_num

	xeno.update_minimap_icon()

	give_action(xeno, /datum/action/xeno_action/activable/info_marker)

	hive_ui.update_xeno_keys()
	return TRUE

/datum/hive_status/proc/remove_hive_leader(mob/living/carbon/xenomorph/xeno, light_mode = FALSE)
	if(!istype(xeno) || !IS_XENO_LEADER(xeno))
		return FALSE

	var/leader_num = GET_XENO_LEADER_NUM(xeno)

	xeno_leader_list[leader_num] = null

	if(!light_mode) // Don't run side effects during deletions. Better yet, replace all this by signals someday
		xeno.hive_pos = NORMAL_XENO
		xeno.handle_xeno_leader_pheromones()
		xeno.hud_update() // To remove leader star

	// Need to maintain ascending order of open_xeno_leader_positions
	for (var/i in 1 to queen_leader_limit)
		if (i > open_xeno_leader_positions.len || open_xeno_leader_positions[i] > leader_num)
			open_xeno_leader_positions.Insert(i, leader_num)
			break

	if(!light_mode)
		hive_ui.update_xeno_keys()

	for(var/obj/effect/alien/resin/marker/leaderless_mark in resin_marks) //no resin_mark limit abuse
		if(leaderless_mark.createdby == xeno.nicknumber)
			qdel(leaderless_mark)

	xeno.update_minimap_icon()

	remove_action(xeno, /datum/action/xeno_action/activable/info_marker)

	return TRUE

/datum/hive_status/proc/replace_hive_leader(mob/living/carbon/xenomorph/original, mob/living/carbon/xenomorph/replacement)
	if(!replacement || replacement.hive_pos != NORMAL_XENO)
		return remove_hive_leader(original)

	var/leader_num = GET_XENO_LEADER_NUM(original)

	xeno_leader_list[leader_num] = replacement

	original.hive_pos = NORMAL_XENO
	original.handle_xeno_leader_pheromones()
	original.hud_update() // To remove leader star
	remove_action(original, /datum/action/xeno_action/activable/info_marker)

	replacement.hive_pos = XENO_LEADER_HIVE_POS(leader_num)
	replacement.handle_xeno_leader_pheromones()
	replacement.hud_update() // To add leader star
	give_action(replacement, /datum/action/xeno_action/activable/info_marker)

	hive_ui.update_xeno_keys()

/datum/hive_status/proc/handle_xeno_leader_pheromones()
	for(var/mob/living/carbon/xenomorph/L in xeno_leader_list)
		L.handle_xeno_leader_pheromones()

/*
 * Helper procs for the Hive Status UI
 * These are all called by the hive status UI manager to update its data
 */

// Returns a list of how many of each caste of xeno there are, sorted by tier
/datum/hive_status/proc/get_xeno_counts()
	// Every caste is manually defined here so you get
	var/list/xeno_counts = list(
		// Yes, Queen is technically considered to be tier 0
		list(XENO_CASTE_LARVA = 0, "Queen" = 0),
		list(XENO_CASTE_DRONE = 0, XENO_CASTE_RUNNER = 0, XENO_CASTE_SENTINEL = 0, XENO_CASTE_DEFENDER = 0),
		list(XENO_CASTE_HIVELORD = 0, XENO_CASTE_BURROWER = 0, XENO_CASTE_CARRIER = 0, XENO_CASTE_LURKER = 0, XENO_CASTE_SPITTER = 0, XENO_CASTE_WARRIOR = 0),
		list(XENO_CASTE_BOILER = 0, XENO_CASTE_CRUSHER = 0, XENO_CASTE_PRAETORIAN = 0, XENO_CASTE_RAVAGER = 0)
	)

	for(var/mob/living/carbon/xenomorph/X in totalXenos)
		//don't show xenos in the thunderdome when admins test stuff.
		if(should_block_game_interaction(X))
			var/area/A = get_area(X)
			if(!(A.flags_atom & AREA_ALLOW_XENO_JOIN))
				continue

		if(X.caste && X.counts_for_slots)
			xeno_counts[X.caste.tier+1][X.caste.caste_type]++

	return xeno_counts

// Returns a sorted list of some basic info (stuff that's needed for sorting) about all the xenos in the hive
// The idea is that we sort this list, and use it as a "key" for all the other information (especially the nicknumber)
// in the hive status UI. That way we can minimize the amount of sorts performed by only calling this when xenos are created/disposed
/datum/hive_status/proc/get_xeno_keys()
	var/list/xenos = list()

	for(var/mob/living/carbon/xenomorph/X in totalXenos)
		if(should_block_game_interaction(X))
			var/area/A = get_area(X)
			if(!(A.flags_atom & AREA_ALLOW_XENO_JOIN))
				continue

		if(!(X in GLOB.living_xeno_list))
			continue

		// This looks weird, but in DM adding List A to List B actually adds each item in List B to List A, not List B itself.
		// Having a nested list like this sort of tricks it into adding the list instead.
		// In this case this results in an array of different 'xeno' dictionaries, rather than just a dictionary.
		xenos += list(list(
			"nicknumber" = X.nicknumber,
			"tier" = X.tier, // This one is only important for sorting
			"is_leader" = (IS_XENO_LEADER(X)),
			"is_queen" = istype(X.caste, /datum/caste_datum/queen),
			"caste_type" = X.caste_type
		))

	// Make it all nice and fancy by sorting the list before returning it
	var/list/sorted_keys = sort_xeno_keys(xenos)
	if(length(sorted_keys))
		return sorted_keys
	return xenos

// This sorts the xeno info list by multiple criteria. Prioritized in order:
// 1. Queen
// 2. Leaders
// 3. Tier
// It uses a slightly modified insertion sort to accomplish this
/datum/hive_status/proc/sort_xeno_keys(list/xenos)
	if(!length(xenos))
		return

	var/list/sorted_list = xenos.Copy()

	if(!length(sorted_list))
		return

	for(var/index in 2 to length(sorted_list))
		var/j = index

		while(j > 1)
			var/current = sorted_list[j]
			var/prev = sorted_list[j-1]

			// Queen comes first, always
			if(current["is_queen"])
				sorted_list.Swap(j-1, j)
				j--
				continue

			// don't muck up queen's slot
			if(prev["is_queen"])
				j--
				continue

			// Leaders before normal xenos
			if(!prev["is_leader"] && current["is_leader"])
				sorted_list.Swap(j-1, j)
				j--
				continue

			// Make sure we're only comparing leaders to leaders and non-leaders to non-leaders when sorting
			// This means we get leaders sorted first, then non-leaders sorted
			// Sort by tier first, higher tiers over lower tiers, and then by name alphabetically

			// Could not think of an elegant way to write this
			if(!(current["is_leader"]^prev["is_leader"])\
				&& (prev["tier"] < current["tier"]\
				|| prev["tier"] == current["tier"] && prev["caste_type"] > current["caste_type"]\
			))
				sorted_list.Swap(j-1, j)

			j--

	return sorted_list

// Returns a list with some more info about all xenos in the hive
/datum/hive_status/proc/get_xeno_info()
	var/list/xenos = list()

	for(var/mob/living/carbon/xenomorph/X in totalXenos)
		if(should_block_game_interaction(X))
			var/area/A = get_area(X)
			if(!(A.flags_atom & AREA_ALLOW_XENO_JOIN))
				continue

		var/xeno_name = X.name
		// goddamn fucking larvas with their weird ass maturing system
		// its name updates with its icon, unlike other castes which only update the mature/elder, etc. prefix on evolve
		if(istype(X, /mob/living/carbon/xenomorph/larva))
			xeno_name = "Larva ([X.nicknumber])"
		xenos["[X.nicknumber]"] = list(
			"name" = xeno_name,
			"strain" = X.get_strain_name(),
			"ref" = "\ref[X]"
		)

	return xenos

/datum/hive_status/proc/set_hive_location(obj/effect/alien/resin/special/pylon/core/C)
	if(!C || C == hive_location)
		return
	var/area/A = get_area(C)
	xeno_message(SPAN_XENOANNOUNCE("The Queen has set the hive location as \the [A]."), 3, hivenumber)
	hive_location = C
	hive_ui.update_hive_location()

// Returns a list of xeno healths and locations
/datum/hive_status/proc/get_xeno_vitals()
	var/list/xenos = list()

	for(var/mob/living/carbon/xenomorph/X in totalXenos)
		if(should_block_game_interaction(X))
			var/area/A = get_area(X)
			if(!(A.flags_atom & AREA_ALLOW_XENO_JOIN))
				continue

		if(!(X in GLOB.living_xeno_list))
			continue

		var/area/A = get_area(X)
		var/area_name = "Unknown"
		if(A)
			area_name = A.name

		xenos["[X.nicknumber]"] = list(
			"health" = round((X.health / X.maxHealth) * 100, 1),
			"area" = area_name,
			"is_ssd" = (!X.client)
		)

	return xenos

#define TIER_3 "3"
#define TIER_2 "2"
#define OPEN_SLOTS "open_slots"
#define GUARANTEED_SLOTS "guaranteed_slots"

// Returns an assoc list of open slots and guaranteed slots left
/datum/hive_status/proc/get_tier_slots()
	var/list/slots = list(
		TIER_3 = list(
			OPEN_SLOTS = 0,
			GUARANTEED_SLOTS = list(),
		),
		TIER_2 = list(
			OPEN_SLOTS = 0,
			GUARANTEED_SLOTS = list(),
		),
	)

	var/used_tier_2_slots = length(tier_2_xenos)
	var/used_tier_3_slots = length(tier_3_xenos)

	for(var/caste_path in free_slots)
		var/slots_free = free_slots[caste_path]
		var/slots_used = used_slots[caste_path]
		var/datum/caste_datum/current_caste = caste_path
		if(slots_used)
			// Don't count any free slots in use
			switch(initial(current_caste.tier))
				if(2)
					used_tier_2_slots -= min(slots_used, slots_free)
				if(3)
					used_tier_3_slots -= min(slots_used, slots_free)
		if(slots_free <= slots_used)
			continue
		// Display any free slots available
		switch(initial(current_caste.tier))
			if(2)
				slots[TIER_2][GUARANTEED_SLOTS][initial(current_caste.caste_type)] = slots_free - slots_used
			if(3)
				slots[TIER_3][GUARANTEED_SLOTS][initial(current_caste.caste_type)] = slots_free - slots_used

	var/burrowed_factor = min(stored_larva, sqrt(4*stored_larva))
	var/effective_total = round(burrowed_factor)
	for(var/mob/living/carbon/xenomorph/xeno as anything in totalXenos)
		if(xeno.counts_for_slots)
			effective_total++

	// Tier 3 slots are always 20% of the total xenos in the hive
	slots[TIER_3][OPEN_SLOTS] = max(0, Ceiling(0.20*effective_total/tier_slot_multiplier) - used_tier_3_slots)
	// Tier 2 slots are between 30% and 50% of the hive, depending
	// on how many T3s there are.
	slots[TIER_2][OPEN_SLOTS] = max(0, Ceiling(0.5*effective_total/tier_slot_multiplier) - used_tier_2_slots - used_tier_3_slots)

	return slots

#undef TIER_3
#undef TIER_2
#undef OPEN_SLOTS
#undef GUARANTEED_SLOTS

/datum/hive_status/proc/can_build_structure(structure_name)
	if(!structure_name || !hive_structures_limit[structure_name])
		return FALSE
	if(get_structure_count(structure_name) >= hive_structures_limit[structure_name])
		return FALSE
	return TRUE

/datum/hive_status/proc/get_structure_count(structure_name)
	return length(hive_structures[structure_name]) + length(hive_constructions[structure_name])

/datum/hive_status/proc/has_structure(structure_name)
	if(!structure_name)
		return FALSE
	if(hive_structures[structure_name] && hive_structures[structure_name].len)
		return TRUE
	return FALSE

/datum/hive_status/proc/add_construction(obj/effect/alien/resin/construction/S)
	if(!S || !S.template)
		return FALSE
	var/name_ref = initial(S.template.name)
	if(!hive_constructions[name_ref])
		hive_constructions[name_ref] = list()
	if(hive_constructions[name_ref].len >= hive_structures_limit[name_ref])
		return FALSE
	hive_constructions[name_ref] += src
	return TRUE

/datum/hive_status/proc/remove_construction(obj/effect/alien/resin/construction/S)
	if(!S || !S.template)
		return FALSE
	var/name_ref = initial(S.template.name)
	hive_constructions[name_ref] -= src
	return TRUE

/datum/hive_status/proc/add_special_structure(obj/effect/alien/resin/special/S)
	if(!S)
		return FALSE
	var/name_ref = initial(S.name)
	if(!hive_structures[name_ref])
		hive_structures[name_ref] = list()
	if(hive_structures[name_ref].len >= hive_structures_limit[name_ref])
		return FALSE
	hive_structures[name_ref] += S
	return TRUE

/datum/hive_status/proc/remove_special_structure(obj/effect/alien/resin/special/S)
	if(!S)
		return FALSE
	var/name_ref = initial(S.name)
	hive_structures[name_ref] -= S
	return TRUE

/datum/hive_status/proc/has_special_structure(name_ref)
	if(!name_ref || !hive_structures[name_ref] || !hive_structures[name_ref].len)
		return 0
	return hive_structures[name_ref].len

/datum/hive_status/proc/abandon_on_hijack()
	var/area/hijacked_dropship = get_area(living_xeno_queen)
	var/shipside_humans_weighted_count = 0
	var/xenos_count = 0
	for(var/name_ref in hive_structures)
		for(var/obj/effect/alien/resin/special/S in hive_structures[name_ref])
			if(get_area(S) == hijacked_dropship)
				continue
			S.hijack_delete = TRUE
			hive_structures[name_ref] -= S
			qdel(S)
	for(var/mob/living/carbon/xenomorph/xeno as anything in totalXenos)
		if(get_area(xeno) != hijacked_dropship && xeno.loc && is_ground_level(xeno.loc.z))
			if(isfacehugger(xeno) || islesserdrone(xeno))
				to_chat(xeno, SPAN_XENOANNOUNCE("The Queen has left without you, you quickly find a hiding place to enter hibernation as you lose touch with the hive mind."))
				if(xeno.stomach_contents.len)
					xeno.devour_timer = 0
					xeno.handle_stomach_contents()
				qdel(xeno)
				continue
			if(xeno.hunter_data.hunted && !isqueen(xeno))
				to_chat(xeno, SPAN_XENOANNOUNCE("The Queen has left without you, seperating you from her hive! You must defend yourself from the headhunter before you can enter hibernation..."))
				xeno.set_hive_and_update(XENO_HIVE_FORSAKEN)
			else
				to_chat(xeno, SPAN_XENOANNOUNCE("The Queen has left without you, you quickly find a hiding place to enter hibernation as you lose touch with the hive mind."))
				if(xeno.stomach_contents.len)
					xeno.devour_timer = 0
					xeno.handle_stomach_contents()
				qdel(xeno)
			stored_larva++
			continue
		if(xeno.tier >= 1)
			xenos_count++
	for(var/i in GLOB.alive_mob_list)
		var/mob/living/potential_host = i
		if(!(potential_host.status_flags & XENO_HOST))
			continue
		if(!is_ground_level(potential_host.z) || get_area(potential_host) == hijacked_dropship)
			continue
		var/obj/item/alien_embryo/A = locate() in potential_host
		if(A && A.hivenumber != hivenumber)
			continue
		for(var/obj/item/alien_embryo/embryo in potential_host)
			embryo.hivenumber = XENO_HIVE_FORSAKEN
		potential_host.update_med_icon()
	for(var/mob/living/carbon/human/current_human as anything in GLOB.alive_human_list)
		if(!(isspecieshuman(current_human) || isspeciessynth(current_human)))
			continue
		var/datum/job/job = GLOB.RoleAuthority.roles_for_mode[current_human.job]
		if(!job)
			continue
		var/turf/turf = get_turf(current_human)
		if(is_mainship_level(turf?.z))
			shipside_humans_weighted_count += GLOB.RoleAuthority.calculate_role_weight(job)
	hijack_burrowed_surge = TRUE
	hijack_burrowed_left = max(Ceiling(shipside_humans_weighted_count * 0.5) - xenos_count, 5)
	hivecore_cooldown = FALSE
	xeno_message(SPAN_XENOBOLDNOTICE("The weeds have recovered! A new hive core can be built!"),3,hivenumber)

/datum/hive_status/proc/free_respawn(client/C)
	stored_larva++
	if(!hive_location || !hive_location.spawn_burrowed_larva(C.mob))
		stored_larva--
	else
		hive_ui.update_burrowed_larva()

/datum/hive_status/proc/respawn_on_turf(client/xeno_client, turf/spawning_turf)
	var/mob/living/carbon/xenomorph/larva/new_xeno = spawn_hivenumber_larva(spawning_turf, hivenumber)
	if(isnull(new_xeno))
		return FALSE

	if(!SSticker.mode.transfer_xeno(xeno_client.mob, new_xeno))
		qdel(new_xeno)
		return FALSE

	new_xeno.visible_message(SPAN_XENODANGER("A larva suddenly emerges from a dead husk!"),
	SPAN_XENOANNOUNCE("The hive has no core! You manage to emerge from your old husk as a larva!"))
	msg_admin_niche("[key_name(new_xeno)] respawned at \a [spawning_turf]. [ADMIN_JMP(spawning_turf)]")
	playsound(new_xeno, 'sound/effects/xeno_newlarva.ogg', 50, 1)
	if(new_xeno.client?.prefs?.toggles_flashing & FLASH_POOLSPAWN)
		window_flash(new_xeno.client)

	hive_ui.update_burrowed_larva()

/datum/hive_status/proc/do_buried_larva_spawn(mob/xeno_candidate)
	var/spawning_area
	if(hive_location)
		spawning_area = hive_location
	else if(living_xeno_queen)
		spawning_area = living_xeno_queen
	else for(var/mob/living/carbon/xenomorpheus as anything in totalXenos)
		if(islarva(xenomorpheus) || isxeno_builder(xenomorpheus)) //next to xenos that should be in a safe spot
			spawning_area = xenomorpheus
	if(!spawning_area)
		spawning_area = pick(totalXenos) // FUCK IT JUST GO ANYWHERE
	var/list/turf_list
	for(var/turf/open/open_turf in orange(3, spawning_area))
		if(istype(open_turf, /turf/open/space))
			continue
		LAZYADD(turf_list, open_turf)
	// just on the off-chance
	if(!LAZYLEN(turf_list))
		return FALSE
	var/turf/open/spawning_turf = pick(turf_list)

	var/mob/living/carbon/xenomorph/larva/new_xeno = spawn_hivenumber_larva(spawning_turf, hivenumber)
	if(isnull(new_xeno))
		return FALSE

	if(!SSticker.mode.transfer_xeno(xeno_candidate, new_xeno))
		qdel(new_xeno)
		return FALSE
	new_xeno.visible_message(SPAN_XENODANGER("A larva suddenly burrows out of \the [spawning_turf]!"),
	SPAN_XENODANGER("You burrow out of \the [spawning_turf] and awaken from your slumber. For the Hive!"))
	msg_admin_niche("[key_name(new_xeno)] burrowed out from \a [spawning_turf]. [ADMIN_JMP(spawning_turf)]")
	playsound(new_xeno, 'sound/effects/xeno_newlarva.ogg', 50, 1)
	to_chat(new_xeno, SPAN_XENOANNOUNCE("You are a xenomorph larva awakened from slumber!"))
	if(new_xeno.client)
		if(new_xeno.client?.prefs?.toggles_flashing & FLASH_POOLSPAWN)
			window_flash(new_xeno.client)

	stored_larva--
	hive_ui.update_burrowed_larva()

/mob/living/proc/ally_of_hivenumber(hivenumber)
	var/datum/hive_status/indexed_hive = GLOB.hive_datum[hivenumber]
	if(!indexed_hive)
		return FALSE

	return indexed_hive.is_ally(src)

/datum/hive_status/proc/is_ally(mob/living/living_mob)
	if(isxeno(living_mob))
		var/mob/living/carbon/xenomorph/zenomorf = living_mob
		if(zenomorf.hivenumber == hivenumber)
			return !zenomorf.banished

	if(!living_mob.faction)
		return FALSE

	return faction_is_ally(living_mob.faction)

/datum/hive_status/proc/faction_is_ally(faction, ignore_queen_check = FALSE)
	if(faction == internal_faction)
		return TRUE
	if(!ignore_queen_check && !living_xeno_queen)
		return FALSE

	return allies[faction]

/datum/hive_status/proc/can_delay_round_end(mob/living/carbon/xenomorph/xeno)
	if(HAS_TRAIT(src, TRAIT_NO_HIVE_DELAY))
		return FALSE
	return TRUE

/datum/hive_status/proc/update_hugger_limit()
	var/countable_xeno_iterator = 0
	for(var/mob/living/carbon/xenomorph/cycled_xeno as anything in totalXenos)
		if(cycled_xeno.counts_for_slots)
			countable_xeno_iterator++

	playable_hugger_limit = max(Floor(countable_xeno_iterator / playable_hugger_max_divisor), playable_hugger_minimum)

/datum/hive_status/proc/can_spawn_as_hugger(mob/dead/observer/user)
	if(!GLOB.hive_datum || ! GLOB.hive_datum[hivenumber])
		return FALSE
	if(jobban_isbanned(user, JOB_XENOMORPH)) // User is jobbanned
		to_chat(user, SPAN_WARNING("You are banned from playing aliens and cannot spawn as a xenomorph."))
		return FALSE
	if(world.time < hugger_timelock)
		to_chat(user, SPAN_WARNING("The hive cannot support facehuggers yet..."))
		return FALSE
	if(world.time - user.timeofdeath < JOIN_AS_FACEHUGGER_DELAY)
		var/time_left = round((user.timeofdeath + JOIN_AS_FACEHUGGER_DELAY - world.time) / 10)
		to_chat(user, SPAN_WARNING("You ghosted too recently. You cannot become a facehugger until 3 minutes have passed ([time_left] seconds remaining)."))
		return FALSE
	if(totalXenos.len <= 0)
		//This is to prevent people from joining as Forsaken Huggers on the pred ship
		to_chat(user, SPAN_WARNING("The hive has fallen, you can't join it!"))
		return FALSE
	for(var/mob_name in banished_ckeys)
		if(banished_ckeys[mob_name] == user.ckey)
			to_chat(user, SPAN_WARNING("You are banished from the [name], you may not rejoin unless the Queen re-admits you or dies."))
			return FALSE

	update_hugger_limit()

	var/current_hugger_count = 0
	for(var/mob/mob as anything in totalXenos)
		if(isfacehugger(mob))
			current_hugger_count++
	if(playable_hugger_limit <= current_hugger_count)
		to_chat(user, SPAN_WARNING("\The [GLOB.hive_datum[hivenumber]] cannot support more facehuggers! Limit: <b>[current_hugger_count]/[playable_hugger_limit]</b>"))
		return FALSE

	if(tgui_alert(user, "Are you sure you want to become a facehugger?", "Confirmation", list("Yes", "No")) != "Yes")
		return FALSE

	if(!user.client)
		return FALSE

	return TRUE

/datum/hive_status/proc/spawn_as_hugger(mob/dead/observer/user, atom/A)
	var/mob/living/carbon/xenomorph/facehugger/hugger = new /mob/living/carbon/xenomorph/facehugger(A.loc, null, hivenumber)
	user.mind.transfer_to(hugger, TRUE)
	hugger.visible_message(SPAN_XENODANGER("A facehugger suddenly emerges out of \the [A]!"), SPAN_XENODANGER("You emerge out of \the [A] and awaken from your slumber. For the Hive!"))
	playsound(hugger, 'sound/effects/xeno_newlarva.ogg', 25, TRUE)
	hugger.generate_name()
	hugger.timeofdeath = user.timeofdeath // Keep old death time

/datum/hive_status/proc/update_lesser_drone_limit()
	var/countable_xeno_iterator = 0
	for(var/mob/living/carbon/xenomorph/cycled_xeno as anything in totalXenos)
		if(cycled_xeno.counts_for_slots)
			countable_xeno_iterator++

	lesser_drone_limit = max(Floor(countable_xeno_iterator / playable_lesser_drones_max_divisor), lesser_drone_minimum)

/datum/hive_status/proc/can_spawn_as_lesser_drone(mob/dead/observer/user, obj/effect/alien/resin/special/pylon/spawning_pylon)
	if(!GLOB.hive_datum || ! GLOB.hive_datum[hivenumber])
		return FALSE

	if(jobban_isbanned(user, JOB_XENOMORPH)) // User is jobbanned
		to_chat(user, SPAN_WARNING("You are banned from playing aliens and cannot spawn as a xenomorph."))
		return FALSE

	if(world.time - user.timeofdeath < JOIN_AS_LESSER_DRONE_DELAY)
		var/time_left = round((user.timeofdeath + JOIN_AS_LESSER_DRONE_DELAY - world.time) / 10)
		to_chat(user, SPAN_WARNING("You ghosted too recently. You cannot become a lesser drone until 30 seconds have passed ([time_left] seconds remaining)."))
		return FALSE

	if(totalXenos.len <= 0)
		to_chat(user, SPAN_WARNING("The hive has fallen, you can't join it!"))
		return FALSE

	if(!living_xeno_queen)
		to_chat(user, SPAN_WARNING("The selected hive does not have a Queen!"))
		return FALSE

	if(spawning_pylon.lesser_drone_spawns < 1)
		to_chat(user, SPAN_WARNING("The selected core or pylon does not have enough power for a lesser drone!"))
		return FALSE

	update_lesser_drone_limit()

	var/current_lesser_drone_count = 0
	for(var/mob/mob as anything in totalXenos)
		if(islesserdrone(mob))
			current_lesser_drone_count++

	if(lesser_drone_limit <= current_lesser_drone_count)
		to_chat(user, SPAN_WARNING("[GLOB.hive_datum[hivenumber]] cannot support more lesser drones! Limit: <b>[current_lesser_drone_count]/[lesser_drone_limit]</b>"))
		return FALSE

	if(!user.client)
		return FALSE

	return TRUE

// Get amount of real xenos, don't count lessers/huggers
/datum/hive_status/proc/get_real_total_xeno_count()
	var/count = 0
	for(var/mob/living/carbon/xenomorph/xeno as anything in totalXenos)
		if(xeno.counts_for_slots)
			count++
	return count

// Checks if we hit larva limit
/datum/hive_status/proc/check_if_hit_larva_from_pylon_limit()
	var/groundside_humans_weighted_count = 0
	for(var/mob/living/carbon/human/current_human as anything in GLOB.alive_human_list)
		if(!(isspecieshuman(current_human) || isspeciessynth(current_human)))
			continue
		var/datum/job/job = GLOB.RoleAuthority.roles_for_mode[current_human.job]
		if(!job)
			continue
		var/turf/turf = get_turf(current_human)
		if(is_ground_level(turf?.z))
			groundside_humans_weighted_count += GLOB.RoleAuthority.calculate_role_weight(job)
	hit_larva_pylon_limit = (get_real_total_xeno_count() + stored_larva) > (groundside_humans_weighted_count * ENDGAME_LARVA_CAP_MULTIPLIER)
	hive_ui.update_pylon_status()
	return hit_larva_pylon_limit

///Called by /obj/item/alien_embryo when a host is bursting to determine extra larva per burst
/datum/hive_status/proc/increase_larva_after_burst()
	var/extra_per_burst = CONFIG_GET(number/extra_larva_per_burst)
	partial_larva += extra_per_burst
	convert_partial_larva_to_full_larva()

///Called after times when partial larva are added to process them to stored larva
/datum/hive_status/proc/convert_partial_larva_to_full_larva()
	for(var/i = 1 to partial_larva)
		partial_larva--
		stored_larva++

/datum/hive_status/corrupted
	name = "Corrupted Hive"
	reporting_id = "corrupted"
	hivenumber = XENO_HIVE_CORRUPTED
	prefix = "Corrupted "
	color = "#80ff80"
	ui_color ="#4d994d"
	latejoin_burrowed = FALSE

	need_round_end_check = TRUE

	var/list/defectors = list()

/datum/hive_status/corrupted/add_xeno(mob/living/carbon/xenomorph/xeno)
	. = ..()
	xeno.add_language(LANGUAGE_ENGLISH)

/datum/hive_status/corrupted/remove_xeno(mob/living/carbon/xenomorph/xeno, hard)
	. = ..()
	xeno.remove_language(LANGUAGE_ENGLISH)

/datum/hive_status/corrupted/can_delay_round_end(mob/living/carbon/xenomorph/xeno)
	if(!faction_is_ally(FACTION_MARINE, TRUE))
		return TRUE
	return FALSE

/datum/hive_status/alpha
	name = "Alpha Hive"
	reporting_id = "alpha"
	hivenumber = XENO_HIVE_ALPHA
	prefix = "Alpha "
	color = "#ff4040"
	ui_color = "#992626"
	latejoin_burrowed = FALSE

	dynamic_evolution = FALSE

/datum/hive_status/bravo
	name = "Bravo Hive"
	reporting_id = "bravo"
	hivenumber = XENO_HIVE_BRAVO
	prefix = "Bravo "
	color = "#ffff80"
	ui_color = "#99994d"
	latejoin_burrowed = FALSE

	dynamic_evolution = FALSE

/datum/hive_status/charlie
	name = "Charlie Hive"
	reporting_id = "charlie"
	hivenumber = XENO_HIVE_CHARLIE
	prefix = "Charlie "
	color = "#bb40ff"
	ui_color = "#702699"
	latejoin_burrowed = FALSE

	dynamic_evolution = FALSE

/datum/hive_status/delta
	name = "Delta Hive"
	reporting_id = "delta"
	hivenumber = XENO_HIVE_DELTA
	prefix = "Delta "
	color = "#8080ff"
	ui_color = "#4d4d99"
	latejoin_burrowed = FALSE

	dynamic_evolution = FALSE

/datum/hive_status/feral
	name = "Feral Hive"
	reporting_id = "feral"
	hivenumber = XENO_HIVE_FERAL
	prefix = "Feral "
	color = "#828296"
	ui_color = "#828296"

	construction_allowed = XENO_NOBODY
	destruction_allowed = XENO_NOBODY
	dynamic_evolution = FALSE
	allow_no_queen_actions = TRUE
	allow_no_queen_evo = TRUE
	allow_queen_evolve = FALSE
	latejoin_burrowed = FALSE

/datum/hive_status/forsaken
	name = "Forsaken Hive"
	reporting_id = "forsaken"
	hivenumber = XENO_HIVE_FORSAKEN
	prefix = "Forsaken "
	color = "#cc8ec4"
	ui_color = "#cc8ec4"

	dynamic_evolution = FALSE
	allow_no_queen_actions = TRUE
	allow_no_queen_evo = TRUE
	allow_queen_evolve = FALSE
	latejoin_burrowed = FALSE

	need_round_end_check = TRUE

/datum/hive_status/forsaken/can_delay_round_end(mob/living/carbon/xenomorph/xeno)
	return FALSE

/datum/hive_status/tutorial
	name = "Tutorial Hive"
	reporting_id = "tutorial"
	hivenumber = XENO_HIVE_TUTORIAL
	prefix = "Inquisitive "
	latejoin_burrowed = FALSE

	dynamic_evolution = FALSE
	allow_queen_evolve = TRUE
	evolution_without_ovipositor = FALSE
	allow_no_queen_actions = TRUE

	///Can have many tutorials going at once.
	hive_structures_limit = list(
		XENO_STRUCTURE_CORE = 999,
		XENO_STRUCTURE_CLUSTER = 999,
		XENO_STRUCTURE_EGGMORPH = 999,
		XENO_STRUCTURE_RECOVERY = 999,
	)

/datum/hive_status/tutorial/can_delay_round_end(mob/living/carbon/xenomorph/xeno)
	return FALSE

/datum/hive_status/yautja
	name = "Hellhound Pack"
	reporting_id = "hellhounds"
	hivenumber = XENO_HIVE_YAUTJA
	internal_faction = FACTION_YAUTJA

	dynamic_evolution = FALSE
	allow_no_queen_actions = TRUE
	allow_no_queen_evo = TRUE
	allow_queen_evolve = FALSE
	latejoin_burrowed = FALSE

	need_round_end_check = TRUE

/datum/hive_status/yautja/can_delay_round_end(mob/living/carbon/xenomorph/xeno)
	return FALSE

/datum/hive_status/mutated
	name = "Mutated Hive"
	reporting_id = "mutated"
	hivenumber = XENO_HIVE_MUTATED
	prefix = "Mutated "
	color = "#6abd99"
	ui_color = "#6abd99"

	hive_inherant_traits = list(TRAIT_XENONID, TRAIT_NO_COLOR)
	latejoin_burrowed = FALSE

/datum/hive_status/corrupted/tamed
	name = "Tamed Hive"
	reporting_id = "tamed"
	hivenumber = XENO_HIVE_TAMED
	prefix = "Tamed "
	color = "#80ff80"

	dynamic_evolution = FALSE
	allow_no_queen_actions = TRUE
	allow_no_queen_evo = TRUE
	allow_queen_evolve = FALSE
	latejoin_burrowed = FALSE

	var/mob/living/carbon/human/leader
	var/list/allied_factions

/datum/hive_status/corrupted/tamed/New()
	. = ..()
	hive_structures_limit[XENO_STRUCTURE_EGGMORPH] = 0

/datum/hive_status/corrupted/tamed/proc/make_leader(mob/living/carbon/human/H)
	if(!istype(H))
		return

	if(leader)
		UnregisterSignal(leader, COMSIG_PARENT_QDELETING)

	leader = H
	RegisterSignal(leader, COMSIG_PARENT_QDELETING, PROC_REF(handle_qdelete))

/datum/hive_status/corrupted/tamed/proc/handle_qdelete(mob/living/carbon/human/H)
	SIGNAL_HANDLER

	if(H == leader)
		leader = null

	var/list/faction_groups = H.faction_group
	if(faction_groups)
		allied_factions = faction_groups.Copy()
		if(!(H.faction in allied_factions))
			allied_factions += H.faction

/datum/hive_status/corrupted/tamed/add_xeno(mob/living/carbon/xenomorph/X)
	. = ..()
	X.faction_group = allied_factions

/datum/hive_status/corrupted/tamed/remove_xeno(mob/living/carbon/xenomorph/X, hard)
	. = ..()
	X.faction_group = list(X.faction)

/datum/hive_status/corrupted/tamed/is_ally(mob/living/carbon/C)
	if(leader)
		if(C.faction in leader.faction_group)
			return TRUE

		if(C.faction == leader.faction)
			return TRUE
	else
		if(C.faction in allied_factions)
			return TRUE

	return ..()

/datum/hive_status/corrupted/renegade
	name = "Renegade Hive"
	reporting_id = "renegade"
	hivenumber = XENO_HIVE_RENEGADE
	prefix = "Renegade "
	color = "#9c7a4d"
	ui_color ="#80705c"

	dynamic_evolution = FALSE
	allow_queen_evolve = FALSE
	allow_no_queen_evo = TRUE
	latejoin_burrowed = FALSE

/datum/hive_status/corrupted/renegade/New()
	. = ..()
	hive_structures_limit[XENO_STRUCTURE_EGGMORPH] = 0
	for(var/faction in FACTION_LIST_HUMANOID) //renegades allied to all humanoids, but it mostly affects structures. Their ability to attack humanoids and other xenos (including of the same hive) depends on iff settings
		allies[faction] = TRUE

/datum/hive_status/corrupted/renegade/can_spawn_as_hugger(mob/dead/observer/user)
	to_chat(user, SPAN_WARNING("The [name] cannot support facehuggers."))
	return FALSE

/datum/hive_status/corrupted/renegade/proc/iff_protection_check(mob/living/carbon/xenomorph/xeno, mob/living/carbon/attempt_harm_mob)
	if(xeno == attempt_harm_mob)
		return TRUE //you cannot hurt yourself...
	if(!xeno.iff_tag)
		return FALSE //can attack anyone if you don't have iff tag
	if(isxeno(attempt_harm_mob))
		var/mob/living/carbon/xenomorph/target_xeno = attempt_harm_mob
		if(!target_xeno.iff_tag)
			return FALSE //can attack any xeno who don't have iff tag
		for(var/faction in xeno.iff_tag.faction_groups)
			if(faction in target_xeno.iff_tag.faction_groups)
				return TRUE //cannot attack xenos with same iff setting
		return FALSE
	for(var/faction in xeno.iff_tag.faction_groups)
		if(faction in attempt_harm_mob.faction_group)
			return TRUE //cannot attack mob if iff is set to at least one of its factions
	return FALSE

/datum/hive_status/corrupted/renegade/faction_is_ally(faction, ignore_queen_check = TRUE)
	return ..()

/datum/hive_status/proc/on_queen_death() //break alliances on queen's death
	if(allow_no_queen_actions || living_xeno_queen)
		return
	var/broken_alliances = FALSE
	for(var/faction in allies)
		if(!allies[faction])
			continue
		change_stance(faction, FALSE)
		broken_alliances = TRUE


	if(broken_alliances)
		xeno_message(SPAN_XENOANNOUNCE("With the death of the Queen, all alliances have been broken."), 3, hivenumber)

/datum/hive_status/proc/change_stance(faction, should_ally)
	if(faction == name)
		return
	if(allies[faction] == should_ally)
		return
	allies[faction] = should_ally

	if(living_xeno_queen)
		if(allies[faction])
			xeno_message(SPAN_XENOANNOUNCE("Your Queen set up an alliance with [faction]!"), 3, hivenumber)
		else
			xeno_message(SPAN_XENOANNOUNCE("Your Queen broke the alliance with [faction]!"), 3, hivenumber)

	for(var/number in GLOB.hive_datum)
		var/datum/hive_status/target_hive = GLOB.hive_datum[number]
		if(target_hive.name != faction)
			continue
		if(!target_hive.living_xeno_queen && !target_hive.allow_no_queen_actions)
			return
		if(allies[faction])
			xeno_message(SPAN_XENOANNOUNCE("We sense that [name] [living_xeno_queen ? "Queen " : ""]set up an alliance with us!"), 3, target_hive.hivenumber)
			return

		xeno_message(SPAN_XENOANNOUNCE("We sense that [name] [living_xeno_queen ? "Queen " : ""]broke the alliance with us!"), 3, target_hive.hivenumber)
		if(target_hive.allies[name]) //autobreak alliance on betrayal
			target_hive.change_stance(name, FALSE)

/datum/hive_status/corrupted/change_stance(faction, should_ally)
	. = ..()
	if(allies[faction])
		return
	if(!(faction in FACTION_LIST_HUMANOID))
		return

	for(var/mob/living/carbon/xenomorph/xeno in totalXenos) // handle defecting xenos on betrayal
		if(!xeno.iff_tag)
			continue
		if(!(faction in xeno.iff_tag.faction_groups))
			continue
		if(xeno in defectors)
			continue
		if(xeno.caste_type == XENO_CASTE_QUEEN)
			continue
		INVOKE_ASYNC(src, PROC_REF(give_defection_choice), xeno, faction)
	addtimer(CALLBACK(src, PROC_REF(handle_defectors), faction), 11 SECONDS)

/datum/hive_status/corrupted/proc/give_defection_choice(mob/living/carbon/xenomorph/xeno, faction)
	if(tgui_alert(xeno, "Your Queen has broken the alliance with the [faction]. The device inside your carapace begins to suppress your connection with the Hive. Do you remove it and stay loyal to her?", "Alliance broken!", list("Stay loyal", "Obey the talls"), 10 SECONDS) == "Obey the talls")
		if(!xeno.iff_tag)
			to_chat(xeno, SPAN_XENOWARNING("It's too late now. The device is gone and our service to the Queen continues."))
			return
		defectors += xeno
		xeno.set_hive_and_update(XENO_HIVE_RENEGADE)
		to_chat(xeno, SPAN_XENOANNOUNCE("You lost the connection with your Hive. Now you have no Queen, only your masters."))
		to_chat(xeno, SPAN_NOTICE("Our instincts have changed, we seem compelled to protect [english_list(xeno.iff_tag.faction_groups, "no one")]."))
		return
	xeno.visible_message(SPAN_XENOWARNING("[xeno] rips out [xeno.iff_tag]!"), SPAN_XENOWARNING("We rip out [xeno.iff_tag]! For the Hive!"))
	xeno.adjustBruteLoss(50)
	xeno.iff_tag.forceMove(get_turf(xeno))
	xeno.iff_tag = null

/datum/hive_status/corrupted/proc/handle_defectors(faction)
	for(var/mob/living/carbon/xenomorph/xeno in totalXenos)
		if(!xeno.iff_tag)
			continue
		if(xeno in defectors)
			continue
		if(!(faction in xeno.iff_tag.faction_groups))
			continue
		xeno.visible_message(SPAN_XENOWARNING("[xeno] rips out [xeno.iff_tag]!"), SPAN_XENOWARNING("You rip out [xeno.iff_tag]! For the hive!"))
		xeno.adjustBruteLoss(50)
		xeno.iff_tag.forceMove(get_turf(xeno))
		xeno.iff_tag = null
	if(!length(defectors))
		return

	xeno_message(SPAN_XENOANNOUNCE("You sense that [english_list(defectors)] turned their backs against their sisters and the Queen in favor of their slavemasters!"), 3, hivenumber)
	defectors.Cut()

/datum/hive_status/proc/override_evilution(evil, override)
	if(SSxevolution)
		SSxevolution.override_power(hivenumber, evil, override)

//Xeno Resin Mark Shit, the very best place for it too :0)
//Defines at the bottom of this list here will show up at the top in the mark menu
/datum/xeno_mark_define
	var/name = "xeno_declare"
	var/icon_state = "empty"
	var/desc = "Xenos make psychic markers with this meaning as positional lasting communication to eachother"

/datum/xeno_mark_define/fortify
	name = "Fortify"
	desc = "Fortify this area!"
	icon_state = "fortify"

/datum/xeno_mark_define/weeds
	name = "Need Weeds"
	desc = "Need weeds here!"
	icon_state = "weed"

/datum/xeno_mark_define/nest
	name = "Nest"
	desc = "Nest enemies here!"
	icon_state = "nest"

/datum/xeno_mark_define/hosts
	name = "Hosts"
	desc = "Hosts here!"
	icon_state = "hosts"

/datum/xeno_mark_define/aide
	name = "Aide"
	desc = "Aide here!"
	icon_state = "aide"

/datum/xeno_mark_define/defend
	name = "Defend"
	desc = "Defend the hive here!"
	icon_state = "defend"

/datum/xeno_mark_define/danger
	name = "Danger Warning"
	desc = "Caution, danger here!"
	icon_state = "danger"

/datum/xeno_mark_define/rally
	name = "Rally"
	desc = "Group up here!"
	icon_state = "rally"

/datum/xeno_mark_define/hold
	name = "Hold"
	desc = "Hold this area!"
	icon_state = "hold"

/datum/xeno_mark_define/ambush
	name = "Ambush"
	desc = "Ambush the enemy here!"
	icon_state = "ambush"
/datum/xeno_mark_define/attack
	name = "Attack"
	desc = "Attack the enemy here!"
	icon_state = "attack"
