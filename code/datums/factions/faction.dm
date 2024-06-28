/datum/faction
	var/name = NAME_FACTION_NEUTRAL
	var/desc = "Neutral Faction"

	var/faction_name = FACTION_NEUTRAL
	var/faction_tag = SIDE_FACTION_NEUTRAL

	var/organ_faction_iff_tag_type
	var/faction_iff_tag_type

	var/relations_pregen[] = RELATIONS_NEUTRAL
	var/datum/faction_relations/relations_datum

	var/hud_type = FACTION_HUD
	var/orders = "Остаться в живых"
	var/color = "#22888a"
	var/ui_color = "#22888a"
	var/prefix = ""
	var/list/totalMobs = list()
	var/list/totalDeadMobs = list()
	var/list/faction_leaders = list()
	var/list/late_join_landmarks = list()
	var/mob/living/carbon/faction_leader
	var/datum/tacmap/faction_datum/tcmp_faction_datum
	var/datum/objectives_datum/objectives_controller
	var/list/objectives = list()
	var/faction_victory_points = 0
	var/homes_sector_occupation = TRUE
	var/objectives_active = FALSE
	var/need_round_end_check = FALSE

////////////////
//BALANCE DEFS//
////////////////
	var/list/role_mappings = list()
	var/list/roles_list = list()
	var/list/coefficient_per_role = list()
	var/list/affected_spawns // TODO: СДЕЛАТЬ СКЕЙЛИНГ СПАВНА ВЕЩЕЙ В ВЕНДОРАХ И УСЛОЖНЕНИЯ ЗАДАЧ ОТ ОНЛАЙНА НАПРИМЕР КАК ОЧКИ ДЕФКОНА
	var/weight_act = list(
		MODE_NAME_EXTENDED = TRUE,
		MODE_NAME_DISTRESS_SIGNAL = TRUE,
		MODE_NAME_FACTION_CLASH = TRUE,
		MODE_NAME_CRASH = TRUE,
		MODE_NAME_WISKEY_OUTPOST = TRUE,
		MODE_NAME_HUNTER_GAMES = TRUE,
		MODE_NAME_HIVE_WARS = TRUE,
		MODE_NAME_INFECTION = TRUE
	)

	var/spawning_enabled = TRUE
	var/latejoin_enabled = TRUE
	var/force_spawning = FALSE

/////////////
//XENO DEFS//
/////////////
	var/mob/living/carbon/xenomorph/queen/living_xeno_queen
	var/egg_planting_range = 15
	var/slashing_allowed = XENO_SLASH_ALLOWED //This initial var allows the queen to turn on or off slashing. Slashing off means harm intent does much less damage.
	var/construction_allowed = NORMAL_XENO //Who can place construction nodes for special structures
	var/destruction_allowed = XENO_LEADER //Who can destroy special structures
	var/unnesting_allowed = TRUE
	var/queen_leader_limit = 2
	var/lesser_drone_limit = 0 //How many lesser drones the hive can support
	var/lesser_drone_minimum = 2 //Slots available for lesser drones will never go below this number
	var/playable_lesser_drones_max_divisor = 3 //This number divides the total xenos counted for slots to give the max number of lesser drones
	var/list/open_xeno_leader_positions = list(1, 2) //Ordered list of xeno leader positions (indexes in xeno_leader_list) that are not occupied
	var/list/xeno_leader_list[2] //Ordered list (i.e. index n holds the nth xeno leader)
	var/partial_larva = 0
	var/stored_larva = 0
	var/list/free_slots = list(
		/datum/caste_datum/burrower = 1,
		/datum/caste_datum/hivelord = 1,
		/datum/caste_datum/carrier = 1
	) //Assoc list of free slots available to specific castes
	var/list/used_slots = list() //Assoc list of slots currently used by specific castes (for calculating free_slot usage)
	var/list/tier_2_xenos = list() //list of living tier2 xenos
	var/list/tier_3_xenos = list() //list of living tier3 xenos
	var/xeno_queen_timer
	var/isSlotOpen = TRUE //Set true for starting alerts only after the hive has reached its full potential
	var/allowed_nest_distance = 15 //How far away do we allow nests from an ovied Queen. Default 15 tiles.
	var/obj/effect/alien/resin/special/pylon/core/faction_location = null //Set to ref every time a core is built, for defining the hive location.
	var/crystal_stored = 0 //How much stockpiled material is stored for the hive to use.
	var/datum/mutator_set/hive_mutations/mutators = new
	var/tier_slot_multiplier = 1.0
	var/larva_gestation_multiplier = 1.0
	var/bonus_larva_spawn_chance = 1.0
	var/hijack_burrowed_surge = FALSE //at hijack, start spawning lots of pooled
	var/hijack_burrowed_left = 0 //how many burrowed is going to spawn during larva surge
	var/ignore_slots = FALSE
	var/dynamic_evolution = TRUE
	var/evolution_rate = 3 //Only has use if dynamic_evolution is false
	var/evolution_bonus = 0
	var/allow_no_queen_actions = FALSE
	var/evolution_without_ovipositor = TRUE //Temporary for the roundstart.
	var/allow_queen_evolve = TRUE //Set to true if you want to prevent evolutions into Queens
	var/hardcore = FALSE //Set to true if you want to prevent bursts and spawns of new xenos. Will also prevent healing if the queen no longer exists
	var/list/hive_inherant_traits
	var/mob/living/carbon/leading_cult_sl //Cultist Info
	var/list/faction_structures_limit = list(
		XENO_STRUCTURE_CORE = 1,
		XENO_STRUCTURE_PYLON = 2,
		XENO_STRUCTURE_CLUSTER = 8,
		XENO_STRUCTURE_POOL = 1,
		XENO_STRUCTURE_EGGMORPH = 6,
		XENO_STRUCTURE_EVOPOD = 2,
		XENO_STRUCTURE_RECOVERY = 6,
	) //List of how many maximum of each special structure you can have
	var/global/list/faction_structure_types = list(
		XENO_STRUCTURE_CORE = /datum/construction_template/xenomorph/core,
		XENO_STRUCTURE_PYLON = /datum/construction_template/xenomorph/pylon,
		XENO_STRUCTURE_CLUSTER = /datum/construction_template/xenomorph/cluster,
		XENO_STRUCTURE_EGGMORPH = /datum/construction_template/xenomorph/eggmorph,
		XENO_STRUCTURE_RECOVERY = /datum/construction_template/xenomorph/recovery
	)
	var/list/list/faction_structures = list() //Stringref list of structures that have been built
	var/list/list/faction_constructions = list() //Stringref list of structures that are being built
	var/datum/mark_menu_ui/mark_ui
	var/datum/hive_status_ui/faction_ui
	var/datum/faction_task_ui/task_interface
	var/datum/objective_memory_storage/objective_memory
	var/datum/objective_memory_interface/objective_interface
	var/datum/research_objective_memory_interface/research_objective_interface
	var/list/tunnels = list()
	var/list/resin_marks = list()
	var/list/banished_ckeys = list()
	var/hivecore_cooldown = FALSE
	var/hugger_timelock = 15 MINUTES //When can huggers join the round
	var/playable_hugger_limit = 0 //How many huggers can the hive support

