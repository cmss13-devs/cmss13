/datum/caste_datum/reaper
	caste_type = XENO_CASTE_REAPER
	caste_desc = "The harvester of hosts."
	tier = 3

	melee_damage_lower = XENO_DAMAGE_TIER_4
	melee_damage_upper = XENO_DAMAGE_TIER_4
	melee_vehicle_damage = XENO_DAMAGE_TIER_8
	max_health = XENO_HEALTH_TIER_8
	plasma_gain = XENO_PLASMA_GAIN_TIER_6
	plasma_max = XENO_PLASMA_TIER_4
	crystal_max = XENO_CRYSTAL_LOW
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_4
	armor_deflection = XENO_ARMOR_TIER_3
	evasion = XENO_EVASION_LOW
	speed = XENO_SPEED_TIER_4

	evolution_allowed = FALSE
	deevolves_to = list(XENO_CASTE_CARRIER)
	throwspeed = SPEED_AVERAGE
	can_hold_eggs = CAN_HOLD_ONE_HAND
	weed_level = WEED_LEVEL_STANDARD

	behavior_delegate_type = /datum/behavior_delegate/base_reaper

	tackle_min = 2
	tackle_max = 4
	tackle_chance = 50
	tacklestrength_min = 4
	tacklestrength_max = 5

	aura_strength = 2


/mob/living/carbon/Xenomorph/Reaper
	caste_type = XENO_CASTE_REAPER
	name = XENO_CASTE_REAPER
	desc = "A horrifying mockery of the human form, this beast has several claws to skewer its foes with."
	icon_size = 64
	icon_xeno = 'icons/mob/xenos/reaper.dmi'
	icon_state = "Reaper Walking"
	plasma_types = list(PLASMA_PURPLE, PLASMA_EGG)

	drag_delay = 6 //pulling a big dead xeno is hard

	mob_size = MOB_SIZE_BIG
	tier = 3
	pixel_x = -16 //Needed for 2x2
	old_x = -16

	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab/reaper,
		/datum/action/xeno_action/activable/place_construction,
		/datum/action/xeno_action/onclick/plant_weeds, //1st macro
		/datum/action/xeno_action/onclick/plasma_strike, //2nd macro
		/datum/action/xeno_action/onclick/claw_toss //3rd macro
	)
	mutation_type = REAPER_NORMAL

	icon_xenonid = 'icons/mob/xenonids/reaper.dmi'

	aura_plasma_cost = 0
	current_aura = "all"


/datum/behavior_delegate/base_reaper
	name = "Base Reaper Behavior Delegate"

	var/egg_plasma_primed = FALSE

	var/claw_toss_primed = FALSE
	var/claw_toss_distance = 2

	var/image/egg_plasma_slash_overlay
	var/image/claw_toss_slash_overlay

/datum/behavior_delegate/base_reaper/New()
	..()
	egg_plasma_slash_overlay = image('icons/effects/effects.dmi', null, "anger", layer = FLY_LAYER, "pixel_x" = 16)
	claw_toss_slash_overlay = image('icons/effects/effects.dmi', null, "pain", layer = FLY_LAYER, "pixel_x" = 16)

/datum/behavior_delegate/base_reaper/Destroy(force, ...)
	QDEL_NULL(egg_plasma_slash_overlay)
	QDEL_NULL(claw_toss_slash_overlay)
	return ..()

/datum/behavior_delegate/base_reaper/melee_attack_modify_damage(original_damage, mob/living/carbon/target_carbon)
	if(!isXenoOrHuman(target_carbon))
		return ..()

	if (egg_plasma_primed)
		to_chat(bound_xeno, SPAN_XENOHIGHDANGER("You stab into \the [target_carbon], releasing egg plasma directly into their bloodstream!"))
		to_chat(target_carbon, SPAN_XENOHIGHDANGER("You feel a cold liquid coursing through your veins as [bound_xeno] stabs you!"))
		target_carbon.reagents.add_reagent(PLASMA_EGG, 15, list("hive_number" = bound_xeno.hivenumber))
		target_carbon.reagents.add_reagent(PLASMA_HEMOCATALENE, 20)
		egg_plasma_primed = FALSE
		var/datum/action/xeno_action/onclick/plasma_strike/ability = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/onclick/plasma_strike)
		if(istype(ability))
			ability.button.icon_state = "template"
		remove_egg_plasma_slash_overlay()

	return ..()

/datum/behavior_delegate/base_reaper/melee_attack_additional_effects_target(mob/living/carbon/target_carbon)
	if(!claw_toss_primed || !isXenoOrHuman(target_carbon))
		return ..()

	var/facing = get_dir(bound_xeno, target_carbon)
	var/turf/target_turf = target_carbon.loc
	var/turf/temp = target_carbon.loc

	for(var/x in 0 to claw_toss_distance)
		temp = get_step(target_turf, facing)
		if (!temp)
			break
		target_turf = temp

	target_carbon.apply_effect(5, WEAKEN)
	target_carbon.throw_atom(target_turf, 2, SPEED_VERY_FAST, bound_xeno, TRUE)

	claw_toss_primed = FALSE
	var/datum/action/xeno_action/onclick/claw_toss/ability = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/onclick/claw_toss)
	if(istype(ability))
		ability.button.icon_state = "template"
	remove_claw_toss_slash_overlay()

	return ..()

/datum/behavior_delegate/base_reaper/proc/add_egg_plasma_slash_overlay()
	bound_xeno.xeno_jitter(1 SECONDS)
	bound_xeno.emote("roar")
	bound_xeno.add_filter("egg_plasma_slash", 1, list("type" = "outline", "color" = "#d6331d49", "size" = 1))
	bound_xeno.overlays.Add(egg_plasma_slash_overlay)

/datum/behavior_delegate/base_reaper/proc/remove_egg_plasma_slash_overlay()
	bound_xeno.remove_filter("egg_plasma_slash")
	bound_xeno.overlays.Remove(egg_plasma_slash_overlay)


/datum/behavior_delegate/base_reaper/proc/add_claw_toss_slash_overlay()
	bound_xeno.xeno_jitter(1 SECONDS)
	bound_xeno.emote("roar")
	bound_xeno.add_filter("claw_toss_slash", 1, list("type" = "outline", "color" = "#a33dc546", "size" = 1))
	bound_xeno.overlays.Add(claw_toss_slash_overlay)

/datum/behavior_delegate/base_reaper/proc/remove_claw_toss_slash_overlay()
	bound_xeno.remove_filter("claw_toss_slash")
	bound_xeno.overlays.Remove(claw_toss_slash_overlay)
