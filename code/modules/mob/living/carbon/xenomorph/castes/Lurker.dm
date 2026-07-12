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
	xenonid_pixel_x = -9
	tier = 2
	organ_value = 2000
	base_actions = list(
		/datum/action/xeno_action/onclick/toggle_seethrough,
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/release_haul,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/pounce/lurker,
		/datum/action/xeno_action/onclick/lurker_invisibility,
		/datum/action/xeno_action/onclick/lurker_assassinate,
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

	skull = /obj/item/skull/lurker
	pelt = /obj/item/pelt/lurker

/datum/behavior_delegate/lurker_base
	name = "Base Lurker Behavior Delegate"

/datum/behavior_delegate/lurker_base/melee_attack_modify_damage(original_damage, mob/living/carbon/target_carbon)
	if(!isxeno_human(target_carbon))
		return original_damage

	if(HAS_TRAIT(bound_xeno, TRAIT_ABILITY_ASSASINATE))
		to_chat(bound_xeno, SPAN_XENOHIGHDANGER("We significantly strengthen our attack, slowing [target_carbon]!"))
		to_chat(target_carbon, SPAN_XENOHIGHDANGER("You feel a sharp pain as [bound_xeno] slashes you, slowing you down!"))
		var/datum/action/xeno_action/onclick/lurker_assassinate/ability = get_action(bound_xeno, /datum/action/xeno_action/onclick/lurker_assassinate)
		original_damage *= ability.buffed_slash_damage_ratio
		target_carbon.set_effect(get_xeno_stun_duration(target_carbon, 3), SUPERSLOW)
		REMOVE_TRAIT(bound_xeno, TRAIT_ABILITY_ASSASINATE, TRAIT_SOURCE_ABILITY("assasinate"))
		if(ability)
			ability.button.icon_state = "template_xeno"

	return original_damage

/datum/behavior_delegate/lurker_base/override_intent(mob/living/carbon/target_carbon)
	. = ..()

	if(!isxeno_human(target_carbon))
		return

	if(HAS_TRAIT(bound_xeno, TRAIT_ABILITY_ASSASINATE) && target_carbon)
		return INTENT_HARM

/datum/behavior_delegate/lurker_base/melee_attack_additional_effects_target(mob/living/carbon/target_carbon)
	if(!isxeno_human(target_carbon))
		return

	var/datum/action/xeno_action/onclick/lurker_assassinate/lurker_ass = get_action(bound_xeno, /datum/action/xeno_action/onclick/lurker_assassinate)
	if(!lurker_ass)
		return

	if(HAS_TRAIT(target_carbon, TRAIT_FLOORED))
		new /datum/effects/xeno_slow(target_carbon, bound_xeno, null, null, get_xeno_stun_duration(target_carbon, lurker_ass.slash_slow_duration))

	return

/datum/behavior_delegate/lurker_base/melee_attack_additional_effects_self()
	..()

	var/datum/action/xeno_action/onclick/lurker_invisibility/lurker_invis_action = get_action(bound_xeno, /datum/action/xeno_action/onclick/lurker_invisibility)
	if(lurker_invis_action)
		lurker_invis_action.invisibility_off() // Full cooldown

/datum/behavior_delegate/lurker_base/append_to_stat()
	. = list()

	var/datum/action/xeno_action/onclick/lurker_invisibility/lurker_inv = get_action(bound_xeno, /datum/action/xeno_action/onclick/lurker_invisibility)

	// Invisible
	if(lurker_inv.invis_start_time != -1)
		var/time_left = (lurker_inv.invis_duration-(world.time - lurker_inv.invis_start_time)) / 10
		. += "Invisibility Remaining: [time_left] second\s."
		return

	if(!lurker_inv)
		return

	if(!bound_xeno.client?.prefs.show_cooldown_messages)
		return

	// Recharged
	if(lurker_inv.cooldown_timer_id == TIMER_ID_NULL)
		. += "Invisibility Recharge: Ready."
		return

	// Recharging
	var/time_left = timeleft(lurker_inv.cooldown_timer_id) / 10
	. += "Invisibility Recharge: [time_left] second\s."


/datum/behavior_delegate/lurker_base/on_collide(atom/movable/movable_atom)
	. = ..()

	if(!ishuman(movable_atom))
		return

	if(!bound_xeno)
		return

	if(!HAS_TRAIT(bound_xeno, TRAIT_ABILITY_INVIS))
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

/datum/action/xeno_action/onclick/lurker_invisibility/use_ability()
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!istype(xeno))
		return

	XENO_ACTION_CHECK_USE_PLASMA(xeno)

	xeno.deselect_timer = world.time + 5 // Half a second to prevent double clicks

	if(HAS_TRAIT(xeno, TRAIT_ABILITY_INVIS))
		invisibility_off(0.9) // Near full refund of remaining time
		return ..()

	button.icon_state = "template_active"

	animate(xeno, alpha = alpha_amount, time = 0.1 SECONDS, easing = QUAD_EASING)

	xeno.speed_modifier -= speed_buff
	xeno.recalculate_speed()

	on_invisibility()

	// if we go off early, this also works fine.
	invis_timer_id = addtimer(CALLBACK(src, PROC_REF(invisibility_off)), invis_duration, TIMER_STOPPABLE)

	return ..()

