/datum/caste_datum/pathogen/neomorph
	caste_type = PATHOGEN_CREATURE_NEOMORPH
	tier = 2

	melee_damage_lower = XENO_DAMAGE_TIER_3
	melee_damage_upper = XENO_DAMAGE_TIER_4
	melee_vehicle_damage = XENO_DAMAGE_TIER_4
	max_health = XENO_HEALTH_TIER_6
	plasma_gain = XENO_PLASMA_GAIN_TIER_8
	plasma_max = XENO_PLASMA_TIER_10
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_2
	armor_deflection = XENO_NO_ARMOR
	evasion = XENO_EVASION_MEDIUM
	speed = XENO_SPEED_TIER_8

	attack_delay = 2

	available_strains = list()
	behavior_delegate_type = /datum/behavior_delegate/pathogen_base/neomorph

	deevolves_to = list(PATHOGEN_CREATURE_SPRINTER)
	caste_desc = "A fast, powerful combatant."
	evolves_to = list(PATHOGEN_CREATURE_CONDITOR, PATHOGEN_CREATURE_BRUTE)

	heal_resting = 1

	minimap_icon = "neomorph"

/datum/caste_datum/pathogen/neomorph/New()
	. = ..()
	resin_build_order = GLOB.resin_build_order_pathogen_base

/mob/living/carbon/xenomorph/neomorph
	caste_type = PATHOGEN_CREATURE_NEOMORPH
	name = PATHOGEN_CREATURE_NEOMORPH
	desc = "A sleek, fast alien with sharp claws."
	icon_size = 48
	icon_state = "Neomorph Walking"
	plasma_types = list()
	pixel_x = -12
	old_x = -12
	tier = 2
	organ_value = 5000
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/onclick/build_tunnel,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/onclick/plant_weeds/pathogen,
		/datum/action/xeno_action/activable/pounce/runner/neomorph, // Macro 1
		/datum/action/xeno_action/onclick/choose_resin/pathogen, // Macro 2 // Shared macro with Conditor
		/datum/action/xeno_action/activable/secrete_resin/pathogen, // Macro 3 // Shared macro with Conditor
		/datum/action/xeno_action/activable/headbite/neomorph, // Macro 4
		/datum/action/xeno_action/onclick/blight_slash, //Macro 5
	)
	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/vent_crawl,
	)
	claw_type = CLAW_TYPE_SHARP

	tackle_min = 2
	tackle_max = 6

	icon_xeno = 'icons/mob/pathogen/neomorph.dmi'
	icon_xenonid = 'icons/mob/pathogen/neomorph.dmi'

	weed_food_icon = 'icons/mob/xenos/weeds_48x48.dmi'
	mycelium_food_icon = 'icons/mob/pathogen/pathogen_weeds_48x48.dmi'
	weed_food_states = list("Neomorph_1","Neomorph_2","Neomorph_3")
	weed_food_states_flipped = list("Neomorph_1","Neomorph_2","Neomorph_3")

	AUTOWIKI_SKIP(TRUE)
	hivenumber = XENO_HIVE_PATHOGEN
	speaking_noise = "pathogen_talk"
	acid_blood_damage = 0
	bubble_icon = "pathogen"
	fire_immunity = FIRE_VULNERABILITY

/datum/behavior_delegate/pathogen_base/neomorph
	name = "Base Neomorph Behavior Delegate"

	// Config
	var/slash_slow_duration = 35

/datum/behavior_delegate/pathogen_base/neomorph/melee_attack_additional_effects_target(mob/living/carbon/target_carbon)
	if (!isxeno_human(target_carbon))
		return

	if (HAS_TRAIT(target_carbon, TRAIT_FLOORED))
		new /datum/effects/xeno_slow(target_carbon, bound_xeno, null, null, get_xeno_stun_duration(target_carbon, slash_slow_duration))

	return

/datum/action/xeno_action/activable/pounce/runner/neomorph
	xeno_cooldown = 5 SECONDS
	knockdown = TRUE // Should we knock down the target?
	knockdown_duration = 1
	slash = TRUE // Do we slash upon reception?
	freeze_self = TRUE // Should we freeze ourselves after the lunge?
	freeze_time = 5
	can_be_shield_blocked = TRUE // Some legacy stuff, self explanatory
	ability_primacy = XENO_PRIMARY_ACTION_1

/datum/action/xeno_action/activable/headbite/neomorph
	ability_primacy = XENO_PRIMARY_ACTION_4
