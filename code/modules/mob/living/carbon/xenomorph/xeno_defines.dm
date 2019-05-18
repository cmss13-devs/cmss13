// Holds defines for /datum/caste_datum, which is the primary datum for the caste system, 
// /datum/hive_status (self explanatory)
// and some of the var defines for the Xenomorph base type. 

// Holds defines relevant to overall xeno balance

// Stopgap usage only. Use to unilaterally buff every Xenomorph. 
// WARNING: These can fuck the entire game 
#define XENO_UNIVERSAL_HPMULT 1.0		// Use to unilaterally buff every caste's total HP.
#define XENO_UNIVERSAL_PLASMAMULT 1.0	// Use to unilaterally buff every caste's total PLASMA.
#define XENO_UNIVERSAL_DAMAGEMULT 1.0	// Use to unilaterally buff every caste's total PLASMA.


/////////////////////////////////////////////////////////////////////////////////////
//
//	Stat Baselines
//
// These provide the values for caste that everything is built on/scaled off of.
//
/////////////////////////////////////////////////////////////////////////////////////

// Armor levels 
#define XENO_NO_ARMOR 0
#define XENO_LOW_ARMOR 15 // +21% health
#define XENO_MEDIUM_ARMOR 25 // +46% health
#define XENO_HEAVY_ARMOR 35 // +77% health
#define XENO_ULTRA_ARMOR 40 // +114% health

// Explosive armor (think explosion resistance)
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

#define XENO_PLASMA_LOW 100 * XENO_UNIVERSAL_PLASMAMULT
#define XENO_PLASMA_LOWMEDIUM 150 * XENO_UNIVERSAL_PLASMAMULT
#define XENO_PLASMA_MEDIUM 200 * XENO_UNIVERSAL_PLASMAMULT
#define XENO_PLASMA_HIGHMEDIUM 300 * XENO_UNIVERSAL_PLASMAMULT
#define XENO_PLASMA_HIGH 500 * XENO_UNIVERSAL_PLASMAMULT
#define XENO_PLASMA_VERYHIGH 800 * XENO_UNIVERSAL_PLASMAMULT
#define XENO_PLASMA_ULTRAHIGH 1000 * XENO_UNIVERSAL_PLASMAMULT

#define XENO_PLASMA_GAIN_LOW 0.02
#define XENO_PLASMA_GAIN_LOWMED 0.03
#define XENO_PLASMA_GAIN_MED 0.04
#define XENO_PLASMA_GAIN_HIGHMED 0.05
#define XENO_PLASMA_GAIN_HIGH 0.06
#define XENO_PLASMA_GAIN_VERYHIGH 0.07
#define XENO_PLASMA_GAIN_ULTRAHIGH 0.08

// Armor factor 
#define XENO_ARMOR_FACTOR_LOW 25
#define XENO_ARMOR_FACTOR_MEDIUM 30
#define XENO_ARMOR_FACTOR_HIGH 35
#define XENO_ARMOR_FACTOR_VERYHIGH 40

// Evasion
#define XENO_EVASION_NONE 0
#define XENO_EVASION_LOW 10
#define XENO_EVASION_MEDIUM 15
#define XENO_EVASION_HIGH 20

// Speed  = XENO_MAX_SPEED-4 
// -2 = very fast
// +2 = very slow 
#define XENO_MAX_SPEED -4
#define XENO_SPEED_CONVERT(x) x + XENO_MAX_SPEED

// Speeds (these have -4 rolled in down the line)
#define XENO_SPEED_SLOW 6
#define XENO_SPEED_MEDSLOW 5
#define XENO_SPEED_MEDIUM 4.5
#define XENO_SPEED_MEDHIGH 4
#define XENO_SPEED_HIGHMINUS 3.5
#define XENO_SPEED_HIGH 3
#define XENO_SPEED_FAST 2.5
#define XENO_SPEED_SANICFAST 2.0

// Xeno damage categories
// generated at COMPILE TIME from the universal multipliers.
#define XENO_DAMAGE_WEAK 10 * XENO_UNIVERSAL_DAMAGEMULT
#define XENO_DAMAGE_LOW 20 * XENO_UNIVERSAL_DAMAGEMULT
#define XENO_DAMAGE_LOWPLUS 25 * XENO_UNIVERSAL_DAMAGEMULT
#define XENO_DAMAGE_MEDIUMLOW 30 * XENO_UNIVERSAL_DAMAGEMULT
#define XENO_DAMAGE_MEDIUM 35 * XENO_UNIVERSAL_DAMAGEMULT
#define XENO_DAMAGE_MEDIUMHIGH 40 * XENO_UNIVERSAL_DAMAGEMULT
#define XENO_DAMAGE_HIGH 50 * XENO_UNIVERSAL_DAMAGEMULT
#define XENO_DAMAGE_VERYHIGH 75 * XENO_UNIVERSAL_DAMAGEMULT
#define XENO_DAMAGE_ULTRAHIGH 100 * XENO_UNIVERSAL_DAMAGEMULT


