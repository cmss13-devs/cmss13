#define XENO_UNIVERSAL_HPMULT 1.0	//Stopgap usage only. Use to unilaterally buff every caste's total HP.
#define XENO_UNIVERSAL_PLASMAMULT 1.0	//Stopgap usage only. Use to unilaterally buff every caste's total PLASMA.
#define XENO_UNIVERSAL_DAMAGEMULT 1.0	//Stopgap usage only. Use to unilaterally buff every caste's total PLASMA.
#define XENO_NO_ARMOR 0
#define XENO_LOW_ARMOR 10 // +21% health
#define XENO_MEDIUM_ARMOR 20 // +46% health
#define XENO_HEAVY_ARMOR 30 // +77% health
#define XENO_ULTRA_ARMOR 40 // +114% health

#define XENO_NO_EXPLOSIVE_ARMOR 0
#define XENO_LOW_EXPLOSIVE_ARMOR 10
#define XENO_MEDIUM_EXPLOSIVE_ARMOR 20
#define XENO_HEAVY_EXPLOSIVE_ARMOR 40
#define XENO_ULTRA_EXPLOSIVE_ARMOR 60
#define XENO_GIGA_EXPLOSIVE_ARMOR 100

#define XENO_HEALTH_LARVA 35 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_LOW 200 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_LOWMEDIUM 225 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_MEDIUM 250 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_HIGHMEDIUM 300 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_HIGH 400 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_VERYHIGH 500 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_ULTRAHIGH 700 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_IMMORTAL 1200 * XENO_UNIVERSAL_HPMULT

#define XENO_MULTIPLIER_HEALTH_YOUNG 1.0
#define XENO_MULTIPLIER_HEALTH_MATURE 1.25
#define XENO_MULTIPLIER_HEALTH_ELDER 1.4
#define XENO_MULTIPLIER_HEALTH_ANCIENT 1.5

#define XENO_PLASMA_LOW 100 * XENO_UNIVERSAL_PLASMAMULT
#define XENO_PLASMA_LOWMEDIUM 150 * XENO_UNIVERSAL_PLASMAMULT
#define XENO_PLASMA_MEDIUM 200 * XENO_UNIVERSAL_PLASMAMULT
#define XENO_PLASMA_HIGHMEDIUM 300 * XENO_UNIVERSAL_PLASMAMULT
#define XENO_PLASMA_HIGH 500 * XENO_UNIVERSAL_PLASMAMULT
#define XENO_PLASMA_VERYHIGH 800 * XENO_UNIVERSAL_PLASMAMULT
#define XENO_PLASMA_ULTRAHIGH 1000 * XENO_UNIVERSAL_PLASMAMULT

#define XENO_MULTIPLIER_PLASMA_YOUNG 1.0
#define XENO_MULTIPLIER_PLASMA_MATURE 1.25
#define XENO_MULTIPLIER_PLASMA_ELDER 1.5
#define XENO_MULTIPLIER_PLASMA_ANCIENT 2.0

#define XENO_PLASMA_GAIN_LOW 0.02
#define XENO_PLASMA_GAIN_LOWMED 0.03
#define XENO_PLASMA_GAIN_MED 0.04
#define XENO_PLASMA_GAIN_HIGHMED 0.05
#define XENO_PLASMA_GAIN_HIGH 0.06
#define XENO_PLASMA_GAIN_VERYHIGH 0.07
#define XENO_PLASMA_GAIN_ULTRAHIGH 0.08

#define XENO_MULTIPLIER_PLASMA_GAIN_YOUNG 1.0
#define XENO_MULTIPLIER_PLASMA_GAIN_MATURE 1.1
#define XENO_MULTIPLIER_PLASMA_GAIN_ELDER 1.2
#define XENO_MULTIPLIER_PLASMA_GAIN_ANCIENT 1.3

#define XENO_MAX_SPEED -4
#define XENO_SPEED_CONVERT(x) x + XENO_MAX_SPEED

