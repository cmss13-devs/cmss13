/datum/faction_module
	var/module_code_identificator

	var/datum/faction/faction_owner

/datum/faction_module/New(datum/faction/faction_ref)
	faction_owner = faction_ref

/datum/faction_module/proc/add_mob(mob/living/carbon/creature)
	return

/datum/faction_module/proc/remove_mob(mob/living/carbon/creature, hard = FALSE, light_mode = FALSE)
	return



#define HIVE_STARTING_BUFFPOINTS 0
#define HIVE_MAX_BUFFPOINTS 10

/datum/faction_module/hive_mind
	module_code_identificator = FACTION_MODULE_HIVE_MIND

	var/mob/living/carbon/xenomorph/queen/living_xeno_queen
	var/egg_planting_range = 15
	var/slashing_allowed = XENO_SLASH_ALLOWED //This initial var allows the queen to turn on or off slashing. Slashing off means harm intent does much less damage.
	var/construction_allowed = NORMAL_XENO //Who can place construction nodes for special structures
	var/destruction_allowed = NORMAL_XENO //Who can destroy special structures
	var/unnesting_allowed = TRUE
	var/queen_leader_limit = 2
	var/list/open_xeno_leader_positions = list(1, 2) // Ordered list of xeno leader positions (indexes in xeno_leader_list) that are not occupied
	var/list/xeno_leader_list[2] // Ordered list (i.e. index n holds the nth xeno leader)
	var/stored_larva = 0

	///used by /datum/faction_module/hive_mind/proc/increase_larva_after_burst() to support non-integer increases to larva
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
	/// list of previously living xenos (hardrefs currently)
	var/list/total_dead_xenos = list()
	var/xeno_queen_timer
	var/isSlotOpen = TRUE //Set true for starting alerts only after the hive has reached its full potential
	var/allowed_nest_distance = 15 //How far away do we allow nests from an ovied Queen. Default 15 tiles.
	var/obj/effect/alien/resin/special/pylon/core/hive_location = null //Set to ref every time a core is built, for defining the hive location

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

	var/list/tunnels = list()

	var/list/resin_marks = list()

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


	/// Hive buffs
	var/buff_points = HIVE_STARTING_BUFFPOINTS
	var/max_buff_points = HIVE_MAX_BUFFPOINTS

	/// List of references to the currently active hivebuffs
	var/list/active_hivebuffs
	/// List of references to used hivebuffs
	var/list/used_hivebuffs
	/// List of references to used hivebuffs currently on cooldown
	var/list/cooldown_hivebuffs

	/// List of references to hive pylons active in the game world
	var/list/active_endgame_pylons

	/*Stores the image()'s for the xeno evolution radial menu
	To add an image for your caste - add an icon to icons/mob/xenos/radial_xenos.dmi
	Icon size should be 32x32, to make them fit within the radial menu border size your icon 22x22 and leave 10px transparent border.
	The name of the icon should be the same as the XENO_CASTE_ define for that caste eg. #define XENO_CASTE_DRONE "Drone"
	*/
	var/static/list/evolution_menu_images

	/// Has a King hatchery
	var/has_hatchery = FALSE

/*
/datum/faction_module/hive_mind/New()
	hive_ui = new(src)
	mark_ui = new(src)
	faction_ui = new(src)
	minimap_type = faction.minimap_flag
	tacmap = new(src, minimap_type)
	if(!internal_faction)
		internal_faction = name
	for(var/number in 1 to 999)
		available_nicknumbers += number
	LAZYINITLIST(active_hivebuffs)
	LAZYINITLIST(used_hivebuffs)
	LAZYINITLIST(active_endgame_pylons)

	if(hivenumber != FACTION_XENOMORPH_NORMAL)
		return

	if(!evolution_menu_images)
		evolution_menu_images = list()
		generate_evo_menu_images()

	RegisterSignal(SSdcs, COMSIG_GLOB_POST_SETUP, PROC_REF(post_setup))
*/
///Generate the image()'s requried for the evolution radial menu.
/datum/faction_module/hive_mind/proc/generate_evo_menu_images()
	for(var/datum/caste_datum/caste as anything in subtypesof(/datum/caste_datum))
		evolution_menu_images[initial(caste.caste_type)] = image('icons/mob/xenos/radial_xenos.dmi', initial(caste.caste_type))

