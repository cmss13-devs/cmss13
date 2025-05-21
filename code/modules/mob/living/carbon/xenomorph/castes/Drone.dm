/datum/caste_datum/drone
	caste_type = XENO_CASTE_DRONE
	tier = 1
	melee_damage_lower = XENO_DAMAGE_TIER_1
	melee_damage_upper = XENO_DAMAGE_TIER_2
	melee_vehicle_damage = XENO_DAMAGE_TIER_2
	max_health = XENO_HEALTH_TIER_6
	plasma_gain = XENO_PLASMA_GAIN_TIER_8
	plasma_max = XENO_PLASMA_TIER_10
	xeno_explosion_resistance = XENO_NO_EXPLOSIVE_ARMOR
	armor_deflection = XENO_NO_ARMOR
	evasion = XENO_EVASION_MEDIUM
	speed = XENO_SPEED_TIER_7

	available_strains = list(
		/datum/xeno_strain/gardener,
		/datum/xeno_strain/healer,
	)

	build_time_mult = BUILD_TIME_MULT_BUILDER

	caste_desc = "A builder of hives. Only drones may evolve into Queens."
	evolves_to = list(XENO_CASTE_QUEEN, XENO_CASTE_BURROWER, XENO_CASTE_CARRIER, XENO_CASTE_HIVELORD) //Add more here separated by commas
	early_evolves_to = list(XENO_CASTE_QUEEN, XENO_CASTE_BURROWER, XENO_CASTE_CARRIER, XENO_CASTE_HIVELORD, XENO_CASTE_LURKER, XENO_CASTE_WARRIOR, XENO_CASTE_SPITTER) //list of castes that can be evolved too prior to 20 minutes.
	deevolves_to = list(XENO_CASTE_LARVA)
	can_hold_facehuggers = 1
	can_hold_eggs = CAN_HOLD_TWO_HANDS
	acid_level = 1
	weed_level = WEED_LEVEL_STANDARD
	max_build_dist = 1

	tackle_min = 2
	tackle_max = 4
	tacklestrength_min = 3
	tacklestrength_max = 4

	aura_strength = 2

	minimum_evolve_time = 1 MINUTES

	minimap_icon = "drone"

/datum/caste_datum/drone/New()
	. = ..()

	resin_build_order = GLOB.resin_build_order_drone

/mob/living/carbon/xenomorph/drone
	caste_type = XENO_CASTE_DRONE
	name = XENO_CASTE_DRONE
	desc = "An alien drone"
	icon = 'icons/mob/xenos/castes/tier_1/drone.dmi'
	icon_size = 48
	icon_state = "Drone Walking"
	plasma_types = list(PLASMA_PURPLE)
	tier = 1
	organ_value = 800
	pixel_x = -12
	old_x = -12
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/corrosive_acid/weak,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/activable/place_construction,
		/datum/action/xeno_action/onclick/plant_weeds, //first macro
		/datum/action/xeno_action/onclick/choose_resin, //second macro
		/datum/action/xeno_action/activable/secrete_resin, //third macro
		/datum/action/xeno_action/activable/transfer_plasma, //fourth macro
		/datum/action/xeno_action/onclick/tacmap,
		)
	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/vent_crawl,
		/mob/living/carbon/xenomorph/proc/rename_tunnel,
		/mob/living/carbon/xenomorph/proc/set_hugger_reserve_for_morpher,
	)

	icon_xeno = 'icons/mob/xenos/castes/tier_1/drone.dmi'
	icon_xenonid = 'icons/mob/xenonids/castes/tier_1/drone.dmi'
	weed_food_icon = 'icons/mob/xenos/weeds_48x48.dmi'
	weed_food_states = list("Drone_1","Drone_2","Drone_3")
	weed_food_states_flipped = list("Drone_1","Drone_2","Drone_3")
	skull = /obj/item/skull/drone
	pelt = /obj/item/pelt/drone

/mob/living/carbon/xenomorph/drone/tutorial
	AUTOWIKI_SKIP(TRUE)

/mob/living/carbon/xenomorph/drone/tutorial/gib(datum/cause_data/cause = create_cause_data("gibbing", src))
	death(cause, 1)