#define XENO_SPEED_SLOW 6
#define XENO_SPEED_MEDSLOW 5
#define XENO_SPEED_MEDIUM 4.5
#define XENO_SPEED_MEDHIGH 4
#define XENO_SPEED_HIGHMINUS 3.5
#define XENO_SPEED_HIGH 3.25
#define XENO_SPEED_FAST 3.0
#define XENO_SPEED_SANICFAST 2.5

#define XENO_MULTIPLIER_SPEED_YOUNG 1.0
#define XENO_MULTIPLIER_SPEED_MATURE 0.95
#define XENO_MULTIPLIER_SPEED_ELDER 0.9
#define XENO_MULTIPLIER_SPEED_ANCIENT 0.85

#define XENO_DAMAGE_WEAK 15 * XENO_UNIVERSAL_DAMAGEMULT
#define XENO_DAMAGE_LOW 20 * XENO_UNIVERSAL_DAMAGEMULT
#define XENO_DAMAGE_LOWPLUS 25 * XENO_UNIVERSAL_DAMAGEMULT
#define XENO_DAMAGE_MEDIUMLOW 30 * XENO_UNIVERSAL_DAMAGEMULT
#define XENO_DAMAGE_MEDIUM 35 * XENO_UNIVERSAL_DAMAGEMULT
#define XENO_DAMAGE_MEDIUMHIGH 40 * XENO_UNIVERSAL_DAMAGEMULT
#define XENO_DAMAGE_HIGH 50 * XENO_UNIVERSAL_DAMAGEMULT
#define XENO_DAMAGE_VERYHIGH 70 * XENO_UNIVERSAL_DAMAGEMULT
#define XENO_DAMAGE_ULTRAHIGH 100 * XENO_UNIVERSAL_DAMAGEMULT

#define XENO_MULTIPLIER_DAMAGE_YOUNG 1.0
#define XENO_MULTIPLIER_DAMAGE_MATURE 1.1
#define XENO_MULTIPLIER_DAMAGE_ELDER 1.15
#define XENO_MULTIPLIER_DAMAGE_ANCIENT 1.2

#define XENO_ARMOR_FACTOR_LOW 25
#define XENO_ARMOR_FACTOR_MEDIUM 30
#define XENO_ARMOR_FACTOR_HIGH 35
#define XENO_ARMOR_FACTOR_VERYHIGH 40

#define XENO_MULTIPLIER_ARMOR_FACTOR_YOUNG 1.0
#define XENO_MULTIPLIER_ARMOR_FACTOR_MATURE 1.1
#define XENO_MULTIPLIER_ARMOR_FACTOR_ELDER 1.15
#define XENO_MULTIPLIER_ARMOR_FACTOR_ANCIENT 1.20

#define XENO_EVASION_NONE 0
#define XENO_EVASION_LOW 10
#define XENO_EVASION_MEDIUM 15
#define XENO_EVASION_HIGH 20

#define XENO_MULTIPLIER_EVASION_YOUNG 1.0
#define XENO_MULTIPLIER_EVASION_MATURE 1.10
#define XENO_MULTIPLIER_EVASION_ELDER 1.15
#define XENO_MULTIPLIER_EVASION_ANCIENT 1.20