//////////////
/datum/faction/New()
	relations_datum = new(src)
	tcmp_faction_datum = new(src)
	objectives_controller = GLOB.objective_controller[faction_name]
	task_interface = new(src)
	objective_memory = new()
	objective_interface = new()
	research_objective_interface = new()

/datum/faction/can_vv_modify()
	return FALSE

/datum/faction/proc/modify_hud_holder(image/holder, mob/living/carbon/human/H)
	return

/datum/faction/proc/add_mob(mob/living/carbon/carbon)
	if(!carbon || !istype(carbon))
		return

	if(carbon.faction && carbon.faction != src)
		carbon.faction.remove_mob(carbon, TRUE)

	if(carbon in totalMobs)
		return

	carbon.faction = src

	if(carbon.hud_list)
		carbon.hud_update()

	if(!carbon.statistic_exempt)
		totalMobs += carbon

/datum/faction/proc/remove_mob(mob/living/carbon/carbon, hard = FALSE)
	if(!carbon || !istype(carbon))
		return

	if(!(carbon in totalMobs))
		return

	if(hard)
		carbon.faction = null
	else
		totalDeadMobs += carbon

	totalMobs -= carbon

/datum/faction/proc/can_delay_round_end(mob/living/carbon/carbon)
	return TRUE

/datum/faction/proc/update_hugger_limit()
	playable_hugger_limit = 2 + Ceiling(totalMobs.len / 4)

/datum/faction/proc/can_spawn_as_hugger(mob/dead/observer/user)
	if(world.time < hugger_timelock)
		to_chat(user, SPAN_WARNING("The hive cannot support facehuggers yet..."))
		return FALSE
	if(world.time - user.timeofdeath < JOIN_AS_FACEHUGGER_DELAY)
		var/time_left = round((user.timeofdeath + JOIN_AS_FACEHUGGER_DELAY - world.time) / 10)
		to_chat(user, SPAN_WARNING("You ghosted too recently. You cannot become a facehugger until 3 minutes have passed ([time_left] seconds remaining)."))
		return FALSE
	if(totalMobs.len <= 0)
		//This is to prevent people from joining as Forsaken Huggers on the pred ship
		to_chat(user, SPAN_WARNING("The hive has fallen, you can't join it!"))
		return FALSE

	update_hugger_limit()

	var/current_hugger_count = 0
	for(var/mob/mob as anything in totalMobs)
		if(isfacehugger(mob))
			current_hugger_count++
	if(playable_hugger_limit <= current_hugger_count)
		to_chat(user, SPAN_WARNING("\The [name] cannot support more facehuggers! Limit: <b>[current_hugger_count]/[playable_hugger_limit]</b>"))
		return FALSE

	if(alert(user, "Are you sure you want to become a facehugger?", usr.client.auto_lang(LANGUAGE_CONFIRM), usr.client.auto_lang(LANGUAGE_YES), usr.client.auto_lang(LANGUAGE_NO)) != usr.client.auto_lang(LANGUAGE_YES))
		return FALSE
	return TRUE