/////////////////////////////////////////////////////////////////////////////////////
//
//	Modifiers 
//
// These below are used in the Xeno strain system to increase and decrease certain stats by strain
// USE THESE WITH SIGNS - postive will be ADDED, negative will be SUBTRACTED from the Xeno's
// previous stat. Bear in mind that the signs mean different things for different values. 
//
/////////////////////////////////////////////////////////////////////////////////////

// Damage - this is applied as a flat nerf/buff to the xeno's average damage
#define XENO_DAMAGE_MOD_VERYSMALL  5
#define XENO_DAMAGE_MOD_SMALL      10
#define XENO_DAMAGE_MOD_MED        15
#define XENO_DAMAGE_MOD_LARGE      20
#define XENO_DAMAGE_MOD_VERYLARGE  25

// Overall health pool 
#define XENO_HEALTH_MOD_VERYSMALL  20
#define XENO_HEALTH_MOD_SMALL      40
#define XENO_HEALTH_MOD_MED        60
#define XENO_HEALTH_MOD_LARGE      80
#define XENO_HEALTH_MOD_VERYLARGE  100

// Armor mods. Use the above defines for some guidance
// In general, +20 armor should be a little more than +20% effective HP, however, 
// the higher the Xeno's base armor, the greater the effect. 
#define XENO_ARMOR_MOD_VERYSMALL  5
#define XENO_ARMOR_MOD_SMALL      10
#define XENO_ARMOR_MOD_MED        15
#define XENO_ARMOR_MOD_LARGE      20
#define XENO_ARMOR_MOD_VERYLARGE  25

#define XENO_EXPOSIVEARMOR_MOD_VERYSMALL  10
#define XENO_EXPOSIVEARMOR_MOD_SMALL      20
#define XENO_EXPOSIVEARMOR_MOD_MED        30
#define XENO_EXPOSIVEARMOR_MOD_LARGE      40
#define XENO_EXPOSIVEARMOR_MOD_VERYLARGE  50

// Plasma
#define XENO_PLASMAPOOL_MOD_VERYSMALL  20
#define XENO_PLASMAPOOL_MOD_SMALL      40
#define XENO_PLASMAPOOL_MOD_MED        60
#define XENO_PLASMAPOOL_MOD_LARGE      80
#define XENO_PLASMAPOOL_MOD_VERYLARGE  100

// Plasma regen 
#define XENO_PLASMAGAIN_MOD_SMALL 0.1
#define XENO_PLASMAGAIN_MOD_MED   0.2
#define XENO_PLASMAGAIN_MOD_LARGE 0.3

// Speed mods (these will be rolled into the xeno's total speed)
// Negative = faster, postive = slower.                     
#define XENO_SPEED_MOD_VERYSMALL  0.25
#define XENO_SPEED_MOD_SMALL      0.5
#define XENO_SPEED_MOD_MED        0.75
#define XENO_SPEED_MOD_LARGE      1.0
#define XENO_SPEED_MOD_VERYLARGE  1.25

// Pheremone strength modifiers
#define XENO_PHERO_MOD_VERYSMALL  0.25
#define XENO_PHERO_MOD_SMALL      0.5
#define XENO_PHERO_MOD_MED        0.75
#define XENO_PHERO_MOD_LARGE      1.0
#define XENO_PHERO_MOD_VERYLARGE  1.25

// Evasion modifiers 
#define XENO_EVASION_MOD_VERYSMALL 	3
#define XENO_EVASION_MOD_SMALL	   	6
#define XENO_EVASION_MOD_MED  	   	9
#define XENO_EVASION_MOD_LARGE   	12
#define XENO_EVASION_MOD_VERYLARGE	15

// Armor factor modifiers
#define XENO_ARMORFACTOR_MOD_VERYSMALL	5
#define XENO_ARMORFACTOR_MOD_SMALL		10
#define XENO_ARMORFACTOR_MOD_MED		15
#define XENO_ARMORFACTOR_MOD_LARGE		20
#define XENO_ARMORFACTOR_MOD_VERYLARGE 	25

// Acid boost (I guess, this is used literally nowhere)
// Feel free to add more defines here if it ever becomes relevant
#define XENO_ACID_MOD_BOOST	1

// Weed boost (same as above)
#define XENO_WEED_BOOST 1

