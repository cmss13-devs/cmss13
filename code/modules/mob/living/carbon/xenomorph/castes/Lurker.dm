/datum/caste_datum/lurker
	caste_type = XENO_CASTE_LURKER
	tier = 2

	melee_damage_lower = XENO_DAMAGE_TIER_4
	melee_damage_upper = XENO_DAMAGE_TIER_4
	melee_vehicle_damage = XENO_DAMAGE_TIER_4
	max_health = XENO_HEALTH_TIER_5
	plasma_gain = XENO_PLASMA_GAIN_TIER_8
	plasma_max = XENO_PLASMA_TIER_4
	xeno_explosion_resistance = XENO_EXPLOSIVE_ARMOR_TIER_2
	armor_deflection = XENO_NO_ARMOR
	evasion = XENO_EVASION_NONE
	speed = XENO_SPEED_TIER_8

	attack_delay = 2 // VERY high slash damage, but attacks relatively slowly

	available_strains = list(/datum/xeno_strain/vampire)
	behavior_delegate_type = /datum/behavior_delegate/lurker_base

	deevolves_to = list(XENO_CASTE_RUNNER)
	caste_desc = "A fast, powerful backline combatant."
	evolves_to = list(XENO_CASTE_RAVAGER)

	heal_resting = 1.5

	minimum_evolve_time = 9 MINUTES

	minimap_icon = "lurker"

/mob/living/carbon/xenomorph/lurker
	caste_type = XENO_CASTE_LURKER
	name = XENO_CASTE_LURKER
	desc = "A beefy, fast alien with sharp claws."
	icon_size = 48
	icon_state = "Lurker Walking"
	plasma_types = list(PLASMA_CATECHOLAMINE)
	pixel_x = -12
	old_x = -12
	tier = 2
	organ_value = 2000
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/pounce/lurker,
		/datum/action/xeno_action/onclick/lurker_invisibility,
		/datum/action/xeno_action/onclick/lurker_assassinate,
		/datum/action/xeno_action/onclick/tacmap,
	)
	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/vent_crawl,
	)
	claw_type = CLAW_TYPE_SHARP

	tackle_min = 2
	tackle_max = 6

	icon_xeno = 'icons/mob/xenos/castes/tier_2/lurker.dmi'
	icon_xenonid = 'icons/mob/xenonids/castes/tier_2/lurker.dmi'

	weed_food_icon = 'icons/mob/xenos/weeds_48x48.dmi'
	weed_food_states = list("Drone_1","Drone_2","Drone_3")
	weed_food_states_flipped = list("Drone_1","Drone_2","Drone_3")

/datum/behavior_delegate/lurker_base
	name = "Base Lurker Behavior Delegate"

	// Config
	var/invis_recharge_time = 20 SECONDS
	var/invis_start_time = -1 // Special value for when we're not invisible
	var/invis_duration = 30 SECONDS // so we can display how long the lurker is invisible to it
	var/buffed_slash_damage_ratio = 1.2
	var/slash_slow_duration = 35

	// State
	var/next_slash_buffed = FALSE

/datum/behavior_delegate/lurker_base/melee_attack_modify_damage(original_damage, mob/living/carbon/target_carbon)
	if (!isxeno_human(target_carbon))
		return original_damage

	if (next_slash_buffed)
		to_chat(bound_xeno, SPAN_XENOHIGHDANGER("We significantly strengthen our attack, slowing [target_carbon]!"))
		to_chat(target_carbon, SPAN_XENOHIGHDANGER("You feel a sharp pain as [bound_xeno] slashes you, slowing you down!"))
		original_damage *= buffed_slash_damage_ratio
		target_carbon.set_effect(get_xeno_stun_duration(target_carbon, 3), SUPERSLOW)
		next_slash_buffed = FALSE
		var/datum/action/xeno_action/onclick/lurker_assassinate/ability = get_action(bound_xeno, /datum/action/xeno_action/onclick/lurker_assassinate)
		if (ability)
			ability.button.icon_state = "template"

	return original_damage

/datum/behavior_delegate/lurker_base/override_intent(mob/living/carbon/target_carbon)
	. = ..()

	if(!isxeno_human(target_carbon))
		return

	if(next_slash_buffed)
		return INTENT_HARM

