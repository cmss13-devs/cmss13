/datum/caste_datum/pathogen/brute
	caste_type = PATHOGEN_CREATURE_BRUTE
	tier = 3

	melee_damage_lower = XENO_DAMAGE_TIER_6
	melee_damage_upper = XENO_DAMAGE_TIER_6
	melee_vehicle_damage = XENO_DAMAGE_TIER_8
	max_health = XENO_HEALTH_TIER_14
	plasma_gain = XENO_PLASMA_GAIN_TIER_8
	plasma_max = XENO_PLASMA_TIER_7
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_10
	armor_deflection = XENO_ARMOR_TIER_3
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_4

	attack_delay = 0

	available_strains = list()
	behavior_delegate_type = /datum/behavior_delegate/pathogen_base/brute

	deevolves_to = list(PATHOGEN_CREATURE_NEOMORPH)
	caste_desc = "Why run if you can whack them to death."
	evolves_to = list()

	heal_resting = 1.8

	minimap_icon = "brute"
	evolution_allowed = FALSE

/mob/living/carbon/xenomorph/brute
	caste_type = PATHOGEN_CREATURE_BRUTE
	name = PATHOGEN_CREATURE_BRUTE
	desc = "A lumbering tank on legs."
	icon_size = 64
	icon_state = "Brute Walking"
	plasma_types = list()
	pixel_x = -16
	old_x = -16
	tier = 3
	organ_value = 8000
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/onclick/emit_pheromones,
		/datum/action/xeno_action/activable/tail_stab/pathogen_t3/brute,
		/datum/action/xeno_action/onclick/crusher_stomp/pathogen_brute, // Macro 1
		/datum/action/xeno_action/activable/oppressor_punch, // Macro 2
		/datum/action/xeno_action/onclick/crusher_shield, // Macro 3
		/datum/action/xeno_action/onclick/tacmap,
	)
	claw_type = CLAW_TYPE_VERY_SHARP

	tackle_min = 2
	tackle_max = 6

	icon_xeno = 'icons/mob/pathogen/brute.dmi'
	icon_xenonid = 'icons/mob/pathogen/brute.dmi'
	//need_weeds = FALSE

	weed_food_icon = 'icons/mob/xenos/weeds_64x64.dmi'
	mycelium_food_icon = 'icons/mob/pathogen/pathogen_weeds_64x64.dmi'
	weed_food_states = list("Brute_1","Brute_2","Brute_3")
	weed_food_states_flipped = list("Brute_1","Brute_2","Brute_3")

	AUTOWIKI_SKIP(TRUE)
	hivenumber = XENO_HIVE_PATHOGEN
	speaking_noise = "pathogen_talk"

	mob_size = MOB_SIZE_BIG
	acid_blood_damage = 0
	bubble_icon = "pathogenroyal"
	aura_strength = 3

/mob/living/carbon/xenomorph/brute/Initialize()
	. = ..()
	make_pathogen_speaker()
	AddComponent(/datum/component/footstep, 4, 25, 11, 2, "alien_footstep_medium")

/datum/action/xeno_action/activable/tail_stab/pathogen_t3/brute
	name = "Arm Whack"
	blunt_stab = TRUE
	stab_range = 2

/datum/action/xeno_action/onclick/crusher_stomp/pathogen_brute
	ability_primacy = XENO_PRIMARY_ACTION_1


/datum/behavior_delegate/pathogen_base/brute
	name = "Base Brute Behavior Delegate"

	var/aoe_slash_damage_reduction = 0.50

/datum/behavior_delegate/pathogen_base/brute/melee_attack_additional_effects_target(mob/living/carbon/target)

	if (!isxeno_human(target))
		return

	new /datum/effects/xeno_slow(target, bound_xeno, 2 SECONDS)

	var/damage = bound_xeno.melee_damage_upper * aoe_slash_damage_reduction

	var/base_cdr_amount = 1.5 SECONDS
	var/cdr_amount = base_cdr_amount
	for (var/mob/living/carbon/aoe_targets in orange(1, target))
		if (aoe_targets.stat == DEAD)
			continue

		if(!isxeno_human(aoe_targets) || bound_xeno.can_not_harm(aoe_targets))
			continue

		if (HAS_TRAIT(aoe_targets, TRAIT_NESTED))
			continue

		cdr_amount += 0.5 SECONDS

		to_chat(aoe_targets, SPAN_XENODANGER("[bound_xeno] slashes [aoe_targets]!"))
		to_chat(bound_xeno, SPAN_XENODANGER("We slash [aoe_targets]!"))

		bound_xeno.flick_attack_overlay(aoe_targets, "slash")

		aoe_targets.last_damage_data = create_cause_data(initial(bound_xeno.name), bound_xeno)
		//Logging, including anti-rulebreak logging
		if(aoe_targets.status_flags & XENO_HOST && aoe_targets.stat != DEAD)
			//Host might be rogue, needs further investigation
			aoe_targets.attack_log += text("\[[time_stamp()]\] <font color='orange'>was slashed by [key_name(bound_xeno)] while they were infected</font>")
			bound_xeno.attack_log += text("\[[time_stamp()]\] <font color='red'>slashed [key_name(aoe_targets)] while they were infected</font>")
		else
			aoe_targets.attack_log += text("\[[time_stamp()]\] <font color='orange'>was slashed by [key_name(bound_xeno)]</font>")
			bound_xeno.attack_log += text("\[[time_stamp()]\] <font color='red'>slashed [key_name(aoe_targets)]</font>")
		log_attack("[key_name(bound_xeno)] slashed [key_name(aoe_targets)]")
		aoe_targets.apply_armoured_damage(get_xeno_damage_slash(aoe_targets, damage), ARMOR_MELEE, BRUTE, bound_xeno.zone_selected)

	var/datum/action/xeno_action/onclick/crusher_shield/sAction = get_action(bound_xeno, /datum/action/xeno_action/onclick/crusher_shield)
	if (!sAction.action_cooldown_check())
		sAction.reduce_cooldown(base_cdr_amount)

/datum/behavior_delegate/pathogen_base/brute/append_to_stat()
	. = list()
	var/shield_total = 0
	for (var/datum/xeno_shield/XS in bound_xeno.xeno_shields)
		if (XS.shield_source == XENO_SHIELD_SOURCE_CRUSHER)
			shield_total += XS.amount

	. += "Personal Shield: [shield_total]"

	var/datum/hive_status/pathogen/hive = GLOB.hive_datum[XENO_HIVE_PATHOGEN]
	if(hive)
		. += "Pathogen Poppers: [hive.get_popper_num()]/[hive.max_poppers]"
