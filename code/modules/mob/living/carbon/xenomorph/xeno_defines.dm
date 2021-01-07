
// Actual caste datum basedef
/datum/caste_datum
	var/caste_name = ""
	var/display_name = ""
	var/tier = 0
	var/dead_icon = "Drone Dead"
	var/language = "Xenomorph"

	var/melee_damage_lower = 10
	var/melee_damage_upper = 20
	var/evasion = XENO_EVASION_NONE

	var/speed = XENO_SPEED_TIER_10

	var/plasma_max = 10
	var/plasma_gain = 5

	var/crystal_max = 0

	var/max_health = XENO_UNIVERSAL_HPMULT * 100

	var/evolution_allowed = 1 //Are they allowed to evolve (and have their evolution progress group)
	var/evolution_threshold = 0 //Threshold to next evolution

	var/list/evolves_to = list() //This is where you add castes to evolve into. "Seperated", "by", "commas"
	var/deevolves_to // what caste to de-evolve to.
	var/is_intelligent = 0 //If they can use consoles, etc. Set on Queen
	var/caste_desc = null

	// Tackles
	var/tackle_min = 2
	var/tackle_max = 6
	var/tackle_chance = 35
	var/tacklestrength_min = 2
	var/tacklestrength_max = 3

	var/armor_deflection = 0 //Chance of deflecting projectiles.
	var/fire_immune = FALSE //Boolean

	var/spit_delay = 60 //Delay timer for spitting

	var/aura_strength = 0 //The strength of our aura. Zero means we can't emit one
	var/aura_allowed = list("frenzy", "warding", "recovery") //"Evolving" removed for the time being

	var/adjust_size_x = 1 //Adjust pixel size. 0.x is smaller, 1.x is bigger, percentage based.
	var/adjust_size_y = 1
	var/list/spit_types //list of datum projectile types the xeno can use.

	var/attack_delay = 0 //Bonus or pen to time in between attacks. + makes slashes slower.

	var/agility_speed_increase = 0 // this opens up possibilities for balancing

	// The type of mutator delegate to instantiate on the base caste. Will
	// be replaced when the Xeno chooses a strain.
	var/behavior_delegate_type = /datum/behavior_delegate

	// Resin building-related vars
	var/build_time_mult = BUILD_TIME_MULT_XENO // Default build time and build distance
	var/max_build_dist = 0

	//Carrier vars
	var/huggers_max = 0
	var/throwspeed = 0
	var/hugger_delay = 0
	var/eggs_max = 0
	var/egg_cooldown = 30

	var/xeno_explosion_resistance = 0 //Armor but for explosions

	//Queen vars
	var/can_hold_facehuggers = 0
	var/can_hold_eggs = CANNOT_HOLD_EGGS

	var/can_be_queen_healed = 1

	var/can_vent_crawl = 1

	var/caste_luminosity = 0

	var/burrow_cooldown = SECONDS_5
	var/tunnel_cooldown = 100
	var/widen_cooldown = SECONDS_10
	var/tremor_cooldown = SECONDS_30 //Big strong ability, big cooldown.

	var/innate_healing = FALSE //whether the xeno heals even outside weeds.

	var/acid_level = 0
	var/weed_level = WEED_LEVEL_STANDARD

	var/acid_splash_cooldown = SECONDS_3 //Time it takes between acid splash retaliate procs. Variable per caste, for if we want future castes that are acid bombs

	// regen vars

	var/heal_delay_time = 0 SECONDS
	var/heal_resting = 1
	var/heal_standing = 0.4
	var/heal_knocked_out = 0.33

	var/list/resin_build_order
	var/minimum_xeno_playtime = 0


/datum/caste_datum/can_vv_modify()
	return FALSE

/datum/caste_datum/New()
	. = ..()

	//Initialise evolution and upgrade thresholds in one place, once and for all
	evolution_threshold = 0
	if(evolution_allowed)
		switch(tier)
			if(1)
				evolution_threshold = 200
			if(2)
				evolution_threshold = 500
			//Other tiers (T3, Queen, etc.) can't evolve anyway

	resin_build_order = GLOB.resin_build_order_default

/client/var/cached_xeno_playtime