/datum/behavior_delegate/lurker_base/melee_attack_additional_effects_target(mob/living/carbon/target_carbon)
	if (!isxeno_human(target_carbon))
		return

	if (HAS_TRAIT(target_carbon, TRAIT_FLOORED))
		new /datum/effects/xeno_slow(target_carbon, bound_xeno, null, null, get_xeno_stun_duration(target_carbon, slash_slow_duration))

	return

/datum/behavior_delegate/lurker_base/melee_attack_additional_effects_self()
	..()

	var/datum/action/xeno_action/onclick/lurker_invisibility/lurker_invis_action = get_action(bound_xeno, /datum/action/xeno_action/onclick/lurker_invisibility)
	if (lurker_invis_action)
		lurker_invis_action.invisibility_off() // Full cooldown

/datum/behavior_delegate/lurker_base/proc/decloak_handler(mob/source)
	SIGNAL_HANDLER
	var/datum/action/xeno_action/onclick/lurker_invisibility/lurker_invis_action = get_action(bound_xeno, /datum/action/xeno_action/onclick/lurker_invisibility)
	if(istype(lurker_invis_action))
		lurker_invis_action.invisibility_off(0.5) // Partial refund of remaining time

/// Implementation for enabling invisibility.
/datum/behavior_delegate/lurker_base/proc/on_invisibility()
	var/datum/action/xeno_action/activable/pounce/lurker/lurker_pounce_action = get_action(bound_xeno, /datum/action/xeno_action/activable/pounce/lurker)
	if(lurker_pounce_action)
		lurker_pounce_action.knockdown = TRUE // pounce knocks down
		lurker_pounce_action.freeze_self = TRUE
	ADD_TRAIT(bound_xeno, TRAIT_CLOAKED, TRAIT_SOURCE_ABILITY("cloak"))
	RegisterSignal(bound_xeno, COMSIG_MOB_EFFECT_CLOAK_CANCEL, PROC_REF(decloak_handler))
	bound_xeno.stealth = TRUE
	invis_start_time = world.time

/// Implementation for disabling invisibility.
/datum/behavior_delegate/lurker_base/proc/on_invisibility_off()
	var/datum/action/xeno_action/activable/pounce/lurker/lurker_pounce_action = get_action(bound_xeno, /datum/action/xeno_action/activable/pounce/lurker)
	if(lurker_pounce_action)
		lurker_pounce_action.knockdown = FALSE // pounce no longer knocks down
		lurker_pounce_action.freeze_self = FALSE
	bound_xeno.stealth = FALSE
	REMOVE_TRAIT(bound_xeno, TRAIT_CLOAKED, TRAIT_SOURCE_ABILITY("cloak"))
	UnregisterSignal(bound_xeno, COMSIG_MOB_EFFECT_CLOAK_CANCEL)
	invis_start_time = -1

/datum/behavior_delegate/lurker_base/append_to_stat()
	. = list()

	// Invisible
	if(invis_start_time != -1)
		var/time_left = (invis_duration-(world.time - invis_start_time)) / 10
		. += "Invisibility Remaining: [time_left] second\s."
		return

	var/datum/action/xeno_action/onclick/lurker_invisibility/lurker_invisibility_action = get_action(bound_xeno, /datum/action/xeno_action/onclick/lurker_invisibility)
	if(!lurker_invisibility_action)
		return

	// Recharged
	if(lurker_invisibility_action.cooldown_timer_id == TIMER_ID_NULL)
		. += "Invisibility Recharge: Ready."
		return

	// Recharging
	var/time_left = timeleft(lurker_invisibility_action.cooldown_timer_id) / 10
	. += "Invisibility Recharge: [time_left] second\s."

/datum/behavior_delegate/lurker_base/on_collide(atom/movable/movable_atom)
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


/datum/action/xeno_action/activable/pounce/lurker/additional_effects(mob/living/living_mob)
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno))
		return

	RegisterSignal(xeno, COMSIG_XENO_SLASH_ADDITIONAL_EFFECTS_SELF, PROC_REF(remove_freeze), TRUE) // Suppresses runtime ever we pounce again before slashing

	var/found = FALSE
	for(var/mob/living/carbon/human/human in get_turf(xeno))
		if(human.stat == DEAD)
			continue
		found = TRUE
		break

	if(found)
		var/datum/action/xeno_action/onclick/lurker_invisibility/lurker_invis = get_action(xeno, /datum/action/xeno_action/onclick/lurker_invisibility)
		if(lurker_invis)
			lurker_invis.invisibility_off() // Full cooldown

