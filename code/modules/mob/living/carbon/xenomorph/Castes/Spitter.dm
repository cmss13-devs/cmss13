/datum/caste_datum/spitter
	caste_name = "Spitter"
	upgrade_name = "Young"
	tier = 2
	upgrade = 0
	melee_damage_lower = 15
	melee_damage_upper = 25
	max_health = 160
	plasma_gain = 20
	plasma_max = 600
	evolution_threshold = 250
	upgrade_threshold = 250
	spit_delay = 25
	speed = -0.5
	caste_desc = "Ptui!"
	armor_deflection = 15
	spit_types = list(/datum/ammo/xeno/toxin/medium, /datum/ammo/xeno/acid/medium)
	evolves_to = list("Boiler")
	xeno_explosion_resistance = 40

/datum/caste_datum/spitter/mature
	upgrade_name = "Mature"
	upgrade = 1
	melee_damage_lower = 20
	melee_damage_upper = 30
	max_health = 180
	plasma_gain = 25
	plasma_max = 700
	upgrade_threshold = 800
	spit_delay = 20
	caste_desc = "A ranged damage dealer. It looks a little more dangerous."
	armor_deflection = 20
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 40
	speed = -0.6

/datum/caste_datum/spitter/elder
	upgrade_name = "Elder"
	upgrade = 2
	melee_damage_lower = 25
	melee_damage_upper = 35
	max_health = 200
	plasma_gain = 30
	plasma_max = 800
	upgrade_threshold = 1600
	spit_delay = 15
	caste_desc = "A ranged damage dealer. It looks pretty strong."
	armor_deflection = 25
	tacklemin = 4
	tacklemax = 5
	tackle_chance = 45
	speed = -0.7

/datum/caste_datum/spitter/ancient
	upgrade_name = "Ancient"
	upgrade = 3
	melee_damage_lower = 30
	melee_damage_upper = 40
	max_health = 220
	plasma_gain = 35
	plasma_max = 900
	spit_delay = 10
	caste_desc = "A ranged destruction machine."
	armor_deflection = 30
	tacklemin = 5
	tacklemax = 6
	tackle_chance = 50
	speed = -0.8

/mob/living/carbon/Xenomorph/Spitter
	caste_name = "Spitter"
	name = "Spitter"
	desc = "A gross, oozing alien of some kind."
	icon = 'icons/Xeno/xenomorph_48x48.dmi'
	icon_state = "Spitter Walking"
	health = 160
	maxHealth = 160
	plasma_stored = 600
	pixel_x = -12
	old_x = -12

	tier = 2
	upgrade = 0
	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/shift_spits,
		/datum/action/xeno_action/activable/xeno_spit,
		)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/vent_crawl,
		)
