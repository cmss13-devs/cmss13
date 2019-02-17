/datum/caste_datum/drone
	caste_name = "Drone"
	upgrade_name = "Young"
	tier = 1
	upgrade = 0
	melee_damage_lower = 15
	melee_damage_upper = 25
	max_health = 145
	armor_deflection = 5
	plasma_gain = 0.027
	plasma_max = 800
	speed = -0.8
	aura_strength = 0.5 //Drone's aura is the weakest. At the top of their evolution, it's equivalent to a Young Queen Climbs by 0.5 to 2
	caste_desc = "A builder of hives. Only drones may evolve into Queens."
	evolves_to = list("Queen", "Burrower", "Carrier", "Hivelord") //Add more here seperated by commas
	can_hold_facehuggers = 1
	can_hold_eggs = CAN_HOLD_TWO_HANDS
	can_denest_hosts = 1
	xeno_explosion_resistance = 20
	acid_level = 1
	weed_level = 1

/datum/caste_datum/drone/mature
	upgrade_name = "Mature"
	upgrade = 1
	max_health = 170
	melee_damage_lower = 20
	melee_damage_upper = 30
	plasma_gain = 0.032
	plasma_max = 850
	armor_deflection = 10
	caste_desc = "The workhorse of the hive. It looks a little more dangerous."
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 40
	speed = -0.9
	aura_strength = 1.5

/datum/caste_datum/drone/elder
	upgrade_name = "Elder"
	upgrade = 2
	melee_damage_lower = 25
	melee_damage_upper = 35
	plasma_gain = 0.04	
	plasma_max = 900
	caste_desc = "The workhorse of the hive. It looks a little more dangerous."
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 45
	speed = -1.0
	aura_strength = 2

/datum/caste_datum/drone/ancient
	upgrade_name = "Ancient"
	upgrade = 3
	max_health = 195
	plasma_max = 1000
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
	tier = 1
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