/datum/faction_module/hive_mind/proc/post_setup()
	SIGNAL_HANDLER

	setup_evolution_announcements()
	setup_pylon_limits()

/datum/faction_module/hive_mind/proc/setup_evolution_announcements()
	for(var/time in GLOB.xeno_evolve_times)
		if(time == "0")
			continue

		addtimer(CALLBACK(src, PROC_REF(announce_evolve_available), GLOB.xeno_evolve_times[time]), text2num(time))

/// Sets up limits on pylons in New() for potential futureproofing with more static comms
/datum/faction_module/hive_mind/proc/setup_pylon_limits()
	hive_structures_limit[XENO_STRUCTURE_PYLON] = length(GLOB.all_static_telecomms_towers) || 2

/datum/faction_module/hive_mind/proc/announce_evolve_available(list/datum/caste_datum/available_castes)

	var/list/castes_available = list()
	for(var/datum/caste_datum/current_caste as anything in available_castes)
		castes_available += initial(current_caste.caste_type)

	var/castes = castes_available.Join(", ")
	xeno_message(SPAN_XENOANNOUNCE("The Hive is now strong enough to support: [castes]"))
	xeno_maptext("The Hive can now support: [castes]", "Hive Strengthening")


// Adds a xeno to this hive
/datum/faction_module/hive_mind/add_mob(mob/living/carbon/creature)
	if(isqueen(creature))
		if(!living_xeno_queen && !should_block_game_interaction(creature)) // Don't consider xenos in admin level
			set_living_xeno_queen(creature)

	if(creature.hud_list)
		creature.hud_update()

	var/area/creature_area = get_area(creature)
	if(!should_block_game_interaction(creature) || (creature_area.flags_atom & AREA_ALLOW_XENO_JOIN))
		var/mob/living/carbon/xenomorph/zenomorph = creature
		if(istype(zenomorph))
			if(zenomorph.tier == 2)
				tier_2_xenos += creature
			else if(zenomorph.tier == 3)
				tier_3_xenos += creature

	// Xenos are a fuckfest of cross-dependencies of different datums that are initialized at different times
	// So don't even bother trying updating UI here without large refactors

// Removes the xeno from the hive
/datum/faction_module/hive_mind/remove_mob(mob/living/carbon/creature, hard = FALSE, light_mode = FALSE)
	// This might be a redundant check now that Queen/Destroy() checks, but doesn't hurt to double check
	if(living_xeno_queen == creature)
		var/mob/living/carbon/xenomorph/queen/next_queen = null
		for(var/mob/living/carbon/xenomorph/queen/queen in faction_owner.total_mobs)
			if(!should_block_game_interaction(queen) && queen != src && !QDELETED(queen))
				next_queen = queen
				break

		set_living_xeno_queen(next_queen) // either null or a queen

	var/mob/living/carbon/xenomorph/zenomorph = creature
	if(istype(zenomorph))
		if(zenomorph.tier == 2)
			tier_2_xenos -= creature
		else if(zenomorph.tier == 3)
			tier_3_xenos -= creature

		// Only handle free slots if the xeno is not in tdome
		if(!should_block_game_interaction(zenomorph))
			var/selected_caste = GLOB.xeno_datum_list[zenomorph.caste_type]?.type
			if(used_slots[selected_caste])
				used_slots[selected_caste]--

		if(!light_mode)
			hive_ui.update_xeno_counts()
			hive_ui.xeno_removed(zenomorph)

/datum/faction_module/hive_mind/proc/set_living_xeno_queen(mob/living/carbon/xenomorph/queen/queen)
	if(!queen)
		SStracking.delete_leader("hive_[faction_owner.code_identificator]")
		SStracking.stop_tracking("hive_[faction_owner.code_identificator]", living_xeno_queen)
		SShive_status.wait = 10 SECONDS
	else
		SStracking.set_leader("hive_[faction_owner.code_identificator]", queen)
		SShive_status.wait = 2 SECONDS

	SEND_SIGNAL(src, COMSIG_HIVE_NEW_QUEEN, queen)
	living_xeno_queen = queen

	recalculate_hive()