/datum/caste_datum
	var/caste_name = ""
	var/display_name = ""
	var/upgrade_name = "Young"
	var/tier = 0
	var/upgrade = 0
	var/dead_icon = "Drone Dead"
	var/language = "Xenomorph"

	var/melee_damage_lower = 10
	var/melee_damage_upper = 20
	var/evasion = XENO_EVASION_NONE

	var/bite_chance = 5 //Chance of doing a special bite attack in place of a claw. Set to 0 to disable.
	var/tail_chance = 10 //Chance of doing a special tail attack in place of a claw. Set to 0 to disable.
	var/rng_min_interval = 70 // 7 seconds

	var/speed = 1

	var/plasma_max = 10
	var/plasma_gain = 5

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
	var/build_time = 10 // Default build time and build distance
	var/max_build_dist = 0

	//Boiler vars
	var/bomb_strength = 0 //Multiplier to the effectiveness of the boiler glob. Improves by 0.5 per upgrade

	//Carrier vars
	var/huggers_max = 0
	var/throwspeed = 0
	var/hugger_delay = 0
	var/eggs_max = 0
	var/egg_cooldown = 30

	var/xeno_explosion_resistance = 0 //0 to 3. how explosions affects the xeno, can it stun it, etc...

	//Queen vars
	var/can_hold_facehuggers = 0
	var/can_hold_eggs = CANNOT_HOLD_EGGS

	var/can_be_queen_healed = 1

	var/can_vent_crawl = 1
	var/can_denest_hosts = 0

	var/burrow_cooldown = 50
	var/tunnel_cooldown = 100
	var/widen_cooldown = 100
	var/tremor_cooldown = 450 //Big strong ability, big cooldown.

	var/acid_spray_range = 3
	var/acid_spray_cooldown = 150

	var/headbutt_cooldown = 40
	var/tail_sweep_cooldown = 120
	var/crest_defense_cooldown = 150
	var/fortify_cooldown = 200

	var/innate_healing = FALSE //whether the xeno slowly heals even outside weeds.

	var/acid_delay = 90 //9 seconds delay on acid. Reduced by -1 per upgrade down to 5 seconds
	var/acid_level = 0
	var/weed_level = 0

	var/charge_speed = 2
	var/charge_distance = 6

	//New variables for how charges work, max speed, speed buildup, all that jazz
	var/charge_speed_max = 1.5 //Can only gain this much speed before capping
	var/charge_speed_buildup = 0.15 //POSITIVE amount of speed built up during a charge each step
	var/charge_turfs_to_charge = 5 //Amount of turfs to build up before a charge begins

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

/datum/caste_datum/proc/young_multipliers()
	melee_damage_lower = melee_damage_lower * XENO_MULTIPLIER_DAMAGE_YOUNG
	melee_damage_upper = melee_damage_upper * XENO_MULTIPLIER_DAMAGE_YOUNG
	plasma_gain = plasma_gain * XENO_MULTIPLIER_PLASMA_GAIN_YOUNG
	plasma_max = plasma_max * XENO_MULTIPLIER_PLASMA_YOUNG
	armor_deflection = armor_deflection
	xeno_explosion_resistance = xeno_explosion_resistance
	max_health = max_health * XENO_MULTIPLIER_HEALTH_YOUNG
	armor_hardiness_mult = armor_hardiness_mult * XENO_MULTIPLIER_ARMOR_FACTOR_YOUNG
	evasion = evasion * XENO_MULTIPLIER_EVASION_YOUNG
	speed = XENO_SPEED_CONVERT( (speed - XENO_MAX_SPEED) * XENO_MULTIPLIER_SPEED_YOUNG )

/datum/caste_datum/proc/mature_multipliers()
	melee_damage_lower = melee_damage_lower * XENO_MULTIPLIER_DAMAGE_MATURE
	melee_damage_upper = melee_damage_upper * XENO_MULTIPLIER_DAMAGE_MATURE
	plasma_gain = plasma_gain * XENO_MULTIPLIER_PLASMA_GAIN_MATURE
	plasma_max = plasma_max * XENO_MULTIPLIER_PLASMA_MATURE
	armor_deflection = armor_deflection
	xeno_explosion_resistance = xeno_explosion_resistance
	max_health = max_health * XENO_MULTIPLIER_HEALTH_MATURE
	armor_hardiness_mult = armor_hardiness_mult * XENO_MULTIPLIER_ARMOR_FACTOR_MATURE
	evasion = evasion * XENO_MULTIPLIER_EVASION_MATURE
	speed = XENO_SPEED_CONVERT( (speed - XENO_MAX_SPEED) * XENO_MULTIPLIER_SPEED_MATURE )

