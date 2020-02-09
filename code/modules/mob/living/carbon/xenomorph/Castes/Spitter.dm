/datum/caste_datum/spitter
	caste_name = "Spitter"
	upgrade_name = "Young"
	tier = 2
	upgrade = 0

	melee_damage_lower = XENO_DAMAGE_LOW
	melee_damage_upper = XENO_DAMAGE_MEDIUMLOW
	max_health = XENO_HEALTH_HIGHMEDIUM
	plasma_gain = XENO_PLASMA_GAIN_HIGHMED
	plasma_max = XENO_PLASMA_VERYHIGH
	xeno_explosion_resistance = XENO_LOW_EXPLOSIVE_ARMOR
	armor_deflection = XENO_LOW_ARMOR
	armor_hardiness_mult = XENO_ARMOR_FACTOR_LOW
	evasion = XENO_EVASION_MEDIUM
	speed = XENO_SPEED_LOWHIGH
	speed_mod = 0

	spit_delay = 20
	caste_desc = "Ptui!"
	spit_types = list(/datum/ammo/xeno/toxin/medium, /datum/ammo/xeno/acid/dot)
	evolves_to = list("Boiler")
	deevolves_to = "Sentinel"
	acid_spray_cooldown = 130
	acid_level = 2

/datum/caste_datum/spitter/mature
	upgrade_name = "Mature"
	caste_desc = "A ranged damage dealer. It looks a little more dangerous."
	upgrade = 1

	spit_delay = 20
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 40
	acid_spray_cooldown = 120

/datum/caste_datum/spitter/elder
	upgrade_name = "Elder"
	caste_desc = "A ranged damage dealer. It looks pretty strong."
	upgrade = 2

	spit_delay = 15
	tacklemin = 4
	tacklemax = 5
	tackle_chance = 45
	acid_spray_cooldown = 100

/datum/caste_datum/spitter/ancient
	upgrade_name = "Ancient"
	caste_desc = "A ranged destruction machine."
	upgrade = 3

	spit_delay = 12
	tacklemin = 4
	tacklemax = 5
	tackle_chance = 48
	acid_spray_cooldown = 90

/mob/living/carbon/Xenomorph/Spitter
	caste_name = "Spitter"
	name = "Spitter"
	desc = "A gross, oozing alien of some kind."
	icon = 'icons/mob/xenos/xenomorph_48x48.dmi'
	icon_size = 48
	icon_state = "Spitter Walking"
	plasma_types = list(PLASMA_NEUROTOXIN)
	pixel_x = -12
	old_x = -12
	acid_spray_activation_time = 3

	tier = 2
	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/shift_spits,
		/datum/action/xeno_action/activable/xeno_spit,
		)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/vent_crawl,
		)
	mutation_type = SPITTER_NORMAL
