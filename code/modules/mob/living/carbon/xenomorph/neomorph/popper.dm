/datum/caste_datum/pathogen/popper
	caste_type = NEOMORPH_POPPER
	tier = 1

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

	deevolves_to = list()
	caste_desc = "A fast, powerful combatant."
	evolves_to = list(NEOMORPH_GROWN)

	heal_resting = 1
	minimum_evolve_time = 0

	minimap_icon = "neomorph"

/mob/living/carbon/xenomorph/popper
	caste_type = NEOMORPH_POPPER
	name = NEOMORPH_POPPER
	desc = "A sleek, fast alien with sharp claws."
	icon_size = 32
	icon_state = "Popper Walking"
	plasma_types = list()
	tier = 1
	base_pixel_x = 0
	base_pixel_y = -20
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

	icon_xeno = 'icons/mob/neo/popper.dmi'
	icon_xenonid = 'icons/mob/neo/popper.dmi'
	need_weeds = FALSE

	weed_food_icon = 'icons/mob/xenos/weeds_48x48.dmi'
	weed_food_states = list("Drone_1","Drone_2","Drone_3")
	weed_food_states_flipped = list("Drone_1","Drone_2","Drone_3")

	AUTOWIKI_SKIP(TRUE)
	hivenumber = XENO_HIVE_NEOMORPH
	speaking_noise = "neo_talk"
