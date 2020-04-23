/datum/caste_datum/sentinel
	caste_name = "Sentinel"
	upgrade_name = "Young"
	tier = 1
	upgrade = 0
	melee_damage_lower = XENO_DAMAGE_LOW
	melee_damage_upper = XENO_DAMAGE_LOWPLUS
	max_health = XENO_HEALTH_LOW
	plasma_gain = XENO_PLASMA_GAIN_MED
	plasma_max = XENO_PLASMA_HIGHMEDIUM
	xeno_explosion_resistance = XENO_LOW_EXPLOSIVE_ARMOR
	armor_deflection = XENO_NO_ARMOR
	armor_hardiness_mult = XENO_ARMOR_FACTOR_LOW
	evasion = XENO_EVASION_MEDIUM
	speed = XENO_SPEED_HIGHFAST
	speed_mod = XENO_SPEED_MOD_MED
	spit_delay = 25
	caste_desc = "A weak ranged combat alien."
	tackle_chance = 40
	spit_types = list(/datum/ammo/xeno/toxin, /datum/ammo/xeno/toxin/burst)
	evolves_to = list("Spitter")
	deevolves_to = "Larva"
	acid_level = 1

/datum/caste_datum/sentinel/mature
	upgrade_name = "Mature"
	caste_desc = "A ranged combat alien. It looks a little more dangerous."
	upgrade = 1
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 45

/datum/caste_datum/sentinel/elder
	upgrade_name = "Elder"
	caste_desc = "A ranged combat alien. It looks pretty strong."
	upgrade = 2
	tacklemin = 4
	tacklemax = 5
	tackle_chance = 50
	spit_delay = 20

/datum/caste_datum/sentinel/ancient
	upgrade_name = "Ancient"
	caste_desc = "Neurotoxin Factory, don't let it get you."
	upgrade = 3
	tacklemin = 4
	tacklemax = 5
	tackle_chance = 55
	spit_delay = 15

/mob/living/carbon/Xenomorph/Sentinel
	caste_name = "Sentinel"
	name = "Sentinel"
	desc = "A slithery, spitting kind of alien."
	icon = 'icons/mob/xenos/xenomorph_48x48.dmi'
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
		/datum/action/xeno_action/activable/corrosive_acid/drone,
		/datum/action/xeno_action/onclick/shift_spits,
		/datum/action/xeno_action/activable/xeno_spit
		)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/vent_crawl,
		)
	mutation_type = SENTINEL_NORMAL