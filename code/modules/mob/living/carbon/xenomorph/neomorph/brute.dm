/datum/caste_datum/pathogen/brute
	caste_type = NEOMORPH_BRUTE
	tier = 3

	melee_damage_lower = XENO_DAMAGE_TIER_4
	melee_damage_upper = XENO_DAMAGE_TIER_4
	melee_vehicle_damage = XENO_DAMAGE_TIER_4
	max_health = XENO_HEALTH_TIER_6
	plasma_gain = XENO_PLASMA_GAIN_TIER_8
	plasma_max = XENO_PLASMA_TIER_4
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_2
	armor_deflection = XENO_NO_ARMOR
	evasion = XENO_EVASION_LOW
	speed = XENO_SPEED_TIER_9

	attack_delay = 2 // VERY high slash damage, but attacks relatively slowly

	available_strains = list()
	behavior_delegate_type = /datum/behavior_delegate/pathogen_base

	deevolves_to = list(NEOMORPH_GROWN)
	caste_desc = "A fast, powerful combatant."
	evolves_to = list()

	heal_resting = 1
	minimum_evolve_time = 0

	minimap_icon = "brute"

/mob/living/carbon/xenomorph/brute
	caste_type = NEOMORPH_BRUTE
	name = NEOMORPH_BRUTE
	desc = "A sleek, fast alien with sharp claws."
	icon_size = 64
	icon_state = "Brute Walking"
	plasma_types = list()
	pixel_x = -16
	old_x = -16
	tier = 3
	organ_value = 10000
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/onclick/tacmap,
	)
	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/vent_crawl,
	)
	claw_type = CLAW_TYPE_SHARP

	tackle_min = 2
	tackle_max = 6

	icon_xeno = 'icons/mob/neo/brute.dmi'
	icon_xenonid = 'icons/mob/neo/brute.dmi'
	need_weeds = FALSE

	weed_food_icon = 'icons/mob/xenos/weeds_48x48.dmi'
	weed_food_states = list("Drone_1","Drone_2","Drone_3")
	weed_food_states_flipped = list("Drone_1","Drone_2","Drone_3")

	AUTOWIKI_SKIP(TRUE)
	hivenumber = XENO_HIVE_NEOMORPH
	speaking_noise = "neo_talk"
