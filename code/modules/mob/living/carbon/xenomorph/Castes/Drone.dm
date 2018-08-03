/datum/caste_datum/drone
	caste_name = "Drone"
	upgrade_name = "Young"
	tier = 1
	upgrade = 0
	melee_damage_lower = 10
	melee_damage_upper = 20
	max_health = 120
	plasma_max = 750
	evolution_threshold = 200
	upgrade_threshold = 200
	plasma_gain = 20
	speed = -0.8
	aura_strength = 0.5 //Drone's aura is the weakest. At the top of their evolution, it's equivalent to a Young Queen Climbs by 0.5 to 2
	caste_desc = "A builder of hives. Only drones may evolve into Queens."
	evolves_to = list("Queen", "Carrier", "Hivelord") //Add more here seperated by commas
	can_hold_facehuggers = 1
	can_hold_eggs = CAN_HOLD_TWO_HANDS

/datum/caste_datum/drone/mature
	upgrade_name = "Mature"
	upgrade = 1
	melee_damage_lower = 15
	melee_damage_upper = 25
	max_health = 145
	plasma_max = 800
	plasma_gain = 25
	upgrade_threshold = 400
	caste_desc = "The workhorse of the hive. It looks a little more dangerous."
	armor_deflection = 5
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 40
	speed = -0.9
	aura_strength = 1

/datum/caste_datum/drone/elder
	upgrade_name = "Elder"
	upgrade = 2
	melee_damage_lower = 20
	melee_damage_upper = 30
	max_health = 170
	plasma_max = 900
	plasma_gain = 30
	upgrade_threshold = 800
	caste_desc = "The workhorse of the hive. It looks a little more dangerous."
	armor_deflection = 10
	tackle_chance = 45
	speed = -1.0
	aura_strength = 1.5

/datum/caste_datum/drone/ancient
	upgrade_name = "Ancient"
	upgrade = 3
	melee_damage_lower = 25
	melee_damage_upper = 35
	max_health = 195
	plasma_max = 1000
	plasma_gain = 40
	caste_desc = "A very mean architect."
	armor_deflection = 15
	tacklemin = 4
	tacklemax = 5
	tackle_chance = 50
	speed = -1.1
	aura_strength = 2

/mob/living/carbon/Xenomorph/Drone
	caste_name = "Drone"
	name = "Drone"
	desc = "An Alien Drone"
	icon = 'icons/Xeno/xenomorph_48x48.dmi'
	icon_state = "Drone Walking"
	health = 120
	maxHealth = 120
	plasma_stored = 750
	tier = 1
	upgrade = 0
	pixel_x = -12
	old_x = -12
	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/plant_weeds,
		/datum/action/xeno_action/choose_resin,
		/datum/action/xeno_action/activable/secrete_resin,
		/datum/action/xeno_action/activable/transfer_plasma,
		/datum/action/xeno_action/activable/corrosive_acid/drone,
		/datum/action/xeno_action/emit_pheromones,
		)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/vent_crawl,
		)
