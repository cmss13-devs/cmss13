/datum/caste_datum/lesser_drone
	caste_type = XENO_CASTE_LESSER_DRONE
	tier = 1
	melee_damage_lower = XENO_DAMAGE_TIER_1
	melee_damage_upper = XENO_DAMAGE_TIER_1
	melee_vehicle_damage = XENO_DAMAGE_TIER_1
	max_health = XENO_HEALTH_LESSER_DRONE
	plasma_gain = XENO_PLASMA_GAIN_TIER_7
	plasma_max = XENO_PLASMA_TIER_3
	crystal_max = XENO_CRYSTAL_LOW
	xeno_explosion_resistance = XENO_NO_EXPLOSIVE_ARMOR
	armor_deflection = XENO_NO_ARMOR
	evasion = XENO_EVASION_LOW
	speed = XENO_SPEED_TIER_7

	evolution_allowed = FALSE
	can_be_revived = FALSE

	build_time_mult = BUILD_TIME_MULT_LESSER_DRONE

	caste_desc = "A builder of hives."
	can_hold_facehuggers = 1
	can_hold_eggs = CAN_HOLD_TWO_HANDS
	acid_level = 1
	weed_level = WEED_LEVEL_STANDARD
	max_build_dist = 1

	tackle_min = 4
	tackle_max = 4

	aura_strength = 1

	minimap_icon = "lesser_drone"

/datum/caste_datum/lesser_drone/New()
	. = ..()

	resin_build_order = GLOB.resin_build_order_lesser_drone

/mob/living/carbon/xenomorph/lesser_drone
	caste_type = XENO_CASTE_LESSER_DRONE
	name = XENO_CASTE_LESSER_DRONE
	desc = "An alien drone. Looks... smaller."
	icon = 'icons/mob/xenos/drone.dmi'
	icon_size = 48
	icon_state = "Lesser Drone Walking"
	plasma_types = list(PLASMA_PURPLE)
	tier = 0
	mob_size = MOB_SIZE_XENO_VERY_SMALL
	life_value = 0
	default_honor_value = 0
	show_only_numbers = TRUE
	counts_for_slots = FALSE
	counts_for_roundend = FALSE
	refunds_larva_if_banished = FALSE
	crit_health = 0
	gib_chance = 100
	acid_blood_damage = 15
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/corrosive_acid/weak,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/onclick/plant_weeds, //first macro
		/datum/action/xeno_action/onclick/choose_resin, //second macro
		/datum/action/xeno_action/activable/secrete_resin, //third macro
		/datum/action/xeno_action/onclick/tacmap,
		)
	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/vent_crawl,
		/mob/living/carbon/xenomorph/proc/rename_tunnel,
		/mob/living/carbon/xenomorph/proc/set_hugger_reserve_for_morpher,
	)

	mutation_type = DRONE_NORMAL

	icon_xeno = 'icons/mob/xenos/lesser_drone.dmi'
	icon_xenonid = 'icons/mob/xenonids/lesser_drone.dmi'

/mob/living/carbon/xenomorph/lesser_drone/age_xeno()
	if(stat == DEAD || !caste || QDELETED(src) || !client)
		return

	age = XENO_NORMAL

	hud_update()

	xeno_jitter(25)