/datum/faction_module/hive_mind/proc/recalculate_hive()
	//No leaders for a Hive without a Queen!
	queen_leader_limit = living_xeno_queen ? 4 : 0

	if (length(xeno_leader_list) > queen_leader_limit)
		var/diff = 0
		for (var/i in queen_leader_limit + 1 to length(xeno_leader_list))
			if(!open_xeno_leader_positions.Remove(i))
				remove_hive_leader(xeno_leader_list[i])
			diff++
		xeno_leader_list.len -= diff // Changing the size of xeno_leader_list needs to go at the end or else it won't iterate through the list properly
	else if (length(xeno_leader_list) < queen_leader_limit)
		for (var/i in length(xeno_leader_list) + 1 to queen_leader_limit)
			open_xeno_leader_positions += i
			xeno_leader_list.len++

	hive_ui.update_all_data()

/datum/faction_module/hive_mind/proc/add_hive_leader(mob/living/carbon/xenomorph/xeno)
	if(!xeno)
		return FALSE //How did this even happen?
	if(!length(open_xeno_leader_positions))
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

/datum/faction_module/hive_mind/proc/remove_hive_leader(mob/living/carbon/xenomorph/xeno, light_mode = FALSE)
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
		if (i > length(open_xeno_leader_positions) || open_xeno_leader_positions[i] > leader_num)
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

/datum/faction_module/hive_mind/proc/replace_hive_leader(mob/living/carbon/xenomorph/original, mob/living/carbon/xenomorph/replacement)
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

/datum/faction_module/hive_mind/proc/handle_xeno_leader_pheromones()
	for(var/mob/living/carbon/xenomorph/L in xeno_leader_list)
		L.handle_xeno_leader_pheromones()

/*
 * Helper procs for the Hive Status UI
 * These are all called by the hive status UI manager to update its data
 */

// Returns a list of how many of each caste of xeno there are, sorted by tier
/datum/faction_module/hive_mind/proc/get_xeno_counts()
	// Every caste is manually defined here so you get
	var/list/xeno_counts = list(
		// Yes, Queen is technically considered to be tier 0
		list(XENO_CASTE_LARVA = 0, "Queen" = 0),
		list(XENO_CASTE_DRONE = 0, XENO_CASTE_RUNNER = 0, XENO_CASTE_SENTINEL = 0, XENO_CASTE_DEFENDER = 0),
		list(XENO_CASTE_HIVELORD = 0, XENO_CASTE_BURROWER = 0, XENO_CASTE_CARRIER = 0, XENO_CASTE_LURKER = 0, XENO_CASTE_SPITTER = 0, XENO_CASTE_WARRIOR = 0),
		list(XENO_CASTE_BOILER = 0, XENO_CASTE_CRUSHER = 0, XENO_CASTE_PRAETORIAN = 0, XENO_CASTE_RAVAGER = 0)
	)

	for(var/mob/living/carbon/xenomorph/X in faction_owner.total_mobs)
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
/datum/faction_module/hive_mind/proc/get_xeno_keys()
	var/list/xenos = list()

	for(var/mob/living/carbon/xenomorph/X in faction_owner.total_mobs)
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
/datum/faction_module/hive_mind/proc/sort_xeno_keys(list/xenos)
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
/datum/faction_module/hive_mind/proc/get_xeno_info()
	var/list/xenos = list()

	for(var/mob/living/carbon/xenomorph/X in faction_owner.total_mobs)
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

/datum/faction_module/hive_mind/proc/set_hive_location(obj/effect/alien/resin/special/pylon/core/C)
	if(!C || C == hive_location)
		return
	var/area/A = get_area(C)
	xeno_message(SPAN_XENOANNOUNCE("The Queen has set the hive location as \the [A]."), 3, faction_owner)
	hive_location = C
	hive_ui.update_hive_location()

// Returns a list of xeno healths and locations
/datum/faction_module/hive_mind/proc/get_xeno_vitals()
	var/list/xenos = list()

	for(var/mob/living/carbon/xenomorph/X in faction_owner.total_mobs)
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
/datum/faction_module/hive_mind/proc/get_tier_slots()
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
	var/effective_total = floor(burrowed_factor)
	for(var/mob/living/carbon/xenomorph/xeno in faction_owner.total_mobs)
		if(xeno.counts_for_slots)
			effective_total++

	// Tier 3 slots are always 20% of the total xenos in the hive
	slots[TIER_3][OPEN_SLOTS] = max(0, ceil(0.20*effective_total/tier_slot_multiplier) - used_tier_3_slots)
	// Tier 2 slots are between 30% and 50% of the hive, depending
	// on how many T3s there are.
	slots[TIER_2][OPEN_SLOTS] = max(0, ceil(0.5*effective_total/tier_slot_multiplier) - used_tier_2_slots - used_tier_3_slots)

	return slots

