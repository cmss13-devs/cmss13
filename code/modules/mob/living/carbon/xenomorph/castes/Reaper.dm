/datum/caste_datum/Reaper
	caste_type = XENO_CASTE_REAPER
	tier = 3

	melee_damage_lower = XENO_DAMAGE_TIER_4
	melee_damage_upper = XENO_DAMAGE_TIER_6
	melee_vehicle_damage = XENO_DAMAGE_TIER_9 //Queen and Ravs have extra multiplier when dealing damage in multitile_interaction.dm
	max_health = XENO_HEALTH_TIER_9
	plasma_gain = XENO_PLASMA_GAIN_TIER_7
	plasma_max = XENO_PLASMA_TIER_12
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_4
	armor_deflection = XENO_ARMOR_TIER_2
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_FASTMOD_TIER_6

	build_time_mult = BUILD_TIME_MULT_BUILDER

	is_intelligent = 1
	evolution_allowed = FALSE
	fire_immunity = FIRE_IMMUNITY_NO_DAMAGE|FIRE_IMMUNITY_NO_IGNITE
	caste_desc = "He who reaps"
	deevolves_to = list("Larva")
	can_hold_facehuggers = 1
	can_hold_eggs = CAN_HOLD_ONE_HAND
	acid_level = 2
	weed_level = WEED_LEVEL_STANDARD
	can_be_revived = FALSE

	spit_delay = 25

	tackle_min = 2
	tackle_max = 6
	tackle_chance = 55

	aura_strength = 4
	tacklestrength_min = 5
	tacklestrength_max = 6


/mob/living/carbon/xenomorph/reaper
	caste_type = XENO_CASTE_REAPER
	name = XENO_CASTE_REAPER
	desc = "An alien reaper"
	icon_size = 64
	icon_state = "Reaper Walking"
	plasma_types = list(PLASMA_EGG, PLASMA_CATECHOLAMINE)
	tier = 3
	pixel_x = -12
	old_x = -12
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/corrosive_acid/weak,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/activable/place_construction,
		/datum/action/xeno_action/onclick/plant_weeds, //first macro
		/datum/action/xeno_action/onclick/choose_resin, //second macro
		/datum/action/xeno_action/activable/secrete_resin, //third macro
				/datum/action/xeno_action/activable/queen_give_plasma, //fourth macro
		/datum/action/xeno_action/onclick/tacmap,
		/datum/action/xeno_action/activable/blockade,
		/datum/action/xeno_action/activable/weed_nade,
		)

	icon_xeno = 'icons/mob/xenos/reaper.dmi'
	icon_xenonid = 'icons/mob/xenonids/praetorian.dmi'

	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/rename_tunnel,
		/mob/living/carbon/xenomorph/proc/set_hugger_reserve_for_morpher,
	)
	mutation_type = REAPER_NORMAL