/datum/action/xeno_action/activable/pounce/lurker/proc/remove_freeze(mob/living/carbon/xenomorph/xeno)
	SIGNAL_HANDLER

	var/datum/behavior_delegate/lurker_base/behaviour_del = xeno.behavior_delegate
	if(istype(behaviour_del))
		UnregisterSignal(xeno, COMSIG_XENO_SLASH_ADDITIONAL_EFFECTS_SELF)
		end_pounce_freeze()

/datum/action/xeno_action/onclick/lurker_invisibility/can_use_action()
	if(!..())
		return FALSE
	var/mob/living/carbon/xenomorph/xeno = owner
	return xeno.deselect_timer < world.time // We clicked the same ability in a very short time

/datum/action/xeno_action/onclick/lurker_invisibility/use_ability(atom/targeted_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!istype(xeno))
		return
	if(!action_cooldown_check())
		return
	if(!check_and_use_plasma_owner())
		return

	xeno.deselect_timer = world.time + 5 // Half a second to prevent double clicks

	if(xeno.stealth)
		invisibility_off(0.9) // Near full refund of remaining time
		return ..()

	button.icon_state = "template_active"
	xeno.update_icons() // callback to make the icon_state indicate invisibility is in lurker/update_icon

	animate(xeno, alpha = alpha_amount, time = 0.1 SECONDS, easing = QUAD_EASING)

	xeno.speed_modifier -= speed_buff
	xeno.recalculate_speed()

	var/datum/behavior_delegate/lurker_base/behavior = xeno.behavior_delegate
	behavior.on_invisibility()

	// if we go off early, this also works fine.
	invis_timer_id = addtimer(CALLBACK(src, PROC_REF(invisibility_off)), duration, TIMER_STOPPABLE)

	return ..()

/// Implementation for disabling invisibility.
/// (refund_multiplier) indicates how much cooldown to refund based on time remaining
/// 0 indicates full cooldown; 0.5 indicates 50% of remaining time is refunded
/datum/action/xeno_action/onclick/lurker_invisibility/proc/invisibility_off(refund_multiplier = 0.0)
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

	var/datum/behavior_delegate/lurker_base/behavior = xeno.behavior_delegate
	if(!istype(behavior))
		CRASH("lurker_base behavior_delegate missing/invalid for [xeno]!")

	var/recharge_time = behavior.invis_recharge_time
	if(behavior.invis_start_time > 0) // Sanity
		refund_multiplier = clamp(refund_multiplier, 0, 1)
		var/remaining = 1 - (world.time - behavior.invis_start_time) / behavior.invis_duration
		recharge_time = behavior.invis_recharge_time - remaining * refund_multiplier * behavior.invis_recharge_time
	apply_cooldown_override(recharge_time)

	behavior.on_invisibility_off()

/datum/action/xeno_action/onclick/lurker_invisibility/ability_cooldown_over()
	to_chat(owner, SPAN_XENOHIGHDANGER("We are ready to use our invisibility again!"))
	..()

/datum/action/xeno_action/onclick/lurker_assassinate/use_ability(atom/targeted_atom)
	var/mob/living/carbon/xenomorph/xeno = owner

	if (!istype(xeno))
		return

	if (!action_cooldown_check())
		return

	if (!check_and_use_plasma_owner())
		return

	var/datum/behavior_delegate/lurker_base/behavior = xeno.behavior_delegate
	if (istype(behavior))
		behavior.next_slash_buffed = TRUE

	to_chat(xeno, SPAN_XENOHIGHDANGER("Our next slash will deal increased damage!"))

	addtimer(CALLBACK(src, PROC_REF(unbuff_slash)), buff_duration)
	xeno.next_move = world.time + 1 // Autoattack reset

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/lurker_assassinate/proc/unbuff_slash()
	var/mob/living/carbon/xenomorph/xeno = owner
	if (!istype(xeno))
		return
	var/datum/behavior_delegate/lurker_base/behavior = xeno.behavior_delegate
	if (istype(behavior))
		// In case slash has already landed
		if (!behavior.next_slash_buffed)
			return
		behavior.next_slash_buffed = FALSE

	to_chat(xeno, SPAN_XENODANGER("We have waited too long, our slash will no longer deal increased damage!"))
