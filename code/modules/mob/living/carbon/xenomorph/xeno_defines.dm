
// Actual caste datum basedef
/datum/caste_datum
	var/caste_name = ""
	var/display_name = ""
	var/upgrade_name = "Young"
	var/tier = 0
	var/upgrade = 0
	var/dead_icon = "Drone Dead"
	var/language = "Xenomorph"

	var/list/minimum_playtimes = list()

	var/melee_damage_lower = 10
	var/melee_damage_upper = 20
	var/evasion = XENO_EVASION_NONE

	var/bite_chance = 5 //Chance of doing a special bite attack in place of a claw. Set to 0 to disable.
	var/tail_chance = 10 //Chance of doing a special tail attack in place of a claw. Set to 0 to disable.
	var/rng_min_interval = 70 // 7 seconds

	var/speed = XENO_SPEED_SANICFAST
	var/speed_mod = XENO_SPEED_MOD_LARGE

	var/plasma_max = 10
	var/plasma_gain = 5

	var/crystal_max = 0

	var/max_health = XENO_UNIVERSAL_HPMULT * 100

	var/evolution_allowed = 1 //Are they allowed to evolve (and have their evolution progress group)
	var/evolution_threshold = 0 //Threshold to next evolution

	var/upgrade_threshold = 0

	var/list/evolves_to = list() //This is where you add castes to evolve into. "Seperated", "by", "commas"
	var/deevolves_to // what caste to de-evolve to.
	var/tacklemin = 2
	var/tacklemax = 3
	var/tackle_chance = 35
	var/is_intelligent = 0 //If they can use consoles, etc. Set on Queen
	var/caste_desc = null

	var/charge_type = 0 //0: normal. 1: warrior/hunter style pounce. 2: ravager free attack.
	var/armor_deflection = 0 //Chance of deflecting projectiles.
	var/armor_hardiness_mult = XENO_ARMOR_FACTOR_LOW //so our armor is stronger
	var/fire_immune = 0 //Boolean

	var/spit_delay = 60 //Delay timer for spitting

	var/is_robotic = 0 //Robots use charge, not plasma (same thing sort of), and can only be healed with welders.

	var/aura_strength = 0 //The strength of our aura. Zero means we can't emit one
	var/aura_allowed = list("frenzy", "warding", "recovery") //"Evolving" removed for the time being

	var/adjust_size_x = 1 //Adjust pixel size. 0.x is smaller, 1.x is bigger, percentage based.
	var/adjust_size_y = 1
	var/list/spit_types //list of datum projectile types the xeno can use.

	var/attack_delay = 0 //Bonus or pen to time in between attacks. + makes slashes slower.

	var/pounce_delay = 40

	var/agility_speed_increase = 0 // this opens up possibilities for balancing
	var/lunge_cooldown = 40
	var/fling_cooldown = 40
	var/punch_cooldown = 40
	var/jab_cooldown = 40
	var/toggle_agility_cooldown = 5

	// Resin building-related vars
	var/build_time = BUILD_TIME_XENO // Default build time and build distance
	var/max_build_dist = 0

	//Boiler vars
	var/bomb_strength = 0 //Multiplier to the effectiveness of the boiler glob. Improves by 0.5 per upgrade

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
	var/can_denest_hosts = 0
	
	var/caste_luminosity = 0

	var/burrow_cooldown = 50
	var/tunnel_cooldown = 100
	var/widen_cooldown = 100
	var/tremor_cooldown = 450 //Big strong ability, big cooldown.


	var/headbutt_cooldown = 40
	var/tail_sweep_cooldown = 120
	var/crest_defense_cooldown = 150
	var/fortify_cooldown = 200

	var/innate_healing = FALSE //whether the xeno heals even outside weeds.

	var/acid_spray_range = 3
	var/acid_spray_cooldown = 90 //9 seconds delay on acid. Reduced by -1 per upgrade down to 5 seconds
	var/acid_level = 0
	var/weed_level = 0

	var/pounce_speed = SPEED_VERY_FAST

	var/charge_speed = 0.5
	var/charge_distance = 6

	//New variables for how charges work, max speed, speed buildup, all that jazz
	var/charge_speed_max = 1.5 //Can only gain this much speed before capping
	var/charge_speed_buildup = 0.15 //POSITIVE amount of speed built up during a charge each step
	var/charge_turfs_to_charge = 5 //Amount of turfs to build up before a charge begins

	var/acid_splash_cooldown = SECONDS_5 //Time it takes between acid splash retaliate procs. Variable per caste, for if we want future castes that are acid bombs

	/////////////////////////////////////////////////////////////////////////
	//
	//    Scalars
	//
	//	These define custom scaling for different age level on a per-caste
	//  basis. If the value isn't defined on the caste datum, it will take
	//  the default scaling value.
	//
	/////////////////////////////////////////////////////////////////////////
	var/melee_damage_scalar
	var/max_health_scalar
	var/plasma_gain_scalar
	var/plasma_max_scalar
	var/crystal_max_scalar
	var/explosion_armor_scalar
	var/armor_scalar
	var/armorfactor_scalar
	var/evasion_scalar

