/datum/caste_datum/pathogen/blight
	caste_type = PATHOGEN_CREATURE_BLIGHT
	tier = 2

	melee_damage_lower = XENO_DAMAGE_TIER_4
	melee_damage_upper = XENO_DAMAGE_TIER_4
	melee_vehicle_damage = XENO_DAMAGE_TIER_4
	max_health = XENO_HEALTH_TIER_10
	plasma_gain = XENO_PLASMA_GAIN_TIER_8
	plasma_max = XENO_PLASMA_TIER_6
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_2
	armor_deflection = XENO_ARMOR_TIER_1
	evasion = XENO_EVASION_LOW
	speed = XENO_SPEED_TIER_8

	attack_delay = 1.7

	available_strains = list()
	behavior_delegate_type = /datum/behavior_delegate/pathogen_base/blight

	deevolves_to = list(PATHOGEN_CREATURE_SPRINTER)
	caste_desc = "A fast, powerful combatant."
	evolves_to = list(PATHOGEN_CREATURE_VENATOR)

	heal_resting = 1.5

	minimap_icon = "blight"

/mob/living/carbon/xenomorph/blight
	caste_type = PATHOGEN_CREATURE_BLIGHT
	name = PATHOGEN_CREATURE_BLIGHT
	desc = "A sleek and stealthy hunter, always watching."
	icon_size = 48
	icon_state = "Blight Walking"
	plasma_types = list()
	pixel_x = -12
	old_x = -12
	tier = 2
	organ_value = 10000
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/onclick/plant_weeds/pathogen,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/onclick/lurker_invisibility/blight, // Macro 1
		/datum/action/xeno_action/activable/pounce/lurker, // Macro 2
		/datum/action/xeno_action/onclick/blight_slash,
		/datum/action/xeno_action/onclick/tacmap,
	)
	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/vent_crawl,
	)
	claw_type = CLAW_TYPE_SHARP

	tackle_min = 2
	tackle_max = 6

	icon_xeno = 'icons/mob/pathogen/blight.dmi'
	icon_xenonid = 'icons/mob/pathogen/blight.dmi'
	//need_weeds = FALSE

	weed_food_icon = 'icons/mob/xenos/weeds_48x48.dmi'
	mycelium_food_icon = 'icons/mob/pathogen/pathogen_weeds_48x48.dmi'
	weed_food_states = list("Blight_1","Blight_2","Blight_3")
	weed_food_states_flipped = list("Blight_1","Blight_2","Blight_3")

	AUTOWIKI_SKIP(TRUE)
	hivenumber = XENO_HIVE_PATHOGEN
	speaking_noise = "pathogen_talk"
	acid_blood_damage = 0
	bubble_icon = "pathogen"

/datum/behavior_delegate/pathogen_base/blight
	name = "Base Blight Behavior Delegate"

	// Config
	var/invis_recharge_time = 20 SECONDS
	var/invis_start_time = -1 // Special value for when we're not invisible
	var/invis_duration = 30 SECONDS // so we can display how long the lurker is invisible to it

/datum/behavior_delegate/pathogen_base/blight/melee_attack_additional_effects_self()
	..()

	var/datum/action/xeno_action/onclick/lurker_invisibility/lurker_invis_action = get_action(bound_xeno, /datum/action/xeno_action/onclick/lurker_invisibility)
	if (lurker_invis_action)
		lurker_invis_action.invisibility_off() // Full cooldown

/datum/behavior_delegate/pathogen_base/blight/proc/decloak_handler(mob/source)
	SIGNAL_HANDLER
	var/datum/action/xeno_action/onclick/lurker_invisibility/lurker_invis_action = get_action(bound_xeno, /datum/action/xeno_action/onclick/lurker_invisibility)
	if(istype(lurker_invis_action))
		lurker_invis_action.invisibility_off(0.5) // Partial refund of remaining time

/// Implementation for enabling invisibility.
/datum/behavior_delegate/pathogen_base/blight/proc/on_invisibility()
	var/datum/action/xeno_action/activable/pounce/lurker/lurker_pounce_action = get_action(bound_xeno, /datum/action/xeno_action/activable/pounce/lurker)
	if(lurker_pounce_action)
		lurker_pounce_action.knockdown = TRUE // pounce knocks down
		lurker_pounce_action.freeze_self = TRUE
	ADD_TRAIT(bound_xeno, TRAIT_CLOAKED, TRAIT_SOURCE_ABILITY("cloak"))
	RegisterSignal(bound_xeno, COMSIG_MOB_EFFECT_CLOAK_CANCEL, PROC_REF(decloak_handler))
	bound_xeno.stealth = TRUE
	invis_start_time = world.time