#undef TIER_3
#undef TIER_2
#undef OPEN_SLOTS
#undef GUARANTEED_SLOTS

/datum/faction_module/hive_mind/proc/can_build_structure(structure_name)
	if(!structure_name || !hive_structures_limit[structure_name])
		return FALSE
	if(get_structure_count(structure_name) >= hive_structures_limit[structure_name])
		return FALSE
	return TRUE

/datum/faction_module/hive_mind/proc/get_structure_count(structure_name)
	return length(hive_structures[structure_name]) + length(hive_constructions[structure_name])

/datum/faction_module/hive_mind/proc/has_structure(structure_name)
	if(!structure_name)
		return FALSE
	if(LAZYLEN(hive_structures[structure_name]))
		return TRUE
	return FALSE

/datum/faction_module/hive_mind/proc/add_construction(obj/effect/alien/resin/construction/S)
	if(!S || !S.template)
		return FALSE
	var/name_ref = initial(S.template.name)
	if(!hive_constructions[name_ref])
		hive_constructions[name_ref] = list()
	if(length(hive_constructions[name_ref]) >= hive_structures_limit[name_ref])
		return FALSE
	hive_constructions[name_ref] += src
	return TRUE

/datum/faction_module/hive_mind/proc/remove_construction(obj/effect/alien/resin/construction/S)
	if(!S || !S.template)
		return FALSE
	var/name_ref = initial(S.template.name)
	hive_constructions[name_ref] -= src
	return TRUE

/datum/faction_module/hive_mind/proc/add_special_structure(obj/effect/alien/resin/special/S)
	if(!S)
		return FALSE
	var/name_ref = initial(S.name)
	if(!hive_structures[name_ref])
		hive_structures[name_ref] = list()
	if(length(hive_structures[name_ref]) >= hive_structures_limit[name_ref])
		return FALSE
	hive_structures[name_ref] += S
	return TRUE

/datum/faction_module/hive_mind/proc/remove_special_structure(obj/effect/alien/resin/special/S)
	if(!S)
		return FALSE
	var/name_ref = initial(S.name)
	hive_structures[name_ref] -= S
	return TRUE

/datum/faction_module/hive_mind/proc/has_special_structure(name_ref)
	if(!name_ref || !LAZYLEN(hive_structures[name_ref]))
		return 0
	return length(hive_structures[name_ref])

/datum/faction_module/hive_mind/proc/abandon_on_hijack()
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
	for(var/mob/living/carbon/xenomorph/xeno in faction_owner.total_mobs)
		if(get_area(xeno) != hijacked_dropship && xeno.loc && is_ground_level(xeno.loc.z))
			if(isfacehugger(xeno) || islesserdrone(xeno))
				to_chat(xeno, SPAN_XENOANNOUNCE("The Queen has left without you, you quickly find a hiding place to enter hibernation as you lose touch with the hive mind."))
				if(length(xeno.stomach_contents))
					xeno.devour_timer = 0
					xeno.handle_stomach_contents()
				qdel(xeno)
				continue
			if(xeno.hunter_data.hunted && !isqueen(xeno))
				to_chat(xeno, SPAN_XENOANNOUNCE("The Queen has left without you, seperating you from her hive! You must defend yourself from the headhunter before you can enter hibernation..."))
				xeno.set_hive_and_update(FACTION_XENOMORPH_FORSAKEN)
			else
				to_chat(xeno, SPAN_XENOANNOUNCE("The Queen has left without you, you quickly find a hiding place to enter hibernation as you lose touch with the hive mind."))
				if(length(xeno.stomach_contents))
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
		if(A && A.faction_to_get != faction_owner)
			continue
		for(var/obj/item/alien_embryo/embryo in potential_host)
			embryo.faction_to_get = FACTION_XENOMORPH_FORSAKEN
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
	hijack_burrowed_left = max(ceil(shipside_humans_weighted_count * 0.5) - xenos_count, 5)
	hivecore_cooldown = FALSE
	xeno_message(SPAN_XENOBOLDNOTICE("The weeds have recovered! A new hive core can be built!"), 3, faction_owner)

	// No buffs in hijack
	for(var/datum/hivebuff/buff in active_hivebuffs)
		buff._on_cease()