/datum/faction/proc/spawn_as_hugger(mob/dead/observer/user, atom/A)
	var/mob/living/carbon/xenomorph/facehugger/facehugger = new /mob/living/carbon/xenomorph/facehugger(A.loc, null, src)
	user.mind.transfer_to(facehugger, TRUE)
	facehugger.visible_message(SPAN_XENODANGER("A facehugger suddenly emerges out of \the [A]!"), SPAN_XENODANGER("You emerge out of \the [A] and awaken from your slumber. For the Hive!"))
	playsound(facehugger, 'sound/effects/xeno_newlarva.ogg', 25, TRUE)
	facehugger.generate_name()

//Ally procs
/atom/movable/proc/ally(datum/faction/ally_faction)
	if(!ally_faction)
		return FALSE

	var/list/factions = list()
	factions += ally_faction
	for(var/datum/faction/i in ally_faction.relations_datum.allies)
		factions += i
	if(isnull(factions) || !faction)
		return FALSE

	return faction in factions

/mob/ally(datum/faction/ally_faction)
	if(!ally_faction)
		return FALSE

	var/list/factions = list()
	factions += ally_faction
	for(var/datum/faction/i in ally_faction.relations_datum.allies)
		factions += i

	if(isnull(factions) || !faction)
		return FALSE

	return faction in factions

/mob/living/carbon/ally(datum/faction/ally_faction)
	if(!ally_faction)
		return FALSE

	if(client in ally_faction.banished_ckeys)
		return FALSE

	if((organ_faction_tag || (faction.faction_tag in SIDE_ORGANICAL_DOM)) && (ally_faction.faction_tag in SIDE_ORGANICAL_DOM))
		if(organ_faction_tag)
			return ally_faction.organ_faction_tag_is_ally(organ_faction_tag)
		else if(faction == ally_faction)
			return TRUE
	else if(faction_tag)
		return ally_faction.faction_tag_is_ally(faction_tag)

	return FALSE

/datum/faction/proc/organ_faction_tag_is_ally(obj/item/faction_tag/organ/FT)
	if(FT.faction == src)
		return TRUE
	for(var/datum/faction/faction in FT.factions + FT.faction)
		if(relations_datum.allies[faction.faction_name])
			return TRUE

	return FALSE

/datum/faction/proc/faction_tag_is_ally(obj/item/faction_tag/FT)
	if(FT.faction == src)
		return TRUE
	for(var/datum/faction/faction in FT.factions + FT.faction)
		if(relations_datum.allies[faction.faction_name])
			return TRUE
		else if(faction.faction_tag == faction_tag)
			return TRUE

	return FALSE

/datum/faction/proc/faction_is_ally(datum/faction/faction_to_check)
	if(faction_to_check.faction_tag == faction_tag)
		return TRUE

	if(relations_datum.allies[faction_to_check.faction_name])
		return TRUE

	return FALSE

/datum/faction/proc/get_antag_guns_snowflake_equipment()
	return list()

/datum/faction/proc/get_antag_guns_sorted_equipment()
	return list()




//////////////
//XENO PROCS//
//////////////
/datum/faction/proc/set_living_xeno_queen(mob/living/carbon/xenomorph/queen/XQ)
	if(XQ == null)
		mutators.reset_mutators()
		SStracking.delete_leader("hive_[faction_name]")
		SStracking.stop_tracking("hive_[faction_name]", living_xeno_queen)
		SShive_status.wait = 10 SECONDS
	else
		SStracking.set_leader("hive_[faction_name]", XQ)
		SShive_status.wait = 2 SECONDS

	living_xeno_queen = XQ
	mutators.xeno = XQ

	recalculate_hive()

/datum/faction/proc/recalculate_hive()
	if(!living_xeno_queen)
		queen_leader_limit = 0 //No leaders for a Hive without a Queen!
	else
		queen_leader_limit = 4 + mutators.leader_count_boost

	if(xeno_leader_list.len > queen_leader_limit)
		var/diff = 0
		for(var/i in queen_leader_limit + 1 to xeno_leader_list.len)
			if(!open_xeno_leader_positions.Remove(i))
				remove_hive_leader(xeno_leader_list[i])
			diff++
		xeno_leader_list.len -= diff // Changing the size of xeno_leader_list needs to go at the end or else it won't iterate through the list properly
	else if(xeno_leader_list.len < queen_leader_limit)
		for (var/i in xeno_leader_list.len + 1 to queen_leader_limit)
			open_xeno_leader_positions += i
			xeno_leader_list.len++


	tier_slot_multiplier = mutators.tier_slot_multiplier
	larva_gestation_multiplier = mutators.larva_gestation_multiplier
	bonus_larva_spawn_chance = mutators.bonus_larva_spawn_chance

	faction_ui.update_all_data()