/client/proc/get_total_xeno_playtime(var/skip_cache = FALSE)
	if(cached_xeno_playtime && !skip_cache)
		return cached_xeno_playtime

	var/total_xeno_playtime = 0

	for(var/caste in RoleAuthority.castes_by_name)
		total_xeno_playtime += get_job_playtime(src, caste)

	total_xeno_playtime += get_job_playtime(src, JOB_XENOMORPH)

	if(player_entity)
		var/past_xeno_playtime = player_entity.get_playtime(STATISTIC_XENO)
		if(past_xeno_playtime)
			total_xeno_playtime += past_xeno_playtime


	cached_xeno_playtime = total_xeno_playtime

	return total_xeno_playtime

/datum/caste_datum/proc/can_play_caste(var/client/client)
	if(!CONFIG_GET(flag/use_timelocks))
		return TRUE

	var/total_xeno_playtime = client.get_total_xeno_playtime()

	if(minimum_xeno_playtime && total_xeno_playtime < minimum_xeno_playtime)
		return FALSE

	return TRUE

/datum/caste_datum/proc/get_caste_requirement(var/client/client)
	return minimum_xeno_playtime - client.get_total_xeno_playtime()

/datum/hive_status
	var/name = "Normal Hive"

	// Used for the faction of the xenomorph. Not recommended to modify.
	var/internal_faction

	var/hivenumber = XENO_HIVE_NORMAL
	var/mob/living/carbon/Xenomorph/Queen/living_xeno_queen
	var/egg_planting_range = 15
	var/slashing_allowed = XENO_SLASH_ALLOWED //This initial var allows the queen to turn on or off slashing. Slashing off means harm intent does much less damage.
	var/construction_allowed = XENO_QUEEN //Who can place construction nodes for special structures
	var/destruction_allowed = XENO_LEADER //Who can destroy special structures
	var/unnesting_allowed = FALSE
	var/queen_time = 300 //5 minutes between queen deaths
	var/xeno_queen_timer
	var/hive_orders = "" //What orders should the hive have
	var/color = null
	var/prefix = ""
	var/queen_leader_limit = 2
	var/list/open_xeno_leader_positions = list(1, 2) // Ordered list of xeno leader positions (indexes in xeno_leader_list) that are not occupied
	var/list/xeno_leader_list[2] // Ordered list (i.e. index n holds the nth xeno leader)
	var/stored_larva = 0
	/// Assoc list of free slots available to specific castes
	var/list/free_slots = list(
		/datum/caste_datum/burrower = 1,
		/datum/caste_datum/hivelord = 1,
		/datum/caste_datum/carrier = 1
	)
	/// Assoc list of free slots currently used by specific castes
	var/list/used_free_slots
	var/list/tier_2_xenos = list()//list of living tier2 xenos
	var/list/tier_3_xenos = list()//list of living tier3 xenos
	var/list/totalXenos	= list()  //list of living xenos
	var/isSlotOpen = TRUE //Set true for starting alerts only after the hive has reached its full potential
	var/allowed_nest_distance = 15 //How far away do we allow nests from an ovied Queen. Default 15 tiles.
	var/obj/effect/alien/resin/special/pylon/core/hive_location = null //Set to ref every time a core is built, for defining the hive location.
	var/obj/effect/alien/resin/special/pool/spawn_pool = null // Ref to the spawn pool if there is one
	var/crystal_stored = 0 //How much stockpiled material is stored for the hive to use.
	var/xenocon_points = 0 //Xeno version of DEFCON

	var/datum/mutator_set/hive_mutators/mutators = new
	var/tier_slot_multiplier = 1.0
	var/larva_gestation_multiplier = 1.0
	var/bonus_larva_spawn_chance = 1.0
	var/hijack_pooled_surge = FALSE //at hijack, start spawning lots of pooled

	var/dynamic_evolution = TRUE
	var/evolution_rate = 3 // Only has use if dynamic_evolution is false

	var/allow_no_queen_actions = FALSE
	var/allow_queen_evolve = TRUE // Set to true if you want to prevent evolutions into Queens
	var/hardcore = FALSE // Set to true if you want to prevent bursts and spawns of new xenos. Will also prevent healing if the queen no longer exists

	// Cultist Info
	var/mob/living/carbon/leading_cult_sl

	//List of how many maximum of each special structure you can have
	var/list/hive_structures_limit = list(
		XENO_STRUCTURE_CORE = 1,
		XENO_STRUCTURE_PYLON = 8,
		XENO_STRUCTURE_POOL = 1,
		XENO_STRUCTURE_EGGMORPH = 6,
		XENO_STRUCTURE_EVOPOD = 2,
		XENO_STRUCTURE_RECOVERY = 6,
	)

	var/global/list/hive_structure_types = list(
		XENO_STRUCTURE_CORE = /datum/construction_template/xenomorph/core,
		XENO_STRUCTURE_PYLON = /datum/construction_template/xenomorph/pylon,
		XENO_STRUCTURE_POOL = /datum/construction_template/xenomorph/pool,
		XENO_STRUCTURE_EGGMORPH = /datum/construction_template/xenomorph/eggmorph,
		XENO_STRUCTURE_EVOPOD = /datum/construction_template/xenomorph/evopod,
		XENO_STRUCTURE_RECOVERY = /datum/construction_template/xenomorph/recovery
	)

	var/list/list/hive_structures = list() //Stringref list of structures that have been built
	var/list/list/hive_constructions = list() //Stringref list of structures that are being built

	var/datum/hive_status_ui/hive_ui
	var/datum/hive_faction_ui/faction_ui

	var/list/tunnels = list()

	var/list/allies = list()