/datum/faction_module/hive_mind/proc/free_respawn(client/C)
	stored_larva++
	if(!hive_location || !hive_location.spawn_burrowed_larva(C.mob))
		stored_larva--
	else
		hive_ui.update_burrowed_larva()

/datum/faction_module/hive_mind/proc/respawn_on_turf(client/xeno_client, turf/spawning_turf)
	var/mob/living/carbon/xenomorph/larva/new_xeno = spawn_hivenumber_larva(spawning_turf, faction_owner)
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

/datum/faction_module/hive_mind/proc/do_buried_larva_spawn(mob/xeno_candidate)
	var/spawning_area
	if(hive_location)
		spawning_area = hive_location
	else if(living_xeno_queen)
		spawning_area = living_xeno_queen
	else for(var/mob/living/carbon/xenomorpheus in faction_owner.total_mobs)
		if(islarva(xenomorpheus) || isxeno_builder(xenomorpheus)) //next to xenos that should be in a safe spot
			spawning_area = xenomorpheus
	if(!spawning_area)
		spawning_area = pick(faction_owner.total_mobs) // FUCK IT JUST GO ANYWHERE
	var/list/turf_list
	for(var/turf/open/open_turf in orange(3, spawning_area))
		if(istype(open_turf, /turf/open/space))
			continue
		LAZYADD(turf_list, open_turf)
	// just on the off-chance
	if(!LAZYLEN(turf_list))
		return FALSE
	var/turf/open/spawning_turf = pick(turf_list)

	var/mob/living/carbon/xenomorph/larva/new_xeno = spawn_hivenumber_larva(spawning_turf, faction_owner)
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

/datum/faction_module/hive_mind/proc/can_delay_round_end(mob/living/carbon/xenomorph/xeno)
	if(HAS_TRAIT(src, TRAIT_NO_HIVE_DELAY))
		return FALSE
	return TRUE

/datum/faction_module/hive_mind/proc/update_hugger_limit()
	var/countable_xeno_iterator = 0
	for(var/mob/living/carbon/xenomorph/cycled_xeno in faction_owner.total_mobs)
		if(cycled_xeno.counts_for_slots)
			countable_xeno_iterator++

	playable_hugger_limit = max(floor(countable_xeno_iterator / playable_hugger_max_divisor), playable_hugger_minimum)

/datum/faction_module/hive_mind/proc/can_spawn_as_hugger(mob/dead/observer/user)
	if(jobban_isbanned(user, JOB_XENOMORPH)) // User is jobbanned
		to_chat(user, SPAN_WARNING("You are banned from playing aliens and cannot spawn as a xenomorph."))
		return FALSE
	if(world.time < hugger_timelock)
		to_chat(user, SPAN_WARNING("The hive cannot support facehuggers yet..."))
		return FALSE
	if(!user.bypass_time_of_death_checks_hugger && world.time - user.timeofdeath < JOIN_AS_FACEHUGGER_DELAY)
		var/time_left = floor((user.timeofdeath + JOIN_AS_FACEHUGGER_DELAY - world.time) / 10)
		to_chat(user, SPAN_WARNING("You ghosted too recently. You cannot become a facehugger until 3 minutes have passed ([time_left] seconds remaining)."))
		return FALSE
	if(!length(faction_owner.total_mobs))
		//This is to prevent people from joining as Forsaken Huggers on the pred ship
		to_chat(user, SPAN_WARNING("The hive has fallen, you can't join it!"))
		return FALSE
	for(var/mob_name in faction_owner.banished_ckeys)
		if(faction_owner.banished_ckeys[mob_name] == user.ckey)
			to_chat(user, SPAN_WARNING("You are banished from the [faction_owner], you may not rejoin unless the Queen re-admits you or dies."))
			return FALSE

	update_hugger_limit()

	var/current_hugger_count = 0
	for(var/mob/mob as anything in faction_owner.total_mobs)
		if(isfacehugger(mob))
			current_hugger_count++
	if(playable_hugger_limit <= current_hugger_count)
		to_chat(user, SPAN_WARNING("\The [faction_owner] cannot support more facehuggers! Limit: <b>[current_hugger_count]/[playable_hugger_limit]</b>"))
		return FALSE

	if(tgui_alert(user, "Are you sure you want to become a facehugger?", "Confirmation", list("Yes", "No")) != "Yes")
		return FALSE

	if(!user.client)
		return FALSE

	return TRUE