/datum/faction/proc/add_hive_leader(mob/living/carbon/xenomorph/X)
	if(!X)
		return FALSE //How did this even happen?
	if(!open_xeno_leader_positions.len)
		return FALSE //Too many leaders already (no available xeno leader positions)
	if(X.hive_pos != NORMAL_XENO)
		return FALSE //Already on the list
	var/leader_num = open_xeno_leader_positions[1]
	xeno_leader_list[leader_num] = X
	X.hive_pos = XENO_LEADER_HIVE_POS(leader_num)
	X.handle_xeno_leader_pheromones()
	X.hud_update() // To add leader star
	open_xeno_leader_positions -= leader_num

	faction_ui.update_xeno_keys()
	return TRUE

/datum/faction/proc/remove_hive_leader(mob/living/carbon/xenomorph/X, light_mode = FALSE)
	if(!istype(X) || !IS_XENO_LEADER(X))
		return FALSE

	var/leader_num = GET_XENO_LEADER_NUM(X)

	xeno_leader_list[leader_num] = null

	if(!light_mode) // Don't run side effects during deletions. Better yet, replace all this by signals someday
		X.hive_pos = NORMAL_XENO
		X.handle_xeno_leader_pheromones()
		X.hud_update() // To remove leader star

	// Need to maintain ascending order of open_xeno_leader_positions
	for (var/i in 1 to queen_leader_limit)
		if(i > open_xeno_leader_positions.len || open_xeno_leader_positions[i] > leader_num)
			open_xeno_leader_positions.Insert(i, leader_num)
			break

	if(!light_mode)
		faction_ui.update_xeno_keys()

	return TRUE

/datum/faction/proc/replace_hive_leader(mob/living/carbon/xenomorph/original, mob/living/carbon/xenomorph/replacement)
	if(!replacement || replacement.hive_pos != NORMAL_XENO)
		return remove_hive_leader(original)

	var/leader_num = GET_XENO_LEADER_NUM(original)

	xeno_leader_list[leader_num] = replacement

	original.hive_pos = NORMAL_XENO
	original.handle_xeno_leader_pheromones()
	original.hud_update() // To remove leader star

	replacement.hive_pos = XENO_LEADER_HIVE_POS(leader_num)
	replacement.handle_xeno_leader_pheromones()
	replacement.hud_update() // To add leader star

	faction_ui.update_xeno_keys()

/datum/faction/proc/handle_xeno_leader_pheromones()
	for(var/mob/living/carbon/xenomorph/L in xeno_leader_list)
		L.handle_xeno_leader_pheromones()

/*
 *    Helper procs for the Hive Status UI
 *    These are all called by the hive status UI manager to update its data
 */

// Returns a list of how many of each caste of xeno there are, sorted by tier
/datum/faction/proc/get_xeno_counts()
	// Every caste is manually defined here so you get
	var/list/xeno_counts = list(
		// Yes, Queen is technically considered to be tier 0
		list(XENO_CASTE_LARVA = 0, "Queen" = 0),
		list(XENO_CASTE_DRONE = 0, XENO_CASTE_RUNNER = 0, XENO_CASTE_SENTINEL = 0, XENO_CASTE_DEFENDER = 0),
		list(XENO_CASTE_HIVELORD = 0, XENO_CASTE_BURROWER = 0, XENO_CASTE_CARRIER = 0, XENO_CASTE_LURKER = 0, XENO_CASTE_SPITTER = 0, XENO_CASTE_WARRIOR = 0),
		list(XENO_CASTE_BOILER = 0, XENO_CASTE_CRUSHER = 0, XENO_CASTE_PRAETORIAN = 0, XENO_CASTE_RAVAGER = 0)
	)

	for(var/mob/living/carbon/xenomorph/X in totalMobs)
		//don't show xenos in the thunderdome when admins test stuff.
		if(X.statistic_exempt)
			continue

		if(X.caste)
			xeno_counts[X.caste.tier+1][X.caste.caste_type]++

	return xeno_counts

