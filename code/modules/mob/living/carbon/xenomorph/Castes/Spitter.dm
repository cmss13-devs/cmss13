/datum/caste_datum/spitter
	caste_name = "Spitter"
	upgrade_name = "Young"
	tier = 2
	upgrade = 0
	melee_damage_lower = 20
	melee_damage_upper = 30
	max_health = 210
	plasma_gain = 0.034
	plasma_max = 600
	spit_delay = 20
	speed = -0.6
	caste_desc = "Ptui!"
	armor_deflection = 15
	spit_types = list(/datum/ammo/xeno/toxin/medium, /datum/ammo/xeno/acid/medium)
	evolves_to = list("Boiler")
	deevolves_to = "Sentinel"
	xeno_explosion_resistance = 40
	acid_level = 2

/datum/caste_datum/spitter/mature
	upgrade_name = "Mature"
	caste_desc = "A ranged damage dealer. It looks a little more dangerous."
	upgrade = 1
	max_health = 225
	melee_damage_lower = 25
	melee_damage_upper = 35
	plasma_gain = 0.036
	plasma_max = 700
	armor_deflection = 20
	spit_delay = 20
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 40

/datum/caste_datum/spitter/elder
	upgrade_name = "Elder"
	caste_desc = "A ranged damage dealer. It looks pretty strong."
	upgrade = 2
	max_health = 235
	melee_damage_lower = 28
	melee_damage_upper = 38
	plasma_gain = 0.038
	plasma_max = 800
	armor_deflection = 25
	spit_delay = 15
	tacklemin = 4
	tacklemax = 5
	tackle_chance = 45
	speed = -0.7

/datum/caste_datum/spitter/ancient
	upgrade_name = "Ancient"
	caste_desc = "A ranged destruction machine."
	upgrade = 3
	max_health = 250
	melee_damage_lower = 30
	melee_damage_upper = 40
	plasma_gain = 0.04
	plasma_max = 850
	armor_deflection = 28
	spit_delay = 12
	tacklemin = 4
	tacklemax = 5
	tackle_chance = 48
	speed = -0.8

/mob/living/carbon/Xenomorph/Spitter
	caste_name = "Spitter"
	name = "Spitter"
	desc = "A gross, oozing alien of some kind."
	icon = 'icons/Xeno/xenomorph_48x48.dmi'
	icon_state = "Spitter Walking"
	pixel_x = -12
	old_x = -12

	tier = 2
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

	new_actions = list(
		/datum/action/xeno_action/activable/spray_acid,
	)