/datum/faction_module/hive_mind/proc/get_current_playable_facehugger_count()
	var/count = 0
	for(var/mob/mob as anything in faction_owner.total_mobs)
		if(isfacehugger(mob))
			count++
	return count

/datum/faction_module/hive_mind/proc/spawn_as_hugger(mob/dead/observer/user, atom/A)
	var/mob/living/carbon/xenomorph/facehugger/hugger = new /mob/living/carbon/xenomorph/facehugger(A.loc, null, faction_owner)
	user.mind.transfer_to(hugger, TRUE)
	hugger.visible_message(SPAN_XENODANGER("A facehugger suddenly emerges out of \the [A]!"), SPAN_XENODANGER("You emerge out of \the [A] and awaken from your slumber. For the Hive!"))
	playsound(hugger, 'sound/effects/xeno_newlarva.ogg', 25, TRUE)
	hugger.generate_name()
	hugger.timeofdeath = user.timeofdeath // Keep old death time

/datum/faction_module/hive_mind/proc/update_lesser_drone_limit()
	var/countable_xeno_iterator = 0
	for(var/mob/living/carbon/xenomorph/cycled_xeno in faction_owner.total_mobs)
		if(cycled_xeno.counts_for_slots)
			countable_xeno_iterator++

	lesser_drone_limit = max(floor(countable_xeno_iterator / playable_lesser_drones_max_divisor), lesser_drone_minimum)

/datum/faction_module/hive_mind/proc/can_spawn_as_lesser_drone(mob/dead/observer/user, obj/effect/alien/resin/special/pylon/spawning_pylon)
	if(jobban_isbanned(user, JOB_XENOMORPH)) // User is jobbanned
		to_chat(user, SPAN_WARNING("You are banned from playing aliens and cannot spawn as a xenomorph."))
		return FALSE

	if(world.time - user.timeofdeath < JOIN_AS_LESSER_DRONE_DELAY)
		var/time_left = floor((user.timeofdeath + JOIN_AS_LESSER_DRONE_DELAY - world.time) / 10)
		to_chat(user, SPAN_WARNING("You ghosted too recently. You cannot become a lesser drone until 30 seconds have passed ([time_left] seconds remaining)."))
		return FALSE

	if(!length(faction_owner.total_mobs))
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
	for(var/mob/mob as anything in faction_owner.total_mobs)
		if(islesserdrone(mob))
			current_lesser_drone_count++

	if(lesser_drone_limit <= current_lesser_drone_count)
		to_chat(user, SPAN_WARNING("[faction_owner] cannot support more lesser drones! Limit: <b>[current_lesser_drone_count]/[lesser_drone_limit]</b>"))
		return FALSE

	if(!user.client)
		return FALSE

	return TRUE

// Get amount of real xenos, don't count lessers/huggers
/datum/faction_module/hive_mind/proc/get_real_total_xeno_count()
	var/count = 0
	for(var/mob/living/carbon/xenomorph/xeno in faction_owner.total_mobs)
		if(xeno.counts_for_slots)
			count++
	return count

// Checks if we hit larva limit
/datum/faction_module/hive_mind/proc/check_if_hit_larva_from_pylon_limit()
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
/datum/faction_module/hive_mind/proc/increase_larva_after_burst()
	var/extra_per_burst = CONFIG_GET(number/extra_larva_per_burst)
	partial_larva += extra_per_burst
	convert_partial_larva_to_full_larva()

///Called after times when partial larva are added to process them to stored larva
/datum/faction_module/hive_mind/proc/convert_partial_larva_to_full_larva()
	for(var/i = 1 to partial_larva)
		partial_larva--
		stored_larva++