/datum/hive_status/New()
	mutators.hive = src

	hive_ui = new(src)
	faction_ui = new(src)

	internal_faction = name

// Adds a xeno to this hive
/datum/hive_status/proc/add_xeno(var/mob/living/carbon/Xenomorph/X)
	if(!X || !istype(X))
		return

	// If the xeno is part of another hive, they should be removed from that one first
	if(X.hive && X.hive != src)
		X.hive.remove_xeno(X, TRUE)

	// Already in the hive
	if(X in totalXenos)
		return

	// Can only have one queen.
	if(isXenoQueen(X))
		if(!living_xeno_queen && !is_admin_level(X.z)) // Don't consider xenos in admin level
			set_living_xeno_queen(X)

	X.hivenumber = hivenumber
	X.hive = src

	X.set_faction(internal_faction)

	if(X.hud_list)
		X.hud_update()

	if(!is_admin_level(X.z))
		totalXenos += X
		if(X.tier == 2)
			tier_2_xenos += X
		else if(X.tier == 3)
			tier_3_xenos += X

	// Xenos are a fuckfest of cross-dependencies of different datums that are initialized at different times
	// So don't even bother trying updating UI here without large refactors

// Removes the xeno from the hive
/datum/hive_status/proc/remove_xeno(var/mob/living/carbon/Xenomorph/X, var/hard=FALSE)
	if(!X || !istype(X))
		return

	// Make sure the xeno was in the hive in the first place
	if(!(X in totalXenos))
		return

	if(isXenoQueen(X))
		if(living_xeno_queen == X)
			var/mob/living/carbon/Xenomorph/Queen/next_queen
			for(var/mob/living/carbon/Xenomorph/Queen/Q in totalXenos)
				if(!is_admin_level(Q.z))
					next_queen = Q
					break

			set_living_xeno_queen(next_queen) // either null or a queen

	// We allow "soft" removals from the hive (the xeno still retains information about the hive)
	// This is so that xenos can add themselves back to the hive if they should die or otherwise go "on leave" from the hive
	if(hard)
		X.hivenumber = 0
		X.hive = null

	totalXenos -= X
	if(X.tier == 2)
		tier_2_xenos -= X
	else if(X.tier == 3)
		tier_3_xenos -= X

	// At least UI updates when xenos are removed are safe
	hive_ui.update_xeno_counts()
	hive_ui.xeno_removed(X)

/datum/hive_status/proc/set_living_xeno_queen(var/mob/living/carbon/Xenomorph/Queen/M)
	if(M == null)
		mutators.reset_mutators()
		SStracking.delete_leader("hive_[hivenumber]")
		SStracking.stop_tracking("hive_[hivenumber]", living_xeno_queen)
	else
		SStracking.set_leader("hive_[hivenumber]", M)

	living_xeno_queen = M

	recalculate_hive()

