/datum/caste_datum/lesser_drone
	caste_type = XENO_CASTE_LESSER_DRONE
	tier = 1
	melee_damage_lower = XENO_DAMAGE_TIER_1
	melee_damage_upper = XENO_DAMAGE_TIER_1
	melee_vehicle_damage = XENO_DAMAGE_TIER_1
	max_health = XENO_HEALTH_LESSER_DRONE
	plasma_gain = XENO_PLASMA_GAIN_TIER_7
	plasma_max = XENO_PLASMA_TIER_3
	xeno_explosion_resistance = XENO_NO_EXPLOSIVE_ARMOR
	armor_deflection = XENO_NO_ARMOR
	evasion = XENO_EVASION_LOW
	speed = XENO_SPEED_TIER_6

	evolution_allowed = FALSE
	can_be_revived = FALSE

	build_time_mult = BUILD_TIME_MULT_LESSER_DRONE
	behavior_delegate_type = /datum/behavior_delegate/lesser_drone_base

	caste_desc = "A builder of hives."
	can_hold_facehuggers = TRUE
	can_hold_eggs = CAN_HOLD_TWO_HANDS
	acid_level = 1
	weed_level = WEED_LEVEL_STANDARD
	max_build_dist = 1

	tackle_min = 4
	tackle_max = 5

	aura_strength = 1

	minimap_icon = "lesser_drone"

/datum/caste_datum/lesser_drone/New()
	. = ..()

	resin_build_order = GLOB.resin_build_order_lesser_drone

/mob/living/carbon/xenomorph/lesser_drone
	caste_type = XENO_CASTE_LESSER_DRONE
	name = XENO_CASTE_LESSER_DRONE
	desc = "An alien drone. Looks... smaller."
	icon = 'icons/mob/xenos/castes/tier_1/drone.dmi'
	icon_size = 48
	icon_state = "Lesser Drone Walking"
	plasma_types = list(PLASMA_PURPLE)
	tier = 0
	mob_flags = NOBIOSCAN
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
		/datum/action/xeno_action/onclick/plant_weeds/lesser, //first macro
		/datum/action/xeno_action/onclick/choose_resin, //second macro
		/datum/action/xeno_action/activable/secrete_resin, //third macro
		/datum/action/xeno_action/onclick/tacmap,
		)
	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/vent_crawl,
		/mob/living/carbon/xenomorph/proc/rename_tunnel,
		/mob/living/carbon/xenomorph/proc/set_hugger_reserve_for_morpher,
	)

	icon_xeno = 'icons/mob/xenos/castes/tier_0/lesser_drone.dmi'
	icon_xenonid = 'icons/mob/xenonids/castes/tier_0/lesser_drone.dmi'

	weed_food_icon = 'icons/mob/xenos/weeds.dmi'
	weed_food_states = list("Lesser_Drone_1","Lesser_Drone_2","Lesser_Drone_3")
	weed_food_states_flipped = list("Lesser_Drone_1","Lesser_Drone_2","Lesser_Drone_3")

/mob/living/carbon/xenomorph/lesser_drone/Login()
	var/last_ckey_inhabited = persistent_ckey
	. = ..()
	if(ckey == last_ckey_inhabited)
		return

	AddComponent(\
		/datum/component/temporary_mute,\
		"We aren't old enough to vocalize anything yet.",\
		"We aren't old enough to communicate like this yet.",\
		"We feel old enough to be able to vocalize and speak to the hivemind.",\
		3 MINUTES,\
	)

/mob/living/carbon/xenomorph/lesser_drone/age_xeno()
	if(stat == DEAD || !caste || QDELETED(src) || !client)
		return

	age = XENO_NORMAL

	hud_update()

	xeno_jitter(25)

/mob/living/carbon/xenomorph/lesser_drone/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_MOB_IS_XENO|PASS_MOB_THRU_XENO
		PF.flags_can_pass_all = PASS_MOB_IS_XENO|PASS_MOB_THRU_XENO

/mob/living/carbon/xenomorph/lesser_drone/ghostize(can_reenter_corpse = FALSE, aghosted = FALSE)
	. = ..()
	if(. && !aghosted && !QDELETED(src))
		gib()

/mob/living/carbon/xenomorph/lesser_drone/handle_ghost_message()
	return

/datum/behavior_delegate/lesser_drone_base
	name = "Base Lesser Drone Behavior Delegate"

/datum/behavior_delegate/lesser_drone_base/on_life()
	if(bound_xeno.body_position == STANDING_UP && !(locate(/obj/effect/alien/weeds) in get_turf(bound_xeno)))
		bound_xeno.adjustBruteLoss(5)