/datum/caste_datum/proc/elder_multipliers()
	melee_damage_lower = melee_damage_lower * XENO_MULTIPLIER_DAMAGE_ELDER
	melee_damage_upper = melee_damage_upper * XENO_MULTIPLIER_DAMAGE_ELDER
	plasma_gain = plasma_gain * XENO_MULTIPLIER_PLASMA_GAIN_ELDER
	plasma_max = plasma_max * XENO_MULTIPLIER_PLASMA_ELDER
	armor_deflection = armor_deflection
	xeno_explosion_resistance = xeno_explosion_resistance
	max_health = max_health * XENO_MULTIPLIER_HEALTH_ELDER
	armor_hardiness_mult = armor_hardiness_mult * XENO_MULTIPLIER_ARMOR_FACTOR_ELDER
	evasion = evasion * XENO_MULTIPLIER_EVASION_ELDER
	speed = XENO_SPEED_CONVERT( (speed - XENO_MAX_SPEED) * XENO_MULTIPLIER_SPEED_ELDER )

/datum/caste_datum/proc/ancient_multipliers()
	melee_damage_lower = melee_damage_lower * XENO_MULTIPLIER_DAMAGE_ANCIENT
	melee_damage_upper = melee_damage_upper * XENO_MULTIPLIER_DAMAGE_ANCIENT
	plasma_gain = plasma_gain * XENO_MULTIPLIER_PLASMA_GAIN_ANCIENT
	plasma_max = plasma_max * XENO_MULTIPLIER_PLASMA_ANCIENT
	armor_deflection = armor_deflection
	xeno_explosion_resistance = xeno_explosion_resistance
	max_health = max_health * XENO_MULTIPLIER_HEALTH_ANCIENT
	armor_hardiness_mult = armor_hardiness_mult * XENO_MULTIPLIER_ARMOR_FACTOR_ANCIENT
	evasion = evasion * XENO_MULTIPLIER_EVASION_ANCIENT
	speed = XENO_SPEED_CONVERT( (speed - XENO_MAX_SPEED) * XENO_MULTIPLIER_SPEED_ANCIENT )

