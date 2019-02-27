/datum/caste_datum/lurker
	caste_name = "Lurker"
	upgrade_name = "Young"
	tier = 2
	upgrade = 0
	melee_damage_lower = 25
	melee_damage_upper = 35
	max_health = 160
	plasma_gain = 0.1
	plasma_max = 100
	deevolves_to = "Runner"
	caste_desc = "A fast, powerful backline combatant."
	speed = -1.6 //Not as fast as runners, but faster than other xenos.
	charge_type = 2 //Pounce - Hunter
	armor_deflection = 15
	attack_delay = -2
	pounce_delay = 55
	evolves_to = list("Ravager")
	xeno_explosion_resistance = 40

/datum/caste_datum/lurker/mature
	upgrade_name = "Mature"
	caste_desc = "A fast, powerful backline combatant. It looks a little more dangerous."
	upgrade = 1
	melee_damage_lower = 30
	melee_damage_upper = 40
	max_health = 170
	plasma_gain = 0.107
	plasma_max = 150
	speed = -1.7
	armor_deflection = 20
	pounce_delay = 50
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 40

/datum/caste_datum/lurker/elder
	upgrade_name = "Elder"
	caste_desc = "A fast, powerful backline combatant. It looks pretty strong."
	upgrade = 2
	melee_damage_lower = 35
	melee_damage_upper = 45
	max_health = 175
	plasma_gain = 0.114
	plasma_max = 175
	speed = -1.8
	armor_deflection = 25
	pounce_delay = 48
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 45
	attack_delay = -3

/datum/caste_datum/lurker/ancient
	upgrade_name = "Ancient"
	caste_desc = "A completely unmatched hunter. No, not even the Yautja can match you."
	upgrade = 3
	melee_damage_lower = 40
	melee_damage_upper = 50
	max_health = 190
	plasma_gain = 0.15
	plasma_max = 190
	speed = -1.9
	armor_deflection = 28
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
	max_health = 250
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
	icon = 'icons/Xeno/xenomorph_48x48.dmi'
	icon_state = "Lurker Walking"
	pixel_x = -12
	old_x = -12
	tier = 2
	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/activable/pounce
		)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/vent_crawl,
		)