/////////////////////////////////////////////////////////////////////////////////////
//
//	Default scaling values 
//
// In the abscence of a scalar (documented below) these values are what are used 
// to scale xeno stats by age.
//
/////////////////////////////////////////////////////////////////////////////////////

#define XENO_MULTIPLIER_HEALTH_YOUNG 1.0
#define XENO_MULTIPLIER_HEALTH_MATURE 1.25
#define XENO_MULTIPLIER_HEALTH_ELDER 1.4
#define XENO_MULTIPLIER_HEALTH_ANCIENT 1.5

#define XENO_MULTIPLIER_DAMAGE_YOUNG 1.0
#define XENO_MULTIPLIER_DAMAGE_MATURE 1.2
#define XENO_MULTIPLIER_DAMAGE_ELDER 1.3
#define XENO_MULTIPLIER_DAMAGE_ANCIENT 1.35

#define XENO_MULTIPLIER_SPEED_YOUNG 1.0
#define XENO_MULTIPLIER_SPEED_MATURE 0.9
#define XENO_MULTIPLIER_SPEED_ELDER 0.85
#define XENO_MULTIPLIER_SPEED_ANCIENT 0.8

#define XENO_MULTIPLIER_PLASMA_YOUNG 1.0
#define XENO_MULTIPLIER_PLASMA_MATURE 1.25
#define XENO_MULTIPLIER_PLASMA_ELDER 1.5
#define XENO_MULTIPLIER_PLASMA_ANCIENT 2.0

#define XENO_MULTIPLIER_PLASMA_GAIN_YOUNG 1.0
#define XENO_MULTIPLIER_PLASMA_GAIN_MATURE 1.2
#define XENO_MULTIPLIER_PLASMA_GAIN_ELDER 1.4
#define XENO_MULTIPLIER_PLASMA_GAIN_ANCIENT 1.6

#define XENO_MULTIPLIER_ARMOR_FACTOR_YOUNG 1.0
#define XENO_MULTIPLIER_ARMOR_FACTOR_MATURE 1.1
#define XENO_MULTIPLIER_ARMOR_FACTOR_ELDER 1.15
#define XENO_MULTIPLIER_ARMOR_FACTOR_ANCIENT 1.20

#define XENO_MULTIPLIER_EVASION_YOUNG 1.0
#define XENO_MULTIPLIER_EVASION_MATURE 1.10
#define XENO_MULTIPLIER_EVASION_ELDER 1.15
#define XENO_MULTIPLIER_EVASION_ANCIENT 1.20

/////////////////////////////////////////////////////////////////////////////////////////////
//
//	Scalars 
//
// These are used to adjust caste scaling. Define in them in the caste datum definitions
// for each age to override the default. Bear in mind that these scale from the base caste 
// values; they are NOT multiplicative. The actual variables for doing that are down below.
//
/////////////////////////////////////////////////////////////////////////////////////////////

#define XENO_SCALAR_HEALTH_NONE				1.0
#define XENO_SCALAR_HEALTH_LOW  			1.1
#define XENO_SCALAR_HEALTH_LOWMED			1.15
#define XENO_SCALAR_HEALTH_MED				1.2
#define XENO_SCALAR_HEALTH_MEDHIGH			1.25
#define XENO_SCALAR_HEALTH_HIGH				1.3
#define XENO_SCALAR_HEALTH_VERYHIGH			1.35
#define XENO_SCALAR_HEALTH_ULTRAHIGH		1.4
#define XENO_SCALAR_HEALTH_IMMORTAL			1.5
#define XENO_SCALAR_HEALTH_OHLAWD			1.7

#define XENO_SCALAR_DAMAGE_NONE				1.0
#define XENO_SCALAR_DAMAGE_LOW  			1.1
#define XENO_SCALAR_DAMAGE_MED				1.2
#define XENO_SCALAR_DAMAGE_HIGH				1.3
#define XENO_SCALAR_DAMAGE_VERYHIGH			1.4
#define XENO_SCALAR_DAMAGE_ULTRAHIGH		1.5

#define XENO_SCALAR_SPEED_NONE				1.0
#define XENO_SCALAR_SPEED_LOW  				0.95
#define XENO_SCALAR_SPEED_MED				0.9
#define XENO_SCALAR_SPEED_HIGH				0.85
#define XENO_SCALAR_SPEED_VERYHIGH			0.8
#define XENO_SCALAR_SPEED_ULTRAHIGH			0.75

#define XENO_SCALAR_PLASMA_NONE				1.0
#define XENO_SCALAR_PLASMA_LOW  			1.25
#define XENO_SCALAR_PLASMA_MED				1.5
#define XENO_SCALAR_PLASMA_HIGH				1.75
#define XENO_SCALAR_PLASMA_VERYHIGH			2.0
#define XENO_SCALAR_PLASMA_ULTRAHIGH		2.25

