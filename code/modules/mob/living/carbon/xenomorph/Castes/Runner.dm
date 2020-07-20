/datum/caste_datum/runner
	caste_name = "Runner"
	caste_desc = "A fast, four-legged terror, but weak in sustained combat."
	tier = 1
	melee_damage_lower = XENO_DAMAGE_TIER_1
	melee_damage_upper = XENO_DAMAGE_TIER_2
	plasma_gain = XENO_PLASMA_GAIN_TIER_1
	plasma_max = XENO_PLASMA_TIER_2
	xeno_explosion_resistance = XENO_LOW_EXPLOSIVE_ARMOR
	armor_deflection = XENO_NO_ARMOR
	max_health = XENO_HEALTH_RUNNER
	armor_hardiness_mult = XENO_ARMOR_FACTOR_LOW
	evasion = XENO_EVASION_HIGH
	speed = XENO_SPEED_RUNNER
	attack_delay = -4
	evolves_to = list("Lurker")
	deevolves_to = "Larva"

	tacklemin = 3
	tacklemax = 4
	tackle_chance = 40

/mob/living/carbon/Xenomorph/Runner
	caste_name = "Runner"
	name = "Runner"
	desc = "A small red alien that looks like it could run fairly quickly..."
	icon = 'icons/mob/xenos/runner.dmi' //They are now like, 2x1 or something
	icon_state = "Runner Walking"
	icon_size = 64
	layer = MOB_LAYER
	plasma_types = list(PLASMA_CATECHOLAMINE)
	tier = 1
	pixel_x = -16  //Needed for 2x2
	old_x = -16
	pull_speed = -0.5
	viewsize = 9
	
	actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/onclick/xenohide,
		/datum/action/xeno_action/activable/pounce/runner,
		/datum/action/xeno_action/activable/runner_skillshot,
		/datum/action/xeno_action/onclick/toggle_long_range/runner,
		)
	inherent_verbs = list(
		/mob/living/carbon/Xenomorph/proc/vent_crawl,
		)
	mutation_type = RUNNER_NORMAL

/mob/living/carbon/Xenomorph/Runner/initialize_pass_flags()
	..()
	flags_pass = SETUP_LIST_FLAGS(PASS_FLAGS_CRAWLER)