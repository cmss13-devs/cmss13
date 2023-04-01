#define JOIN_AS_FACEHUGGER_DELAY 3 MINUTES

// Actual caste datum basedef
/datum/caste_datum
	var/caste_type = ""
	var/display_name = ""
	var/tier = 0
	var/dead_icon = "Drone Dead"
	var/language = LANGUAGE_XENOMORPH
	var/melee_damage_lower = 10
	var/melee_damage_upper = 20
	///allows fine tuning melee damage to vehicles per caste.
	var/melee_vehicle_damage = 10
	var/evasion = XENO_EVASION_NONE

	var/speed = XENO_SPEED_TIER_10

	var/plasma_max = 10
	var/plasma_gain = 5

	var/crystal_max = 0

	var/max_health = XENO_UNIVERSAL_HPMULT * 100
	///Are they allowed to evolve (and have their evolution progress group)
	var/evolution_allowed = 1
	///Threshold to next evolution
	var/evolution_threshold = 0
	/// whether they can get evo points without needing an ovi queen
	var/evolve_without_queen = FALSE
	///This is where you add castes to evolve into. "Separated", "by", "commas"
	var/list/evolves_to = list()
	/// what caste or castes to de-evolve to.
	var/list/deevolves_to = list()
	///If they can use consoles, etc. Set on Queen
	var/is_intelligent = 0
	var/caste_desc = null

	// Tackles
	var/tackle_min = 2
	var/tackle_max = 6
	var/tackle_chance = 35
	var/tacklestrength_min = 2
	var/tacklestrength_max = 3

	///Chance of deflecting projectiles.
	var/armor_deflection = 0
	var/fire_immunity = FIRE_IMMUNITY_NONE
	var/fire_intensity_resistance = 0

	///Delay timer for spitting
	var/spit_delay = 60

	/// Windup for spits
	var/spit_windup = FALSE

	///The strength of our aura. Zero means we can't emit one
	var/aura_strength = 0

	///"Evolving" removed for the time being
	var/aura_allowed = list("frenzy", "warding", "recovery")

	///Adjust pixel size. 0.x is smaller, 1.x is bigger, percentage based.
	var/adjust_size_x = 1
	var/adjust_size_y = 1

	///list of datum projectile types the xeno can use.
	var/list/spit_types

	var/attack_delay = 0 //Bonus or pen to time in between attacks. + makes slashes slower.

	var/agility_speed_increase = 0 // this opens up possibilities for balancing

	// The type of mutator delegate to instantiate on the base caste. Will
	// be replaced when the Xeno chooses a strain.
	var/behavior_delegate_type = /datum/behavior_delegate

	// Resin building-related vars
	/// Default build time and build distance
	var/build_time_mult = BUILD_TIME_MULT_XENO
	var/max_build_dist = 0

	// Carrier vars //

	/// if a hugger is held in hand, won't attempt to leap and kill itself
	var/hugger_nurturing = FALSE
	var/huggers_max = 0
	var/throwspeed = 0
	var/hugger_delay = 0
	var/eggs_max = 0
	var/egg_cooldown = 30
	///Armor but for explosions
	var/xeno_explosion_resistance = 0

	//Queen vars
	var/can_hold_facehuggers = 0
	var/can_hold_eggs = CANNOT_HOLD_EGGS

	var/can_be_queen_healed = TRUE
	var/can_be_revived = TRUE

	var/can_vent_crawl = 1

	var/caste_luminosity = 0

	/// if fire_immunity is set to be vulnerable, how much will fire damage be multiplied. Defines in xeno.dm
	var/fire_vulnerability_mult = 0

	var/burrow_cooldown = 5 SECONDS
	var/tunnel_cooldown = 100
	var/widen_cooldown = 10 SECONDS
	///Big strong ability, big cooldown.
	var/tremor_cooldown = 30 SECONDS
	///whether the xeno heals even outside weeds.
	var/innate_healing = FALSE

	var/acid_level = 0
	var/weed_level = WEED_LEVEL_STANDARD
	///Time it takes between acid splash retaliate procs. Variable per caste, for if we want future castes that are acid bombs
	var/acid_splash_cooldown = 3 SECONDS

	// regen vars

	var/heal_delay_time = 0 SECONDS
	var/heal_resting = 1
	var/heal_standing = 0.4
	var/heal_knocked_out = 0.33

	var/list/resin_build_order
	var/minimum_xeno_playtime = 0