/datum/caste_datum/New()
	. = ..()
	apply_scalars_and_speed()

	//Initialise evolution and upgrade thresholds in one place, once and for all
	evolution_threshold = 0
	if(evolution_allowed)
		switch(tier)
			if(1)
				evolution_threshold = 200
			if(2)
				evolution_threshold = 500
			//Other tiers (T3, Queen, etc.) can't evolve anyway

	upgrade_threshold = 0

	switch(tier)
		if(1)
			switch(upgrade)
				if(0)
					upgrade_threshold = 100
				if(1)
					upgrade_threshold = 200
				if(2)
					upgrade_threshold = 400
		if(2)
			switch(upgrade)
				if(0)
					upgrade_threshold = 250
				if(1)
					upgrade_threshold = 500
				if(2)
					upgrade_threshold = 1000
		if(3)
			switch(upgrade)
				if(0)
					upgrade_threshold = 400
				if(1)
					upgrade_threshold = 800
				if(2)
					upgrade_threshold = 1600
	if(caste_name == "Queen")
		switch(upgrade)
			if(0)
				upgrade_threshold = 800
			if(1)
				upgrade_threshold = 1600
			if(2)
				upgrade_threshold = 3200

/datum/caste_datum/proc/can_play_caste(var/client/client)
	if(!config.use_timelocks)
		return TRUE
	var/datum/entity/player_entity/selected_entity = client.player_entity
	if(!minimum_playtimes.len || (client.admin_holder && (client.admin_holder.rights & R_ADMIN)) || selected_entity.get_playtime(STATISTIC_XENO, caste_name) > 0)
		return TRUE
	for(var/prereq in minimum_playtimes)
		if(selected_entity.get_playtime(STATISTIC_XENO, prereq) < minimum_playtimes[prereq])
			return FALSE
	return TRUE

/datum/caste_datum/proc/get_caste_requirements(var/client/client)
	var/datum/entity/player_entity/selected_entity = client.player_entity
	var/list/return_requirements = list()
	for(var/prereq in minimum_playtimes)
		if(selected_entity.get_playtime(STATISTIC_XENO, prereq) < minimum_playtimes[prereq])
			return_requirements["[prereq]"] = minimum_playtimes[prereq] - selected_entity.get_playtime(STATISTIC_XENO, prereq)
	return return_requirements