// Returns a sorted list of some basic info (stuff that's needed for sorting) about all the xenos in the hive
// The idea is that we sort this list, and use it as a "key" for all the other information (especially the nicknumber)
// in the hive status UI. That way we can minimize the amount of sorts performed by only calling this when xenos are created/disposed
/datum/faction/proc/get_xeno_keys()
	var/list/xenos[totalMobs.len]

	var/index = 1
	var/useless_slots = 0
	for(var/mob/living/carbon/xenomorph/X in totalMobs)
		if(X.statistic_exempt)
			useless_slots++
			continue

		// Insert without doing list merging
		xenos[index++] = list(
			"nicknumber" = X.nicknumber,
			"tier" = X.tier, // This one is only important for sorting
			"is_leader" = (IS_XENO_LEADER(X)),
			"is_queen" = istype(X.caste, /datum/caste_datum/queen),
			"caste_type" = X.caste_type
		)

	// Clear nulls from the xenos list
	xenos.len -= useless_slots

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
/datum/faction/proc/sort_xeno_keys(list/xenos)
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
/datum/faction/proc/get_xeno_info()
	var/list/xenomorphs = list()

	for(var/mob/living/carbon/xenomorph/xenomorph in totalMobs)
		if(xenomorph.statistic_exempt)
			continue

		var/xeno_name = xenomorph.name
		// goddamn fucking larvas with their weird ass maturing system
		// its name updates with its icon, unlike other castes which only update the mature/elder, etc. prefix on evolve
		if(istype(xenomorph, /mob/living/carbon/xenomorph/larva))
			xeno_name = "Larva ([xenomorph.nicknumber])"
		xenomorphs["[xenomorph.nicknumber]"] = list(
			"name" = xeno_name,
			"strain" = xenomorph.mutation_type,
			"ref" = "\ref[xenomorph]"
		)

	return xenomorphs

/datum/faction/proc/set_faction_location(obj/effect/alien/resin/special/pylon/core/core)
	if(!core || core == faction_location)
		return
	var/area/A = get_area(core)
	xeno_message(SPAN_XENOANNOUNCE("The Queen has set the hive location as \the [A]."), 3, src)
	faction_location = core
	faction_ui.update_faction_location()

// Returns a list of xeno healths and locations
/datum/faction/proc/get_xeno_vitals()
	var/list/xenomorphs = list()

	for(var/mob/living/carbon/xenomorph/xenomorph in totalMobs)
		if(xenomorph.statistic_exempt)
			continue

		if(!(xenomorph in GLOB.living_xeno_list))
			continue

		var/area/area = get_area(xenomorph)
		var/area_name = "Unknown"
		if(area)
			area_name = area.name

		xenomorphs["[xenomorph.nicknumber]"] = list(
			"health" = round((xenomorph.health / xenomorph.maxHealth) * 100, 1),
			"area" = area_name,
			"is_ssd" = (!xenomorph.client)
		)

	return xenomorphs

#define TIER_3 "3"
#define TIER_2 "2"
#define OPEN_SLOTS "open_slots"
#define GUARANTEED_SLOTS "guaranteed_slots"

// Returns an assoc list of open slots and guaranteed slots left
/datum/faction/proc/get_tier_slots()
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
	for(var/mob/living/carbon/xenomorph/xeno as anything in totalMobs)
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

// returns if that location can be used to plant eggs
/datum/faction/proc/in_egg_plant_range(turf/T)
	if(!istype(living_xeno_queen))
		return TRUE // xenos already dicked without queen. Let them plant whereever

	if(!living_xeno_queen.ovipositor)
		return FALSE // ovid queen only

	return get_dist(living_xeno_queen, T) <= egg_planting_range

/datum/faction/proc/can_build_structure(structure_name)
	if(!structure_name || !faction_structures_limit[structure_name])
		return FALSE
	var/total_count = 0
	if(faction_structures[structure_name])
		total_count += faction_structures[structure_name].len
	if(faction_constructions[structure_name])
		total_count += faction_constructions[structure_name].len
	if(total_count >= faction_structures_limit[structure_name])
		return FALSE
	return TRUE

/datum/faction/proc/has_structure(structure_name)
	if(!structure_name)
		return FALSE
	if(faction_structures[structure_name] && faction_structures[structure_name].len)
		return TRUE
	return FALSE

/datum/faction/proc/add_construction(obj/effect/alien/resin/construction/resin)
	if(!resin || !resin.template)
		return FALSE
	var/name_ref = initial(resin.template.name)
	if(!faction_constructions[name_ref])
		faction_constructions[name_ref] = list()
	if(faction_constructions[name_ref].len >= faction_structures_limit[name_ref])
		return FALSE
	faction_constructions[name_ref] += src
	return TRUE

/datum/faction/proc/remove_construction(obj/effect/alien/resin/construction/resin)
	if(!resin || !resin.template)
		return FALSE
	var/name_ref = initial(resin.template.name)
	faction_constructions[name_ref] -= src
	return TRUE

/datum/faction/proc/add_special_structure(obj/effect/alien/resin/special/resin)
	if(!resin)
		return FALSE
	var/name_ref = initial(resin.name)
	if(!faction_structures[name_ref])
		faction_structures[name_ref] = list()
	if(faction_structures[name_ref].len >= faction_structures_limit[name_ref])
		return FALSE
	faction_structures[name_ref] += resin
	return TRUE

/datum/faction/proc/remove_special_structure(obj/effect/alien/resin/special/resin)
	if(!resin)
		return FALSE
	var/name_ref = initial(resin.name)
	faction_structures[name_ref] -= resin
	return TRUE

