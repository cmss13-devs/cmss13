/datum/caste_datum/lurker
	caste_name = "Lurker"
	upgrade_name = "Young"
	tier = 2
	upgrade = 0

	melee_damage_lower = XENO_DAMAGE_LOW
	melee_damage_upper = XENO_DAMAGE_MEDIUMLOW
	max_health = XENO_HEALTH_MEDIUM
	plasma_gain = XENO_PLASMA_GAIN_HIGH
	plasma_max = XENO_PLASMA_LOW
	xeno_explosion_resistance = XENO_LOW_EXPLOSIVE_ARMOR
	armor_deflection = XENO_NO_ARMOR
	armor_hardiness_mult = XENO_ARMOR_FACTOR_LOW
	evasion = XENO_EVASION_MEDIUM
	speed = XENO_SPEED_FAST
	speed_mod = XENO_SPEED_MOD_LARGE

	deevolves_to = "Runner"
	caste_desc = "A fast, powerful backline combatant."
	charge_type = 2 //Pounce - Hunter
	attack_delay = -2
	pounce_delay = 55
	evolves_to = list("Ravager")

/datum/caste_datum/lurker/mature
	upgrade_name = "Mature"
	caste_desc = "A fast, powerful backline combatant. It looks a little more dangerous."
	upgrade = 1

	pounce_delay = 50
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 40

/datum/caste_datum/lurker/elder
	upgrade_name = "Elder"
	caste_desc = "A fast, powerful backline combatant. It looks pretty strong."
	upgrade = 2

	pounce_delay = 48
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 45
	attack_delay = -3

/datum/caste_datum/lurker/ancient
	upgrade_name = "Ancient"
	caste_desc = "A completely unmatched hunter. No, not even the Yautja can match you."
	upgrade = 3

	pounce_delay = 45
	tacklemin = 4
	tacklemax = 5
	tackle_chance = 50
	attack_delay = -4

/datum/caste_datum/lurker/primordial
	upgrade_name = "Primordial"
	caste_desc = "The apex predator. The hunter who stands atop all others."
	upgrade = 4
	melee_damage_lower = 50
	melee_damage_upper = 55
	max_health = XENO_UNIVERSAL_HPMULT * 250
	plasma_gain = 0.2
	armor_deflection = 30
	melee_damage_lower = 60
	melee_damage_upper = 70
	attack_delay = -4
	pounce_delay = 20
	speed = -1.8
	plasma_gain = 0.4

/mob/living/carbon/Xenomorph/Lurker
	caste_name = "Lurker"
	name = "Lurker"
	desc = "A beefy, fast alien with sharp claws."
	icon = 'icons/mob/xenos/xenomorph_48x48.dmi'
	icon_state = "Lurker Walking"
	plasma_types = list(PLASMA_CATECHOLAMINE)
	pixel_x = -12
	old_x = -12
	tier = 2
	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/pounce
		)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/vent_crawl,
		)
	mutation_type = LURKER_NORMAL
