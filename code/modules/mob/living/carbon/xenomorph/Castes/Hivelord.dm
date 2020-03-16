/datum/caste_datum/hivelord
	caste_name = "Hivelord"
	upgrade_name = "Young"
	tier = 2
	upgrade = 0

	melee_damage_lower = XENO_DAMAGE_WEAK
	melee_damage_upper = XENO_DAMAGE_LOW
	max_health = XENO_HEALTH_HIGHMEDIUM
	plasma_gain = XENO_PLASMA_GAIN_VERYHIGH
	plasma_max = XENO_PLASMA_ULTRAHIGH
	crystal_max = XENO_CRYSTAL_HIGH
	xeno_explosion_resistance = XENO_LOW_EXPLOSIVE_ARMOR
	armor_deflection = XENO_LOW_ARMOR
	armor_hardiness_mult = XENO_ARMOR_FACTOR_MEDIUM
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_MEDIUM
	speed_mod = XENO_SPEED_MOD_SMALL

	evolution_allowed = FALSE
	caste_desc = "A builder of really big hives."
	deevolves_to = "Drone"
	aura_strength = 1 //Hivelord's aura is not extremely strong, but better than Drones. At the top, it's just a bit above a young Queen. Climbs by 0.5 to 2.5
	can_hold_facehuggers = 1
	can_hold_eggs = CAN_HOLD_TWO_HANDS
	can_denest_hosts = 1
	acid_level = 2
	aura_strength = 1.5
	weed_level = 2 //Starts with wider weeds by default
	build_time = BUILD_TIME_HIVELORD
	max_build_dist = 1

/datum/caste_datum/hivelord/mature
	upgrade_name = "Mature"
	caste_desc = "A builder of really big hives hives. It looks a little more dangerous."
	upgrade = 1

	tacklemin = 3
	tacklemax = 4
	tackle_chance = 40
	aura_strength = 2

/datum/caste_datum/hivelord/elder
	upgrade_name = "Elder"
	caste_desc = "A builder of really big hives. It looks pretty strong."
	upgrade = 2

	tacklemin = 4
	tacklemax = 5
	tackle_chance = 45
	aura_strength = 2.5

/datum/caste_datum/hivelord/ancient
	upgrade_name = "Ancient"
	caste_desc = "An extreme construction machine. It seems to be building walls..."
	upgrade = 3

	tacklemin = 5
	tacklemax = 6
	tackle_chance = 50
	aura_strength = 2.8

/mob/living/carbon/Xenomorph/Hivelord
	caste_name = "Hivelord"
	name = "Hivelord"
	desc = "A builder of really big hives."
	icon = 'icons/mob/xenos/xenomorph_64x64.dmi'
	icon_size = 64
	icon_state = "Hivelord Walking"
	plasma_types = list(PLASMA_PURPLE,PLASMA_PHEROMONE)
	pixel_x = -16
	old_x = -16
	mob_size = MOB_SIZE_BIG
	drag_delay = 6 //pulling a big dead xeno is hard
	tier = 2
	actions = list(
		/datum/action/xeno_action/xeno_resting,
		/datum/action/xeno_action/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/plant_weeds,
		/datum/action/xeno_action/choose_resin,
		/datum/action/xeno_action/activable/secrete_resin/hivelord,
		/datum/action/xeno_action/activable/place_construction,
		/datum/action/xeno_action/activable/transfer_plasma/hivelord,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/emit_pheromones,
		/datum/action/xeno_action/toggle_speed
		)
	mutation_type = HIVELORD_NORMAL