/mob/living/carbon/Xenomorph
	var/datum/caste_datum/caste
	var/datum/hive_status/hive

	var/obj/item/clothing/suit/wear_suit = null
	var/obj/item/clothing/head/head = null
	var/obj/item/r_store = null
	var/obj/item/l_store = null
	var/amount_grown = 0
	var/time_of_birth
	var/max_grown = 200
	var/evolution_stored = 0 //How much evolution they have stored

	var/upgrade_stored = 0 //How much upgrade points they have stored.
	var/upgrade = -1  //This will track their upgrade level. -1 means cannot upgrade

	var/has_spat = 0
	var/armor_bonus = 0 //Extra chance of deflecting projectiles due to temporary effects
	var/has_screeched = 0
	var/middle_mouse_toggle = TRUE //This toggles whether selected ability uses middle mouse clicking or shift clicking
	var/directional_attack_toggle = TRUE //This toggles whether attacks use directional attacks

	var/devour_timer = 0

	var/last_rng_attack = 0

	var/obj/structure/tunnel/start_dig = null
	var/tunnel_delay = 0
	var/datum/ammo/xeno/ammo = null //The ammo datum for our spit projectiles. We're born with this, it changes sometimes.
	var/pslash_delay = 0

	var/current_aura = null //"claw", "armor", "regen", "speed"
	var/frenzy_aura = 0 //Strength of aura we are affected by. NOT THE ONE WE ARE EMITTING
	var/warding_aura = 0
	var/recovery_aura = 0

	var/is_zoomed = 0
	var/zoom_turf = null
	var/autopsied = 0

	var/tier = 1 //This will track their "tier" to restrict/limit evolutions
	var/hardcore = 0 //Set to 1 in New() when Whiskey Outpost is active. Prevents healing and queen evolution
	var/crit_health = -100 // What negative healthy they die in.
	var/gib_chance  = 5 // % chance of them exploding when taking damage. Goes up with damage inflicted.

	var/fortify_timer = 60
	var/burrow_timer = 200
	var/tunnel_timer = 20

	var/emotedown = 0

	var/datum/action/xeno_action/activable/selected_ability
	var/selected_resin = RESIN_WALL //which resin structure to build when we secrete resin

	//Naming variables
	var/caste_name = ""
	var/nicknumber = 0 //The number after the name. Saved right here so it transfers between castes.

	//This list of inherent verbs lets us take any proc basically anywhere and add them.
	//If they're not a xeno subtype it might crash or do weird things, like using human verb procs
	//It should add them properly on New() and should reset/readd them on evolves
	var/list/inherent_verbs = list()

	//Lord forgive me for this horror, but Life code is awful
	//These are tally vars, yep. Because resetting the aura value directly leads to fuckups
	var/frenzy_new = 0
	var/warding_new = 0
	var/recovery_new = 0

	var/xeno_mobhud = FALSE //whether the xeno mobhud is activated or not.

	var/queen_chosen_lead //whether the xeno has been selected by the queen as a leader.

	//Old crusher specific vars, moved here so the Queen can use charge, and potential future Xenos
	var/charge_dir = 0 //Stores initial charge dir to immediately cut out any direction change shenanigans
	var/charge_timer = 0 //Has a small charge window. has to keep moving to build speed.
	var/turf/lastturf = null
	var/noise_timer = 0 // Makes a mech footstep, but only every 3 turfs.
	var/has_moved = 0
	var/is_charging = 0 //Will the mob charge when moving ? You need the charge verb to change this
	var/weedwalking_activated = 0 //Hivelord's weedwalking
	var/last_charge_move = 0 //Time of the last time the Crusher moved while charging. If it's too far apart, the charge is broken

	//Burrower Vars
	var/used_tremor = 0

	//Pounce vars
	var/used_pounce = 0

	// Warrior vars
	var/agility = 0		// 0 - upright, 1 - all fours
	var/ripping_limb = 0

	var/used_lunge = 0
	var/used_fling = 0
	var/used_punch = 0
	var/used_toggle_agility = 0

	var/used_jab = 0

	// Defender vars
	var/fortify = 0
	var/crest_defense = 0

	var/used_headbutt = 0
	var/used_tail_sweep = 0
	var/used_crest_defense = 0
	var/used_fortify = 0

	var/used_burrow = 0
	var/used_tunnel = 0
	var/used_widen = 0

	var/tunnel = 0
	var/burrow = 0

	//Praetorian vars
	var/used_acid_spray = 0

	//Carrier vars
	var/threw_a_hugger = 0
	var/huggers_cur = 0
	var/eggs_cur = 0
	var/huggers_max = 0
	var/eggs_max = 0
	var/laid_egg = 0

	//Leader vars
	var/leader_aura_strength = 0 //Pheromone strength inherited from Queen
	var/leader_current_aura = "" //Pheromone type inherited from Queen

	// Related to zooming out (primarily queen and boiler)
	var/tileoffset = 0
	var/viewsize = 0

	gender = NEUTER

/datum/hive_status
	var/hivenumber = XENO_HIVE_NORMAL
	var/mob/living/carbon/Xenomorph/Queen/living_xeno_queen
	var/slashing_allowed = 1 //This initial var allows the queen to turn on or off slashing. Slashing off means harm intent does much less damage.
	var/queen_time = 300 //5 minutes between queen deaths
	var/xeno_queen_timer
	var/hive_orders = "" //What orders should the hive have
	var/color = null
	var/prefix = ""
	var/queen_leader_limit = 2
	var/list/xeno_leader_list = list()
	var/stored_larva = 0
	var/list/tier_2_xenos = list()//list of living tier2 xenos
	var/list/tier_3_xenos = list()//list of living tier3 xenos
	var/list/totalXenos	= list()  //list of living xenos
	var/isSlotOpen = TRUE //Set true for starting alerts only after the hive has reached its full potential

	var/datum/mutator_set/hive_mutators/mutators = new
	var/tier_slot_multiplier = 1.0
	var/larva_gestation_multiplier = 1.0
	var/bonus_larva_spawn_chance = 1.0