// Populates all the default scaling values on a caste datum
// if they aren't already set.
// Scaling vars should be defined on each
/datum/caste_datum/proc/apply_scalars_and_speed()

	// I'm so sorry for this code but its necessary to have these all in defines, which is very desired
	// Formula
	// final_value_on_xeno = modifier + caste_base_value * (caste_scaler_val ? caste_scaler_val : default_val)

	// All the scalars currently implemented:
	//var/melee_damage_scalar
	//var/max_health_scalar
	//var/plasma_gain_scalar
	//var/plasma_max_scalar
	//var/crystal_max_scalar
	//var/explosion_armor_scalar
	//var/armor_scalar
	//var/evasion_scalar
	//var/armorfactor_scalar

	speed = speed - speed_mod * upgrade
	// Armor we can set here because it's not age-dependent unless we make it so by setting scalars
	if (!armor_scalar)
		armor_scalar = 1.0
	if (!explosion_armor_scalar)
		explosion_armor_scalar = 1.0

	switch(upgrade)
		if (0) // Yung

			if (!melee_damage_scalar)
				melee_damage_scalar = XENO_MULTIPLIER_DAMAGE_YOUNG
			if (!max_health_scalar)
				max_health_scalar = XENO_MULTIPLIER_HEALTH_YOUNG
			if (!plasma_gain_scalar)
				plasma_gain_scalar = XENO_MULTIPLIER_PLASMA_GAIN_YOUNG
			if (!plasma_max_scalar)
				plasma_max_scalar = XENO_MULTIPLIER_PLASMA_YOUNG
			if (!crystal_max_scalar)
				crystal_max_scalar = XENO_MULTIPLIER_PLASMA_YOUNG
			if (!evasion_scalar)
				evasion_scalar = XENO_MULTIPLIER_EVASION_YOUNG
			if (!armorfactor_scalar)
				armorfactor_scalar = XENO_MULTIPLIER_ARMOR_FACTOR_YOUNG

		if (1) // Mature
			if (!melee_damage_scalar)
				melee_damage_scalar = XENO_MULTIPLIER_DAMAGE_MATURE
			if (!max_health_scalar)
				max_health_scalar = XENO_MULTIPLIER_HEALTH_MATURE
			if (!plasma_gain_scalar)
				plasma_gain_scalar = XENO_MULTIPLIER_PLASMA_GAIN_MATURE
			if (!plasma_max_scalar)
				plasma_max_scalar = XENO_MULTIPLIER_PLASMA_MATURE
			if (!crystal_max_scalar)
				crystal_max_scalar = XENO_MULTIPLIER_PLASMA_MATURE
			if (!evasion_scalar)
				evasion_scalar = XENO_MULTIPLIER_EVASION_MATURE
			if (!armorfactor_scalar)
				armorfactor_scalar = XENO_MULTIPLIER_ARMOR_FACTOR_MATURE

		if (2) // Elder/Elite
			if (!melee_damage_scalar)
				melee_damage_scalar = XENO_MULTIPLIER_DAMAGE_ELDER
			if (!max_health_scalar)
				max_health_scalar = XENO_MULTIPLIER_HEALTH_ELDER
			if (!plasma_gain_scalar)
				plasma_gain_scalar = XENO_MULTIPLIER_PLASMA_GAIN_ELDER
			if (!plasma_max_scalar)
				plasma_max_scalar = XENO_MULTIPLIER_PLASMA_ELDER
			if (!crystal_max_scalar)
				crystal_max_scalar = XENO_MULTIPLIER_PLASMA_ELDER
			if (!evasion_scalar)
				evasion_scalar = XENO_MULTIPLIER_EVASION_ELDER
			if (!armorfactor_scalar)
				armorfactor_scalar = XENO_MULTIPLIER_ARMOR_FACTOR_ELDER

		if (3) // Ancient
			if (!melee_damage_scalar)
				melee_damage_scalar = XENO_MULTIPLIER_DAMAGE_ANCIENT
			if (!max_health_scalar)
				max_health_scalar = XENO_MULTIPLIER_HEALTH_ANCIENT
			if (!plasma_gain_scalar)
				plasma_gain_scalar = XENO_MULTIPLIER_PLASMA_GAIN_ANCIENT
			if (!plasma_max_scalar)
				plasma_max_scalar = XENO_MULTIPLIER_PLASMA_ANCIENT
			if (!crystal_max_scalar)
				crystal_max_scalar = XENO_MULTIPLIER_PLASMA_ANCIENT
			if (!evasion_scalar)
				evasion_scalar = XENO_MULTIPLIER_EVASION_ANCIENT
			if (!armorfactor_scalar)
				armorfactor_scalar = XENO_MULTIPLIER_ARMOR_FACTOR_ANCIENT

		if (4) // Primordial
			if (!melee_damage_scalar)
				melee_damage_scalar = XENO_MULTIPLIER_DAMAGE_PRIMORDIAL
			if (!max_health_scalar)
				max_health_scalar = XENO_MULTIPLIER_HEALTH_PRIMORDIAL
			if (!plasma_gain_scalar)
				plasma_gain_scalar = XENO_MULTIPLIER_PLASMA_PRIMORDIAL
			if (!plasma_max_scalar)
				plasma_max_scalar = XENO_MULTIPLIER_PLASMA_PRIMORDIAL
			if (!crystal_max_scalar)
				crystal_max_scalar = XENO_MULTIPLIER_PLASMA_PRIMORDIAL
			if (!evasion_scalar)
				evasion_scalar = XENO_MULTIPLIER_EVASION_PRIMORDIAL
			if (!armorfactor_scalar)
				armorfactor_scalar = XENO_MULTIPLIER_ARMOR_FACTOR_PRIMORDIAL
		else
			melee_damage_scalar = 1
			max_health_scalar = 1
			plasma_gain_scalar = 1
			plasma_max_scalar = 1
			crystal_max_scalar = 1
			evasion_scalar = 1
			armorfactor_scalar = 1

	melee_damage_lower = melee_damage_lower * melee_damage_scalar
	melee_damage_upper = melee_damage_upper * melee_damage_scalar
	plasma_gain = plasma_gain * plasma_gain_scalar
	plasma_max = plasma_max * plasma_max_scalar
	crystal_max = crystal_max * crystal_max_scalar
	armor_deflection = armor_deflection * armor_scalar
	xeno_explosion_resistance = xeno_explosion_resistance * explosion_armor_scalar
	max_health = max_health * max_health_scalar
	evasion = evasion * evasion_scalar
	armor_hardiness_mult = armor_hardiness_mult * armorfactor_scalar

