/datum/caste_datum/hivelord
	caste_name = "Hivelord"
	tier = 2

	melee_damage_lower = XENO_DAMAGE_TIER_1
	melee_damage_upper = XENO_DAMAGE_TIER_2
	max_health = XENO_HEALTH_TIER_5
	plasma_gain = XENO_PLASMA_GAIN_TIER_10
	plasma_max = XENO_PLASMA_TIER_10
	crystal_max = XENO_CRYSTAL_HIGH
	xeno_explosion_resistance = XENO_LOW_EXPLOSIVE_ARMOR
	armor_deflection = XENO_ARMOR_TIER_1
	armor_hardiness_mult = XENO_ARMOR_FACTOR_MEDIUM
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_2

	evolution_allowed = FALSE
	caste_desc = "A builder of really big hives."
	deevolves_to = "Drone"
	can_hold_facehuggers = 1
	can_hold_eggs = CAN_HOLD_TWO_HANDS
	acid_level = 2
	weed_level = WEED_LEVEL_STANDARD
	build_time = BUILD_TIME_HIVELORD
	max_build_dist = 1

	tackle_min = 2
	tackle_max = 4
	tackle_chance = 45
	tacklestrength_min = 4
	tacklestrength_max = 5
	
	aura_strength = 2.5

/mob/living/carbon/Xenomorph/Hivelord
	caste_name = "Hivelord"
	name = "Hivelord"
	desc = "A builder of really big hives."
	icon_source = "alien_hivelord"
	icon_size = 64
	icon_state = "Hivelord Walking"
	plasma_types = list(PLASMA_PURPLE,PLASMA_PHEROMONE)
	pixel_x = -16
	old_x = -16
	mob_size = MOB_SIZE_BIG
	drag_delay = 6 //pulling a big dead xeno is hard
	tier = 2
	actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/onclick/plant_weeds,
		/datum/action/xeno_action/onclick/choose_resin,
		/datum/action/xeno_action/activable/secrete_resin/hivelord,
		/datum/action/xeno_action/activable/place_construction,
		/datum/action/xeno_action/activable/transfer_plasma/hivelord,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/onclick/toggle_speed
		)
	mutation_type = HIVELORD_NORMAL
