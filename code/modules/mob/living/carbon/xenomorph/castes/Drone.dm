/datum/caste_datum/drone
	caste_type = XENO_CASTE_DRONE
	tier = 1
	melee_damage_lower = XENO_DAMAGE_TIER_1
	melee_damage_upper = XENO_DAMAGE_TIER_2
	max_health = XENO_HEALTH_TIER_5
	plasma_gain = XENO_PLASMA_GAIN_TIER_8
	plasma_max = XENO_PLASMA_TIER_10
	crystal_max = XENO_CRYSTAL_LOW
	xeno_explosion_resistance = XENO_NO_EXPLOSIVE_ARMOR
	armor_deflection = XENO_NO_ARMOR
	evasion = XENO_EVASION_MEDIUM
	speed = XENO_SPEED_TIER_7

	build_time_mult = BUILD_TIME_MULT_BUILDER

	caste_desc = "A builder of hives. Only drones may evolve into Queens."
	evolves_to = list(XENO_CASTE_QUEEN, XENO_CASTE_BURROWER, XENO_CASTE_CARRIER, XENO_CASTE_HIVELORD) //Add more here seperated by commas
	deevolves_to = "Larva"
	can_hold_facehuggers = 1
	can_hold_eggs = CAN_HOLD_TWO_HANDS
	acid_level = 1
	weed_level = WEED_LEVEL_STANDARD

	tackle_min = 2
	tackle_max = 4
	tacklestrength_min = 3
	tacklestrength_max = 4

	aura_strength = 2

/datum/caste_datum/drone/New()
	. = ..()

	resin_build_order = GLOB.resin_build_order_drone

/mob/living/carbon/Xenomorph/Drone
	caste_type = XENO_CASTE_DRONE
	name = XENO_CASTE_DRONE
	desc = "An Alien Drone"
	icon_size = 48
	icon_state = "Drone Walking"
	plasma_types = list(PLASMA_PURPLE)
	tier = 1
	pixel_x = -12
	old_x = -12
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/corrosive_acid/weak,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/activable/place_construction,
		/datum/action/xeno_action/onclick/plant_weeds, //first macro
		/datum/action/xeno_action/onclick/choose_resin, //second macro
		/datum/action/xeno_action/activable/secrete_resin, //third macro
		/datum/action/xeno_action/activable/transfer_plasma //fourth macro
		)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/vent_crawl,
		/mob/living/carbon/Xenomorph/proc/rename_tunnel,
		)
	mutation_type = DRONE_NORMAL

/mob/living/carbon/Xenomorph/Drone/Initialize(mapload, mob/living/carbon/Xenomorph/oldXeno, h_number)
	. = ..()
	icon = get_icon_from_source(CONFIG_GET(string/alien_drone))
