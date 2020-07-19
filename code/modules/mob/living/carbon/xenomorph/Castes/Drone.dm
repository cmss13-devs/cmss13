/datum/caste_datum/drone
	caste_name = "Drone"
	tier = 1
	melee_damage_lower = XENO_DAMAGE_TIER_1
	melee_damage_upper = XENO_DAMAGE_TIER_2
	max_health = XENO_HEALTH_TIER_3
	plasma_gain = XENO_PLASMA_GAIN_TIER_8
	plasma_max = XENO_PLASMA_TIER_10
	crystal_max = XENO_CRYSTAL_LOW
	xeno_explosion_resistance = XENO_NO_EXPLOSIVE_ARMOR
	armor_deflection = XENO_ARMOR_TIER_1
	armor_hardiness_mult = XENO_ARMOR_FACTOR_LOW
	evasion = XENO_EVASION_MEDIUM
	speed = XENO_SPEED_TIER_7

	caste_desc = "A builder of hives. Only drones may evolve into Queens."
	evolves_to = list("Queen", "Burrower", "Carrier", "Hivelord") //Add more here seperated by commas
	deevolves_to = "Larva"
	can_hold_facehuggers = 1
	can_hold_eggs = CAN_HOLD_TWO_HANDS
	acid_level = 1
	weed_level = 1

	tacklemin = 3
	tacklemax = 4
	tackle_chance = 35
	aura_strength = 2

/mob/living/carbon/Xenomorph/Drone
	caste_name = "Drone"
	name = "Drone"
	desc = "An Alien Drone"
	icon = 'icons/mob/xenos/drone.dmi'
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
		/datum/action/xeno_action/activable/corrosive_acid/weak,
		/datum/action/xeno_action/onclick/emit_pheromones
		)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/vent_crawl,
		/mob/living/carbon/Xenomorph/proc/rename_tunnel,
		)
	mutation_type = DRONE_NORMAL
