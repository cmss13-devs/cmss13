/datum/caste_datum/praetorian
	caste_name = "Praetorian"
	upgrade_name = "Young"
	tier = 3
	upgrade = 0

	melee_damage_lower = XENO_DAMAGE_LOW
	melee_damage_upper = XENO_DAMAGE_MEDIUMLOW
	max_health = XENO_HEALTH_PRAE
	plasma_gain = XENO_PLASMA_GAIN_HIGHMED
	plasma_max = XENO_PLASMA_VERYHIGH
	xeno_explosion_resistance = XENO_MEDIUM_EXPLOSIVE_ARMOR
	armor_deflection = XENO_LOWMED_ARMOR
	armor_hardiness_mult = XENO_ARMOR_FACTOR_MEDIUM
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_LOWHIGH
	speed_mod = XENO_SPEED_MOD_LARGE

	tackle_chance = 45
	evolution_allowed = FALSE
	deevolves_to = "Warrior"
	spit_delay = 20
	caste_desc = "The warleader of the hive."
	aura_strength = 0.5 // Base Prae: 1.0 -> 2.0 -> 3.0 -> 4.0. Royal Guard: 2.0 -> 3.0 -> 4.0 -> 4.0. Dancer/Oppressor: .5 -> 1.5 -> 2.5 -> 3.5
	spit_types = list(/datum/ammo/xeno/toxin/heavy, /datum/ammo/xeno/acid/heavy, /datum/ammo/xeno/sticky)
	acid_level = 2

	acid_spray_cooldown = 180
	tail_sweep_cooldown = 150
	
	// Screech buff TTL
	var/screech_duration = 150 
	
	// Strain variables

	// Vanilla
	var/xenoheal_screech_cooldown = 800
	var/xenoheal_screech_healamount = 125 // Amount to heal every seen xeno by

	// Royal guard
	var/xenodamage_screech_cooldown = 800
	var/xenodamage_screech_damagebuff = XENO_DAMAGE_MOD_MED // Amount to buff nearby xeno's damage by 

	// Oppressor 
	var/xenoarmor_screech_cooldown = 1000
	var/xenoarmor_screech_armorbuff = XENO_ARMOR_MOD_SMALL	 		 // Amount to buff xeno armor by (10)
	var/xenoarmor_screech_explosivebuff = XENO_EXPOSIVEARMOR_MOD_VERYSMALL // Amount to buff xeno explosion armor by (30)
	var/oppressor_grenade_cooldown = 400
	var/oppressor_grenade_setup = 7
	var/oppressor_grenade_fuse = 10
	var/oppressor_punch_cooldown = 75
	var/oppressor_punch_fling_dist = 3
	
	// Dancer
	var/xenomovement_screech_cooldown = 800
	var/xenomovement_screech_speedbuff = XENO_SPEED_MOD_VERYLARGE // Amount to buff xeno speed by
	var/dance_cooldown = 400
	var/dance_duration = 100
	var/tailattack_cooldown = 150
	var/tailattack_max_range = 2
	var/tailattack_abduct_range = 5
	var/tailattack_abduct_usetime_short = 15
	var/tailattack_abduct_usetime_long = 20
	var/tailattack_abduct_range_buff = 2 // Tiledistance buff for empowering abduct 
	var/tailattack_damagebuff = 4 //Bonus damage for impale attacks (2x coming out of a dance)
	var/dance_speed_buff = XENO_SPEED_MOD_VERYLARGE
	var/dance_evasion_buff = XENO_EVASION_MOD_ULTRA + XENO_EVASION_MOD_MED // evasion base: 40. evasion w/ dance: 74
	
/datum/caste_datum/praetorian/mature
	upgrade_name = "Mature"
	caste_desc = "The warleader of the hive. It looks a little stronger."
	upgrade = 1
	tackle_chance = 50
	aura_strength = 1.5
	acid_spray_cooldown = 170

/datum/caste_datum/praetorian/elder
	upgrade_name = "Elder"
	caste_desc = "The warleader of the hive. It looks pretty strong."
	upgrade = 2

	spit_delay = 15
	tackle_chance = 55
	aura_strength = 2.5
	acid_spray_cooldown = 160

/datum/caste_datum/praetorian/ancient
	upgrade_name = "Ancient"
	caste_desc = "Dread it, run from it, death arrives all the same."
	upgrade = 3

	spit_delay = 12
	tackle_chance = 55
	aura_strength = 3.5
	acid_spray_cooldown = 150

/datum/caste_datum/praetorian/primordial
	upgrade_name = "Primordial"
	caste_desc = "Why is this thing bigger than a dropship?!"
	upgrade = 4
	melee_damage_lower = 50
	melee_damage_upper = 60
	plasma_gain = 0.05
	plasma_max = 1500
	spit_delay = 0
	armor_deflection = 60
	tackle_chance = 60
	speed = -0.9
	aura_strength = 5.0
	max_health = XENO_UNIVERSAL_HPMULT * 350

/mob/living/carbon/Xenomorph/Praetorian
	caste_name = "Praetorian"
	name = "Praetorian"
	desc = "A huge, looming beast of an alien."
	icon = 'icons/mob/xenos/xenomorph_64x64.dmi'
	icon_size = 64
	icon_state = "Praetorian Walking"
	plasma_types = list(PLASMA_PHEROMONE,PLASMA_NEUROTOXIN)
	pixel_x = -16
	old_x = -16
	mob_size = MOB_SIZE_BIG
	drag_delay = 6 //pulling a big dead xeno is hard
	tier = 3
	mutation_type = PRAETORIAN_NORMAL
	
	// Variables unique to Praetorians.
	var/screech_sound_effect = 'sound/voice/xeno_praetorian_screech.ogg'

	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/prae_screech,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/emit_pheromones,
		/datum/action/xeno_action/activable/xeno_spit,
		/datum/action/xeno_action/shift_spits,
		/datum/action/xeno_action/activable/spray_acid
	)