/datum/faction/proc/has_special_structure(name_ref)
	if(!name_ref || !faction_structures[name_ref] || !faction_structures[name_ref].len)
		return 0
	return faction_structures[name_ref].len

/datum/faction/proc/abandon_on_hijack()
	var/area/hijacked_dropship = get_area(living_xeno_queen)
	var/xenos_count = 0
	var/shipside_humans_weighted_count = 0
	for(var/name_ref in faction_structures)
		for(var/obj/effect/alien/resin/special/resin in faction_structures[name_ref])
			if(get_area(resin) == hijacked_dropship)
				continue
			resin.hijack_delete = TRUE
			faction_structures[name_ref] -= resin
			qdel(resin)
	for(var/mob/living/carbon/xenomorph/xeno as anything in totalMobs)
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
				xeno.set_hive_and_update(GLOB.faction_datum[FACTION_XENOMORPH_FORSAKEN])
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
		if(A && A.faction != src)
			continue
		for(var/obj/item/alien_embryo/embryo in potential_host)
			embryo.faction = GLOB.faction_datum[FACTION_XENOMORPH_FORSAKEN]
		potential_host.update_med_icon()
	for(var/mob/living/carbon/human/current_human as anything in GLOB.alive_human_list)
		if(!(isspecieshuman(current_human) || isspeciessynth(current_human)))
			continue
		var/datum/job/job = SSticker.role_authority.roles_for_mode[current_human.job]
		if(!job)
			continue
		var/turf/turf = get_turf(current_human)
		if(is_mainship_level(turf?.z))
			shipside_humans_weighted_count += current_human.faction.get_role_coeff(current_human.job)
	hijack_burrowed_surge = TRUE
	hijack_burrowed_left = max(n_ceil(shipside_humans_weighted_count * 0.5) - xenos_count, 5)
	hivecore_cooldown = FALSE
	xeno_message(SPAN_XENOBOLDNOTICE("The weeds have recovered! A new hive core can be built!"), 3, src)

/datum/faction/proc/update_lesser_drone_limit()
	var/countable_xeno_iterator = 0
	for(var/mob/living/carbon/xenomorph/cycled_xeno as anything in totalMobs)
		if(cycled_xeno.counts_for_slots)
			countable_xeno_iterator++

	lesser_drone_limit = max(round(countable_xeno_iterator / playable_lesser_drones_max_divisor), lesser_drone_minimum)

/datum/faction/proc/can_spawn_as_lesser_drone(mob/dead/observer/user, obj/effect/alien/resin/special/pylon/spawning_pylon)
	if(jobban_isbanned(user, JOB_XENOMORPH)) // User is jobbanned
		to_chat(user, SPAN_WARNING("You are banned from playing aliens and cannot spawn as a xenomorph."))
		return FALSE

	if(world.time - user.timeofdeath < JOIN_AS_LESSER_DRONE_DELAY)
		var/time_left = round((user.timeofdeath + JOIN_AS_LESSER_DRONE_DELAY - world.time) / 10)
		to_chat(user, SPAN_WARNING("You ghosted too recently. You cannot become a lesser drone until 30 seconds have passed ([time_left] seconds remaining)."))
		return FALSE

	if(totalMobs.len <= 0)
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
	for(var/mob/mob as anything in totalMobs)
		if(islesserdrone(mob))
			current_lesser_drone_count++

	if(lesser_drone_limit <= current_lesser_drone_count)
		to_chat(user, SPAN_WARNING("[name] cannot support more lesser drones! Limit: <b>[current_lesser_drone_count]/[lesser_drone_limit]</b>"))
		return FALSE

	if(!user.client)
		return FALSE

	return TRUE

/datum/faction/proc/on_leader_death() //break alliances on queen's death
	return TRUE

/datum/faction/proc/free_respawn(client/xeno_client)
	if(!faction_location || !faction_location.spawn_burrowed_larva(xeno_client.mob))
		stored_larva--
	else
		stored_larva++
		faction_ui.update_burrowed_larva()

/datum/faction/proc/respawn_on_turf(client/xeno_client, turf/spawning_turf)
	var/mob/living/carbon/xenomorph/larva/new_xeno = spawn_faction_larva(spawning_turf, src)
	if(isnull(new_xeno))
		return FALSE

	if(!SSticker.mode.transfer_xenomorph(xeno_client.mob, new_xeno))
		qdel(new_xeno)
		return FALSE

	new_xeno.visible_message(SPAN_XENODANGER("A larva suddenly emerges from a dead husk!"),
	SPAN_XENOANNOUNCE("The hive has no core! You manage to emerge from your old husk as a larva!"))
	msg_admin_niche("[key_name(new_xeno)] respawned at \a [spawning_turf]. [ADMIN_JMP(spawning_turf)]")
	playsound(new_xeno, 'sound/effects/xeno_newlarva.ogg', 50, 1)
	if(new_xeno.client?.prefs?.toggles_flashing & FLASH_POOLSPAWN)
		window_flash(new_xeno.client)

	faction_ui.update_burrowed_larva()

