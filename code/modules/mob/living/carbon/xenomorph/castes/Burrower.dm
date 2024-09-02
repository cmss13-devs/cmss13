//burrower is COMBAT support
/datum/caste_datum/burrower
	caste_type = XENO_CASTE_BURROWER
	tier = 2

	melee_damage_lower = XENO_DAMAGE_TIER_2
	melee_damage_upper = XENO_DAMAGE_TIER_3
	melee_vehicle_damage = XENO_DAMAGE_TIER_3
	max_health = XENO_HEALTH_TIER_6
	plasma_gain = XENO_PLASMA_GAIN_TIER_8
	plasma_max = XENO_PLASMA_TIER_6
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_4
	armor_deflection = XENO_ARMOR_TIER_2
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_4

	deevolves_to = list(XENO_CASTE_DRONE)
	caste_desc = "A digger and trapper."
	acid_level = 2
	weed_level = WEED_LEVEL_STANDARD
	evolution_allowed = FALSE

	behavior_delegate_type = /datum/behavior_delegate/burrower_base

	tackle_min = 3
	tackle_max = 5
	tackle_chance = 40
	tacklestrength_min = 4
	tacklestrength_max = 5

	burrow_cooldown = 20
	tunnel_cooldown = 70
	widen_cooldown = 70
	tremor_cooldown = 450

	minimum_evolve_time = 7 MINUTES

	minimap_icon = "burrower"

/mob/living/carbon/xenomorph/burrower
	caste_type = XENO_CASTE_BURROWER
	name = XENO_CASTE_BURROWER
	desc = "A beefy alien with sharp claws."
	icon = 'icons/mob/xenos/burrower.dmi'
	icon_size = 64
	icon_state = "Burrower Walking"
	layer = MOB_LAYER
	plasma_stored = 100
	plasma_types = list(PLASMA_PURPLE)
	pixel_x = -12
	old_x = -12
	base_pixel_x = 0
	base_pixel_y = -20
	tier = 2
	organ_value = 1500

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/corrosive_acid,
		/datum/action/xeno_action/activable/place_construction,
		/datum/action/xeno_action/onclick/build_tunnel,
		/datum/action/xeno_action/onclick/plant_weeds, //first macro
		/datum/action/xeno_action/onclick/place_trap, //second macro
		/datum/action/xeno_action/activable/burrow, //third macro
		/datum/action/xeno_action/onclick/tremor, //fourth macro
		/datum/action/xeno_action/active_toggle/toggle_meson_vision,
		/datum/action/xeno_action/onclick/tacmap,
		)

	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/vent_crawl,
		/mob/living/carbon/xenomorph/proc/rename_tunnel,
		/mob/living/carbon/xenomorph/proc/set_hugger_reserve_for_morpher,
	)

	icon_xeno = 'icons/mob/xenos/burrower.dmi'
	icon_xenonid = 'icons/mob/xenonids/burrower.dmi'

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	weed_food_states = list("Burrower_1","Burrower_2","Burrower_3")
	weed_food_states_flipped = list("Burrower_1","Burrower_2","Burrower_3")

/mob/living/carbon/xenomorph/burrower/ex_act(severity)
	if(HAS_TRAIT(src, TRAIT_ABILITY_BURROWED))
		return
	..()

/mob/living/carbon/xenomorph/burrower/attack_hand()
	if(HAS_TRAIT(src, TRAIT_ABILITY_BURROWED))
		return
	..()

/mob/living/carbon/xenomorph/burrower/attackby()
	if(HAS_TRAIT(src, TRAIT_ABILITY_BURROWED))
		return
	..()

/mob/living/carbon/xenomorph/burrower/get_projectile_hit_chance()
	. = ..()
	if(HAS_TRAIT(src, TRAIT_ABILITY_BURROWED))
		return 0

/datum/behavior_delegate/burrower_base
	name = "Base Burrower Behavior Delegate"
