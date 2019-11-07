// Holds defines for /datum/caste_datum, which is the primary datum for the caste system,
// /datum/hive_status (self explanatory)
// and some of the var defines for the Xenomorph base type.

// Holds defines relevant to overall xeno balance

// Stopgap usage only. Use to unilaterally buff every Xenomorph.
// WARNING: These can fuck the entire game
#define XENO_UNIVERSAL_HPMULT 1.0		// Use to unilaterally buff every caste's total HP.
#define XENO_UNIVERSAL_PLASMAMULT 1.0	// Use to unilaterally buff every caste's total PLASMA.
#define XENO_UNIVERSAL_DAMAGEMULT 1.0	// Use to unilaterally buff every caste's DAMAGE.

/////////////////////////////////////////////////////////////////////////////////////
//
//	Stat Baselines
//
// These provide the values for caste that everything is built on/scaled off of.
//
/////////////////////////////////////////////////////////////////////////////////////

// Armor levels
#define XENO_NO_ARMOR 0
#define XENO_LOW_ARMOR 20
#define XENO_LOWMED_ARMOR 25
#define XENO_MEDIUM_ARMOR 30
#define XENO_HEAVY_ARMOR 40
#define XENO_ULTRA_ARMOR 50

// Explosive armor (think explosion resistance)
#define XENO_NO_EXPLOSIVE_ARMOR 0
#define XENO_LOW_EXPLOSIVE_ARMOR 10
#define XENO_MEDIUM_EXPLOSIVE_ARMOR 20
#define XENO_HEAVY_EXPLOSIVE_ARMOR 40
#define XENO_LOWULTRA_EXPLOSIVE_ARMOR 50
#define XENO_ULTRA_EXPLOSIVE_ARMOR 60
#define XENO_GIGA_EXPLOSIVE_ARMOR 100

// Health bands
#define XENO_HEALTH_LARVA 35 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_VERYLOW 200 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_LOW 225 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_LOWMEDIUM 250 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_MEDIUM 275 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_HIGHMEDIUM 325 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_LOWHIGH 400 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_HIGH 450 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_VERYHIGH 525 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_ULTRAHIGH 750 * XENO_UNIVERSAL_HPMULT
#define XENO_HEALTH_IMMORTAL 1200 * XENO_UNIVERSAL_HPMULT

// Plasma bands
#define XENO_PLASMA_LOW 100 * XENO_UNIVERSAL_PLASMAMULT
#define XENO_PLASMA_LOWMEDIUM 150 * XENO_UNIVERSAL_PLASMAMULT
#define XENO_PLASMA_MEDIUM 200 * XENO_UNIVERSAL_PLASMAMULT
#define XENO_PLASMA_HIGHMEDIUM 300 * XENO_UNIVERSAL_PLASMAMULT
#define XENO_PLASMA_HIGH 500 * XENO_UNIVERSAL_PLASMAMULT
#define XENO_PLASMA_VERYHIGH 800 * XENO_UNIVERSAL_PLASMAMULT
#define XENO_PLASMA_ULTRAHIGH 1000 * XENO_UNIVERSAL_PLASMAMULT

// Plasma gain bands
#define XENO_PLASMA_GAIN_LOW 1
#define XENO_PLASMA_GAIN_LOWMED 2
#define XENO_PLASMA_GAIN_MED 2.5
#define XENO_PLASMA_GAIN_HIGHMED 3
#define XENO_PLASMA_GAIN_HIGH 3.5
#define XENO_PLASMA_GAIN_VERYHIGH 4
#define XENO_PLASMA_GAIN_ULTRAHIGH 5

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

// Speeds
#define XENO_SPEED_SLOW 0.7
#define XENO_SPEED_MEDIUM 0.3
#define XENO_SPEED_MEDHIGH -0.2
#define XENO_SPEED_LOWHIGH -0.4
#define XENO_SPEED_HIGH -0.5
#define XENO_SPEED_HIGHFAST -0.8
#define XENO_SPEED_FAST -1.6
#define XENO_SPEED_SANICFAST -1.9