// cannot evolve to this caste until the round has been going on for this amount of time
	// IMPORTANT: this is ROUND_TIME, not world.time
	var/minimum_evolve_time = 1 MINUTES
	/// Iconstate for the xeno on the minimap
	var/minimap_icon = "xeno"
	///The iconstate for leadered xenos on the minimap, added as overlay
	var/minimap_leadered_overlay = "xenoleader"


/datum/caste_datum/can_vv_modify()
	return FALSE

/datum/caste_datum/New()
	. = ..()

	//Initialise evolution and upgrade thresholds in one place, once and for all
	evolution_threshold = 0
	if(evolution_allowed)
		switch(tier)
			if(0)
				evolution_threshold = 60
			if(1)
				evolution_threshold = 200
			if(2)
				evolution_threshold = 500
			//Other tiers (T3, Queen, etc.) can't evolve anyway

	resin_build_order = GLOB.resin_build_order_drone

/client/var/cached_xeno_playtime

/// playtime for all castes
/client/proc/get_total_xeno_playtime(skip_cache = FALSE)
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

/// playtime for drone and drone evolution castes
/client/proc/get_total_drone_playtime()
	var/total_drone_playtime = 0

	var/list/drone_evo_castes = list(XENO_CASTE_DRONE, XENO_CASTE_CARRIER, XENO_CASTE_BURROWER, XENO_CASTE_HIVELORD, XENO_CASTE_QUEEN)

	for(var/caste in RoleAuthority.castes_by_name)
		if(!(caste in drone_evo_castes))
			continue
		total_drone_playtime += get_job_playtime(src, caste)

	return total_drone_playtime

/// playtime for t3 castes and queen
/client/proc/get_total_t3_playtime()
	var/total_t3_playtime = 0
	var/datum/caste_datum/caste
	for(var/caste_name in RoleAuthority.castes_by_name)
		caste = RoleAuthority.castes_by_name[caste_name]
		if(caste.tier < 3)
			continue
		total_t3_playtime += get_job_playtime(src, caste_name)

	return total_t3_playtime

/datum/caste_datum/proc/can_play_caste(client/client)
	if(!CONFIG_GET(flag/use_timelocks))
		return TRUE

	var/total_xeno_playtime = client.get_total_xeno_playtime()

	if(minimum_xeno_playtime && total_xeno_playtime < minimum_xeno_playtime)
		return FALSE

	return TRUE

/datum/caste_datum/proc/get_caste_requirement(client/client)
	return minimum_xeno_playtime - client.get_total_xeno_playtime()

/datum/caste_datum/proc/get_minimap_icon()
	var/image/background = mutable_appearance('icons/ui_icons/map_blips.dmi', "background")
	background.color = MINIMAP_ICON_BACKGROUND_XENO

	var/iconstate = minimap_icon ? minimap_icon : "unknown"
	var/mutable_appearance/icon = image('icons/ui_icons/map_blips.dmi', icon_state = iconstate)
	icon.appearance_flags = RESET_COLOR
	background.overlays += icon

	return background