/datum/faction/proc/do_buried_larva_spawn(mob/spawn_candidate)
	var/spawning_area
	if(faction_location)
		spawning_area = faction_location
	else if(living_xeno_queen)
		spawning_area = living_xeno_queen
	else for(var/mob/living/carbon/mob as anything in totalMobs)
		if(islarva(spawn_candidate) || isxeno_builder(mob)) //next to xenos that should be in a safe spot
			spawning_area = spawn_candidate
	if(!spawning_area)
		return FALSE

	var/list/turf_list
	for(var/turf/open/open_turf in orange(3, spawning_area))
		LAZYADD(turf_list, open_turf)

	var/turf/open/spawning_turf = pick(turf_list)

	var/mob/living/carbon/xenomorph/larva/new_xenomorph = new(spawning_turf, null, src)
	if(isnull(new_xenomorph))
		return FALSE

	if(!SSticker.mode.transfer_xenomorph(spawn_candidate, new_xenomorph))
		qdel(new_xenomorph)
		return FALSE
	new_xenomorph.visible_message(SPAN_XENODANGER("A larva suddenly burrows out of \the [spawning_turf]!"),
	SPAN_XENODANGER("You burrow out of \the [spawning_turf] and awaken from your slumber. For the Hive!"))
	msg_admin_niche("[key_name(new_xenomorph)] burrowed out from \a [spawning_turf]. (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[spawning_turf.x];Y=[spawning_turf.y];Z=[spawning_turf.z]'>JMP</a>)")
	playsound(new_xenomorph, 'sound/effects/xeno_newlarva.ogg', 50, 1)
	to_chat(new_xenomorph, SPAN_XENOANNOUNCE("You are a xenomorph larva awakened from slumber!"))
	if(new_xenomorph.client)
		if(new_xenomorph.client?.prefs?.toggles_flashing & FLASH_POOLSPAWN)
			window_flash(new_xenomorph.client)

	stored_larva--
	faction_ui.update_burrowed_larva()

///Called by /obj/item/alien_embryo when a host is bursting to determine extra larva per burst
/datum/faction/proc/increase_larva_after_burst()
	var/extra_per_burst = CONFIG_GET(number/extra_larva_per_burst)
	partial_larva += extra_per_burst
	convert_partial_larva_to_full_larva()

///Called after times when partial larva are added to process them to stored larva
/datum/faction/proc/convert_partial_larva_to_full_larva()
	for(var/i = 1 to partial_larva)
		partial_larva--
		stored_larva++

/datum/faction/proc/make_leader(mob/living/carbon/mob)
	if(!istype(mob))
		return

	if(mob.stat == DEAD)
		return

	if(faction_leader)
		UnregisterSignal(faction_leader, COMSIG_PARENT_QDELETING)

	faction_leader = mob
	RegisterSignal(faction_leader, COMSIG_PARENT_QDELETING, PROC_REF(handle_qdelete))

/datum/faction/proc/handle_qdelete(mob/living/carbon/mob)
	SIGNAL_HANDLER

	if(mob == faction_leader)
		faction_leader = null

//Roles and join stuff
/datum/faction/proc/get_role_coeff(role_name)
	if(coefficient_per_role[role_name])
		return coefficient_per_role[role_name]
	return 1

/datum/faction/proc/store_objective(datum/cm_objective/O)
	if(objective_memory)
		objective_memory.store_objective(O)

//FACTION INFO PANEL
/datum/faction/ui_state(mob/user)
	return GLOB.not_incapacitated_state

/datum/faction/ui_status(mob/user, datum/ui_state/state)
	. = ..()
	if(isobserver(user))
		return UI_INTERACTIVE

/datum/faction/ui_data(mob/user)
	. = list()
	.["faction_orders"] = orders

/datum/faction/ui_static_data(mob/user)
	. = list()
	.["faction_color"] = ui_color
	.["faction_name"] = name
	.["faction_desc"] = desc
	.["actions"] = get_faction_actions()

/datum/faction/tgui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FactionStatus", "[name] Статус")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/faction/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return

	switch(action)
		if("relations")
			relations_datum.tgui_interact(usr)
		if("tasks")
			task_interface.tgui_interact(usr)
		if("clues")
			if(!skillcheck(usr, SKILL_INTEL, SKILL_INTEL_TRAINED))
				to_chat(usr, SPAN_WARNING("You have no access to the [name] intel network."))
				return
			objective_interface.tgui_interact(usr)
		if("researchs")
			if(!skillcheck(usr, SKILL_RESEARCH, SKILL_RESEARCH_TRAINED))
				to_chat(usr, SPAN_WARNING("You have no access to the [name] research network."))
				return
			research_objective_interface.tgui_interact(usr)
		if("status")
			get_faction_info(usr)