/datum/hive_status/proc/recalculate_hive()
	if (!living_xeno_queen)
		queen_leader_limit = 0 //No leaders for a Hive without a Queen!
	else
		queen_leader_limit = 4 + mutators.leader_count_boost

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


	tier_slot_multiplier = mutators.tier_slot_multiplier

	larva_gestation_multiplier = mutators.larva_gestation_multiplier
	bonus_larva_spawn_chance = mutators.bonus_larva_spawn_chance

/datum/hive_status/proc/add_hive_leader(var/mob/living/carbon/Xenomorph/xeno)
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

	hive_ui.update_xeno_keys()
	return TRUE

/datum/hive_status/proc/remove_hive_leader(var/mob/living/carbon/Xenomorph/xeno)
	if(!istype(xeno) || !IS_XENO_LEADER(xeno))
		return FALSE

	var/leader_num = GET_XENO_LEADER_NUM(xeno)

	xeno_leader_list[leader_num] = null
	xeno.hive_pos = NORMAL_XENO
	xeno.handle_xeno_leader_pheromones()
	xeno.hud_update() // To remove leader star

	// Need to maintain ascending order of open_xeno_leader_positions
	for (var/i in 1 to queen_leader_limit)
		if (i > open_xeno_leader_positions.len || open_xeno_leader_positions[i] > leader_num)
			open_xeno_leader_positions.Insert(i, leader_num)
			break

	hive_ui.update_xeno_keys()
	return TRUE

/datum/hive_status/proc/replace_hive_leader(var/mob/living/carbon/Xenomorph/original, var/mob/living/carbon/Xenomorph/replacement)
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

	hive_ui.update_xeno_keys()

/datum/hive_status/proc/handle_xeno_leader_pheromones()
	for(var/mob/living/carbon/Xenomorph/L in xeno_leader_list)
		L.handle_xeno_leader_pheromones()

/*
 *    Helper procs for the Hive Status UI
 *    These are all called by the hive status UI manager to update its data
 */

// Returns a list of how many of each caste of xeno there are, sorted by tier
/datum/hive_status/proc/get_xeno_counts()
	// Every caste is manually defined here so you get
	var/list/xeno_counts = list(
		// Yes, Queen is technically considered to be tier 0
		list("Bloody Larva" = 0, "Queen" = 0),
		list("Drone" = 0, "Runner" = 0, "Sentinel" = 0, "Defender" = 0),
		list("Hivelord" = 0, "Burrower" = 0, "Carrier" = 0, "Lurker" = 0, "Spitter" = 0, "Warrior" = 0),
		list("Boiler" = 0, "Crusher" = 0, "Praetorian" = 0, "Ravager" = 0)
	)

	for(var/mob/living/carbon/Xenomorph/X in totalXenos)
		//don't show xenos in the thunderdome when admins test stuff.
		if(is_admin_level(X.z))
			continue
		if(X.caste)
			xeno_counts[X.caste.tier+1][X.caste.caste_name]++

	return xeno_counts