/datum/hive_status
	var/name = "Normal Hive"

	// Used for the faction of the xenomorph. Not recommended to modify.
	var/internal_faction

	var/hivenumber = XENO_HIVE_NORMAL
	var/mob/living/carbon/xenomorph/queen/living_xeno_queen
	var/egg_planting_range = 15
	var/slashing_allowed = XENO_SLASH_ALLOWED //This initial var allows the queen to turn on or off slashing. Slashing off means harm intent does much less damage.
	var/construction_allowed = NORMAL_XENO //Who can place construction nodes for special structures
	var/destruction_allowed = XENO_LEADER //Who can destroy special structures
	var/unnesting_allowed = TRUE
	var/hive_orders = "" //What orders should the hive have
	var/color = null
	var/ui_color = null // Color for hive status collapsible buttons and xeno count list
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
	var/list/totalXenos = list()  //list of living xenos
	var/list/totalDeadXenos = list()//list of previously living xenos
	var/xeno_queen_timer
	var/isSlotOpen = TRUE //Set true for starting alerts only after the hive has reached its full potential
	var/allowed_nest_distance = 15 //How far away do we allow nests from an ovied Queen. Default 15 tiles.
	var/obj/effect/alien/resin/special/pylon/core/hive_location = null //Set to ref every time a core is built, for defining the hive location
	var/crystal_stored = 0 //How much stockpiled material is stored for the hive to use.
	var/xenocon_points = 0 //Xeno version of DEFCON

	var/datum/mutator_set/hive_mutators/mutators = new
	var/tier_slot_multiplier = 1
	var/larva_gestation_multiplier = 1
	var/bonus_larva_spawn_chance = 1
	var/hijack_burrowed_surge = FALSE //at hijack, start spawning lots of burrowed

	var/ignore_slots = FALSE
	var/dynamic_evolution = TRUE
	var/evolution_rate = 3 // Only has use if dynamic_evolution is false
	var/evolution_bonus = 0

	var/allow_no_queen_actions = FALSE
	var/evolution_without_ovipositor = TRUE //Temporary for the roundstart.
	var/allow_queen_evolve = TRUE // Set to true if you want to prevent evolutions into Queens
	var/hardcore = FALSE // Set to true if you want to prevent bursts and spawns of new xenos. Will also prevent healing if the queen no longer exists

	var/list/hive_inherant_traits

	// Cultist Info
	var/mob/living/carbon/leading_cult_sl

	//List of how many maximum of each special structure you can have
	var/list/hive_structures_limit = list(
		XENO_STRUCTURE_CORE = 1,
		XENO_STRUCTURE_CLUSTER = 8,
		XENO_STRUCTURE_POOL = 1,
		XENO_STRUCTURE_EGGMORPH = 6,
		XENO_STRUCTURE_EVOPOD = 2,
		XENO_STRUCTURE_RECOVERY = 6,
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

	var/datum/tacmap/tacmap
	var/minimap_type = MINIMAP_FLAG_XENO

/datum/hive_status/New()
	mutators.hive = src
	hive_ui = new(src)
	mark_ui = new(src)
	faction_ui = new(src)
	tacmap = new(src, minimap_type)
	if(!internal_faction)
		internal_faction = name
	if(hivenumber != XENO_HIVE_NORMAL)
		return

	RegisterSignal(SSdcs, COMSIG_GLOB_POST_SETUP, PROC_REF(setup_evolution_announcements))

/datum/hive_status/proc/setup_evolution_announcements()
	SIGNAL_HANDLER

	for(var/time in GLOB.xeno_evolve_times)
		if(time == "0")
			continue

		addtimer(CALLBACK(src, PROC_REF(announce_evolve_available), GLOB.xeno_evolve_times[time]), text2num(time))

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
		if(!living_xeno_queen && !is_admin_level(X.z)) // Don't consider xenos in admin level
			set_living_xeno_queen(X)

	X.hivenumber = hivenumber
	X.hive = src

	X.set_faction(internal_faction)

	if(X.hud_list)
		X.hud_update()

	var/area/A = get_area(X)
	if(!is_admin_level(X.z) || (A.flags_atom & AREA_ALLOW_XENO_JOIN))
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
			if(!is_admin_level(queen.z) && queen != src && !QDELETED(queen))
				next_queen = queen
				break

		set_living_xeno_queen(next_queen) // either null or a queen

	// We allow "soft" removals from the hive (the xeno still retains information about the hive)
	// This is so that xenos can add themselves back to the hive if they should die or otherwise go "on leave" from the hive
	if(hard)
		xeno.hivenumber = 0
		xeno.hive = null
	else
		totalDeadXenos += xeno

	totalXenos -= xeno
	if(xeno.tier == 2)
		tier_2_xenos -= xeno
	else if(xeno.tier == 3)
		tier_3_xenos -= xeno

	if(!light_mode)
		hive_ui.update_xeno_counts()
		hive_ui.xeno_removed(xeno)

/datum/hive_status/proc/set_living_xeno_queen(mob/living/carbon/xenomorph/queen/queen)
	if(!queen)
		mutators.reset_mutators()
		SStracking.delete_leader("hive_[hivenumber]")
		SStracking.stop_tracking("hive_[hivenumber]", living_xeno_queen)
		SShive_status.wait = 10 SECONDS
	else
		SStracking.set_leader("hive_[hivenumber]", queen)
		SShive_status.wait = 2 SECONDS

	living_xeno_queen = queen

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
		if(is_admin_level(X.z))
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
	var/list/xenos[totalXenos.len]

	var/index = 1
	var/useless_slots = 0
	for(var/mob/living/carbon/xenomorph/X in totalXenos)
		if(is_admin_level(X.z))
			var/area/A = get_area(X)
			if(!(A.flags_atom & AREA_ALLOW_XENO_JOIN))
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
		if(is_admin_level(X.z))
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
			"strain" = X.mutation_type,
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
		if(is_admin_level(X.z))
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

	var/burrowed_factor = min(stored_larva, sqrt(4*stored_larva))
	burrowed_factor = round(burrowed_factor)

	var/used_tier_2_slots = length(tier_2_xenos)
	var/used_tier_3_slots = length(tier_3_xenos)
	for(var/caste_path in used_free_slots)
		var/used_count = used_free_slots[caste_path]
		if(!used_count)
			continue
		var/datum/caste_datum/C = caste_path
		switch(initial(C.tier))
			if(2) used_tier_2_slots -= used_count
			if(3) used_tier_3_slots -= used_count

	for(var/caste_path in free_slots)
		var/slot_count = free_slots[caste_path]
		if(!slot_count)
			continue
		var/datum/caste_datum/C = caste_path
		switch(initial(C.tier))
			if(2) slots[TIER_2][GUARANTEED_SLOTS][initial(C.caste_type)] = slot_count
			if(3) slots[TIER_3][GUARANTEED_SLOTS][initial(C.caste_type)] = slot_count

	var/total_xenos = 0
	var/effective_total = burrowed_factor
	for(var/mob/living/carbon/xenomorph/xeno as anything in totalXenos)
		if(xeno.counts_for_slots)
			total_xenos++
			effective_total++

	// Tier 3 slots are always 20% of the total xenos in the hive
	slots[TIER_3][OPEN_SLOTS] = max(0, Ceiling(0.20*total_xenos/tier_slot_multiplier) - used_tier_3_slots)
	// Tier 2 slots are between 30% and 50% of the hive, depending
	// on how many T3s there are.
	slots[TIER_2][OPEN_SLOTS] = max(0, Ceiling(0.5*effective_total/tier_slot_multiplier) - used_tier_2_slots - used_tier_3_slots)

	return slots

#undef TIER_3
#undef TIER_2
#undef OPEN_SLOTS
#undef GUARANTEED_SLOTS

// returns if that location can be used to plant eggs
/datum/hive_status/proc/in_egg_plant_range(turf/T)
	if(!istype(living_xeno_queen))
		return TRUE // xenos already dicked without queen. Let them plant whereever

	if(!living_xeno_queen.ovipositor)
		return FALSE // ovid queen only

	return get_dist(living_xeno_queen, T) <= egg_planting_range

/datum/hive_status/proc/can_build_structure(structure_name)
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
	for(var/name_ref in hive_structures)
		for(var/obj/effect/alien/resin/special/S in hive_structures[name_ref])
			if(get_area(S) == hijacked_dropship)
				continue
			hive_structures[name_ref] -= S
			qdel(S)
	for(var/mob/living/carbon/xenomorph/xeno as anything in totalXenos)
		if(get_area(xeno) != hijacked_dropship && xeno.loc && is_ground_level(xeno.loc.z))
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
	hijack_burrowed_surge = TRUE
	hivecore_cooldown = FALSE
	xeno_message(SPAN_XENOBOLDNOTICE("The weeds have recovered! A new hive core can be built!"),3,hivenumber)

/datum/hive_status/proc/free_respawn(client/C)
	stored_larva++
	if(!hive_location || !hive_location.spawn_burrowed_larva(C.mob))
		stored_larva--
	else
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
		LAZYADD(turf_list, open_turf)
	var/turf/open/spawning_turf = pick(turf_list)

	var/mob/living/carbon/xenomorph/larva/new_xeno = spawn_hivenumber_larva(spawning_turf, hivenumber)
	if(isnull(new_xeno))
		return FALSE

	if(!SSticker.mode.transfer_xeno(xeno_candidate, new_xeno))
		qdel(new_xeno)
		return FALSE
	new_xeno.visible_message(SPAN_XENODANGER("A larva suddenly burrows out of \the [spawning_turf]!"),
	SPAN_XENODANGER("You burrow out of \the [spawning_turf] and awaken from your slumber. For the Hive!"))
	msg_admin_niche("[key_name(new_xeno)] burrowed out from \a [spawning_turf]. (<A HREF='?_src_=admin_holder;[HrefToken(forceGlobal = TRUE)];adminplayerobservecoodjump=1;X=[spawning_turf.x];Y=[spawning_turf.y];Z=[spawning_turf.z]'>JMP</a>)")
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
	playable_hugger_limit = 2 + Ceiling(totalXenos.len / 4)

/datum/hive_status/proc/can_spawn_as_hugger(mob/dead/observer/user)
	if(!GLOB.hive_datum || ! GLOB.hive_datum[hivenumber])
		return
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

	update_hugger_limit()

	var/current_hugger_count = 0
	for(var/mob/mob as anything in totalXenos)
		if(isfacehugger(mob))
			current_hugger_count++
	if(playable_hugger_limit <= current_hugger_count)
		to_chat(user, SPAN_WARNING("\The [GLOB.hive_datum[hivenumber]] cannot support more facehuggers! Limit: <b>[current_hugger_count]/[playable_hugger_limit]</b>"))
		return FALSE

	if(alert(user, "Are you sure you want to become a facehugger?", "Confirmation", "Yes", "No") != "Yes")
		return FALSE
	return TRUE

/datum/hive_status/proc/spawn_as_hugger(mob/dead/observer/user, atom/A)
	var/mob/living/carbon/xenomorph/facehugger/hugger = new /mob/living/carbon/xenomorph/facehugger(A.loc, null, hivenumber)
	user.mind.transfer_to(hugger, TRUE)
	hugger.visible_message(SPAN_XENODANGER("A facehugger suddenly emerges out of \the [A]!"), SPAN_XENODANGER("You emerge out of \the [A] and awaken from your slumber. For the Hive!"))
	playsound(hugger, 'sound/effects/xeno_newlarva.ogg', 25, TRUE)
	hugger.generate_name()

/datum/hive_status/corrupted
	name = "Corrupted Hive"
	hivenumber = XENO_HIVE_CORRUPTED
	prefix = "Corrupted "
	color = "#80ff80"
	ui_color ="#4d994d"

	need_round_end_check = TRUE

/datum/hive_status/corrupted/add_xeno(mob/living/carbon/xenomorph/X)
	. = ..()
	X.add_language(LANGUAGE_ENGLISH)

/datum/hive_status/corrupted/remove_xeno(mob/living/carbon/xenomorph/X, hard)
	. = ..()
	X.remove_language(LANGUAGE_ENGLISH)

/datum/hive_status/corrupted/can_delay_round_end(mob/living/carbon/xenomorph/xeno)
	if(!faction_is_ally(FACTION_MARINE, TRUE))
		return TRUE
	return FALSE

/datum/hive_status/alpha
	name = "Alpha Hive"
	hivenumber = XENO_HIVE_ALPHA
	prefix = "Alpha "
	color = "#ff4040"
	ui_color = "#992626"

	dynamic_evolution = FALSE

/datum/hive_status/bravo
	name = "Bravo Hive"
	hivenumber = XENO_HIVE_BRAVO
	prefix = "Bravo "
	color = "#ffff80"
	ui_color = "#99994d"

	dynamic_evolution = FALSE

/datum/hive_status/charlie
	name = "Charlie Hive"
	hivenumber = XENO_HIVE_CHARLIE
	prefix = "Charlie "
	color = "#bb40ff"
	ui_color = "#702699"

	dynamic_evolution = FALSE

/datum/hive_status/delta
	name = "Delta Hive"
	hivenumber = XENO_HIVE_DELTA
	prefix = "Delta "
	color = "#8080ff"
	ui_color = "#4d4d99"

	dynamic_evolution = FALSE

/datum/hive_status/feral
	name = "Feral Hive"
	hivenumber = XENO_HIVE_FERAL
	prefix = "Feral "
	color = "#828296"
	ui_color = "#828296"

	construction_allowed = XENO_NOBODY
	destruction_allowed = XENO_NOBODY
	dynamic_evolution = FALSE
	allow_no_queen_actions = TRUE
	allow_queen_evolve = FALSE
	ignore_slots = TRUE

/datum/hive_status/forsaken
	name = "Forsaken Hive"
	hivenumber = XENO_HIVE_FORSAKEN
	prefix = "Forsaken "
	color = "#cc8ec4"
	ui_color = "#cc8ec4"

	dynamic_evolution = FALSE
	allow_no_queen_actions = TRUE
	allow_queen_evolve = FALSE
	ignore_slots = TRUE

	need_round_end_check = TRUE

/datum/hive_status/forsaken/can_delay_round_end(mob/living/carbon/xenomorph/xeno)
	return FALSE

/datum/hive_status/yautja
	name = "Hellhound Pack"
	hivenumber = XENO_HIVE_YAUTJA
	internal_faction = FACTION_YAUTJA

	dynamic_evolution = FALSE
	allow_no_queen_actions = TRUE
	allow_queen_evolve = FALSE
	ignore_slots = TRUE

	need_round_end_check = TRUE

/datum/hive_status/yautja/can_delay_round_end(mob/living/carbon/xenomorph/xeno)
	return FALSE

/datum/hive_status/mutated
	name = "Mutated Hive"
	hivenumber = XENO_HIVE_MUTATED
	prefix = "Mutated "
	color = "#6abd99"
	ui_color = "#6abd99"

	hive_inherant_traits = list(TRAIT_XENONID, TRAIT_NO_COLOR)

/datum/hive_status/corrupted/tamed
	name = "Tamed Hive"
	hivenumber = XENO_HIVE_TAMED
	prefix = "Tamed "
	color = "#80ff80"

	dynamic_evolution = FALSE
	allow_no_queen_actions = TRUE
	allow_queen_evolve = FALSE
	ignore_slots = TRUE

	var/mob/living/carbon/human/leader
	var/list/allied_factions

/datum/hive_status/corrupted/tamed/New()
	. = ..()
	hive_structures_limit[XENO_STRUCTURE_EGGMORPH] = 0
	hive_structures_limit[XENO_STRUCTURE_EVOPOD] = 0

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



