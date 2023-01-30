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

	behavior_delegate_type = /datum/behavior_delegate/lurker_base

	deevolves_to = list(XENO_CASTE_RUNNER)
	caste_desc = "A fast, powerful backline combatant."
	evolves_to = list(XENO_CASTE_RAVAGER)

	heal_resting = 1.5

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
	base_actions = list(
		/datum/action/xeno_action/onclick/xeno_resting,
		/datum/action/xeno_action/onclick/regurgitate,
		/datum/action/xeno_action/watch_xeno,
		/datum/action/xeno_action/activable/tail_stab,
		/datum/action/xeno_action/activable/pounce/lurker,
		/datum/action/xeno_action/onclick/lurker_invisibility,
		/datum/action/xeno_action/onclick/lurker_assassinate,
		)
	inherent_verbs = list(
		/mob/living/carbon/xenomorph/proc/vent_crawl,
		)
	mutation_type = LURKER_NORMAL
	claw_type = CLAW_TYPE_SHARP

	tackle_min = 2
	tackle_max = 6

	icon_xeno = 'icons/mob/xenos/lurker.dmi'
	icon_xenonid = 'icons/mob/xenonids/lurker.dmi'

/datum/behavior_delegate/lurker_base
	name = "Base Lurker Behavior Delegate"

	// Config
	var/buffed_slash_damage_ratio = 1.2
	var/slash_slow_duration = 35

	// State
	var/next_slash_buffed = FALSE

/datum/behavior_delegate/lurker_base/melee_attack_modify_damage(original_damage, mob/living/carbon/target_carbon)
	if (!isxeno_human(target_carbon))
		return original_damage

	if (next_slash_buffed)
		to_chat(bound_xeno, SPAN_XENOHIGHDANGER("You significantly strengthen your attack, slowing [target_carbon]!"))
		to_chat(target_carbon, SPAN_XENOHIGHDANGER("You feel a sharp pain as [bound_xeno] slashes you, slowing you down!"))
		original_damage *= buffed_slash_damage_ratio
		target_carbon.set_effect(get_xeno_stun_duration(target_carbon, 3), SUPERSLOW)
		new /datum/effects/xeno_slow(target_carbon, bound_xeno, null, null, get_xeno_stun_duration(target_carbon, slash_slow_duration))
		next_slash_buffed = FALSE
		var/datum/action/xeno_action/onclick/lurker_assassinate/ability = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/onclick/lurker_assassinate)
		if (ability)
			ability.button.icon_state = "template"

	return original_damage

/datum/behavior_delegate/lurker_base/melee_attack_additional_effects_self()
	..()

	var/datum/action/xeno_action/onclick/lurker_invisibility/invisibility_action = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/onclick/lurker_invisibility)
	if (invisibility_action)
		invisibility_action.invisibility_off()


/datum/behavior_delegate/lurker_base/post_ability_cast(datum/action/xeno_action/ability, result)
	..()
	if(istype(ability, /datum/action/xeno_action/onclick/lurker_assassinate) && result)
		//result is the duration of the slash buff
		next_slash_buffed = TRUE
		to_chat(bound_xeno, SPAN_XENOHIGHDANGER("Your next slash will deal increased damage!"))
		addtimer(CALLBACK(src, PROC_REF(nerf_slash)), result)

/datum/behavior_delegate/lurker_base/append_to_stat()
	. = list()
	var/datum/action/xeno_action/onclick/lurker_invisibility/invisibility_action = get_xeno_action_by_type(bound_xeno, /datum/action/xeno_action/onclick/lurker_invisibility)
	if(invisibility_action && bound_xeno.stealth)
		var/invis_message = "[COOLDOWN_SECONDSLEFT(invisibility_action, invisibility_start)] seconds."
		. += "Invisibility Time Left: [invis_message]"

/datum/behavior_delegate/lurker_base/proc/nerf_slash()
	next_slash_buffed = FALSE
	to_chat(bound_xeno, SPAN_XENODANGER("You have waited too long, your slash will no longer deal increased damage!"))