#define XENO_SCALAR_PLASMA_GAIN_NONE		1.0
#define XENO_SCALAR_PLASMA_GAIN_LOW  		1.15
#define XENO_SCALAR_PLASMA_GAIN_MED			1.3
#define XENO_SCALAR_PLASMA_GAIN_HIGH		1.45
#define XENO_SCALAR_PLASMA_GAIN_VERYHIGH	1.6
#define XENO_SCALAR_PLASMA_GAIN_ULTRAHIGH	1.75

#define XENO_SCALAR_ARMORFACTOR_NONE		1.0
#define XENO_SCALAR_ARMORFACTOR_LOW  		1.05
#define XENO_SCALAR_aRMORFACTOR_MED			1.1
#define XENO_SCALAR_ARMORFACTOR_HIGH		1.15
#define XENO_SCALAR_ARMORFACTOR_VERYHIGH	1.20
#define XENO_SCALAR_ARMORFACTOR_ULTRAHIGH	1.25

#define XENO_SCALAR_EVASION_NONE			1.0
#define XENO_SCALAR_EVASION_LOW  			1.05
#define XENO_SCALAR_EVASION_MED				1.1
#define XENO_SCALAR_EVASION_HIGH			1.15
#define XENO_SCALAR_EVASION_VERYHIGH		1.20
#define XENO_SCALAR_EVASION_ULTRAHIGH		1.25

// Actual caste datum 
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

	var/xeno_explosion_resistance = 0 //Armor but for explosions

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

	var/innate_healing = FALSE //whether the xeno heals even outside weeds.

	var/acid_delay = 90 //9 seconds delay on acid. Reduced by -1 per upgrade down to 5 seconds
	var/acid_level = 0
	var/weed_level = 0

	var/charge_speed = 2
	var/charge_distance = 6

	//New variables for how charges work, max speed, speed buildup, all that jazz
	var/charge_speed_max = 1.5 //Can only gain this much speed before capping
	var/charge_speed_buildup = 0.15 //POSITIVE amount of speed built up during a charge each step
	var/charge_turfs_to_charge = 5 //Amount of turfs to build up before a charge begins

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
	var/explosion_armor_scalar
	var/armor_scalar
	var/armorfactor_scalar
	var/speed_scalar
	var/evasion_scalar 

/datum/caste_datum/New()
	. = ..()
	apply_scalars()

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

// Populates all the default scaling values on a caste datum
// if they aren't already set.
// Scaling vars should be defined on each 
/datum/caste_datum/proc/apply_scalars()
	
	// I'm so sorry for this code but its necessary to have these all in defines, which is very desired
	// Formula
	// final_value_on_xeno = modifier + caste_base_value * (caste_scaler_val ? caste_scaler_val : default_val) 
	
	// All the scalars currently implemented:
	//var/melee_damage_scalar
	//var/max_health_scalar
	//var/plasma_gain_scalar
	//var/plasma_max_scalar
	//var/explosion_armor_scalar
	//var/armor_scalar
	//var/speed_scalar
	//var/evasion_scalar 
	//var/armorfactor_scalar

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
			if (!speed_scalar)
				speed_scalar = XENO_MULTIPLIER_SPEED_YOUNG
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
			if (!speed_scalar)
				speed_scalar = XENO_MULTIPLIER_SPEED_MATURE
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
			if (!speed_scalar)
				speed_scalar = XENO_MULTIPLIER_SPEED_ELDER
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
			if (!speed_scalar)
				speed_scalar = XENO_MULTIPLIER_SPEED_ANCIENT
			if (!evasion_scalar)
				evasion_scalar = XENO_MULTIPLIER_EVASION_ANCIENT
			if (!armorfactor_scalar)
				armorfactor_scalar = XENO_MULTIPLIER_ARMOR_FACTOR_ANCIENT

	melee_damage_lower = melee_damage_lower * melee_damage_scalar
	melee_damage_upper = melee_damage_upper * melee_damage_scalar
	plasma_gain = plasma_gain * plasma_gain_scalar
	plasma_max = plasma_max * plasma_max_scalar
	armor_deflection = armor_deflection * armor_scalar
	xeno_explosion_resistance = xeno_explosion_resistance * explosion_armor_scalar
	max_health = max_health * max_health_scalar
	speed = XENO_SPEED_CONVERT( (speed - XENO_MAX_SPEED) * speed_scalar )
	evasion = evasion * evasion_scalar
	armor_hardiness_mult = armor_hardiness_mult * armorfactor_scalar
	

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