// Returns a sorted list of some basic info (stuff that's needed for sorting) about all the xenos in the hive
// The idea is that we sort this list, and use it as a "key" for all the other information (especially the nicknumber)
// in the hive status UI. That way we can minimize the amount of sorts performed by only calling this when xenos are created/disposed
/datum/hive_status/proc/get_xeno_keys()
	var/list/xenos[totalXenos.len]

	var/index = 1
	var/useless_slots = 0
	for(var/mob/living/carbon/Xenomorph/X in totalXenos)
		if(is_admin_level(X.z))
			useless_slots++
			continue

		// Insert without doing list merging
		xenos[index++] = list(
			"nicknumber" = X.nicknumber,
			"tier" = X.tier, // This one is only important for sorting
			"leader" = (IS_XENO_LEADER(X)),
			"is_queen" = istype(X.caste, /datum/caste_datum/queen),
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
/datum/hive_status/proc/sort_xeno_keys(var/list/xenos)
	if(!length(xenos))
		return

	var/list/sorted_list = xenos.Copy()

	if(!length(sorted_list))
		return

	for(var/index in 2 to sorted_list.len)
		var/j = index

		while(j > 1)
			// Queen comes first, always
			if(sorted_list[j]["is_queen"])
				sorted_list.Swap(j-1, j)
				j--
				continue

			var/info = sorted_list[j-1]

			// don't muck up queen's slot
			if(info["is_queen"])
				j--
				continue

			// Leaders before normal xenos
			if(!info["leader"] && sorted_list[j]["leader"])
				sorted_list.Swap(j-1, j)
				j--
				continue

			// Make sure we're only comparing leaders to leaders and non-leaders to non-leaders when sorting by tier
			// This means we get leaders sorted by tier first, then non-leaders sorted by tier

			// Sort by tier otherwise, higher tiers first
			if((sorted_list[j]["leader"] || !info["leader"]) && (info["tier"] < sorted_list[j]["tier"]))
				sorted_list.Swap(j-1, j)

			j--

	return sorted_list

// Returns a list with some more info about all xenos in the hive
/datum/hive_status/proc/get_xeno_info()
	var/list/xenos = list()

	for(var/mob/living/carbon/Xenomorph/X in totalXenos)
		if(is_admin_level(X.z))
			continue

		var/xeno_name = X.name
		// goddamn fucking larvas with their weird ass maturing system
		// its name updates with its icon, unlike other castes which only update the mature/elder, etc. prefix on evolve
		if(istype(X, /mob/living/carbon/Xenomorph/Larva))
			xeno_name = "Larva ([X.nicknumber])"

		xenos["[X.nicknumber]"] = list(
			"name" = xeno_name,
			"strain" = X.mutation_type,
			"ref" = "\ref[X]"
		)

	return xenos

/datum/hive_status/proc/set_hive_location(var/obj/effect/alien/resin/special/pylon/core/C)
	if(!C || C == hive_location)
		return
	var/area/A = get_area(C)
	xeno_message(SPAN_XENOANNOUNCE("The Queen has set the hive location as \the [A]."), 3, hivenumber)
	hive_location = C
	hive_ui.update_hive_location()

// Returns a list of xeno healths and locations
/datum/hive_status/proc/get_xeno_vitals()
	var/list/xenos = list()

	for(var/mob/living/carbon/Xenomorph/X in totalXenos)
		if(is_admin_level(X.z))
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

// Returns a list of slots for tier 2 and 3
/datum/hive_status/proc/get_tier_slots()
	var/list/slots = list(0, 0)

	var/pooled_factor = min(stored_larva, sqrt(4*stored_larva))
	pooled_factor = round(pooled_factor)

	var/used_tier_2_slots = length(tier_2_xenos)
	var/used_tier_3_slots = length(tier_3_xenos)
	for(var/caste_path in used_free_slots)
		if(!used_free_slots[caste_path])
			continue
		var/datum/caste_datum/C = caste_path
		switch(initial(C.tier))
			if(2) used_tier_2_slots--
			if(3) used_tier_3_slots--

	var/effective_total = length(totalXenos) + pooled_factor

	// no division by zero here, sir, nope.
	if(!effective_total)
		return slots

	// Tier 3 slots are always 25% of the total xenos in the hive
	slots[2] = max(0, Ceiling(0.25*length(totalXenos)/tier_slot_multiplier) - used_tier_3_slots)
	// Tier 2 slots are between 25% and 50% of the hive, depending
	// on how many T3s there are.
	slots[1] = max(0, Ceiling(0.5*effective_total/tier_slot_multiplier) - used_tier_2_slots - used_tier_3_slots)

	return slots

// returns if that location can be used to plant eggs
/datum/hive_status/proc/in_egg_plant_range(var/turf/T)
	if(!istype(living_xeno_queen))
		return TRUE // xenos already dicked without queen. Let them plant whereever

	if(!living_xeno_queen.ovipositor)
		return FALSE // ovid queen only

	return get_dist(living_xeno_queen, T) <= egg_planting_range

/datum/hive_status/proc/can_build_structure(var/structure_name)
	if(!structure_name || !hive_structures_limit[structure_name])
		return FALSE
	var/total_count = 0
	if(hive_structures[structure_name])
		total_count += hive_structures[structure_name].len
	if(hive_constructions[structure_name])
		total_count += hive_constructions[structure_name].len
	if(total_count >= hive_structures_limit[structure_name])
		return FALSE
	return TRUE

/datum/hive_status/proc/has_structure(var/structure_name)
	if(!structure_name)
		return FALSE
	if(hive_structures[structure_name] && hive_structures[structure_name].len)
		return TRUE
	return FALSE

/datum/hive_status/proc/add_construction(var/obj/effect/alien/resin/construction/S)
	if(!S || !S.template)
		return FALSE
	var/name_ref = initial(S.template.name)
	if(!hive_constructions[name_ref])
		hive_constructions[name_ref] = list()
	if(hive_constructions[name_ref].len >= hive_structures_limit[name_ref])
		return FALSE
	hive_constructions[name_ref] += src
	return TRUE

/datum/hive_status/proc/remove_construction(var/obj/effect/alien/resin/construction/S)
	if(!S || !S.template)
		return FALSE
	var/name_ref = initial(S.template.name)
	hive_constructions[name_ref] -= src
	return TRUE

/datum/hive_status/proc/add_special_structure(var/obj/effect/alien/resin/special/S)
	if(!S)
		return FALSE
	var/name_ref = initial(S.name)
	if(!hive_structures[name_ref])
		hive_structures[name_ref] = list()
	if(hive_structures[name_ref].len >= hive_structures_limit[name_ref])
		return FALSE
	hive_structures[name_ref] += S
	return TRUE

/datum/hive_status/proc/remove_special_structure(var/obj/effect/alien/resin/special/S)
	if(!S)
		return FALSE
	var/name_ref = initial(S.name)
	hive_structures[name_ref] -= S
	return TRUE

/datum/hive_status/proc/has_special_structure(var/name_ref)
	if(!name_ref || !hive_structures[name_ref] || !hive_structures[name_ref].len)
		return 0
	return hive_structures[name_ref].len

/datum/hive_status/proc/abandon_on_hijack()
	var/area/hijacked_dropship = get_area(living_xeno_queen)
	for(var/name_ref in hive_structures)
		for(var/obj/effect/alien/resin/special/S in hive_structures[name_ref])
			if(get_area(S) == hijacked_dropship)
				continue
			hive_structures[name_ref] -= S
			qdel(S)
	for(var/i in totalXenos)
		var/mob/living/carbon/Xenomorph/xeno = i
		if(get_area(xeno) != hijacked_dropship && xeno.loc && is_ground_level(xeno.loc.z))
			to_chat(xeno, SPAN_XENOANNOUNCE("The Queen has left without you, you quickly find a hiding place to enter hibernation as you lose touch with the hive mind."))
			qdel(xeno)
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
			qdel(embryo)
		potential_host.death("larva suicide")

/mob/living/carbon/proc/ally_of_hivenumber(var/hivenumber)
	var/datum/hive_status/H = GLOB.hive_datum[hivenumber]
	if(!H)
		return FALSE

	return H.is_ally(src)

/datum/hive_status/proc/is_ally(var/mob/living/carbon/C)
	if(isXeno(C) && C.hivenumber == hivenumber)
		var/mob/living/carbon/Xenomorph/X = C
		return !X.banished

	if(!C.faction)
		return FALSE

	return faction_is_ally(C.faction)

/datum/hive_status/proc/faction_is_ally(var/faction)
	if(!living_xeno_queen)
		return FALSE

	return allies[faction]

/datum/hive_status/corrupted
	name = "Corrupted Hive"
	hivenumber = XENO_HIVE_CORRUPTED
	prefix = "Corrupted "
	color = "#80ff80"

/datum/hive_status/corrupted/add_xeno(mob/living/carbon/Xenomorph/X)
	. = ..()
	X.add_language("English")

/datum/hive_status/corrupted/remove_xeno(mob/living/carbon/Xenomorph/X, hard)
	. = ..()
	X.remove_language("English")

/datum/hive_status/alpha
	name = "Alpha Hive"
	hivenumber = XENO_HIVE_ALPHA
	prefix = "Alpha "
	color = "#ff4040"

	dynamic_evolution = FALSE

/datum/hive_status/bravo
	name = "Bravo Hive"
	hivenumber = XENO_HIVE_BRAVO
	prefix = "Bravo "
	color = "#ffff80"

	dynamic_evolution = FALSE

/datum/hive_status/charlie
	name = "Charlie Hive"
	hivenumber = XENO_HIVE_CHARLIE
	prefix = "Charlie "
	color = "#bb40ff"

	dynamic_evolution = FALSE

/datum/hive_status/delta
	name = "Delta Hive"
	hivenumber = XENO_HIVE_DELTA
	prefix = "Delta "
	color = "#8080ff"

	dynamic_evolution = FALSE

