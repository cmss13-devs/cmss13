/datum/caste_datum/pathogen/neophyte
	caste_type = PATHOGEN_CREATURE_NEOPHYTE
	tier = 1

	melee_damage_lower = XENO_DAMAGE_TIER_2
	melee_damage_upper = XENO_DAMAGE_TIER_3
	melee_vehicle_damage = XENO_DAMAGE_TIER_3
	max_health = XENO_HEALTH_TIER_4
	plasma_gain = XENO_PLASMA_GAIN_TIER_6
	plasma_max = XENO_PLASMA_TIER_8
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_1
	armor_deflection = XENO_NO_ARMOR
	evasion = XENO_EVASION_MEDIUM
	speed = XENO_SPEED_NEOPHYTE

	attack_delay = 1.5

	available_strains = list()
	behavior_delegate_type = /datum/behavior_delegate/pathogen_base/neomorph/neophyte

	deevolves_to = list(PATHOGEN_CREATURE_BURSTER)
	caste_desc = "A juvenile Neomorph not yet fully developed."
	evolves_to = list(PATHOGEN_CREATURE_NEOMORPH)
	early_evolves_to = list(PATHOGEN_CREATURE_NEOMORPH, PATHOGEN_CREATURE_BLIGHT)

	heal_resting = 1
	max_build_dist = 1

	minimap_icon = "neophyte"

/datum/caste_datum/pathogen/neophyte/New()
	. = ..()
	resin_build_order = GLOB.resin_build_order_pathogen_base

/mob/living/carbon/xenomorph/neophyte
	caste_type = PATHOGEN_CREATURE_NEOPHYTE
	name = PATHOGEN_CREATURE_NEOPHYTE
	desc = "A small and nimble juvenile alien with sharp claws."
	icon_size = 48
	icon_state = "Neophyte Walking"
	plasma_types = list()
	pixel_x = -12
	old_x = -12
	tier = 2
	organ_value = 5000
	base_actions = list(
		/datum/action/xeno_action/onclick/toggle_seethrough/pathogen,
		/datum/action/xeno_action/onclick/xeno_resting/pathogen,
		/datum/action/xeno_action/onclick/release_haul/pathogen,
		/datum/action/xeno_action/watch_xeno/pathogen,
		/datum/action/xeno_action/activable/tail_stab/pathogen,
		/datum/action/xeno_action/activable/place_pathogen_structure/not_primary,
		/datum/action/xeno_action/onclick/plant_weeds/pathogen/macro_one, // Macro 1
		/datum/action/xeno_action/activable/pounce/runner/pathogen/neomorph/neophyte, // Macro 2
		/datum/action/xeno_action/onclick/choose_resin/pathogen/not_primary,
		/datum/action/xeno_action/activable/secrete_resin/pathogen, // Macro 3 // Shared macro with Conditor
	)
	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/vent_crawl,
	)
	claw_type = CLAW_TYPE_SHARP

	tackle_min = 2
	tackle_max = 6

	icon_xeno = 'icons/mob/pathogen/neophyte.dmi'
	icon_xenonid = 'icons/mob/pathogen/neophyte.dmi'

	skull = /obj/item/skull/pathogen_neophyte
	pelt = /obj/item/pelt/pathogen_neophyte

	weed_food_icon = 'icons/mob/xenos/weeds_48x48.dmi'
	mycelium_food_icon = 'icons/mob/pathogen/pathogen_weeds_48x48.dmi'
	weed_food_states = list("Neophyte_1","Neophyte_2","Neophyte_3")
	weed_food_states_flipped = list("Neophyte_1","Neophyte_2","Neophyte_3")

	AUTOWIKI_SKIP(TRUE)
	hivenumber = XENO_HIVE_PATHOGEN
	speaking_noise = "pathogen_talk"

	mob_size = MOB_SIZE_BIG
	acid_blood_damage = 0
	bubble_icon = "pathogen"
	fire_immunity = FIRE_VULNERABILITY

/datum/behavior_delegate/pathogen_base/neomorph/neophyte
	name = "Base Neophyte Behavior Delegate"
	slash_slow_duration = 20