/datum/faction/proc/get_faction_actions(mob/user)
	. = list()
	. += list(list("name" = "Faction Relations", "action" = "relations"))
	. += list(list("name" = "Faction Tasks", "action" = "tasks"))
	. += list(list("name" = "Faction Clues", "action" = "clues"))
	. += list(list("name" = "Faction Researchs", "action" = "researchs"))
	. += list(list("name" = "Faction Status", "action" = "status"))
	return .

/datum/faction/proc/get_faction_info(mob/user)
	var/dat = GLOB.data_core.get_manifest(FALSE, src)
	if(!dat)
		return FALSE
	show_browser(user, dat, "Список Экипажа [name]", "manifest", "size=450x750")
	return TRUE

/datum/faction/proc/get_join_status(mob/new_player/user, dat)
	dat = "<html><body onselectstart='return false;'><center>"
	dat += "[user.client.auto_lang(LANGUAGE_LOBBY_ROUND_TIME)]: [DisplayTimeText(world.time, language = user.client.language)]<br>"
	dat += "[user.client.auto_lang(LANGUAGE_LOBBY_LATE_JOIN_CHOSE)]:<br>"
	dat += additional_join_status(user)

	if(!latejoin_enabled)
		dat = "[user.client.auto_lang(LANGUAGE_LOBBY_LATE_JOIN_CLOSED)]:<br>"

	else if(!SSautobalancer.can_join(src))
		dat = "[user.client.auto_lang(LANGUAGE_JS_BALANCE_ISSUE)]:<br>"

	else
		var/list/roles = roles_list[SSticker.mode.name]
		for(var/i in roles)
			var/datum/job/job = SSticker.role_authority.roles_by_name[i]
			var/check_result = SSticker.role_authority.check_role_entry(user, job, src, TRUE)
			var/active = 0
			for(var/mob/mob in GLOB.player_list)
				if(mob.client && mob.job == job.title)
					active++

			if(check_result)
				dat += "[job.disp_title] ([job.current_positions]): [check_result] ([user.client.auto_lang(LANGUAGE_LOBBY_LATE_JOIN_ACTIVE)]: [active])<br>"
			else
				dat += "<a href='byond://?src=\ref[user];lobby_choice=SelectedJob;job_selected=[job.title]'>[job.disp_title] ([job.current_positions]) ([user.client.auto_lang(LANGUAGE_LOBBY_LATE_JOIN_ACTIVE)]: [active])</a><br>"

	dat += "</center>"
	show_browser(user, dat, user.client.auto_lang(LANGUAGE_LOBBY_LATE_JOIN), "latechoices", "size=420x700")

/datum/faction/proc/additional_join_status(mob/new_player/user, dat = "")
	return
/*
			if(roles_show & FLAG_SHOW_CIC && ROLES_CIC & job.title)
				dat += "<hr>[user.client.auto_lang(LANGUAGE_LOBBY_LATE_JOIN_COM)]:<br>"
				roles_show ^= FLAG_SHOW_CIC

			else if(roles_show & FLAG_SHOW_AUXIL_SUPPORT && ROLES_AUXIL_SUPPORT & job.title)
				dat += "<hr>[user.client.auto_lang(LANGUAGE_LOBBY_LATE_JOIN_SUP)]:<br>"
				roles_show ^= FLAG_SHOW_AUXIL_SUPPORT

			else if(roles_show & FLAG_SHOW_MISC && ROLES_MISC & job.title)
				dat += "<hr>[user.client.auto_lang(LANGUAGE_LOBBY_LATE_JOIN_OTH)]:<br>"
				roles_show ^= FLAG_SHOW_MISC

			else if(roles_show & FLAG_SHOW_POLICE && ROLES_POLICE & job.title)
				dat += "<hr>[user.client.auto_lang(LANGUAGE_LOBBY_LATE_JOIN_POL)]:<br>"
				roles_show ^= FLAG_SHOW_POLICE

			else if(roles_show & FLAG_SHOW_ENGINEERING && ROLES_ENGINEERING & job.title)
				dat += "<hr>[user.client.auto_lang(LANGUAGE_LOBBY_LATE_JOIN_ENG)]:<br>"
				roles_show ^= FLAG_SHOW_ENGINEERING

			else if(roles_show & FLAG_SHOW_REQUISITION && ROLES_REQUISITION & job.title)
				dat += "<hr>[user.client.auto_lang(LANGUAGE_LOBBY_LATE_JOIN_CAG)]:<br>"
				roles_show ^= FLAG_SHOW_REQUISITION

			else if(roles_show & FLAG_SHOW_MEDICAL && ROLES_MEDICAL & job.title)
				dat += "<hr>[user.client.auto_lang(LANGUAGE_LOBBY_LATE_JOIN_MED)]:<br>"
				roles_show ^= FLAG_SHOW_MEDICAL

			else if(roles_show & FLAG_SHOW_MARINES && ROLES_MARINES & job.title)
				dat += "<hr>[user.client.auto_lang(LANGUAGE_LOBBY_LATE_JOIN_MAR)]:<br>"
				roles_show ^= FLAG_SHOW_MARINES
*/