/datum/hive_status
	var/hivenumber = XENO_HIVE_NORMAL
	var/mob/living/carbon/Xenomorph/Queen/living_xeno_queen
	var/egg_planting_range = 15
	var/slashing_allowed = 1 //This initial var allows the queen to turn on or off slashing. Slashing off means harm intent does much less damage.
	var/construction_allowed = 0 //Who can place construction nodes for special structures. 0 for Queen, 1 for Leaders, 2 for all.
	var/queen_time = 300 //5 minutes between queen deaths
	var/xeno_queen_timer
	var/hive_orders = "" //What orders should the hive have
	var/color = null
	var/prefix = ""
	var/queen_leader_limit = 2
	var/list/open_xeno_leader_positions = list(1, 2) // Ordered list of xeno leader positions (indexes in xeno_leader_list) that are not occupied
	var/list/xeno_leader_list[2] // Ordered list (i.e. index n holds the nth xeno leader)
	var/stored_larva = 0
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

	//List of how many maximum of each special structure you can have
	var/list/hive_structures_limit = list(
		XENO_STRUCTURE_CORE = 1,
		XENO_STRUCTURE_PYLON = 8,
		XENO_STRUCTURE_POOL = 1,
		XENO_STRUCTURE_EGGMORPH = 6,
		XENO_STRUCTURE_EVOPOD = 5,
		XENO_STRUCTURE_RECOVERY = 6
	)

	var/global/list/hive_structure_types = list(
		XENO_STRUCTURE_CORE = /datum/construction_template/xenomorph/core,
		XENO_STRUCTURE_PYLON = /datum/construction_template/xenomorph/pylon,
		XENO_STRUCTURE_POOL = /datum/construction_template/xenomorph/pool,
		XENO_STRUCTURE_EGGMORPH = /datum/construction_template/xenomorph/eggmorph,
		XENO_STRUCTURE_EVOPOD = /datum/construction_template/xenomorph/evopod,
		XENO_STRUCTURE_RECOVERY = /datum/construction_template/xenomorph/recovery
	)

	var/list/hive_structures = list() //Stringref list of structures that have been built
	var/list/hive_constructions = list() //Stringref list of structures that are being built
	var/list/datum/mind/spawn_list = list() //List of minds that are waiting to be respawned

	var/datum/hive_status_ui/hive_ui = new

/datum/hive_status/New()
	mutators.hive = src
	hive_ui.set_hive(src)

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

	// Can only have one queen
	if(istype(X, /mob/living/carbon/Xenomorph/Queen))
		if(living_xeno_queen)
			return
		set_living_xeno_queen(X)

	X.hivenumber = hivenumber
	X.hive = src

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

	if(istype(X, /mob/living/carbon/Xenomorph/Queen))
		set_living_xeno_queen(null)

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
		mutators.user_levelled_up(M.upgrade)
		SStracking.set_leader("hive_[hivenumber]", M)

	living_xeno_queen = M

	recalculate_hive()

/datum/hive_status/proc/recalculate_hive()
	if (!living_xeno_queen)
		queen_leader_limit = 0 //No leaders for a Hive without a Queen!
	else
		queen_leader_limit = 2 + living_xeno_queen.upgrade + mutators.leader_count_boost

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
	if (!IS_XENO_LEADER(xeno))
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

