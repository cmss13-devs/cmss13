/datum/caste_datum/drone
	caste_name = "Drone"
	upgrade_name = "Young"
	tier = 1
	upgrade = 0
	melee_damage_lower = XENO_DAMAGE_LOW
	melee_damage_upper = XENO_DAMAGE_LOWPLUS
	plasma_gain = XENO_PLASMA_GAIN_HIGHMED
	plasma_max = XENO_PLASMA_VERYHIGH
	crystal_max = XENO_CRYSTAL_LOW
	armor_deflection = XENO_LOW_ARMOR
	max_health = XENO_HEALTH_MEDIUM
	armor_hardiness_mult = XENO_ARMOR_FACTOR_LOW
	evasion = XENO_EVASION_MEDIUM
	speed = XENO_SPEED_HIGHFAST
	speed_mod = XENO_SPEED_MOD_MED
	xeno_explosion_resistance = XENO_NO_EXPLOSIVE_ARMOR

	aura_strength = 0.5 //Drone's aura is the weakest. At the top of their evolution, it's equivalent to a Young Queen Climbs by 0.5 to 2
	caste_desc = "A builder of hives. Only drones may evolve into Queens."
	evolves_to = list("Queen", "Burrower", "Carrier", "Hivelord") //Add more here seperated by commas
	deevolves_to = "Larva"
	can_hold_facehuggers = 1
	can_hold_eggs = CAN_HOLD_TWO_HANDS
	can_denest_hosts = 1
	acid_level = 1
	weed_level = 1

/datum/caste_datum/drone/mature
	upgrade_name = "Mature"
	caste_desc = "The workhorse of the hive. It looks a little more dangerous."
	upgrade = 1
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 30
	aura_strength = 1.5

/datum/caste_datum/drone/elder
	upgrade_name = "Elder"
	caste_desc = "The workhorse of the hive. It looks a little more dangerous."
	upgrade = 2
	tacklemin = 3
	tacklemax = 4
	tackle_chance = 35
	aura_strength = 2

/datum/caste_datum/drone/ancient
	upgrade_name = "Ancient"
	caste_desc = "A very mean architect."
	upgrade = 3
	tacklemin = 4
	tacklemax = 5
	tackle_chance = 40
	aura_strength = 2.2

/mob/living/carbon/Xenomorph/Drone
	caste_name = "Drone"
	name = "Drone"
	desc = "An Alien Drone"
	icon = 'icons/mob/xenos/xenomorph_48x48.dmi'
	icon_size = 48
	icon_state = "Drone Walking"
	plasma_types = list(PLASMA_PURPLE)
	tier = 1
	pixel_x = -12
	old_x = -12
	actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/onclick/plant_weeds,
		/datum/action/xeno_action/onclick/choose_resin,
		/datum/action/xeno_action/activable/secrete_resin,
		/datum/action/xeno_action/activable/place_construction,
		/datum/action/xeno_action/activable/transfer_plasma,
		/datum/action/xeno_action/activable/corrosive_acid/drone,
		/datum/action/xeno_action/onclick/emit_pheromones
		)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/vent_crawl
		)
	mutation_type = DRONE_NORMAL
