/datum/caste_datum/runner
	caste_type = XENO_CASTE_RUNNER
	caste_desc = "A fast, four-legged terror, but weak in sustained combat."
	tier = 1
	melee_damage_lower = XENO_DAMAGE_TIER_1
	melee_damage_upper = XENO_DAMAGE_TIER_2
	melee_vehicle_damage = 0
	plasma_gain = XENO_PLASMA_GAIN_TIER_1
	plasma_max = XENO_NO_PLASMA
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_1
	armor_deflection = XENO_NO_ARMOR
	max_health = XENO_HEALTH_RUNNER
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_RUNNER
	attack_delay = -4
	evolves_to = list(XENO_CASTE_LURKER)
	deevolves_to = list("Larva")

	tackle_min = 4
	tackle_max = 5
	tackle_chance = 40
	tacklestrength_min = 4
	tacklestrength_max = 4

	heal_resting = 1.75

	minimap_icon = "runner"

/mob/living/carbon/xenomorph/runner
	caste_type = XENO_CASTE_RUNNER
	name = XENO_CASTE_RUNNER
	desc = "A small red alien that looks like it could run fairly quickly..."
	icon = 'icons/mob/xenos/runner.dmi'
	icon_state = "Runner Walking"
	icon_size = 64
	layer = MOB_LAYER
	plasma_types = list(PLASMA_CATECHOLAMINE)
	tier = 1
	pixel_x = -16  //Needed for 2x2
	old_x = -16
	base_pixel_x = 0
	base_pixel_y = -20
	pull_speed = -0.5
	viewsize = 9

	mob_size = MOB_SIZE_XENO_SMALL

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/onclick/xenohide,
		/datum/action/xeno_action/activable/pounce/runner,
		/datum/action/xeno_action/activable/runner_skillshot,
		/datum/action/xeno_action/onclick/toggle_long_range/runner,
	)
	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/vent_crawl,
	)
	mutation_type = RUNNER_NORMAL

	icon_xeno = 'icons/mob/xenos/runner.dmi'
	icon_xenonid = 'icons/mob/xenonids/runner.dmi'


/mob/living/carbon/xenomorph/runner/initialize_pass_flags(datum/pass_flags_container/PF)
	..()
	if (PF)
		PF.flags_pass = PASS_FLAGS_CRAWLER
