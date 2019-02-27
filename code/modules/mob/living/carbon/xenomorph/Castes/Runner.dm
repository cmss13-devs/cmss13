/datum/caste_datum/runner
	caste_name = "Runner"
	upgrade_name = "Young"
	tier = 1
	upgrade = 0
	melee_damage_lower = 20
	melee_damage_upper = 25
	plasma_gain = 0.02
	plasma_max = 150
	caste_desc = "A fast, four-legged terror, but weak in sustained combat."
	armor_deflection = 5
	max_health = 120
	speed = -1.9
	charge_type = 1 //Pounce - Runner
	attack_delay = -4
	evolves_to = list("Lurker")
	pounce_delay = 35
	xeno_explosion_resistance = 20

/datum/caste_datum/runner/mature
	upgrade_name = "Mature"
	caste_desc = "A fast, four-legged terror, but weak in sustained combat. It looks a little more dangerous."
	upgrade = 1
	melee_damage_lower = 20
	melee_damage_upper = 30
	plasma_gain = 0.02
	plasma_max = 150
	armor_deflection = 5
	max_health = 140
	speed = -1.9

/datum/caste_datum/runner/elder
	upgrade_name = "Elder"
	caste_desc = "A fast, four-legged terror, but weak in sustained combat. It looks pretty strong."
	upgrade = 2
	melee_damage_lower = 25
	melee_damage_upper = 30
	plasma_gain = 0.02
	plasma_max = 200
	armor_deflection = 10
	max_health = 160
	speed = -2.0
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 40
	pounce_delay = 30

/datum/caste_datum/runner/ancient
	upgrade_name = "Ancient"
	caste_desc = "Not what you want to run into in a dark alley. It looks fucking deadly."
	upgrade = 3
	melee_damage_lower = 25
	melee_damage_upper = 35
	plasma_gain = 0.02
	plasma_max = 250
	armor_deflection = 15
	max_health = 160
	speed = -2.1
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 45
	pounce_delay = 25

/mob/living/carbon/Xenomorph/Runner
	caste_name = "Runner"
	name = "Runner"
	desc = "A small red alien that looks like it could run fairly quickly..."
	icon = 'icons/xeno/xenomorph_64x64.dmi' //They are now like, 2x1 or something
	icon_state = "Runner Walking"
	flags_pass = PASSTABLE
	tier = 1
	pixel_x = -16  //Needed for 2x2
	old_x = -16
	pull_speed = -1
	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/xenohide,
		/datum/action/xeno_action/activable/pounce,
		)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/vent_crawl,
		)
