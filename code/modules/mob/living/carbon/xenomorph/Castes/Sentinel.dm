/datum/caste_datum/sentinel
	caste_name = "Sentinel"
	tier = 1

	melee_damage_lower = XENO_DAMAGE_TIER_1
	melee_damage_upper = XENO_DAMAGE_TIER_2
	max_health = XENO_HEALTH_TIER_3
	plasma_gain = XENO_PLASMA_GAIN_TIER_5
	plasma_max = XENO_PLASMA_TIER_4
	xeno_explosion_resistance = XENO_LOW_EXPLOSIVE_ARMOR
	armor_deflection = XENO_NO_ARMOR
	armor_hardiness_mult = XENO_ARMOR_FACTOR_LOW
	evasion = XENO_EVASION_MEDIUM
	speed = XENO_SPEED_TIER_7

	caste_desc = "A weak ranged combat alien."
	spit_types = list(/datum/ammo/xeno/toxin, /datum/ammo/xeno/toxin/burst)
	evolves_to = list("Spitter")
	deevolves_to = "Larva"
	acid_level = 1

	tackle_min = 2
	tackle_max = 6
	tackle_chance = 50
	tacklestrength_min = 4
	tacklestrength_max = 5
	
	spit_delay = 20

/mob/living/carbon/Xenomorph/Sentinel
	caste_name = "Sentinel"
	name = "Sentinel"
	desc = "A slithery, spitting kind of alien."
	icon_source = "alien_sentinel"
	icon_size = 48
	icon_state = "Sentinel Walking"
	plasma_types = list(PLASMA_NEUROTOXIN)
	pixel_x = -12
	old_x = -12
	tier = 1
	actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/corrosive_acid/weak,
		/datum/action/xeno_action/onclick/shift_spits,
		/datum/action/xeno_action/activable/xeno_spit
		)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/vent_crawl,
		)
	mutation_type = SENTINEL_NORMAL