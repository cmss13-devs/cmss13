/datum/caste_datum/pathogen/conditor
	caste_type = PATHOGEN_CREATURE_CONDITOR
	tier = 3

	melee_damage_lower = XENO_DAMAGE_TIER_3
	melee_damage_upper = XENO_DAMAGE_TIER_3
	melee_vehicle_damage = XENO_DAMAGE_TIER_3
	max_health = XENO_HEALTH_TIER_6
	plasma_gain = XENO_PLASMA_GAIN_TIER_10
	plasma_max = XENO_PLASMA_TIER_10
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_2
	armor_deflection = XENO_ARMOR_MOD_MED
	evasion = XENO_EVASION_LOW
	speed = XENO_SPEED_TIER_6

	attack_delay = 2

	available_strains = list()
	behavior_delegate_type = /datum/behavior_delegate/pathogen_base/conditor

	deevolves_to = list(PATHOGEN_CREATURE_NEOMORPH)
	caste_desc = "The shaper and cultivator of the Confluence."
	spit_types = list(/datum/ammo/xeno/toxin, /datum/ammo/xeno/acid/spatter)
	evolves_to = list()

	heal_resting = 1
	is_intelligent = TRUE

	minimap_icon = "conditor"
	evolution_allowed = FALSE
	royal_caste = TRUE

	build_time_mult = BUILD_TIME_MULT_HIVELORD
	max_build_dist = 1

/datum/caste_datum/pathogen/conditor/New()
	. = ..()
	resin_build_order = GLOB.resin_build_order_pathogen_better

/mob/living/carbon/xenomorph/conditor
	caste_type = PATHOGEN_CREATURE_CONDITOR
	name = PATHOGEN_CREATURE_CONDITOR
	desc = "A masterful cultivator of mycelium and death."
	icon_size = 48
	icon_state = "Neomorph Walking"
	plasma_types = list()
	pixel_x = -12
	old_x = -12
	tier = 3
	organ_value = 5000
	base_actions = list(
		/datum/action/xeno_action/onclick/toggle_seethrough,
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/place_pathogen_structure/not_primary,
		/datum/action/xeno_action/onclick/build_tunnel,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/onclick/plant_weeds/pathogen/macro_one, // Macro 1
		/datum/action/xeno_action/activable/xeno_spit/macro_two, // Macro 2
		/datum/action/xeno_action/onclick/choose_resin/pathogen/not_primary,
		/datum/action/xeno_action/activable/secrete_resin/pathogen/thick, // Macro 3 // Shared macro with Neomorph
		/datum/action/xeno_action/onclick/shift_spits/macro_four, // Macro 4
		/datum/action/xeno_action/onclick/blight_slash, //Macro 5
	)
	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/vent_crawl,
	)
	claw_type = CLAW_TYPE_SHARP

	tackle_min = 2
	tackle_max = 6

	icon_xeno = 'icons/mob/pathogen/conditor.dmi'
	icon_xenonid = 'icons/mob/pathogen/conditor.dmi'

	acid_overlay = icon('icons/mob/pathogen/conditor.dmi', "Conditor-Spit")

	weed_food_icon = 'icons/mob/xenos/weeds_48x48.dmi'
	mycelium_food_icon = 'icons/mob/pathogen/pathogen_weeds_48x48.dmi'
	weed_food_states = list("Conditor_1","Conditor_2","Conditor_3")
	weed_food_states_flipped = list("Conditor_1","Conditor_2","Conditor_3")

	AUTOWIKI_SKIP(TRUE)
	hivenumber = XENO_HIVE_PATHOGEN
	speaking_noise = "pathogen_talk"
	acid_blood_damage = 0
	bubble_icon = "pathogenroyal"
	fire_immunity = FIRE_VULNERABILITY
	aura_strength = 3

/datum/behavior_delegate/pathogen_base/conditor
	name = "Base Conditor Behavior Delegate"