// Xeno damage categories
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
#define XENO_SPEED_MOD_SMALL      0.05
#define XENO_SPEED_MOD_MED        0.09
#define XENO_SPEED_MOD_LARGE      0.1
#define XENO_SPEED_MOD_VERYLARGE  0.25
#define XENO_SPEED_MOD_LOWULTRA	  0.375
#define XENO_SPEED_MOD_ULTRA	  0.5

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
#define XENO_EVASION_MOD_ULTRA		25

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
#define XENO_MULTIPLIER_HEALTH_PRIMORDIAL 1.75

#define XENO_MULTIPLIER_DAMAGE_YOUNG 1.0
#define XENO_MULTIPLIER_DAMAGE_MATURE 1.2
#define XENO_MULTIPLIER_DAMAGE_ELDER 1.3
#define XENO_MULTIPLIER_DAMAGE_ANCIENT 1.35
#define XENO_MULTIPLIER_DAMAGE_PRIMORDIAL 1.45

#define XENO_MULTIPLIER_PLASMA_YOUNG 1.0
#define XENO_MULTIPLIER_PLASMA_MATURE 1.25
#define XENO_MULTIPLIER_PLASMA_ELDER 1.5
#define XENO_MULTIPLIER_PLASMA_ANCIENT 2.0
#define XENO_MULTIPLIER_PLASMA_PRIMORDIAL 2.25

#define XENO_MULTIPLIER_PLASMA_GAIN_YOUNG 1.0
#define XENO_MULTIPLIER_PLASMA_GAIN_MATURE 1.2
#define XENO_MULTIPLIER_PLASMA_GAIN_ELDER 1.4
#define XENO_MULTIPLIER_PLASMA_GAIN_ANCIENT 1.6
#define XENO_MULTIPLIER_PLASMA_GAIN_PRIMORDIAL 1.8

#define XENO_MULTIPLIER_ARMOR_FACTOR_YOUNG 1.0
#define XENO_MULTIPLIER_ARMOR_FACTOR_MATURE 1.1
#define XENO_MULTIPLIER_ARMOR_FACTOR_ELDER 1.15
#define XENO_MULTIPLIER_ARMOR_FACTOR_ANCIENT 1.20
#define XENO_MULTIPLIER_ARMOR_FACTOR_PRIMORDIAL 1.30

#define XENO_MULTIPLIER_EVASION_YOUNG 1.0
#define XENO_MULTIPLIER_EVASION_MATURE 1.10
#define XENO_MULTIPLIER_EVASION_ELDER 1.15
#define XENO_MULTIPLIER_EVASION_ANCIENT 1.20
#define XENO_MULTIPLIER_EVASION_PRIMORDIAL 1.3

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
#define XENO_SCALAR_ARMORFACTOR_MED			1.1
#define XENO_SCALAR_ARMORFACTOR_HIGH		1.15
#define XENO_SCALAR_ARMORFACTOR_VERYHIGH	1.20
#define XENO_SCALAR_ARMORFACTOR_ULTRAHIGH	1.25

#define XENO_SCALAR_EVASION_NONE			1.0
#define XENO_SCALAR_EVASION_LOW  			1.05
#define XENO_SCALAR_EVASION_MED				1.1
#define XENO_SCALAR_EVASION_HIGH			1.15
#define XENO_SCALAR_EVASION_VERYHIGH		1.20
#define XENO_SCALAR_EVASION_ULTRAHIGH		1.25

