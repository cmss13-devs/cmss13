/datum/caste_datum/pathogen/sprinter
	caste_type = PATHOGEN_CREATURE_SPRINTER
	caste_desc = "A fast, four-legged terror, but weak in sustained combat."
	tier = 1
	melee_damage_lower = XENO_DAMAGE_TIER_2
	melee_damage_upper = XENO_DAMAGE_TIER_3
	melee_vehicle_damage = 0
	plasma_gain = XENO_PLASMA_GAIN_TIER_1
	plasma_max = XENO_PLASMA_TIER_2
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_1
	armor_deflection = XENO_NO_ARMOR
	max_health = XENO_HEALTH_TIER_3
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_RUNNER
	attack_delay = -1

	available_strains = list()
	behavior_delegate_type = /datum/behavior_delegate/pathogen_base/sprinter
	evolves_to = list(PATHOGEN_CREATURE_NEOMORPH, PATHOGEN_CREATURE_BLIGHT)
	deevolves_to = list(PATHOGEN_CREATURE_BURSTER)

	tackle_min = 4
	tackle_max = 5
	tackle_chance = 40
	tacklestrength_min = 4
	tacklestrength_max = 4

	heal_resting = 1.4

	minimap_icon = "sprinter"

/mob/living/carbon/xenomorph/sprinter
	caste_type = PATHOGEN_CREATURE_SPRINTER
	name = PATHOGEN_CREATURE_SPRINTER
	desc = "A small white alien that looks like it could run fairly quickly..."
	icon = 'icons/mob/pathogen/sprinter.dmi'
	icon_state = "Sprinter Walking"
	icon_size = 64
	layer = MOB_LAYER
	plasma_types = list()
	tier = 1
	pixel_x = -16  //Needed for 2x2
	old_x = -16
	base_pixel_x = 0
	base_pixel_y = -20
	pull_speed = -0.5
	viewsize = 9
	organ_value = 3000

	mob_size = MOB_SIZE_XENO_SMALL

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/onclick/xenohide,
		/datum/action/xeno_action/activable/pounce/runner, // Macro 1
		/datum/action/xeno_action/activable/runner_skillshot, // Macro 2
		/datum/action/xeno_action/onclick/toggle_long_range/runner, // Macro 3
		/datum/action/xeno_action/onclick/blight_slash,
		/datum/action/xeno_action/onclick/tacmap,
	)
	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/vent_crawl,
	)

	icon_xeno = 'icons/mob/pathogen/sprinter.dmi'
	icon_xenonid = 'icons/mob/pathogen/sprinter.dmi'
	//need_weeds = FALSE

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	mycelium_food_icon = 'icons/mob/pathogen/pathogen_weeds_64x64.dmi'
	weed_food_states = list("Sprinter_1","Sprinter_2","Sprinter_3")
	weed_food_states_flipped = list("Sprinter_1","Sprinter_2","Sprinter_3")

	AUTOWIKI_SKIP(TRUE)
	hivenumber = XENO_HIVE_PATHOGEN
	speaking_noise = "pathogen_talk"
	acid_blood_damage = 0
	bubble_icon = "pathogen"

/mob/living/carbon/xenomorph/sprinter/initialize_pass_flags(datum/pass_flags_container/pass_flags_container)
	..()
	if (pass_flags_container)
		pass_flags_container.flags_pass |= PASS_FLAGS_CRAWLER

/mob/living/carbon/xenomorph/sprinter/recalculate_actions()
	. = ..()
	pull_multiplier *= 0.85
	if(is_zoomed)
		zoom_out()

/datum/behavior_delegate/pathogen_base/sprinter
	name = "Base Sprinter Behavior Delegate"

/datum/behavior_delegate/pathogen_base/sprinter/melee_attack_additional_effects_self()
	..()

	var/datum/action/xeno_action/onclick/xenohide/hide = get_action(bound_xeno, /datum/action/xeno_action/onclick/xenohide)
	if(hide)
		hide.post_attack()