/datum/hive_status/proc/handle_nuke_alert(var/timing, var/area/loc)
	if (!totalXenos.len) //sanity check!
		return

	if(timing)
		xeno_announcement(SPAN_XENOANNOUNCE("The tallhosts have deployed a hive killer at [loc.name]! Stop it at all costs!"), hivenumber, XENO_GENERAL_ANNOUNCE)
	else
		xeno_announcement(SPAN_XENOANNOUNCE("The hive killer has been disabled! Rejoice!"), hivenumber, XENO_GENERAL_ANNOUNCE)

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
		if(X.z == ADMIN_Z_LEVEL)
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
		if(X.z == ADMIN_Z_LEVEL)
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
	if(sorted_keys && sorted_keys.len)
		return sorted_keys
	return xenos

// This sorts the xeno info list by multiple criteria. Prioritized in order:
// 1. Queen
// 2. Leaders
// 3. Tier
// It uses a slightly modified insertion sort to accomplish this
/datum/hive_status/proc/sort_xeno_keys(var/list/xenos)
	if(!xenos || !xenos.len)
		return

	var/list/sorted_list = xenos.Copy()

	if(!sorted_list || !sorted_list.len)
		return

	for(var/index = 2 to sorted_list.len)
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
		if(X.z == ADMIN_Z_LEVEL)
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
		if(X.z == ADMIN_Z_LEVEL)
			continue

		if(!X in living_xeno_list)
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

	var/effective_total = totalXenos.len + pooled_factor

	// no division by zero here, sir, nope.
	if(!effective_total)
		return slots

	// Tier 3 slots are always 25% of the total xenos in the hive
	slots[2] = max(0, Ceiling(0.25 * tier_slot_multiplier * totalXenos.len) - tier_3_xenos.len)

	// Tier 2 slots are between 25% and 50% of the hive, depending
	// on how many T3s there are.
	slots[1] = max(0, Ceiling(effective_total * (0.5 - tier_3_xenos.len / effective_total) * tier_slot_multiplier) - tier_2_xenos.len)

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
	hive_structures[name_ref] += src
	return TRUE

/datum/hive_status/proc/remove_special_structure(var/obj/effect/alien/resin/special/S)
	if(!S)
		return FALSE
	var/name_ref = initial(S.name)
	hive_structures[name_ref] -= src
	return TRUE

/datum/hive_status/proc/remove_all_special_structures()
	clear_spawn_list()
	for(var/name_ref in hive_structures)
		for(var/obj/effect/alien/resin/special/S in hive_structures[name_ref])
			hive_structures[name_ref] -= S
			qdel(S)

/datum/hive_status/proc/has_special_structure(var/name_ref)
	if(!name_ref || !hive_structures[name_ref] || !hive_structures[name_ref].len)
		return 0
	return hive_structures[name_ref].len

/datum/hive_status/proc/queue_spawn(var/mob/M)
	if(!M || !M.mind)
		return
	if(!living_xeno_queen)
		to_chat(M, SPAN_WARNING("The hivemind is disrupted! Your conciousness was lost to the void..."))
		return
	if(!has_special_structure(XENO_STRUCTURE_POOL))
		to_chat(M, SPAN_WARNING("There is no [XENO_STRUCTURE_POOL]! Your conciousness was lost to the void..."))
		return
	to_chat(M, SPAN_XENONOTICE("Your conciousness is recovered as you depart your body! You will be reborn soon..."))
	spawn_list.Add(M.mind)

/datum/hive_status/proc/clear_spawn_list()
	if(!spawn_list.len)
		return
	for(var/datum/mind/picked_mind in spawn_list)
		var/mind_ckey = picked_mind.ckey
		if(!directory[mind_ckey])
			return
		var/client/C = directory[mind_ckey]
		var/mob/M = C.mob
		to_chat(M, SPAN_WARNING("The hivemind has been disrupted! Your conciousness was lost to the void..."))
	spawn_list = list()

/datum/hive_status/proc/pick_from_spawn_list()
	if(!spawn_list.len)
		return null
	var/datum/mind/M = pick(spawn_list)
	return M

/datum/hive_status/corrupted
	hivenumber = XENO_HIVE_CORRUPTED
	prefix = "Corrupted "
	color = "#00ff80"

/datum/hive_status/alpha
	hivenumber = XENO_HIVE_ALPHA
	prefix = "Alpha "
	color = "#cccc00"

/datum/hive_status/beta
	hivenumber = XENO_HIVE_BETA
	prefix = "Beta "
	color = "#9999ff"

/datum/hive_status/zeta
	hivenumber = XENO_HIVE_ZETA
	prefix = "Zeta "
	color = "#606060"