// Actual caste datum basedef
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

	var/speed = XENO_SPEED_SANICFAST
	var/speed_mod = XENO_SPEED_MOD_LARGE

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
			if (!evasion_scalar)
				evasion_scalar = XENO_MULTIPLIER_EVASION_PRIMORDIAL
			if (!armorfactor_scalar)
				armorfactor_scalar = XENO_MULTIPLIER_ARMOR_FACTOR_PRIMORDIAL
		else
			melee_damage_scalar = 1
			max_health_scalar = 1
			plasma_gain_scalar = 1
			plasma_max_scalar = 1
			evasion_scalar = 1
			armorfactor_scalar = 1

	melee_damage_lower = melee_damage_lower * melee_damage_scalar
	melee_damage_upper = melee_damage_upper * melee_damage_scalar
	plasma_gain = plasma_gain * plasma_gain_scalar
	plasma_max = plasma_max * plasma_max_scalar
	armor_deflection = armor_deflection * armor_scalar
	xeno_explosion_resistance = xeno_explosion_resistance * explosion_armor_scalar
	max_health = max_health * max_health_scalar
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
	var/list/open_xeno_leader_positions = list(1, 2) // Ordered list of xeno leader positions (indexes in xeno_leader_list) that are not occupied
	var/list/xeno_leader_list[2] // Ordered list (i.e. index n holds the nth xeno leader)
	var/stored_larva = 0
	var/list/tier_2_xenos = list()//list of living tier2 xenos
	var/list/tier_3_xenos = list()//list of living tier3 xenos
	var/list/totalXenos	= list()  //list of living xenos
	var/isSlotOpen = TRUE //Set true for starting alerts only after the hive has reached its full potential

	var/datum/mutator_set/hive_mutators/mutators = new
	var/tier_slot_multiplier = 1.0
	var/larva_gestation_multiplier = 1.0
	var/bonus_larva_spawn_chance = 1.0

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
	xeno.hive_pos = XENO_LEADER(leader_num)
	xeno.handle_xeno_leader_pheromones()
	open_xeno_leader_positions -= leader_num

	hive_ui.update_xeno_keys()

	return TRUE

/datum/hive_status/proc/remove_hive_leader(var/mob/living/carbon/Xenomorph/xeno)
	var/leader_num = GET_XENO_LEADER_NUM(xeno.hive_pos)
	
	xeno.hive_pos = NORMAL_XENO
	xeno.handle_xeno_leader_pheromones()

	xeno_leader_list[leader_num] = null

	// Need to maintain ascending order of open_xeno_leader_positions
	for (var/i in 1 to queen_leader_limit)
		if (i > open_xeno_leader_positions.len || open_xeno_leader_positions[i] > leader_num)
			open_xeno_leader_positions.Insert(i, leader_num)
			break

	hive_ui.update_xeno_keys()

/datum/hive_status/proc/handle_xeno_leader_pheromones()
	for(var/mob/living/carbon/Xenomorph/L in xeno_leader_list)
		L.handle_xeno_leader_pheromones()

/datum/hive_status/proc/handle_nuke_alert(var/timing, var/area/loc)
	if (!totalXenos.len) //sanity check!
		return

	if(timing)
		xeno_message(SPAN_XENOANNOUNCE("The tallhosts have deployed a hive killer at [loc.name]! Stop it at all costs!"),2, hivenumber)
	else
		xeno_message(SPAN_XENOANNOUNCE("The hive killer has been disabled! Rejoice!"),2, hivenumber)

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
			"leader" = (IS_XENO_LEADER(X.hive_pos)),
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

	var/burrowed_factor = min(stored_larva, sqrt(4*stored_larva))
	burrowed_factor = round(burrowed_factor)

	var/effective_total = totalXenos.len + burrowed_factor

	// no division by zero here, sir, nope.
	if(!effective_total)
		return slots

	// Tier 3 slots are always 25% of the total xenos in the hive
	slots[2] = max(0, Ceiling(0.25 * tier_slot_multiplier) - tier_3_xenos.len)

	// Tier 2 slots are between 25% and 50% of the hive, depending
	// on how many T3s there are.
	slots[1] = max(0, Ceiling(effective_total * (0.5 - tier_3_xenos.len / effective_total) * tier_slot_multiplier) - tier_2_xenos.len)

	return slots

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