/datum/hive_status/New()
	mutators.hive = src

/datum/hive_status/proc/set_living_xeno_queen(var/mob/living/carbon/Xenomorph/Queen/M)
	if(M == null)
		mutators.reset_mutators()
	else
		mutators.user_levelled_up(M.upgrade)
	living_xeno_queen = M
	recalculate_hive()

/datum/hive_status/proc/recalculate_hive()
	if(!living_xeno_queen)
		queen_leader_limit = 0 //No leaders for a Hive without a Queen!
	else
		queen_leader_limit = 2 + living_xeno_queen.upgrade + mutators.leader_count_boost
	while(xeno_leader_list.len > queen_leader_limit)
		//Removing Hive leaders from the most freshly added to the oldest ones
		remove_hive_leader(xeno_leader_list[xeno_leader_list.len])
	tier_slot_multiplier = mutators.tier_slot_multiplier

	larva_gestation_multiplier = mutators.larva_gestation_multiplier
	bonus_larva_spawn_chance = mutators.bonus_larva_spawn_chance

/datum/hive_status/proc/add_hive_leader(var/mob/living/carbon/Xenomorph/xeno)
	if(!xeno)
		return FALSE //How did this even happen?
	if(xeno_leader_list.len >= queen_leader_limit)
		return FALSE //Too many leaders already
	if(xeno in xeno_leader_list)
		return FALSE //Already on the list
	xeno_leader_list += xeno
	xeno.queen_chosen_lead = TRUE
	xeno.handle_xeno_leader_pheromones()
	return TRUE

/datum/hive_status/proc/remove_hive_leader(var/mob/living/carbon/Xenomorph/xeno)
	xeno_leader_list -= xeno
	xeno.queen_chosen_lead = FALSE
	xeno.handle_xeno_leader_pheromones()

/datum/hive_status/proc/handle_xeno_leader_pheromones()
	for(var/mob/living/carbon/Xenomorph/L in xeno_leader_list)
		L.handle_xeno_leader_pheromones()

/datum/hive_status/proc/handle_evolution_alert()
	if (!totalXenos.len) //sanity check!
		isSlotOpen = FALSE
		return

	if (((tier_2_xenos.len + tier_3_xenos.len) / totalXenos.len * tier_slot_multiplier) > 0.5)
		if(!isSlotOpen)//plus a check to stop message spam
			xeno_message(SPAN_XENONOTICE("The hive can support more second tier castes!"),2, hivenumber)
			isSlotOpen = TRUE
			return

	if ((tier_3_xenos.len / totalXenos.len * tier_slot_multiplier) > 0.25)
		if(!isSlotOpen)//plus a check to stop message spam
			xeno_message(SPAN_XENONOTICE("The hive can support more third tier castes!"),2, hivenumber)
			isSlotOpen = TRUE
			return

	isSlotOpen = FALSE

/datum/hive_status/proc/handle_nuke_alert(var/timing, var/area/loc)
	if (!totalXenos.len) //sanity check!
		return

	if(timing)
		xeno_message("<span class='xenoannounce'>The tallhosts have deployed a hive killer at [loc.name]! Stop it at all costs!</span>",2, hivenumber)
	else
		xeno_message("<span class='xenoannounce'>The hive killer has been disabled! Rejoice!</span>",2, hivenumber)

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

var/global/list/hive_datum = list(new /datum/hive_status(), new /datum/hive_status/corrupted(), new /datum/hive_status/alpha(), new /datum/hive_status/beta(), new /datum/hive_status/zeta())