/// Implementation for disabling invisibility.
/datum/behavior_delegate/pathogen_base/blight/proc/on_invisibility_off()
	var/datum/action/xeno_action/activable/pounce/lurker/lurker_pounce_action = get_action(bound_xeno, /datum/action/xeno_action/activable/pounce/lurker)
	if(lurker_pounce_action)
		lurker_pounce_action.knockdown = FALSE // pounce no longer knocks down
		lurker_pounce_action.freeze_self = FALSE
	bound_xeno.stealth = FALSE
	REMOVE_TRAIT(bound_xeno, TRAIT_CLOAKED, TRAIT_SOURCE_ABILITY("cloak"))
	UnregisterSignal(bound_xeno, COMSIG_MOB_EFFECT_CLOAK_CANCEL)
	invis_start_time = -1

/datum/behavior_delegate/pathogen_base/blight/append_to_stat()
	. = list()

	// Invisible
	if(invis_start_time != -1)
		var/time_left = (invis_duration-(world.time - invis_start_time)) / 10
		. += "Invisibility Remaining: [time_left] second\s."
		return

	var/datum/action/xeno_action/onclick/lurker_invisibility/lurker_invisibility_action = get_action(bound_xeno, /datum/action/xeno_action/onclick/lurker_invisibility)
	if(!lurker_invisibility_action)
		return

	if(!bound_xeno.client?.prefs.show_cooldown_messages)
		return

	// Recharged
	if(lurker_invisibility_action.cooldown_timer_id == TIMER_ID_NULL)
		. += "Invisibility Recharge: Ready."
		return

	// Recharging
	var/time_left = timeleft(lurker_invisibility_action.cooldown_timer_id) / 10
	. += "Invisibility Recharge: [time_left] second\s."

	var/datum/hive_status/pathogen/hive = GLOB.hive_datum[XENO_HIVE_PATHOGEN]
	if(hive)
		. += "Pathogen Poppers: [hive.get_popper_num()]/[hive.max_poppers]"

/datum/behavior_delegate/pathogen_base/blight/on_collide(atom/movable/movable_atom)
	. = ..()

	if(!ishuman(movable_atom))
		return

	if(!bound_xeno || !bound_xeno.stealth)
		return

	var/datum/action/xeno_action/onclick/lurker_invisibility/lurker_invisibility_action = get_action(bound_xeno, /datum/action/xeno_action/onclick/lurker_invisibility)
	if(!lurker_invisibility_action)
		return

	var/mob/living/carbon/human/bumped_into = movable_atom
	if(HAS_TRAIT(bumped_into, TRAIT_CLOAKED)) //ignore invisible scouts and preds
		return

	to_chat(bound_xeno, SPAN_XENOHIGHDANGER("We bumped into someone and lost our invisibility!"))
	lurker_invisibility_action.invisibility_off(0.5) // partial refund of remaining time


/datum/action/xeno_action/onclick/lurker_invisibility/blight/invisibility_off(refund_multiplier = 0.0)
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!istype(xeno))
		return
	if(owner.alpha == initial(owner.alpha) && !xeno.stealth)
		return

	if(invis_timer_id != TIMER_ID_NULL)
		deltimer(invis_timer_id)
		invis_timer_id = TIMER_ID_NULL

	animate(xeno, alpha = initial(xeno.alpha), time = 0.1 SECONDS, easing = QUAD_EASING)
	to_chat(xeno, SPAN_XENOHIGHDANGER("We feel our invisibility end!"))

	button.icon_state = "template"
	xeno.update_icons()

	xeno.speed_modifier += speed_buff
	xeno.recalculate_speed()

	var/datum/behavior_delegate/pathogen_base/blight/behavior = xeno.behavior_delegate
	if(!istype(behavior))
		CRASH("blight behavior_delegate missing/invalid for [xeno]!")

	var/recharge_time = behavior.invis_recharge_time
	if(behavior.invis_start_time > 0) // Sanity
		refund_multiplier = clamp(refund_multiplier, 0, 1)
		var/remaining = 1 - (world.time - behavior.invis_start_time) / behavior.invis_duration
		recharge_time = behavior.invis_recharge_time - remaining * refund_multiplier * behavior.invis_recharge_time
	apply_cooldown_override(recharge_time)

	behavior.on_invisibility_off()
