/datum/caste_datum/runner
	caste_name = "Runner"
	upgrade_name = "Young"
	tier = 1
	upgrade = 0
	melee_damage_lower = 10
	melee_damage_upper = 20
	plasma_gain = 1
	plasma_max = 100
	upgrade_threshold = 200
	evolution_threshold = 200
	caste_desc = "A fast, four-legged terror, but weak in sustained combat."
	max_health = 100
	speed = -1.8
	charge_type = 1 //Pounce - Runner
	attack_delay = -4
	evolves_to = list("Lurker")

/datum/caste_datum/runner/mature
	upgrade_name = "Mature"
	upgrade = 1
	melee_damage_lower = 15
	melee_damage_upper = 25
	plasma_gain = 2
	plasma_max = 150
	upgrade_threshold = 400
	caste_desc = "A fast, four-legged terror, but weak in sustained combat. It looks a little more dangerous."
	armor_deflection = 5
	max_health = 120
	speed = -1.9
	pounce_delay = 35

/datum/caste_datum/runner/elder
	upgrade_name = "Elder"
	upgrade = 2
	melee_damage_lower = 20
	melee_damage_upper = 30
	tacklemin = 3
	tacklemax = 5
	tackle_chance = 60
	plasma_max = 200
	upgrade_threshold = 800
	caste_desc = "A fast, four-legged terror, but weak in sustained combat. It looks pretty strong."
	armor_deflection = 10
	max_health = 150
	speed = -2.0
	attack_delay = -4
	pounce_delay = 30

/datum/caste_datum/runner/ancient
	upgrade_name = "Ancient"
	upgrade = 3
	melee_damage_lower = 25
	melee_damage_upper = 35
	tackle_chance = 70
	upgrade_threshold = 800
	caste_desc = "Not what you want to run into in a dark alley. It looks fucking deadly."
	armor_deflection = 10
	max_health = 140
	speed = -2.1
	attack_delay = -4
	pounce_delay = 25

/mob/living/carbon/Xenomorph/Runner
	caste_name = "Runner"
	name = "Runner"
	desc = "A small red alien that looks like it could run fairly quickly..."
	icon = 'icons/xeno/xenomorph_64x64.dmi' //They are now like, 2x1 or something
	icon_state = "Runner Walking"
	health = 100
	maxHealth = 100
	plasma_stored = 50
	flags_pass = PASSTABLE
	tier = 1
	upgrade = 0
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
