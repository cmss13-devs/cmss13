/datum/caste_datum/sentinel
	caste_name = "Sentinel"
	upgrade_name = "Young"
	tier = 1
	upgrade = 0
	melee_damage_lower = 10
	melee_damage_upper = 20
	max_health = 125
	plasma_gain = 10
	plasma_max = 300
	evolution_threshold = 200
	upgrade_threshold = 200
	spit_delay = 30
	caste_desc = "A weak ranged combat alien."
	tackle_chance = 40
	armor_deflection = 10
	speed = -0.8
	spit_types = list(/datum/ammo/xeno/toxin)
	evolves_to = list("Spitter")
	xeno_explosion_resistance = 20

/datum/caste_datum/sentinel/mature
	upgrade_name = "Mature"
	upgrade = 1
	melee_damage_lower = 15
	melee_damage_upper = 25
	max_health = 150
	plasma_gain = 15
	plasma_max = 400
	upgrade_threshold = 400
	spit_delay = 25
	caste_desc = "A ranged combat alien. It looks a little more dangerous."
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 45
	armor_deflection = 15
	speed = -0.9

/datum/caste_datum/sentinel/elder
	upgrade_name = "Elder"
	upgrade = 2
	melee_damage_lower = 20
	melee_damage_upper = 30
	max_health = 175
	plasma_gain = 20
	plasma_max = 500
	upgrade_threshold = 800
	spit_delay = 20
	caste_desc = "A ranged combat alien. It looks pretty strong."
	armor_deflection = 20
	tacklemin = 4
	tacklemax = 5
	tackle_chance = 50
	speed = -1.0

/datum/caste_datum/sentinel/ancient
	upgrade_name = "Ancient"
	upgrade = 3
	melee_damage_lower = 25
	melee_damage_upper = 35
	max_health = 200
	plasma_gain = 25
	plasma_max = 600
	spit_delay = 15
	caste_desc = "Neurotoxin Factory, don't let it get you."
	armor_deflection = 25
	tacklemin = 4
	tacklemax = 5
	tackle_chance = 55
	speed = -1.1

/mob/living/carbon/Xenomorph/Sentinel
	caste_name = "Sentinel"
	name = "Sentinel"
	desc = "A slithery, spitting kind of alien."
	icon = 'icons/Xeno/xenomorph_48x48.dmi'
	icon_state = "Sentinel Walking"
	health = 125
	maxHealth = 125
	plasma_stored = 300
	pixel_x = -12
	old_x = -12
	tier = 1
	upgrade = 0
	pull_speed = -1
	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/activable/corrosive_acid/drone,
		/datum/action/xeno_action/activable/xeno_spit,
		)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/vent_crawl,
		)