/// Implementation for enabling invisibility.
/datum/action/xeno_action/onclick/lurker_invisibility/proc/on_invisibility()
	var/mob/living/carbon/xenomorph/xeno = owner
	var/datum/action/xeno_action/activable/pounce/lurker/lurker_pounce_action = get_action(xeno, /datum/action/xeno_action/activable/pounce/lurker)
	if(lurker_pounce_action)
		lurker_pounce_action.knockdown = TRUE // pounce knocks down
		lurker_pounce_action.freeze_self = TRUE
	ADD_TRAIT(xeno, TRAIT_CLOAKED, TRAIT_SOURCE_ABILITY("cloak"))
	ADD_TRAIT(xeno, TRAIT_ABILITY_INVIS, TRAIT_SOURCE_ABILITY("invis"))
	RegisterSignal(xeno, COMSIG_MOB_EFFECT_CLOAK_CANCEL, PROC_REF(decloak_handler))
	invis_start_time = world.time

/// Implementation for disabling invisibility.
/// (refund_multiplier) indicates how much cooldown to refund based on time remaining
/// 0 indicates full cooldown; 0.5 indicates 50% of remaining time is refunded
/datum/action/xeno_action/onclick/lurker_invisibility/proc/invisibility_off(refund_multiplier = 0.0)
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!istype(xeno))
		return

	if(owner.alpha == initial(owner.alpha))
		return

	if(!HAS_TRAIT(xeno, TRAIT_ABILITY_INVIS))
		return

	if(invis_timer_id != TIMER_ID_NULL)
		deltimer(invis_timer_id)
		invis_timer_id = TIMER_ID_NULL

	animate(xeno, alpha = initial(xeno.alpha), time = 0.1 SECONDS, easing = QUAD_EASING)
	to_chat(xeno, SPAN_XENOHIGHDANGER("We feel our invisibility end!"))

	button.icon_state = "template_xeno"

	xeno.speed_modifier += speed_buff
	xeno.recalculate_speed()

	if(invis_start_time > 0) // Sanity
		refund_multiplier = clamp(refund_multiplier, 0, 1)
		var/remaining = 1 - (world.time - invis_start_time) / invis_duration
		invis_recharge_time = invis_recharge_time - remaining * refund_multiplier * invis_recharge_time

	apply_cooldown_override(invis_recharge_time)

	var/datum/action/xeno_action/activable/pounce/lurker/lurker_pounce_action = get_action(xeno, /datum/action/xeno_action/activable/pounce/lurker)
	if(lurker_pounce_action)
		lurker_pounce_action.knockdown = FALSE // pounce no longer knocks down
		lurker_pounce_action.freeze_self = FALSE
	REMOVE_TRAIT(xeno, TRAIT_CLOAKED, TRAIT_SOURCE_ABILITY("cloak"))
	REMOVE_TRAIT(xeno, TRAIT_ABILITY_INVIS, TRAIT_SOURCE_ABILITY("invis"))
	UnregisterSignal(xeno, COMSIG_MOB_EFFECT_CLOAK_CANCEL)
	invis_start_time = -1

/datum/action/xeno_action/onclick/lurker_invisibility/proc/decloak_handler()
	SIGNAL_HANDLER
	invisibility_off(0.5) // Partial refund of remaining time

/datum/action/xeno_action/onclick/lurker_invisibility/ability_cooldown_over()
	if(owner.client?.prefs.show_cooldown_messages)
		to_chat(owner, SPAN_XENOHIGHDANGER("We are ready to use our invisibility again!"))
	..()

/datum/action/xeno_action/onclick/lurker_assassinate/use_ability()
	var/mob/living/carbon/xenomorph/xeno = owner

	if(!istype(xeno))
		return

	XENO_ACTION_CHECK_USE_PLASMA(xeno)

	ADD_TRAIT(xeno, TRAIT_ABILITY_ASSASINATE, TRAIT_SOURCE_ABILITY("assasinate"))

	to_chat(xeno, SPAN_XENOHIGHDANGER("Our next slash will deal increased damage!"))

	addtimer(CALLBACK(src, PROC_REF(unbuff_slash)), buff_duration)
	xeno.next_move = world.time + 1 // Autoattack reset

	apply_cooldown()
	return ..()

/datum/action/xeno_action/onclick/lurker_assassinate/proc/unbuff_slash()
	var/mob/living/carbon/xenomorph/xeno = owner
	if(!istype(xeno))
		return

	if(!HAS_TRAIT(xeno, TRAIT_ABILITY_ASSASINATE))
		return
	REMOVE_TRAIT(xeno, TRAIT_ABILITY_ASSASINATE, TRAIT_SOURCE_ABILITY("assasinate"))

	to_chat(xeno, SPAN_XENODANGER("We have waited too long, our slash will no longer deal increased damage!"))
